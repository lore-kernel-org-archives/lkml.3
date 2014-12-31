Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751856AbaLaAjn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 19:39:43 -0500
Received: from mout.gmx.net ([212.227.17.22]:50400 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751424AbaLaAjm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 19:39:42 -0500
Message-ID: <54A34538.2020802@gmx.de>
Date: Wed, 31 Dec 2014 01:37:12 +0100
From: Heinrich Schuchardt <xypron.glpk@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.3.0
MIME-Version: 1.0
To: Chen-Yu Tsai <wens@csie.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
CC: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Shuge <shuge@allwinnertech.com>, Meng Zhang <kevin@allwinnertech.com>,
        linux-arm-kernel@lists.infradead.org
Subject: ARM: dts: sun9i: Allwinner A80 dtsi - missing clock-frequency property
References: <1412773376-25212-1-git-send-email-wens@csie.org> <1412773376-25212-3-git-send-email-wens@csie.org>
In-Reply-To: <1412773376-25212-3-git-send-email-wens@csie.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:h3tYos5wanwivW1hhJg9skFYruWI3Grm9VI4jnledYPUZGYMb4g
 X/QeowZ1YOd5vktBaCzRJ3ZkGvHZZzbe1geRi6L96RsLZxg2pudjrIx4kIUla6ntok9mvB0
 T7SaKdRa8S6O/ZuAxfgIYMIK0UZArLy8zAkBJ7pOyBt8xEIRkqrPliXNT+xFgBhKGacXk1F
 a0POleLUpRBHLqA8xuzCA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When booting Linux 3.19-rc2 on a Merrii Optimusboard using 
arch/arm/boot/dts/sun9i-a80-optimus.dts adn 
arch/arm/boot/dts/sun9i-a80.dtsi I get errors
[    0.061192] /cpus/cpu@0 missing clock-frequency property
[    0.061209] /cpus/cpu@1 missing clock-frequency property
[    0.061223] /cpus/cpu@2 missing clock-frequency property
[    0.061237] /cpus/cpu@3 missing clock-frequency property
[    0.061251] /cpus/cpu@100 missing clock-frequency property
[    0.061266] /cpus/cpu@101 missing clock-frequency property
[    0.061283] /cpus/cpu@102 missing clock-frequency property
[    0.061300] /cpus/cpu@103 missing clock-frequency property

The dtsi was provided by patch
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=4ab328f06e305bf3ea254f4e3c94bb4d820998c1

According to file pack/chips/sun9iw1p1/optimus/sys_config.fex supplied 
in the OptimusBoard SDK the big cluster can run at up to 1800 MHz, and
the LITTLE cluster can run at up to 1200 MHz,depending on the CPU voltage:

big
1.08V (1608Mhz, 1800Mhz]
1.00V (1536Mhz, 1608Mhz]
0.96V (1440Mhz, 1536Mhz]
0.90V (1296Mhz, 1440Mhz]
0.84V (   0Mhz, 1296Mhz]

LITTLE
1.02V (1128Mhz, 1200Mhz]
0.96V (1008Mhz, 1128Mhz]
0.90V ( 864Mhz, 1008Mhz]
0.84V (   0Mhz,  864Mhz]

I guess the proper way to specify the data is the one described in
Documentation/devicetree/bindings/cpufreq/arm_big_little_dt.txt

Other boards might run at other frequencies. Hence we might want to put 
this information into the board file
arch/arm/boot/dts/sun9i-a80-optimus.dts.

Documentation/devicetree/bindings/cpufreq/arm_big_little_dt.txt,
arch/arm/boot/dts/exynos5260.dtsi, and
arch/arm/boot/dts/exynos5420.dtsi, all assume that
cpu@0-cpu@3 are A15 (big) and cpu@101-cpu@103 are A7 (LITTLE).

Shouldn't arch/arm/boot/dts/sun9i-a80.dtsi stick to this convention?

The scripts to create the uImage and to reproduce the problem are in
https://github.com/xypron/kernel-optimusboard/tree/35d06c020f6584b5023e0e4bef67cc5a625f65bb

Best regards

Heinrich Schuchardt


