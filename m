Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760064Ab3ICQ1h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 12:27:37 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46557 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760033Ab3ICQ1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 12:27:32 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 37/58] Hostap: copying wrong data prism2_ioctl_giwaplist()
Date: Tue,  3 Sep 2013 09:23:41 -0700
Message-Id: <1378225442-20654-38-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1378225442-20654-1-git-send-email-kamal@canonical.com>
References: <1378225442-20654-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 909bd5926d474e275599094acad986af79671ac9 upstream.

We want the data stored in "addr" and "qual", but the extra ampersands
mean we are copying stack data instead.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/wireless/hostap/hostap_ioctl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/hostap/hostap_ioctl.c b/drivers/net/wireless/hostap/hostap_ioctl.c
index ac07473..e509030 100644
--- a/drivers/net/wireless/hostap/hostap_ioctl.c
+++ b/drivers/net/wireless/hostap/hostap_ioctl.c
@@ -523,9 +523,9 @@ static int prism2_ioctl_giwaplist(struct net_device *dev,
 
 	data->length = prism2_ap_get_sta_qual(local, addr, qual, IW_MAX_AP, 1);
 
-	memcpy(extra, &addr, sizeof(struct sockaddr) * data->length);
+	memcpy(extra, addr, sizeof(struct sockaddr) * data->length);
 	data->flags = 1; /* has quality information */
-	memcpy(extra + sizeof(struct sockaddr) * data->length, &qual,
+	memcpy(extra + sizeof(struct sockaddr) * data->length, qual,
 	       sizeof(struct iw_quality) * data->length);
 
 	kfree(addr);
-- 
1.8.1.2

