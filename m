Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754995Ab3CRUV1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 16:21:27 -0400
Received: from p3plsmtps2ded04.prod.phx3.secureserver.net ([208.109.80.198]:57771
	"EHLO p3plsmtps2ded04.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754034Ab3CRUV0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 16:21:26 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        andi@firstfloor.org, akpm@linux-foundation.org, linux-mm@kvack.org,
        kamezawa.hiroyuki@gmail.com, mhocko@suse.cz, hannes@cmpxchg.org,
        yinghan@google.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH V2 1/3]  mm: Export split_page()
Date: Mon, 18 Mar 2013 13:51:36 -0700
Message-Id: <1363639898-1615-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1363639873-1576-1-git-send-email-kys@microsoft.com>
References: <1363639873-1576-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This symbol would be used in the Hyper-V balloon driver to support 2M
allocations.

In this version of the patch, based on feedback from Michal Hocko
<mhocko@suse.cz>, I have updated the patch description.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 mm/page_alloc.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 6cacfee..7e0ead6 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1404,6 +1404,7 @@ void split_page(struct page *page, unsigned int order)
 	for (i = 1; i < (1 << order); i++)
 		set_page_refcounted(page + i);
 }
+EXPORT_SYMBOL_GPL(split_page);
 
 static int __isolate_free_page(struct page *page, unsigned int order)
 {
-- 
1.7.4.1

