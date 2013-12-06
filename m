Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758119Ab3LFNCM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:02:12 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44087 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758075Ab3LFNCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:02:01 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 112/272] ext4: avoid bh leak in retry path of ext4_expand_extra_isize_ea()
Date: Fri,  6 Dec 2013 12:56:41 +0000
Message-Id: <1386334761-25517-113-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit dcb9917ba041866686fe152850364826c4622a36 upstream.

Reported-by: Dave Jones <davej@redhat.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/ext4/xattr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 03e9beb..1423c48 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1352,6 +1352,7 @@ retry:
 					new_extra_isize = s_min_extra_isize;
 					kfree(is); is = NULL;
 					kfree(bs); bs = NULL;
+					brelse(bh);
 					goto retry;
 				}
 				error = -1;
-- 
1.8.3.2

