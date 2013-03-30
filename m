Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757722Ab3C3Cxp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 22:53:45 -0400
Received: from mail-da0-f52.google.com ([209.85.210.52]:37171 "EHLO
	mail-da0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757680Ab3C3Cxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 22:53:44 -0400
Date: Sat, 30 Mar 2013 10:53:30 +0800
From: Wang YanQing <udknight@gmail.com>
To: tomi.valkeinen@ti.com
Cc: spock@gentoo.org, linux-fbdev@vger.kernel.org, FlorianSchandinat@gmx.de,
        linux-kernel@vger.kernel.org
Subject: [PATCH]video:uvesafb: Fix dereference NULL pointer code path
Message-ID: <20130330025330.GA25246@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>, tomi.valkeinen@ti.com,
	spock@gentoo.org, linux-fbdev@vger.kernel.org,
	FlorianSchandinat@gmx.de, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

platform_device_alloc could failed and return NULL,
we should check this before call platform_device_put.

Signed-off-by: Wang YanQing <udknight@gmail.com>
---
 drivers/video/uvesafb.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/video/uvesafb.c b/drivers/video/uvesafb.c
index 2f8f82d..230bd45 100644
--- a/drivers/video/uvesafb.c
+++ b/drivers/video/uvesafb.c
@@ -1975,7 +1975,8 @@ static int __devinit uvesafb_init(void)
 			err = -ENOMEM;
 
 		if (err) {
-			platform_device_put(uvesafb_device);
+			if (uvesafb_device)
+				platform_device_put(uvesafb_device);
 			platform_driver_unregister(&uvesafb_driver);
 			cn_del_callback(&uvesafb_cn_id);
 			return err;
-- 
1.7.11.1.116.g8228a23
