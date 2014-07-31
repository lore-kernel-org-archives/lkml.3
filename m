Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751878AbaGaOY3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 10:24:29 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:42434 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808AbaGaOY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 10:24:27 -0400
Message-ID: <53DA519A.4090905@cogentembedded.com>
Date: Thu, 31 Jul 2014 18:24:26 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Peter Ujfalusi <peter.ujfalusi@ti.com>, nsekhar@ti.com, robh+dt@kernel.org
CC: devicetree@vger.kernel.org, davinci-linux-open-source@linux.davincidsp.com,
        linux@arm.linux.org.uk, pawel.moll@arm.com,
        khilman@deeprootsystems.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 5/6] ARM: DTS: da850-evm: Add node for tlv320aic3106 codec
References: <1406801934-23334-1-git-send-email-peter.ujfalusi@ti.com> <1406801934-23334-6-git-send-email-peter.ujfalusi@ti.com>
In-Reply-To: <1406801934-23334-6-git-send-email-peter.ujfalusi@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 07/31/2014 02:18 PM, Peter Ujfalusi wrote:

> The board uses aic3106 for audio.

> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> ---
>   arch/arm/boot/dts/da850-evm.dts | 14 ++++++++++++++
>   1 file changed, 14 insertions(+)

> diff --git a/arch/arm/boot/dts/da850-evm.dts b/arch/arm/boot/dts/da850-evm.dts
> index 09118c72e83f..b9ef2be0b145 100644
> --- a/arch/arm/boot/dts/da850-evm.dts
> +++ b/arch/arm/boot/dts/da850-evm.dts
> @@ -51,6 +51,20 @@
>   			tps: tps@48 {
>   				reg = <0x48>;
>   			};
> +			tlv320aic3106: tlv320aic3106@1b {

    The "reg" property is <0x18>, why the unit-address part of a name is 
different? Also, the ePAPR standard [1] says:

The name of a node should be somewhat generic, reflecting the function of the 
device and not its precise programming model.

> +				#sound-dai-cells = <0>;
> +				compatible = "ti,tlv320aic3106";
> +				reg = <0x18>;
> +				status = "okay";
> +
> +				/* Regulators */
> +				IOVDD-supply = <&vdcdc2_reg>;
> +				/* Derived from VBAT: Baseboard 3.3V / 1.8V */
> +				AVDD-supply = <&vbat>;
> +				DRVDD-supply = <&vbat>;
> +				DVDD-supply = <&vbat>;
> +			};
> +

[1] http://www.power.org/resources/downloads/Power_ePAPR_APPROVED_v1.0.pdf

WBR, Sergei

