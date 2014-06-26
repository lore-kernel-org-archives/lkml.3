Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563AbaFZMxj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 08:53:39 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:22737 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbaFZMxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 08:53:37 -0400
X-AuditID: cbfee68e-b7fb96d000004bfc-83-53ac17cf11c2
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Cc: naveenkrishna.ch@gmail.com, linux@roeck-us.net, cpgs@samsung.com,
        herbert@gondor.apana.org.au
Subject: [PATCH] hwmon: ntc_thermistor: correct the information printed during
 probe
Date: Thu, 26 Jun 2014 18:20:14 +0530
Message-id: <1403787014-5858-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJLMWRmVeSWpSXmKPExsWyRsSkRve8+Jpgg92rLC1eHtK06H4lY3F5
	1xw2iycLzzBZ3Jm2l81i0bb/zA5sHjtn3WX32HZA1ePBxN1A3vcGdo++LasYPT5vkgtgi+Ky
	SUnNySxLLdK3S+DKOPB/N3tBK1vFw/uPGBsYf7N0MXJySAiYSPx91MsGYYtJXLi3Hsjm4hAS
	WMooMWP3ZkaYohuHLjJCJBYxSvz++pAVJCEk0M8k8euiKojNJmAmcXDRanYQW0TAWmLf8l1g
	U5kFkiUaX/wH2yYsECax4+VxZhCbRUBVYu2d9UD1HBy8Ai4Sd/+4gpgSAgoScybZgKySEPjN
	JvHl1i12iHIBiW+TD7FA1MhKbDrADHGapMTBFTdYJjAKLmBkWMUomlqQXFCclF5kpFecmFtc
	mpeul5yfu4kRGKyn/z3r28F484D1IcZkoHETmaVEk/OBwZ5XEm9obGZkYWpiamxkbmlGmrCS
	OO+ih0lBQgLpiSWp2ampBalF8UWlOanFhxiZODilGhj5bKrM/Zfyq7l25+gtOXA/f/3PqVdM
	b716pTUr8zqH+3qFAKufMS+bTiT5P/uwRHKq8oGb6pW5foplySH3OvJC7yrvvsEpvfdzxScu
	7xaT3zG9pZ6derdm7rZRdFLWbdkouc+MudWx+L5NjNzWnt6t/SaNu/wnGN+Z78iWska+bs93
	v+K0MCWW4oxEQy3mouJEAPmRr4psAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgkeLIzCtJLcpLzFFi42I5/e+xgO558TXBBleuG1i8PKRp0f1KxuLy
	rjlsFk8WnmGyuDNtL5vFom3/mR3YPHbOusvuse2AqseDibuBvO8N7B59W1YxenzeJBfAFtXA
	aJORmpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDdISSQlli
	TilQKCCxuFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCGMePA/93sBa1sFQ/vP2JsYPzN0sXI
	ySEhYCJx49BFRghbTOLCvfVsXYxcHEICixglfn99yAqSEBLoZ5L4dVEVxGYTMJM4uGg1O4gt
	ImAtsW/5LjYQm1kgWaLxxX+wocICYRI7Xh5nBrFZBFQl1t5ZD1TPwcEr4CJx948riCkhoCAx
	Z5LNBEbuBYwMqxhFUwuSC4qT0nON9IoTc4tL89L1kvNzNzGCY+GZ9A7GVQ0WhxgFOBiVeHg/
	PF4VLMSaWFZcmXuIUYKDWUmE9z7/mmAh3pTEyqrUovz4otKc1OJDjKZAuycyS4km5wPjNK8k
	3tDYxNzU2NTSxMLEzFJJnPdgq3WgkEB6YklqdmpqQWoRTB8TB6dUA2Pqhr5+H99DRRtfux2f
	fZGz2cDPIy3ukUhU6Sz109wtsU4uW0JD6zPduRLNOe0/ta4MPXfWcnWb2ROTFVs9nhy//Hbz
	XMvvG5XLrh/83y/vVLH80trICiM+c5GY/9ltTv8Z3uVF9W1inFScmV/xLiypQ09s4dpDf5Qc
	r0pdOLkywvJjXT37KSWW4oxEQy3mouJEAF/EUCubAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, dev_info() at the end of the probe says
"type:%s ". But, prints the pdev->name.

This patch uses "pdev_id->name" which prints the thermistor type.

Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
---
 drivers/hwmon/ntc_thermistor.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/ntc_thermistor.c b/drivers/hwmon/ntc_thermistor.c
index bdfbe91..ae66f42 100644
--- a/drivers/hwmon/ntc_thermistor.c
+++ b/drivers/hwmon/ntc_thermistor.c
@@ -512,7 +512,7 @@ static int ntc_thermistor_probe(struct platform_device *pdev)
 	}
 
 	dev_info(&pdev->dev, "Thermistor type: %s successfully probed.\n",
-								pdev->name);
+								pdev_id->name);
 
 	return 0;
 err_after_sysfs:
-- 
1.7.9.5

