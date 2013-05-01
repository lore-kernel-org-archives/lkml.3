Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589Ab3EARHQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 13:07:16 -0400
Received: from relay2.sgi.com ([192.48.179.30]:59272 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753096Ab3EARHH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 13:07:07 -0400
From: Robin Holt <holt@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Russell King <linux@arm.linux.org.uk>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Miguel Boton <mboton.lkml@gmail.com>
Cc: Russ Anderson <rja@sgi.com>, Robin Holt <holt@sgi.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Arm Mailing List <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH -v7 0/11] Shutdown from reboot_cpuid without stopping other cpus.
Date: Wed,  1 May 2013 12:06:40 -0500
Message-Id: <1367428011-17123-1-git-send-email-holt@sgi.com>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew, Please do _NOT_ take this patch series yet.  I am sending this
to you because you had comments on my -v6 submission.  If you do take
any of the patches, I believe patches 1-5 would be considered ready for
moving on as you had comments and I don't recall any others.  The first
two would really be nice to get into the stable release.

Peter,  I don't think I went too far off the rails on this.  The three
archs which handle reboot= should have been unified, correct?  I think
that ends up with essentially this.  I think the unicore and arm functions
passing around the now-global reboot_mode is probably the wrong way to
do things, so I would at least want to rework unicore and arm patches
to remove that parameter.  Otherwise, this patch set was building for
all the arm defconfigs as well as my x86_64 configs.

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
To: H. Peter Anvin <hpa@zytor.com>
Cc: Russ Anderson <rja@sgi.com>
Cc: Robin Holt <holt@sgi.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: the arch/x86 maintainers <x86@kernel.org>
Cc: Arm Mailing List <linux-arm-kernel@lists.infradead.org>
