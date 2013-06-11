Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757043Ab3FKUMi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 16:12:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41985 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756574Ab3FKUEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 16:04:06 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tyler Hicks <tyhicks@canonical.com>, Paul Taysom <taysom@chromium.org>,
        Olof Johansson <olofj@chromium.org>
Subject: [ 51/79] eCryptfs: Check return of filemap_write_and_wait during fsync
Date: Tue, 11 Jun 2013 13:03:17 -0700
Message-Id: <20130611195322.800333846@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.254.g5578ad7
In-Reply-To: <20130611195312.352656079@linuxfoundation.org>
References: <20130611195312.352656079@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tyler Hicks <tyhicks@canonical.com>

commit bc5abcf7e411b889f73ea2a90439071a0f451011 upstream.

Error out of ecryptfs_fsync() if filemap_write_and_wait() fails.

Signed-off-by: Tyler Hicks <tyhicks@canonical.com>
Cc: Paul Taysom <taysom@chromium.org>
Cc: Olof Johansson <olofj@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ecryptfs/file.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/fs/ecryptfs/file.c
+++ b/fs/ecryptfs/file.c
@@ -294,7 +294,12 @@ static int ecryptfs_release(struct inode
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
 


