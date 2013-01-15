Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756305Ab3AOHjL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 02:39:11 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:35138 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755167Ab3AOHjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 02:39:10 -0500
From: Mike Qiu <qiudayu@linux.vnet.ibm.com>
To: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Cc: benh@kernel.crashing.org, tglx@linutronix.de,
        Mike Qiu <qiudayu@linux.vnet.ibm.com>
Subject: [PATCH 0/3] Enable multiple MSI feature in pSeries
Date: Tue, 15 Jan 2013 15:38:53 +0800
Message-Id: <1358235536-32741-1-git-send-email-qiudayu@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.7.6
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13011507-3568-0000-0000-00000307D0FD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, multiple MSI feature hasn't been enabled in pSeries,
These patches try to enbale this feature.

These patches have been tested by using ipr driver, and the driver patch
has been made by Wen Xiong <wenxiong@linux.vnet.ibm.com>:

[PATCH 0/7] Add support for new IBM SAS controllers

Test platform: One partition of pSeries with one cpu core(4 SMTs) and 
               RAID bus controller: IBM PCI-E IPR SAS Adapter (ASIC) in POWER7
OS version: SUSE Linux Enterprise Server 11 SP2  (ppc64) with 3.8-rc3 kernel 

IRQ 21 and 22 are assigned to the ipr device which support 2 mutiple MSI.

The test results is shown by 'cat /proc/interrups':
          CPU0       CPU1       CPU2       CPU3       
16:     240458     261601     226310     200425      XICS Level     IPI
17:          0          0          0          0      XICS Level     RAS_EPOW
18:         10          0          3          2      XICS Level     hvc_console
19:     122182      28481      28527      28864      XICS Level     ibmvscsi
20:        506    7388226        108        118      XICS Level     eth0
21:          6          5          5          5      XICS Level     host1-0
22:        817        814        816        813      XICS Level     host1-1
LOC:     398077     316725     231882     203049   Local timer interrupts
SPU:       1659        919        961        903   Spurious interrupts
CNT:          0          0          0          0   Performance
monitoring interrupts
MCE:          0          0          0          0   Machine check exceptions

Mike Qiu (3):
  irq: Set multiple MSI descriptor data for multiple IRQs
  irq: Add hw continuous IRQs map to virtual continuous IRQs support
  powerpc/pci: Enable pSeries multiple MSI feature

 arch/powerpc/kernel/msi.c            |    4 --
 arch/powerpc/platforms/pseries/msi.c |   62 ++++++++++++++++++++++++++++++++-
 include/linux/irq.h                  |    4 ++
 include/linux/irqdomain.h            |    3 ++
 kernel/irq/chip.c                    |   40 ++++++++++++++++-----
 kernel/irq/irqdomain.c               |   61 +++++++++++++++++++++++++++++++++
 6 files changed, 158 insertions(+), 16 deletions(-)

-- 
1.7.7.6

