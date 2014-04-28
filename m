Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346AbaD1Bcq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 21:32:46 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42885 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752565AbaD1B3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 21:29:21 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Benny Halevy" <bhalevy@primarydata.com>,
        "J. Bruce Fields" <bfields@redhat.com>
Date: Mon, 28 Apr 2014 02:11:22 +0100
Message-ID: <lsq.1398647482.94239108@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 61/94] nfsd4: buffer-length check for SUPPATTR_EXCLCREAT
In-Reply-To: <lsq.1398647481.453080089@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.58-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: "J. Bruce Fields" <bfields@redhat.com>

commit de3997a7eeb9ea286b15879fdf8a95aae065b4f7 upstream.

This was an omission from 8c18f2052e756e7d5dea712fc6e7ed70c00e8a39
"nfsd41: SUPPATTR_EXCLCREAT attribute".

Cc: Benny Halevy <bhalevy@primarydata.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/nfsd/nfs4xdr.c | 2 ++
 1 file changed, 2 insertions(+)

--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -2413,6 +2413,8 @@ out_acl:
 		WRITE64(stat.ino);
 	}
 	if (bmval2 & FATTR4_WORD2_SUPPATTR_EXCLCREAT) {
+		if ((buflen -= 16) < 0)
+			goto out_resource;
 		WRITE32(3);
 		WRITE32(NFSD_SUPPATTR_EXCLCREAT_WORD0);
 		WRITE32(NFSD_SUPPATTR_EXCLCREAT_WORD1);

