Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933160AbaEMKCr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 06:02:47 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:60828 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760075AbaEMJ24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:28:56 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "J. Bruce Fields" <bfields@redhat.com>,
        Benny Halevy <bhalevy@primarydata.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 058/182] nfsd4: buffer-length check for SUPPATTR_EXCLCREAT
Date: Tue, 13 May 2014 11:26:50 +0200
Message-Id: <4730853e4fe2462d3aeea298409993468e1e3992.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "J. Bruce Fields" <bfields@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit de3997a7eeb9ea286b15879fdf8a95aae065b4f7 upstream.

This was an omission from 8c18f2052e756e7d5dea712fc6e7ed70c00e8a39
"nfsd41: SUPPATTR_EXCLCREAT attribute".

Cc: Benny Halevy <bhalevy@primarydata.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/nfsd/nfs4xdr.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index ecc735e30bea..0407ba4990e0 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -2502,6 +2502,8 @@ out_acl:
 			goto out;
 	}
 	if (bmval2 & FATTR4_WORD2_SUPPATTR_EXCLCREAT) {
+		if ((buflen -= 16) < 0)
+			goto out_resource;
 		WRITE32(3);
 		WRITE32(NFSD_SUPPATTR_EXCLCREAT_WORD0);
 		WRITE32(NFSD_SUPPATTR_EXCLCREAT_WORD1);
-- 
1.9.3

