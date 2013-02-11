Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756425Ab3BKMAd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 07:00:33 -0500
Received: from service87.mimecast.com ([91.220.42.44]:39404 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756231Ab3BKMAb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 07:00:31 -0500
Date: Mon, 11 Feb 2013 12:00:26 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Roger Quadros <rogerq@ti.com>
Cc: "tony@atomide.com" <tony@atomide.com>,
        "b-cousson@ti.com" <b-cousson@ti.com>, "balbi@ti.com" <balbi@ti.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "kishon@ti.com" <kishon@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH v2 09/14] mfd: omap-usb-host: Add device tree support
 and binding information
Message-ID: <20130211120026.GD2726@e106331-lin.cambridge.arm.com>
References: <1360252974-7912-1-git-send-email-rogerq@ti.com>
 <1360252974-7912-10-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
In-Reply-To: <1360252974-7912-10-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 11 Feb 2013 12:00:27.0620 (UTC) FILETIME=[61C71A40:01CE084F]
X-MC-Unique: 113021112003002501
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 07, 2013 at 04:02:49PM +0000, Roger Quadros wrote:
> Allows the OMAP HS USB host controller to be specified
> via device tree.
> 
> CC: Samuel Ortiz <sameo@linux.intel.com>
> Signed-off-by: Roger Quadros <rogerq@ti.com>
> ---
>  .../devicetree/bindings/mfd/omap-usb-host.txt      |   80 ++++++++++
>  drivers/mfd/omap-usb-host.c                        |  160 +++++++++++++++++++-
>  2 files changed, 234 insertions(+), 6 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/mfd/omap-usb-host.txt
> 
> diff --git a/Documentation/devicetree/bindings/mfd/omap-usb-host.txt b/Documentation/devicetree/bindings/mfd/omap-usb-host.txt
> new file mode 100644
> index 0000000..b381fa6
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/mfd/omap-usb-host.txt
> @@ -0,0 +1,80 @@
> +OMAP HS USB Host
> +
> +Required properties:
> +
> +- compatible: should be "ti,usbhs-host"
> +- reg: should contain one register range i.e. start and length
> +- ti,hwmods: must contain "usb_host_hs"
> +
> +Optional properties:
> +
> +- num-ports: number of USB ports. Usually this is automatically detected
> +  from the IP's revision register but can be overridden by specifying
> +  this property. A maximum of 3 ports are supported at the moment.
> +
> +- portN-mode: String specifying the port mode for port N, where N can be
> +  from 1 to 3. If the port mode is not specified, that port is treated
> +  as unused. When specified, it must be one of the following.
> +	"ehci-phy",
> +        "ehci-tll",
> +        "ehci-hsic",
> +        "ohci-phy-6pin-datse0",
> +        "ohci-phy-6pin-dpdm",
> +        "ohci-phy-3pin-datse0",
> +        "ohci-phy-4pin-dpdm",
> +        "ohci-tll-6pin-datse0",
> +        "ohci-tll-6pin-dpdm",
> +        "ohci-tll-3pin-datse0",
> +        "ohci-tll-4pin-dpdm",
> +        "ohci-tll-2pin-datse0",
> +        "ohci-tll-2pin-dpdm",
> +

[...]

> +/**
> + * Map 'enum usbhs_omap_port_mode' found in <linux/platform_data/usb-omap.h>
> + * to the device tree binding portN-mode found in
> + * 'Documentation/devicetree/bindings/mfd/omap-usb-host.txt'
> + */
> +static const char *port_modes[] = {
> +	[OMAP_USBHS_PORT_MODE_UNUSED]	= "",
> +	[OMAP_EHCI_PORT_MODE_PHY]	= "ehci-phy",
> +	[OMAP_EHCI_PORT_MODE_TLL]	= "ehci-tll",
> +	[OMAP_EHCI_PORT_MODE_HSIC]	= "ehci-hsic",
> +	[OMAP_OHCI_PORT_MODE_PHY_6PIN_DATSE0]	= "ohci-phy-6pin-datse0",
> +	[OMAP_OHCI_PORT_MODE_PHY_6PIN_DPDM]	= "ohci-phy-6pin-dpdm",
> +	[OMAP_OHCI_PORT_MODE_PHY_3PIN_DATSE0]	= "ohci-phy-3pin-datse0",
> +	[OMAP_OHCI_PORT_MODE_PHY_4PIN_DPDM]	= "ohci-phy-4pin-dpdm",
> +	[OMAP_OHCI_PORT_MODE_TLL_6PIN_DATSE0]	= "ohci-tll-6pin-datse0",
> +	[OMAP_OHCI_PORT_MODE_TLL_6PIN_DPDM]	= "ohci-tll-6pin-dpdm",
> +	[OMAP_OHCI_PORT_MODE_TLL_3PIN_DATSE0]	= "ohci-tll-3pin-datse0",
> +	[OMAP_OHCI_PORT_MODE_TLL_4PIN_DPDM]	= "ohci-tll-4pin-dpdm",
> +	[OMAP_OHCI_PORT_MODE_TLL_2PIN_DATSE0]	= "ohci-tll-2pin-datse0",
> +	[OMAP_OHCI_PORT_MODE_TLL_2PIN_DPDM]	= "ohci-tll-2pin-dpdm",
> +};
> +
> +/**
> + * omap_usbhs_get_dt_port_mode - Get the 'enum usbhs_omap_port_mode'
> + * from the port mode string.
> + * @mode: The port mode string, usually obtained from device tree.
> + *
> + * The function returns the 'enum usbhs_omap_port_mode' that matches the
> + * provided port mode string as per the port_modes table.
> + * If no match is found it returns -ENODEV
> + */
> +static const int omap_usbhs_get_dt_port_mode(const char *mode)
> +{
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(port_modes); i++) {
> +		if (!strcasecmp(mode, port_modes[i]))
> +			return i;
> +	}

Any reason for using strcasecmp rather than strcmp? The binding only specified
lower case versions, and this allows people to write "oHcI-PhY-6PiN-DaTsE0"
with impunity.

Otherwise, this looks fine to me.

Thanks,
Mark.

