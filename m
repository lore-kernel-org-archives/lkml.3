Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909AbbAHBlF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 20:41:05 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:40189 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202AbbAHBlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 20:41:01 -0500
X-AuditID: cbfee68f-f791c6d000004834-d0-54ade02a640d
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com, kgene@kernel.org
Cc: kyungmin.park@samsung.com, rafael.j.wysocki@intel.com,
        mark.rutland@arm.com, a.kesavan@samsung.com, tomasz.figa@gmail.com,
        k.kozlowski@samsung.com, b.zolnierkie@samsung.com, robh+dt@kernel.org,
        cw00.choi@samsung.com, inki.dae@samsung.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCHv3 0/8] devfreq: Add generic exynos memory-bus frequency driver
Date: Thu, 08 Jan 2015 10:40:49 +0900
Message-id: <1420681257-3078-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBLMWRmVeSWpSXmKPExsWyRsSkWFfrwdoQgzmfdCwer1nMZLFxxnpW
	i+tfnrNaTLo/gcXi9QtDi/7Hr5ktzja9YbfY9Pgaq8XlXXPYLD73HmG0mHF+H5PF0usXmSxu
	N65gs3i84i27ReveI+wWq3b9YXQQ8Fgzbw2jx85Zd9k9Fu95yeSxaVUnm8fmJfUefVtWMXp8
	3iQXwB7FZZOSmpNZllqkb5fAlTHpxQSWgrlSFdPmHGBvYDwg0sXIySEhYCLx5303G4QtJnHh
	3nogm4tDSGApo8S5Pa/YYYqWX3rBCpFYxChx/+BsJginiUni1Yr5jCBVbAJaEvtf3AAbJSKg
	J9F5bA9YN7PAHyaJpk0sILawgJ9Ef+dfZhCbRUBVonvzNTCbV8BFYtrepVDbFCSWLZ/JCmFf
	Ype4M4sNol5A4tvkQ0BzOIDishKbDjBDlEhKHFxxg2UCo+ACRoZVjKKpBckFxUnpRcZ6xYm5
	xaV56XrJ+bmbGIERcvrfs/4djHcPWB9iFOBgVOLhLehbEyLEmlhWXJl7iNEUaMNEZinR5Hxg
	HOaVxBsamxlZmJqYGhuZW5opifMulPoZLCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoGxuLuZ
	0Wi1zVlJ53tcUutUOH/UONR9+BW2ZHX6TV1PqcuWM658WKWU1xn2Z/LKuUqOTmwenxcql1+L
	kV/+seW97B67jhfOvtzBEU232poN3/l6Fm5RWOl0RXCJmGKOG9MTs3PuvI//yqmu2uUexzfp
	19kwjdr5H7J26nd5Blwzue/0doXPpAAlluKMREMt5qLiRADog5h1iwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMIsWRmVeSWpSXmKPExsVy+t9jAV2tB2tDDBbNVrZ4vGYxk8XGGetZ
	La5/ec5qMen+BBaL1y8MLfofv2a2ONv0ht1i0+NrrBaXd81hs/jce4TRYsb5fUwWS69fZLK4
	3biCzeLxirfsFq17j7BbrNr1h9FBwGPNvDWMHjtn3WX3WLznJZPHplWdbB6bl9R79G1Zxejx
	eZNcAHtUA6NNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+Arltm
	DtDxSgpliTmlQKGAxOJiJX07TBNCQ9x0LWAaI3R9Q4LgeowM0EDCGsaMSS8msBTMlaqYNucA
	ewPjAZEuRk4OCQETieWXXrBC2GISF+6tZ+ti5OIQEljEKHH/4GwmCKeJSeLVivmMIFVsAloS
	+1/cYAOxRQT0JDqP7WEHsZkF/jBJNG1iAbGFBfwk+jv/MoPYLAKqEt2br4HZvAIuEtP2LmWH
	2KYgsWz5TNYJjNwLGBlWMYqmFiQXFCel5xrpFSfmFpfmpesl5+duYgRH4DPpHYyrGiwOMQpw
	MCrx8Bb0rQkRYk0sK67MPcQowcGsJMLbdXZtiBBvSmJlVWpRfnxRaU5q8SFGU6DtE5mlRJPz
	gckhryTe0NjEzMjSyNzQwsjYXEmcV8m+LURIID2xJDU7NbUgtQimj4mDU6qBcbqy7Gr33xct
	P984Z/3YLPTtPJ8lfJmCPnXLrgWxbrEreTF1yubZ7b3+/accLDiLVq7mSl5a9Wzy4jN1DWbN
	dYyLzTLPxepd2umvt9r13Znvy+ZXh6Ut3XpiXtquY0z+XbWBmzaKuqo7m36aKV+0VGDLrPur
	VkW0nnh3a7pIdrDXdH1vpTsTdiixFGckGmoxFxUnAgDsYHDR1gIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch-set adds the generic exynos bus frequency driver for memory bus
