Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757384Ab3IMP1O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 11:27:14 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:22088 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755610Ab3IMP1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 11:27:11 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19ySadzymIK1Cid2uQhBnj7
Date: Fri, 13 Sep 2013 08:27:06 -0700
From: Tony Lindgren <tony@atomide.com>
To: Koen Kooi <koen@dominion.thruhere.net>
Cc: linux-kernel@vger.kernel.org, bcousson@baylibre.com,
        rob.herring@calxeda.com, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ijc+devicetree@hellion.org.uk,
        linux@arm.linux.org.uk, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 2/4] ARM: dts: am335x-boneblack: add eMMC DT entry
Message-ID: <20130913152705.GN7189@atomide.com>
References: <1379010935-25943-1-git-send-email-koen@dominion.thruhere.net>
 <1379010935-25943-3-git-send-email-koen@dominion.thruhere.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379010935-25943-3-git-send-email-koen@dominion.thruhere.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Koen Kooi <koen@dominion.thruhere.net> [130912 11:43]:
> The pinmux is specified in am335x-bone-common.dtsi to be reused by the eMMC cape.
> 
> Signed-off-by: Koen Kooi <koen@dominion.thruhere.net>
> ---
>  arch/arm/boot/dts/am335x-bone-common.dtsi | 22 ++++++++++++++++++++++
>  arch/arm/boot/dts/am335x-boneblack.dts    | 14 ++++++++++++++
>  2 files changed, 36 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/am335x-bone-common.dtsi b/arch/arm/boot/dts/am335x-bone-common.dtsi
> index 0d95d54..bc8d1a2 100644
> --- a/arch/arm/boot/dts/am335x-bone-common.dtsi
> +++ b/arch/arm/boot/dts/am335x-bone-common.dtsi
> @@ -113,6 +113,21 @@
>  				0x160 (PIN_INPUT | MUX_MODE7) /* GPIO0_6 */
>  			>;
>  		};
> +
> +		emmc_pins: pinmux_emmc_pins {
> +			pinctrl-single,pins = <
> +				0x80 (PIN_INPUT_PULLUP | MUX_MODE2) /* gpmc_csn1.mmc1_clk, INPUT_PULLUP | MODE2 */
> +				0x84 (PIN_INPUT_PULLUP | MUX_MODE1) /* gpmc_csn2.mmc1_cmd, INPUT_PULLUP | MODE2 */
> +				0x00 (PIN_INPUT_PULLUP | MUX_MODE1) /* gpmc_ad0.mmc1_dat0, INPUT_PULLUP | MODE1 */
> +				0x04 (PIN_INPUT_PULLUP | MUX_MODE1) /* gpmc_ad1.mmc1_dat1, INPUT_PULLUP | MODE1 */
> +				0x08 (PIN_INPUT_PULLUP | MUX_MODE1) /* gpmc_ad2.mmc1_dat2, INPUT_PULLUP | MODE1 */
> +				0x0c (PIN_INPUT_PULLUP | MUX_MODE1) /* gpmc_ad3.mmc1_dat3, INPUT_PULLUP | MODE1 */
> +				0x10 (PIN_INPUT_PULLUP | MUX_MODE1) /* gpmc_ad4.mmc1_dat4, INPUT_PULLUP | MODE1 */
> +				0x14 (PIN_INPUT_PULLUP | MUX_MODE1) /* gpmc_ad5.mmc1_dat5, INPUT_PULLUP | MODE1 */
> +				0x18 (PIN_INPUT_PULLUP | MUX_MODE1) /* gpmc_ad6.mmc1_dat6, INPUT_PULLUP | MODE1 */
> +				0x1c (PIN_INPUT_PULLUP | MUX_MODE1) /* gpmc_ad7.mmc1_dat7, INPUT_PULLUP | MODE1 */
> +			>;
> +		};
>  	};
>  
>  	ocp {

Here you can now use just the defines to make it a bit shorter:

0x80 (PIN_INPUT_PULLUP | MUX_MODE2) /* gpmc_csn1.mmc1_clk */

Regards,

Tony
