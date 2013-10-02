Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495Ab3JBVKW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 17:10:22 -0400
Received: from mail-qc0-f182.google.com ([209.85.216.182]:54959 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754126Ab3JBVKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 17:10:20 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:6e3b:e5ff:fe16:f1aa]
In-Reply-To: <1380670860-17621-3-git-send-email-seanpaul@chromium.org>
References: <1380670860-17621-1-git-send-email-seanpaul@chromium.org>
	<1380670860-17621-3-git-send-email-seanpaul@chromium.org>
Date: Wed, 2 Oct 2013 14:10:18 -0700
Message-ID: <CAOesGMj3142o1B_33BqtLZMbObn2tjfBaBHvAB-2+O+XOuCjSw@mail.gmail.com>
Subject: Re: [PATCH 2/5] ARM: dts: Add dp-controller node to exynos5250-snow
From: Olof Johansson <olof@lixom.net>
To: Sean Paul <seanpaul@chromium.org>
Cc: dri-devel@lists.freedesktop.org,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Inki Dae <inki.dae@samsung.com>, airlied@linux.ie
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 1, 2013 at 4:40 PM, Sean Paul <seanpaul@chromium.org> wrote:
> This patch adds the dp-controller node to the exynos5250-snow board dts
> file.
>
> Signed-off-by: Sean Paul <seanpaul@chromium.org>
> ---
>  arch/arm/boot/dts/exynos5250-snow.dts | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
>
> diff --git a/arch/arm/boot/dts/exynos5250-snow.dts b/arch/arm/boot/dts/exynos5250-snow.dts
> index e5af3f2..780511a 100644
> --- a/arch/arm/boot/dts/exynos5250-snow.dts
> +++ b/arch/arm/boot/dts/exynos5250-snow.dts
> @@ -190,6 +190,18 @@
>                 samsung,vbus-gpio = <&gpx1 1 0>;
>         };
>
> +       dp-controller {
> +               samsung,color-space = <0>;
> +               samsung,dynamic-range = <0>;
> +               samsung,ycbcr-coeff = <0>;
> +               samsung,color-depth = <1>;
> +               samsung,link-rate = <0x0a>;
> +               samsung,lane-count = <2>;
> +
> +               pinctrl-names = "default";
> +               pinctrl-0 = <&dp_hpd>;
> +       };

This won't actually do what I think you want. Since the dtsi has the
node name "dp-controller@145B0000", you will end up duplicating a new
node and not build on top of that one.

There's two ways to do it: Always include the unit address, or create
a label in the dtsi such that:

dp_controller: dp-controller@ {....
}

Then in your dts you can, at the root level:

&dp_controller {
  ... new stuff and overrides ...
};



-Olof
