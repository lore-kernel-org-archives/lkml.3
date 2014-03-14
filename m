Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756162AbaCNJds (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 05:33:48 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:59049 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755937AbaCNJaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 05:30:20 -0400
X-AuditID: cbfee690-b7f266d00000287c-8e-5322cc248789
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com, kyungmin.park@samsung.com
Cc: rafael.j.wysocki@intel.com, nm@ti.com, b.zolnierkie@samsaung.com,
        pawel.moll@arm.com, mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv3 0/8] devfreq: exynos4: Support dt and use common ppmu driver
Date: Fri, 14 Mar 2014 18:30:00 +0900
Message-id: <1394789408-14648-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIIsWRmVeSWpSXmKPExsWyRsSkRFfljFKwwbUWLouOnt8sFte/PGe1
	mH/kHKvFuVcrGS3ONr1ht1jYtoTF4vKuOWwWn3uPMFrMOL+PyWLp9YtMFrcbV7BZvPlxlsli
	wvS1LBaPV7xlt3h1sI3Fgd9jzbw1jB4rl39h81i85yWTx8/l29k9+rasYvQ4fmM7k8fnTXIe
	G+eGBnBEcdmkpOZklqUW6dslcGU8/xtf8Iq/YkrzQqYGxos8XYycHBICJhLLtrxmhrDFJC7c
	W8/WxcjFISSwlFHizPNPQA4HWNHShhyQGiGBRYwSCz6mQ9Q0Mkl8e/CVHSTBJqAlsf/FDTYQ
	W0TAXGLX0p9gg5gFnjFJ3OrvYwJJCAv4SfTP2c4MMpRFQFVie6cNSJhXwFVi+smZTBBHyEl8
	2POIHcK+xi7xZ1skiM0iICDxbfIhFoh7ZCU2HYC6WVLi4IobLBMYBRcwMqxiFE0tSC4oTkov
	MtErTswtLs1L10vOz93ECIyO0/+eTdjBeO+A9SHGZKBxE5mlRJPzgdGVVxJvaGxmZGFqYmps
	ZG5pRpqwkjiv2qOkICGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2MBcz7DRNYLWWc1p2eZ2XO
	eFhiUon/10OqX2Oe9Zul/T8T0O8QGpfmH7fp9td326dMdPnrX9l7fPbRU81TFtp+nhHEysj3
	5KNYgZenfn39PcNwtt+Z9jWZ3l/z/9q0PduzocB5+sGfZ9xrfe1P6yTkuGxySNLakfM/8/6G
	h8zK80p4YvZ7h1spsRRnJBpqMRcVJwIAb3OOvaQCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPIsWRmVeSWpSXmKPExsVy+t9jAV2VM0rBBo2rGS06en6zWFz/8pzV
	Yv6Rc6wW516tZLQ42/SG3WJh2xIWi8u75rBZfO49wmgx4/w+Joul1y8yWdxuXMFm8ebHWSaL
	CdPXslg8XvGW3eLVwTYWB36PNfPWMHqsXP6FzWPxnpdMHj+Xb2f36NuyitHj+I3tTB6fN8l5
	bJwbGsAR1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuW
	mQN0vZJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsIYx4/nf+IJX/BVTmhcy
	NTBe5Oli5OCQEDCRWNqQ08XICWSKSVy4t54NxBYSWMQoseBjehcjF5DdyCTx7cFXdpAEm4CW
	xP4XN8CKRATMJXYt/ckGUsQs8IxJ4lZ/HxNIQljAT6J/znZmkAUsAqoS2zttQMK8Aq4S00/O
	ZIJYJifxYc8j9gmM3AsYGVYxiqYWJBcUJ6XnGukVJ+YWl+al6yXn525iBEffM+kdjKsaLA4x
	CnAwKvHwzjiqGCzEmlhWXJl7iFGCg1lJhJdhnlKwEG9KYmVValF+fFFpTmrxIcZkoOUTmaVE
	k/OBiSGvJN7Q2MTMyNLI3NDCyNicNGElcd6DrdaBQgLpiSWp2ampBalFMFuYODilGhgDTq68
	b+yQ/Gj6j+7yBUIsikVx99ezi1xT8quftvKh+09ljh0rviZws3x7wlD1uPn+h0XCZbNd9wke
	ED5Y/SZWTc5H1f4tG7+l67rKUs/IJ6xhej8SZ3QvlS7nvcAe1do6/TtL2l9Ft7XN8a8e/Pe5
	uXNeRfqtv0Yz50p4LQ6tMjr6lpOn8Y8SS3FGoqEWc1FxIgBZANRPAgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset support devicetree and use common ppmu driver instead of
individual code of exynos4_bus.c to remove duplicate code. Also this patchset
get the resources for busfreq from dt data by using DT helper function.
- PPMU register address
- PPMU clock
- Regulator for INT/MIF block

This patchset use SET_SYSTEM_SLEEP_PM_OPS macro intead of legacy method.
To remove power-leakage in suspend state, before entering suspend state,
disable ppmu clocks.

Changes from v2:
- Add detailed description to Documentation/devicetree/bindings/exynos4_bus.txt
  and change patch description of patch#8
- Change the sequence of patchset in patch #1 ~ #4
- Fix minor issue

Changes from v1:
- Add exynos4_bus.txt documentation for devicetree guide
- Fix probe failure if CONFIG_PM_OPP is disabled
- Fix typo and resource leak(regulator/clock/memory) when happening probe failure
- Add additionally comment for PPMU usage instead of previous PPC
- Split separate patch to remove ambiguous of patch

Chanwoo Choi (8):
  devfreq: exynos4: Fix bug of resource leak and code clean on probe()
  devfreq: exynos4: Support devicetree to get device id of Exynos4 SoC
  devfreq: exynos4: Use common ppmu driver and get ppmu address from dt data
  devfreq: exynos4: Add ppmu's clock control and code clean about regulator control
  devfreq: exynos4: Use SET_SYSTEM_SLEEP_PM_OPS macro
  devfreq: exynos4: Fix power-leakage of clock on suspend state
  devfreq: exynos4: Add CONFIG_PM_OPP dependency to fix probe fail
  Documentation: dt: devfreq: Add device tree binding of Exynos4
    busfreq

 .../devicetree/bindings/devfreq/exynos4_bus.txt    |  50 +++
 drivers/devfreq/Kconfig                            |   1 +
 drivers/devfreq/exynos/Makefile                    |   2 +-
 drivers/devfreq/exynos/exynos4_bus.c               | 415 ++++++++++++++-------
 4 files changed, 342 insertions(+), 126 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/devfreq/exynos4_bus.txt

-- 
1.8.0

