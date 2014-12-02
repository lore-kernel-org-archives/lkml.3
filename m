Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933281AbaLBV1J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 16:27:09 -0500
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:58409
	"EHLO p3plsmtps2ded02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754237AbaLBV1I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 16:27:08 -0500
X-Greylist: delayed 452 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Dec 2014 16:26:42 EST
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 1/3] Drivers: hv: hv_balloon: Make adjustments in computing the floor
Date: Tue,  2 Dec 2014 14:29:13 -0800
Message-Id: <1417559355-13730-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1417559331-13691-1-git-send-email-kys@microsoft.com>
References: <1417559331-13691-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make adjustments in computing the balloon floor.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/hv/hv_balloon.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/hv/hv_balloon.c b/drivers/hv/hv_balloon.c
index b958ded..9cbbb83 100644
--- a/drivers/hv/hv_balloon.c
+++ b/drivers/hv/hv_balloon.c
@@ -928,9 +928,8 @@ static unsigned long compute_balloon_floor(void)
 	 *     128        72    (1/2)
 	 *     512       168    (1/4)
 	 *    2048       360    (1/8)
-	 *    8192       552    (1/32)
-	 *   32768      1320
-	 *  131072      4392
+	 *    8192       768    (1/16)
+	 *   32768      1536	(1/32)
 	 */
 	if (totalram_pages < MB2PAGES(128))
 		min_pages = MB2PAGES(8) + (totalram_pages >> 1);
@@ -938,8 +937,10 @@ static unsigned long compute_balloon_floor(void)
 		min_pages = MB2PAGES(40) + (totalram_pages >> 2);
 	else if (totalram_pages < MB2PAGES(2048))
 		min_pages = MB2PAGES(104) + (totalram_pages >> 3);
+	else if (totalram_pages < MB2PAGES(8192))
+		min_pages = MB2PAGES(256) + (totalram_pages >> 4);
 	else
-		min_pages = MB2PAGES(296) + (totalram_pages >> 5);
+		min_pages = MB2PAGES(512) + (totalram_pages >> 5);
 #undef MB2PAGES
 	return min_pages;
 }
-- 
1.7.4.1

