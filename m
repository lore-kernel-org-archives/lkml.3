Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965128Ab3DPULa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 16:11:30 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:44583 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936099Ab3DPUJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 16:09:18 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: stefano.stabellini@eu.citrix.com, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com
Subject: [PATCH] fixes for v3.10 in the CPU hotplug patch (v1). 
Date: Tue, 16 Apr 2013 16:08:58 -0400
Message-Id: <1366142947-18655-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.1.4
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first three patches fix outstanding issues with v3.9 (and earlier)
kernels where the simple sequence of:

echo 0 > /sys/devices/system/cpu/cpu1/online
echo 1 > /sys/devices/system/cpu/cpu1/online

would embarrassingly not work. As such they also have the stable@vger.kernel.org
on them.

 [PATCH 1/9] xen/smp: Fix leakage of timer interrupt line for every
 [PATCH 2/9] xen/smp/spinlock: Fix leakage of the spinlock interrupt
 [PATCH 3/9] xen/time: Fix kasprintf splat when allocating timer%d IRQ

The rest are just cleanups and some coalescing of the PV and PVHVM
paths.

 arch/x86/xen/enlighten.c |  5 ++++-
 arch/x86/xen/smp.c       | 21 ++++++++++++++-------
 arch/x86/xen/spinlock.c  | 25 +++++++++++++++++++++++++
 arch/x86/xen/time.c      | 13 ++++++++++---
 drivers/xen/events.c     | 20 +++++++++++++++++++-
 5 files changed, 72 insertions(+), 12 deletions(-)

Konrad Rzeszutek Wilk (9):
      xen/smp: Fix leakage of timer interrupt line for every CPU online/offline.
      xen/smp/spinlock: Fix leakage of the spinlock interrupt line for every CPU online/offline
      xen/time: Fix kasprintf splat when allocating timer%d IRQ line.
      xen/events: Check that IRQ value passed in is valid.
      xen/time: Add default value of -1 for IRQ and check for that.
      xen/spinlock:  Check against default value of -1 for IRQ line.
      xen/spinlock: Disable IRQ spinlock (PV) allocation on PVHVM
      xen/smp/pvhvm: Don't initialize IRQ_WORKER as we are using the native one.
      xen/smp: Unifiy some of the PVs and PVHVM offline CPU path

