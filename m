Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932775AbaEEMul (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 08:50:41 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:41029 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932314AbaEEMne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 08:43:34 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 09/50] dcache: restore error on restart in prepend_path
Date: Mon,  5 May 2014 14:42:51 +0200
Message-Id: <12716b1214464dc9b5d418f8e7a9f465ae03e241.1399292849.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <7d4f4737432af6216e86975e587331b9d8b08063.1399292849.git.jslaby@suse.cz>
References: <7d4f4737432af6216e86975e587331b9d8b08063.1399292849.git.jslaby@suse.cz>
In-Reply-To: <cover.1399292849.git.jslaby@suse.cz>
References: <cover.1399292849.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

We need to restore all variables including error (as it is done in the
upstream kernel). The variable error was errorneously not restored when
backporting the patch ede4cebce16f5643c61aedd6d88d9070a1d23a68
(prepend_path() needs to reinitialize dentry/vfsmount/mnt on restarts).

This should be applied only to the 3.12 series.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/dcache.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/dcache.c b/fs/dcache.c
index 30b38e23caa7..008f524e195a 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -2893,6 +2893,7 @@ static int prepend_path(const struct path *path,
 restart:
 	bptr = *buffer;
 	blen = *buflen;
+	error = 0;
 	dentry = path->dentry;
 	vfsmnt = path->mnt;
 	mnt = real_mount(vfsmnt);
-- 
1.9.2

