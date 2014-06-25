Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757272AbaFYOhK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 10:37:10 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:39072 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757066AbaFYOhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 10:37:07 -0400
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
Subject: [PATCH] staging: bcm: nvm.c:  Cleaning up check unsigned is less than zero
Date: Wed, 25 Jun 2014 16:38:01 +0200
Message-Id: <1403707081-27193-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove checking if a unsigned int is less than zero

This was found using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/staging/bcm/nvm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/bcm/nvm.c b/drivers/staging/bcm/nvm.c
index 63be3be..0061968 100644
--- a/drivers/staging/bcm/nvm.c
+++ b/drivers/staging/bcm/nvm.c
@@ -3321,7 +3321,7 @@ int BcmSetActiveSection(struct bcm_mini_adapter *Adapter, enum bcm_flash2x_secti
 
 			SectImagePriority = ReadISOPriority(Adapter, HighestPriISO) + 1;
 
-			if ((SectImagePriority <= 0) && IsSectionWritable(Adapter, HighestPriISO)) {
+			if ((SectImagePriority == 0) && IsSectionWritable(Adapter, HighestPriISO)) {
 				/* This is a SPECIAL Case which will only happen if the current highest priority ISO has priority value = 0x7FFFFFFF.
 				 * We will write 1 to the current Highest priority ISO And then shall increase the priority of the requested ISO
 				 * by user
@@ -3381,7 +3381,7 @@ int BcmSetActiveSection(struct bcm_mini_adapter *Adapter, enum bcm_flash2x_secti
 			}
 
 			SectImagePriority = ReadDSDPriority(Adapter, HighestPriDSD) + 1;
-			if (SectImagePriority <= 0) {
+			if (SectImagePriority == 0) {
 				/* This is a SPECIAL Case which will only happen if the current highest priority DSD has priority value = 0x7FFFFFFF.
 				 * We will write 1 to the current Highest priority DSD And then shall increase the priority of the requested DSD
 				 * by user
-- 
1.7.10.4

