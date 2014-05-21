Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751517AbaEUBav (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 21:30:51 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:62179 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807AbaEUBat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 21:30:49 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18NPPAoZbdwhLW+TBdUDG+R1eNc3+m3Wwc=
X-DKIM: OpenDKIM Filter v2.0.1 titan 3209F57B8D3
Date: Tue, 20 May 2014 21:30:27 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: arm@kernel.org, Brian Norris <computersforpeace@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND 2/2] Documentation: add Broadcom STB Level-2
 interrupt controller binding
Message-ID: <20140521013027.GD8664@titan.lakedaemon.net>
References: <1400613229-19049-1-git-send-email-f.fainelli@gmail.com>
 <1400613229-19049-3-git-send-email-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400613229-19049-3-git-send-email-f.fainelli@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2014 at 12:13:49PM -0700, Florian Fainelli wrote:
> This patch adds the Device Tree binding document for the Broadcom
> Set-top-box Level 2 interrupt controller hardware.
> 
> Signed-off-by: Brian Norris <computersforpeace@gmail.com>
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>  .../bindings/interrupt-controller/brcm,l2-intc.txt | 29 ++++++++++++++++++++++
>  1 file changed, 29 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/interrupt-controller/brcm,l2-intc.txt
> 
> diff --git a/Documentation/devicetree/bindings/interrupt-controller/brcm,l2-intc.txt b/Documentation/devicetree/bindings/interrupt-controller/brcm,l2-intc.txt
> new file mode 100644
> index 000000000000..448273a30a11
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/interrupt-controller/brcm,l2-intc.txt
> @@ -0,0 +1,29 @@
> +Broadcom Generic Level 2 Interrupt Controller
> +
> +Required properties:
> +
> +- compatible: should be "brcm,l2-intc"
> +- reg: specifies the base physical address and size of the registers
> +- interrupt-controller: identifies the node as an interrupt controller
> +- #interrupt-cells: specifies the number of cells needed to encode an
> +  interrupt source. Should be 1.
> +- interrupt-parent: specifies the phandle to the parent interrupt controller
> +  this controller is cacaded from
> +- interrupts: specifies the interrupt line in the interrupt-parent irq space
> +  to be used for cascading
> +
> +Optional properties:
> +
> +- brcm,irq-can-wake: If present, this means the L2 controller can be used as a
> +  wakeup source for system suspend/resume.

Do we need a vendor-specific property here?  I'd much prefer to see a
generic implementation.

thx,

Jason.
