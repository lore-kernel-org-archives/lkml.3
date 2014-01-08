Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755750AbaAHJ5a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 04:57:30 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:44242 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755121AbaAHJ52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 04:57:28 -0500
Date: Wed, 8 Jan 2014 09:56:52 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Roger Quadros <rogerq@ti.com>
Cc: "bcousson@baylibre.com" <bcousson@baylibre.com>,
        "tony@atomide.com" <tony@atomide.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, "arnd@arndb.de" <arnd@arndb.de>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "balbi@ti.com" <balbi@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v4 1/5] mfd: omap-usb-host: Update DT clock binding
 information
Message-ID: <20140108095652.GD6701@e106331-lin.cambridge.arm.com>
References: <1389161742-10533-1-git-send-email-rogerq@ti.com>
 <1389161742-10533-2-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389161742-10533-2-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 08, 2014 at 06:15:38AM +0000, Roger Quadros wrote:
> The omap-usb-host driver expects the 60MHz functional clock
> of the USB host module to be named as "init_60m_fclk".
> Add this information in the DT binding document.
> 
> CC: Lee Jones <lee.jones@linaro.org>
> CC: Samuel Ortiz <sameo@linux.intel.com>
> Signed-off-by: Roger Quadros <rogerq@ti.com>
> ---
>  Documentation/devicetree/bindings/mfd/omap-usb-host.txt | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/mfd/omap-usb-host.txt b/Documentation/devicetree/bindings/mfd/omap-usb-host.txt
> index b381fa6..5635202 100644
> --- a/Documentation/devicetree/bindings/mfd/omap-usb-host.txt
> +++ b/Documentation/devicetree/bindings/mfd/omap-usb-host.txt
> @@ -32,6 +32,10 @@ Optional properties:
>  - single-ulpi-bypass: Must be present if the controller contains a single
>    ULPI bypass control bit. e.g. OMAP3 silicon <= ES2.1
>  
> +- clocks: phandle to 60MHz functional clock to the USB Host module.
> +
> +- clock-names: must be "init_60m_fclk"
> +

Nit: clocks aren't just phandles, there's a clock-specifier too.

Also, it would be nicer if clocks was defined in terms of clock-names,
as it makes the relationship between clocks and clock-names clear, and
makes it easier to extend the list in future. Something like:

- clocks: a list of phandles + clock-specifiers, one for each entry in
  clock-names

- clock-names: should include:
  * "init_60m_fclk" - the 60MHz functional clock to the USB host module.

Thanks,
Mark.
