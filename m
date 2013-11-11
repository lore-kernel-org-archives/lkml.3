Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595Ab3KKPmS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 10:42:18 -0500
Received: from m53-178.qiye.163.com ([123.58.178.53]:52877 "EHLO
	m53-178.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754480Ab3KKPla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 10:41:30 -0500
From: Li Wang <liwang@ubuntukylin.com>
To: linux-kernel@vger.kernel.org
Cc: ceph-devel@vger.kernel.org, Sage Weil <sage@inktank.com>,
        linux-fsdevel@vger.kernel.org, linux-cifs@vger.kernel.org,
        Milosz Tanski <milosz@adfin.com>, Li Wang <liwang@ubuntukylin.com>
Subject: [PATCH 6/7] Cifs: Implement uncaching single no-data page
Date: Mon, 11 Nov 2013 23:27:28 +0800
Message-Id: <08bbf81e5da33b1a4a6ce8af119acfd2fb8a2760.1384183054.git.liwang@ubuntukylin.com>
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
	SkNPT0NNTkhCVTMWGhIXVRcSDBoVHDsOGQ4VDw4QAhcSFVUYFBZFWVdZDB4ZWUEdGhcIHldZCAFZ
	QUlJTE43V1kSC1lBWUpJSlVISFVJTk5VSktZBg++
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement the routine for uncaching single no-data page, typically
in readpage().

Signed-off-by: Li Wang <liwang@ubuntukylin.com>
---
 fs/cifs/fscache.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/cifs/fscache.c b/fs/cifs/fscache.c
index 8d4b7bc..168f184 100644
--- a/fs/cifs/fscache.c
+++ b/fs/cifs/fscache.c
@@ -223,6 +223,13 @@ void __cifs_readpage_to_fscache(struct inode *inode, struct page *page)
 		fscache_uncache_page(CIFS_I(inode)->fscache, page);
 }
 
+void __cifs_fscache_readpage_cancel(struct inode *inode, struct page *page)
+{
+        cifs_dbg(FYI, "%s: (fsc: %p, i: %p)\n",
+                 __func__, CIFS_I(inode)->fscache, inode);
+        fscache_readpage_cancel(CIFS_I(inode)->fscache, page);
+}
+
 void __cifs_fscache_readpages_cancel(struct inode *inode, struct list_head *pages)
 {
 	cifs_dbg(FYI, "%s: (fsc: %p, i: %p)\n",
-- 
1.7.9.5

