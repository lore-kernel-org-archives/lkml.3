Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751944Ab3EKL5g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 May 2013 07:57:36 -0400
Received: from relay2.sgi.com ([192.48.179.30]:59306 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751042Ab3EKL5f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 May 2013 07:57:35 -0400
From: Robin Holt <holt@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Russ Anderson <rja@sgi.com>,
        Robin Holt <holt@sgi.com>, Russell King <linux@arm.linux.org.uk>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Arm Mailing List <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH -v10 00/11] Shutdown from reboot_cpuid without stopping other cpus.
Date: Sat, 11 May 2013 06:57:16 -0500
Message-Id: <1368273447-11958-1-git-send-email-holt@sgi.com>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We recently noticed that reboot of a 1024 cpu machine takes approx 16
minutes of just stopping the cpus.  The slowdown was tracked to commit
f96972f.

The current implementation does all the work of hot removing the cpus
before halting the system.  We are switching to just migrating to the
reboot_cpu and then continuing with shutdown/reboot.

The patch set is broken into eleven parts.  The first two are planned for
the stable release.  The others move the halt/shutdown/reboot related
functions to their own kernel/reboot.c file and then move the handling
of the kernel reboot= kernel parameter to generic kernel code.

Changes since -v9
 - Added Ingo's Acked-by for x86.

 - Added Guan's Acked-by for unicore32.

 - Replaced first patch with updated patch from Srivatsa S. Bhat.
   This compiles for alpha allmodconfig, all arm defconfigs, and a few
   test x86_64 defconfigs.  I have not tried more.

Changes since -v8
 - Changes reboot_cpu on stack to cpu to fix bug noticed by Russell King.

 - Switched unicore32 and arm from using REBOOT_WARM/COLD to HARD/SOFT.

 - Fixed case statement bug.

 - Went to using simple_strtoul for parsing reboot_cpu=smp###.

 - Made parsing of reboot= not use any #ifdef'd code.

Changes since -v7.
 - Fixed authorship for first patch.

 - Rebased to Linus' current tree (51a26ae7a).

Changes since -v6.
 - Cross compiled all arm architectures (using v3.9 kernel.  Fails with
   current).

 - Added a #define for non-hotplug case.

 - Add #define for PF_THREAD_BOUND as compatibility to make stable easier.

 - Fixup s/reboot_cpu_id/reboot_cpu/

 - Add include of linux/uaccess.h to allow building on arm.

 - Removed last remaining checkpatch.pl line length warning on
   kernel/reboot.c.

 - Fixed the duplicate handling or the reboot= kernel parameter.

Changes since -v5.
 - Moved the arch/x86 reboot= up to the generic kernel code.

Changes since -v4.
 - Integrated Srivatsa S. Bhat creating cpu_hotplug_disable()
   function

 - Integrated comments by Srivatsa S. Bhat.

 - Made one more comment consistent with others in function.

Changes since -v3.
 - Added a tested-by for the original reporter.

 - Fix compile failure found by Joe Perches.

 - Integrated comments by Joe Perches.


To: Andrew Morton <akpm@linux-foundation.org>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Russ Anderson <rja@sgi.com>
Cc: Robin Holt <holt@sgi.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: the arch/x86 maintainers <x86@kernel.org>
Cc: Arm Mailing List <linux-arm-kernel@lists.infradead.org>
