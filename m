Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760168AbaGRF74 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 01:59:56 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:32478 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754590AbaGRF7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 01:59:52 -0400
X-AuditID: cbfee68f-b7fef6d000003970-da-53c8b7d5dc73
From: Chanwoo Choi <cw00.choi@samsung.com>
To: jic23@kernel.org, ch.naveen@samsung.com
Cc: kgene.kim@samsung.com, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rdunlap@infradead.org, kyungmin.park@samsung.com,
        t.figa@samsung.com, linux-iio@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv6 0/4] iio: adc: exynos_adc: Support Exynos3250 ADC and code
 clean
Date: Fri, 18 Jul 2014 14:59:42 +0900
Message-id: <1405663186-26464-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCIsWRmVeSWpSXmKPExsWyRsSkUPfa9hPBBi8fMVrcfX6Y0eL6l+es
	FvOPnGO16H+zkNXi3KuVjBYPmlYxWfQuuMpmcbbpDbvFpsfXWC0Wti1hsZh35B2LxeVdc9gs
	Zpzfx2Sx9PpFJosJ09eyWLy9M53FonXvEXaL9TNeszgIeayZt4bR43JfL5PHyuVf2Dw2r9Dy
	2LSqE8hYUu/Rt2UVo8fnTXIBHFFcNimpOZllqUX6dglcGad3z2YuWMFbsWjBUaYGxpNcXYyc
	HBICJhKrpjazQdhiEhfurQeyuTiEBJYySlzqWsQOU7S4+SQjRGIRo8TsE6+gqpqYJLY928AE
	UsUmoCWx/8UNsFEiAtoSExZ2gBUxC+xllti+/j0zSEJYIETi6arVYGNZBFQlrmyaD9bMK+Aq
	saz5H9QdchIf9jxiB2mWELjHLvHpzVxGiAYBiW+TD7F0MXIAJWQlNh1ghqiXlDi44gbLBEbB
	BYwMqxhFUwuSC4qT0ouM9YoTc4tL89L1kvNzNzECY+j0v2f9OxjvHrA+xJgMNG4is5Rocj4w
	BvNK4g2NzYwsTE1MjY3MLc1IE1YS573/MClISCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUA6OX
	Kkeyz/xVUVzp2yM+S3YejddJkrw14VGM4g2/X2l2Fxx8LkrP/bj+kD+ztdRV1Zc5/+bzO29k
	tz9wdeblrUcfrn7woEyQ/9wS8zl2/8xrFB4q9245HrF2f6a/OYPjhNlHF5s//PZ8++dZe52v
	yHyfragSHPFt/8lpwd4X/atZ+sxMJpbktd1QYinOSDTUYi4qTgQAs5eKWLcCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMIsWRmVeSWpSXmKPExsVy+t9jAd2r208EG7zoM7W4+/wwo8X1L89Z
	LeYfOcdq0f9mIavFuVcrGS0eNK1isuhdcJXN4mzTG3aLTY+vsVosbFvCYjHvyDsWi8u75rBZ
	zDi/j8li6fWLTBYTpq9lsXh7ZzqLReveI+wW62e8ZnEQ8lgzbw2jx+W+XiaPlcu/sHlsXqHl
	sWlVJ5CxpN6jb8sqRo/Pm+QCOKIaGG0yUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3M
	lRTyEnNTbZVcfAJ03TJzgH5RUihLzCkFCgUkFhcr6dthmhAa4qZrAdMYoesbEgTXY2SABhLW
	MGac3j2buWAFb8WiBUeZGhhPcnUxcnJICJhILG4+yQhhi0lcuLeerYuRi0NIYBGjxOwTr6Cc
	JiaJbc82MIFUsQloSex/cYMNxBYR0JaYsLADrIhZYC+zxPb175lBEsICIRJPV61mB7FZBFQl
	rmyaD9bMK+Aqsaz5HxvEOjmJD3sesU9g5F7AyLCKUTS1ILmgOCk911CvODG3uDQvXS85P3cT
	IzhCn0ntYFzZYHGIUYCDUYmH1+Lm8WAh1sSy4srcQ4wSHMxKIrzZ94FCvCmJlVWpRfnxRaU5
	qcWHGE2Btk9klhJNzgcmj7ySeENjEzMjSyNzQwsjY3Mlcd4DrdaBQgLpiSWp2ampBalFMH1M
	HJxSDYxpxR4Lp9vILI96vsUyxHvNFJ7uYsPJsbznm37NiV5i2Da1T3nJxqh+Hm7R0OeVFRwJ
	7oofZhj7eOmVX6r5wj33Vti5ngvVxoczvSfLTFzkfmW/qGZrv+BnuRRB00ue9xnV8kwU/p6N
	2RC6zFe0u1urYKV2/KwmnckbpOTyn/Fc/xLBJN7yX4mlOCPRUIu5qDgRANLft0nmAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset support Exynos3250 ADC (Analog Digital Converter) because
Exynos3250 has additional special clock for ADC IP.

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
 drivers/iio/adc/exynos_adc.c                       | 326 +++++++++++++++------
 3 files changed, 267 insertions(+), 88 deletions(-)

-- 
1.8.0

