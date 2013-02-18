Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856Ab3BRPVT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 10:21:19 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:6318 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753648Ab3BRPVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 10:21:18 -0500
X-Authority-Analysis: v=2.0 cv=It2cgcDg c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=dna11aX-Ae4A:10 a=3yHeP7xUt7HX8vnJXM8A:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1361200876.23152.149.camel@gandalf.local.home>
Subject: Re: prctl(PR_SET_MM)
From: Steven Rostedt <rostedt@goodmis.org>
To: u3557@dialix.com.au
Cc: Oleg Nesterov <oleg@redhat.com>, Pedro Alves <palves@redhat.com>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Date: Mon, 18 Feb 2013 10:21:16 -0500
In-Reply-To: <20130218013954.28FCF59206F@miso.sublimeip.com>
References: <20130218013954.28FCF59206F@miso.sublimeip.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-02-18 at 12:39 +1100, Amnon Shiloh wrote:
> Hello,
> 
> The code in "kernel/sys.c" provides the "prctl(PR_SET_MM)" function,
> which is the only way a process can set or modify the following 11
> per-process fields:
> 
>  	start_code, end_code, start_data, end_data, start_brk, brk,
>  	start_stack, arg_start, arg_end, env_start, env_end.
> 
> Being able to set those fields is important, even crucial,
> for any conceivable user-level checkpointing software, as
> well as for migrating processes between different computers.

You're saying that this is useful for code not needing a kernel with
CHECKPOINT_RESTORE enabled. Correct?

> 
> Unfortunately, this code (essentially "prctl_set_mm()") is presently
> enclosed in "#ifdef CONFIG_CHECKPOINT_RESTORE" which is configured
> as "default n" in "init/Kconfig".  Many system-administrators who
> may like to have a checkpoint/restore or process-migration facility,
> but use standard pre-packaged kernels, find the requirement to
> configure and compile their own non-standard kernel difficult or
> too prohibitive.
> 
> Would it be possible to have this code enabled by default?
> 
> This could be done in one of 4 ways:
> 1) Having CONFIG_CHECKPOINT_RESTORE enabled by default; or

Nope, that wont due. Kernel policy is to have things default n. Have an
issue with a config, talk with the distribution you are dealing with.
They set the policy of what configs get set for their kernels.

> 2) Releasing this code from the "#ifdef CONFIG_CHECK_RESTORE"; or
> 3) Placing this code within a different kernel-configuration option
>    (say "CONFIG_BASIC_CHECKPOINTING") that is enabled by default; or
> 4) Placing this code under a dual #if, so instead of:
>    #ifdef CONFIG_CHECKPOINT_RESTORE
> 	   have:
>    #if defined(CONFIG_CHECKPOINT_RESTORE) || defined(CONFIG_BASIC_CHECKPOINTING)

One of the above 3 can probably be worked out.

-- Steve


