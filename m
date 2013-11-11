Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676Ab3KKPmt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 10:42:49 -0500
Received: from m53-178.qiye.163.com ([123.58.178.53]:52836 "EHLO
	m53-178.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754262Ab3KKPl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 10:41:26 -0500
From: Li Wang <liwang@ubuntukylin.com>
To: linux-kernel@vger.kernel.org
Cc: ceph-devel@vger.kernel.org, Sage Weil <sage@inktank.com>,
        linux-fsdevel@vger.kernel.org, linux-cifs@vger.kernel.org,
        Milosz Tanski <milosz@adfin.com>, Li Wang <liwang@ubuntukylin.com>
Subject: [PATCH 1/7] Fscache: Introduce new API fscache_readpage_cancel()
Date: Mon, 11 Nov 2013 23:27:23 +0800
Message-Id: <ec97baea70056e5546bc8df0ba29e30edb057b76.1384183054.git.liwang@ubuntukylin.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1384183054.git.liwang@ubuntukylin.com>
References: <cover.1384183054.git.liwang@ubuntukylin.com>
In-Reply-To: <cover.1384183054.git.liwang@ubuntukylin.com>
References: <cover.1384183054.git.liwang@ubuntukylin.com>
X-HM-Spam-Status: e1koWUFPN1dZCBgUCR5ZQU5VQ0hLS0tLT0tLTk9ISUpIV1kJDhceCFlBWS
	grPSQrOigoJDI1JDM#Oj8#KUFLVUtANiMkIj4oJDI1JDM#Oj8#KUFLVUtAKy8pJDU0JDI1JDM#Oj
	8#KUFJVUtAODQuNS8pIiQ4NUFLVUtAKT48MjQ1JDooMjpBS1VLQCspNC0yNTg#JDwuOjU8PzQ1PE
	FLVUtAPyI1OjYyOCQyKyQ1NCQyNSQzPjo*PilBS1VLQDYuNy8yJCk4Ky8kPzI9PT4pPjUvJDI1JD
	M#Oj8#KUFJVUtAMiskLzQ*OiIkODUvJEskSktLQUtVS0AyKyROJDYyNS4vPiQ4NS8kSyRKS0FLVU
	tAMiskSEskNjI1Li8#JDg1LyRLJE5LQUtVS0AyKyRKJDM0LikkODUvJEskSktLQUtVS0AyKyRKJD
	YyNS4vPiQ4NS8kSyRKS0FLVUtAKC45JD5BSlVOTkA9NSQoLjkkPjUsNCk*KCQzNzEkSktLSUtKQU
	tVSUNZBg++
X-HM-Sender-Digest: e1kSHx4VD1lBWUc6MQg6Cjo4LDo4EDorKjhIOj4qOkMwCjFVSlVKSENP
	SkNPT0NPSk9PVTMWGhIXVRcSDBoVHDsOGQ4VDw4QAhcSFVUYFBZFWVdZDB4ZWUEdGhcIHldZCAFZ
	QUlMSUM3V1kSC1lBWUpJSlVISFVJTk5VSktZBg++
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce a new API fscache_readpage_cancel() for uncaching one single
no-data page from fscache.

Signed-off-by: Li Wang <liwang@ubuntukylin.com>
---
 include/linux/fscache.h |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/include/linux/fscache.h b/include/linux/fscache.h
index 115bb81..f1ed21f 100644
--- a/include/linux/fscache.h
+++ b/include/linux/fscache.h
@@ -245,6 +245,8 @@ extern bool __fscache_maybe_release_page(struct fscache_cookie *, struct page *,
 					 gfp_t);
 extern void __fscache_uncache_all_inode_pages(struct fscache_cookie *,
 					      struct inode *);
+extern void __fscache_readpage_cancel(struct fscache_cookie *cookie,
+				      struct page *page);
 extern void __fscache_readpages_cancel(struct fscache_cookie *cookie,
 				       struct list_head *pages);
 extern void __fscache_disable_cookie(struct fscache_cookie *, bool);
@@ -633,6 +635,15 @@ int fscache_alloc_page(struct fscache_cookie *cookie,
 		return -ENOBUFS;
 }
 
+static inline
+void fscache_readpage_cancel(struct fscache_cookie *cookie,
+			     struct page *page)
+{
+	if (fscache_cookie_valid(cookie))
+		__fscache_readpage_cancel(cookie, page);
+}
+
+
 /**
  * fscache_readpages_cancel - Cancel read/alloc on pages
  * @cookie: The cookie representing the inode's cache object.
-- 
1.7.9.5

