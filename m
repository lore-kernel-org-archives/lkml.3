Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753578Ab3ISLUB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 07:20:01 -0400
Received: from mail-bk0-f43.google.com ([209.85.214.43]:32850 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032Ab3ISLUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 07:20:00 -0400
Message-ID: <523ADDDC.7010008@gmail.com>
Date: Thu, 19 Sep 2013 13:19:56 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
To: Quentin Armitage <quentin@armitage.org.uk>, linux-kernel@vger.kernel.org
CC: Jason Cooper <jason@lakedaemon.net>
Subject: Re: [PATCH 1/1] Fix address of second XOR engine in Kirkwood SoC
 DT
References: <1379588429.2484.84.camel@samson1.armitage.org.uk>
In-Reply-To: <1379588429.2484.84.camel@samson1.armitage.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/13 13:00, Quentin Armitage wrote:
> There appears to be an error in the second address of the second XOR
> engine in the Kirkwood SoC device tree, which is specified as 0xd0b00
> but should be 0x60b00.
>
> For confirmation of address see
> http://www.marvell.com/embedded-processors/kirkwood/assets/FS_88F6180_9x_6281_OpenSource.pdf table 581 page 658.
> Also see definition of XOR1_HIGH_PHYS_BASE in
> arch/arm/mach-kirkwood/include/mach/kirkwood.h
> #define XOR1_HIGH_PHYS_BASE    (KIRKWOOD_REGS_PHYS_BASE + 0x60B00)
>
> Signed-off-by: Quentin Armitage <quentin@armitage.org.uk>

I double-checked the references, typo and fix are correct.

Reviewed-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>

> ---
>   arch/arm/boot/dts/kirkwood.dtsi | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/arm/boot/dts/kirkwood.dtsi
> b/arch/arm/boot/dts/kirkwood.dtsi
> index cf7aeaf..63d4066 100644
> --- a/arch/arm/boot/dts/kirkwood.dtsi
> +++ b/arch/arm/boot/dts/kirkwood.dtsi
> @@ -167,7 +167,7 @@
>   		xor@60900 {
>   			compatible = "marvell,orion-xor";
>   			reg = <0x60900 0x100
> -			       0xd0B00 0x100>;
> +			       0x60B00 0x100>;
>   			status = "okay";
>   			clocks = <&gate_clk 16>;
>
> ---
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

