Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934315AbaE2JVY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 05:21:24 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:39807 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932373AbaE2JVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 05:21:22 -0400
Date: Thu, 29 May 2014 10:21:06 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Harini Katakam <harinik@xilinx.com>
Cc: "wim@iguana.be" <wim@iguana.be>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "rob@landley.net" <rob@landley.net>,
        "michals@xilinx.com" <michals@xilinx.com>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] watchdog: Add Cadence WDT driver
Message-ID: <20140529092106.GC24233@leverpostej>
References: <1401185895-3677-1-git-send-email-harinik@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401185895-3677-1-git-send-email-harinik@xilinx.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2014 at 11:18:14AM +0100, Harini Katakam wrote:
> Add Cadence WDT driver. This is used by Xilinx Zynq.
> 
> Signed-off-by: Harini Katakam <harinik@xilinx.com>
> ---
> 
> Sorry for the delay in sending v2.
> v2 changes:
> - Update IO helpers.
> - Use dev_dbg instead of dev_info where possible.
> - Use watchdog_init_timeout
> - Spinlock for restart register where missing.
> - Change order of probe to move reboot notifier register to the end
> - Remove unecessary comments
> - Do clk_prepare_enabel and clk_disable_unprepare in resume/suspend
>   respectively.
> - There is an input from dts to decide whether internal reset should be
>   enabled or not. When this is enabled, reset happens wutomatically when
>   counter reaches zero. In case this is not enabled, a message is disaplayed
>   to indicate that the watchdog has timed out. Elaborated this message
>   to describe the above.

When is that useful?

[...]

> +       of_property_read_u32(pdev->dev.of_node, "reset", &wdt->rst);

For booleans use an empty property and of_property_read_bool.

[...]

> +static struct of_device_id cdns_wdt_of_match[] = {
> +       { .compatible = "xlnx,zynq-wdt-r1p2", },
> +       { .compatible = "cdns,wdt-r1p2", },

If these can currently be handled identically, why not just have
"cdns,wdt-r1p2" in the driver and in your dts have:

compatible = "xlnx,zynq-wdt-r1p2", "cdns,wdt-r1p2";

If we need to distinguish the two for some reason later we can always
add the "xlnx,zynq-wdt-r1p2" string to the driver.

Cheers,
Mark.
