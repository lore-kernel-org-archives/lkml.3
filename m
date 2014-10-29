Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756458AbaJ2JX0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 05:23:26 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:46382 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756414AbaJ2JXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 05:23:21 -0400
X-AuditID: cbfec7f5-b7f956d000005ed7-b8-5450b1ffeae1
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, lauraa@codeaurora.org,
        linux-omap@vger.kernel.org, linus.walleij@linaro.org, tony@atomide.com,
        drake@endlessm.com, loeliger@gmail.com,
        Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH v7 4/8] ARM: l2c: shorten warning about incorrect associativity
Date: Wed, 29 Oct 2014 10:22:57 +0100
Message-id: <1414574581-2320-5-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.9.2
In-reply-to: <1414574581-2320-1-git-send-email-m.szyprowski@samsung.com>
References: <1414574581-2320-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCLMWRmVeSWpSXmKPExsVy+t/xy7r/NwaEGHxpY7Z4NP8xs0Xvgqts
	Fmeb3rBbbO+cwW4x5c9yJotNj6+xWlzeNYfNYvaSfhaLGef3MVncvsxrcW77FhaLtUfuslss
	vX6RyWLVrj+MFvuveDnwe6yZt4bRo6W5h83j29dJLB6X+3qZPBZ9z/LYOesuu8eda3vYPDYv
	qffo27KK0ePzJrkArigum5TUnMyy1CJ9uwSujK8L/7EXLGavOLJyD2MD43/WLkZODgkBE4kv
	p56yQ9hiEhfurWfrYuTiEBJYyigx5+Jndginj0ni4tTfYFVsAoYSXW+72EBsEYFsiR/fJrOA
	FDEL9DFLnJ/ewwySEBbwl+i984wJxGYRUJXYc3MtC4jNK+AucfvnKRaIdXIS/1+uAKvhFPCQ
	WH1hCdhQIaCajYe72SYw8i5gZFjFKJpamlxQnJSea6RXnJhbXJqXrpecn7uJERLSX3cwLj1m
	dYhRgINRiYc3gsU/RIg1say4MvcQowQHs5II7w7zgBAh3pTEyqrUovz4otKc1OJDjEwcnFIN
	jIsKk388NOl0EdgVfu/ovG/KnswKxV/45/zvj3jms/+669xclbRNIladLL9trC8fZkt4m7Vt
	vWK5oETOx2PlBz39Gz5Y516qjwzgFA6ZfCSjxGTvDVFHG1+XJvPJha9U/IS/z7HY4HvaJqsg
	42O1nZjoNTG9VcJlJbNyCuv0z3LKbClmLMtTYinOSDTUYi4qTgQAR9E47EcCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Warning message about missing/incorrect associativity was a bit too
long, so shorten it to fit a single line.

Suggested-by: Russell King - ARM Linux <linux@arm.linux.org.uk>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 arch/arm/mm/cache-l2x0.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mm/cache-l2x0.c b/arch/arm/mm/cache-l2x0.c
index ad981894de73..83b36f3b415c 100644
--- a/arch/arm/mm/cache-l2x0.c
+++ b/arch/arm/mm/cache-l2x0.c
@@ -1200,8 +1200,8 @@ static void __init l2c310_of_parse(const struct device_node *np,
 		*aux_mask &= ~L2X0_AUX_CTRL_ASSOC_MASK;
 		break;
 	default:
-		pr_err("PL310 OF: cache setting yield illegal associativity\n");
-		pr_err("PL310 OF: %d calculated, only 8 and 16 legal\n", assoc);
+		pr_err("L2C-310 OF cache associativity %d invalid, only 8 or 16 permitted\n",
+		       assoc);
 		break;
 	}
 }
-- 
1.9.2

