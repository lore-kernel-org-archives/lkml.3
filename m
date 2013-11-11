Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691Ab3KKPm4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 10:42:56 -0500
Received: from m53-178.qiye.163.com ([123.58.178.53]:52842 "EHLO
	m53-178.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754440Ab3KKPl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 10:41:26 -0500
From: Li Wang <liwang@ubuntukylin.com>
To: linux-kernel@vger.kernel.org
Cc: ceph-devel@vger.kernel.org, Sage Weil <sage@inktank.com>,
        linux-fsdevel@vger.kernel.org, linux-cifs@vger.kernel.org,
        Milosz Tanski <milosz@adfin.com>, Li Wang <liwang@ubuntukylin.com>
Subject: [PATCH 2/7] Fscache: Implement uncaching single no-data page
Date: Mon, 11 Nov 2013 23:27:24 +0800
Message-Id: <57f79ce8b28f2f0e3837f66c3aa99eb078bc5bf7.1384183054.git.liwang@ubuntukylin.com>
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
	SkNPT0NPTUpLVTMWGhIXVRcSDBoVHDsOGQ4VDw4QAhcSFVUYFBZFWVdZDB4ZWUEdGhcIHldZCAFZ
	QUlKQ0k3V1kSC1lBWUpJSlVISFVJTk5VSktZBg++
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Similar to the routine for multiple pages except
that it takes page * as input rather than list head *.

Signed-off-by: Li Wang <liwang@ubuntukylin.com>
---
 fs/fscache/page.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/fscache/page.c b/fs/fscache/page.c
index 7f5c658..0c69f72 100644
--- a/fs/fscache/page.c
+++ b/fs/fscache/page.c
@@ -721,6 +721,14 @@ nobufs:
 }
 EXPORT_SYMBOL(__fscache_alloc_page);
 
+void __fscache_readpage_cancel(struct fscache_cookie *cookie,
+			       struct page *page)
+{
+	if (PageFsCache(page))
+		__fscache_uncache_page(cookie, page);
+}
+EXPORT_SYMBOL(__fscache_readpage_cancel);
+
 /*
  * Unmark pages allocate in the readahead code path (via:
  * fscache_readpages_or_alloc) after delegating to the base filesystem
-- 
1.7.9.5

