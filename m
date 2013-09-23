Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753736Ab3IWM2u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 08:28:50 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:60552 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753407Ab3IWM2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 08:28:47 -0400
X-AuditID: cbfec7f5-b7ef66d00000795a-86-524033fcebf8
From: Tomasz Figa <t.figa@samsung.com>
To: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
Cc: mturquette@linaro.org, rob@landley.net, ijc+devicetree@hellion.org.uk,
        swarren@wwwdotorg.org, mark.rutland@arm.com, pawel.moll@arm.com,
        rob.herring@calxeda.com, kgene.kim@samsung.com, ben-linux@fluff.org,
        kyungmin.park@samsung.com, linux@arm.linux.org.uk,
        tomasz.figa@gmail.com, thomas.abraham@linaro.org,
        s.nawrocki@samsung.com, rjw@sisk.pl, viresh.kumar@linaro.org,
        linux-pm@vger.kernel.org, cpufreq@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 0/3] ARM: S5PV210: move to common clk framework
Date: Mon, 23 Sep 2013 14:28:33 +0200
Message-id: <1533271.F4sWn2BdKU@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.11 (Linux/3.10.10-gentoo; KDE/4.11.0; x86_64; ; )
In-reply-to: <1379785342-25107-1-git-send-email-m.krawczuk@partner.samsung.com>
References: <1379785342-25107-1-git-send-email-m.krawczuk@partner.samsung.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMIsWRmVeSWpSXmKPExsVy+t/xK7p/jB2CDNr/mFpMWneAyeJp0w92
	i/lHzrFanHu1ktGid8FVNouzTW/YLTY9vsZqsbBtCYvF5V1z2Cw+9x5htLh9mdfi9JpTzBZL
	r18Eap1wkc1iwvS1LBb9C3uZLA6vABq37uV0FovDb9pZLV4dbGOxODZjCaPFql1/GC02fvVw
	EPdYM28No0dLcw+bx4LPV9g9/q56weyxc9Zddo+Vy7+webxaPZPV4861PWwem5fUexx8t4fJ
	o2/LKkaPR4tbGD0+b5Lz2Dg3NIAvissmJTUnsyy1SN8ugStj7b//jAWb+Cv23L7J3MC4jLuL
	kZNDQsBEYv7H1YwQtpjEhXvr2UBsIYGljBLXDmh0MXIB2V1MEg/3vGMBSbAJqEl8bngEViQi
	YCrx7u41NpAiZoF1LBKPvlwCmyQs4CbxpHkuM4jNIqAqce3EPDCbV0BToulMNyuIzS+gLvFu
	21MmEFtUwFXi08KN7CA2p4C/ROOCBYwQV/hJzH7QxQbRKyjxY/I9sCOYBeQl9u2fygpha0ms
	33mcaQKj4CwkZbOQlM1CUraAkXkVo2hqaXJBcVJ6rpFecWJucWleul5yfu4mRkjEf93BuPSY
	1SFGAQ5GJR7eiET7ICHWxLLiytxDjBIczEoivIsUHYKEeFMSK6tSi/Lji0pzUosPMTJxcEo1
	MDY+OvmxZWJhz2Mpw/QVrf4HJd4E88QdeLHgT1Givo7V4+2OBza7tgp7qWkY/W7dfOqZ+0eF
	w3cmntBcNsknw972fl1YjV+P4y8bkWSetS4OHNqrXrP6xTz25P99YcWPlfq6+9yYzZhXuTFy
	bI9dedD1H98Wj1Np6hUPS9fPXemd5Oa36ueCBiWW4oxEQy3mouJEAAy3H7PWAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mateusz,

On Saturday 21 of September 2013 19:42:19 Mateusz Krawczuk wrote:
> This patch series is the new s5pv210 clock implementation
> (using common clk framework).
> 
> This implementation is compatible with device tree definition and board
> files.
> 
> This patch series is based on linux-next and has been tested on goni and
> aquila
> boards using board file.
> 
> Since v3:
> 
> Replace s5pv210_clk_register_finpll, by creating mux finpll
> with xusbxti and xxti as parrents.
> 
> Mateusz Krawczuk (3):
>   clk: samsung: Add clock driver for s5pc110/s5pv210
>   Cpufreq: s5pv210 cpufreq fixes for CCF
>   ARM: s5pv210: Migrate clock handling to Common Clock Framework
> 
>  .../bindings/clock/samsung,s5pv210-clock.txt       |  75 +++
>  arch/arm/mach-s5pv210/Kconfig                      |   9 +
>  arch/arm/mach-s5pv210/Makefile                     |   4 +-
>  arch/arm/mach-s5pv210/common.c                     |  17 +
>  arch/arm/mach-s5pv210/common.h                     |  10 +
>  arch/arm/mach-s5pv210/mach-goni.c                  |   2 +-
>  arch/arm/mach-s5pv210/mach-smdkv210.c              |   2 +-
>  arch/arm/plat-samsung/Kconfig                      |   2 +-
>  drivers/clk/samsung/Makefile                       |   3 +
>  drivers/clk/samsung/clk-s5pv210.c                  | 673
> +++++++++++++++++++++ drivers/cpufreq/s5pv210-cpufreq.c                 
> |   6 +-
>  include/dt-bindings/clock/samsung,s5pv210-clock.h  | 224 +++++++
>  12 files changed, 1019 insertions(+), 8 deletions(-)
>  create mode 100644
> Documentation/devicetree/bindings/clock/samsung,s5pv210-clock.txt create
> mode 100644 drivers/clk/samsung/clk-s5pv210.c
>  create mode 100644 include/dt-bindings/clock/samsung,s5pv210-clock.h

Very nice work. I hope we will be able to finally move S5PV210 to Device 
Tree for 3.13 and drop all the legacy code.

Acked-by: Tomasz Figa <t.figa@samsung.com>

Best regards,
Tomasz

