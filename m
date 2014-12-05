Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751589AbaLELBS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 06:01:18 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:50591 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053AbaLELBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 06:01:15 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-75-548190773885
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
Subject: [PATCH v4 0/3] Fix Arndale Octa/Peach Pi boot on Audio subsystem clocks
Date: Fri, 05 Dec 2014 12:00:51 +0100
Message-id: <1417777254-26579-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJLMWRmVeSWpSXmKPExsVy+t/xy7rlExpDDFpPyFlsnLGe1WL+kXOs
	Fm1XDrJbHP1dYPH6haFF/+PXzBZPNz9msjjb9IbdYsqf5UwWmx5fY7XYPP8Po8XlXXPYLGac
	38dksfbIXXaLpxMuslkcftPOarFq1x9GB0GPv8+vs3jsnHWX3WPTqk42jzvX9rB5bF5S79G3
	ZRWjx+dNcgHsUVw2Kak5mWWpRfp2CVwZJ2euYy9YJFjxYfNq5gbG+7xdjJwcEgImEjeOXGWH
	sMUkLtxbz9bFyMUhJLCUUaLjyh0op49J4vePmWBVbALGEpuXLwFLiAj8YZa4P/ErM4jDLHCU
	UWJ671smkCphgQCJSW//MYPYLAKqEnefTmMDsXkF3CVOfZrICrFPTuLkscmsExi5FzAyrGIU
	TS1NLihOSs811CtOzC0uzUvXS87P3cQICc4vOxgXH7M6xCjAwajEw3vBujFEiDWxrLgy9xCj
	BAezkggvfydQiDclsbIqtSg/vqg0J7X4ECMTB6dUA+PKf6+jK379KbGfuWzFFpVFR9gr1kad
	f9Rlm1FmJdiikN+zfRt76cxMl9JjxR0HzodY6aRZvf746uiUBb8Xzhfby/8/dt+mO5svMTU5
	GhVOPsF4zvLLoyOsST+65+/gms3iUTvr33mW2c/fh/K/zmVsWGt2gPVm5Xne6TuPr1oR1PPK
	uu29welUJZbijERDLeai4kQA/96ASiwCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


Changes since v3
================
1. Patch 1/3: Fix issues pointed by Sylwester.
2. Add Javier's tested-by [1]

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

Tomasz Figa had some questions about power domains on Exynos5420 in
relation to this patchset, but I haven't addressed all of them yet.

Changes since v1
================
1. clocks-audss: Reimplement own clock register functions instead
   changing clk API. Minor fixes. (after idea from Tomasz Figa)
2. Add new patches: fix for pinctrl and minor fixes in clk-audss.

Description
===========
This patchset tries to solve dependency between AudioSS components
(clocks and GPIO) and main clock controller on Exynos 5420 platform.

This solves boot failure of Peach Pi/Pit and Arndale Octa [2].

Any access to memory of audss block (like checking if clock is enabled
or configuring GPIO) will hang if main audss clock is gated.

Tested on Arndale Octa board.

[1] https://lkml.org/lkml/2014/11/26/420
[2] http://www.spinics.net/lists/linux-samsung-soc/msg39331.html

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
 drivers/clk/samsung/clk-exynos-audss.c             | 339 ++++++++++++++++++---
 drivers/pinctrl/samsung/pinctrl-samsung.c          | 111 ++++++-
 drivers/pinctrl/samsung/pinctrl-samsung.h          |   2 +
 5 files changed, 418 insertions(+), 43 deletions(-)

-- 
1.9.1

