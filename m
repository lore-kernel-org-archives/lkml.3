Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755737Ab3CFHzR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 02:55:17 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:53467 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755450Ab3CFHzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 02:55:14 -0500
X-AuditID: cbfee68e-b7fa46d00000627e-ad-5136f661edbf
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <007b01ce1a3e$cd9f3260$68dd9720$%han@samsung.com>
In-reply-to: <007b01ce1a3e$cd9f3260$68dd9720$%han@samsung.com>
Subject: [PATCH V2 23/30] rtc: rtc-stk17ta8: use devm_rtc_device_register()
Date: Wed, 06 Mar 2013 16:55:12 +0900
Message-id: <009101ce1a3f$eea7f6d0$cbf7e470$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4aPs2G+X8TED9/S2OjRUc7S5yKjAAARbwQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPIsWRmVeSWpSXmKPExsVy+t8zI93Eb2aBBj/aeC0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGrwNn2Qr6uSoePP3O0sC4g6OLkZNDQsBEYl3zMxYIW0ziwr31
	bF2MXBxCAssYJWZ8fMwKU/Th5Ad2iMQiRon+P1uYIZzZTBJHtzUzgVSxCahJfPlyGKiKg0NE
	QF+irUUDpIZZoJdR4kzvbrC4kICtRM88HpByTgE7iSkTH7OD2MIC3hKPnl1kBLFZBFQlvvV3
	go3kBSq/+KaZEcIWlPgx+R7YpcwCWhLrdx5ngrDlJTavecsMMl5CQF3i0V9dkLCIgJHEpE2b
	GCFKRCT2vXjHCHKOhMAydon5HxayQ+wSkPg2+RALRK+sxKYDzBD/SkocXHGDZQKjxCwkm2ch
	2TwLyeZZSFYsYGRZxSiaWpBcUJyUXmSkV5yYW1yal66XnJ+7iRESWX07GG8esD7EmAy0fiKz
	lGhyPjAy80riDY2NTcxMTE3MLU3NTUkTVhLnlb8kEygkkJ5YkpqdmlqQWhRfVJqTWnyIkYmD
	U6qBscnEXuf7leVdbcqcL8vDo9cnmPuuaa8U/JRkHHXlxdPy6Ow0kd9d4f/3Oa/YXyyy/nxs
	Pufu6/aXOc2ULJdEvxfbKWPHsPpCy5a9L6783xO1l6/zXbOSbt+dDYdvVbyS1ormq5G36Tyb
	s1UiYsfL5knfpG4sfh1acGo34zPDb2sfF7WVKjh9UGIpzkg01GIuKk4EAE6EIZnCAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphleLIzCtJLcpLzFFi42I5/e+xgG7iN7NAg/WN7BaXd81hc2D0+LxJ
	LoAxqoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdo
	qpJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4x49eBs2wF/VwVD55+Z2lg
	3MHRxcjJISFgIvHh5Ad2CFtM4sK99WxdjFwcQgKLGCX6/2xhhnBmM0kc3dbMBFLFJqAm8eXL
	YaAODg4RAX2JthYNkBpmgV5GiTO9u8HiQgK2Ej3zeEDKOQXsJKZMfAy2QFjAW+LRs4uMIDaL
	gKrEt/5OsJG8QOUX3zQzQtiCEj8m32MBsZkFtCTW7zzOBGHLS2xe85YZZLyEgLrEo7+6IGER
	ASOJSZs2MUKUiEjse/GOcQKj0Cwkk2YhmTQLyaRZSFoWMLKsYhRNLUguKE5KzzXUK07MLS7N
	S9dLzs/dxAiO22dSOxhXNlgcYhTgYFTi4bVQMgsUYk0sK67MPcQowcGsJMLLdQYoxJuSWFmV
	WpQfX1Sak1p8iDEZ6NGJzFKiyfnAlJJXEm9obGJmZGlkZmFkYm5OmrCSOC/jqScBQgLpiSWp
	2ampBalFMFuYODilGhjP70hgP522gflfoMXtxNPTD7f2TvViuPehbFbJ25kMp/y1j/GY8TcL
	nVg5uf7r0Xk5a3Uufdog0PRf5HnvzqS5XF59LU8Wfp1wc8vxuyX6aRPOb5NYnyDhsHmi9dUr
	qu5pMw+e/fTjovF1HdVMX92YHbpXb14Vm7dm30Imw+srFBou5Nj3Hj+mrMRSnJFoqMVcVJwI
	AEwKB2UfAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_rtc_device_register() is device managed and makes cleanup
paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
Changes since v1:
- used 'struct device *dev' as the first argument

 drivers/rtc/rtc-stk17ta8.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/rtc/rtc-stk17ta8.c b/drivers/rtc/rtc-stk17ta8.c
index 7e4a6f6..af5e97e 100644
--- a/drivers/rtc/rtc-stk17ta8.c
+++ b/drivers/rtc/rtc-stk17ta8.c
@@ -336,14 +336,13 @@ static int stk17ta8_rtc_probe(struct platform_device *pdev)
 		}
 	}
 
-	pdata->rtc = rtc_device_register(pdev->name, &pdev->dev,
+	pdata->rtc = devm_rtc_device_register(&pdev->dev, pdev->name,
 				  &stk17ta8_rtc_ops, THIS_MODULE);
 	if (IS_ERR(pdata->rtc))
 		return PTR_ERR(pdata->rtc);
 
 	ret = sysfs_create_bin_file(&pdev->dev.kobj, &stk17ta8_nvram_attr);
-	if (ret)
-		rtc_device_unregister(pdata->rtc);
+
 	return ret;
 }
 
@@ -352,7 +351,6 @@ static int stk17ta8_rtc_remove(struct platform_device *pdev)
 	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
 
 	sysfs_remove_bin_file(&pdev->dev.kobj, &stk17ta8_nvram_attr);
-	rtc_device_unregister(pdata->rtc);
 	if (pdata->irq > 0)
 		writeb(0, pdata->ioaddr + RTC_INTERRUPTS);
 	return 0;
-- 
1.7.2.5


