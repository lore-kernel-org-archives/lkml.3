Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755811Ab3BURnG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 12:43:06 -0500
Received: from mx4-phx2.redhat.com ([209.132.183.25]:41020 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755646Ab3BURnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 12:43:01 -0500
Date: Thu, 21 Feb 2013 12:43:01 -0500 (EST)
From: Rado Vrbovsky <rvrbovsk@redhat.com>
To: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeff <jgarzik@redhat.com>
Message-ID: <693649786.7135156.1361468581077.JavaMail.root@redhat.com>
In-Reply-To: <1619122110.7061314.1361463977742.JavaMail.root@redhat.com>
Subject: [PATCH] ata_piix: Add MODULE_PARM_DESC to prefer_ms_hyperv
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.34.1.244]
X-Mailer: Zimbra 7.2.0_GA_2669 (ZimbraWebClient - FF3.0 (Linux)/7.2.0_GA_2669)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Brownfield <abrownfi@redhat.com>

In reference to the commit cd006086fa5d91414d8ff9ff2b78fbb593878e3c
this trivial patch adds a description to prefer_ms_hyperv.

[rvrbovsk@redhat.com: MODULE_PARM_DESC() string formatting modified]

Signed-off-by: Radomir Vrbovsky <rvrbovsk@redhat.com>

---
 drivers/ata/ata_piix.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index 174eca6..b9bf99a 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -1530,6 +1530,10 @@ static bool piix_broken_system_poweroff(struct pci_dev *pdev)
 
 static int prefer_ms_hyperv = 1;
 module_param(prefer_ms_hyperv, int, 0);
+MODULE_PARM_DESC(prefer_ms_hyperv,
+       "Prefer Hyper-V paravirtualization drivers instead of ATA, "
+       "0 - Use ATA drivers, "
+       "1 (Default) - Use the paravirtualization drivers.");
 
 static void piix_ignore_devices_quirk(struct ata_host *host)
 {
-- 
1.7.11.7
