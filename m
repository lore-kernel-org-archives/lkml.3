Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755969Ab3FAH1R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 03:27:17 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:56207 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839Ab3FAH1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 03:27:09 -0400
X-AuditID: cbfee690-b7f6f6d00000740c-fb-51a9a24cc2bd
From: Jingoo Han <jg1.han@samsung.com>
To: "'Anton Vorontsov'" <cbou@mail.ru>
Cc: Anton Vorontsov <avorontsov@ru.mvista.com>,
        "'David Woodhouse'" <dwmw2@infradead.org>,
        linux-kernel@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH] power: replace strict_strtoul() with kstrtoul()
Date: Sat, 01 Jun 2013 16:27:08 +0900
Message-id: <001101ce5e99$6c8efb00$45acf100$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5emTdmkVe1JZhLQ5O8hRub2p9CXQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrAIsWRmVeSWpSXmKPExsVy+t8zI12fRSsDDf59VrPYe/Uuk8WvnduY
	LSaunMxscXnhJVaLy7vmsDmwemxeoeUxZe4RVo85x+axePRtWcXo8XmTXABrFJdNSmpOZllq
	kb5dAlfG+RNz2Qsm8VXcnrKauYHxNHcXIyeHhICJxMd5E9ggbDGJC/fWA9lcHEICyxgl3jR8
	Zocpmvn8LTNEYhGjxIxPtxkhnF+MEs3XV4BVsQmoSXz5chjMFhFQkZh57xATSBGzwGxGic89
	D1lAEsICDhJfvnYBjeLgYBFQlXiyVBMkzCtgKXHq/CVWCFtQ4sfke2DlzAJaEut3HmeCsOUl
	Nq8BuQLkIgWJHWdfM0Ls0pPY9GE1K0SNiMS+F+/AjpMQOMYusbmvEyzBIiAg8W3yIRaQvRIC
	shKbDkDNkZQ4uOIGywRGsVlIVs9CsnoWktWzkKxYwMiyilE0tSC5oDgpvchErzgxt7g0L10v
	OT93EyMk9ibsYLx3wPoQYzLQ+onMUqLJ+cDYzSuJNzQ2M7IwNTE1NjK3NCNNWEmcV73FOlBI
	ID2xJDU7NbUgtSi+qDQntfgQIxMHp1QD43rV8I9+zufC3f8pnnondfRBefQJ46CNmaat5ZFO
	c5okEjmys74/CVq3K+eWYzPXwVlp7rGrblu5dK7MOe/UdnL79pOvsnTdyjznb/Av31p/5e/C
	pmzj93Yh7Sc7A398nXrEfLqQzvkll0On3A19eHTvWunpe0+f2RdhHM9ZP3d3AldezIIvu5VY
	ijMSDbWYi4oTAXTMXbDTAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLKsWRmVeSWpSXmKPExsVy+t9jAV2fRSsDDbZ0KVvsvXqXyeLXzm3M
	FhNXTma2uLzwEqvF5V1z2BxYPTav0PKYMvcIq8ecY/NYPPq2rGL0+LxJLoA1qoHRJiM1MSW1
	SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdouZJCWWJOKVAoILG4
	WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4x4/yJuewFk/gqbk9ZzdzAeJq7i5GTQ0LARGLm
	87fMELaYxIV769m6GLk4hAQWMUrM+HSbEcL5xSjRfH0FO0gVm4CaxJcvh8FsEQEViZn3DjGB
	FDELzGaU+NzzkAUkISzgIPHlaxfQWA4OFgFViSdLNUHCvAKWEqfOX2KFsAUlfky+B1bOLKAl
	sX7ncSYIW15i8xqYixQkdpx9zQixS09i04fVrBA1IhL7XrxjnMAoMAvJqFlIRs1CMmoWkpYF
	jCyrGEVTC5ILipPScw31ihNzi0vz0vWS83M3MYIj+5nUDsaVDRaHGAU4GJV4eA1WrAgUYk0s
	K67MPcQowcGsJMK7csHKQCHelMTKqtSi/Pii0pzU4kOMyUCPTmSWEk3OByadvJJ4Q2MTMyNL
	IzMLIxNzc9KElcR5D7RaBwoJpCeWpGanphakFsFsYeLglGpg1OluZXI3OXZQp32nCcPNZ0Gr
	MjbcSZ6as+WRIH/gvZKSu/5X7gsauMiLiHYvVNm58eOOmnLpSRaTbZjUdp9++e3XHE/JAykL
	92/msbh2l28f77FYJ4Fwq0SOyR8eHH1R37Nz65fi7YoGC9YlhO1fJPDw47GpoRe+uCyQ1ttt
	e/busbubW/eeElFiKc5INNRiLipOBAD9eGEEMAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The usage of strict_strtoul() is not preferred, because
strict_strtoul() is obsolete. Thus, kstrtoul() should be
used.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/power/ab8500_fg.c        |    4 ++--
 drivers/power/pcf50633-charger.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/power/ab8500_fg.c b/drivers/power/ab8500_fg.c
index c5391f5..6207b5e 100644
--- a/drivers/power/ab8500_fg.c
+++ b/drivers/power/ab8500_fg.c
@@ -2467,7 +2467,7 @@ static ssize_t charge_full_store(struct ab8500_fg *di, const char *buf,
 	unsigned long charge_full;
 	ssize_t ret = -EINVAL;
 
-	ret = strict_strtoul(buf, 10, &charge_full);
+	ret = kstrtoul(buf, 10, &charge_full);
 
 	dev_dbg(di->dev, "Ret %zd charge_full %lu", ret, charge_full);
 
@@ -2489,7 +2489,7 @@ static ssize_t charge_now_store(struct ab8500_fg *di, const char *buf,
 	unsigned long charge_now;
 	ssize_t ret;
 
-	ret = strict_strtoul(buf, 10, &charge_now);
+	ret = kstrtoul(buf, 10, &charge_now);
 
 	dev_dbg(di->dev, "Ret %zd charge_now %lu was %d",
 		ret, charge_now, di->bat_cap.prev_mah);
diff --git a/drivers/power/pcf50633-charger.c b/drivers/power/pcf50633-charger.c
index 17fd77f..92f0ea0 100644
--- a/drivers/power/pcf50633-charger.c
+++ b/drivers/power/pcf50633-charger.c
@@ -191,7 +191,7 @@ static ssize_t set_usblim(struct device *dev,
 	unsigned long ma;
 	int ret;
 
-	ret = strict_strtoul(buf, 10, &ma);
+	ret = kstrtoul(buf, 10, &ma);
 	if (ret)
 		return -EINVAL;
 
@@ -228,7 +228,7 @@ static ssize_t set_chglim(struct device *dev,
 	if (!mbc->pcf->pdata->charger_reference_current_ma)
 		return -ENODEV;
 
-	ret = strict_strtoul(buf, 10, &ma);
+	ret = kstrtoul(buf, 10, &ma);
 	if (ret)
 		return -EINVAL;
 
-- 
1.7.10.4


