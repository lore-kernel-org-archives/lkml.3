Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932261AbaFHVo4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2014 17:44:56 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:53292 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753980AbaFHVog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2014 17:44:36 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lisa Nguyen <lisa@xenapiadmin.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Tugce Sirin <ztugcesirin@gmail.com>,
        Masanari Iida <standby24x7@gmail.com>,
        Wenliang Fan <fanwlexca@gmail.com>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        Aldo Iljazi <neonsync1@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: bcm: nvm.c:  Cleaning up a array that is filled incompletely
Date: Sun,  8 Jun 2014 23:45:28 +0200
Message-Id: <1402263928-1961-2-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1402263928-1961-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1402263928-1961-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Array 'SigBuff' is filled incompletely.
Someone forget to multiply for the sizeof type.

This was partly found using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/staging/bcm/nvm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/bcm/nvm.c b/drivers/staging/bcm/nvm.c
index 63be3be..d56ca3b 100644
--- a/drivers/staging/bcm/nvm.c
+++ b/drivers/staging/bcm/nvm.c
@@ -3591,7 +3591,7 @@ int BcmCopyISO(struct bcm_mini_adapter *Adapter, struct bcm_flash2x_copy_section
 
 			if (IsThisHeaderSector == TRUE) {
 				/* If this is header sector write 0xFFFFFFFF at the sig time and in last write sig */
-				memcpy(SigBuff, Buff + sigOffset, MAX_RW_SIZE);
+				memcpy(SigBuff, Buff + sigOffset, sizeof(SigBuff));
 
 				for (i = 0; i < MAX_RW_SIZE; i++)
 					*(Buff + sigOffset + i) = 0xFF;
@@ -3704,7 +3704,7 @@ int BcmCopyISO(struct bcm_mini_adapter *Adapter, struct bcm_flash2x_copy_section
 
 			if (IsThisHeaderSector == TRUE) {
 				/* If this is header sector write 0xFFFFFFFF at the sig time and in last write sig */
-				memcpy(SigBuff, Buff + sigOffset, MAX_RW_SIZE);
+				memcpy(SigBuff, Buff + sigOffset, sizeof(SigBuff));
 
 				for (i = 0; i < MAX_RW_SIZE; i++)
 					*(Buff + sigOffset + i) = 0xFF;
-- 
1.7.10.4

