Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205AbaBCRLB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 12:11:01 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:58455 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751134AbaBCRK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 12:10:58 -0500
Date: Mon, 3 Feb 2014 17:10:53 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Andrew Chew <achew@nvidia.com>
Cc: "robh+dt@kernel.org" <robh+dt@kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "rob@landley.net" <rob@landley.net>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "abrestic@chromium.org" <abrestic@chromium.org>,
        "dgreid@chromium.org" <dgreid@chromium.org>,
        "katierh@chromium.org" <katierh@chromium.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1] ARM: tegra: add nvidia,wdt-timer-id optional
 property
Message-ID: <20140203171053.GA28338@e106331-lin.cambridge.arm.com>
References: <1391204811-6293-1-git-send-email-achew@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391204811-6293-1-git-send-email-achew@nvidia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 31, 2014 at 09:46:51PM +0000, Andrew Chew wrote:
> This optional property can be used to specify which timers are to be used
> for hardware watchdog timeouts (via a tegra wdt driver).

Is there any reason that a particular timer should be used?

This shouldn't even mention the driver, as the binding should describe
the HW, not how it's used by Linux at the moment.

> 
> Signed-off-by: Andrew Chew <achew@nvidia.com>
> ---
>  Documentation/devicetree/bindings/timer/nvidia,tegra30-timer.txt | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/timer/nvidia,tegra30-timer.txt b/Documentation/devicetree/bindings/timer/nvidia,tegra30-timer.txt
> index b5082a1..e87fa70 100644
> --- a/Documentation/devicetree/bindings/timer/nvidia,tegra30-timer.txt
> +++ b/Documentation/devicetree/bindings/timer/nvidia,tegra30-timer.txt
> @@ -13,6 +13,13 @@ Required properties:
>  - clocks : Must contain one entry, for the module clock.
>    See ../clocks/clock-bindings.txt for details.
>  
> +Optional properties:
> +
> +- nvidia,wdt-timer-id: A list of timer IDs to be used for watchdogs.
> +    Watchdog 0 will be assigned to the first timer listed, watchdog 1 will
> +    be assigned to the second timer listed, etc. up to the number of watchdogs
> +    available.

This sounds like a description of what software should do. Is there any
reason this order is important?

Also, it feels odd for the proerty name to be singular given it's a
list...

Thanks,
Mark.
