Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524AbaJZQ47 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 12:56:59 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:45385 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930AbaJZQxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 12:53:14 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH v2 05/15] net: dsa/mv88e6352: Add support for MV88E6176
Date: Sun, 26 Oct 2014 09:52:35 -0700
Message-Id: <1414342365-27191-6-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414342365-27191-1-git-send-email-linux@roeck-us.net>
References: <1414342365-27191-1-git-send-email-linux@roeck-us.net>
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020207.544D26FA.00F5,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 44
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MV88E6176 is mostly compatible to MV88E6352 and is documented
in the same functional specification. Add support for it.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
v2:
- No change

 drivers/net/dsa/Kconfig     | 5 +++--
 drivers/net/dsa/mv88e6352.c | 2 ++
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/Kconfig b/drivers/net/dsa/Kconfig
index 0987c33..2d1a55e 100644
--- a/drivers/net/dsa/Kconfig
+++ b/drivers/net/dsa/Kconfig
@@ -46,12 +46,13 @@ config NET_DSA_MV88E6171
 	  chip.
 
 config NET_DSA_MV88E6352
-	tristate "Marvell 88E6352 ethernet switch chip support"
+	tristate "Marvell 88E6176/88E6352 ethernet switch chip support"
 	select NET_DSA
 	select NET_DSA_MV88E6XXX
 	select NET_DSA_TAG_EDSA
 	---help---
-	  This enables support for the Marvell 88E6352 ethernet switch chip.
+	  This enables support for the Marvell 88E6176 and 88E6352 ethernet
+	  switch chips.
 
 config NET_DSA_BCM_SF2
 	tristate "Broadcom Starfighter 2 Ethernet switch support"
diff --git a/drivers/net/dsa/mv88e6352.c b/drivers/net/dsa/mv88e6352.c
index 43a5826..f17364f 100644
--- a/drivers/net/dsa/mv88e6352.c
+++ b/drivers/net/dsa/mv88e6352.c
@@ -73,6 +73,8 @@ static char *mv88e6352_probe(struct device *host_dev, int sw_addr)
 
 	ret = __mv88e6xxx_reg_read(bus, sw_addr, REG_PORT(0), 0x03);
 	if (ret >= 0) {
+		if ((ret & 0xfff0) == 0x1760)
+			return "Marvell 88E6176";
 		if (ret == 0x3521)
 			return "Marvell 88E6352 (A0)";
 		if (ret == 0x3522)
-- 
1.9.1

