Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753808AbaF0L55 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 07:57:57 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:35644 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753759AbaF0L5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 07:57:55 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+ImCJa1XUvt5mInBpfbVQLeCQVUSSUzcA=
X-DKIM: OpenDKIM Filter v2.0.1 titan 6F32959B9D1
Date: Fri, 27 Jun 2014 07:57:42 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Sricharan R <r.sricharan@ti.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        tony@atomide.com, santosh.shilimkar@ti.com, nm@ti.com, rnayak@ti.com,
        linux@arm.linux.org.uk, tglx@linutronix.de, joe@perches.com
Subject: Re: [PATCH V4 15/16] documentation: dt: omap: crossbar: Add
 description for interrupt consumer
Message-ID: <20140627115742.GA23978@titan.lakedaemon.net>
References: <1403766634-18543-1-git-send-email-r.sricharan@ti.com>
 <1403766634-18543-16-git-send-email-r.sricharan@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403766634-18543-16-git-send-email-r.sricharan@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2014 at 12:40:33PM +0530, Sricharan R wrote:
> From: Nishanth Menon <nm@ti.com>
> 
> The current crossbar description does not include the description
> required for the consumer of the crossbar, a.k.a devices whoes events
> pass through the crossbar into the GIC interrupt controller.
> 
> So, provide documentation for the same.
> 
> Signed-off-by: Nishanth Menon <nm@ti.com>
> Signed-off-by: Sricharan R <r.sricharan@ti.com>
> Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> ---
>  .../devicetree/bindings/arm/omap/crossbar.txt      |   17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/arm/omap/crossbar.txt b/Documentation/devicetree/bindings/arm/omap/crossbar.txt
> index 6923531..35356b6 100644
> --- a/Documentation/devicetree/bindings/arm/omap/crossbar.txt
> +++ b/Documentation/devicetree/bindings/arm/omap/crossbar.txt
> @@ -36,3 +36,20 @@ Examples:
>  			ti,irqs-reserved = <0 1 2 3 5 6 131 132 139 140>;
>  			ti,irqs-skip = <10 133 139 140>;
>  		};
> +
> +Consumer:
> +========
> +See Documentation/devicetree/bindings/interrupt-controller/interrupts.txt and
> +Documentation/devicetree/bindings/arm/gic.txt for further details.
> +
> +An interrupt consumer on an SoC using crossbar will use:
> +	interrupts = <GIC_SPI request_number interrupt_level>
> +request number shall be between 0 to that described by
> +"ti,max-crossbar-sources"
> +
> +Example:
> +	device_x@0x4a023000 {
> +		/* Crossbar 8 used */
> +		interrupts = <GIC_SPI 8 IRQ_TYPE_LEVEL_HIGH>;

If you are going to reference MAX_SOURCES in the previous patch to the
docs, then you should use the macro here as well and explain both.  Or,
just use numbers in the docs, and macros in the dtsi files.

If you prefer the latter, just let me know and I'll fixup the other
patch when applying these.  Otherwise, you can just send a v5 of the two
patches affected.

thx,

Jason.
