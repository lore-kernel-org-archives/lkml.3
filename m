Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932153Ab3ERDGm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 23:06:42 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23572 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932089Ab3ERDA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 23:00:27 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=6aaLHPvUsN8A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=iwrYbM9pwCUA:10 a=CjxXgO3LAAAA:8 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=Op-mwl0xAAAA:8 a=aCPqOQJ_S1qBLZ7JjQ4A:9 a=rC2wZJ5BpNYA:10 a=MSl-tDqOz04A:10 a=d4CUUju0HPYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021654.956006331@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:17:19 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Elad Yi <elad.yi@gmail.com>, Philip Rakity <prakity@yahoo.com>,
        Chris Ball <cjb@laptop.org>
Subject: [ 082/136 ] mmc: core: Fix bit width test failing on old eMMC cards
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0082-mmc-core-Fix-bit-width-test-failing-on-old-eMMC-card.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Philip Rakity <prakity@yahoo.com>

[ Upstream commit 836dc2fe89c968c10cada87e0dfae6626f8f9da3 ]

PARTITION_SUPPORT needs to be set before doing the compare on version
number so the bit width test does not get invalid data.  Before this
patch, a Sandisk iNAND eMMC card would detect 1-bit width although
the hardware supports 4-bit.

Only affects old emmc devices - pre 4.4 devices.

Reported-by: Elad Yi <elad.yi@gmail.com>
Signed-off-by: Philip Rakity <prakity@yahoo.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Chris Ball <cjb@laptop.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/mmc/core/mmc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
index 396b258..246750e 100644
--- a/drivers/mmc/core/mmc.c
+++ b/drivers/mmc/core/mmc.c
@@ -368,13 +368,13 @@ static int mmc_read_ext_csd(struct mmc_card *card, u8 *ext_csd)
 		ext_csd[EXT_CSD_SEC_FEATURE_SUPPORT];
 	card->ext_csd.raw_trim_mult =
 		ext_csd[EXT_CSD_TRIM_MULT];
+	card->ext_csd.raw_partition_support = ext_csd[EXT_CSD_PARTITION_SUPPORT];
 	if (card->ext_csd.rev >= 4) {
 		/*
 		 * Enhanced area feature support -- check whether the eMMC
 		 * card has the Enhanced area enabled.  If so, export enhanced
 		 * area offset and size to user by adding sysfs interface.
 		 */
-		card->ext_csd.raw_partition_support = ext_csd[EXT_CSD_PARTITION_SUPPORT];
 		if ((ext_csd[EXT_CSD_PARTITION_SUPPORT] & 0x2) &&
 		    (ext_csd[EXT_CSD_PARTITION_ATTRIBUTE] & 0x1)) {
 			hc_erase_grp_sz =
-- 
1.7.10.4


