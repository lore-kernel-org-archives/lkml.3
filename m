Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752594Ab3GTIkQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 04:40:16 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44624 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958Ab3GTIji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 04:39:38 -0400
From: John Johansen <john.johansen@canonical.com>
To: linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 02/12] apparmor: add a features/policy dir to interface
Date: Sat, 20 Jul 2013 01:38:37 -0700
Message-Id: <1374309527-7082-3-git-send-email-john.johansen@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374309527-7082-1-git-send-email-john.johansen@canonical.com>
References: <1374309527-7082-1-git-send-email-john.johansen@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a policy directory to features to contain features that can affect
policy compilation but do not affect mediation. Eg of such features would
be types of dfa compression supported, etc.

Signed-off-by: John Johansen <john.johansen@canonical.com>
Acked-by: Kees Cook <kees@ubuntu.com>
---
 security/apparmor/apparmorfs.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/security/apparmor/apparmorfs.c b/security/apparmor/apparmorfs.c
index 16c15ec..ad6c748 100644
--- a/security/apparmor/apparmorfs.c
+++ b/security/apparmor/apparmorfs.c
@@ -198,7 +198,12 @@ static struct aa_fs_entry aa_fs_entry_domain[] = {
 	{ }
 };
 
+static struct aa_fs_entry aa_fs_entry_policy[] = {
+	{}
+};
+
 static struct aa_fs_entry aa_fs_entry_features[] = {
+	AA_FS_DIR("policy",			aa_fs_entry_policy),
 	AA_FS_DIR("domain",			aa_fs_entry_domain),
 	AA_FS_DIR("file",			aa_fs_entry_file),
 	AA_FS_FILE_U64("capability",		VFS_CAP_FLAGS_MASK),
-- 
1.8.1.2

