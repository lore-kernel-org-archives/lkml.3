Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755221AbaG3QHK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 12:07:10 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:44898 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754630AbaG3QHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 12:07:07 -0400
MIME-Version: 1.0
In-Reply-To: <1406676273-20701-3-git-send-email-dianders@chromium.org>
References: <1406676273-20701-1-git-send-email-dianders@chromium.org>
	<1406676273-20701-3-git-send-email-dianders@chromium.org>
Date: Wed, 30 Jul 2014 09:07:06 -0700
X-Google-Sender-Auth: QaOg81Sgbm6AtI4XtAXsHXjUkGw
Message-ID: <CAD=FV=WXmaForADQGCS0zQ--aFguANSfgyg=6tq6_D0mfmKjEA@mail.gmail.com>
Subject: Re: [PATCH 2/3] ARM: dts: add rk3288 ehci usb devices
From: Doug Anderson <dianders@chromium.org>
To: Heiko Stuebner <heiko@sntech.de>, Kever Yang <kever.yang@rock-chips.com>
Cc: Sonny Rao <sonnyrao@chromium.org>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Doug Anderson <dianders@chromium.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jul 29, 2014 at 4:24 PM, Doug Anderson <dianders@chromium.org> wrote:
> rk3288 has two kind of usb controller; this adds the ehci variant for
> host0 and hsic.
>
> At the moment we don't add any phys for these controllers, but the
> default settings seem to work OK.
>
> There is a hardware problem in ohci controller which make it
> unavailable and host0 controller can only support high-speed devices.
>
> Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> ---
>  arch/arm/boot/dts/rk3288.dtsi | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
>
> diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
> index 3ef8951..0bb4480 100644
> --- a/arch/arm/boot/dts/rk3288.dtsi
> +++ b/arch/arm/boot/dts/rk3288.dtsi
> @@ -251,6 +251,26 @@
>                 status = "disabled";
>         };
>
> +       usb_host0_ehci: ehci@ff500000 {

According to sergei.shtylyov@cogentembedded.com in another thread,
this should be "usb@ff500000".

I will fix (and the hsic one) this when I spin the series shortly.

-Doug
