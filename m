Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549AbaJNSVS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 14:21:18 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:48073 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755447AbaJNSVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 14:21:15 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: "David S. Miller" <davem@davemloft.net>
Cc: Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH] dsa: mv88e6171: Fix tag_protocol check
Date: Tue, 14 Oct 2014 11:21:04 -0700
Message-Id: <1413310864-16830-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tag_protocol is now an enum, so drivers have to check against it.

Cc: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/net/dsa/mv88e6171.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mv88e6171.c b/drivers/net/dsa/mv88e6171.c
index 6365e30..1020a7a 100644
--- a/drivers/net/dsa/mv88e6171.c
+++ b/drivers/net/dsa/mv88e6171.c
@@ -206,7 +206,7 @@ static int mv88e6171_setup_port(struct dsa_switch *ds, int p)
 	 */
 	val = 0x0433;
 	if (dsa_is_cpu_port(ds, p)) {
-		if (ds->dst->tag_protocol == htons(ETH_P_EDSA))
+		if (ds->dst->tag_protocol == DSA_TAG_PROTO_EDSA)
 			val |= 0x3300;
 		else
 			val |= 0x0100;
-- 
1.9.1

