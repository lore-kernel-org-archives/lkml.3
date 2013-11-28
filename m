Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757422Ab3K1Mwz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 07:52:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1510 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751102Ab3K1Mwy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 07:52:54 -0500
Message-ID: <52973CA4.7070402@redhat.com>
Date: Thu, 28 Nov 2013 13:52:52 +0100
From: Maurizio Lombardi <mlombard@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: pe1dnn@amsat.org
CC: linux-kernel@vger.kernel.org
Subject: [PATCH v2] wlags49_h2: Fix overflow in wireless_set_essid()
References: <1385643047-8725-1-git-send-email-mlombard@redhat.com>
In-Reply-To: <1385643047-8725-1-git-send-email-mlombard@redhat.com>
X-Forwarded-Message-Id: <1385643047-8725-1-git-send-email-mlombard@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch prevents the wireless_set_essid() function from overwriting
the last byte of the NetworkName buffer which must be NULL.

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
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



