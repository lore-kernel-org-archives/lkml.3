Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757347Ab3BRBj6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 20:39:58 -0500
Received: from miso.sublimeip.com ([203.12.5.51]:58401 "EHLO
	miso.sublimeip.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754047Ab3BRBj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 20:39:57 -0500
Subject: prctl(PR_SET_MM)
To: oleg@redhat.com (Oleg Nesterov)
Date: Mon, 18 Feb 2013 12:39:54 +1100 (EST)
Cc: palves@redhat.com (Pedro Alves), dvlasenk@redhat.com (Denys Vlasenko),
        jan.kratochvil@redhat.com (Jan Kratochvil),
        gorcunov@openvz.org (Cyrill Gorcunov),
        xemul@parallels.com (Pavel Emelyanov),
        rostedt@goodmis.org (Steven Rostedt),
        fweisbec@gmail.com (Frederic Weisbecker),
        mingo@redhat.com (Ingo Molnar),
        a.p.zijlstra@chello.nl (Peter Zijlstra), linux-kernel@vger.kernel.org
Reply-To: u3557@dialix.com.au
In-Reply-To: <20130114160153.GA16555@redhat.com>
X-Mailer: ELM [version 2.5 PL8]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20130218013954.28FCF59206F@miso.sublimeip.com>
From: u3557@miso.sublimeip.com (Amnon Shiloh)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

The code in "kernel/sys.c" provides the "prctl(PR_SET_MM)" function,
which is the only way a process can set or modify the following 11
per-process fields:

 	start_code, end_code, start_data, end_data, start_brk, brk,
 	start_stack, arg_start, arg_end, env_start, env_end.

Being able to set those fields is important, even crucial,
for any conceivable user-level checkpointing software, as
well as for migrating processes between different computers.

Unfortunately, this code (essentially "prctl_set_mm()") is presently
enclosed in "#ifdef CONFIG_CHECKPOINT_RESTORE" which is configured
as "default n" in "init/Kconfig".  Many system-administrators who
may like to have a checkpoint/restore or process-migration facility,
but use standard pre-packaged kernels, find the requirement to
configure and compile their own non-standard kernel difficult or
too prohibitive.

Would it be possible to have this code enabled by default?

This could be done in one of 4 ways:
1) Having CONFIG_CHECKPOINT_RESTORE enabled by default; or
2) Releasing this code from the "#ifdef CONFIG_CHECK_RESTORE"; or
3) Placing this code within a different kernel-configuration option
   (say "CONFIG_BASIC_CHECKPOINTING") that is enabled by default; or
4) Placing this code under a dual #if, so instead of:
   #ifdef CONFIG_CHECKPOINT_RESTORE
	   have:
   #if defined(CONFIG_CHECKPOINT_RESTORE) || defined(CONFIG_BASIC_CHECKPOINTING)


Thank you,
Amnon.
