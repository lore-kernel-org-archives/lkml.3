Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933381AbaFRCVO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 22:21:14 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:21474 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932118AbaFRCVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 22:21:11 -0400
X-AuditID: cbfee68d-b7fd46d000005f36-19-53a0f79426ea
From: Chanwoo Choi <cw00.choi@samsung.com>
To: jic23@kernel.org, ch.naveen@samsung.com, t.figa@samsung.com,
        kgene.kim@samsung.com
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, sachin.kamat@linaro.org,
        linux-iio@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv4 0/4] iio: adc: exynos_adc: Support Exynos3250 ADC and code
 clean
Date: Wed, 18 Jun 2014 11:20:57 +0900
Message-id: <1403058061-24271-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPIsWRmVeSWpSXmKPExsWyRsSkQHfK9wXBBmsucFvcfX6Y0eL6l+es
	FvOPnGO16H+zkNXi3KuVjBYPmlYxWfQuuMpmsbBtCYvFvCPvWCwu75rDZjHj/D4mi6XXLzJZ
	TJi+lsXi7Z3pLBate4+wW5z808tosX7GaxYHQY8189Ywelzu62XyWLn8C5vH5hVaHptWdbJ5
	3Lm2h82jb8sqRo/Pm+QCOKK4bFJSczLLUov07RK4MnpnH2Mt2MdVcfnieuYGxi0cXYycHBIC
	JhLXlnYyQdhiEhfurWcDsYUEljJKrN4uDlOzf+sLli5GLqD4dEaJ/3MfM0I4TUwS3c/6GUGq
	2AS0JPa/uAHWLSIQITF/8w4mkCJmgRdMEo/uPgArEhYIkfi04TbYOhYBVYkHf5+ANfAKuEo8
	fjwX6gw5iQ97HrGDNEsIPGKX2NbxnBGiQUDi2+RDQHdwACVkJTYdYIaol5Q4uOIGywRGwQWM
	DKsYRVMLkguKk9KLDPWKE3OLS/PS9ZLzczcxAiPn9L9nvTsYbx+wPsSYDDRuIrOUaHI+MPLy
	SuINjc2MLExNTI2NzC3NSBNWEudNepgUJCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoHx2Kl1
	6b+kvM6/5D2anSm/U1VN9Zxj/tEsRdaj1z4+SWbpmcDosEOENexvPouh6SGB8Gkv3z1ieGt2
	8TLbZnsG9ZJNJ6d8iZVqXPyJR/DAil6Jd0tOKd4LOvlPLcjTMZy3rODbEYmVmStnvTeb57yz
	5KkCi7kt/1MTP6vDnios/97tPBocIKiixFKckWioxVxUnAgAVjExWLICAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLIsWRmVeSWpSXmKPExsVy+t9jQd0p3xcEG6yfxmRx9/lhRovrX56z
	Wsw/co7Vov/NQlaLc69WMlo8aFrFZNG74CqbxcK2JSwW8468Y7G4vGsOm8WM8/uYLJZev8hk
	MWH6WhaLt3ems1i07j3CbnHyTy+jxfoZr1kcBD3WzFvD6HG5r5fJY+XyL2wem1doeWxa1cnm
	cefaHjaPvi2rGD0+b5IL4IhqYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LI
	S8xNtVVy8QnQdcvMAfpDSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYw5jR
	O/sYa8E+rorLF9czNzBu4ehi5OSQEDCR2L/1BQuELSZx4d56ti5GLg4hgemMEv/nPmaEcJqY
	JLqf9TOCVLEJaEnsf3GDDcQWEYiQmL95BxNIEbPACyaJR3cfgBUJC4RIfNpwmwnEZhFQlXjw
	9wlYA6+Aq8Tjx3OZINbJSXzY84h9AiP3AkaGVYyiqQXJBcVJ6bmGesWJucWleel6yfm5mxjB
	kflMagfjygaLQ4wCHIxKPLwcuQuChVgTy4orcw8xSnAwK4nwqpwDCvGmJFZWpRblxxeV5qQW
	H2JMBto+kVlKNDkfmDTySuINjU3MjCyNzA0tjIzNSRNWEuc90GodKCSQnliSmp2aWpBaBLOF
	iYNTqoExxqOqMDetT81E4WWLa1pvcka20b0sLbN3ZdM3trj7cMjHVB3feLAl64PBTcut8xce
	OGP195t0yYOiOZ7HkmtSav7eUY8yMmj9WHzOV7p/qWZgHseK0MWmLlUu+w74235a9tJqf5W5
	lN/E59zF0gY8VxTlL0cum526sPGYX+LO5aan67f27lViKc5INNRiLipOBAD97iLMEAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset support Exynos3250 ADC (Analog Digital Converter) because
Exynos3250 has additional special clock for ADC IP and add 'exynos_adc_ops'
structure to improve readability.

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
  iio: adc: exynos_adc: Add exynos_adc_ops structure to improve readability
  iio: adc: exynos_adc: Control special clock of ADC to support Exynos3250 ADC
  iio: devicetree: Add DT binding documentation for Exynos3250 ADC
  ARM: dts: Fix wrong compatible string for Exynos3250 ADC

 .../devicetree/bindings/arm/samsung/exynos-adc.txt |  20 ++
 arch/arm/boot/dts/exynos3250.dtsi                  |   4 +-
 drivers/iio/adc/exynos_adc.c                       | 267 ++++++++++++++++-----
 3 files changed, 223 insertions(+), 68 deletions(-)

-- 
1.8.0

