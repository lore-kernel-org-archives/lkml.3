Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570AbaIZJwR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 05:52:17 -0400
Received: from mail-ig0-f173.google.com ([209.85.213.173]:64265 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089AbaIZJwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:52:13 -0400
Date: Fri, 26 Sep 2014 10:51:55 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Rob Herring <robherring2@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, tglx@linutronix.de, devicetree@vger.kernel.org
Subject: Re: [PATCH 3/6] irqchip: irq-st: Add documentation for STi based
 syscfg IRQs
Message-ID: <20140926095155.GD4097@lee--X1>
References: <1406642744-22589-1-git-send-email-lee.jones@linaro.org>
 <1406642744-22589-4-git-send-email-lee.jones@linaro.org>
 <20140818120545.GQ12769@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140818120545.GQ12769@titan.lakedaemon.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Aug 2014, Jason Cooper wrote:

> Hey Lee,
> 
> Rob, Grant, question for you below:
> 
> On Tue, Jul 29, 2014 at 03:05:41PM +0100, Lee Jones wrote:
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > ---
> >  .../interrupt-controller/st,sti-irq-syscfg.txt     | 35 ++++++++++++++++++++++
> >  1 file changed, 35 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/interrupt-controller/st,sti-irq-syscfg.txt
> > 
> > diff --git a/Documentation/devicetree/bindings/interrupt-controller/st,sti-irq-syscfg.txt b/Documentation/devicetree/bindings/interrupt-controller/st,sti-irq-syscfg.txt
> > new file mode 100644
> > index 0000000..ced6014
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/interrupt-controller/st,sti-irq-syscfg.txt
> > @@ -0,0 +1,35 @@
> > +STMicroelectronics STi System Configuration Controlled IRQs
> > +-----------------------------------------------------------
> > +
> > +On STi based systems; External, CTI (Core Sight), PMU (Performance Management),
> > +and PL310 L2 Cache IRQs are controlled using System Configuration registers.
> > +This driver is used to unmask them prior to use.
> 
> We don't usually refer to the driver in binding docs as they are
> supposed to be OS-agnostic.

I beg to differ:

$ git grep -i driver -- Documentation/devicetree/ | wc -l
355

I can understand if I was referencing Linux driver implementation
specifics, but any of the OS's drivers would also be un/masking IRQs
in order to provide this functionality.


> > +Required properties:
> > +- compatible	: Should be set to one of:
> > +			"st,stih415-irq-syscfg"
> > +			"st,stih416-irq-syscfg"
> > +			"st,stih407-irq-syscfg"
> > +			"st,stid127-irq-syscfg"
> > +- st,syscfg	: Phandle to Cortex-A9 IRQ system config registers
> > +- st,irq-device	: Array of IRQs to enable - should be 2 in length
> > +- st,fiq-device	: Array of FIQs to enable - should be 2 in length
> > +
> > +Optional properties:
> > +- st,invert-ext	: External IRQs can be inverted at will.  This property inverts
> > +		  these IRQs using bitwise logic.  A number of defines have been
> > +		  provided for convenience:
> > +			ST_IRQ_SYSCFG_EXT_1_INV
> > +			ST_IRQ_SYSCFG_EXT_2_INV
> > +			ST_IRQ_SYSCFG_EXT_3_INV
> > +Example:
> 
> Rob, Grant, should we be mingling implementation details (macros from
> include files) with the binding documentation?  It just _seems_ wrong
> too me.  But if we agree that the binding docs, the dts files, and their
> includes are always kept together, I also don't see the harm...

IMHO, we should be able to document anything here which appears in the
DTS(I) files.

> > +irq-syscfg {
> > +	compatible    = "st,stih416-irq-syscfg";
> > +	st,syscfg     = <&syscfg_cpu>;
> > +	st,irq-device = <ST_IRQ_SYSCFG_PMU_0>,
> > +			<ST_IRQ_SYSCFG_PMU_1>;
> > +	st,fiq-device = <ST_IRQ_SYSCFG_DISABLED>,
> > +			<ST_IRQ_SYSCFG_DISABLED>;
> > +	st,invert-ext = <(ST_IRQ_SYSCFG_EXT_1_INV | ST_IRQ_SYSCFG_EXT_3_INV)>;
> > +};

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
