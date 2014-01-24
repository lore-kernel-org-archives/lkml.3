Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752067AbaAXIIK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 03:08:10 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:46416 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825AbaAXIII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 03:08:08 -0500
X-AuditID: cbfee690-b7f266d00000287c-f0-52e21f623eb5
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: catalin.marinas@arm.com, will.deacon@arm.com, lauraa@codeaurora.org,
        Pankaj Dubey <pankaj.dubey@samsung.com>,
        Somraj Mani <somraj.mani@samsung.com>
Subject: [PATCH] arm64: fix build error if DMA_CMA is enabled
Date: Fri, 24 Jan 2014 17:23:08 +0900
Message-id: <1390551788-6138-1-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDLMWRmVeSWpSXmKPExsVy+t8zA90k+UdBBmuOqlu8X9bDaLG9cwa7
	xabH11gtLu+aw2axaOsXdotVH6azWLz8eILFgd1jzbw1jB6X+3qZPDYvqffo27KK0ePzJrkA
	1igum5TUnMyy1CJ9uwSujCOHVrEUzGavODqjia2BcTZbFyMnh4SAicTWs1OYIWwxiQv31gPF
	uTiEBJYxSvx/0czaxcgBVtQ4QRikRkhgEaPE8p81EDVtTBJb9q9kBUmwCehKPHk/F2yQiICb
	xI3GDiaQImaBmYwSU55+AUsIC9hKfLu7EKyBRUBVYtmvdSwgNq+Au8Tthk9MEMsUJOZMsgHp
	lRBoZpe4fbCJGaJeQOLb5EMsEDWyEpsOQB0tKXFwxQ2WCYyCCxgZVjGKphYkFxQnpReZ6BUn
	5haX5qXrJefnbmKEhOyEHYz3DlgfYkwGGjeRWUo0OR8Y8nkl8YbGZkYWpiamxkbmlmakCSuJ
	86o9SgoSEkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnVwJj25e5uprVv5ofx3zFQlj7SGPY+esfE
	s/1zj9ek3mTWK9lms/Fq4l3BymU+7Q2tL2/tPKdeoredP9lze8jC56fnt81PP34g2NXzfqzS
	vcoAWw2ZbfvF1nVJHlBMZvyygSX28b15cqWd110jm/zUwtcdPFpu9CjGM+DkiSSG2W/2b1sk
	wxTMkKfEUpyRaKjFXFScCAB81Y49bwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJIsWRmVeSWpSXmKPExsVy+t9jAd0k+UdBBvc/Klm8X9bDaLG9cwa7
	xabH11gtLu+aw2axaOsXdotVH6azWLz8eILFgd1jzbw1jB6X+3qZPDYvqffo27KK0ePzJrkA
	1qgGRpuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoDOU
	FMoSc0qBQgGJxcVK+naYJoSGuOlawDRG6PqGBMH1GBmggYR1jBlHDq1iKZjNXnF0RhNbA+Ns
	ti5GDg4JAROJxgnCXYycQKaYxIV769lAbCGBRYwSy3/WdDFyAdltTBJb9q9kBUmwCehKPHk/
	lxnEFhFwk7jR2MEEUsQsMJNRYsrTL2AJYQFbiW93F4I1sAioSiz7tY4FxOYVcJe43fCJCWKx
	gsScSTYTGLkXMDKsYhRNLUguKE5KzzXSK07MLS7NS9dLzs/dxAiOiGfSOxhXNVgcYhTgYFTi
	4Z0R+DBIiDWxrLgy9xCjBAezkghv/TWgEG9KYmVValF+fFFpTmrxIcZkoOUTmaVEk/OB0ZpX
	Em9obGJmZGlkZmFkYm5OmrCSOO/BVutAIYH0xJLU7NTUgtQimC1MHJxSDYzzp5+M5L3y6NLn
	LJfrBnOmt9wViHlovayq5RzLm5Oa4i7bt8jINRdEdH5ZxftBKiTY0uBU38HjJ/1WbKj+8UEu
	offBUQ7e1sr1xtpebV9mz/H9IPksev+MI8/E3vBKfjvqJeggzG+9sr6TSV9d6OK1qUfjetc6
	GQodmfXif4Diz26D34ekUz8rsRRnJBpqMRcVJwIAfE9PlcwCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arm64/include/asm/dma-contiguous.h is trying to include
<asm-genric/dma-contiguous.h> which does not exist, and thus failing
build for arm64 if we enable CONFIG_DMA_CMA. This patch fixes build 
error by removing unwanted header inclusion from arm64's dma-contiguous.h.

Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
Signed-off-by: Somraj Mani <somraj.mani@samsung.com>
---
 arch/arm64/include/asm/dma-contiguous.h |    1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/include/asm/dma-contiguous.h b/arch/arm64/include/asm/dma-contiguous.h
index d6aacb6..14c4c0c 100644
--- a/arch/arm64/include/asm/dma-contiguous.h
+++ b/arch/arm64/include/asm/dma-contiguous.h
@@ -18,7 +18,6 @@
 #ifdef CONFIG_DMA_CMA
 
 #include <linux/types.h>
-#include <asm-generic/dma-contiguous.h>
 
 static inline void
 dma_contiguous_early_fixup(phys_addr_t base, unsigned long size) { }
-- 
1.7.10.4

