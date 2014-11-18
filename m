Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631AbaKRRoZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 12:44:25 -0500
Received: from mail-vc0-f180.google.com ([209.85.220.180]:54811 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753833AbaKRRoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 12:44:23 -0500
MIME-Version: 1.0
In-Reply-To: <1416005574-7756-2-git-send-email-amstan@chromium.org>
References: <1416005574-7756-1-git-send-email-amstan@chromium.org>
	<1416005574-7756-2-git-send-email-amstan@chromium.org>
Date: Tue, 18 Nov 2014 09:44:22 -0800
X-Google-Sender-Auth: makKsVI3JZWLAwUW5LDEXeEx3cw
Message-ID: <CAD=FV=XL7hht32hu5zxXAJ+8BKbQp7aQOP68cCjKtrytGGs8iA@mail.gmail.com>
Subject: Re: [PATCH 1/2] clk: rockchip: add bindings for the mmc clock phases
From: Doug Anderson <dianders@chromium.org>
To: Alexandru M Stan <amstan@chromium.org>
Cc: Heiko Stuebner <heiko@sntech.de>, addy ke <addy.ke@rock-chips.com>,
        Sonny Rao <sonnyrao@chromium.org>,
        Kever Yang <kever.yang@rock-chips.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Mike Turquette <mturquette@linaro.org>,
        Mark yao <mark.yao@rock-chips.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Nov 14, 2014 at 2:52 PM, Alexandru M Stan <amstan@chromium.org> wrote:
> This will be used in a later patch for clock phase tuning.
>
> Suggested-by: Heiko Stuebner <heiko@sntech.de>
> Signed-off-by: Alexandru M Stan <amstan@chromium.org>
> ---
>  include/dt-bindings/clock/rk3288-cru.h | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>
> diff --git a/include/dt-bindings/clock/rk3288-cru.h b/include/dt-bindings/clock/rk3288-cru.h
> index 100a08c..465d0f6 100644
> --- a/include/dt-bindings/clock/rk3288-cru.h
> +++ b/include/dt-bindings/clock/rk3288-cru.h
> @@ -72,6 +72,16 @@
>  #define SCLK_HEVC_CABAC                111
>  #define SCLK_HEVC_CORE         112
>
> +#define SCLK_SDMMC_DRV_PHASE   113
> +#define SCLK_SDIO0_DRV_PHASE   114
> +#define SCLK_SDIO1_DRV_PHASE   115
> +#define SCLK_EMMC_DRV_PHASE    116
> +
> +#define SCLK_SDMMC_SAMPLE_PHASE        117
> +#define SCLK_SDIO0_SAMPLE_PHASE        118
> +#define SCLK_SDIO1_SAMPLE_PHASE        119
> +#define SCLK_EMMC_SAMPLE_PHASE 120
> +

Thinking about Mike T's comment, we might want to actually rename
these defines and just remove the "_PHASE".  These clocks _are_ the
drive and sample clocks.  Sure, they happen to have phases as one of
the attributes, but they aren't "phase clocks".

FYI, the TRM shows these clocks as:

- Into "clkgen" you see cclkin (the *2 clock)
- Out of "clkgen" you see:
  --> "cclk_in" (the non *2 clock)
  --> "cclk_in_drv" (the drive clock, which might be shifted)
  --> "cclk_in_sample" (the sample clock, which might be shifted)

Right now we're not modeling the non-shifted, non *2 clock.  I think
that's OK (otherwise we've got a bunch of old device trees to change,
since the old DTS files passed in the *2 clock as the card clock).


-Doug
