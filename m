Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752255AbaEWKZu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 06:25:50 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:28806 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474AbaEWKZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 06:25:46 -0400
X-AuditID: cbfee68f-b7fef6d000003970-6f-537f22139d65
From: Jaehoon Chung <jh80.chung@samsung.com>
To: linux-mmc@vger.kernel.org
Cc: Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Seungwon Jeon <tgih.jun@samsung.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Jaehoon Chung <jh80.chung@samsung.com>
Subject: [PATCH 2/3] mmc: dw_mmc: use the __mmc_of_parse to parse the slot node
Date: Fri, 23 May 2014 19:25:20 +0900
Message-id: <1400840721-11050-3-git-send-email-jh80.chung@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1400840721-11050-1-git-send-email-jh80.chung@samsung.com>
References: <1400840721-11050-1-git-send-email-jh80.chung@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPLMWRmVeSWpSXmKPExsWyRsSkWFdYqT7YYEmbmcWEy9sZLeYfOcdq
	ceNXG6vF5V1z2CyO/O9ntJhxfh+TxaGZyRYf7l9ktji+NtyB02PBr60sHneu7WHzuPFqIZNH
	35ZVjB6fN8kFsEZx2aSk5mSWpRbp2yVwZey53s5W8Fykou/vDqYGxibBLkZODgkBE4m2LW9Z
	IGwxiQv31rN1MXJxCAksZZQ4ev4EC0zRxW/NTBCJRYwSnWfmsUI4bUwSbdchqtgEdCS2fzvO
	BGKLCMhK/PxzAWwUs8BqJomjy38zgySEBfwl2u5tZwexWQRUJZa2gezj5OAVcJNo650FNJUD
	aJ2CxJxJNiBhTgF3iXlzL7KC2EJAJR+2zwObKSGwjl3i86PjrBBzBCS+TT7EAtErK7HpADPE
	1ZISB1fcYJnAKLyAkWEVo2hqQXJBcVJ6kbFecWJucWleul5yfu4mRmDgn/73rH8H490D1ocY
	k4HGTWSWEk3OB0ZOXkm8obGZkYWpiamxkbmlGWnCSuK89x8mBQkJpCeWpGanphakFsUXleak
	Fh9iZOLglGpg3LjczcMo2cPxjNW7RONX1xXVPX87lRZOzxcTmHRdqvRNi7VbhvKHg5wON41k
	Jgo76BteFeF7MeXQfeb9QTGRa90MBN5IKSn0HXxsUNevX7BTNio4xfTBrUdnd3fJtEcJsDvG
	r9mQYnn2+7ToZ9t9bbPtJlz3evspSMDf8GaZ1iq945K6ibuVWIozEg21mIuKEwG7eGyXkgIA	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDIsWRmVeSWpSXmKPExsVy+t9jAV1hpfpgg7n9ehYTLm9ntJh/5Byr
	xY1fbawWl3fNYbM48r+f0WLG+X1MFodmJlt8uH+R2eL42nAHTo8Fv7ayeNy5tofN48arhUwe
	fVtWMXp83iQXwBrVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk
	4hOg65aZA3SPkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMDNJCwhjFjz/V2toLn
	IhV9f3cwNTA2CXYxcnJICJhIXPzWzARhi0lcuLeerYuRi0NIYBGjROeZeawQThuTRNv1Eywg
	VWwCOhLbvx0H6xARkJX4+ecCWAezwGomiaPLfzODJIQF/CXa7m1nB7FZBFQllraBjOXk4BVw
	k2jrnQU0lQNonYLEnEk2IGFOAXeJeXMvsoLYQkAlH7bPY5vAyLuAkWEVo2hqQXJBcVJ6rqFe
	cWJucWleul5yfu4mRnBcPZPawbiyweIQowAHoxIP7wOmumAh1sSy4srcQ4wSHMxKIrxnZOuD
	hXhTEiurUovy44tKc1KLDzEmAx01kVlKNDkfGPN5JfGGxiZmRpZG5oYWRsbmpAkrifMeaLUO
	FBJITyxJzU5NLUgtgtnCxMEp1cC4rXH1jJXR1t4B2TWBa9NYdijWe/09JDf3zIGVQm/+amWm
	RapcT9h193blugXNCy1jdPm2riv3zn53+uWz71L+P970u78sPrvVuuRTjX17r6hD+wee//vn
	XFhecCKMZ14uv6OWQeiML59n7uzQkkq5r2vYOUFv+uFAqzRVL5f5d7RbFiZ26s5QYinOSDTU
	Yi4qTgQA4hSboO8CAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dw-mmc controller have the multiple slot.
