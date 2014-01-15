Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754304AbaAOWAr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 17:00:47 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41457 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754280AbaAOWAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 17:00:42 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dan Carpenter <dan.carpenter@oracle.com>, Chris Mason <clm@fb.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 049/166] Btrfs: fix access_ok() check in btrfs_ioctl_send()
Date: Wed, 15 Jan 2014 13:51:03 -0800
Message-Id: <1389822780-4729-50-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389822780-4729-1-git-send-email-kamal@canonical.com>
References: <1389822780-4729-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.16 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 700ff4f095d78af0998953e922e041d75254518b upstream.

The closing parenthesis is in the wrong place.  We want to check
"sizeof(*arg->clone_sources) * arg->clone_sources_count" instead of
"sizeof(*arg->clone_sources * arg->clone_sources_count)".

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Jie Liu <jeff.liu@oracle.com>
Signed-off-by: Chris Mason <clm@fb.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/btrfs/send.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 321b7fb..a89d788 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -4555,8 +4555,8 @@ long btrfs_ioctl_send(struct file *mnt_file, void __user *arg_)
 	}
 
 	if (!access_ok(VERIFY_READ, arg->clone_sources,
-			sizeof(*arg->clone_sources *
-			arg->clone_sources_count))) {
+			sizeof(*arg->clone_sources) *
+			arg->clone_sources_count)) {
 		ret = -EFAULT;
 		goto out;
 	}
-- 
1.8.3.2

