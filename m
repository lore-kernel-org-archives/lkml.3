Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675AbaHDTi2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 15:38:28 -0400
Received: from gloria.sntech.de ([95.129.55.99]:36687 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752227AbaHDTi0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 15:38:26 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: mark yao <yzq@rock-chips.com>
Cc: Rob Clark <robdclark@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>, David Airlie <airlied@linux.ie>,
        Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Rom Lemarchand <romlem@google.com>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-api@vger.kernel.org,
        olof@lixom.net, djkurtz@chromium.org, xjq@rock-chips.com,
        kfx@rock-chips.com, cym@rock-chips.com, cf@rock-chips.com,
        zyw@rock-chips.com, zwl@rock-chips.com, xxm@rock-chips.com,
        huangtao@rock-chips.com, kever.yang@rock-chips.com,
        zhangqing@rock-chips.com, yxj@rock-chips.com, wxt@rock-chips.com,
        xw@rock-chips.com
Subject: Re: [PATCH 8/9] Add devicetree bindings for Rockchip Soc EDP
Date: Mon, 04 Aug 2014 21:39:34 +0200
Message-ID: <4758549.OE3inCP7ZI@diego>
User-Agent: KMail/4.11.5 (Linux/3.13-1-amd64; KDE/4.11.3; x86_64; ; )
In-Reply-To: <1407128159-1930-1-git-send-email-yzq@rock-chips.com>
References: <1407127274-1356-1-git-send-email-mark.yao@rock-chips.com> <1407128159-1930-1-git-send-email-yzq@rock-chips.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 4. August 2014, 12:55:59 schrieb mark yao:
> Signed-off-by: mark yao <yzq@rock-chips.com>
> ---
>  .../devicetree/bindings/video/rockchip-panel.txt   |   34
> ++++++++++++++++++++ 1 file changed, 34 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/video/rockchip-panel.txt
> b/Documentation/devicetree/bindings/video/rockchip-panel.txt index
> f599806..f6d80f6 100644
> --- a/Documentation/devicetree/bindings/video/rockchip-panel.txt
> +++ b/Documentation/devicetree/bindings/video/rockchip-panel.txt
> @@ -80,3 +80,37 @@ Example:
>  		rockchip,data-width = <24>;
>  		rockchip,panel = <&panel>;
>  	};
> +
> +Rockchip RK3288 EDP interface
> +================================
> +Required properties:
> +-compatible: "rockchip,rk3288-edp";
> +
> +- reg: physical base address of the controller and length
> +- clocks: from common clock binding: handle to dp clock.
> +	of memory mapped region.
> +- clock-names: from common clock binding:
> +	Required elements: "clk_edp"
> +			"clk_edp_24m"
> +			"clk_edp_24m_parent"
> +			"pclk_edp"
> +- rockchip,grf: this soc should set GRF regs, so need get grf here.
> +- resets: Must contain an entry for each entry in reset-names.
> +	See ../reset/reset.txt for details.
> +- reset-names: Must include the following entries:
> +  - edp
> +- rockchip,panel: required a panel node
> +
> +Example:
> +	edp: edp@ff970000 {
> +		compatible = "rockchip,rk3288-edp";
> +                reg = <0xff970000 0x4000>;
> +                interrupts = <GIC_SPI 98 IRQ_TYPE_LEVEL_HIGH>;
> +                clocks = <&cru SCLK_EDP>, <&cru SCLK_EDP_24M>, <&cru
> PCLK_EDP_CTRL>, <&xin24m>; +                clock-names = "clk_edp",
> "clk_edp_24m", "pclk_edp", "clk_edp_24m_parent"; +

clk_epd_24m_parent is not part of the hardware, so instead of referencing the 
target-parent as part of the device clocks, the new
	"clk: Support for clock parents and rates assigned from device tree"
should be used for setting the target parent - so the re-parenting code should 
also move out of the driver.

This commit [0] is part of the clk-pull request and thus will most likely be 
part of 3.17.


Heiko

[0] 
http://git.linaro.org/people/mike.turquette/linux.git/commitdiff/86be408bfbd846fab3c4ac21d6f9298bd2e4b790?hp=09575693a2511b5ddae0105546e0d9cefc936e34



> +                rockchip,grf = <&grf>;
> +                resets = <&cru 111>;
> +                reset-names = "edp";
> +		rockchip,panel = <&panel>;
> +	};

