Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752908Ab3IXMub (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 08:50:31 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:56485 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742Ab3IXMu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 08:50:28 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-f6-52418a924bc0
From: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
To: rjw@sisk.pl, kgene.kim@samsung.com
Cc: viresh.kumar@linaro.org, cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
        kyungmin.park@samsung.com, ben-linux@fluff.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, rob.herring@calxeda.com,
        pawel.moll@arm.com, mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, rob@landley.net, mturquette@linaro.org,
        tomasz.figa@gmail.com, thomas.abraham@linaro.org,
        s.nawrocki@samsung.com, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, t.stanislaws@samsung.com,
        m.szyprowski@samsung.com, b.zolnierkie@samsung.com,
        Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
Subject: [PATCH v5 0/3] ARM: S5PV210: move to common clk framework
Date: Tue, 24 Sep 2013 14:50:06 +0200
Message-id: <1380027009-2239-1-git-send-email-m.krawczuk@partner.samsung.com>
X-Mailer: git-send-email 1.8.1.2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnkeLIzCtJLcpLzFFi42I5/e+xgO6kLscgg013NSw2zljPajFp3QEm
	i6dNP9gt5h85x2px7tVKRoveBVfZLM42vWG32PT4GqvFwrYlLBaXd81hs/jce4TRYsb5fUwW
	ty/zWpxec4rZYu2Ru+wWS69fBBoy4SKbxYTpa1ks+hf2MlkcXgE0eN3L6SwWh9+0s1q8OtjG
	YjGv/SWrxbEZSxgtVu36w2ix8auHg7THmnlrGD1amnvYPBZ8vsLu8XfVC2aPnbPusnusXP6F
	zePV6pmsHneu7WHz2Lyk3uPguz1MHn1bVjF6PFrcwujxeZOcx8a5oQF8UVw2Kak5mWWpRfp2
	CVwZq9ZmFUzmrbj27ytzA+MVzi5GTg4JAROJz/962SBsMYkL99YD2VwcQgKLGCX2Hp4A5bQz
	SfQ9u8UCUsUmYC4x8dkmIJuDQ0RATWLqJmeQGmaBTawS/z/2s4PUCAs4SazvvsMMYrMIqEpc
	OHyOHaSeV8BX4uYSXohlChI/L59gm8DIvYCRYRWjaGpBckFxUnqukV5xYm5xaV66XnJ+7iZG
	cPQ8k97BuKrB4hCjAAejEg/vhQSHICHWxLLiytxDjBIczEoivJq1jkFCvCmJlVWpRfnxRaU5
	qcWHGKU5WJTEeQ+2WgcKCaQnlqRmp6YWpBbBZJk4OKUaGFfOnfcymLvl8o6nF27JHHaZ4fIq
	+2WQkGCOj8P1mwmr/G+su+u2Q9m2em7dxwVBe9ek+J8svxEy59YJ3yVcf061KcxNZU0XmZIq
	8eHV0cvOXz/rFWY0nVE+lPNFz/CUnPHkmSuTutYvLqlIPb1E48cXpgseciXTnsy/wLrLpKDk
	Z6z9qTBZn79KLMUZiYZazEXFiQD1VGmXmgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series is the new s5pv210 clock implementation
(using common clk framework).

This implementation is compatible with device tree definition and board
files.

This patch series is based on linux-next and has been tested on goni and
aquila
boards using board file.

Since v4:
Corrected mux flags for finpll.

Since v3:

Replace s5pv210_clk_register_finpll, by creating mux finpll
with xusbxti and xxti as parrents.


Mateusz Krawczuk (3):
  clk: samsung: Add clock driver for s5pc110/s5pv210
  Cpufreq: s5pv210 cpufreq fixes for CCF
  ARM: s5pv210: Migrate clock handling to Common Clock Framework

 .../bindings/clock/samsung,s5pv210-clock.txt       |  75 +++
 arch/arm/mach-s5pv210/Kconfig                      |   9 +
 arch/arm/mach-s5pv210/Makefile                     |   4 +-
 arch/arm/mach-s5pv210/common.c                     |  17 +
 arch/arm/mach-s5pv210/common.h                     |  10 +
 arch/arm/mach-s5pv210/mach-goni.c                  |   2 +-
 arch/arm/mach-s5pv210/mach-smdkv210.c              |   2 +-
 arch/arm/plat-samsung/Kconfig                      |   2 +-
 drivers/clk/samsung/Makefile                       |   3 +
 drivers/clk/samsung/clk-s5pv210.c                  | 673 +++++++++++++++++++++
 drivers/cpufreq/s5pv210-cpufreq.c                  |   6 +-
 include/dt-bindings/clock/samsung,s5pv210-clock.h  | 224 +++++++
 12 files changed, 1019 insertions(+), 8 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/clock/samsung,s5pv210-clock.txt
 create mode 100644 drivers/clk/samsung/clk-s5pv210.c
 create mode 100644 include/dt-bindings/clock/samsung,s5pv210-clock.h

-- 
1.8.1.2

