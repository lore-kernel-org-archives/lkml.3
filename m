Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325Ab3AYKen (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 05:34:43 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:54052 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754825Ab3AYKej (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 05:34:39 -0500
Message-ID: <51025FAE.3060503@ti.com>
Date: Fri, 25 Jan 2013 16:04:22 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Mrugesh Katepallewar <mrugesh.mk@ti.com>
CC: <devicetree-discuss@lists.ozlabs.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-doc@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <grant.likely@secretlab.ca>,
        <rob.herring@calxeda.com>, <rob@landley.net>, <hs@denx.de>
Subject: Re: [PATCH] ARM: davinci: da850: add RTC driver DT entries
References: <1359094430-14724-1-git-send-email-mrugesh.mk@ti.com>
In-Reply-To: <1359094430-14724-1-git-send-email-mrugesh.mk@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/25/2013 11:43 AM, Mrugesh Katepallewar wrote:
> Add RTC DT entries in da850 dts file.
> 
> Signed-off-by: Mrugesh Katepallewar <mrugesh.mk@ti.com>
> ---
> Applies on top of v3.8-rc4 of linus tree.
> 
> Tested on da850-evm device.
> 
> Test Procedure:
> date [YYYY.]MM.DD-hh:mm[:ss]
> hwclock -w
> reset board and check system time.
> 
> :100644 100644 37dc5a3... b16efd4... M	arch/arm/boot/dts/da850-evm.dts
> :100644 100644 640ab75... a8eb1b1... M	arch/arm/boot/dts/da850.dtsi
>  arch/arm/boot/dts/da850-evm.dts |    3 +++
>  arch/arm/boot/dts/da850.dtsi    |    8 ++++++++
>  2 files changed, 11 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/da850-evm.dts b/arch/arm/boot/dts/da850-evm.dts
> index 37dc5a3..b16efd4 100644
> --- a/arch/arm/boot/dts/da850-evm.dts
> +++ b/arch/arm/boot/dts/da850-evm.dts
> @@ -24,5 +24,8 @@
>  		serial2: serial@1d0d000 {
>  			status = "okay";
>  		};
> +		rtc@1c23000 {
> +			status = "okay";
> +		};
>  	};
>  };
> diff --git a/arch/arm/boot/dts/da850.dtsi b/arch/arm/boot/dts/da850.dtsi
> index 640ab75..a8eb1b1 100644
> --- a/arch/arm/boot/dts/da850.dtsi
> +++ b/arch/arm/boot/dts/da850.dtsi
> @@ -56,5 +56,13 @@
>  			interrupt-parent = <&intc>;
>  			status = "disabled";
>  		};
> +		rtc@1c23000 {
> +			compatible = "ti,da830-rtc";
> +			reg = <0x23000 0x1000>;
> +			interrupts = <19
> +				      19>;

Why two interrupts of the same number? If there is only one interrupt
line then only one should be specified, no?

Thanks,
Sekhar
