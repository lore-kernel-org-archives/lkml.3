Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757869Ab3BRFnu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 00:43:50 -0500
Received: from merlin.infradead.org ([205.233.59.134]:38158 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191Ab3BRFnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 00:43:49 -0500
Message-ID: <5121BFA7.8070203@infradead.org>
Date: Sun, 17 Feb 2013 21:44:07 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130105 Thunderbird/17.0.2
MIME-Version: 1.0
To: u3557@dialix.com.au
CC: Amnon Shiloh <u3557@miso.sublimeip.com>, Oleg Nesterov <oleg@redhat.com>,
        Pedro Alves <palves@redhat.com>, Denys Vlasenko <dvlasenk@redhat.com>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: prctl(PR_SET_MM)
References: <20130218013954.28FCF59206F@miso.sublimeip.com>
In-Reply-To: <20130218013954.28FCF59206F@miso.sublimeip.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/17/13 17:39, Amnon Shiloh wrote:
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
> 2) Releasing this code from the "#ifdef CONFIG_CHECK_RESTORE"; or
> 3) Placing this code within a different kernel-configuration option
>    (say "CONFIG_BASIC_CHECKPOINTING") that is enabled by default; or
> 4) Placing this code under a dual #if, so instead of:
>    #ifdef CONFIG_CHECKPOINT_RESTORE
> 	   have:
>    #if defined(CONFIG_CHECKPOINT_RESTORE) || defined(CONFIG_BASIC_CHECKPOINTING)


This is basically a distro issue.  Distros can choose to enable
this code by default, but the Linux kernel that Linus maintains does
not need to enable it.


-- 
~Randy
