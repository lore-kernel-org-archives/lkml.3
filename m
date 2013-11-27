Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758152Ab3K0A5u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 19:57:50 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39067 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757690Ab3K0A5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:57:40 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Weston Andros Adamson <dros@netapp.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [PATCH 3.10 50/80] NFSv4: dont fail on missing fattr in open recover
Date: Tue, 26 Nov 2013 16:57:19 -0800
Message-Id: <20131127005644.426351481@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131127005640.934155527@linuxfoundation.org>
References: <20131127005640.934155527@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weston Andros Adamson <dros@netapp.com>

commit a43ec98b72aae3e330f0673438f58316c3769b84 upstream.

This is an unneeded check that could cause the client to fail to recover
opens.

Signed-off-by: Weston Andros Adamson <dros@netapp.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/nfs4proc.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -1165,12 +1165,6 @@ _nfs4_opendata_reclaim_to_nfs4_state(str
 		goto err;
 	}
 
-	ret = -ESTALE;
-	if (!(data->f_attr.valid & NFS_ATTR_FATTR_TYPE) ||
-	    !(data->f_attr.valid & NFS_ATTR_FATTR_FILEID) ||
-	    !(data->f_attr.valid & NFS_ATTR_FATTR_CHANGE))
-		goto err;
-
 	ret = -ENOMEM;
 	state = nfs4_get_open_state(inode, data->owner);
 	if (state == NULL)


