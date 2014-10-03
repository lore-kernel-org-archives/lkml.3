Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787AbaJCVVK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 17:21:10 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:36173 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509AbaJCVVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:21:05 -0400
MIME-Version: 1.0
In-Reply-To: <1411900693-30484-6-git-send-email-caesar.wang@rock-chips.com>
References: <1411900693-30484-1-git-send-email-caesar.wang@rock-chips.com>
	<1411900693-30484-6-git-send-email-caesar.wang@rock-chips.com>
Date: Fri, 3 Oct 2014 14:21:03 -0700
X-Google-Sender-Auth: CEknwtV-2u3iE0jT9ffdXPJnF7M
Message-ID: <CAD=FV=V6c1tGxxTTDyExRkW0fqFVY6v2OxJauoJ_xwZdXX0Tmg@mail.gmail.com>
Subject: Re: [PATCH v7 5/5] ARM: dts: enable Thermal on rk3288-evb board
From: Doug Anderson <dianders@chromium.org>
To: Caesar Wang <caesar.wang@rock-chips.com>
Cc: =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <edubezval@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, zyf <zyf@rock-chips.com>,
        linux-rockchip@lists.infradead.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Eddie Cai <cf@rock-chips.com>, Derek Basehore <dbasehore@chromium.org>,
        Tao Huang <huangtao@rock-chips.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Caesar,

On Sun, Sep 28, 2014 at 3:38 AM, Caesar Wang <caesar.wang@rock-chips.com> wrote:
> when a thermal shutdown at 125C.Via GPIO give PMIC,
> Reset the entire chip.
>
> Signed-off-by: Caesar Wang <caesar.wang@rock-chips.com>
> ---
>  arch/arm/boot/dts/rk3288-evb.dtsi | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/arch/arm/boot/dts/rk3288-evb.dtsi b/arch/arm/boot/dts/rk3288-evb.dtsi
> index 2964370..a6872aa 100644
> --- a/arch/arm/boot/dts/rk3288-evb.dtsi
> +++ b/arch/arm/boot/dts/rk3288-evb.dtsi
> @@ -101,6 +101,11 @@
>         status = "okay";
>  };
>
> +&tsadc {
> +       reset-gpios = <&gpio0 10 GPIO_ACTIVE_HIGH>;

I don't see "reset-gpios" mentioned in the bindings or the code.  I
think you can just remove this, right?

> +       status = "okay";
> +};
> +
>  &pinctrl {
>         buttons {
>                 pwrbtn: pwrbtn {
> --
> 1.9.1
>
>
