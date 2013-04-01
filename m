Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758761Ab3DAN6b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 09:58:31 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:12220 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758585Ab3DAN60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 09:58:26 -0400
X-AuditID: cbfee691-b7f5f6d000002fda-c4-515992803f0f
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-omap@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org, balbi@ti.com,
        stern@rowland.harvard.edu, sarah.a.sharp@linux.intel.com,
        rob.herring@calxeda.com, kgene.kim@samsung.com, kishon@ti.com,
        dianders@chromium.org, t.figa@samsung.com, p.paneri@samsung.com
Subject: [PATCH v3 07/11] usb: phy: samsung: Enable runtime power management on
 usb2phy
Date: Mon, 01 Apr 2013 19:24:06 +0530
Message-id: <1364824448-14732-8-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
In-reply-to: <1364824448-14732-1-git-send-email-gautam.vivek@samsung.com>
References: <1364824448-14732-1-git-send-email-gautam.vivek@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGIsWRmVeSWpSXmKPExsWyRsSkWrdhUmSgwfaHZhYH79dbnF12kM2i
	efF6NoveBVfZLC487WGzuLxrDpvF7CX9LBYzzu9jsli0rJXZ4vyWTiaLwysOMFk0nzjFbDHh
	9wU2i/UzXrM48Hks+HyF3WN2w0UWj3knAz32z10D5N39wejRt2UVo8fxG9uZPD5vkgvgiOKy
	SUnNySxLLdK3S+DK2LryAVvBLPaKO8cPMDUw9rN1MXJySAiYSNw48AHKFpO4cG89kM3FISSw
	lFFi0cIjjDBF/e/Ws0AkFjFKvFh8DapqCpPEhGc/mUCq2AR0JZre7gLq4OAQEYiT2DxBGCTM
	LNDFJLH0qDiILSwQKbH48V92EJtFQFXifH8fWCuvgIfEixv/WSGWKUi8uf2MGcTmFPCU+LB1
	MViNEFBN+9UTrCB7JQTusUtcmr6bCWKQgMS3yYdYQPZKCMhKbDrADDFHUuLgihssExiFFzAy
	rGIUTS1ILihOSi8y1StOzC0uzUvXS87P3cQIjKPT/55N3MF4/4D1IcZkoHETmaVEk/OBcZhX
	Em9obGZkYWpiamxkbmlGmrCSOK96i3WgkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBkYuJocD
	zx8qySnvtLz89Mqlt8kLb5r8mLJ3IS+nPQ9vROdlW4sbC7qaVt6rEa8oWnVVKCT1lrGbxu1/
	jX82s1hP5Bd2fS038/eaTxEG3R+7r4iwvNJy1vdQvCH0rOJ/hLhq9SrPOduaZlrwH/DYuLPE
	PT69NzHwxbFCmS8bblSZtX17Xb7Ob5oSS3FGoqEWc1FxIgBvPtw1uQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmleLIzCtJLcpLzFFi42I5/e+xgG7DpMhAg7ntehYH79dbnF12kM2i
	efF6NoveBVfZLC487WGzuLxrDpvF7CX9LBYzzu9jsli0rJXZ4vyWTiaLwysOMFk0nzjFbDHh
	9wU2i/UzXrM48Hks+HyF3WN2w0UWj3knAz32z10D5N39wejRt2UVo8fxG9uZPD5vkgvgiGpg
	tMlITUxJLVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wBultJoSwx
	pxQoFJBYXKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjDmLF15QO2glnsFXeOH2BqYOxn62Lk
	5JAQMJHof7eeBcIWk7hwbz1QnItDSGARo8SLxdegnClMEhOe/WQCqWIT0JVoeruLsYuRg0NE
	IE5i8wRhkDCzQBeTxNKj4iC2sECkxOLHf9lBbBYBVYnz/X1grbwCHhIvbvxnhVimIPHm9jNm
	EJtTwFPiw9bFYDVCQDXtV0+wTmDkXcDIsIpRNLUguaA4KT3XUK84Mbe4NC9dLzk/dxMjOEqf
	Se1gXNlgcYhRgINRiYc34kJEoBBrYllxZe4hRgkOZiUR3hWZkYFCvCmJlVWpRfnxRaU5qcWH
	GJOBrprILCWanA9MIHkl8YbGJuamxqaWJhYmZpakCSuJ8x5otQ4UEkhPLEnNTk0tSC2C2cLE
	wSnVwNhjxPGx5gFXv+6Khz0WrrbfVFjay9e6S+sHHp1WuuOK3NXeiQGmMyb+7P7ZLXvml/at
	w9M4FXsXqS17W+bk7nJhmsMn68Cen0asCQdmNPtYO3OzvpjgU6nWYhNvc6Dslvvb29f/OLrb
	WMxtbHkvuTrnwcqTbI8kDCeYLIi297y1+a7k+5TjzkosxRmJhlrMRcWJAG1LaDsWAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable autosuspending of Samsung usb2.0 PHY

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---
 drivers/usb/phy/phy-samsung-usb2.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/phy/phy-samsung-usb2.c b/drivers/usb/phy/phy-samsung-usb2.c
index 45ffe03..d378fe9 100644
--- a/drivers/usb/phy/phy-samsung-usb2.c
+++ b/drivers/usb/phy/phy-samsung-usb2.c
@@ -423,6 +423,9 @@ static int samsung_usb2phy_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, sphy);
 
+	pm_runtime_set_active(&pdev->dev);
+	pm_runtime_enable(&pdev->dev);
+
 	return usb_add_phy(&sphy->phy, USB_PHY_TYPE_USB2);
 }
 
@@ -432,6 +435,8 @@ static int samsung_usb2phy_remove(struct platform_device *pdev)
 
 	usb_remove_phy(&sphy->phy);
 
+	pm_runtime_disable(&pdev->dev);
+
 	if (sphy->pmuregs)
 		iounmap(sphy->pmuregs);
 	if (sphy->sysreg)
-- 
1.7.6.5

