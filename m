Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364AbaDPKMF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 06:12:05 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:9716 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754823AbaDPKL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 06:11:57 -0400
X-AuditID: cbfee691-b7efc6d0000039d3-80-534e576b32ca
From: Chanwoo Choi <cw00.choi@samsung.com>
To: jic23@kernel.org, ch.naveen@samsung.com, kgene.kim@samsung.com
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, t.figa@samsung.com, sachin.kamat@linaro.org,
        linux-iio@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv3 0/2] iio: adc: exynos_adc: Support Exynos3250 ADC
Date: Wed, 16 Apr 2014 19:11:56 +0900
Message-id: <1397643118-6934-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJIsWRmVeSWpSXmKPExsWyRsSkQDc73C/Y4P42KYu7zw8zWlz/8pzV
	Yv6Rc6wW/W8Wslqce7WS0eJB0yomi94FV9ksNj2+xmqxsG0Ji8W8I+9YLC7vmsNmMeP8PiaL
	pdcvMllMmL6WxeLtneksFq17j7BbnPzTy2ixfsZrFgchjzXz1jB6XO7rZfJYufwLm8fmFVoe
	m1Z1snncubYHyFtS79G3ZRWjx+dNcgGcUVw2Kak5mWWpRfp2CVwZZx/eYyyYzFYxf8E8xgbG
	LyxdjJwcEgImEvdu3mSGsMUkLtxbz9bFyMUhJLCUUWLlj2usMEV7bnezQiSmM0q8f9rGDuE0
	MUlc3rWJEaSKTUBLYv+LG2wgtoiAk8TPb/fARjELLGKWmL36HFhCWMBZ4svOT2D7WARUJVZ9
	uwG2glfARWJr2w82iHVyEh/2PALbICHwkV3i4OlfTBANAhLfJh8COpwDKCErsekA1N2SEgdX
	3GCZwCi4gJFhFaNoakFyQXFSepGpXnFibnFpXrpecn7uJkZgNJ3+92ziDsb7B6wPMSYDjZvI
	LCWanA+MxrySeENjMyMLUxNTYyNzSzPShJXEedMfJQUJCaQnlqRmp6YWpBbFF5XmpBYfYmTi
	4JRqYAyd8N9eOVyMe4LX4QDXdfHC7lvvZMtrrt/PzfJs7iKnjaVpvIe//+aXFWH85CMaUXx5
	ToEF6+RPWmLql2XdzguIWPyuS9pWziu2N6M4RW5efmfUJJ0VuXFeHvvmCG5b9//lXJ+5+SUl
	+SKef+Sbg4p0d/rN4wx2Ofne5o7uRP1Zss5hTIzXlViKMxINtZiLihMB49FCybwCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjleLIzCtJLcpLzFFi42I5/e+xoG52uF+wwf6jAhZ3nx9mtLj+5Tmr
	xfwj51gt+t8sZLU492olo8WDplVMFr0LrrJZbHp8jdViYdsSFot5R96xWFzeNYfNYsb5fUwW
	S69fZLKYMH0ti8XbO9NZLFr3HmG3OPmnl9Fi/YzXLA5CHmvmrWH0uNzXy+SxcvkXNo/NK7Q8
	Nq3qZPO4c20PkLek3qNvyypGj8+b5AI4oxoYbTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwM
	dQ0tLcyVFPISc1NtlVx8AnTdMnOAHlJSKEvMKQUKBSQWFyvp22GaEBripmsB0xih6xsSBNdj
	ZIAGEtYwZpx9eI+xYDJbxfwF8xgbGL+wdDFyckgImEjsud3NCmGLSVy4t56ti5GLQ0hgOqPE
	+6dt7BBOE5PE5V2bGEGq2AS0JPa/uMEGYosIOEn8/HYPrINZYBGzxOzV58ASwgLOEl92fmIG
	sVkEVCVWfbsBtoJXwEVia9sPNoh1chIf9jxin8DIvYCRYRWjaGpBckFxUnqukV5xYm5xaV66
	XnJ+7iZGcKw+k97BuKrB4hCjAAejEg/vzBzfYCHWxLLiytxDjBIczEoivH9C/YKFeFMSK6tS
	i/Lji0pzUosPMSYDbZ/ILCWanA9MI3kl8YbGJmZGlkbmhhZGxuakCSuJ8x5stQ4UEkhPLEnN
	Tk0tSC2C2cLEwSnVwGgRzXBmUplJePuUDaF+z68t7GuSzQ1LDDwtpb2u9/HyGKMzFovfeE0s
	X5phY7e36JH05JvnecXiN/5flinw5Tz/vG1vYo88jj77+6JHBoPobObzAldCzy26IST4guPM
	XSk5cb4L5Rtz1+/0//b5zY4J2zK9GAOfvDG5rloRathfsMpwybGCiEYlluKMREMt5qLiRAAU
	LF5JGQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset support Exynos3250 ADC (Analog Digital Converter) because
Exynos3250 has additional special clock for ADC IP.

Changes from v2:
- Check return value of clock function to deal with error exception
- Fix minor coding style to improve readability

Changes from v1:
- Add new "samsung,exynos-adc-v3" compatible to support Exynos3250 ADC
- Add a patch about DT binding documentation

Chanwoo Choi (2):
  iio: adc: exynos_adc: Control special clock of ADC to support Exynos3250 ADC
  iio: devicetree: Add DT binding documentation for Exynos3250 ADC

 .../devicetree/bindings/arm/samsung/exynos-adc.txt | 20 +++++
 drivers/iio/adc/exynos_adc.c                       | 86 ++++++++++++++++++----
 2 files changed, 93 insertions(+), 13 deletions(-)

-- 
1.8.0

