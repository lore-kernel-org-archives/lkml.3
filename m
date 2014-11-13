Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964997AbaKMVbL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 16:31:11 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:40098 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934330AbaKMVbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 16:31:08 -0500
From: Pieter Smith <pieter@boesman.nl>
To: pieter@boesman.nl
Cc: Josh Triplett <josh@joshtriplett.org>, Jan Kara <jack@suse.cz>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 43/56] fs/udf: support compiling out splice
Date: Thu, 13 Nov 2014 22:23:20 +0100
Message-Id: <1415913813-362-44-git-send-email-pieter@boesman.nl>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415913813-362-1-git-send-email-pieter@boesman.nl>
References: <pieter@boesman.nl>
 <1415913813-362-1-git-send-email-pieter@boesman.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compile out splice support from udf when the splice-family of syscalls is not
supported by the system (i.e. CONFIG_SYSCALL_SPLICE is undefined).

Signed-off-by: Pieter Smith <pieter@boesman.nl>
---
 fs/udf/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/udf/file.c b/fs/udf/file.c
index 86c6743..65e5335 100644
--- a/fs/udf/file.c
+++ b/fs/udf/file.c
@@ -242,7 +242,7 @@ const struct file_operations udf_file_operations = {
 	.write_iter		= udf_file_write_iter,
 	.release		= udf_release_file,
 	.fsync			= generic_file_fsync,
-	.splice_read		= generic_file_splice_read,
+	SPLICE_READ_INIT(generic_file_splice_read)
 	.llseek			= generic_file_llseek,
 };
 
-- 
1.9.1

