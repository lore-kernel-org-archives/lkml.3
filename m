Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756814Ab3AQPfs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 10:35:48 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:31997 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756558Ab3AQPfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 10:35:47 -0500
X-Authority-Analysis: v=2.0 cv=O9a7TWBW c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=RAYXirgi3N4A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=iAK3kXgEXMMA:10 a=9tU1zQue3W_4dtgYghAA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1358436945.23211.10.camel@gandalf.local.home>
Subject: Re: [PATCH V2] mips: function tracer: Fix broken function tracing
From: Steven Rostedt <rostedt@goodmis.org>
To: Alan Cooper <alcooperx@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, ddaney.cavm@gmail.com,
        ralf@linux-mips.org, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Date: Thu, 17 Jan 2013 10:35:45 -0500
In-Reply-To: <CAOGqxeWNfknkq2Kad2sTWh9f9C8HpghdNBimsB9HFs8ze=LHHQ@mail.gmail.com>
References: <1358379808-16449-1-git-send-email-alcooperx@gmail.com>
	 <CAMuHMdUSRM6dauiRtSs20YVfHmNrROrc4RpZL+dKA_e2t82J6A@mail.gmail.com>
	 <CAOGqxeWNfknkq2Kad2sTWh9f9C8HpghdNBimsB9HFs8ze=LHHQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-01-17 at 09:58 -0500, Alan Cooper wrote:
> When the kernel first boots we have to be able to handle the gcc
> generated jalr, addui sequence until ftrace_init gets a chance to run
> and change the sequence. At this point mcount just adjusts the stack
> and returns. When ftrace_init runs, we convert the jalr/addui to nops.
> Then whenever tracing is enabled we convert the first nop to a "jalr
> mcount+8". The mcount+8 entry point skips the stack adjust.
> 

I was confused by that too.

> 
> On Thu, Jan 17, 2013 at 1:27 AM, Geert Uytterhoeven

> >
> >> @@ -69,7 +68,7 @@ NESTED(ftrace_caller, PT_SIZE, ra)
> >>         .globl _mcount
> >>  _mcount:
> >>         b       ftrace_stub
> >> -        nop
> >> +       addiu sp,sp,8

Can you add a comment here:

	/* When tracing is activated, it calls ftrace_caller+8 (aka here) */

> >>         lw      t1, function_trace_stop
> >>         bnez    t1, ftrace_stub
> >>         nop
> >

-- Steve


