Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752923Ab3D2JPg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 05:15:36 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:20868 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639Ab3D2JPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 05:15:34 -0400
X-AuditID: cbfee68f-b7f066d000003683-6c-517e3a2e092a
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Wim Van Sebroeck'" <wim@iguana.be>,
        linux-watchdog@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH RESEND 1/5] watchdog: dw_wdt: use devm_clk_get()
Date: Mon, 29 Apr 2013 18:15:26 +0900
Message-id: <000201ce44ba$160fc0a0$422f41e0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5Eug8vIgNymBs4Sv+NjnyttqOb0g==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNIsWRmVeSWpSXmKPExsVy+t8zA109q7pAg13XTSzmrF/DZnF54SVW
	i8u75rBZ3Fi3j93i1owXrA6sHtc2i3mcmPGbxaNvyypGj8+b5AJYorhsUlJzMstSi/TtErgy
	2k7tZylYwVnRvvorUwPjJfYuRk4OCQETiRctX5kgbDGJC/fWs3UxcnEICSxjlLh5dD0jTNHs
	/WvYIRLTGSWWH/rMBOH8YpRY1buIGaSKTUBN4suXw0BVHBwiAvoSbS0aIDXMAh2MEgeeLmUF
	qREWcJCYPPcOmM0ioCrxZd0MsF5eAUuJTYtOQdmCEj8m32MBsZkFtCTW7zzOBGHLS2xe85YZ
	4iIFiR1nX4NdJyKgJ9FwcQ8zRI2IxL4X7xhBFksI7GOX2NK7mB1imYDEt8mHWECOkxCQldh0
	AGqOpMTBFTdYJjCKzUKyehaS1bOQrJ6FZMUCRpZVjKKpBckFxUnpRcZ6xYm5xaV56XrJ+bmb
	GCER17+D8e4B60OMyUDrJzJLiSbnAyM2ryTe0NjMyMLUxNTYyNzSjDRhJXFetRbrQCGB9MSS
	1OzU1ILUovii0pzU4kOMTBycUg2MbPWblP2nSGb8/SF9zY07rz9v4judutIXHndeX3c7GsYZ
	OfV4QHCCavUrW1aHWYa7NzL+3RYuv9ZN0TTsR5h8JPvGo0eqH1tm7F9VnbhVZc3sZNMlZY8e
	yCoUn+C1rHnW67D+3gOXdW4Lv89925OnlPrry77yIy+rHjUWBXvPPsM67dPnsBNlSizFGYmG
	WsxFxYkAVM4M084CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBKsWRmVeSWpSXmKPExsVy+t9jQV09q7pAgynvDCzmrF/DZnF54SVW
	i8u75rBZ3Fi3j93i1owXrA6sHtc2i3mcmPGbxaNvyypGj8+b5AJYohoYbTJSE1NSixRS85Lz
	UzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOA9ioplCXmlAKFAhKLi5X07TBN
	CA1x07WAaYzQ9Q0JgusxMkADCesYM9pO7WcpWMFZ0b76K1MD4yX2LkZODgkBE4nZ+9dA2WIS
	F+6tZ+ti5OIQEpjOKLH80GcmCOcXo8Sq3kXMIFVsAmoSX74cBurg4BAR0Jdoa9EAqWEW6GCU
	OPB0KStIjbCAg8TkuXfAbBYBVYkv62aA9fIKWEpsWnQKyhaU+DH5HguIzSygJbF+53EmCFte
	YvOat8wQFylI7Dj7mhHEFhHQk2i4uIcZokZEYt+Ld4wTGAVmIRk1C8moWUhGzULSsoCRZRWj
	aGpBckFxUnqukV5xYm5xaV66XnJ+7iZGcDw/k97BuKrB4hCjAAejEg9vwObaQCHWxLLiytxD
	jBIczEoivIpGdYFCvCmJlVWpRfnxRaU5qcWHGJOBPp3ILCWanA9MNXkl8YbGJmZGlkZmFkYm
	5uakCSuJ8x5stQ4UEkhPLEnNTk0tSC2C2cLEwSnVwOhovGrSHb5HDn4PI6a1/5/Sfuh62nfG
	k8teS7wRzd1Qp/GyNV3cJl84lFVIW3/BAQ6Nb17y7w44uGus/ViX9FHwaRunpk9c1vVHJzid
	VqWsW+jgdG5fbLXCDb3J2+rSPf9lvzo/V3PphRc+1ZN3bmM+zz0x+z9/R03Yivu/tTgbVnML
	7GlgDFFiKc5INNRiLipOBAAC9NOVKwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_clk_get() to make cleanup paths more simple.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/watchdog/dw_wdt.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/watchdog/dw_wdt.c b/drivers/watchdog/dw_wdt.c
index 2037669..2e70fd0 100644
--- a/drivers/watchdog/dw_wdt.c
+++ b/drivers/watchdog/dw_wdt.c
@@ -305,13 +305,13 @@ static int dw_wdt_drv_probe(struct platform_device *pdev)
 	if (IS_ERR(dw_wdt.regs))
 		return PTR_ERR(dw_wdt.regs);
 
-	dw_wdt.clk = clk_get(&pdev->dev, NULL);
+	dw_wdt.clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(dw_wdt.clk))
 		return PTR_ERR(dw_wdt.clk);
 
 	ret = clk_enable(dw_wdt.clk);
 	if (ret)
-		goto out_put_clk;
+		return ret;
 
 	spin_lock_init(&dw_wdt.lock);
 
@@ -327,8 +327,6 @@ static int dw_wdt_drv_probe(struct platform_device *pdev)
 
 out_disable_clk:
 	clk_disable(dw_wdt.clk);
-out_put_clk:
-	clk_put(dw_wdt.clk);
 
 	return ret;
 }
@@ -338,7 +336,6 @@ static int dw_wdt_drv_remove(struct platform_device *pdev)
 	misc_deregister(&dw_wdt_miscdev);
 
 	clk_disable(dw_wdt.clk);
-	clk_put(dw_wdt.clk);
 
 	return 0;
 }
-- 
1.7.2.5


