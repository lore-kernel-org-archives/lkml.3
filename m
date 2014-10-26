Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986AbaJZQxR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 12:53:17 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:45355 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784AbaJZQxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 12:53:07 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH v2 03/15] net: dsa: Report known silicon revisions for Marvell 88E6131
Date: Sun, 26 Oct 2014 09:52:33 -0700
Message-Id: <1414342365-27191-4-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414342365-27191-1-git-send-email-linux@roeck-us.net>
References: <1414342365-27191-1-git-send-email-linux@roeck-us.net>
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020207.544D26F2.01AE,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 27
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

Report known silicon revisions when probing Marvell 88E6131 switches.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
v2:
- No change

 drivers/net/dsa/mv88e6131.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/mv88e6131.c b/drivers/net/dsa/mv88e6131.c
index 244c735..1230f52 100644
--- a/drivers/net/dsa/mv88e6131.c
+++ b/drivers/net/dsa/mv88e6131.c
@@ -21,6 +21,7 @@
 #define ID_6085		0x04a0
 #define ID_6095		0x0950
 #define ID_6131		0x1060
+#define ID_6131_B2	0x1066
 
 static char *mv88e6131_probe(struct device *host_dev, int sw_addr)
 {
@@ -32,12 +33,15 @@ static char *mv88e6131_probe(struct device *host_dev, int sw_addr)
 
 	ret = __mv88e6xxx_reg_read(bus, sw_addr, REG_PORT(0), 0x03);
 	if (ret >= 0) {
-		ret &= 0xfff0;
-		if (ret == ID_6085)
+		int ret_masked = ret & 0xfff0;
+
+		if (ret_masked == ID_6085)
 			return "Marvell 88E6085";
-		if (ret == ID_6095)
+		if (ret_masked == ID_6095)
 			return "Marvell 88E6095/88E6095F";
-		if (ret == ID_6131)
+		if (ret == ID_6131_B2)
+			return "Marvell 88E6131 (B2)";
+		if (ret_masked == ID_6131)
 			return "Marvell 88E6131";
 	}
 
-- 
1.9.1

