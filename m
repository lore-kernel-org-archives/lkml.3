Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756995AbaFYOAx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 10:00:53 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:55226 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756662AbaFYOAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 10:00:51 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: xjtuwjp@gmail.com, lindar_liu@usish.com
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: pm8001: pm80xx_hwi.c:  Cleaning up variable is set more than once
Date: Wed, 25 Jun 2014 16:01:47 +0200
Message-Id: <1403704907-25672-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A struct member variable is set to different values without having used in between.

This was found using a static code analysis program called cppcheck

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/scsi/pm8001/pm80xx_hwi.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index d70587f..2698227 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -249,7 +249,6 @@ moreData:
 				sprintf(pm8001_ha->
 					forensic_info.data_buf.direct_data,
 						"%08x ", 4);
-			pm8001_ha->forensic_info.data_buf.read_len = 0xFFFFFFFF;
 			pm8001_ha->forensic_info.data_buf.direct_len =  0;
 			pm8001_ha->forensic_info.data_buf.direct_offset = 0;
 			pm8001_ha->forensic_info.data_buf.read_len = 0;
-- 
1.7.10.4

