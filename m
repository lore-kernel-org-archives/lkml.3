Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756156AbaJXKSu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 06:18:50 -0400
Received: from galahad.ideasonboard.com ([185.26.127.97]:44711 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755488AbaJXKSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 06:18:47 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-sh@vger.kernel.org, Marek Szyprowski <m.szyprowski@samsung.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Michal Nazarewicz <mina86@mina86.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Weijie Yang <weijie.yang.kh@gmail.com>
Subject: [PATCH v2 1/4] mm: cma: Don't crash on allocation if CMA area can't be activated
Date: Fri, 24 Oct 2014 13:18:39 +0300
Message-Id: <1414145922-26042-2-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1414145922-26042-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1414145922-26042-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If activation of the CMA area fails its mutex won't be initialized,
leading to an oops at allocation time when trying to lock the mutex. Fix
this by setting the cma area count field to 0 when activation fails,
leading to allocation returning NULL immediately.

Cc: <stable@vger.kernel.org>  # v3.17
Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Acked-by: Michal Nazarewicz <mina86@mina86.com>
---
 mm/cma.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/cma.c b/mm/cma.c
index 963bc4add9af..5aa1a6f74dec 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -124,6 +124,7 @@ static int __init cma_activate_area(struct cma *cma)
 
 err:
 	kfree(cma->bitmap);
+	cma->count = 0;
 	return -EINVAL;
 }
 
-- 
2.0.4

