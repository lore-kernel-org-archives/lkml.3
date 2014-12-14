Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751585AbaLNWen (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 17:34:43 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:55277 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbaLNWeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 17:34:36 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Oleg Drokin <oleg.drokin@intel.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Greg Donald <gdonald@gmail.com>,
        Brilliantov Kirill Vladimirovich <brilliantov@inbox.ru>,
        HPDD-discuss@ml01.01.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: lustre: lustre: osc: lproc_osc.c:  Fix for possible null pointer dereference
Date: Sun, 14 Dec 2014 23:37:18 +0100
Message-Id: <1418596638-24646-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is otherwise a risk of a possible null pointer dereference.

Was largely found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/staging/lustre/lustre/osc/lproc_osc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lustre/osc/lproc_osc.c b/drivers/staging/lustre/lustre/osc/lproc_osc.c
index 9f719bc..9ba6293 100644
--- a/drivers/staging/lustre/lustre/osc/lproc_osc.c
+++ b/drivers/staging/lustre/lustre/osc/lproc_osc.c
@@ -237,13 +237,15 @@ static ssize_t osc_cur_grant_bytes_seq_write(struct file *file, const char *buff
 				  size_t count, loff_t *off)
 {
 	struct obd_device *obd = ((struct seq_file *)file->private_data)->private;
-	struct client_obd *cli = &obd->u.cli;
+	struct client_obd *cli;
 	int		rc;
 	__u64	      val;
 
 	if (obd == NULL)
 		return 0;
 
+	cli = &obd->u.cli;
+
 	rc = lprocfs_write_u64_helper(buffer, count, &val);
 	if (rc)
 		return rc;
-- 
1.7.10.4

