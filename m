Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209AbaIYSnV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 14:43:21 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:55878 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883AbaIYSnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 14:43:18 -0400
Date: Thu, 25 Sep 2014 11:43:14 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Josh Cartwright <joshc@codeaurora.org>
Cc: Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Kumar Gala <galak@codeaurora.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Randy Dunlap <rdunlap@infradead.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v3 2/3] watchdog: qcom: document device tree bindings
Message-ID: <20140925184314.GC12340@roeck-us.net>
References: <cover.1411667144.git.joshc@codeaurora.org>
 <f49033de078aff9112fb8fa6fa4331e16998edf2.1411667144.git.joshc@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f49033de078aff9112fb8fa6fa4331e16998edf2.1411667144.git.joshc@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2014 at 12:48:52PM -0500, Josh Cartwright wrote:
> The Qualcomm Krait Processor Sub-system (KPSS) contains one or more
> instances of the WDT.  Provide documentation on how to describe these in
> the device tree.
> 
> Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
> ---
>  .../devicetree/bindings/watchdog/qcom-wdt.txt      | 22 ++++++++++++++++++++++
>  1 file changed, 22 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/watchdog/qcom-wdt.txt
> 
> diff --git a/Documentation/devicetree/bindings/watchdog/qcom-wdt.txt b/Documentation/devicetree/bindings/watchdog/qcom-wdt.txt
> new file mode 100644
> index 0000000..c75566e
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/watchdog/qcom-wdt.txt
> @@ -0,0 +1,22 @@
> +Qualcomm Krait Processor Sub-system (KPSS) Watchdog
> +---------------------------------------------------
> +
> +Required properties :
> +- compatible : shall contain only one of the following:
> +
> +			"qcom,kpss-wdt-msm8960"
> +			"qcom,kpss-wdt-apq8064"
> +			"qcom,kpss-wdt-ipq8064"
> +
> +- reg : shall contain base register location and length
> +- clocks : shall contain the input clock
> +- timeout-sec : shall contain the default watchdog timeout in seconds,
> +                if unset, the default timeout is 30 seconds

Hi Josh,

timeout-sec is optional, not mandatory.

Thanks,
Guenter

> +
> +Example:
> +	watchdog@208a038 {
> +		compatible = "qcom,kpss-wdt-ipq8064";
> +		reg = <0x0208a038 0x40>;
> +		clocks = <&sleep_clk>;
> +		timeout-sec = <10>;
> +	};
> -- 
> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
> hosted by The Linux Foundation
> 
