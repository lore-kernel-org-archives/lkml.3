Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758085Ab3BZFia (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 00:38:30 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:18376 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752581Ab3BZFi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 00:38:28 -0500
X-AuditID: cbfee691-b7faa6d000005ae9-5e-512c4a5243aa
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Subject: [PATCH 1/2] f2fs: read with READ_SYNC when getting dnode page
Date: Tue, 26 Feb 2013 14:37:47 +0900
Message-id: <1361857068-31613-1-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.1.3.566.gaa39828
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrALMWRmVeSWpSXmKPExsVy+t8zA90gL51Ag5uvDCz27D3JYnF51xw2
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDJafj1hKVjAUtG8+SZjA+M25i5GTg4JAROJvit3WSBs
	MYkL99azdTFycQgJLGOUeNPXwQ5T9P/lbkaIxCJGiek3elggnDYmiS+fdgON4uBgE9CW2Lzf
	AKRBRCBTYvWll+wgYWYBTYkZT+pAwsICbhITzz0HW8YioCrxYd4TJhCbV8BdYtaFLqgjdCVW
	/3/ODjJeQuAAm8SvzfeZIRoEJL5NPsQCMlNCQFZi0wGoByQlDq64wTKBUXABI8MqRtHUguSC
	4qT0IlO94sTc4tK8dL3k/NxNjJDQmriD8f4B60OMyUDjJjJLiSbnA0MzryTe0NjYxMzE1MTc
	0tTclDRhJXFe+UsygUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoYY7c7H17xvMMvULqbNX7b
	5dV3CzXF+Q1D+N/9W8e1P9mdcYNEYbB+aqiSvMLEg7s9zujGT/pTd1j81IellXOO/DXYYaG5
	6lGKsHuFw91PWe8LdN9c3WN95ZZdo0fxU0+Dn3+uPBVgvPajt6TRo3y1s+uPFI5Nl/VWGs71
	itZfdsB07flHn3lmKLEUZyQaajEXFScCAA2w181DAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplkeLIzCtJLcpLzFFi42I5/e+xgG6Ql06gwYpp2hZ79p5ksbi8aw6b
	A5PH501yAYxRDYw2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4B
	um6ZOUCjlRTKEnNKgUIBicXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZoIGEdYwZLb+esBQsYKlo
	3nyTsYFxG3MXIyeHhICJxP+XuxkhbDGJC/fWs3UxcnEICSxilJh+o4cFwmljkvjyaTdQBwcH
	m4C2xOb9BiANIgKZEqsvvWQHCTMLaErMeFIHEhYWcJOYeO45C4jNIqAq8WHeEyYQm1fAXWLW
	hS4WiF26Eqv/P2efwMi9gJFhFaNoakFyQXFSeq6RXnFibnFpXrpecn7uJkZw4D6T3sG4qsHi
	EKMAB6MSD69Gh3agEGtiWXFl7iFGCQ5mJRFezgygEG9KYmVValF+fFFpTmrxIcZkoO0TmaVE
	k/OBUZVXEm9obGJmZGlkZmFkYm5OmrCSOC/jqScBQgLpiSWp2ampBalFMFuYODilGhgF8soa
	Znx94Bb1+P7bD7pSkxfrrDs3Z9XViOXH9h38cNPVvG1VytOOZZdLSu+fl5CIzb+UP1nm2o6t
	xvarfnNoi70tPLvyhZR/Zt5PDS4Zs/QjM6KDMyxSz61aqb93eYJ6ez3f3fXLfU9wsyY4yN9/
	deJMW8699l3nK77dPsrzL6TJ8BKHScEGJZbijERDLeai4kQAc3vieaACAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It must be set READ_SYNC not READA.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/node.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index e275218..185454f 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -930,7 +930,7 @@ repeat:
 	if (!page)
 		return ERR_PTR(-ENOMEM);
 
-	err = read_node_page(page, READA);
+	err = read_node_page(page, READ_SYNC);
 	if (err) {
 		f2fs_put_page(page, 1);
 		return ERR_PTR(err);
-- 
1.8.1.3.566.gaa39828

