Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624AbaGaXom (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 19:44:42 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:64446 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977AbaGaXok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 19:44:40 -0400
MIME-Version: 1.0
In-Reply-To: <1406823200-20911-3-git-send-email-dianders@chromium.org>
References: <1406823200-20911-1-git-send-email-dianders@chromium.org>
	<1406823200-20911-3-git-send-email-dianders@chromium.org>
Date: Thu, 31 Jul 2014 16:44:39 -0700
X-Google-Sender-Auth: d4Hnmxkfa6y_8Im4EBMtJ737QZo
Message-ID: <CAD=FV=UcJD08wUB7kJH4DusJEZ+xdH=L-zig5DGZrUgu9HYbmA@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] ARM: dts: Enable emmc and sdmmc on the rk3288-evb boards
From: Doug Anderson <dianders@chromium.org>
To: Heiko Stuebner <heiko@sntech.de>, Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>, Chris Ball <chris@printf.net>,
        Ulf Hansson <ulf.hansson@linaro.org>
Cc: Addy Ke <addy.ke@rock-chips.com>, Kever Yang <kever.yang@rock-chips.com>,
        Sonny Rao <sonnyrao@chromium.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Doug Anderson <dianders@chromium.org>,
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

On Thu, Jul 31, 2014 at 9:13 AM, Doug Anderson <dianders@chromium.org> wrote:
> This adds support for the sdmmc and emmc ports on the rk3288 using the
> currently posted driver from Addy at:
>   https://patchwork.kernel.org/patch/4653631/
>
> This enables basic SD and eMMC support.  Things are not yet running at
> the fastest speed and we don't have the regulators specified, but we
> can at least use the eMMC and SD cards now.
>
> A few notes:
> * This is not baesd on Jaehoon's patch series removing the slot node,
>   but it does use new syntax like putting the bus width at the top
>   level and using the new cap-mmc-highspeed / cap-sd-highspeed.  A
>   future patch will modify this one to remove the slot node.
>
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> ---
> Changes in v2:
> - Squashed in the DDR50 mode since Addy spun his patch.
> - New patchwork link for Addy's patch
>
>  arch/arm/boot/dts/rk3288-evb.dtsi | 33 +++++++++++++++++++++++++++++++++
>  1 file changed, 33 insertions(+)
>
> diff --git a/arch/arm/boot/dts/rk3288-evb.dtsi b/arch/arm/boot/dts/rk3288-evb.dtsi
> index 749e20d..ec580fa 100644
> --- a/arch/arm/boot/dts/rk3288-evb.dtsi
> +++ b/arch/arm/boot/dts/rk3288-evb.dtsi
> @@ -37,6 +37,39 @@
>         };
>  };
>
> +&emmc {
> +       broken-cd;
> +       bus-width = <8>;
> +       cap-mmc-highspeed;
> +       mmc-ddr-1_8v;

Strangely DDR mode started failing all of a sudden for me.  Even going
back to old git hashes made things fail.  ...I'd be curious to know if
DDR mode is working for others.

-Doug
