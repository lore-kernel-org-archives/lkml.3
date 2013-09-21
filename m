Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752383Ab3IURmr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 13:42:47 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:26733 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969Ab3IURmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 13:42:44 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-de-523dda92c79a
From: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
To: mturquette@linaro.org
Cc: rob@landley.net, ijc+devicetree@hellion.org.uk, swarren@wwwdotorg.org,
        mark.rutland@arm.com, pawel.moll@arm.com, rob.herring@calxeda.com,
        kgene.kim@samsung.com, ben-linux@fluff.org, kyungmin.park@samsung.com,
        linux@arm.linux.org.uk, tomasz.figa@gmail.com, t.figa@samsung.com,
        thomas.abraham@linaro.org, s.nawrocki@samsung.com, rjw@sisk.pl,
        viresh.kumar@linaro.org, linux-pm@vger.kernel.org,
        cpufreq@vger.kernel.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
Subject: [PATCH v4 0/3] ARM: S5PV210: move to common clk framework
Date: Sat, 21 Sep 2013 19:42:19 +0200
Message-id: <1379785342-25107-1-git-send-email-m.krawczuk@partner.samsung.com>
X-Mailer: git-send-email 1.8.1.2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFLMWRmVeSWpSXmKPExsVy+t9jQd1Jt2yDDN7ekLOYtO4Ak8XTph/s
	FvOPnGO1OPdqJaNF74KrbBZnm96wW2x6fI3VYmHbEhaLy7vmsFl87j3CaHH7Mq/F6TWnmC2W
	Xr8I1DrhIpvFhOlrWSz6F/YyWRxeATRu3cvpLBaH37SzWrw62MZisX7GaxaLYzOWMFqs2vWH
	0WLjVw8HCY8189YwerQ097B5LPh8hd3j76oXzB47Z91l91i5/Aubx6vVM1k97lzbw+axeUm9
	x8F3e5g8+rasYvR4tLiF0ePzJjmPjXNDA/iiuGxSUnMyy1KL9O0SuDJu71zOUvCMp6Jn9wW2
	BsaNnF2MnBwSAiYS7xa8YoewxSQu3FvP1sXIxSEkMJ1RYlrfFxYIp51JouVbLyNIFZuAucTE
	Z5tYQGwRAUmJB5+ngxUxCzxgkZj56DpYkbCAk8TFQ6/AbBYBVYlzz3+zdjFycPAK+Eks3RQL
	sU1B4uflE2wTGLkXMDKsYhRNLUguKE5KzzXSK07MLS7NS9dLzs/dxAiOkWfSOxhXNVgcYhTg
	YFTi4RVIsA0SYk0sK67MPcQowcGsJMIrsgsoxJuSWFmVWpQfX1Sak1p8iFGag0VJnPdgq3Wg
	kEB6YklqdmpqQWoRTJaJg1OqgbH1VsAmsfJ1fQzbf/Hw35BhnJw6R8Ho6JcXc04/SKoJ/6b1
	aarrpDPKYetSl5U28eqzNcsJMmxZa6WhYzrfSkfJoJJDS9S5chdb/LoNe+8ETr/XddRFoN57
	ta9s6rRVGzcrNVhsetF8WyXvtc+L4qmeK1VkOvzUliiEH1aa7m35qsr7udB0HSWW4oxEQy3m
	ouJEADuXD3iNAgAA
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

