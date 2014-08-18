Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751835AbaHRMGN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 08:06:13 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:47893 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751158AbaHRMGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 08:06:11 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/IWLruWsI8zdech2HGzje/AFjNvyZ79HE=
X-DKIM: OpenDKIM Filter v2.0.1 titan 319995C8ABC
Date: Mon, 18 Aug 2014 08:05:45 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Lee Jones <lee.jones@linaro.org>, Rob Herring <robherring2@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, tglx@linutronix.de, devicetree@vger.kernel.org
Subject: Re: [PATCH 3/6] irqchip: irq-st: Add documentation for STi based
 syscfg IRQs
Message-ID: <20140818120545.GQ12769@titan.lakedaemon.net>
References: <1406642744-22589-1-git-send-email-lee.jones@linaro.org>
 <1406642744-22589-4-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406642744-22589-4-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Lee,

Rob, Grant, question for you below:

On Tue, Jul 29, 2014 at 03:05:41PM +0100, Lee Jones wrote:
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  .../interrupt-controller/st,sti-irq-syscfg.txt     | 35 ++++++++++++++++++++++
>  1 file changed, 35 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/interrupt-controller/st,sti-irq-syscfg.txt
> 
> diff --git a/Documentation/devicetree/bindings/interrupt-controller/st,sti-irq-syscfg.txt b/Documentation/devicetree/bindings/interrupt-controller/st,sti-irq-syscfg.txt
> new file mode 100644
> index 0000000..ced6014
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/interrupt-controller/st,sti-irq-syscfg.txt
> @@ -0,0 +1,35 @@
> +STMicroelectronics STi System Configuration Controlled IRQs
> +-----------------------------------------------------------
> +
> +On STi based systems; External, CTI (Core Sight), PMU (Performance Management),
> +and PL310 L2 Cache IRQs are controlled using System Configuration registers.
> +This driver is used to unmask them prior to use.

We don't usually refer to the driver in binding docs as they are
supposed to be OS-agnostic.

> +
> +Required properties:
> +- compatible	: Should be set to one of:
> +			"st,stih415-irq-syscfg"
> +			"st,stih416-irq-syscfg"
> +			"st,stih407-irq-syscfg"
> +			"st,stid127-irq-syscfg"
> +- st,syscfg	: Phandle to Cortex-A9 IRQ system config registers
> +- st,irq-device	: Array of IRQs to enable - should be 2 in length
> +- st,fiq-device	: Array of FIQs to enable - should be 2 in length
> +
> +Optional properties:
> +- st,invert-ext	: External IRQs can be inverted at will.  This property inverts
> +		  these IRQs using bitwise logic.  A number of defines have been
> +		  provided for convenience:
> +			ST_IRQ_SYSCFG_EXT_1_INV
> +			ST_IRQ_SYSCFG_EXT_2_INV
> +			ST_IRQ_SYSCFG_EXT_3_INV
> +Example:

Rob, Grant, should we be mingling implementation details (macros from
include files) with the binding documentation?  It just _seems_ wrong
too me.  But if we agree that the binding docs, the dts files, and their
includes are always kept together, I also don't see the harm...

> +
> +irq-syscfg {
> +	compatible    = "st,stih416-irq-syscfg";
> +	st,syscfg     = <&syscfg_cpu>;
> +	st,irq-device = <ST_IRQ_SYSCFG_PMU_0>,
> +			<ST_IRQ_SYSCFG_PMU_1>;
> +	st,fiq-device = <ST_IRQ_SYSCFG_DISABLED>,
> +			<ST_IRQ_SYSCFG_DISABLED>;
> +	st,invert-ext = <(ST_IRQ_SYSCFG_EXT_1_INV | ST_IRQ_SYSCFG_EXT_3_INV)>;
> +};

thx,

Jason.
