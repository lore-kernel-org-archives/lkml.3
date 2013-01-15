Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757264Ab3AOVHh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 16:07:37 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:24615 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757149Ab3AOVHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 16:07:32 -0500
X-Authority-Analysis: v=2.0 cv=e+OEuNV/ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=79wlbEtt-9EA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=pX4miy-IAAsA:10 a=2Jtw9-WZmrLkOvoCA9IA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1358284049.4068.21.camel@gandalf.local.home>
Subject: Re: [PATCH] mips: function tracer: Fix broken function tracing
From: Steven Rostedt <rostedt@goodmis.org>
To: David Daney <ddaney.cavm@gmail.com>
Cc: Al Cooper <alcooperx@gmail.com>, ralf@linux-mips.org,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Date: Tue, 15 Jan 2013 16:07:29 -0500
In-Reply-To: <50F59812.6040806@gmail.com>
References: <y> <1357914810-20656-1-git-send-email-alcooperx@gmail.com>
	 <50F0454D.5060109@gmail.com> <20130115034006.GA3854@home.goodmis.org>
	 <50F59812.6040806@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-01-15 at 09:55 -0800, David Daney wrote:

> > There's nothing that states what the ftrace caller must be. We can have
> > it do a proper stack update. That is, only at boot up do we need to
> > handle the defined mcount. After that, those instructions are just place
> > holders for our own algorithms. If the addiu was needed for the defined
> > mcount, there's no reason to keep it for our own ftrace_caller.
> >
> > Would that work?
> 
> ... either do as you suggest and dynamically change the ABI of the 
> target function.

We already change the ABI. We have it call ftrace_caller instead of
mcount.

BTW, I've just compiled with gcc 4.6.3 against mips, and I don't see the
issue. I have:

0000000000000000 <account_kernel_stack>:
       0:       03e0082d        move    at,ra
       4:       0c000000        jal     0 <account_kernel_stack>
                        4: R_MIPS_26    _mcount
                        4: R_MIPS_NONE  *ABS*
                        4: R_MIPS_NONE  *ABS*
       8:       0000602d        move    t0,zero
       c:       2402000d        li      v0,13
      10:       3c030000        lui     v1,0x0
                        10: R_MIPS_HI16 mem_section
                        10: R_MIPS_NONE *ABS*
                        10: R_MIPS_NONE *ABS*
      14:       000216fc        dsll32  v0,v0,0x1b
      18:       64630000        daddiu  v1,v1,0

Is it dependent on the config?

> 
> Or add support to GCC for a better tracing ABI (as I already said we did 
> for mips64).

I wouldn't waste time changing gcc for this. If you're going to change
gcc than please implement the -mfentry option. Look at x86_64 to
understand this more.

-- Steve


