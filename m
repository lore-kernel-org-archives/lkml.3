Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759410Ab3K1Tj4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 14:39:56 -0500
Received: from [77.240.181.54] ([77.240.181.54]:60347 "EHLO
	dhcp-27-189.brq.redhat.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755625Ab3K1Tjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 14:39:52 -0500
From: Maurizio Lombardi <mlombard@redhat.com>
To: pe1dnn@amsat.org
Cc: linux-kernel@vger.kernel.org, Maurizio Lombardi <mlombard@redhat.com>
Subject: [PATCH] wlags49_h2: Fix overflow in wireless_set_essid()
Date: Wed, 27 Nov 2013 10:03:53 +0100
Message-Id: <1385543033-4365-1-git-send-email-mlombard@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch prevents the wireless_set_essid() function from overwriting
the last byte of the NetworkName buffer which must be NULL.
---
 drivers/staging/wlags49_h2/wl_wext.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wlags49_h2/wl_wext.c b/drivers/staging/wlags49_h2/wl_wext.c
index c731ff2..62ad158 100644
--- a/drivers/staging/wlags49_h2/wl_wext.c
+++ b/drivers/staging/wlags49_h2/wl_wext.c
@@ -1127,7 +1127,7 @@ static int wireless_set_essid(struct net_device *dev, struct iw_request_info *in
 		goto out;
 	}
 
-	if (data->flags != 0 && data->length > HCF_MAX_NAME_LEN + 1) {
+	if (data->flags != 0 && data->length > HCF_MAX_NAME_LEN) {
 		ret = -EINVAL;
 		goto out;
 	}
-- 
1.8.3.1

