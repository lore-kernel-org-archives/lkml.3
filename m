Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965175Ab3GCTHq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 15:07:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33268 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965001Ab3GCTA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 15:00:28 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=y9UFkyy-ewIA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=8_r_Nag2vFoA:10 a=DfNHnWVPAAAA:8 a=cm27Pg_UAAAA:8 a=VwQbUJbxAAAA:8 a=fBeKd2HRWbP4T1pgm1MA:9 a=lBRciGGoxdUA:10 a=zv9_9hqRWm8A:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130703184101.381089239@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 14:40:32 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Tyler Hicks <tyhicks@canonical.com>, Paul Taysom <taysom@chromium.org>,
        Olof Johansson <olofj@chromium.org>
Subject: [095/141] eCryptfs: Check return of filemap_write_and_wait during fsync
References: <20130703183857.307196999@goodmis.org>
Content-Disposition: inline; filename=0095-eCryptfs-Check-return-of-filemap_write_and_wait-duri.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.6 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Tyler Hicks <tyhicks@canonical.com>

[ Upstream commit bc5abcf7e411b889f73ea2a90439071a0f451011 ]

Error out of ecryptfs_fsync() if filemap_write_and_wait() fails.

Signed-off-by: Tyler Hicks <tyhicks@canonical.com>
Cc: Paul Taysom <taysom@chromium.org>
Cc: Olof Johansson <olofj@chromium.org>
Cc: stable@vger.kernel.org # v3.6+
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 fs/ecryptfs/file.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/ecryptfs/file.c b/fs/ecryptfs/file.c
index 4f9a25e..9d5dd5c 100644
--- a/fs/ecryptfs/file.c
+++ b/fs/ecryptfs/file.c
@@ -296,7 +296,12 @@ static int ecryptfs_release(struct inode *inode, struct file *file)
 static int
 ecryptfs_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 {
-	filemap_write_and_wait(file->f_mapping);
+	int rc;
+
+	rc = filemap_write_and_wait(file->f_mapping);
+	if (rc)
+		return rc;
+
 	return vfs_fsync(ecryptfs_file_to_lower(file), datasync);
 }
 
-- 
1.7.10.4


