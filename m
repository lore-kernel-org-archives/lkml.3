Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476Ab3ISWBV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 18:01:21 -0400
Received: from www17.your-server.de ([213.133.104.17]:57461 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150Ab3ISWBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 18:01:20 -0400
Subject: [PATCH 7/10] staging: r8188eu: Add files for new drive: Cocci
 spatch "noderef"
From: Thomas Meyer <thomas@m3y3r.de>
To: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Message-ID: <1379604755853-725626372-7-diffsplit-thomas@m3y3r.de>
References: <1379604755850-858421494-0-diffsplit-thomas@m3y3r.de>
In-Reply-To: <1379604755850-858421494-0-diffsplit-thomas@m3y3r.de>
Date: Thu, 19 Sep 2013 23:45:46 +0200
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sizeof when applied to a pointer typed expression gives the size of the
pointer.
Found by coccinelle spatch "misc/noderef.cocci"

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/staging/rtl8188eu/core/rtw_mp.c b/drivers/staging/rtl8188eu/core/rtw_mp.c
--- a/drivers/staging/rtl8188eu/core/rtw_mp.c
+++ b/drivers/staging/rtl8188eu/core/rtw_mp.c
@@ -907,7 +907,7 @@ u32 mp_query_psd(struct adapter *pAdapte
 		sscanf(data, "pts =%d, start =%d, stop =%d", &psd_pts, &psd_start, &psd_stop);
 	}
 
-	_rtw_memset(data, '\0', sizeof(data));
+	_rtw_memset(data, '\0', sizeof(*data));
 
 	i = psd_start;
 	while (i < psd_stop) {
