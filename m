Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758641Ab3DYCpJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 22:45:09 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:44472 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932182Ab3DYCpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 22:45:06 -0400
X-AuditID: cbfee68d-b7f016d000007930-4a-517898b07ca3
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH] f2fs: avoid frequent background GC
Date: Thu, 25 Apr 2013 11:44:02 +0900
Message-id: <1366857842-17240-1-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.1.3.566.gaa39828
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMLMWRmVeSWpSXmKPExsVy+t8zI90NMyoCDZpm8Vlc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlbF66RPGgtXsFf0v
	JrM0MH5n7WLk5JAQMJF4PGURM4QtJnHh3nq2LkYuDiGBZYwSXf97WWCKrrSvZgSxhQSmM0os
	vi8LUdTGJDG19QhQNwcHm4C2xOb9BiA1IgLMEgumnmcEqWEWmMAo8X/Re7BBwgLGEm33NrKB
	2CwCqhKT1zxkBenlFXCXmPEbapeuxOr/z9lBeiUE7rNJLHr8iB2iXkDi2+RDLCD1EgKyEpsO
	QB0tKXFwxQ2WCYyCCxgZVjGKphYkFxQnpRcZ6hUn5haX5qXrJefnbmKEBGDvDsbbB6wPMSYD
	jZvILCWanA8M4LySeENjMyMLUxNTYyNzSzPShJXEedVarAOFBNITS1KzU1MLUovii0pzUosP
	MTJxcEo1MMrNXn67bBnr/8eTQjrT2qU1UpuiL8x4kyA4T3rbt6afa66vWJjF2VStqlG2JfXG
	2+STW6sKH6doH/3Gd0c3uuUFm84shSTtYP2dKy165Cv8+9jXiCq0Vm/g0/6xqkBoYoShyhHN
	6SyK1lfarZubZQMWbJC91P5rifP1k35ndHxFvObrvFrOqMRSnJFoqMVcVJwIADLw1xdWAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrAIsWRmVeSWpSXmKPExsVy+t9jQd0NMyoCDVovcVlc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8c
	b2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RNSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5v
	SBBcj5EBGkhYx5ixeukTxoLV7BX9LyazNDB+Z+1i5OSQEDCRuNK+mhHCFpO4cG89G4gtJDCd
	UWLxfdkuRi4gu41JYmrrEeYuRg4ONgFtic37DUBqRASYJRZMPc8IUsMsMIFR4v+i9ywgCWEB
	Y4m2exvBBrEIqEpMXvOQFaSXV8BdYsZvFohduhKr/z9nn8DIvYCRYRWjaGpBckFxUnquoV5x
	Ym5xaV66XnJ+7iZGcHg/k9rBuLLB4hCjAAejEg+vwKvyQCHWxLLiytxDjBIczEoivMscKgKF
	eFMSK6tSi/Lji0pzUosPMSYDLZ/ILCWanA+MvbySeENjEzMjSyMzCyMTc3PShJXEeQ+0WgcK
	CaQnlqRmp6YWpBbBbGHi4JRqYFwv/Dmm0eGKWsDDt6FhnIEK0hsmu4bE/XwaUXxnS4Rn9nPZ
	PcVh94y2/H4sF/CHWSIjXsl+9clApha35Oi9RicazDmsJQ6GG+wq1T/wIH9LsKfmLGV3k7cN
	hdsaDlwL+hAsnTQroE7bPJTpr89buz/RTRUs1z5EBPmfe+ppd/3iTq7LnhMDlViKMxINtZiL
	ihMB6/qRcrMCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If there is no victim segments selected by background GC, let's wait
a little bit longer time to collect dirty segments.
By default, let's give 10 minutes.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/gc.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/gc.h b/fs/f2fs/gc.h
index 30b2db0..1190d57 100644
--- a/fs/f2fs/gc.h
+++ b/fs/f2fs/gc.h
@@ -13,9 +13,9 @@
 						 * whether IO subsystem is idle
 						 * or not
 						 */
-#define GC_THREAD_MIN_SLEEP_TIME	10000 /* milliseconds */
+#define GC_THREAD_MIN_SLEEP_TIME	10000	/* milliseconds */
 #define GC_THREAD_MAX_SLEEP_TIME	30000
-#define GC_THREAD_NOGC_SLEEP_TIME	10000
+#define GC_THREAD_NOGC_SLEEP_TIME	600000	/* wait 10 min */
 #define LIMIT_INVALID_BLOCK	40 /* percentage over total user space */
 #define LIMIT_FREE_BLOCK	40 /* percentage over invalid + free space */
 
-- 
1.8.1.3.566.gaa39828

