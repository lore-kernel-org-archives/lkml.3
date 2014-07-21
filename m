Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752347AbaGUCSC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 22:18:02 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:29761 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759AbaGUCR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 22:17:57 -0400
X-AuditID: cbfee68e-b7fb96d000004bfc-d3-53cc7852fe62
From: Chanwoo Choi <cw00.choi@samsung.com>
To: jic23@kernel.org, ch.naveen@samsung.com
Cc: arnd@arndb.de, kgene.kim@samsung.com, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, kyungmin.park@samsung.com, t.figa@samsung.com,
        linux-iio@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv7 0/4] iio: adc: exynos_adc: Support Exynos3250 ADC and code
 clean
Date: Mon, 21 Jul 2014 11:17:44 +0900
Message-id: <1405909068-22539-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNIsWRmVeSWpSXmKPExsWyRsSkSDeo4kywwccFShZ/Jx1jt7j7/DCj
	xfUvz1kt5h85x2rR/2Yhq8W5VysZLR40rWKy6F1wlc3ibNMbdotNj6+xWixsW8JiMe/IOxaL
	y7vmsFnMOL+PyWLp9YtMFhOmr2WxeHtnOotF694j7BbrZ7xmcRD2WDNvDaPH71+TGD0u9/Uy
	eaxc/oXNY/MKLY9NqzqBjCX1Hn1bVjF6fN4kF8AZxWWTkpqTWZZapG+XwJXxZOVEpoIJAhU/
	bnI3MH7m6WLk5JAQMJG4+PwXM4QtJnHh3nq2LkYuDiGBpYwSf58+Z4QpurKyjR3EFhJYxCjR
	e5IZoqiJSaLzXS9YEZuAlsT+FzfYQGwRAW2JCQs7wCYxC5xhluhtWwnWLSwQInF/ySOgbg4O
	FgFViYeP0kDCvAKuEosevoC6Qk7iw55H7CC9EgIf2SWOTvrFApJgERCQ+Db5EAtIr4SArMSm
	A1D1khIHV9xgmcAouICRYRWjaGpBckFxUnqRkV5xYm5xaV66XnJ+7iZGYESd/vesbwfjzQPW
	hxiTgcZNZJYSTc4HRmReSbyhsZmRhamJqbGRuaUZacJK4ryLHiYFCQmkJ5akZqemFqQWxReV
	5qQWH2Jk4uCUamAssrVISfh98YPclrLEqo3n+jOcGC1ThDnyb2wJijbsiP188Ft81L3NDS27
	/vMft+uazySTyp19MH8Ny+V2wwPayxMKlDZUM7gs2sj0d3pBh5206b0MHe19WtNTd++f5bha
	odfI6NKMQhXOTcyN8v91Z8pd2rLzdQ2j6ZPtPgI/v+g4L21e1KLEUpyRaKjFXFScCADOamuf
	vgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFIsWRmVeSWpSXmKPExsVy+t9jAd2gijPBBouPS1r8nXSM3eLu88OM
	Fte/PGe1mH/kHKtF/5uFrBbnXq1ktHjQtIrJonfBVTaLs01v2C02Pb7GarGwbQmLxbwj71gs
	Lu+aw2Yx4/w+Joul1y8yWUyYvpbF4u2d6SwWrXuPsFusn/GaxUHYY828NYwev39NYvS43NfL
	5LFy+Rc2j80rtDw2reoEMpbUe/RtWcXo8XmTXABnVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8
	c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QV0oKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0
	fUOC4HqMDNBAwhrGjCcrJzIVTBCo+HGTu4HxM08XIyeHhICJxJWVbewQtpjEhXvr2UBsIYFF
	jBK9J5m7GLmA7CYmic53vYwgCTYBLYn9L26AFYkIaEtMWNjBBlLELHCGWaK3bSXYJGGBEIn7
	Sx4BdXNwsAioSjx8lAYS5hVwlVj08AUzxDI5iQ97HrFPYORewMiwilE0tSC5oDgpPddQrzgx
	t7g0L10vOT93EyM4Xp9J7WBc2WBxiFGAg1GJh9eD8UywEGtiWXFl7iFGCQ5mJRHeExlAId6U
	xMqq1KL8+KLSnNTiQ4ymQMsnMkuJJucDU0leSbyhsYmZkaWRuaGFkbG5kjjvgVbrQCGB9MSS
	1OzU1ILUIpg+Jg5OqQZG9pWv8jdsV/T4aXjbfu+7gMMufx6oPJ+Y16u2beU3BfHFe5+a9ExP
	ixbha9ir2vw20ci5762n/Ao+Th9zEetK/auuRwI3736msm7mpGmTrN9dUls5wT5a2lmGv9dh
	2cdt/06X+bKqrgqsY/lfXFgZutuRIc+iPO3isbUCqmKiez+V3Ot4aOymxFKckWioxVxUnAgA
	sKEEbe0CAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset support Exynos3250 ADC (Analog Digital Converter) because
Exynos3250 has additional special clock for ADC IP.

Changes from v6:
- Use "exynos3250-adc" compatible string instead of "exynos3250-adc-v2"
- Use "sclk" clock name instead of "sclk_adc"
- Remove un-necessary macro for exyno-adc-data-v2 structure.
- Remove '(void *)' cast and mark the exynos-adc-data structure as 'const'
- Change the number of ADC channels (Exynos3250 has only two channels for ADC)

Changes from v5:
- Add acked message by Kukjin Kim
- Add reviewed messgae by Tomasz Figa
- Fix typo (for for -> for)

Changes from v4:
- Use 'exynos_adc_data' structure instead of 'exynos_adc_ops' structure
  and remove enum variable of ADC version
- Fix wrong name of special clock (sclk_tsadc -> sclk_adc)
- Add reviewed message by Naveen Krishna Chatradhi
- Add functions for ADC clock control

Changes from v3:
- Add new 'exynos_adc_ops' structure to improve readability according to
 Tomasz Figa comment[1]
 [1] https://lkml.org/lkml/2014/4/16/238
- Add new 'exynos3250-adc-v2' compatible string to support Exynos3250 ADC
- Fix wrong compaitlbe string of ADC in Exynos3250 dtsi file

Changes from v2:
- Check return value of clock function to deal with error exception
- Fix minor coding style to improve readability

Changes from v1:
- Add new "samsung,exynos-adc-v3" compatible to support Exynos3250 ADC
- Add a patch about DT binding documentation


Chanwoo Choi (4):
  iio: adc: exynos_adc: Add exynos_adc_data structure to improve
    readability
  iio: adc: exynos_adc: Control special clock of ADC to support
    Exynos3250 ADC
  iio: devicetree: Add DT binding documentation for Exynos3250 ADC
  ARM: dts: Fix wrong compatible string for Exynos3250 ADC

 .../devicetree/bindings/arm/samsung/exynos-adc.txt |  25 +-
 arch/arm/boot/dts/exynos3250.dtsi                  |   4 +-
 drivers/iio/adc/exynos_adc.c                       | 335 +++++++++++++++------
 3 files changed, 274 insertions(+), 90 deletions(-)

-- 
1.8.0

