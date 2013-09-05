Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753868Ab3IEEE0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 00:04:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44760 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750701Ab3IEEEZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 00:04:25 -0400
Date: Thu, 5 Sep 2013 00:04:18 -0400
From: Dave Jones <davej@redhat.com>
To: viro@zeniv.linux.org.uk
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] Fix missing braces in ncpfs:ncp_lookup
Message-ID: <20130905040418.GA20210@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, viro@zeniv.linux.org.uk,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dave Jones <davej@fedoraproject.org>

diff --git a/fs/ncpfs/dir.c b/fs/ncpfs/dir.c
index 3be0474..1f6419f 100644
--- a/fs/ncpfs/dir.c
+++ b/fs/ncpfs/dir.c
@@ -857,10 +857,11 @@ static struct dentry *ncp_lookup(struct inode *dir, struct dentry *dentry, unsig
 	if (ncp_is_server_root(dir)) {
 		res = ncp_io2vol(server, __name, &len, dentry->d_name.name,
 				 dentry->d_name.len, 1);
-		if (!res)
+		if (!res) {
 			res = ncp_lookup_volume(server, __name, &(finfo.i));
 			if (!res)
 				ncp_update_known_namespace(server, finfo.i.volNumber, NULL);
+		}
 	} else {
 		res = ncp_io2vol(server, __name, &len, dentry->d_name.name,
 				 dentry->d_name.len, !ncp_preserve_case(dir));
