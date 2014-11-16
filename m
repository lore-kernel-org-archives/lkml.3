Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755039AbaKPKDc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 05:03:32 -0500
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:14235 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752771AbaKPKDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 05:03:31 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtcNAHN1aFRbsk2U/2dsb2JhbABbgw6BLrhMBQF1mhWBChcBAQEBAX2EMC8jgRo3iEUBwGiPbYY+imQdhDUFnkyWeoFHAYI1PDCCSwEBAQ
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Peter Huewe <peterhuewe@gmx.de>,
        Ashley Lai <ashley@ashleylai.com>,
        Marcel Selhorst <tpmdd@selhorst.net>,
        tpmdd-devel@lists.sourceforge.net
Subject: [PATCH 1/1 linux-next] tpm: remove unnecessary sizeof(u8)
Date: Sun, 16 Nov 2014 11:03:24 +0100
Message-Id: <1416132204-12714-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sizeof(u8) is always 1.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/char/tpm/tpm_i2c_stm_st33.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/tpm/tpm_i2c_stm_st33.c b/drivers/char/tpm/tpm_i2c_stm_st33.c
index 4669e37..5271b75 100644
--- a/drivers/char/tpm/tpm_i2c_stm_st33.c
+++ b/drivers/char/tpm/tpm_i2c_stm_st33.c
@@ -635,13 +635,13 @@ tpm_st33_i2c_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	}
 
 	platform_data->tpm_i2c_buffer[0] =
-	    kmalloc(TPM_BUFSIZE * sizeof(u8), GFP_KERNEL);
+	    kmalloc(TPM_BUFSIZE, GFP_KERNEL);
 	if (platform_data->tpm_i2c_buffer[0] == NULL) {
 		err = -ENOMEM;
 		goto _tpm_clean_answer;
 	}
 	platform_data->tpm_i2c_buffer[1] =
-	    kmalloc(TPM_BUFSIZE * sizeof(u8), GFP_KERNEL);
+	    kmalloc(TPM_BUFSIZE, GFP_KERNEL);
 	if (platform_data->tpm_i2c_buffer[1] == NULL) {
 		err = -ENOMEM;
 		goto _tpm_clean_response1;
-- 
1.9.3

