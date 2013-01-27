Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756029Ab3A0GNv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 01:13:51 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:47054 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755727Ab3A0GNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 01:13:49 -0500
Date: Sun, 27 Jan 2013 14:13:32 +0800
From: Wang YanQing <udknight@gmail.com>
To: FlorianSchandinat@gmx.de
Cc: spock@gentoo.org, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH]video:uvesafb: Fix dereference NULL pointer code path
Message-ID: <20130127061331.GA4314@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>,
	FlorianSchandinat@gmx.de, spock@gentoo.org,
	linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
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
