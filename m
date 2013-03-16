Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751949Ab3CPVMG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 17:12:06 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:53978
	"EHLO p3plsmtps2ded02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751326Ab3CPVMC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 17:12:02 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        andi@firstfloor.org, akpm@linux-foundation.org, linux-mm@kvack.org,
        kamezawa.hiroyuki@gmail.com, mhocko@suse.cz, hannes@cmpxchg.org,
        yinghan@google.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 1/2] mm: Export split_page()
Date: Sat, 16 Mar 2013 14:42:04 -0700
Message-Id: <1363470125-24606-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1363470088-24565-1-git-send-email-kys@microsoft.com>
References: <1363470088-24565-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The split_page() function will be very useful for balloon drivers. On Hyper-V,
it will be very efficient to use 2M allocations in the guest as this (a) makes
the ballooning protocol with the host that much more efficient and (b) moving
memory in 2M chunks minimizes fragmentation in the host. Export the split_page()
function to let the guest allocations be in 2M chunks while the host is free to
return this memory at arbitrary granularity.

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

