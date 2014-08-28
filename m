Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936469AbaH1JCs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 05:02:48 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:16781 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934737AbaH1JCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 05:02:44 -0400
X-AuditID: cbfee691-f79546d0000011a1-a4-53fef0311d26
From: Chanwoo Choi <cw00.choi@samsung.com>
To: a.zummo@towertech.it
Cc: kgene.kim@samsung.com, akpm@linux-foundation.org,
        kyungmin.park@samsung.com, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv3 0/5] rtc: s3c: Refactoring s3c-rtc driver and support
 Exynos3250 RTC
Date: Thu, 28 Aug 2014 18:02:34 +0900
Message-id: <1409216559-22402-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOLMWRmVeSWpSXmKPExsWyRsSkQNfww79gg2VbzC2WXLzKbjFn/Ro2
	i+tfnrNa9C64ymZxtukNu8XlXXPYLGac38dksb+zg9GBw2PPxJNsHidm/Gbx6NuyitFj+ryf
	TB6fN8kFsEZx2aSk5mSWpRbp2yVwZextdSuYw1kx/dJG9gbGuexdjJwcEgImEoumH2WBsMUk
	LtxbzwZiCwksZZTY9dwUpmbGnmmsXYxcQPHpjBJnH15ihnCamCS+zH0I1sEmoCWx/8UNMFtE
	QEJiyZw7jCA2s8ANRokX22JAbGGBCInzC36C1bAIqEr827SbCcTmFXCVuPd8GxvENjmJD3se
	sYMskBBoZ5d4tnMKC0SDgMS3yYeAbA6ghKzEpgPMEPWSEgdX3GCZwCi4gJFhFaNoakFyQXFS
	epGpXnFibnFpXrpecn7uJkZg+J7+92ziDsb7B6wPMQpwMCrx8M5I+BcsxJpYVlyZe4jRFGjD
	RGYp0eR8YJTklcQbGpsZWZiamBobmVuaKYnz6kj/DBYSSE8sSc1OTS1ILYovKs1JLT7EyMTB
	KdXAuDtr9t0Zk0+cCYgw+vjl78cpVU7PD22az33vmYv+r5iWT15Vr/9d8FXyU+gMU7t/VX1B
	a03fNjPB12I3pZjLik7HbZm1Myyh+W/QymP23+d99XOMunz7quLDjefy9R9U9Bf86GnTc+75
	YnXiTc3vmZ48f7JeF6d9YFPKL7l7V2yOpr9/k7zRKiWW4oxEQy3mouJEABEL4oxaAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEIsWRmVeSWpSXmKPExsVy+t9jQV3DD/+CDSY+17dYcvEqu8Wc9WvY
	LK5/ec5q0bvgKpvF2aY37BaXd81hs5hxfh+Txf7ODkYHDo89E0+yeZyY8ZvFo2/LKkaP6fN+
	Mnl83iQXwBrVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg
	65aZA3SMkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMDNJCwhjFjb6tbwRzOiumX
	NrI3MM5l72Lk5JAQMJGYsWcaK4QtJnHh3nq2LkYuDiGB6YwSZx9eYoZwmpgkvsx9yAZSxSag
	JbH/xQ0wW0RAQmLJnDuMIDazwA1GiRfbYkBsYYEIifMLfoLVsAioSvzbtJsJxOYVcJW493wb
	G8Q2OYkPex6xT2DkXsDIsIpRNLUguaA4KT3XUK84Mbe4NC9dLzk/dxMjOD6eSe1gXNlgcYhR
	gINRiYfXIe5fsBBrYllxZe4hRgkOZiUR3qPHgUK8KYmVValF+fFFpTmpxYcYTYG2T2SWEk3O
	B8ZuXkm8obGJmZGlkbmhhZGxuZI474FW60AhgfTEktTs1NSC1CKYPiYOTqkGxkVyj04W/tQI
	6m1xPTBDgSXP4s7PFcrTrq1YcWwq25U1N+LNNveEBVamJn7jWb/wpZH93f/hXIomTztOnJVf
	2bLiUsQ1doaqXxM+6nWlmLupz5wY3uPidONphNKTnSmTF/Sw/63O4bzbmPj+/bLHwcmz9jwx
	2h0ZWfWGq+pl8/TONa8LD6aZ1yuxFGckGmoxFxUnAgCh7+G/pQIAAA==
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

Changes from v2:
- Drop the checking statement of 'info->base' because it is un-needed

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
 drivers/rtc/rtc-s3c.c                             | 851 ++++++++++++++--------
 3 files changed, 535 insertions(+), 321 deletions(-)

-- 
1.8.0

