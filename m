Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751287AbaBZH3W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 02:29:22 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:46513 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172AbaBZH3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 02:29:19 -0500
MIME-Version: 1.0
In-Reply-To: <20140226181521.e8cecdff21d892ea1f037bff@canb.auug.org.au>
References: <20140226181521.e8cecdff21d892ea1f037bff@canb.auug.org.au>
From: Mike Turquette <mturquette@linaro.org>
Date: Tue, 25 Feb 2014 23:28:58 -0800
Message-ID: <CAPtuhTi=4XewQma4XT_mNmFKOphjE24353RVSOFXas7_0GddAA@mail.gmail.com>
Subject: Re: linux-next: manual merge of the clk tree with the keystone tree
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>,
        Murali Karicheri <m-karicheri2@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 25, 2014 at 11:15 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Mike,
>
> Today's linux-next merge of the clk tree got a conflict in
> arch/arm/boot/dts/keystone-clocks.dtsi between commit 0cfc9ccec2a8 ("ARM:
> dts: keystone: preparatory patch to support K2L and K2E SOCs") from the
> keystone tree and commit 565bbdcd3b91 ("ARM: keystone: dts: fix clkvcp3
> control register address") from the clk tree.
>
> I fixed it up (by adding the following merge fix patch) and can carry the
> fix as necessary (no action is required).
>
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Wed, 26 Feb 2014 18:12:55 +1100
> Subject: [PATCH] ARM: keystone: dts: fix for code movement
>
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>

Looks good to me.

Thanks!
Mike

> ---
>  arch/arm/boot/dts/k2hk-clocks.dtsi | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/arm/boot/dts/k2hk-clocks.dtsi b/arch/arm/boot/dts/k2hk-clocks.dtsi
> index 4eed84feb761..a71aa2996321 100644
> --- a/arch/arm/boot/dts/k2hk-clocks.dtsi
> +++ b/arch/arm/boot/dts/k2hk-clocks.dtsi
> @@ -339,7 +339,7 @@ clocks {
>                 compatible = "ti,keystone,psc-clock";
>                 clocks = <&chipclk13>;
>                 clock-output-names = "vcp-3";
> -               reg = <0x0235000a8 0xb00>, <0x02350060 0x400>;
> +               reg = <0x023500a8 0xb00>, <0x02350060 0x400>;
>                 reg-names = "control", "domain";
>                 domain-id = <24>;
>         };
> --
> 1.9.0
>
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
