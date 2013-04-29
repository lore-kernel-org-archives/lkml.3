Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757542Ab3D2NNu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 09:13:50 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:52967 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756853Ab3D2NNt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 09:13:49 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "chas williams - CONTRACTOR" <chas@cmf.nrl.navy.mil>
Subject: [PATCH v2 05/21] atm: he: use msleep instead of large udelay constants
Date: Mon, 29 Apr 2013 15:13:26 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: "David Laight" <David.Laight@aculab.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org
References: <1366910944-3033663-1-git-send-email-arnd@arndb.de> <AE90C24D6B3A694183C094C60CF0A2F6026B7203@saturn3.aculab.com> <20130426091220.468cf59e@thirdoffive.cmf.nrl.navy.mil>
In-Reply-To: <20130426091220.468cf59e@thirdoffive.cmf.nrl.navy.mil>
MIME-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <201304291513.27104.arnd@arndb.de>
X-Provags-ID: V02:K0:86yt3r88vZac3lgwY77qM0GIdA8PUV7xRUsdSJNsKWc
 7wfZi5oUese1t1hVKXJVaBg0jlLEIeEqlC9yM7UofQmI2b5Yte
 R0EeOvAE7SUEdavfJgXPVKfMO5tpgepRo508aGKANuuwDSirbM
 C3fZH5g+cf74H67ufsq2VKbS44ou+0x0UXgAzoWwuN9xxhnaAf
 +C+nIM+jeAZ1B2jARytfWN8hztUEqspjgQKIggINF56CKCWGM5
 F5EJwzh+WQJc0o4q5AaCr1iMxi/pQ4tgvyReM/JGgv0++gWUig
 t4PBczE3S2zTKqDaWIcoWVkPs9I59dYy7+V4ZKvZvvDyBsdk6S
 BnJGyNgcCMZySE0jReoE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From a0ddf082821b064cc2d6a9bb90861f9b81a559a5 Mon Sep 17 00:00:00 2001
From: Arnd Bergmann <arnd@arndb.de>
Date: Thu, 14 Mar 2013 15:21:36 +0100
Subject: [PATCH] atm: he: use mdelay instead of large udelay constants

ARM cannot handle udelay for more than 2 miliseconds, and
it is rather bad style to block the cpu for 16ms anyway,
so let's use msleep instead.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Chas Williams <chas@cmf.nrl.navy.mil>
Cc: linux-atm-general@lists.sourceforge.net
Cc: netdev@vger.kernel.org
---
diff --git a/drivers/atm/he.c b/drivers/atm/he.c
index d689126..507362a 100644
--- a/drivers/atm/he.c
+++ b/drivers/atm/he.c
@@ -1055,7 +1055,7 @@ static int he_start(struct atm_dev *dev)
 	he_writel(he_dev, 0x0, RESET_CNTL);
 	he_writel(he_dev, 0xff, RESET_CNTL);
 
-	udelay(16*1000);	/* 16 ms */
+	msleep(16);	/* 16 ms */
 	status = he_readl(he_dev, RESET_CNTL);
 	if ((status & BOARD_RST_STATUS) == 0) {
 		hprintk("reset failed\n");
