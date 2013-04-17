Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936366Ab3DQSna (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 14:43:30 -0400
Received: from relay2.sgi.com ([192.48.179.30]:43531 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755239Ab3DQSn2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 14:43:28 -0400
From: Robin Holt <holt@sgi.com>
To: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Russ Anderson <rja@sgi.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: [PATCH -v5 0/5] Shutdown from reboot_cpuid without stopping other cpus.
Date: Wed, 17 Apr 2013 13:43:13 -0500
Message-Id: <1366224198-49485-1-git-send-email-holt@sgi.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We recently noticed that reboot of a 1024 cpu machine takes approx 16
minutes of just stopping the cpus.  The slowdown was tracked to commit
f96972f.

The current implementation does all the work of hot removing the cpus
before halting the system.  We are switching to just migrating to the
reboot_cpuid and then continuing with shutdown/reboot.

The patch set is broken into five parts.  The first two are planned for
the stable release.  The others move the halt/shutdown/reboot related
functions to their own kernel/reboot.c file and then introduce the kernel
boot parameter.


Changes since -v4.
 - Integrated Srivatsa S. Bhat creating cpu_hotplug_disable()
   function

 - Integrated comments by Srivatsa S. Bhat.

 - Made one more comment consistent with others in function.

Changes since -v3.
 - Added a tested-by for the original reporter.

 - Fix compile failure found by Joe Perches.

 - Integrated comments by Joe Perches.
