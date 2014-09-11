Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532AbaIKR6P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 13:58:15 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:34574 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826AbaIKR6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 13:58:13 -0400
MIME-Version: 1.0
In-Reply-To: <1410343554-8383-3-git-send-email-kever.yang@rock-chips.com>
References: <1410343554-8383-1-git-send-email-kever.yang@rock-chips.com>
	<1410343554-8383-3-git-send-email-kever.yang@rock-chips.com>
Date: Thu, 11 Sep 2014 10:58:12 -0700
X-Google-Sender-Auth: GT5ffIgkzzOqSc_sjuKYP6CQOpg
Message-ID: <CAD=FV=U3gqMeCp_z_uML3iPc6GC_nnYL9v6qwux2PQ5wzrbdwQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] ARM: dts: add intmem node for rk3288 smp support
From: Doug Anderson <dianders@chromium.org>
To: Kever Yang <kever.yang@rock-chips.com>
Cc: =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Sonny Rao <sonnyrao@chromium.org>, Addy Ke <addy.ke@rock-chips.com>,
        Eddie Cai <cf@rock-chips.com>, Jianqun Xu <xjq@rock-chips.com>,
        han jiang <hj@rock-chips.com>, Tao Huang <huangtao@rock-chips.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-rockchip@lists.infradead.org,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kever,

On Wed, Sep 10, 2014 at 3:05 AM, Kever Yang <kever.yang@rock-chips.com> wrote:
> This patch add intmem node des which is needed by platsmp.c
> and enable the smp.
>
> Signed-off-by: Heiko Stuebner <heiko@sntech.de>
> Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
> ---
>
>  arch/arm/boot/dts/rk3288.dtsi | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
>
> diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
> index dca586e..562ec5f 100644
> --- a/arch/arm/boot/dts/rk3288.dtsi
> +++ b/arch/arm/boot/dts/rk3288.dtsi
> @@ -40,6 +40,7 @@
>                 #address-cells = <1>;
>                 #size-cells = <0>;
>
> +               enable-method = "rockchip,rk3288-smp";
>                 cpu@500 {
>                         device_type = "cpu";
>                         compatible = "arm,cortex-a12";
> @@ -353,6 +354,23 @@
>                 status = "disabled";
>         };
>
> +       bus_intmem@ff700000 {
> +               compatible = "mmio-sram";
> +               reg = <0xff700000 0x18000>;
> +               #address-cells = <1>;
> +               #size-cells = <1>;
> +               ranges = <0 0xff700000 0x18000>;
> +                       smp-sram@0 {

nit: I think the "smp-sram@0" line is indented one too many tabs.

I haven't done a full review of this series yet, though...
