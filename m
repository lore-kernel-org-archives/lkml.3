Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758103Ab3BSCAB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 21:00:01 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:22809 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758024Ab3BSB77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 20:59:59 -0500
X-AuditID: cbfee68f-b7f656d000000d78-34-5122dc9e2f58
From: Boojin Kim <boojin.kim@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: "'Dan Williams'" <djbw@fb.com>, "'Vinod Koul'" <vinod.koul@intel.com>,
        "'Jaswinder Singh'" <jassi.brar@samsung.com>,
        "'Russell King'" <linux@arm.linux.org.uk>
Subject: [PATCH 1/2] dma: pl330: support burst mode for dev-to-mem and
 mem-to-dev transmit
Date: Tue, 19 Feb 2013 10:59:57 +0900
Message-id: <00ea01ce0e44$d1a9e360$74fdaa20$%kim@samsung.com>
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4ORNEloL6pleRKSRCwKBmaENW5Ew==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPLMWRmVeSWpSXmKPExsVy+t8zY915d5QCDRa/Fbe4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZhxZcZi64zFcxaStXA+Mf7i5GTg4JAROJ17ceskHYYhIX7q0H
	srk4hASWMUp8ePCEFaZozuF7jBCJRYwS64/eZ4Jw5jFJrJz+gQmkik1AU2LG9+nsILaIgILE
	5t5nrCBFzALzGCU+P/oHlhAWiJG482YeC4jNIqAqcXvyfbDdvAK2Emd7eoFsDqB16hKP/upC
	zNGT2H1tAlgrs4CIxL4X7xghLrrOJvFylQHEGAGJb5MPsUC0ykpsOsAMUSIpcXDFDZYJjMKz
	kHQvYGRcxSiaWpBcUJyUXmSsV5yYW1yal66XnJ+7iRESmP07GO8esD7EmAw0eiKzlGhyPjCw
	80riDY2NTcxMTE3MLU3NTUkTVhLnlb8kEygkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qBUWFf
	+eIHGf83s5nFrpJQjyl9dtvBm1vj8wvZzX6iRrXR8/c7TLuht0B6emHFl3epUh2unqVs13de
	YF+neUMiqCY5JW7JSvOo1NzTQX+UO6ZdW/Foi2+wFYfp174PDoq16qubI5kZ9XfLvlwkWsG/
	x2bXnt/dKwslL0kkeZfF/ayQDtnH0X1SiaU4I9FQi7moOBEAwTFmxGICAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLIsWRmVeSWpSXmKPExsVy+t9jAd15d5QCDbZOELG4vGsOmwOjx+dN
	cgGMUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlA
	U5UUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhHWMGYcWXGYuuMxXMWkrVwPj
	H+4uRk4OCQETiTmH7zFC2GISF+6tZ+ti5OIQEljEKLH+6H0mCGcek8TK6R+YQKrYBDQlZnyf
	zg5iiwgoSGzufcYKUsQsMI9R4vOjf2AJYYEYiTtv5rGA2CwCqhK3J99nA7F5BWwlzvb0Atkc
	QOvUJR791YWYoyex+9oEsFZmARGJfS/eMU5g5J2FxF3AyLiKUTS1ILmgOCk910ivODG3uDQv
	XS85P3cTIzjwn0nvYFzVYHGIUYCDUYmH94OjUqAQa2JZcWXuIUYJDmYlEd6OdqAQb0piZVVq
	UX58UWlOavEhxmSgAycyS4km5wOjMq8k3tDYxMzI0sjMwsjE3Jw0YSVxXsZTTwKEBNITS1Kz
	U1MLUotgtjBxcEo1ME79tHT5+QOiR6e0Tz0jFBsRf4n3nnRe88VGh2XfnqlKc1XU9SYnHug3
	+fSd+fkWrcu5Gy47Jt5nXBH4eVdK5p8JHf7rgr35zVs2yxzNaG1g2P2pordxyf2Vbe63Smsa
	5tjGbBRwiZyh3fYm76WzZe6sI5mrzVWX2xuEyDZOm/ImP7lpf4epgRJLcUaioRZzUXEiACHO
	x5TAAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds to support burst mode for dev-to-mem and mem-to-dev transmit

Signed-off-by: Boojin Kim <boojin.kim@samsung.com>
---
 drivers/dma/pl330.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
index 80680ee..a070160 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -1271,10 +1271,11 @@ static inline int _ldst_devtomem(unsigned dry_run, u8 buf[],
 		const struct _xfer_spec *pxs, int cyc)
 {
 	int off = 0;
+	enum pl330_cond cond = (pxs->r->cfg->brst_size == 1) ? SINGLE : BURST;

 	while (cyc--) {
-		off += _emit_WFP(dry_run, &buf[off], SINGLE, pxs->r->peri);
-		off += _emit_LDP(dry_run, &buf[off], SINGLE, pxs->r->peri);
+		off += _emit_WFP(dry_run, &buf[off], cond, pxs->r->peri);
+		off += _emit_LDP(dry_run, &buf[off], cond, pxs->r->peri);
 		off += _emit_ST(dry_run, &buf[off], ALWAYS);
 		off += _emit_FLUSHP(dry_run, &buf[off], pxs->r->peri);
 	}
@@ -1286,11 +1287,12 @@ static inline int _ldst_memtodev(unsigned dry_run, u8 buf[],
 		const struct _xfer_spec *pxs, int cyc)
 {
 	int off = 0;
+	enum pl330_cond cond = (pxs->r->cfg->brst_size == 1) ? SINGLE : BURST;

 	while (cyc--) {
-		off += _emit_WFP(dry_run, &buf[off], SINGLE, pxs->r->peri);
+		off += _emit_WFP(dry_run, &buf[off], cond, pxs->r->peri);
 		off += _emit_LD(dry_run, &buf[off], ALWAYS);
-		off += _emit_STP(dry_run, &buf[off], SINGLE, pxs->r->peri);
+		off += _emit_STP(dry_run, &buf[off], cond, pxs->r->peri);
 		off += _emit_FLUSHP(dry_run, &buf[off], pxs->r->peri);
 	}

@@ -2835,7 +2837,7 @@ pl330_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 		}

 		desc->rqcfg.brst_size = pch->burst_sz;
-		desc->rqcfg.brst_len = 1;
+		desc->rqcfg.brst_len = pch->burst_len;
 	}

 	/* Return the last desc in the chain */
--
1.7.5.4


