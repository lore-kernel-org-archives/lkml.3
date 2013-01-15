Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756270Ab3AOVe4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 16:34:56 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:52912 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280Ab3AOVez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 16:34:55 -0500
Message-ID: <50F5CB78.20800@gmail.com>
Date: Tue, 15 Jan 2013 13:34:48 -0800
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Al Cooper <alcooperx@gmail.com>, ralf@linux-mips.org,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mips: function tracer: Fix broken function tracing
References: <y> <1357914810-20656-1-git-send-email-alcooperx@gmail.com>  <50F0454D.5060109@gmail.com> <20130115034006.GA3854@home.goodmis.org>  <50F59812.6040806@gmail.com> <1358284049.4068.21.camel@gandalf.local.home>
In-Reply-To: <1358284049.4068.21.camel@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/2013 01:07 PM, Steven Rostedt wrote:
> On Tue, 2013-01-15 at 09:55 -0800, David Daney wrote:
>
>>> There's nothing that states what the ftrace caller must be. We can have
>>> it do a proper stack update. That is, only at boot up do we need to
>>> handle the defined mcount. After that, those instructions are just place
>>> holders for our own algorithms. If the addiu was needed for the defined
>>> mcount, there's no reason to keep it for our own ftrace_caller.
>>>
>>> Would that work?
>>
>> ... either do as you suggest and dynamically change the ABI of the
>> target function.
>
> We already change the ABI. We have it call ftrace_caller instead of
> mcount.
>
> BTW, I've just compiled with gcc 4.6.3 against mips, and I don't see the
> issue. I have:
>
> 0000000000000000 <account_kernel_stack>:
>         0:       03e0082d        move    at,ra
>         4:       0c000000        jal     0 <account_kernel_stack>
>                          4: R_MIPS_26    _mcount
>                          4: R_MIPS_NONE  *ABS*
>                          4: R_MIPS_NONE  *ABS*
>         8:       0000602d        move    t0,zero
>         c:       2402000d        li      v0,13
>        10:       3c030000        lui     v1,0x0
>                          10: R_MIPS_HI16 mem_section
>                          10: R_MIPS_NONE *ABS*
>                          10: R_MIPS_NONE *ABS*
>        14:       000216fc        dsll32  v0,v0,0x1b
>        18:       64630000        daddiu  v1,v1,0
>
> Is it dependent on the config?

Yes.

You need to select a 32-bit kernel (which in turn may require selecting 
a board type that also supports it).

The ABI is different for 32-bit and 64-bit _mcount.

David Daney


>
>>
>> Or add support to GCC for a better tracing ABI (as I already said we did
>> for mips64).
>
> I wouldn't waste time changing gcc for this. If you're going to change
> gcc than please implement the -mfentry option. Look at x86_64 to
> understand this more.

A good point.  But I don't really plan on doing any work related to 
32-bit mips things at this point, so any such change would have to be 
done by someone else.

David Daney

