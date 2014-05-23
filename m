Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524AbaEWJoq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 05:44:46 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:41638 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbaEWJoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 05:44:25 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, akpm@linux-foundation.org, apw@canonical.com,
        nbd@openwrt.org, neilb@suse.de, jordipujolp@gmail.com,
        ezk@fsl.cs.sunysb.edu, dhowells@redhat.com, sedat.dilek@gmail.com,
        hooanon05@yahoo.co.jp, mszeredi@suse.cz
Subject: [PATCH 13/13] vfs: dcache: Export d_ancestor to modules
Date: Fri, 23 May 2014 11:43:43 +0200
Message-Id: <1400838223-30844-14-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1400838223-30844-1-git-send-email-miklos@szeredi.hu>
References: <1400838223-30844-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sedat Dilek <sedat.dilek@gmail.com>

With OverlayFS v22 I get the following build error when
CONFIG_OVERLAYFS_FS=m

ERROR: "d_ancestor" [fs/overlayfs/overlayfs.ko] undefined!

Fix this by adding the missing export.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/dcache.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/dcache.c b/fs/dcache.c
index 42ae01eefc07..b233bfc849de 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -2559,6 +2559,7 @@ struct dentry *d_ancestor(struct dentry *p1, struct dentry *p2)
 	}
 	return NULL;
 }
+EXPORT_SYMBOL(d_ancestor);
 
 /*
  * This helper attempts to cope with remotely renamed directories
-- 
1.8.1.4

