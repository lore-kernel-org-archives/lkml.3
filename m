Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339Ab3LZOa4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 09:30:56 -0500
Received: from m199-177.yeah.net ([123.58.177.199]:56471 "EHLO
	m199-177.yeah.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753145Ab3LZOav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 09:30:51 -0500
From: Li Wang <liwang@ubuntukylin.com>
To: ceph-devel@vger.kernel.org
Cc: Sage Weil <sage@inktank.com>, Milosz Tanski <milosz@adfin.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yunchuan Wen <yunchuanwen@ubuntukylin.com>,
        Min Chen <minchen@ubuntukylin.com>, Li Wang <liwang@ubuntukylin.com>
Subject: [PATCH 1/3] Ceph fscache: Add an interface to synchronize object store limit
Date: Thu, 26 Dec 2013 06:29:26 -0800
Message-Id: <ac5d506a62b697c2f79ac916ef4030290f94956b.1388066937.git.liwang@ubuntukylin.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1388066937.git.liwang@ubuntukylin.com>
References: <cover.1388066937.git.liwang@ubuntukylin.com>
In-Reply-To: <cover.1388066937.git.liwang@ubuntukylin.com>
References: <cover.1388066937.git.liwang@ubuntukylin.com>
X-HM-Spam-Status: e1koWUFPN1dZCBgUCR5ZQU9MVUhKSUJCTkJKS01PT05IV1kJDhceCFlBWS
	grPSQoND0vPToyNyQyNSQzPjo*PilBTVVKSEJANiMkIj4oJDI1JDM#Oj8#KUFLVUhPSUArLykkNT
	QkMjUkMz46Pz4pQUlVQ05DQDg0LjUvKSIkODVBS1VJTUNAKT48MjQ1JDooMjpBSFVPT01AKyk0LT
	I1OD4kMy41OjVBQlVCSk5APyI1OjYyOCQyKyQ1NCQyNSQzPjo*PilBS1VMQ0JAPzAyNiQ1NDU#QU
	tVS0ApPjo3JDIrJDI1JCk5NyQyNSQzPjo*PilBTFVLS0NANi43LzIkKTgrLyQ*Mj09Pik#NS8kMj
	UkMz46Pz4pQU9VS0tJQDIrJC80PzoiJDg1LyRLJEpLS0FLVUxKTUAyKyRKJDM0LikkODUvJEskSk
	tLQUtVS0AyKyRKJDYyNS4vPiQ4NS8kSyRKS0FLVUtAMiskTiQ2MjUuLz4kODUvJEskSktBS1VLQD
	IrJEhLJDYyNS4vPiQ4NS8kSyROS0FLVUtANTQvJD06NjQuKCQ*NDY6MjUkKCs9JD06MjdBSktVS0
	AoLjkkPkFKVU5OQD01JCguOSQ#NSw0KT8oJDM3MSRKS0tJS0pBS1VJQ1kG
X-HM-Sender-Digest: e1kSHx4VD1lBWUc6MQg6Cjo4LDo4EDorKjhIOj4qOkMwCjFVSlVKSEND
	S01DSU9OTkNCVTMWGhIXVRcSDBoVHDsOGQ4VDw4QAhcSFVUYFBZFWVdZDB4ZWUEdGhcIHldZCAFZ
	QUlMQkw3V1kSC1lBWU1KVUpDTFVOT1VCWQY+
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yunchuan Wen <yunchuanwen@ubuntukylin.com>

Add an interface to explicitly synchronize object->store_limit[_l]
with inode->i_size

Signed-off-by: Yunchuan Wen <yunchuanwen@ubuntukylin.com>
Signed-off-by: Min Chen <minchen@ubuntukylin.com>
Signed-off-by: Li Wang <liwang@ubuntukylin.com>
---
 fs/ceph/cache.h |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/ceph/cache.h b/fs/ceph/cache.h
index ba94940..262106b 100644
--- a/fs/ceph/cache.h
+++ b/fs/ceph/cache.h
@@ -48,6 +48,12 @@ void ceph_readpage_to_fscache(struct inode *inode, struct page *page);
 void ceph_invalidate_fscache_page(struct inode* inode, struct page *page);
 void ceph_queue_revalidate(struct inode *inode);
 
+static inline void ceph_fscache_update_objectsize(struct inode *inode)
+{
+	struct ceph_inode_info *ci = ceph_inode(inode);
+	fscache_attr_changed(ci->fscache);
+}
+
 static inline void ceph_fscache_invalidate(struct inode *inode)
 {
 	fscache_invalidate(ceph_inode(inode)->fscache);
@@ -127,6 +133,10 @@ static inline void ceph_readpage_to_fscache(struct inode *inode,
 {
 }
 
+static inline void ceph_fscache_update_objectsize(struct inode *inode)
+{
+}
+
 static inline void ceph_fscache_invalidate(struct inode *inode)
 {
 }
-- 
1.7.9.5

