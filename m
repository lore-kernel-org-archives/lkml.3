Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932497Ab3B1Ot2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 09:49:28 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42311 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753758Ab3B1OtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:49:16 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 084/139] quota: autoload the quota_v2 module for QFMT_VFS_V1 quota format
Date: Thu, 28 Feb 2013 14:43:54 +0000
Message-Id: <1362062689-2567-85-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
References: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit c3ad83d9efdfe6a86efd44945a781f00c879b7b4 upstream.

Otherwise, ext4 file systems with the quota featured enable will get a
very confusing "No such process" error message if the quota code is
built as a module and the quota_v2 module has not been loaded.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Acked-by: Jan Kara <jack@suse.cz>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 include/linux/quota.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/quota.h b/include/linux/quota.h
index c09fa04..ffd8607 100644
--- a/include/linux/quota.h
+++ b/include/linux/quota.h
@@ -417,6 +417,7 @@ struct quota_module_name {
 #define INIT_QUOTA_MODULE_NAMES {\
 	{QFMT_VFS_OLD, "quota_v1"},\
 	{QFMT_VFS_V0, "quota_v2"},\
+	{QFMT_VFS_V1, "quota_v2"},\
 	{0, NULL}}
 
 #endif /* __KERNEL__ */
-- 
1.8.1.2

