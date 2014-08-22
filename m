Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305AbaHVJqu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 05:46:50 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:33793 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854AbaHVJqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 05:46:47 -0400
X-AuditID: cbfee68d-b7f2f6d0000062f0-97-53f71184c5eb
From: Chanwoo Choi <cw00.choi@samsung.com>
To: a.zummo@towertech.it
Cc: kgene.kim@samsung.com, kyungmin.park@samsung.com,
        akpm@linux-foundation.org, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [RESEND PATCHv2 0/5] rtc: s3c: Refactoring s3c-rtc driver and support
 Exynos3250 RTC
Date: Fri, 22 Aug 2014 18:46:37 +0900
Message-id: <1408700802-15673-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCLMWRmVeSWpSXmKPExsWyRsSkSLdF8Huwwa61nBZLLl5lt5izfg2b
	xfUvz1ktehdcZbM42/SG3eLyrjlsFjPO72Oy2N/ZwejA4bFn4kk2jxMzfrN49G1Zxegxfd5P
	Jo/Pm+QCWKO4bFJSczLLUov07RK4MmZPX8VWcJCj4tn74gbGK2xdjJwcEgImEsvX32KHsMUk
	LtxbDxTn4hASWMooMWviCxaYook32pghEtMZJVYvmsEI4TQxSezfcJQZpIpNQEti/4sbYGNF
	BCQklsy5A1bELHCDUWLh4i+sIAlhgXiJyz0HwBpYBFQlen/cALN5BVwl+g93QN0hJ/FhzyN2
	kGYJgWZ2iT0rLjBCNAhIfJt8COgmDqCErMQmiDkSApISB1fcYJnAKLiAkWEVo2hqQXJBcVJ6
	kaFecWJucWleul5yfu4mRmAIn/73rHcH4+0D1ocYk4HGTWSWEk3OB8ZAXkm8obGZkYWpiamx
	kbmlGWnCSuK8SQ+TgoQE0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUwHueyYxcQ3j+vLnXzarm6
	blazutCpW/b/amL4tTpQW+qA//ILL75NZBI1l/FS2KSfq7vq/S+mE8cs5jJ+Xyc4RfVRhcVa
	m1n993p5iu9fZfSUmShjLPf1eFnIwp5fpw9N2smVKdIlw/NJ7/YeR2PvSoVXeZu0V97+HK1+
	Y0Nw4x9N/anfTzFbK7EUZyQaajEXFScCAL060Dl3AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMIsWRmVeSWpSXmKPExsVy+t9jQd0Wwe/BBr8XM1ssuXiV3WLO+jVs
	Fte/PGe16F1wlc3ibNMbdovLu+awWcw4v4/JYn9nB6MDh8eeiSfZPE7M+M3i0bdlFaPH9Hk/
	mTw+b5ILYI1qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQ
	dcvMATpGSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYw5gxe/oqtoKDHBXP
	3hc3MF5h62Lk5JAQMJGYeKONGcIWk7hwbz1QnItDSGA6o8TqRTMYIZwmJon9G46CVbEJaEns
	f3EDrFtEQEJiyZw7YEXMAjcYJRYu/sIKkhAWiJe43HMArIFFQFWi98cNMJtXwFWi/3AHO8Q6
	OYkPex6xT2DkXsDIsIpRNLUguaA4KT3XSK84Mbe4NC9dLzk/dxMjOEKeSe9gXNVgcYhRgINR
	iYc34svXYCHWxLLiytxDjBIczEoivD/4vgcL8aYkVlalFuXHF5XmpBYfYjQF2j6RWUo0OR8Y
	vXkl8YbGJmZGlkbmhhZGxuZK4rwHW60DhQTSE0tSs1NTC1KLYPqYODilGhgFWPd05m9xFCpk
	kTt++82HyKIdz9ay9Ajyudy+qPDJ/t6+x01Oe3IzDfrYOtZz71u58AfLohfh8Y89D89en6ta
	LM3B07p0c6IVx5ck34C+MD7LKIl1v295/ZxgPYdZ/oytynl9xRy5R4ca+fVTPFP1f1nv/T+v
	NPn2pUWt4dH7PnnyFUt9kFdiKc5INNRiLipOBACZ7sJApgIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset clean up codes to improve readability as following and support
the RTC of Exynos3250 SoC.
- Remove global variables and then use new s3c_rtc structure
- Remove warn message with checking checkpatch script
- Use variant structure according to SoC type instead of legacy enum variable(s3c_cpu_type)

Changes from v1:
- Fix NULL pointer panic of s3c_rtc_settime()
- Check info->base value to protect NULL pointer panic

Chanwoo Choi (5):
  rtc: s3c: Define s3c_rtc structure to remove global variables.
  rtc: s3c: Remove warning message when checking coding style with checkpatch script
  rtc: s3c: Add s3c_rtc_data structure to use variant data instead of s3c_cpu_type
  rtc: s3c: Add support for RTC of Exynos3250 SoC
  ARM: dts: Fix wrong compatible string of Exynos3250 RTC dt node

 Documentation/devicetree/bindings/rtc/s3c-rtc.txt |   3 +
 arch/arm/boot/dts/exynos3250.dtsi                 |   2 +-
 drivers/rtc/rtc-s3c.c                             | 869 ++++++++++++++--------
 3 files changed, 553 insertions(+), 321 deletions(-)

-- 
1.8.0

