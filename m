Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751887Ab3LKQEs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 11:04:48 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:14197 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945Ab3LKQEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 11:04:46 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 24.7.12.101
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/ynxxR82+x5NEX91ejVAnS
Date: Wed, 11 Dec 2013 08:04:40 -0800
From: Tony Lindgren <tony@atomide.com>
To: Nishanth Menon <nm@ti.com>
Cc: devicetree@vger.kernel.org, linux-omap@vger.kernel.org,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        =?utf-8?Q?Beno=C3=AEt?= Cousson <bcousson@baylibre.com>
Subject: Re: [PATCH 1/2] net: smc91x: Read hardware behavior flags from
 device tree
Message-ID: <20131211160440.GA13171@atomide.com>
References: <1386757305-12545-1-git-send-email-nm@ti.com>
 <1386757305-12545-2-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386757305-12545-2-git-send-email-nm@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Nishanth Menon <nm@ti.com> [131211 02:23]:
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/smsc91x.txt
> @@ -0,0 +1,45 @@
> +* Smart Mixed-Signal Connectivity (SMSC) LAN91c94/91c111 Controller
> +
> +Required properties:
> +- compatible : Should be one of:
> +	"smsc,lan91c94"
> +	"smsc,lan91c111"
> +- reg : Address and length of the io space for SMSC LAN
> +- interrupts : Should contain SMSC LAN interrupt line
> +- interrupt-parent : Should be the phandle for the interrupt controller
> +  that services interrupts for this device
> +
> +Optional properties:
> +- reg-shift : Specify the quantity to shift the register offsets by
> +- reg-io-width : Specify the size (in bytes) of the IO accesses that
> +  should be performed on the device.  Valid value for SMSC LAN is
> +  1, 2 or 4.

I posted a minimal regression fix for this a few weeks ago that we
should merge to the v3.13-rc cycle:

http://www.spinics.net/lists/netdev/msg258913.html

Care to ack that one? Then if that works for you, maybe rebase these on
that one for the upcoming merge window?

Note that for the -rc cycle we don't need these extra properties as we
can get the interrupts from the struct resource after fix
4a43d686fe336c (of/irq: Pass trigger type in IRQ resource flags)
got merged.

Regards,

Tony
