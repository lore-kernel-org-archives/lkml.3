Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758676Ab3FAJoM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 05:44:12 -0400
Received: from www17.your-server.de ([213.133.104.17]:59181 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758271Ab3FAJoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 05:44:03 -0400
Message-ID: <1370079835.29224.14.camel@localhost.localdomain>
Subject: [PATCH] ARM: imx: Cocci spatch "ptr_ret.spatch"
From: Thomas Meyer <thomas@m3y3r.de>
To: kernel@pengutronix.de, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org
Date: Sat, 01 Jun 2013 11:43:55 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/arch/arm/mach-imx/devices/platform-mxc_rnga.c b/arch/arm/mach-imx/devices/platform-mxc_rnga.c
--- a/arch/arm/mach-imx/devices/platform-mxc_rnga.c
+++ b/arch/arm/mach-imx/devices/platform-mxc_rnga.c
@@ -48,9 +48,6 @@ static int __init imxXX_add_mxc_rnga(voi
 #endif /* if defined(CONFIG_SOC_IMX31) */
 		ret = ERR_PTR(-ENODEV);
 
-	if (IS_ERR(ret))
-		return PTR_ERR(ret);
-
-	return 0;
+	return PTR_RET(ret);
 }
 arch_initcall(imxXX_add_mxc_rnga);


