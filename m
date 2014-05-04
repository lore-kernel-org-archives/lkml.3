Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755382AbaEDQkf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 12:40:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36131 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754050AbaEDPlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:41:42 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Benny Halevy <bhalevy@primarydata.com>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [PATCH 3.14 072/158] nfsd4: buffer-length check for SUPPATTR_EXCLCREAT
Date: Sun,  4 May 2014 11:39:41 -0400
Message-Id: <20140504154039.704900068@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154029.975081050@linuxfoundation.org>
References: <20140504154029.975081050@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "J. Bruce Fields" <bfields@redhat.com>

commit de3997a7eeb9ea286b15879fdf8a95aae065b4f7 upstream.

This was an omission from 8c18f2052e756e7d5dea712fc6e7ed70c00e8a39
"nfsd41: SUPPATTR_EXCLCREAT attribute".

Cc: Benny Halevy <bhalevy@primarydata.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfsd/nfs4xdr.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -2483,6 +2483,8 @@ out_acl:
 			goto out;
 	}
 	if (bmval2 & FATTR4_WORD2_SUPPATTR_EXCLCREAT) {
+		if ((buflen -= 16) < 0)
+			goto out_resource;
 		WRITE32(3);
 		WRITE32(NFSD_SUPPATTR_EXCLCREAT_WORD0);
 		WRITE32(NFSD_SUPPATTR_EXCLCREAT_WORD1);


