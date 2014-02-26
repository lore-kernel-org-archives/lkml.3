Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751439AbaBZBoV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 20:44:21 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:33100 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917AbaBZBoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 20:44:19 -0500
Message-ID: <530D46EF.6010103@converseincode.com>
Date: Tue, 25 Feb 2014 17:44:15 -0800
From: Behan Webster <behanw@converseincode.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, mmarek@suse.cz, tglx@linutronix.de,
        mingo@redhat.com, x86@kernel.org, sparse@chrisli.org
CC: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sparse@vger.kernel.org, torvalds@linux-foundation.org,
        dwmw2@infradead.org, pageexec@freemail.hu,
        =?UTF-8?B?SmFuLVNpbW9uIE3Dtmxs?= =?UTF-8?B?ZXI=?= <dl9pf@gmx.de>,
        Mark Charlebois <charlebm@gmail.com>
Subject: Re: [PATCH 5/5] x86 kbuild: LLVMLinux: More cc-options added for
 clang
References: <1393376923-21892-1-git-send-email-behanw@converseincode.com> <1393376923-21892-6-git-send-email-behanw@converseincode.com> <530D4445.8060304@zytor.com>
In-Reply-To: <530D4445.8060304@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/25/14 17:32, H. Peter Anvin wrote:
> On 02/25/2014 05:08 PM, behanw@converseincode.com wrote:
>>   
>> +# enforce no-sse for clang
>> +ifneq ($(COMPILER),clang)
>> +        KBUILD_CFLAGS += $(call cc-option,-mno-sse)
>> +        KBUILD_CFLAGS += $(call cc-option,-mpreferred-stack-boundary=3)
>> +endif
>> +
> I'm *very* confused.  You're doing ifneq here but you're talking about
> it as if you are *adding* them for Clang, also these options are already
> added elsewhere (lines 57, 64, 86, 89) so why add them here?
Because when David Woodhouse's recent .code16 changes made it upstream 
(which invalidated most of our original patch) it seems I didn't remove 
this properly from our patch as well. :)

Thanks David for your patches. Thanks Peter for your sharp eyes!

Another example of why reviewing code on the mailing list works so well.

I will fix and resend.

Behan

-- 
Behan Webster
behanw@converseincode.com

