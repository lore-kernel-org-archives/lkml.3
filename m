Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758210Ab3KIC0c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 21:26:32 -0500
Received: from m53-178.qiye.163.com ([123.58.178.53]:56278 "EHLO
	m53-178.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757752Ab3KIC03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 21:26:29 -0500
From: Li Wang <liwang@ubuntukylin.com>
To: ceph-devel@vger.kernel.org
Cc: linux-cachefs@redhat.com, Sage Weil <sage@inktank.com>,
        Milosz Tanski <milosz@adfin.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Li Wang <liwang@ubuntukylin.com>
Subject: [PATCH] Ceph: allocate non-zero page to fscache in readpage()
Date: Sat,  9 Nov 2013 10:26:06 +0800
Message-Id: <1383963966-10888-1-git-send-email-liwang@ubuntukylin.com>
X-Mailer: git-send-email 1.7.9.5
X-HM-Spam-Status: e1koWUFPN1dZCBgUCR5ZQUpMVUNJQkJCQkJJSExLTUtOTldZCQ4XHghZQV
	koKz0kKzooKCQyNSQzPjo*PilBS1VLQDYjJCI#KCQyNSQzPjo*PilBS1VLQCsvKSQ1NCQyNSQzPj
	o*PilBSVVLQDg0LjUvKSIkODVBS1VLQCk#PDI0NSQ6KDI6QUtVS0ArKTQtMjU4PiQzLjU6NUFLVU
	tAPyI1OjYyOCQyKyQ1NCQyNSQzPjo*PilBS1VLQCk#OjckMiskMjUkKTk3JDI1JDM#Oj8#KUFKSV
	VLQDYuNy8yJCk4Ky8kPzI9PT4pPjUvJDI1JDM#Oj8#KUFJVUtAMiskLzQ*OiIkODUvJEskSktLQU
	tVS0AyKyROJDYyNS4vPiQ4NS8kSyRKS0FLVUtAMiskSEskNjI1Li8#JDg1LyRLJE5LQUtVS0AyKy
	RKJDM0LikkODUvJEskSktLQUtVS0AyKyRKJDYyNS4vPiQ4NS8kSyRKS0FLVUtAKC45JD5BSlVOTk
	A9NSQoLjkkPjUsNCk*KCQzNzEkSktLSUtKQUtVSUNZBg++
X-HM-Sender-Digest: e1kSHx4VD1lBWUc6MQg6Cjo4LDo4EDorKjhIOj4qOkMwCjFVSlVKSENI
	Qk1IQkNMT0JMVTMWGhIXVRcSDBoVHDsOGQ4VDw4QAhcSFVUYFBZFWVdZDB4ZWUEdGhcIHldZCAFZ
	QUpOSUg3V1kSC1lBWUlJSVVJT0tVSkxMVUhPWQY+
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ceph_osdc_readpages() returns number of bytes read, currently,
the code only allocate full-zero page into fscache, this patch
fixes this.

Signed-off-by: Li Wang <liwang@ubuntukylin.com>
---
 fs/ceph/addr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 6df8bd4..1e561c0 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -216,7 +216,7 @@ static int readpage_nounlock(struct file *filp, struct page *page)
 	}
 	SetPageUptodate(page);
 
-	if (err == 0)
+	if (err >= 0)
 		ceph_readpage_to_fscache(inode, page);
 
 out:
-- 
1.7.9.5

