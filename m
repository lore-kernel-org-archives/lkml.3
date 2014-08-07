Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751926AbaHGVXl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 17:23:41 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:59712 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069AbaHGVXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 17:23:37 -0400
MIME-Version: 1.0
In-Reply-To: <1407404095-3265-5-git-send-email-kever.yang@rock-chips.com>
References: <1407404095-3265-1-git-send-email-kever.yang@rock-chips.com>
	<1407404095-3265-5-git-send-email-kever.yang@rock-chips.com>
Date: Thu, 7 Aug 2014 14:23:36 -0700
X-Google-Sender-Auth: n-6VcSRYEE9w3e3_tMbq5rANKOI
Message-ID: <CAD=FV=V-yb0JLJ24i5zsKzdZExJ5h8NGDD0QdG1740kc3yoEdQ@mail.gmail.com>
Subject: Re: [PATCH v4 4/4] ARM: dts: Enable USB otg and host1(dwc) on rk3288-evb
From: Doug Anderson <dianders@chromium.org>
To: Kever Yang <kever.yang@rock-chips.com>
Cc: Paul Zimmerman <paulz@synopsys.com>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Olof Johansson <olof@lixom.net>, Sonny Rao <sonnyrao@chromium.org>,
        Addy Ke <addy.ke@rock-chips.com>, Eddie Cai <cf@rock-chips.com>,
        Jianqun Xu <xjq@rock-chips.com>, wulf <wulf@rock-chips.com>,
        lyz <lyz@rock-chips.com>, han jiang <hj@rock-chips.com>,
        Tao Huang <huangtao@rock-chips.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kever,

On Thu, Aug 7, 2014 at 2:34 AM, Kever Yang <kever.yang@rock-chips.com> wrote:
> USB otg port is the usb3.0 b-port on the board.
> USB host1 port is the host A port nearby the otg port.
>
> Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
>
> ---
>
> Changes in v4: None
> Changes in v3:
> - Rebase
>
> Changes in v2:
> - evb patch added in version 2
>
>  arch/arm/boot/dts/rk3288-evb.dtsi | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/arch/arm/boot/dts/rk3288-evb.dtsi b/arch/arm/boot/dts/rk3288-evb.dtsi
> index 4f57209..a322100 100644
> --- a/arch/arm/boot/dts/rk3288-evb.dtsi
> +++ b/arch/arm/boot/dts/rk3288-evb.dtsi
> @@ -94,3 +94,9 @@
>  &usb_host0_ehci {
>         status = "okay";
>  };
> +&usb_host1 {
> +       status = "okay";
> +};
> +&usb_otg {
> +       status = "okay";
> +};

Do you really want to enable "usb_otg" on EVB?  I think you have a
rework on your board to enable vbus on this port, but I don't think
it's applicable to anyone else, is it?

I'm told that on some boards you can turn on GPIO0_12 to get vbus, but
I don't have a board like that so I can't really test.  Even so,
before enabling the otg port we should probably put something in the
dts file that would turn on that vbus...

Unless you've somehow gotten gadget mode to work on the OTG port, my
vote would be to leave it disabled for the EVB for now.


NOTE: keeping the otg definition in the main "r3288.dtsi" (patch 3/4)
still makes sense because other boards may have the OTG port hooked
up.


-Doug
