Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719AbaJIJ5x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 05:57:53 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:59588 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751137AbaJIJ5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 05:57:44 -0400
Date: Thu, 9 Oct 2014 10:56:49 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel@stlinux.com" <kernel@stlinux.com>,
        "wim@iguana.be" <wim@iguana.be>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        "linux@roeck-us.net" <linux@roeck-us.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        David Paris <david.paris@st.com>
Subject: Re: [PATCH 3/4] watchdog: st_wdt: Provide binding documentation for
 ST's LPC Watchdog driver
Message-ID: <20141009095649.GC3869@leverpostej>
References: <1412760810-23199-1-git-send-email-lee.jones@linaro.org>
 <1412760810-23199-4-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412760810-23199-4-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 08, 2014 at 10:33:29AM +0100, Lee Jones wrote:
> Cc: devicetree@vger.kernel.org
> Signed-off-by: David Paris <david.paris@st.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  .../devicetree/bindings/watchdog/st-lpc-wdt.txt    | 30 ++++++++++++++++++++++
>  1 file changed, 30 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/watchdog/st-lpc-wdt.txt
> 
> diff --git a/Documentation/devicetree/bindings/watchdog/st-lpc-wdt.txt b/Documentation/devicetree/bindings/watchdog/st-lpc-wdt.txt
> new file mode 100644
> index 0000000..520ce90
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/watchdog/st-lpc-wdt.txt
> @@ -0,0 +1,30 @@
> +STMicroelectronics LPC Watchdog
> +===============================
> +
> +Required properties
> +
> +- compatible 	: Must be one of:
> +			"st,stih407-watchdog"
> +			"st,stih416-watchdog"
> +			"st,stih415-watchdog"
> +			"st,stid127-watchdog"
> +- reg		: LPC registers base address + range

s/range/size/

Please append something like "one entryfor each entry in reg-names".

> +- reg-names	: Register map "base" and "syscfg-en" are compulsory. "type" is
> +		  platform dependent and not required for the STiH407

I don't understand the mention of "type".

Additionally, "syscfg-en" looks to be a portion of another device
(shared system controller?), and probably should be described by
reference.

> +- clock-names 	: Should be "lpc_wdt"
> +- clocks	: Clock used by LPC device
> +- timeout-sec	: Watchdog timeout in seconds
> +- st,syscfg	: Syscfg node used to configure CPU reset type and mask

Does this relate to the syscfg-en entry in the reg proeprty?

> +- st,warm_reset	: If present, reset type will be 'warm'. If not, it will be cold

s/_/-/ in property names.

Why does this need to be in the binding? It seems like a choice rather
than a property of the system.

Mark.

> +
> +Example:
> +	watchdog@fde05000 {
> +		compatible	= "st,stih416-lpc-watchdog";
> +		reg		= <0xfde05000 0x1000> <0x204 0x4>;
> +		reg-names	= "base", "syscfg-en"
> +		clock-names	= "lpc_wdt";
> +		clocks 		= <&clk_s_d3_flexgen CLK_LPC_0>;
> +		timeout-sec	= <600>;
> +		st,syscfg	= <&syscfg_core>;
> +		st,warm_reset;
> +	};
> -- 
> 1.9.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
