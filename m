Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758082Ab3DXLTP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 07:19:15 -0400
Received: from relay3.sgi.com ([192.48.152.1]:59202 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754697Ab3DXLTO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 07:19:14 -0400
From: Robin Holt <holt@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Russ Anderson <rja@sgi.com>, Robin Holt <holt@sgi.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: [PATCH -v6 0/5] Shutdown from reboot_cpuid without stopping other cpus.
Date: Wed, 24 Apr 2013 06:18:48 -0500
Message-Id: <1366802333-8890-1-git-send-email-holt@sgi.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We recently noticed that reboot of a 1024 cpu machine takes approx 16
minutes of just stopping the cpus.  The slowdown was tracked to commit
f96972f.

The current implementation does all the work of hot removing the cpus
before halting the system.  We are switching to just migrating to the
reboot_cpu and then continuing with shutdown/reboot.

The patch set is broken into five parts.  The first two are planned for
the stable release.  The others move the halt/shutdown/reboot related
functions to their own kernel/reboot.c file and then introduce the kernel
boot parameter.


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
