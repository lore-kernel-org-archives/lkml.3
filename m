Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751708AbaBZC0l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 21:26:41 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:51122 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075AbaBZC0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 21:26:39 -0500
X-AuditID: cbfee68d-b7fcd6d00000315b-b1-530d50dd8436
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: t.figa@samsung.com, mturquette@linaro.org
Cc: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH] clk: samsung: fixed compiler warning [-Wpointer-to-int-cast]
Date: Wed, 26 Feb 2014 11:42:41 +0900
Message-id: <1393382561-5388-1-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrILMWRmVeSWpSXmKPExsVy+t8zA927AbzBBjt+6FhsenyN1eLyrjls
	FjPO72OyeDrhIpvFoq1f2C3Wz3jN4sDmcefaHjaPzUvqPfq2rGL0+LxJLoAlissmJTUnsyy1
	SN8ugSvj9MrnzAXT2Suadi9lbGCcwtbFyMEhIWAi8e5LbRcjJ5ApJnHh3nqgMBeHkMAyRomD
	Jw6yQCRMJP4t/cEEkVjEKDHlz09mCKeNSWLmg29gVWwCuhJP3s9lBrFFgOzzy26AdTALTGGU
	+N72kQVknbCAr8TsZncQk0VAVeLEDnaQcl4Bd4mtz+YzQxykIDFnkg1Ip4TAZzaJhkUnmEBq
	WAQEJL5NPsQCUSMrsekAM8RtkhIHV9xgmcAouICRYRWjaGpBckFxUnqRoV5xYm5xaV66XnJ+
	7iZGSHD27mC8fcD6EGMy0LiJzFKiyfnA4M4riTc0NjOyMDUxNTYytzQjTVhJnDfpYVKQkEB6
	YklqdmpqQWpRfFFpTmrxIUYmDk6pBsaO77n2z760Xnv3ICthAld0xJWpD03932zuF9oSu3u5
	12z7i8sX/VHNvL/rCs/xNTPCuQ4c2bX694ddb/ZvVUuVez/XponvZ9FdneKSTRFVoixHpeYZ
	Htv750j1w+pz+9OFjgc/K1XnLTy6kn11J9uJ+tRdMpFV3XLS9f5nf4SuWT6585OrUusxJZbi
	jERDLeai4kQAja3X92QCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPIsWRmVeSWpSXmKPExsVy+t9jAd27AbzBBhc/aVhsenyN1eLyrjls
	FjPO72OyeDrhIpvFoq1f2C3Wz3jN4sDmcefaHjaPzUvqPfq2rGL0+LxJLoAlqoHRJiM1MSW1
	SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdouZJCWWJOKVAoILG4
	WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4x4/TK58wF09krmnYvZWxgnMLWxcjJISFgIvFv
	6Q8mCFtM4sK99UBxLg4hgUWMElP+/GSGcNqYJGY++MYCUsUmoCvx5P1cZhBbBMg+v+wGE0gR
	s8AURonvbR+Bijg4hAV8JWY3u4OYLAKqEid2sIOU8wq4S2x9Np8ZJCwhoCAxZ5LNBEbuBYwM
	qxhFUwuSC4qT0nON9IoTc4tL89L1kvNzNzGCg/+Z9A7GVQ0WhxgFOBiVeHgDWHiDhVgTy4or
	cw8xSnAwK4nwWnzjCRbiTUmsrEotyo8vKs1JLT7EmAy0eyKzlGhyPjAy80riDY1NzIwsjcws
	jEzMzUkTVhLnPdhqHSgkkJ5YkpqdmlqQWgSzhYmDU6qBUfSXb1VoUvK23L2lqrFHEtsmn/3E
	pNUrKGejXGqyUN4wS9hR4zVXdXvUPaa4nO/Zf5+9OCm5furKPfv/h92rKph40NonKL/f2eX6
	Dd7ps5/P/7lOp/pga0/bR84j+4SuCEwuex8fPVVKymbro8V+FY9mlz2R5vvWHHz3uKnl89hj
	l6vtypNXK7EUZyQaajEXFScCAI/T/GDCAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When compiled using ARM64 cross compiler, gcc complains as

drivers/clk/samsung/clk.c:293:18:
warning: cast from pointer to integer of different size
[-Wpointer-to-int-cast]

Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
---
 drivers/clk/samsung/clk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/samsung/clk.c b/drivers/clk/samsung/clk.c
index 91bec3e..59142ba 100644
--- a/drivers/clk/samsung/clk.c
+++ b/drivers/clk/samsung/clk.c
@@ -278,7 +278,7 @@ void __init samsung_clk_of_register_fixed_ext(
 	for_each_matching_node_and_match(np, clk_matches, &match) {
 		if (of_property_read_u32(np, "clock-frequency", &freq))
 			continue;
-		fixed_rate_clk[(u32)match->data].fixed_rate = freq;
+		fixed_rate_clk[(unsigned long)match->data].fixed_rate = freq;
 	}
 	samsung_clk_register_fixed_rate(fixed_rate_clk, nr_fixed_rate_clk);
 }
-- 
1.7.9.5

