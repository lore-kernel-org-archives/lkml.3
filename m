Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986AbaERP7A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 11:59:00 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:58868 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888AbaERP66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 11:58:58 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>,
        Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        support@lsi.com, DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] message: fusion: mptscsih.c:  Fix for possible null pointer dereference
Date: Sun, 18 May 2014 17:59:43 +0200
Message-Id: <1400428783-10162-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is otherwise a risk of a possible null pointer dereference.

Was largely found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/message/fusion/mptscsih.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index 727819c..b323b23 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -1279,9 +1279,11 @@ mptscsih_info(struct Scsi_Host *SChost)
 
 		mpt_print_ioc_summary(h->ioc, h->info_kbuf, &size, 0, 0);
 		h->info_kbuf[size-1] = '\0';
+
+		return h->info_kbuf;
 	}
 
-	return h->info_kbuf;
+	return NULL;
 }
 
 int mptscsih_show_info(struct seq_file *m, struct Scsi_Host *host)
-- 
1.7.10.4

