Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759594Ab3ICG2N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 02:28:13 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:10409 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754636Ab3ICG2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 02:28:09 -0400
X-AuditID: cbfee690-b7f3b6d000007a15-2f-5225817201c5
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 1/2] f2fs: trigger GC when there are prefree segments
Date: Tue, 03 Sep 2013 15:27:52 +0900
Message-id: <1378189673-32656-1-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.3.1.437.g0dbd812
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrALMWRmVeSWpSXmKPExsVy+t8zI92iRtUgg2PtshbXd/1lsri0yN1i
	z96TLBaXd81hc2Dx2L3gM5NH35ZVjB6fN8kFMEdx2aSk5mSWpRbp2yVwZXxvXsZSsJm94swB
	mwbGBWxdjJwcEgImEtO73zNB2GISF+6tB4sLCSxjlDjRYtDFyAFW0//XsIuRCyi8iFFizZPl
	zBA1bUwSX2flgtSwCWhLbN5vABIWEWCWWDD1PCNIPbPABEaJ/4ves4DUCAu4SlxdqAFSwyKg
	KvHsWAPYWl4Bd4nZ7T9ZIU7QlVh04iArSK+EwH02iTm9d1kgGgQkvk0+xAJxj6zEpgPMEPWS
	EgdX3GCZwCi4gJFhFaNoakFyQXFSepGJXnFibnFpXrpecn7uJkZI6E3YwXjvgPUhxmSgcROZ
	pUST84Ghm1cSb2hsZmRhamJqbGRuaUaasJI4r3qLdaCQQHpiSWp2ampBalF8UWlOavEhRiYO
	TqkGRkfNFfv1bR9Meh8dZcCqXKinoa/UqZj45XO9+a4l5otf/D9+K5pzWoTb0msLhPIb5HTf
	MqSuEfM7tN6GKfIr/y3fQrmHy5+ZXF2jEjhntVF0qPPUki0Kcvuii20/efw5l56isjdx8o9p
	p+WUeFpZ7rs//CabarC8ZrE/P8d0p+rcs5Ua7y6LK7EUZyQaajEXFScCACFsEdZTAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHIsWRmVeSWpSXmKPExsVy+t9jAd2iRtUgg/1TJS2u7/rLZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI5qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneO
	NzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAdqmpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3
	JAiux8gADSSsY8z43ryMpWAze8WZAzYNjAvYuhg5OCQETCT6/xp2MXICmWISF+6tBwpzcQgJ
	LGKUWPNkOTNIQkigjUni66xckHo2AW2JzfsNQMIiAswSC6aeZwSpZxaYwCjxf9F7FpAaYQFX
	iasLNUBqWARUJZ4da2ACsXkF3CVmt/9khdilK7HoxEHWCYzcCxgZVjGKphYkFxQnpeca6hUn
	5haX5qXrJefnbmIEh/YzqR2MKxssDjEKcDAq8fBy7FUJEmJNLCuuzD3EKMHBrCTCK/QNKMSb
	klhZlVqUH19UmpNafIgxGWj7RGYp0eR8YNzllcQbGpuYGVkamVkYmZibkyasJM57oNU6UEgg
	PbEkNTs1tSC1CGYLEwenVANj+ImYJKUnJs+1fX+sF5N2ldgim/qSdfveLT9SePrv+vOm+4lE
	Texcd/6V6LY2eZUJZ72msslMlHsQ/Je/W6Po6dRZX01rtoquizvC6Cl/TKZ6ybougQtLmKs/
	MJ262DVhQ9gsefdrNXnnN3AyLnHQ5+qsSt644bjb08orW17K5NxeWNO1aoWLEktxRqKhFnNR
	cSIA5vmQSbECAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously, f2fs conducts SSR when free_sections() < overprovision_sections.
But, even though there are a lot of prefree segments, it can consider SSR only.
So, let's consider the number of prefree segments too for triggering SSR.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/segment.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h
index 062424a..cd9bd93 100644
--- a/fs/f2fs/segment.h
+++ b/fs/f2fs/segment.h
@@ -453,7 +453,8 @@ static inline int reserved_sections(struct f2fs_sb_info *sbi)
 
 static inline bool need_SSR(struct f2fs_sb_info *sbi)
 {
-	return (free_sections(sbi) < overprovision_sections(sbi));
+	return ((prefree_segments(sbi) / sbi->segs_per_sec)
+			+ free_sections(sbi) < overprovision_sections(sbi));
 }
 
 static inline bool has_not_enough_free_secs(struct f2fs_sb_info *sbi, int freed)
-- 
1.8.3.1.437.g0dbd812

