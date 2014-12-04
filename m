Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753578AbaLDKtk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 05:49:40 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:25508 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712AbaLDKtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 05:49:35 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-3c-54803c3b3f35
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Mike Turquette <mturquette@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Kukjin Kim <kgene@kernel.org>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Linus Walleij <linus.walleij@linaro.org>, linux-gpio@vger.kernel.org,
        devicetree@vger.kernel.org, Vivek Gautam <gautam.vivek@samsung.com>,
        Kevin Hilman <khilman@kernel.org>
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v3 0/3] Fix Arndale Octa/Peach Pi boot on Audio subsystem clocks
Date: Thu, 04 Dec 2014 11:47:52 +0100
Message-id: <1417690075-13483-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGLMWRmVeSWpSXmKPExsVy+t/xq7rWNg0hBn1PTCw2zljPajH/yDlW
	i7YrB9ktjv4usHj9wtCi//FrZounmx8zWZxtesNuMeXPciaLTY+vsVpsnv+H0eLyrjlsFjPO
	72OyWHvkLrvF0wkX2SwOv2lntVi16w+jg6DH3+fXWTx2zrrL7rFpVSebx51re9g8Ni+p9+jb
	sorR4/MmuQD2KC6blNSczLLUIn27BK6MSV9ZCr7zVdxua2NvYHzJ3cXIySEhYCLxvmMWE4Qt
	JnHh3nq2LkYuDiGBpYwS+/d/YwZJCAn0MUks/sgPYrMJGEtsXr4ErEhE4A+zxP2JX5lBHGaB
	o4wS03vfgo0SFgiQ+HRmEVCCg4NFQFXi/11XkDCvgLvEpK79LBDb5CROHpvMOoGRewEjwypG
	0dTS5ILipPRcQ73ixNzi0rx0veT83E2MkLD8soNx8TGrQ4wCHIxKPLwLntaHCLEmlhVX5h5i
	lOBgVhLhZfwLFOJNSaysSi3Kjy8qzUktPsTIxMEp1cBoe2Qbx6GPBUp7lhsLhW/LenWqaV/7
	jQc/uLT9t6/Zcnv2eudHAgxf55y9Fs8w+alFj+ZR6Y8vGyYtmJNVVnLhdREv40nGdKP2Un2B
	7eWVcXbJ6lpxGl5bDiW+O3BHxu7nVbsVi3KWrfUx844tPLleuUm4sOzmcqVzeVEpdRsnmjkn
	ZGc41EYrsRRnJBpqMRcVJwIAgXkgSSkCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


Changes since v2
================
1. Patch 1 applied ("clk: samsung: Fix double add of syscore ops after
   driver rebind"), remove it.
2. Squash patch 5 with "clk: samsung: Fix clock disable
   failure because domain being gated". Suggested by Sylwester.
3. Patch 1/3: Fix issues pointed by Sylwester.
4. Patch 2/3: Fix redundant clk_disable when removing driver (clk is
   already disabled). Add missing check !=null when removing driver.
5. Patch 3/3: Extend commit message.

Changes since v1
================
1. clocks-audss: Reimplement own clock register functions instead
   changing clk API. Minor fixes. (after idea from Tomasz Figa)
2. Add new patches: fix for pinctrl and minor fixes in clk-audss.

Description
===========
This patchset tries to solve dependency between AudioSS components
(clocks and GPIO) and main clock controller on Exynos 5420 platform.

This solves boot failure of Peach Pi/Pit and Arndale Octa [1].

Any access to memory of audss block (like checking if clock is enabled
or configuring GPIO) will hang if main audss clock is gated.

Tested on Arndale Octa board.

[1] http://www.spinics.net/lists/linux-samsung-soc/msg39331.html

Best regards,
Krzysztof Kozlowski


Krzysztof Kozlowski (3):
  clk: samsung: Fix clock disable failure because domain being gated
  pinctrl: exynos: Fix GPIO setup failure because domain clock being
    gated
  ARM: dts: exynos5420: Add clock for audss pinctrl (fixing GPIO setup
    failure)

 .../bindings/pinctrl/samsung-pinctrl.txt           |   6 +
 arch/arm/boot/dts/exynos5420-pinctrl.dtsi          |   3 +
 drivers/clk/samsung/clk-exynos-audss.c             | 357 ++++++++++++++++++---
 drivers/pinctrl/samsung/pinctrl-samsung.c          | 111 ++++++-
 drivers/pinctrl/samsung/pinctrl-samsung.h          |   2 +
 5 files changed, 436 insertions(+), 43 deletions(-)

-- 
1.9.1

