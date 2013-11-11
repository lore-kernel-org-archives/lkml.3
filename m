Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656Ab3KKPml (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 10:42:41 -0500
Received: from m53-178.qiye.163.com ([123.58.178.53]:52852 "EHLO
	m53-178.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754441Ab3KKPl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 10:41:27 -0500
From: Li Wang <liwang@ubuntukylin.com>
To: linux-kernel@vger.kernel.org
Cc: ceph-devel@vger.kernel.org, Sage Weil <sage@inktank.com>,
        linux-fsdevel@vger.kernel.org, linux-cifs@vger.kernel.org,
        Milosz Tanski <milosz@adfin.com>, Li Wang <liwang@ubuntukylin.com>
Subject: [PATCH 3/7] Ceph: Introduce routine for uncaching single no-data page
Date: Mon, 11 Nov 2013 23:27:25 +0800
Message-Id: <a10e4947af6b0c7f5fbaa55e2eb920e9914d88fc.1384183054.git.liwang@ubuntukylin.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1384183054.git.liwang@ubuntukylin.com>
References: <cover.1384183054.git.liwang@ubuntukylin.com>
In-Reply-To: <cover.1384183054.git.liwang@ubuntukylin.com>
References: <cover.1384183054.git.liwang@ubuntukylin.com>
X-HM-Spam-Status: e1koWUFPN1dZCBgUCR5ZQU5VQ0hLS0tLT0tLTk9ISUpIV1kJDhceCFlBWS
	grPSQoND0vPToyNyQyNSQzPjo*PilBS1VLQDYjJCI#KCQyNSQzPjo*PilBS1VLQCsvKSQ1NCQyNS
	QzPjo*PilBSVVLQDg0LjUvKSIkODVBS1VLQCk#PDI0NSQ6KDI6QUtVS0ArKTQtMjU4PiQ8Ljo1PD
	80NTxBS1VLQD8iNTo2MjgkMiskNTQkMjUkMz46Pz4pQUtVS0A2LjcvMiQpOCsvJD8yPT0#KT41Ly
	QyNSQzPjo*PilBSVVLQDIrJC80PzoiJDg1LyRLJEpLS0FLVUtAMiskTiQ2MjUuLz4kODUvJEskSk
	tBS1VLQDIrJEhLJDYyNS4vPiQ4NS8kSyROS0FLVUtAMiskSiQzNC4pJDg1LyRLJEpLS0FLVUtAMi
	skSiQ2MjUuLz4kODUvJEskSktBS1VLQCguOSQ#QUpVTk5APTUkKC45JD41LDQpPygkMzcxJEpLS0
	lLSkFLVUlDWQY+
X-HM-Sender-Digest: e1kSHx4VD1lBWUc6MQg6Cjo4LDo4EDorKjhIOj4qOkMwCjFVSlVKSENP
	SkNPT0NOS0NOVTMWGhIXVRcSDBoVHDsOGQ4VDw4QAhcSFVUYFBZFWVdZDB4ZWUEdGhcIHldZCAFZ
	QUlOTU43V1kSC1lBWUpJSlVISFVJTk5VSktZBg++
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce a routine for uncaching single no-data page, typically
in readpage().

Signed-off-by: Li Wang <liwang@ubuntukylin.com>
---
 fs/ceph/cache.h |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/ceph/cache.h b/fs/ceph/cache.h
index ba94940..eb0ec76 100644
--- a/fs/ceph/cache.h
+++ b/fs/ceph/cache.h
@@ -67,6 +67,14 @@ static inline int ceph_release_fscache_page(struct page *page, gfp_t gfp)
 	return fscache_maybe_release_page(ci->fscache, page, gfp);
 }
 
+
+static inline void cpeh_fscache_readpage_cancel(struct inode *inode,
+						struct page *page)
+{
+	struct ceph_inode_info *ci = ceph_inode(inode);
+	return fscache_readpage_cancel(ci->fscache, page);
+}
+
 static inline void ceph_fscache_readpages_cancel(struct inode *inode,
 						 struct list_head *pages)
 {
@@ -145,6 +153,11 @@ static inline int ceph_release_fscache_page(struct page *page, gfp_t gfp)
 	return 1;
 }
 
+static inline void ceph_fscache_readpage_cancel(struct inode *inode,
+						struct page *page)
+{
+}
+
 static inline void ceph_fscache_readpages_cancel(struct inode *inode,
 						 struct list_head *pages)
 {
-- 
1.7.9.5

