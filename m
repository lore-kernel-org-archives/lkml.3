Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755819AbaG3Sy1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 14:54:27 -0400
Received: from us01smtprelay-2.synopsys.com ([198.182.60.111]:59526 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755728AbaG3SyZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 14:54:25 -0400
From: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
To: Kever Yang <kever.yang@rock-chips.com>,
        "heiko@sntech.de" <heiko@sntech.de>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "mporter@linaro.org" <mporter@linaro.org>,
        "kishon@ti.com" <kishon@ti.com>, "balbi@ti.com" <balbi@ti.com>
CC: "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "addy.ke@rock-chips.com" <addy.ke@rock-chips.com>,
        "xjq@rock-chips.com" <xjq@rock-chips.com>,
        "cf@rock-chips.com" <cf@rock-chips.com>,
        "lyz@rock-chips.com" <lyz@rock-chips.com>,
        "wulf@rock-chips.com" <wulf@rock-chips.com>,
        "dianders@chromium.org" <dianders@chromium.org>,
        "olof@lixom.net" <olof@lixom.net>,
        "sonnyrao@chromium.org" <sonnyrao@chromium.org>
Subject: RE: [PATCH 1/4] Documentation: dt-bindings: add dt binding info for
 Rockchip dwc2
Thread-Topic: [PATCH 1/4] Documentation: dt-bindings: add dt binding info
 for Rockchip dwc2
Thread-Index: AQHPq5YSuEfgP7TQWEu9SvGvP0hNhpu49jMg
Date: Wed, 30 Jul 2014 18:53:38 +0000
Message-ID: <A2CA0424C0A6F04399FB9E1CD98E0304844C2F5B@US01WEMBX2.internal.synopsys.com>
References: <963258>
 <1406683873-18194-1-git-send-email-kever.yang@rock-chips.com>
 <1406683873-18194-2-git-send-email-kever.yang@rock-chips.com>
In-Reply-To: <1406683873-18194-2-git-send-email-kever.yang@rock-chips.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.9.64.241]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Kever Yang [mailto:kever.yang@rock-chips.com]
> Sent: Tuesday, July 29, 2014 6:31 PM
> 
> This add necessary dwc2 binding documentation for Rockchip socs:
> rk3066, rk3188 and rk3288
> 
> add dr_mode as optional properties.
> 
> Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
> ---
>  Documentation/devicetree/bindings/usb/dwc2.txt |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/usb/dwc2.txt
> b/Documentation/devicetree/bindings/usb/dwc2.txt
> index aa91034..eb80d7b 100644
> --- a/Documentation/devicetree/bindings/usb/dwc2.txt
> +++ b/Documentation/devicetree/bindings/usb/dwc2.txt
> @@ -4,6 +4,9 @@ Platform DesignWare HS OTG USB 2.0 controller
>  Required properties:
>  - compatible : One of:
>    - brcm,bcm2835-usb: The DWC2 USB controller instance in the BCM2835 SoC.
> +  - rockchip,rk3066-usb: The DWC2 USB controller instance in the rk3066 Soc;
> +  - "rockchip,rk3188-usb","rockchip,rk3066-usb": for rk3188 Soc;
> +  - "rockchip,rk3288-usb","rockchip,rk3066-usb": for rk3288 Soc;
>    - snps,dwc2: A generic DWC2 USB controller with default parameters.

Do you really need three different bindings here? I believe the 
recommended approach is to define one binding for the common case, and
reuse it for similar SOCs. Additional bindings should only be added if
there is some difference in the SOC that requires it.

>  - reg : Should contain 1 register range (address and length)
>  - interrupts : Should contain 1 interrupt
> @@ -15,6 +18,8 @@ Optional properties:
>  - phys: phy provider specifier
>  - phy-names: shall be "usb2-phy"
>  Refer to phy/phy-bindings.txt for generic phy consumer properties
> +- dr_mode: shall be one of "host", "peripheral" and "otg"

I don't see where you use 'dr_mode' in any of the DTS files. Are you
going to add the uses later? And please us a more descriptive name,
such as 'dual-role-mode'.

-- 
Paul

