Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560AbaBEPrB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 10:47:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60484 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751333AbaBEPrA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 10:47:00 -0500
Message-ID: <52F25CF0.5060705@redhat.com>
Date: Wed, 05 Feb 2014 16:46:56 +0100
From: Maurizio Lombardi <mlombard@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: pe1dnn@amsat.org
CC: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH RESEND] wlags49_h2: Fix overflow in wireless_set_essid()
References: <1391614506-3118-1-git-send-email-mlombard@redhat.com>
In-Reply-To: <1391614506-3118-1-git-send-email-mlombard@redhat.com>
X-Forwarded-Message-Id: <1391614506-3118-1-git-send-email-mlombard@redhat.com>
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
index 4a1ddaf..187fc06 100644
--- a/drivers/staging/wlags49_h2/wl_wext.c
+++ b/drivers/staging/wlags49_h2/wl_wext.c
@@ -1061,7 +1061,7 @@ static int wireless_set_essid(struct net_device *dev, struct iw_request_info *in
 		goto out;
 	}

-	if (data->flags != 0 && data->length > HCF_MAX_NAME_LEN + 1) {
+	if (data->flags != 0 && data->length > HCF_MAX_NAME_LEN) {
 		ret = -EINVAL;
 		goto out;
 	}
-- 
Maurizio Lombardi



