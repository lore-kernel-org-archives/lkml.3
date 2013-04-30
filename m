Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752483Ab3D3FGh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 01:06:37 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:38287 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751549Ab3D3FGg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 01:06:36 -0400
Message-ID: <517F5126.5000509@ti.com>
Date: Tue, 30 Apr 2013 10:35:42 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: "Gupta, Pekon" <pekon@ti.com>
CC: <linux-mtd@lists.infradead.org>, <b-cousson@ti.com>, <tony@atomide.com>,
        <linux@arm.linux.org.uk>, avinash philip <avinashphilip@ti.com>,
        <linux-omap@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <gururaja.hebbar@ti.com>, <hvaibhav@ti.com>, <zonque@gmail.com>,
        <jacmet@sunsite.dk>
Subject: Re: [v2, 3/3] ARM: dts: AM33XX: Add NAND flash device tree data to
 am335x-evm
References: <ebfab3e9123b3e50b9a9678c1480191addd86d59.1359007746.git.avinashphilip@ti.com>
In-Reply-To: <ebfab3e9123b3e50b9a9678c1480191addd86d59.1359007746.git.avinashphilip@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 4/29/2013 1:25 PM, Gupta, Pekon wrote:
> From: avinash philip <avinashphilip@ti.com>
> 
> NAND flash connected in am335x-evm on GPMC controller. This patch adds
> device tree node in am3355-evm with GPMC contoller timing for NAND flash
> interface, NAND partition table, ECC scheme, elm handle id.
> 
> Signed-off-by: Philip Avinash <avinashphilip@ti.com>
> Tested-by: Pekon Gupta <pekon@ti.com>
> 
> ---
> arch/arm/boot/dts/am335x-evm.dts |   98 +++++++++++++++++++++++++++++++++++++-
>  1 file changed, 97 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/boot/dts/am335x-evm.dts b/arch/arm/boot/dts/am335x-evm.dts
> index 0423298..1c2fd89 100644
> --- a/arch/arm/boot/dts/am335x-evm.dts
> +++ b/arch/arm/boot/dts/am335x-evm.dts
> @@ -26,7 +26,8 @@
>  
>  	am33xx_pinmux: pinmux@44e10800 {
>  		pinctrl-names = "default";
> -		pinctrl-0 = <&matrix_keypad_s0 &volume_keys_s0>;
> +		pinctrl-0 = <&matrix_keypad_s0 &volume_keys_s0
> +			&nandflash_pins_s0>;

Why add this to the board level fallback (called pinctrl hogs, I think)?
This can be part of nand node you added below so that the pinctrl will
take effect when nand gets probed instead of all the time.

Thanks,
Sekhar
