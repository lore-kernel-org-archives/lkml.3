Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751475AbaFEHCz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 03:02:55 -0400
Received: from mga09.intel.com ([134.134.136.24]:62924 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751261AbaFEHCt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 03:02:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,979,1392192000"; 
   d="scan'208";a="551900440"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org
Subject: [RFC Patch 2/3] ce4100, irq: do not set legacy_pic to null_legacy_pic
Date: Thu,  5 Jun 2014 15:04:36 +0800
Message-Id: <1401951877-23032-3-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401951877-23032-1-git-send-email-jiang.liu@linux.intel.com>
References: <1401951877-23032-1-git-send-email-jiang.liu@linux.intel.com>
In-Reply-To: <5385BCD0.1080802@linutronix.de>
References: <5385BCD0.1080802@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Intel CE4100 platforms has i8259 legacy interrupt controllers, so don't
set legacy_pic to null_legacy_pic in late booting stage because we need
legacy_pic to mask i8259 pins when enabling IOAPIC pins for safety.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/platform/ce4100/ce4100.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/platform/ce4100/ce4100.c b/arch/x86/platform/ce4100/ce4100.c
index 0a54a586559b..701fd5843c87 100644
--- a/arch/x86/platform/ce4100/ce4100.c
+++ b/arch/x86/platform/ce4100/ce4100.c
@@ -138,8 +138,6 @@ static void __init sdv_arch_setup(void)
 static void sdv_pci_init(void)
 {
 	x86_of_pci_init();
-	/* We can't set this earlier, because we need to calibrate the timer */
-	legacy_pic = &null_legacy_pic;
 }
 
 /*
-- 
1.7.10.4

