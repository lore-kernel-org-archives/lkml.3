Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610AbaHEM1y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 08:27:54 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:57427 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136AbaHEM1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 08:27:52 -0400
X-AuditID: cbfee690-b7f526d000003627-86-53e0cdc56e22
From: Chanwoo Choi <cw00.choi@samsung.com>
To: a.zummo@towertech.it
Cc: kgene.kim@samsung.com, kyungmin.park@samsung.com,
        rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 0/5] rtc: s3c: Refactoring s3c-rtc driver and support
 Exynos3250 RTC
Date: Tue, 05 Aug 2014 21:27:41 +0900
Message-id: <1407241666-17835-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNLMWRmVeSWpSXmKPExsWyRsSkSPfo2QfBBtv3GFosuXiV3eL6l+es
	Fr0LrrJZnG16w25xedccNosZ5/cxWezv7GB0YPfYM/Ekm0ffllWMHtPn/WTy+LxJLoAlissm
	JTUnsyy1SN8ugSvj0KszbAXH2Ctmb9rO2MD4kbWLkZNDQsBEomPNDjYIW0ziwr31QDYXh5DA
	UkaJMy8+ssEUzeo5xwqRmM4ose9wOxOE08QkMW3aRGaQKjYBLYn9L26AdYgISEgsmXOHEaSI
	WWA3o8TkNS9ZQBLCAmES0x7PBitiEVCVOLx6Algzr4CrxPmp0xgh1slJfNjziB2kWULgN5vE
	+q89rBANAhLfJh8CGsQBlJCV2HSAGaJeUuLgihssExgFFzAyrGIUTS1ILihOSi8y0StOzC0u
	zUvXS87P3cQIDNjT/55N2MF474D1IcZkoHETmaVEk/OBAZ9XEm9obGZkYWpiamxkbmlGmrCS
	OK/ao6QgIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYzhjPIhopy/T898v0nd/c2WXg+RpXLq
	1zvv6Mif9Git+3nLfXmArErHu9dpPgdYjzNu22b3v/bdz6tMR8/v3FmyVfW6iNX/uRPDvOdn
	ftqo3xcovtdo/ZfYZ+bv7x/adoxn+8yLhacr480zkpP2Bshy2sS2F1lEzygxUXutlMrA6DPz
	6+lDN+WVWIozEg21mIuKEwHbSTcVbgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupikeLIzCtJLcpLzFFi42I5/e+xoO7Rsw+CDc681bRYcvEqu8X1L89Z
	LXoXXGWzONv0ht3i8q45bBYzzu9jstjf2cHowO6xZ+JJNo++LasYPabP+8nk8XmTXABLVAOj
	TUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QCUoKZYk5
	pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwhrGjEOvzrAVHGOvmL1pO2MD40fWLkZO
	DgkBE4lZPeegbDGJC/fWs3UxcnEICUxnlNh3uJ0Jwmlikpg2bSIzSBWbgJbE/hc32EBsEQEJ
	iSVz7jCCFDEL7GaUmLzmJQtIQlggTGLa49lgRSwCqhKHV08Aa+YVcJU4P3UaI8Q6OYkPex6x
	T2DkXsDIsIpRNLUguaA4KT3XSK84Mbe4NC9dLzk/dxMjOB6eSe9gXNVgcYhRgINRiYdXQO1+
	sBBrYllxZe4hRgkOZiUR3qe7HgQL8aYkVlalFuXHF5XmpBYfYjQF2j6RWUo0OR8Yq3kl8YbG
	JmZGlkbmhhZGxuZK4rwHW60DhQTSE0tSs1NTC1KLYPqYODilGhjj9FasCbBZxtH+4NdPE+Fi
	u1f5b6drHFXQKGfx2Vfjwjxb6HiN0c7Aqb6nlFw+m/qU8S3nYUjvkV28YkqbtpPwrxM3D9ku
	4FvUe8HntWFy55GitNplM3RTLx1Zc8ni+5yVK1rXTfnkLKP9O+bd0lvXpD9eO2Bw+/TGpRs5
	J4W+em7KM9GSU/OAEktxRqKhFnNRcSIAJRi6Ip0CAAA=
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

Chanwoo Choi (5):
  rtc: s3c: Define s3c_rtc structure to remove global variables.
  rtc: s3c: Remove warning message when checking coding style with checkpatch script
  rtc: s3c: Add s3c_rtc_data structure to use variant data instead of s3c_cpu_type
  rtc: s3c: Add support for RTC of Exynos3250 SoC
  ARM: dts: Fix wrong compatible string of Exynos3250 RTC dt node

 Documentation/devicetree/bindings/rtc/s3c-rtc.txt |   3 +
 arch/arm/boot/dts/exynos3250.dtsi                 |   2 +-
 drivers/rtc/rtc-s3c.c                             | 849 ++++++++++++++--------
 3 files changed, 534 insertions(+), 320 deletions(-)

-- 
1.8.0

