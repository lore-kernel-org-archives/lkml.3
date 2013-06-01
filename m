Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758868Ab3FAJwx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 05:52:53 -0400
Received: from www17.your-server.de ([213.133.104.17]:60227 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758516Ab3FAJws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 05:52:48 -0400
Message-ID: <1370080363.29224.24.camel@localhost.localdomain>
Subject: [PATCH] GFS2: Cocci spatch "ptr_ret.spatch"
From: Thomas Meyer <thomas@m3y3r.de>
To: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Date: Sat, 01 Jun 2013 11:52:43 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/fs/gfs2/inode.c b/fs/gfs2/inode.c
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -587,7 +587,7 @@ static int gfs2_create_inode(struct inod
 		inode = gfs2_lookupi(dir, &dentry->d_name, 0);
 		gfs2_glock_dq_uninit(ghs);
 		d_instantiate(dentry, inode);
-		return IS_ERR(inode) ? PTR_ERR(inode) : 0;
+		return PTR_RET(inode);
 	}
 	if (error)
 		goto fail_gunlock;


