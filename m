Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791AbaE0PPN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 11:15:13 -0400
Received: from mga14.intel.com ([192.55.52.115]:17451 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752671AbaE0PO7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 11:14:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,919,1392192000"; 
   d="scan'208";a="538195181"
Date: Tue, 27 May 2014 18:14:53 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Alexandre Courbot <gnurou@gmail.com>,
        "Zhu, Lejun" <lejun.zhu@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        jacob.jun.pan@linux.intel.com, bin.yang@intel.com
Subject: Re: [PATCH v4] gpio: Add support for Intel SoC PMIC (Crystal Cove)
Message-ID: <20140527151453.GB2067@lahna.fi.intel.com>
References: <1400810423-14067-1-git-send-email-lejun.zhu@linux.intel.com>
 <CAAVeFu+F=nHDCpL6Vfmq26QNr74mfRD5p9at_osB3R97v7xBSA@mail.gmail.com>
 <538459E8.6010701@ti.com>
 <20140527084615.GC1801@lahna.fi.intel.com>
 <53847F39.2010503@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53847F39.2010503@ti.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2014 at 03:04:09PM +0300, Grygorii Strashko wrote:
> Hi Mika,
> 
> On 05/27/2014 11:46 AM, Mika Westerberg wrote:
> > On Tue, May 27, 2014 at 12:24:56PM +0300, Grygorii Strashko wrote:
> >>>> +
> >>>> +       if (retval) {
> >>>> +               dev_warn(&pdev->dev, "request irq failed: %d\n", retval);
> >>>> +               goto out;
> >>>> +       }
> >>>> +
> >>>> +       retval = gpiochip_add(&cg->chip);
> >>>> +       if (retval) {
> >>>> +               dev_warn(&pdev->dev, "add gpio chip error: %d\n", retval);
> >>>> +               goto out_free_irq;
> >>>> +       }
> >>
> >> As to my mind, It'll be better to setup IRQ as last probing step and
> >> free it as the first step of driver removing.
> > 
> > When gpiochip_add() is called the chip is exported to outside world. At
> > that point anyone can start requesting GPIOs and setup GPIO based
> > interrupts. How does that work if you setup the IRQ after you call
> > gpiochip_add()?
> > 
> 
> It's difficult for me to imagine case when GPIO will be accessed
> until GPIO driver's probe is finished.

Once you call gpiochip_add() your driver gets registered to the GPIO
subsystem and advertised outside. It doesn't matter whether your probe
function is finished or not.

> Regarding remove()/suspend() routines, It's like an axiom for me:
> - always disable irq
> - always stop all works/threads created by driver
> - do everything else
> (It's proved by dozens hours of debugging).

That's true for remove and suspend, yes but I'm not talking about them.

> Anyway, above is just my opinion :)
> So, It's up to you, because it's your code :)

No it's not, it's Lejun's driver :)
