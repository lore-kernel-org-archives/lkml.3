Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751431AbaLPOxG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 09:53:06 -0500
Received: from www.linutronix.de ([62.245.132.108]:50379 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbaLPOxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 09:53:03 -0500
Date: Tue, 16 Dec 2014 15:52:23 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        Mike Turquette <mturquette@linaro.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] ARM: at91: fix irq_pm_install_action WARNING
In-Reply-To: <20141216152041.56ff9b2e@bbrezillon>
Message-ID: <alpine.DEB.2.11.1412161551290.17382@nanos>
References: <1418660152-17185-1-git-send-email-boris.brezillon@free-electrons.com> <2662748.NJbkr6jW7r@vostro.rjw.lan> <3542278.8lcJeXLMFm@vostro.rjw.lan> <20141216100715.57baeb65@bbrezillon> <alpine.DEB.2.11.1412161013570.17382@nanos> <20141216122503.77c5632f@bbrezillon>
 <alpine.DEB.2.11.1412161349420.17382@nanos> <20141216152041.56ff9b2e@bbrezillon>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Dec 2014, Boris Brezillon wrote:
> On Tue, 16 Dec 2014 13:56:26 +0100 (CET)
> Okay, that's what I had in mind, thanks for clarifying this aspect.
> 
> Regarding the DT representation, it should look like this, right ?
> 
> aic: interrupt-controller@fffff000 {
> 	#interrupt-cells = <3>;
> 	compatible = "atmel,at91rm9200-aic";
> 	interrupt-controller;
> 	reg = <0xfffff000 0x200>;
> 	atmel,external-irqs = <29 30 31>;
> 
> 	irq1_demux: irq1-demux {
> 		#interrupt-cells = <1>;
> 		interrupt-controller;
> 	}
> };
> 
> pit: timer@fffffd30 {
> 	compatible = "atmel,at91sam9260-pit";
> 	reg = <0xfffffd30 0xf>;
> 	/* 0 is the id reserved for the PIT */
> 	interrupts-extended = <&irq1_demux 0>;
> 	clocks = <&mck>;
> };
> 
> pmc: pmc@fffffc00 {
> 	compatible = "atmel,at91sam9260-pmc";
> 	reg = <0xfffffc00 0x100>;
> 	/* 1 is the id reserved for the PMC */
> 	interrupts-extended = <&irq1_demux 1>;

Not that I'm a DT expert, but that looks about right.

Thanks,

	tglx
