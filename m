Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934330Ab3CHPw7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 10:52:59 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:44171 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934283Ab3CHPwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 10:52:55 -0500
From: Toshi Kani <toshi.kani@hp.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        isimatu.yasuaki@jp.fujitsu.com, wency@cn.fujitsu.com,
        tangchen@cn.fujitsu.com, Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH 2/2] mm: remove_memory: Fix end_pfn setting
Date: Fri,  8 Mar 2013 08:41:41 -0700
Message-Id: <1362757301-18550-2-git-send-email-toshi.kani@hp.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1362757301-18550-1-git-send-email-toshi.kani@hp.com>
References: <1362757301-18550-1-git-send-email-toshi.kani@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

remove_memory() calls walk_memory_range() with [start_pfn, end_pfn),
where end_pfn is exclusive in this range.  Therefore, end_pfn needs
to be set to the next page of the end address.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
---
 mm/memory_hotplug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index ae7bcba..3e2ab7b 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1801,7 +1801,7 @@ int __ref remove_memory(int nid, u64 start, u64 size)
 	int retry = 1;
 
 	start_pfn = PFN_DOWN(start);
-	end_pfn = start_pfn + PFN_DOWN(size);
+	end_pfn = PFN_UP(start + size - 1);
 
 	/*
 	 * When CONFIG_MEMCG is on, one memory block may be used by other
