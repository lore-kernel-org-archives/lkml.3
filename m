Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753AbaF0Eba (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 00:31:30 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:38626 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990AbaF0EaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 00:30:19 -0400
X-AuditID: cbfee68d-b7fd46d000005f36-21-53acf3533d71
From: Chanwoo Choi <cw00.choi@samsung.com>
To: jic23@kernel.org, ch.naveen@samsung.com, t.figa@samsung.com,
        kgene.kim@samsung.com
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, sachin.kamat@linaro.org,
        kyungmin.park@samsung.com, linux-iio@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv5 0/4] iio: adc: exynos_adc: Support Exynos3250 ADC and code
 clean
Date: Fri, 27 Jun 2014 13:30:02 +0900
Message-id: <1403843406-28229-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPIsWRmVeSWpSXmKPExsWyRsSkQDf485pgg5MvNCzuPj/MaHH9y3NW
	i/lHzrFa9L9ZyGpx7tVKRosHTauYLHoXXGWzONv0ht1i3pF3LBaXd81hs5hxfh+TxdLrF5ks
	Jkxfy2Lx9s50FovWvUfYLU7+6WW0WD/jNYuDoMeaeWsYPS739TJ5rFz+hc1j8wotj02rOtk8
	7lzbw+bRt2UVo8fnTXIBHFFcNimpOZllqUX6dglcGb+e7WIqWMxdcenJLOYGxkbOLkZODgkB
	E4ljMyazQNhiEhfurWfrYuTiEBJYyihxrOMAE0zR/Ikb2CES0xkl/l5ezwqSEBJoYpLY3CkA
	YrMJaEnsf3GDDcQWEYiQmL95BxNIA7PAMyaJ1hd9jCAJYYEQiUl3n4KtYxFQlVj15BE7iM0r
	4Coxo3cGO8Q2OYkPex6BbZMQuMcusfDqGlaIBgGJb5MPATVzACVkJTYdYIaol5Q4uOIGywRG
	wQWMDKsYRVMLkguKk9KLDPWKE3OLS/PS9ZLzczcxAiPn9L9nvTsYbx+wPsSYDDRuIrOUaHI+
	MPLySuINjc2MLExNTI2NzC3NSBNWEudNepgUJCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoFx
	Z+tqjh0rtwWscmWp2fioyvyadR/n+iimAwt+sLg6c1wKESh4Wf35V27+yg3mS+J/O9q/uXOm
	QuLwlItTDxYqpQnoO4cLReTpSrjM00vf8kHaKfO0ybszb5Ksb6ZOTb03w/vklMs3uuf29vPq
	tnNtKTCxeRat+S723bz/QffWbX0x7a+K5uEPSizFGYmGWsxFxYkA0p3YvrICAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHIsWRmVeSWpSXmKPExsVy+t9jQd3gz2uCDaZ2KVjcfX6Y0eL6l+es
	FvOPnGO16H+zkNXi3KuVjBYPmlYxWfQuuMpmcbbpDbvFvCPvWCwu75rDZjHj/D4mi6XXLzJZ
	TJi+lsXi7Z3pLBate4+wW5z808tosX7GaxYHQY8189Ywelzu62XyWLn8C5vH5hVaHptWdbJ5
	3Lm2h82jb8sqRo/Pm+QCOKIaGG0yUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTy
	EnNTbZVcfAJ03TJzgP5QUihLzCkFCgUkFhcr6dthmhAa4qZrAdMYoesbEgTXY2SABhLWMGb8
	eraLqWAxd8WlJ7OYGxgbObsYOTkkBEwk5k/cwA5hi0lcuLeerYuRi0NIYDqjxN/L61lBEkIC
	TUwSmzsFQGw2AS2J/S9usIHYIgIREvM372ACaWAWeMYk0fqijxEkISwQIjHp7lMWEJtFQFVi
	1ZNHYBt4BVwlZvTOgNomJ/FhzyP2CYzcCxgZVjGKphYkFxQnpeca6hUn5haX5qXrJefnbmIE
	x+UzqR2MKxssDjEKcDAq8fAaeKwJFmJNLCuuzD3EKMHBrCTC+/IeUIg3JbGyKrUoP76oNCe1
	+BCjKdD2icxSosn5wJSRVxJvaGxiZmRpZG5oYWRsriTOe6DVOlBIID2xJDU7NbUgtQimj4mD
	U6qBUblUb2VVl4gKX8s5hZcpnCn9Lw+tS47focpzbHVFoX6N/JXqhVtTJrU4ZKyQd/iule/0
	2W1xnlfQ9qwZGuwZujUr7ix8U7n82pYo3afCvGtWdTPEJ01pjdOzv7k7dL/tvc9PTou5PNUR
	9lKY+WdfXssCMfdrayXut+7blTT5UWOwneP3veJ/lViKMxINtZiLihMBkp1eiOECAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
  iio: adc: exynos_adc: Add exynos_adc_data structure to improve readability
  iio: adc: exynos_adc: Control special clock of ADC to support Exynos3250 ADC
  iio: devicetree: Add DT binding documentation for Exynos3250 ADC
  ARM: dts: Fix wrong compatible string for Exynos3250 ADC

 .../devicetree/bindings/arm/samsung/exynos-adc.txt |  26 +-
 arch/arm/boot/dts/exynos3250.dtsi                  |   4 +-
 drivers/iio/adc/exynos_adc.c                       | 326 +++++++++++++++------
 3 files changed, 268 insertions(+), 88 deletions(-)

-- 
1.8.0

