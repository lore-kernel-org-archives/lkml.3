Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755AbaKNIjO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 03:39:14 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:8518 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754635AbaKNIjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 03:39:12 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 14 Nov 2014 00:39:15 -0800
Message-ID: <5465BFA2.9050706@nvidia.com>
Date: Fri, 14 Nov 2014 17:38:58 +0900
From: Alexandre Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Mark Brown <broonie@kernel.org>, Mark Rutland <mark.rutland@arm.com>
CC: Simon Horman <horms@verge.net.au>, Joe Perches <joe@perches.com>,
        "Geert Uytterhoeven" <geert@linux-m68k.org>,
        Kuninori Morimoto <kuninori.morimoto.gx@gmail.com>,
        Olof Johansson <olof@lixom.net>,
        "Stephen Warren" <swarren@wwwdotorg.org>,
        Rob Herring <robh@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "ALSA Development Mailing List" <alsa-devel@alsa-project.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        Magnus <magnus.damm@gmail.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH v3] of: replace Asahi Kasei Corp venter prefix
References: <5398AB07.4040304@wwwdotorg.org>	<87sinbdk44.wl%kuninori.morimoto.gx@renesas.com>	<878ulzx6hr.wl%kuninori.morimoto.gx@gmail.com>	<20140922130026.GK3290@leverpostej>	<CAMuHMdX22z97SbGS1HDiYfJ1PXxyEN2S8D7w4sr+4bUwD+mJZw@mail.gmail.com>	<20140922132743.GM3290@leverpostej>	<87y4rfhmgl.wl%kuninori.morimoto.gx@renesas.com>	<1415845309.4269.6.camel@perches.com>	<20141113025105.GA16652@verge.net.au>	<87vbmjhj00.wl%kuninori.morimoto.gx@renesas.com>	<20141113110740.GE3815@sirena.org.uk> <87k32yd0bd.wl%kuninori.morimoto.gx@renesas.com>
In-Reply-To: <87k32yd0bd.wl%kuninori.morimoto.gx@renesas.com>
X-NVConfidentiality: public
X-Originating-IP: [10.19.57.128]
X-ClientProxiedBy: HKMAIL102.nvidia.com (10.18.16.11) To
 HKMAIL102.nvidia.com (10.18.16.11)
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/2014 10:43 AM, Kuninori Morimoto wrote:
> From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
>
> Current vendor-prefixes.txt already has
> "ak" prefix for Asahi Kasei Corp by
> ae8c4209af2cec065fef15d200a42a04130799f7
> (of: Add vendor prefix for Asahi Kasei Corp.)
>
> It went through the appropriate review process.
> But, almost all Asahi Kasei chip drivers are
> using "asahi-kasei" prefix today.
> (arch/arm/boot/dts/tegra20-seaboard.dts only is
> using "ak,ak8975", but there are instances of
> "asahi-kasei,ak8975" in other dts files.
> And drivers/iio/magnetometer/ak8975.c
> doesn't support "ak,ak8975")
> So, we made a mistake there.
>
> In addition, checkpatch.pl reports WARNING
> if it is using "asahi-kasei" prerfix in DT file.
> (DT compatible string vendor "asahi-kasei" appears un-documented)
>
> Marking it deprecated and warning with checkpatch
> is certainly preferable.
> So, this patch replace "ak" to "asahi-kasei" in
> vendor-prefixes.txt. (and fixup tegra20-seaboard)
>
> OTOH, Asahi Kasei is usually referred to as "AKM",
> but this patch doesn't care about it.
> Because no DT is using that today.
>
> Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
> ---
>   .../devicetree/bindings/vendor-prefixes.txt        |    2 +-
>   arch/arm/boot/dts/tegra20-seaboard.dts             |    2 +-
>   2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
> index 723999d..ddcb4cd 100644
> --- a/Documentation/devicetree/bindings/vendor-prefixes.txt
> +++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
> @@ -9,7 +9,6 @@ ad	Avionic Design GmbH
>   adapteva	Adapteva, Inc.
>   adi	Analog Devices, Inc.
>   aeroflexgaisler	Aeroflex Gaisler AB
> -ak	Asahi Kasei Corp.
>   allwinner	Allwinner Technology Co., Ltd.
>   altr	Altera Corp.
>   amcc	Applied Micro Circuits Corporation (APM, formally AMCC)
> @@ -20,6 +19,7 @@ amstaos	AMS-Taos Inc.
>   apm	Applied Micro Circuits Corporation (APM)
>   arm	ARM Ltd.
>   armadeus	ARMadeus Systems SARL
> +asahi-kasei	Asahi Kasei Corp.
>   atmel	Atmel Corporation
>   auo	AU Optronics Corporation
>   avago	Avago Technologies
> diff --git a/arch/arm/boot/dts/tegra20-seaboard.dts b/arch/arm/boot/dts/tegra20-seaboard.dts
> index a1d4bf9..7f5cf80 100644
> --- a/arch/arm/boot/dts/tegra20-seaboard.dts
> +++ b/arch/arm/boot/dts/tegra20-seaboard.dts
> @@ -405,7 +405,7 @@
>   		clock-frequency = <400000>;
>
>   		magnetometer@c {
> -			compatible = "ak,ak8975";
> +			compatible = "asahi-kasei,ak8975";

Mmm. So does this mean this device was never probed because the driver 
did not recognize its compatible property? I cannot find "ak,ak8975" 
anywhere else in the kernel.

If so,

Acked-by: Alexandre Courbot <acourbot@nvidia.com>
