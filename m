Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754376AbaCLNQY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 09:16:24 -0400
Received: from mail-ig0-f170.google.com ([209.85.213.170]:47583 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754364AbaCLNQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 09:16:21 -0400
Message-ID: <53205E23.8030905@ieee.org>
Date: Wed, 12 Mar 2014 08:16:19 -0500
From: Alex Elder <elder@ieee.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Matt Porter <mporter@linaro.org>, Alex Elder <elder@linaro.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
CC: Mark Brown <broonie@kernel.org>, Christian Daudt <bcm@fixthebug.org>,
        Devicetree List <devicetree@vger.kernel.org>,
        bcm-kernel-feedback-list@broadcom.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: dts: bcm28155-ap: leave camldo1 on to fix reboot
References: <1394630079-12063-1-git-send-email-mporter@linaro.org>
In-Reply-To: <1394630079-12063-1-git-send-email-mporter@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/2014 08:14 AM, Matt Porter wrote:
> The BCM28155-AP board has a bootloader that expects the camldo1
> regulator to be enabled on entry. Currently, the camldo1 regulator
> is disabled when no longer in use as is the case during a reboot /
> warm reset. This causes the early bootloader to hang upon entry. Add
> regulator-always-on to the camldo1 constraint to fix reboot.
> 
> Reported-by: Alex Elder <elder@linaro.org>
> Signed-off-by: Matt Porter <mporter@linaro.org>

Tested-by: Alex Elder <elder@linaro.org>

> ---
> [Depends on BCM59056 regulator series dts support:
>  http://www.gossamer-threads.com/lists/linux/kernel/1885489]
> 
>  arch/arm/boot/dts/bcm28155-ap.dts | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm/boot/dts/bcm28155-ap.dts b/arch/arm/boot/dts/bcm28155-ap.dts
> index 99ff0c1..cc1303c 100644
> --- a/arch/arm/boot/dts/bcm28155-ap.dts
> +++ b/arch/arm/boot/dts/bcm28155-ap.dts
> @@ -94,6 +94,7 @@
>  		camldo1_reg: camldo1 {
>  			regulator-min-microvolt = <3300000>;
>  			regulator-max-microvolt = <3300000>;
> +			regulator-always-on;
>  		};
>  
>  		sdldo_reg: sdldo {
> 

