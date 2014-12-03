Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751873AbaLCLEL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 06:04:11 -0500
Received: from mout.kundenserver.de ([212.227.126.187]:65269 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbaLCLEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 06:04:10 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Stefan Agner <stefan@agner.ch>, shawn.guo@linaro.org,
        kernel@pengutronix.de, linux@arm.linux.org.uk,
        u.kleine-koenig@pengutronix.de, jason@lakedaemon.net, olof@lixom.net,
        daniel.lezcano@linaro.org, tglx@linutronix.de, mark.rutland@arm.com,
        pawel.moll@arm.com, robh+dt@kernel.org, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/12] ARM: dts: add support for Vybrid running on Cortex-M4
Date: Wed, 03 Dec 2014 12:03:37 +0100
Message-ID: <2994970.DCfUQgtmcD@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1417565531-4507-12-git-send-email-stefan@agner.ch>
References: <1417565531-4507-1-git-send-email-stefan@agner.ch> <1417565531-4507-12-git-send-email-stefan@agner.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:HGnZz07krHFVi5O8b7ueSL3BH36wTMS0ifKaJA18qaf
 WZp/abnrciiq6kOvP18OCiWHucKxR7vjxPqFOmxQYO1Hk0sT9k
 i7+2LzJ5iU1Sa4NOB4kkdUH+9ad3rrQjpFMTa4GqunFcbiVOdi
 TMvil4EGoYxcihDUrPmuGNhWeV6H31IPajzddAvTXuyevApl9/
 YDFjYchSYkkvorDBdpjCXb0xWrGDOxneXUGl0bE7Ui/wAfbVd7
 SHY/tiZNy9VANp2N+WYEZAUb2+olWniwA8m1SOJb/HHBVgV9qC
 4a5DSP3FkIGbsljUzGEldHUEDPXBjNkjyOB128KbWdlCO/ZzWG
 Fa4FrUODnniVjoQyhkCs=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 December 2014 01:12:10 Stefan Agner wrote:
> diff --git a/arch/arm/boot/dts/vf610m4-colibri.dts b/arch/arm/boot/dts/vf610m4-colibri.dts
> new file mode 100644
> index 0000000..051ee0f
> --- /dev/null
> +++ b/arch/arm/boot/dts/vf610m4-colibri.dts
> @@ -0,0 +1,52 @@
> +/*
> + * Device tree for Colibri VF61 Cortex-M4 support
> + *
> + * Copyright 2014 Stefan Agner
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +
> +/dts-v1/;
> +#include "vf610m4.dtsi"
> +
> +/ {
> +       model = "VF610 Cortex-M4";
> +       compatible = "fsl,vf610m4";
> +
> +       chosen {
> +               bootargs = "console=ttyLP2,115200 ihash_entries=64 dhash_entries=64 earlyprintk clk_ignore_unused init=/linuxrc rw";
> +       };
> +

Starting with v3.19, you should be able to use the earlycon framework on
arm32, so it would be better to replace earlyprintk with earlycon here
and add a stdout-path property in chosen that points to the console
uart.

64 hash table entries sounds extremely small, doesn't that impact
performance? If you have 50MB of actual RAM available, I don't think
you need that.

	Arnd
