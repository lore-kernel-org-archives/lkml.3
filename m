Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234Ab3H3ENN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 00:13:13 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:57323 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753511Ab3H3ENL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 00:13:11 -0400
X-AuditID: cbfee68f-b7f656d0000058e3-8a-52201bd6b86e
From: Jingoo Han <jg1.han@samsung.com>
To: "'Hans J. Koch'" <hjk@hansjkoch.de>
Cc: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
References: <002b01cea537$10ed8930$32c89b90$%han@samsung.com>
In-reply-to: <002b01cea537$10ed8930$32c89b90$%han@samsung.com>
Subject: [PATCH 2/3] drivers: uio_pdrv_genirq: use dev_get_platdata()
Date: Fri, 30 Aug 2013 13:13:11 +0900
Message-id: <002c01cea537$3d5380b0$b7fa8210$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6lNxC0zCCz2b5JSCutk7ruoAGsQQAABE2w
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOIsWRmVeSWpSXmKPExsVy+t8zI91r0gpBBqvuqVk0L17PZnH07HR2
	i8sLL7FaXN41h82BxWP+Qy+P/XPXsHv0bVnF6PF5k1wASxSXTUpqTmZZapG+XQJXxozWG2wF
	k9krvp9dz9jA2MrWxcjJISFgInHoy2pWCFtM4sK99WBxIYFljBJT93PA1Cyfvpixi5ELKD6d
	UWLnw+nMEM4vRolvJx8zglSxCahJfPlymL2LkYNDREBd4mdLHIjJLFApsbg7BsQUErCV+LIc
	bDyngJ3EnXMTwNYKC7hKfHl5CGwIi4CqxMcHM5lBynmBytetSwAJ8woISvyYfI8FxGYW0JJY
	v/M4E4QtL7F5zVuwcgmgnY/+6kKsN5JY8cUBokJEYt+Ld2C3SwgcY5c4fvcVG8QmAYlvkw+x
	QLTKSmw6wAzxq6TEwRU3WCYwSsxCsngWksWzkCyehWTFAkaWVYyiqQXJBcVJ6UXGesWJucWl
	eel6yfm5mxghkdi/g/HuAetDjMlA6ycyS4km5wMjOa8k3tDYzMjC1MTU2Mjc0ow0YSVxXrUW
	60AhgfTEktTs1NSC1KL4otKc1OJDjEwcnFINjPtnPnW0yXP/zmX0+/PBg8d/OrnrmCYu7pCv
	YuF1dpRt/fbS6dma7hkSqhppst6r43t+XWC62WZ3zPeDq5ZvtPopNS6OlRvPhXHuFHafkece
	ZsHWedxr7b/IdXdeHjZUqeGS+KoZp32q4eXTkJYnsSI/TpudehfsdEKrsj5i026rnylCy//v
	UmIpzkg01GIuKk4EADpTXXvaAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKKsWRmVeSWpSXmKPExsVy+t9jQd1r0gpBBtu+KVk0L17PZnH07HR2
	i8sLL7FaXN41h82BxWP+Qy+P/XPXsHv0bVnF6PF5k1wAS1QDo01GamJKapFCal5yfkpmXrqt
	kndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0EolhbLEnFKgUEBicbGSvh2mCaEhbroW
	MI0Rur4hQXA9RgZoIGEdY8aM1htsBZPZK76fXc/YwNjK1sXIySEhYCKxfPpiRghbTOLCvfVA
	cS4OIYHpjBI7H05nhnB+MUp8O/kYrIpNQE3iy5fD7F2MHBwiAuoSP1viQExmgUqJxd0xIKaQ
	gK3El+Vg4zkF7CTunJvACmILC7hKfHl5CGwIi4CqxMcHM5lBynmBytetSwAJ8woISvyYfI8F
	xGYW0JJYv/M4E4QtL7F5zVuwcgmgnY/+6kKsN5JY8cUBokJEYt+Ld4wTGIVmIRk0C8mgWUgG
	zULSsoCRZRWjaGpBckFxUnquoV5xYm5xaV66XnJ+7iZGcKQ/k9rBuLLB4hCjAAejEg/vg2D5
	ICHWxLLiytxDjBIczEoivPHbgEK8KYmVValF+fFFpTmpxYcYk4HenMgsJZqcD0xCeSXxhsYm
	ZkaWRmYWRibm5qQJK4nzHmi1DhQSSE8sSc1OTS1ILYLZwsTBKdXAqLee8dTd6H3P2a/5PY5J
	kjVb7yfz/Pu2Q3MWumzhFAlIfHXkkd8jG0VxLvdX95t+r+raJsYmWTpf6sp84ylVs+flMZqq
	Lr5737/DVs6Wv69pjmjkY6UnIsESQutXRX7NZ/jO/N9z0o3upNf7vl5ZaO6fteqQTm978r+1
	AeXfOd2n2394MeUUpxJLcUaioRZzUXEiAKF6UOU4AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the wrapper function for retrieving the platform data instead of
accessing dev->platform_data directly. This is a cosmetic change
to make the code simpler and enhance the readability.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/uio/uio_pdrv_genirq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/uio/uio_pdrv_genirq.c b/drivers/uio/uio_pdrv_genirq.c
index 4eb8eaf..90ff17a 100644
--- a/drivers/uio/uio_pdrv_genirq.c
+++ b/drivers/uio/uio_pdrv_genirq.c
@@ -104,7 +104,7 @@ static int uio_pdrv_genirq_irqcontrol(struct uio_info *dev_info, s32 irq_on)
 
 static int uio_pdrv_genirq_probe(struct platform_device *pdev)
 {
-	struct uio_info *uioinfo = pdev->dev.platform_data;
+	struct uio_info *uioinfo = dev_get_platdata(&pdev->dev);
 	struct uio_pdrv_genirq_platdata *priv;
 	struct uio_mem *uiomem;
 	int ret = -EINVAL;
-- 
1.7.10.4


