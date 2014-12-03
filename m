Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754387AbaLCAmx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 19:42:53 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47134 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751017AbaLCAmv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 19:42:51 -0500
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 2/2] posix_fadvise.2: Document the behaviour of partial page discard requests
Date: Wed,  3 Dec 2014 00:42:47 +0000
Message-Id: <1417567367-9298-3-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1417567367-9298-1-git-send-email-mgorman@suse.de>
References: <1417567367-9298-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is not obvious from the interface that partial page discard requests
are ignored. It should be spelled out.

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 man2/posix_fadvise.2 | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/man2/posix_fadvise.2 b/man2/posix_fadvise.2
index 25d0c50..07313a9 100644
--- a/man2/posix_fadvise.2
+++ b/man2/posix_fadvise.2
@@ -144,6 +144,11 @@ A program may periodically request the kernel to free cached data
 that has already been used, so that more useful cached pages are not
 discarded instead.
 
+Requests to discard partial pages are ignored. It is preferable to preserve
+needed data than discard unneeded data. If the application requires that
+data be considered for discarding then \fIoffset\fP and \fIlen\fP must be
+page-aligned.
+
 Pages that have not yet been written out will be unaffected, so if the
 application wishes to guarantee that pages will be released, it should
 call