Then it needs to parse the property for each slot.

Signed-off-by: Jaehoon Chung <jh80.chung@samsung.com>
---
 drivers/mmc/host/dw_mmc.c |   25 ++++++-------------------
 1 file changed, 6 insertions(+), 19 deletions(-)

diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
index 1ac227c..d4800f8 100644
--- a/drivers/mmc/host/dw_mmc.c
+++ b/drivers/mmc/host/dw_mmc.c
@@ -1015,12 +1015,11 @@ static int dw_mci_get_cd(struct mmc_host *mmc)
 {
 	int present;
 	struct dw_mci_slot *slot = mmc_priv(mmc);
-	struct dw_mci_board *brd = slot->host->pdata;
 	struct dw_mci *host = slot->host;
 	int gpio_cd = mmc_gpio_get_cd(mmc);
 
 	/* Use platform get_cd function, else try onboard card detect */
-	if (brd->quirks & DW_MCI_QUIRK_BROKEN_CARD_DETECTION)
+	if (slot->quirks & DW_MCI_QUIRK_BROKEN_CARD_DETECTION)
 		present = 1;
 	else if (!IS_ERR_VALUE(gpio_cd))
 		present = gpio_cd;
@@ -2010,6 +2009,9 @@ static struct dw_mci_of_slot_quirks {
 	{
 		.quirk	= "disable-wp",
 		.id	= DW_MCI_SLOT_QUIRK_NO_WRITE_PROTECT,
+	}, {
+		.quirk	= "broken-cd",
+		.id	= DW_MCI_QUIRK_BROKEN_CARD_DETECTION,
 	},
 };
 
@@ -2088,7 +2090,7 @@ static int dw_mci_init_slot(struct dw_mci *host, unsigned int id)
 	if (host->pdata->caps2)
 		mmc->caps2 = host->pdata->caps2;
 
-	mmc_of_parse(mmc);
+	__mmc_of_parse(mmc, dw_mci_of_find_slot_node(host->dev, slot->id));
 
 	if (host->pdata->blk_settings) {
 		mmc->max_segs = host->pdata->blk_settings->max_segs;
@@ -2231,23 +2233,13 @@ static inline bool dw_mci_ctrl_all_reset(struct dw_mci *host)
 }
 
 #ifdef CONFIG_OF
-static struct dw_mci_of_quirks {
-	char *quirk;
-	int id;
-} of_quirks[] = {
-	{
-		.quirk	= "broken-cd",
-		.id	= DW_MCI_QUIRK_BROKEN_CARD_DETECTION,
-	},
-};
-
 static struct dw_mci_board *dw_mci_parse_dt(struct dw_mci *host)
 {
 	struct dw_mci_board *pdata;
 	struct device *dev = host->dev;
 	struct device_node *np = dev->of_node;
 	const struct dw_mci_drv_data *drv_data = host->drv_data;
-	int idx, ret;
+	int ret;
 	u32 clock_frequency;
 
 	pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
@@ -2264,11 +2256,6 @@ static struct dw_mci_board *dw_mci_parse_dt(struct dw_mci *host)
 		pdata->num_slots = 1;
 	}
 
-	/* get quirks */
-	for (idx = 0; idx < ARRAY_SIZE(of_quirks); idx++)
-		if (of_get_property(np, of_quirks[idx].quirk, NULL))
-			pdata->quirks |= of_quirks[idx].id;
-
 	if (of_property_read_u32(np, "fifo-depth", &pdata->fifo_depth))
 		dev_info(dev, "fifo-depth property not found, using "
 				"value of FIFOTH register as default\n");
-- 
1.7.9.5

