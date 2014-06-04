Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751926AbaFDVcD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 17:32:03 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:41193 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290AbaFDVcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 17:32:01 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
        Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: bfa: bfad_attr.c:  Cleaning up missing null-terminate after strncpy call
Date: Wed,  4 Jun 2014 23:32:55 +0200
Message-Id: <1401917575-2954-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added a guaranteed null-terminate after call to strncpy.

This was partly found using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/scsi/bfa/bfad_attr.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/bfa/bfad_attr.c b/drivers/scsi/bfa/bfad_attr.c
index 40be670..06aa3dd 100644
--- a/drivers/scsi/bfa/bfad_attr.c
+++ b/drivers/scsi/bfa/bfad_attr.c
@@ -843,7 +843,8 @@ bfad_im_symbolic_name_show(struct device *dev, struct device_attribute *attr,
 
 	bfa_fcs_lport_get_attr(&bfad->bfa_fcs.fabric.bport, &port_attr);
 	strncpy(symname, port_attr.port_cfg.sym_name.symname,
-			BFA_SYMNAME_MAXLEN);
+			sizeof(symname));
+	symname[sizeof(symname) - 1] = '\0';
 	return snprintf(buf, PAGE_SIZE, "%s\n", symname);
 }
 
-- 
1.7.10.4

