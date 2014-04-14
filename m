Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345AbaDNLuJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 07:50:09 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:49976 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755318AbaDNLuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 07:50:04 -0400
X-AuditID: cbfee61b-b7f456d000006dfd-10-534bcb6b96db
From: Robert Baldyga <r.baldyga@samsung.com>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        myungjoo.ham@samsung.com, cw00.choi@samsung.com, dbaryshkov@gmail.com,
        dwmw2@infradead.org, balbi@ti.com, gregkh@linuxfoundation.org,
        grant.likely@linaro.org, ldewangan@nvidia.com, kishon@ti.com,
        gg@slimlogic.co.uk, anton@enomsg.org, jonghwa3.lee@samsung.com,
        rongjun.ying@csr.com, linux@roeck-us.net, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, aaro.koskinen@iki.fi,
        m.szyprowski@samsung.com, t.figa@samsung.com,
        Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH v2 13/13] extcon: extcon-max77693: check if pdata exists
Date: Mon, 14 Apr 2014 13:46:24 +0200
Message-id: <1397475984-28001-14-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1397475984-28001-1-git-send-email-r.baldyga@samsung.com>
References: <1397475984-28001-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAzWRW0iTYRzGe/cdtRZfm+aHStigQCnNMnwpCy9SXhihIkHURU73oaLTsXms
	i1biaambipg5j2k6nYoncmbq53aRWGoYeaFmodPUShBtQpq5YXe//+//wHPx0JjIjHvSiSlp
	nCpFliwhXfGJv0vMxaQJafQlvtYbmr6HQr7fF/KLj+Hs9ioBy5Y3MVhnnSRgqbEcg7ofDQTU
	9d2Co3sDAOa87CLh5LoRwMIPyxicthWRsHm4HYcNeU04nBk0kLC6SYfDxle5GFxueC+AHdYF
	CjbPfhTAuSetJGz5eUBCfWUHDr9azBTsXKvEYe5bKwWHp/cI2PV8Aw89g0y1JoBmSooFaNBs
	IJBetwWQ+cUChYwt2ySy7DTgqLfVD/W0FZJovb2KQPOfh0g0UmOiUHHOLxKtlf4hkdmuoVBJ
	XxuIFN9zDZFzyYkZnCrgZoxrwsjSOlBqqSzNSjmlATuEFrjQLBPElpsXj/g0O/2li9QCV1rE
	NAJWf1B2dOQL2E9148CRIpkLbJ9d72Q3BmPrK6acjDE2gn29e8PBYgax/Ooc5mCcOceuVFgp
	BwuZcNYyPnro6cM2H9ZQFuLQLoear9p3xkVMGDuaM4fpgbAeHGsD7pwyTqmOjVdc9lfLFOr0
	lHj/uFRFD3AOuuI1ANo0cAwwNJCcEBYYpNEiQpahzlaMAZbGJG7CsP5DJZTLsh9yqtQHqvRk
	Tj0GvGhc4iHkc69HiZh4WRqXxHFKTvX/K6BdPDXgUd35yO6naWfvSAs3Ei0nF/k3Psc7tyIL
	8q4t6TyNU0PBtfLfKjrcPuVtiBo9Zk/wfycOvhpT4lMgt3HgfubgwlgMInoF0d/09oDS7vDq
	Uza/HVmRdDOo90q0h+628lnETI2YjcjcjfV3354vbiYD8n0395VZWj4/8O6wd4kEVyfIAv0w
	lVr2D8XUGezMAgAA
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds check if pdata is NULL, to avoid NULL pointer dereference
when platform data is not available. After this changes, in described
situation driver will be configured with default values.

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
---
 drivers/extcon/extcon-max77693.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/extcon/extcon-max77693.c b/drivers/extcon/extcon-max77693.c
index 2cd8892..fa8534e 100644
--- a/drivers/extcon/extcon-max77693.c
+++ b/drivers/extcon/extcon-max77693.c
@@ -1210,7 +1210,7 @@ static int max77693_muic_probe(struct platform_device *pdev)
 
 
 	/* Initialize MUIC register by using platform data or default data */
-	if (pdata->muic_data) {
+	if (pdata && pdata->muic_data) {
 		init_data = pdata->muic_data->init_data;
 		num_init_data = pdata->muic_data->num_init_data;
 	} else {
-- 
1.7.9.5

