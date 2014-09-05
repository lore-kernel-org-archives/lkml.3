Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755724AbaIEP2L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 11:28:11 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:59098 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123AbaIEP2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 11:28:08 -0400
Date: Fri, 5 Sep 2014 08:27:58 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, wim@iguana.be, linux-watchdog@vger.kernel.org,
        David Paris <david.paris@st.com>
Subject: Re: [PATCH 3/4] watchdog: st_wdt: Provide binding documentation for
 ST's LPC Watchdog driver
Message-ID: <20140905152758.GA10670@roeck-us.net>
References: <1409841592-18890-1-git-send-email-lee.jones@linaro.org>
 <1409841592-18890-5-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409841592-18890-5-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 04, 2014 at 03:39:51PM +0100, Lee Jones wrote:
> Signed-off-by: David Paris <david.paris@st.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

You might want to copy the devicetree mailing list for bindings approval.

> ---
>  .../devicetree/bindings/watchdog/st-lpc-wdt.txt    | 27 ++++++++++++++++++++++
>  1 file changed, 27 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/watchdog/st-lpc-wdt.txt
> 
> diff --git a/Documentation/devicetree/bindings/watchdog/st-lpc-wdt.txt b/Documentation/devicetree/bindings/watchdog/st-lpc-wdt.txt
> new file mode 100644
> index 0000000..f0e57ba
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/watchdog/st-lpc-wdt.txt
> @@ -0,0 +1,27 @@
> +STMicroelectronics LPC Watchdog
> +===============================
> +
> +Required properties
> +
> +- compatible 	: "st,<soc>-watchdog"

Is this acceptable ? I thought the supported bindings have to be listed
explicitly.

> +- reg		: LPC registers base address + range
> +- reg-names	: Register map "base" and "syscfg-en" are compulsory "type" is

'.' after compulsory ?

> +		  platform dependent and not required for the STiH407.
> +- clock-names 	: Should be "lpc_wdt"
> +- clocks	: Clock used by LPC device
> +- timeout-sec	: Qatchdog timeout in seconds

Watchdog

> +- st,syscfg	: Syscfg node used to configure cpu reset type and mask
> +- st,warm_reset	: If present, reset type will be 'warm'. If not, it will be cold

s/cold/cold./ ?

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
> +

Empty line at the end results in a whitespace error when applying.

Guenter
