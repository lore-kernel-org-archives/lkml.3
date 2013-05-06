Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760705Ab3EFXPz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 19:15:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37004 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932604Ab3EFXOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 19:14:15 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Elad Yi <elad.yi@gmail.com>, Philip Rakity <prakity@yahoo.com>,
        Chris Ball <cjb@laptop.org>
Subject: [ 101/104] mmc: core: Fix bit width test failing on old eMMC cards
Date: Mon,  6 May 2013 16:13:00 -0700
Message-Id: <20130506230053.998097464@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130506230043.526528358@linuxfoundation.org>
References: <20130506230043.526528358@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Philip Rakity <prakity@yahoo.com>

commit 836dc2fe89c968c10cada87e0dfae6626f8f9da3 upstream.

PARTITION_SUPPORT needs to be set before doing the compare on version
number so the bit width test does not get invalid data.  Before this
patch, a Sandisk iNAND eMMC card would detect 1-bit width although
the hardware supports 4-bit.

Only affects old emmc devices - pre 4.4 devices.

Reported-by: Elad Yi <elad.yi@gmail.com>
Signed-off-by: Philip Rakity <prakity@yahoo.com>
Signed-off-by: Chris Ball <cjb@laptop.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/core/mmc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mmc/core/mmc.c
+++ b/drivers/mmc/core/mmc.c
@@ -368,13 +368,13 @@ static int mmc_read_ext_csd(struct mmc_c
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


