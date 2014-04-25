Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419AbaDYJdH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 05:33:07 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:24957 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753316AbaDYJb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 05:31:26 -0400
From: Marc Zyngier <marc.zyngier@arm.com>
To: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com
Cc: Russell King <linux@arm.linux.org.uk>, Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Alessandro Zummo <a.zummo@towertech.it>
Subject: [PATCH 0/7] rtc-cmos: private locking and MMIO support
Date: Fri, 25 Apr 2014 10:31:08 +0100
Message-Id: <1398418275-9671-1-git-send-email-marc.zyngier@arm.com>
X-Mailer: git-send-email 1.8.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The original PC-style CMOS RTC driver is so weird and full of hacks
that it has reached the status of a major piece of art.

Despite noticeable efforts to carry on with the spirit of tainting
every architecture under the sun, this patch series tries to make the
rtc-cmos driver a slightly better citizen by allowing architecture
code *not* to provide an exported lock when it is not strictly
required, and to allow for MMIO accessors on architectures that don't
have IO ports.

Please have a bucket ready.

The actual goal of the exercise is to allow the use of the RTC
emulation provided by kvmtool in KVM/ARM guests. This series has also
been tested on x86.

Marc Zyngier (7):
  rtc-cmos: abstract IO accessors
  rtc-cmos: abstract locking primitives
  rtc-cmos: allow MMIO to be used when initialized from FDT
  rtc-cmos: allow strictly MMIO based configurations
  rtc-cmos: implement driver private locking
  ARM: rtc: update CMOS RTC to support MMIO and private lock
  arm64: rtc: plug the PC CMOS RTC using MMIO accessors

 arch/arm/kernel/time.c               |   7 --
 arch/arm64/include/asm/mc146818rtc.h |  10 ++
 drivers/rtc/Kconfig                  |  15 ++-
 drivers/rtc/rtc-cmos.c               | 217 +++++++++++++++++++++++++----------
 include/asm-generic/rtc.h            |  92 ++++++++++-----
 5 files changed, 240 insertions(+), 101 deletions(-)
 create mode 100644 arch/arm64/include/asm/mc146818rtc.h

-- 
1.8.3.4