with DEVFREQ framework. The Samsung Exynos SoCs have the common architecture
for memory bus between DRAM memory and MMC/sub IP in SoC. This driver can
support the memory bus frequency driver for Exynos SoCs.

Each memory bus block has a clock for memory bus speed and frequency
table which is changed according to the utilization of memory bus on runtime.
And then each memory bus group has the one more memory bus blocks and
OPP table (including frequency and voltage), regulator, devfreq-event
devices.

There are a little difference about the number of memory bus because each Exynos
SoC have the different sub-IP and different memory bus speed. In spite of this
difference among Exynos SoCs, we can support almost Exynos SoC by adding
unique data of memory bus to devicetree file.

Depend on:
- v3.19-rc3
- [PATCHv7 00/10] devfreq: Add devfreq-event class to provide raw data for devfreq device
  : https://lkml.org/lkml/2015/1/7/795

Changelog:

Changes from v2:
(https://lkml.org/lkml/2014/12/31/2)
- Support the memory bus frequency feature for Exynos3250-based Monk board
- Fix build warning about variable uninitialized

Changes from v1:
(https://lkml.org/lkml/2014/12/23/178)
- This patchset is rebased on v3.19-rc2.
- Fix bug after wake-up from suspend state. If devfreq device fail to get event,
  exynos-busfreq retry to set the event for starting.
- Add memory bus group of Exynos4x12/Exynos4210
- Add divider clock id for Exynos4 memory bus frequency
- Support memory bus frequency driver on Exynos4412-based TRATS2 board
- This patch-set has the dependency on following patch-set[1]:
  [1] [PATCHv6 0/9] devfreq: Add devfreq-event class to provide raw data for devfreq device
  : https://lkml.org/lkml/2014/12/28/139

Chanwoo Choi (8):
  devfreq: exynos: Add generic exynos memory bus frequency driver
  devfreq: exynos: Add documentation for generic exynos memory bus frequency driver
  ARM: dts: Add memory bus node for Exynos3250
  clk: samsung: exynos4: Add divider clock id for memory bus frequency
  ARM: dts: Add memory bus node for Exynos4x12
  ARM: dts: Add memory bus node for Exynos4210
  ARM: dts: Add memory bus node for Exynos3250-based Rinato/Monk board
  ARM: dts: Add memory bus node for Exynos4412-based TRATS2 board

 .../devicetree/bindings/devfreq/exynos-busfreq.txt | 184 +++++++
 arch/arm/boot/dts/exynos3250-monk.dts              |  12 +
 arch/arm/boot/dts/exynos3250-rinato.dts            |  12 +
 arch/arm/boot/dts/exynos3250.dtsi                  | 125 +++++
 arch/arm/boot/dts/exynos4210.dtsi                  |  93 ++++
 arch/arm/boot/dts/exynos4412-trats2.dts            |  12 +
 arch/arm/boot/dts/exynos4x12.dtsi                  | 121 +++++
 drivers/clk/samsung/clk-exynos4.c                  |  10 +-
 drivers/devfreq/Kconfig                            |  15 +
 drivers/devfreq/Makefile                           |   1 +
 drivers/devfreq/exynos-busfreq.c                   | 589 +++++++++++++++++++++
 include/dt-bindings/clock/exynos4.h                |   7 +-
 12 files changed, 1175 insertions(+), 6 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/devfreq/exynos-busfreq.txt
 create mode 100644 drivers/devfreq/exynos-busfreq.c

-- 
1.8.5.5

