Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751658Ab3BOTc5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 14:32:57 -0500
Received: from mout.gmx.net ([212.227.15.18]:59057 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751588Ab3BOTcy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 14:32:54 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/Fc1kjSEzF+yr9Z6rzNd1ASuLpkLEtOcSp2zZTMj
	/qAnyfXfq9TGXD
From: Peter Huewe <peterhuewe@gmx.de>
To: Arnaud Patard <arnaud.patard@rtp-net.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, Peter Huewe <peterhuewe@gmx.de>,
        =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] staging/xgifb: Consolidate return paths
Date: Fri, 15 Feb 2013 20:37:12 +0100
Message-Id: <1360957033-11876-4-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1360957033-11876-1-git-send-email-peterhuewe@gmx.de>
References: <1360957033-11876-1-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both branches of this if statement end in the same return statement.
-> move the return to the bottom and get rid of the else statement.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/xgifb/vb_setmode.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/xgifb/vb_setmode.c b/drivers/staging/xgifb/vb_setmode.c
index a602d43..edbe70b 100644
--- a/drivers/staging/xgifb/vb_setmode.c
+++ b/drivers/staging/xgifb/vb_setmode.c
@@ -2860,10 +2860,8 @@ static unsigned short XGI_GetOffset(unsigned short ModeNo,
 		temp = 0x6B;
 		if (infoflag & InterlaceMode)
 			temp = temp << 1;
-		return temp * colordepth;
-	} else {
-		return temp * colordepth;
 	}
+	return temp * colordepth;
 }
 
 static void XGI_SetCRT2Offset(unsigned short ModeNo,
-- 
1.7.8.6

