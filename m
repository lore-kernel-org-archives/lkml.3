Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753027Ab3C1TCW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 15:02:22 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:47363 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300Ab3C1TCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 15:02:21 -0400
Date: Thu, 28 Mar 2013 19:02:08 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Rob Herring <robherring2@gmail.com>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] ARM: irq: Call irqchit_init if no init_irq
	function is specified
Message-ID: <20130328190207.GF3368@n2100.arm.linux.org.uk>
References: <1364463704-13692-1-git-send-email-maxime.ripard@free-electrons.com> <1364463704-13692-2-git-send-email-maxime.ripard@free-electrons.com> <51545832.1050504@gmail.com> <20130328145155.GB3368@n2100.arm.linux.org.uk> <51548E89.9060505@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51548E89.9060505@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 28, 2013 at 01:40:09PM -0500, Rob Herring wrote:
> On 03/28/2013 09:51 AM, Russell King - ARM Linux wrote:
> > On Thu, Mar 28, 2013 at 09:48:18AM -0500, Rob Herring wrote:
> >> On 03/28/2013 04:41 AM, Maxime Ripard wrote:
> >>> +	if (machine_desc->init_irq)
> >>> +		machine_desc->init_irq();
> >>> +	else
> >>> +		irqchip_init();
> >>
> >> There needs to be an empty version defined for !OF.
> > 
> > Better:
> > 
> > #ifdef CONFIG_OF
> > 	if (!machine_desc->init_irq)
> > 		irqchip_init();
> > 	else
> > #endif
> 
> Or the new style:
> 
> 	if (IS_ENABLED(CONFIG_OF) && !machine_desc->init_irq)
> 		irqchip_init();
> 	else
> 
> That needs the empty version, but handles your case.

It shouldn't need the empty version at all - because the compiler should
optimize the "true" case away entirely.
