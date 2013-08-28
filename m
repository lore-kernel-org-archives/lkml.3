Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754336Ab3H1QaC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 12:30:02 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:16567 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753464Ab3H1Q37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 12:29:59 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-d6-521e2584d8ce
From: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
To: kgene.kim@samsung.com
Cc: mturquette@linaro.org, tomasz.figa@gmail.com, yadi.brar@samsung.com,
        dianders@chromium.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ian.campbell@citrix.com, rob@landley.net,
        thomas.abraham@linaro.org, s.nawrocki@samsung.com,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux@arm.linux.org.uk, ben-linux@fluff.org,
        linux-samsung-soc@vger.kernel.org,
        Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
Subject: [RFC 0/3] ARM: S5PC100: move to common clk framework
Date: Wed, 28 Aug 2013 18:29:14 +0200
Message-id: <1377707357-4902-1-git-send-email-m.krawczuk@partner.samsung.com>
X-Mailer: git-send-email 1.8.1.2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrELMWRmVeSWpSXmKPExsVy+t9jQd1WVbkgg9mXeS0mrTvAZDH/yDlW
	i7PLDrJZvOntYLHoXXCVzWLT42usFgvblrBYXN41h81ixvl9TBa3gRpOrznFbLH0+kUmi6cT
	LrJZTJi+lsVi3cvpLBaH37SzWrw62MZicWzGEkaLVbv+MFrMmf6OyUHEY828NYweLc09bB6z
	Gy6yeLyePIHR4++qF8weO2fdZfd4tXomq8eda3vYPDYvqfc4+G4Pk0ffllWMHp83yXlsnBsa
	wBvFZZOSmpNZllqkb5fAlfGx/zxrwWfuirU/3rM0MJ7j6GLk5JAQMJF43XeHBcIWk7hwbz1b
	FyMXh5DAdEaJL5dfMoMkhATamSRufcwAsdkEzCUmPtsE1iAiICnR1PCHGaSBWaCDReLpgZes
	IAlhAVuJJbfmMIHYLAKqEuua54HZvAK+EocPLWGC2KYg8fPyCbYJjNwLGBlWMYqmFiQXFCel
	5xrpFSfmFpfmpesl5+duYgSH/DPpHYyrGiwOMQpwMCrx8Eb8lg0SYk0sK67MPcQowcGsJML7
	W0QuSIg3JbGyKrUoP76oNCe1+BCjNAeLkjjvwVbrQCGB9MSS1OzU1ILUIpgsEwenVAOj1L9L
	einn252KTfu2hfonMXxlrNw2eatW4trF1zg73iTNjTrH2yudfuhI3snsR5b7Um/EGfv2Hz9w
	1vUq++6Ve5y6uZVmCroLaqs9s3nPJLR0am4+p4RH2tt9cX90QtneJi4RPdXRdHxVTpPi59zF
	EvWqdjFnXkjlbBcI7tQ4ePNryrS2rIlKLMUZiYZazEXFiQATjNUbdQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series is the new s5pc100 clock implementation
(using common clk framework).

This implementation is compatible with device tree definition and board files.

This patch series is based on linux-next and has been tested on smdkc100 
board using board file.

Mateusz Krawczuk (3):
  clk: samsung: pll: Add support for PLL6545a and PLL6522x
  clk: samsung: Add clock driver for s5pc100
  ARM: s5pc100: Migrate clock handling to Common Clock Framework

 .../bindings/clock/samsung,s5pc100-clock.txt       |  72 +++
 arch/arm/mach-s5pc100/Kconfig                      |   8 +
 arch/arm/mach-s5pc100/Makefile                     |   4 +-
 arch/arm/mach-s5pc100/common.c                     |  23 +-
 arch/arm/mach-s5pc100/common.h                     |  13 +
 arch/arm/mach-s5pc100/mach-smdkc100.c              |   3 +-
 arch/arm/plat-samsung/Kconfig                      |   2 +-
 drivers/clk/samsung/Makefile                       |   3 +-
 drivers/clk/samsung/clk-pll.c                      |   2 +
 drivers/clk/samsung/clk-pll.h                      |   2 +
 drivers/clk/samsung/clk-s5pc100.c                  | 695 +++++++++++++++++++++
 include/dt-bindings/clock/samsung,s5pc100-clock.h  | 202 ++++++
 12 files changed, 1023 insertions(+), 6 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/clock/samsung,s5pc100-clock.txt
 create mode 100644 drivers/clk/samsung/clk-s5pc100.c
 create mode 100644 include/dt-bindings/clock/samsung,s5pc100-clock.h

-- 
1.8.1.2

