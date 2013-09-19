Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007Ab3ISWBj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 18:01:39 -0400
Received: from www17.your-server.de ([213.133.104.17]:57480 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753943Ab3ISWBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 18:01:32 -0400
Subject: [PATCH 9/10] staging: r8188eu: Cocci spatch "noderef"
From: Thomas Meyer <thomas@m3y3r.de>
To: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Message-ID: <1379604755854-737294623-9-diffsplit-thomas@m3y3r.de>
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

diff -u -p a/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c b/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
--- a/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
+++ b/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
@@ -6973,7 +6973,7 @@ static int rtw_mp_ctx(struct net_device
 	stop = strncmp(extra, "stop", 4);
 	sscanf(extra, "count =%d, pkt", &count);
 
-	_rtw_memset(extra, '\0', sizeof(extra));
+	_rtw_memset(extra, '\0', sizeof(*extra));
 
 	if (stop == 0) {
 		bStartTest = 0; /*  To set Stop */
