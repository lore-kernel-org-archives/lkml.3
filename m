Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751472AbaIJD0v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 23:26:51 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:32849 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784AbaIJD0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 23:26:50 -0400
Date: Tue, 9 Sep 2014 20:26:46 -0700
From: Darren Hart <dvhart@infradead.org>
To: "Chen, Alvin" <alvin.chen@intel.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, atull <atull@opensource.altera.com>,
        "Shevchenko, Andriy" <andriy.shevchenko@intel.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "Kweh, Hock Leong" <hock.leong.kweh@intel.com>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        "Westerberg, Mika" <mika.westerberg@intel.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 1/4 v3] GPIO: gpio-dwapb: Enable platform driver binding
 to MFD driver
Message-ID: <20140910032646.GA39541@vmdeb7>
References: <1410286081-16653-1-git-send-email-alvin.chen@intel.com>
 <1410286081-16653-2-git-send-email-alvin.chen@intel.com>
 <D034802C.A7BEE%dvhart@linux.intel.com>
 <4656BEB6164FC34F8171C6538F1A595B2E98854F@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4656BEB6164FC34F8171C6538F1A595B2E98854F@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 12:34:50AM +0000, Chen, Alvin wrote:
> > >@@ -136,7 +136,6 @@ config GPIO_DWAPB
> > > 	tristate "Synopsys DesignWare APB GPIO driver"
> > > 	select GPIO_GENERIC
> > > 	select GENERIC_IRQ_CHIP
> > >-	depends on OF_GPIO
> > 
> > You cover this specific dependencies with inline ifdefs, but you lose the
> > CONFIG_OF depends by dropping it, and there are no such checks in the probe
> > routine. Assumptions of OF are not limited to probe in this driver.
> > 
> > While I would like to see this assumption properly abstracted, the most
> > expedient/immediate fix is probably to add a depends on OF above.
> 
> Andriy, how do you think? 
> 
> How about 
> depends on OF_GPIO || MFD_GPIO_DWAPB, or
> depends on OF_GPIO || MFD_INTEL_QUARK_I2C_GPIO?
> 

Upon closer inspection, I think my concern is invalid. the OF header already
tests for CONFIG_OF and provides no-op / -ENOSYS (tsk tsk) alternatives. So long
as you can compile with "#CONFIG_OF is not set" as it is, then I withdraw my
comment.

Sorry for the noise.

-- 
Darren Hart
Intel Open Source Technology Center
