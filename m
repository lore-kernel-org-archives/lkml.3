Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751118AbbAMFCh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 00:02:37 -0500
Received: from mail-yh0-f52.google.com ([209.85.213.52]:54785 "EHLO
	mail-yh0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969AbbAMFCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 00:02:35 -0500
Date: Mon, 12 Jan 2015 21:02:30 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org, kernel@stlinux.com,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>
Subject: Re: [PATCH v3 03/13] mtd: st_spi_fsm: dt-bindings: Deprecate generic
 compatible string
Message-ID: <20150113050230.GP9759@ld-irv-0074>
References: <1418644760-18773-1-git-send-email-lee.jones@linaro.org>
 <1418644760-18773-4-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418644760-18773-4-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+ devicetree

Please include devicetree@vger.kernel.org whenever you send DT patches
like this.

On Mon, Dec 15, 2014 at 11:59:10AM +0000, Lee Jones wrote:
> This driver now obtains platform information via DT matching, which requires
> a compatible string per platform.  This change introduces the new specific
> strings and deprecates the old generic one.
> 
> We also take out all of the old, unused properties which are no longer
> required.
> 
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  Documentation/devicetree/bindings/mtd/st-fsm.txt | 20 +++++++-------------
>  1 file changed, 7 insertions(+), 13 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/mtd/st-fsm.txt b/Documentation/devicetree/bindings/mtd/st-fsm.txt
> index c248939..4e3a16c 100644
> --- a/Documentation/devicetree/bindings/mtd/st-fsm.txt
> +++ b/Documentation/devicetree/bindings/mtd/st-fsm.txt
> @@ -1,26 +1,20 @@
>  * ST-Microelectronics SPI FSM Serial (NOR) Flash Controller
>  
>  Required properties:
> -  - compatible : Should be "st,spi-fsm"
> +  - compatible : "st,spi-fsm" is now DEPRECATED

See my comments on patch 4.

In light of that, it may make sense to support both, so DTS files could
list:

	compatible = "st,stid127-spi-fsm", "st,spi-fsm";

But I'm not really privy to whatever discussion determined that you
needed to deprecate the current binding. If there really are no users of
the current upstream binding, then maybe your current deprecation plan
can work fine.

> +		 Should be one of;
> +		   "st,stid127-spi-fsm"
> +		   "st,stih407-spi-fsm"
> +		   "st,stih416-spi-fsm"
>    - reg        : Contains register's location and length.
> -  - reg-names  : Should contain the reg names "spi-fsm"
>    - interrupts : The interrupt number
>    - pinctrl-0  : Standard Pinctrl phandle (see: pinctrl/pinctrl-bindings.txt)
> -
> -Optional properties:
> -  - st,syscfg          : Phandle to boot-device system configuration registers
> -  - st,boot-device-reg : Address of the aforementioned boot-device register(s)
> -  - st,boot-device-spi : Expected boot-device value if booted via this device
> +  - st,syscfg  : Phandle to boot-device system configuration registers
>  
>  Example:
>  	spifsm: spifsm@fe902000{
> -	        compatible         = "st,spi-fsm";
> +		compatible         = "st,stih407-spi-fsm";
>  	        reg                =  <0xfe902000 0x1000>;
> -	        reg-names          = "spi-fsm";
>  	        pinctrl-0          = <&pinctrl_fsm>;
>  		st,syscfg	   = <&syscfg_rear>;
> -	        st,boot-device-reg = <0x958>;
> -	        st,boot-device-spi = <0x1a>;
> -		status = "okay";
>  	};
> -

Brian
