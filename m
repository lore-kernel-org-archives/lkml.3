Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759669Ab3D3IoI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 04:44:08 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:10414 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759146Ab3D3IoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 04:44:03 -0400
X-AuditID: cbfee68f-b7f066d000003683-24-517f8452e61c
From: Jonghwan Choi <jhbird.choi@samsung.com>
To: "'Jonghwan Choi'" <jhbird.choi@samsung.com>, linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org, "'Chen Gang'" <gang.chen@asianux.com>,
        "'Al Viro'" <viro@zeniv.linux.org.uk>
References: 
In-reply-to: 
Subject: [PATCH 3.8-stable]  kernel/audit_tree.c: tree will leak memory when
 failure occurs in audit_trim_trees()
Date: Tue, 30 Apr 2013 17:44:01 +0900
Message-id: <007001ce457e$dcfff1c0$96ffd540$%choi@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4vhL6OHdYi6A9aR4m9yzeDEXJPogAflJswAu8tBWABA4TFIAFsOElw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHIsWRmVeSWpSXmKPExsVy+t8zA92glvpAg95lzBav7qhYLGnmtri8
	aw6bxYKNjxgtzv89zurA6rHn3xxWj74tqxg9Pm+S89j05C1TAEsUl01Kak5mWWqRvl0CV0bD
	8amsBZs4K9b9EW5g/MbexcjJISFgInFg3V82CFtM4sK99UA2F4eQwDJGies3bzDCFE05dB0q
	sYhRoqXxEDuE85dR4tfbTrAqNgFdiWPrt7CC2CIC3hKnpvxiBrGZBdIkui6+BarhAGrglljd
	HAQS5hTgkVj3p5MZJCwsUCwxr4ELJMwioCpxsHc5C4jNK2AncePXKmYIW1Dix+R7LBATtSTW
	7zzOBGHLS2xe8xZsjISAusSjv7oQB7hJTLiyixGiRERi34t3jCAXSwicY5e4t+05M8QuAYlv
	kw+xQPTKSmw6wAzxrqTEwRU3WCYwSsxCsnkWks2zkGyehWTFAkaWVYyiqQXJBcVJ6UXGesWJ
	ucWleel6yfm5mxghcdm/g/HuAetDjMlA6ycyS4km5wPjOq8k3tDYzMjC1MTU2Mjc0ow0YSVx
	XrUW60AhgfTEktTs1NSC1KL4otKc1OJDjEwcnFINjIEuhm8WS/NJbwle6fBM7kL95m/duSur
	p3lf81fa5FPmp94ertwXtE37n9XNisIOhRqPddUf7ILl7kye6Xr3X5zB3C2X44I7vnx8PEv6
	3fvXKa2+lZuct8T8sjgj1Ztee7bWYYrsfeWbDkcmMRT+0n6fvnm3R+sEsU6RGTONuTn2RFXy
	7TReqcRSnJFoqMVcVJwIANRmYp3hAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNKsWRmVeSWpSXmKPExsVy+t9jAd3AlvpAg/nHbCxe3VGxWNLMbXF5
	1xw2iwUbHzFanP97nNWB1WPPvzmsHn1bVjF6fN4k57HpyVumAJaoBkabjNTElNQihdS85PyU
	zLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKC1SgpliTmlQKGAxOJiJX07TBNC
	Q9x0LWAaI3R9Q4LgeowM0EDCOsaMhuNTWQs2cVas+yPcwPiNvYuRk0NCwERiyqHrbBC2mMSF
	e+uBbC4OIYFFjBItjYfYIZy/jBK/3nYyglSxCehKHFu/hRXEFhHwljg15RcziM0skCbRdfEt
	UA0HUAO3xOrmIJAwpwCPxLo/ncwgYWGBYol5DVwgYRYBVYmDvctZQGxeATuJG79WMUPYghI/
	Jt9jgZioJbF+53EmCFteYvOat2BjJATUJR791YU4wE1iwpVdjBAlIhL7XrxjnMAoNAvJpFlI
	Js1CMmkWkpYFjCyrGEVTC5ILipPScw31ihNzi0vz0vWS83M3MYKj/pnUDsaVDRaHGAU4GJV4
	eHcsqQsUYk0sK67MPcQowcGsJMKrX1ofKMSbklhZlVqUH19UmpNafIgxGejRicxSosn5wISU
	VxJvaGxiZmRpZGZhZGJuTpqwkjjvgVbrQCGB9MSS1OzU1ILUIpgtTBycUg2MQRMfvi2cskrW
	9bDI1cu5EzYcyIpcsMD4fIPNwR/V7/IvWm1NOKV7Pze5dqvq7HlfnvPeWSuRJRj29svV6abf
	bC5941r55pS4tp58wB/+tzFx7iyOjIyx1VL6ARtX+y4qfHPkPMujW+Z57TJmwbMaYh1ieb/w
	Lrt5uHUDy+04Xl3NeftmzKidrMRSnJFoqMVcVJwIAHQlo/Y+AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch looks like it should be in the 3.8-stable tree, should we apply
it?

------------------

From: "Chen Gang <gang.chen@asianux.com>"

commit 12b2f117f3bf738c1a00a6f64393f1953a740bd4 upstream

audit_trim_trees() calls get_tree().  If a failure occurs we must call
put_tree().

[akpm@linux-foundation.org: run put_tree() before mutex_lock() for small
scalability improvement]
Signed-off-by: Chen Gang <gang.chen@asianux.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric Paris <eparis@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
---
 kernel/audit_tree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/audit_tree.c b/kernel/audit_tree.c
index 642a89c..a291aa2 100644
--- a/kernel/audit_tree.c
+++ b/kernel/audit_tree.c
@@ -617,9 +617,9 @@ void audit_trim_trees(void)
 		}
 		spin_unlock(&hash_lock);
 		trim_marked(tree);
-		put_tree(tree);
 		drop_collected_mounts(root_mnt);
 skip_it:
+		put_tree(tree);
 		mutex_lock(&audit_filter_mutex);
 	}
 	list_del(&cursor);
-- 
1.7.9.5

