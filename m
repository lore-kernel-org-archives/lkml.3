Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805AbaBPDbo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 22:31:44 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:39405 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567AbaBPDbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 22:31:42 -0500
X-AuditID: cbfee61a-b7fb26d00000724f-10-5300311c1353
From: Weijie Yang <weijie.yang@samsung.com>
To: riel@redhat.com
Cc: "'Mel Gorman'" <mgorman@suse.de>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Minchan Kim'" <minchan@kernel.org>, weijie.yang.kh@gmail.com,
        "'linux-kernel'" <linux-kernel@vger.kernel.org>,
        "'Linux-MM'" <linux-mm@kvack.org>
Subject: [RFC PATCH] mm/vmscan: remove two un-needed mem_cgroup_page_lruvec()
 call
Date: Sun, 16 Feb 2014 11:30:54 +0800
Message-id: <000001cf2ac7$9abf23b0$d03d6b10$%yang@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8qx39NForErs1TSrS/tLPrTkuZuA==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHLMWRmVeSWpSXmKPExsVy+t9jQV0ZQ4ZggxVtohZz1q9hs7i8aw6b
	xb01/1ktJr97xmix7Ot7dou/V9azWDw58Z/Fgd1j56y77B6bVnWyeWz6NInd48SM3ywe7/dd
	ZfPYfLra4/MmuQD2KC6blNSczLLUIn27BK6MvZMPsRZcZ6+Y8GEfYwPjIrYuRk4OCQETiU3H
	PjJB2GISF+6tB4pzcQgJTGeUOPv7FDuE84dRYvfHJnaQKjYBbYm7/RtZQWwRAWGJt8sWs4AU
	MQs8ZpS40HmMESQhLBAi8fDXO2YQm0VAVWL+ycdAKzg4eAXsJA69cQYJ8woISvyYfI8FJMws
	oC4xZUouSJhZQF5i85q3zCBhCaDwo7+6EJv0JOZPW8sCUSIusfHILZYJjAKzkAyahTBoFpJB
	s5B0LGBkWcUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kRHAvPpHYwrmywOMQowMGoxMN74df/
	ICHWxLLiytxDjBIczEoivHv+AoV4UxIrq1KL8uOLSnNSiw8xSnOwKInzHmi1DhQSSE8sSc1O
	TS1ILYLJMnFwSjUw6if565554OFitqiyNSfA6uii+xceVvlMlFGZXfqiv3z5w0TWEx1z+Xvj
	90ksbugVFY5P337TpCLELy15unRUI+MDs7ikKDmHc+927lpu9X7Sb7+X85qPXDm0hbH11uK9
	spJei6ceyrrnePaWwGnhqtVrGVx3xP85afY98JLYh68Jrmf+HWD+ocRSnJFoqMVcVJwIAFK8
	/uqBAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In putback_inactive_pages() and move_active_pages_to_lru(),
lruvec is already an input parameter and pages are all from this lruvec,
therefore there is no need to call mem_cgroup_page_lruvec() in loop.

Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
---
 mm/vmscan.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index a9c74b4..4804fdb 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1393,8 +1393,6 @@ putback_inactive_pages(struct lruvec *lruvec, struct list_head *page_list)
 			continue;
 		}
 
-		lruvec = mem_cgroup_page_lruvec(page, zone);
-
 		SetPageLRU(page);
 		lru = page_lru(page);
 		add_page_to_lru_list(page, lruvec, lru);
@@ -1602,7 +1600,6 @@ static void move_active_pages_to_lru(struct lruvec *lruvec,
 
 	while (!list_empty(list)) {
 		page = lru_to_page(list);
-		lruvec = mem_cgroup_page_lruvec(page, zone);
 
 		VM_BUG_ON_PAGE(PageLRU(page), page);
 		SetPageLRU(page);
-- 
1.7.10.4


