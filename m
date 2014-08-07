Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932359AbaHGRVl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 13:21:41 -0400
Received: from mx02.posteo.de ([89.146.194.165]:38034 "EHLO posteo.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932277AbaHGRVj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 13:21:39 -0400
From: Andreas Schlick <ninox@posteo.net>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jes Sorensen <Jes.Sorensen@redhat.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        linux-wireless@vger.kernel.org, Andreas Schlick <ninox@posteo.net>
Subject: [PATCH 2/2] staging: rtl8723au: Remove unnecessary bit masking.
Date: Thu,  7 Aug 2014 19:20:50 +0200
Message-Id: <1407432050-5624-3-git-send-email-ninox@posteo.net>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1407432050-5624-1-git-send-email-ninox@posteo.net>
References: <1407432050-5624-1-git-send-email-ninox@posteo.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andreas Schlick <ninox@posteo.net>
---
 drivers/staging/rtl8723au/core/rtw_efuse.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_efuse.c b/drivers/staging/rtl8723au/core/rtw_efuse.c
index 0bec131..abc5d3c 100644
--- a/drivers/staging/rtl8723au/core/rtw_efuse.c
+++ b/drivers/staging/rtl8723au/core/rtw_efuse.c
@@ -156,8 +156,7 @@ ReadEFuseByte23a(struct rtw_adapter *Adapter, u16 _offset, u8 *pbuf)
 	/* Check bit 32 read-ready */
 	retry = 0;
 	value32 = rtl8723au_read32(Adapter, EFUSE_CTRL);
-	/* while(!(((value32 >> 24) & 0xff) & 0x80)  && (retry<10)) */
-	while (!(((value32 >> 24) & 0xff) & 0x80) && (retry<10000)) {
+	while (!((value32 >> 24) & 0x80) && retry < 10000) {
 		value32 = rtl8723au_read32(Adapter, EFUSE_CTRL);
 		retry++;
 	}
-- 
2.0.4

