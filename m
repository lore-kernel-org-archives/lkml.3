Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757367Ab3JJBGb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 21:06:31 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:15586 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756623Ab3JJBG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 21:06:29 -0400
X-AuditID: cbfee68e-b7f756d000004512-d0-5255fd7267dc
From: Chanwoo Choi <cw00.choi@samsung.com>
To: sameo@linux.intel.com, lee.jones@linaro.org
Cc: linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH] mfd: max77693: Fix up bug of wrong interrupt number
Date: Thu, 10 Oct 2013 10:05:55 +0900
Message-id: <1381367155-4888-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDLMWRmVeSWpSXmKPExsWyRsSkRLfob2iQwf3Z8hbXvzxntTjb9Ibd
	4v7Xo4wWl3fNYbM43c3qwOpx59oeNo95JwM9+rasYvT4vEkugCWKyyYlNSezLLVI3y6BK+Np
	h2vBb/aKhhXbWBoYn7J1MXJySAiYSKzs3gtli0lcuLceyObiEBJYyigx/dcMFpiiDYsesEAk
	pjNK/FizGcppZJLYNP8jE0gVm4CWxP4XN8BGiQjoS3zYcZUZxGYWSJbofT0JrEZYwEXi5sW7
	7F2MHBwsAqoSOx9rgoR5gcIfD82EukJO4sOeR+wg8yUEHrNJXG3sBruCRUBA4tvkQywgvRIC
	shKbDjBD1EtKHFxxg2UCo+ACRoZVjKKpBckFxUnpRUZ6xYm5xaV56XrJ+bmbGIEhefrfs74d
	jDcPWB9iTAYaN5FZSjQ5HxjSeSXxhsZmRhamJqbGRuaWZqQJK4nzqrVYBwoJpCeWpGanphak
	FsUXleakFh9iZOLglGpgjP3+0Ojs8hm3pvJHXTEKmjRr2i3FjI1B0bNmbmH2OF+5Mjlh0X2O
	0o9p7sftO6Y+cL219sTZZSuitbhC3lYrLHHakBC27fX0VdMLpD9GPjnQvbzyhMnOL36PXZjz
	jt4/7ls1P+1ASSvvkqqb8Yf+ZZ46KfOkXmPpR8+wT1/0KrWaHaz1pX1msiqxFGckGmoxFxUn
	AgB/DaPtXwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJIsWRmVeSWpSXmKPExsVy+t9jQd2iv6FBBg9viVtc//Kc1eJs0xt2
	i/tfjzJaXN41h83idDerA6vHnWt72DzmnQz06NuyitHj8ya5AJaoBkabjNTElNQihdS85PyU
	zLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKC1SgpliTmlQKGAxOJiJX07TBNC
	Q9x0LWAaI3R9Q4LgeowM0EDCGsaMpx2uBb/ZKxpWbGNpYHzK1sXIySEhYCKxYdEDFghbTOLC
	vfVAcS4OIYHpjBI/1mxmgXAamSQ2zf/IBFLFJqAlsf/FDbBuEQF9iQ87rjKD2MwCyRK9ryeB
	1QgLuEjcvHiXvYuRg4NFQFVi52NNkDAvUPjjoZlQi+UkPux5xD6BkXsBI8MqRtHUguSC4qT0
	XEO94sTc4tK8dL3k/NxNjOCAfya1g3Flg8UhRgEORiUe3oqy0CAh1sSy4srcQ4wSHMxKIrzT
	TwKFeFMSK6tSi/Lji0pzUosPMSYDLZ/ILCWanA+MxrySeENjEzMjSyNzQwsjY3PShJXEeQ+0
	WgcKCaQnlqRmp6YWpBbBbGHi4JRqYCxU394zb4r0j1c/bRNe/2DXjmNgidrD/P6vimPH0y1R
	FadiMviiHny6durh5ofeHVdsXq6zNn5ZW+Da8/hhWEpKu8hjp/WRLv45K069iubb8kXeSS/P
	eF97scFmNj/lf/lRs1/rWk3dUdefGMlt08H7e198Qsr/nIN77CaIr/qwz1A82y+8S4mlOCPR
	UIu5qDgRALI9siy8AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The max77693 MFD device use irq domain method which has hardware interrupt number
and virtual interrupt number getting through irq domain mapping. This patch
use hardware interrupt number instead of virtual interrupt number to get
struct irq_data.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/mfd/max77693-irq.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/max77693-irq.c b/drivers/mfd/max77693-irq.c
index 1029d01..66b58fe 100644
--- a/drivers/mfd/max77693-irq.c
+++ b/drivers/mfd/max77693-irq.c
@@ -128,7 +128,8 @@ static void max77693_irq_sync_unlock(struct irq_data *data)
 static const inline struct max77693_irq_data *
 irq_to_max77693_irq(struct max77693_dev *max77693, int irq)
 {
-	return &max77693_irqs[irq];
+	struct irq_data *data = irq_get_irq_data(irq);
+	return &max77693_irqs[data->hwirq];
 }
 
 static void max77693_irq_mask(struct irq_data *data)
-- 
1.8.0

