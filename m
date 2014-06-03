Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557AbaFCK5S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 06:57:18 -0400
Received: from mga09.intel.com ([134.134.136.24]:49808 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751189AbaFCK5Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 06:57:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,964,1392192000"; 
   d="scan'208";a="550794117"
Date: Tue, 3 Jun 2014 13:57:10 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Grygorii Strashko <grygorii.strashko@ti.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        "Zhu, Lejun" <lejun.zhu@linux.intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        jacob.jun.pan@linux.intel.com, bin.yang@intel.com
Subject: Re: [PATCH v4] gpio: Add support for Intel SoC PMIC (Crystal Cove)
Message-ID: <20140603105710.GF1730@lahna.fi.intel.com>
References: <CAAVeFu+F=nHDCpL6Vfmq26QNr74mfRD5p9at_osB3R97v7xBSA@mail.gmail.com>
 <538459E8.6010701@ti.com>
 <20140527084615.GC1801@lahna.fi.intel.com>
 <53847F39.2010503@ti.com>
 <CACRpkdbe1=Yt3UDm9f4ZmZ+K2ZB9nVL+RNr7eU_TbnK-CmNY+A@mail.gmail.com>
 <20140529150058.GB6263@lahna.fi.intel.com>
 <53875A4B.2060604@ti.com>
 <CACRpkdZk9hFUZCoWci15EGFsJ7gOWNyFH13gJjHB9EcQT4ONRQ@mail.gmail.com>
 <20140530082503.GA1645@lahna.fi.intel.com>
 <CACRpkdar8jUuQHg7q5rPmGQ2tdomBgXcPA5OUT-n3iLh5Ca11w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdar8jUuQHg7q5rPmGQ2tdomBgXcPA5OUT-n3iLh5Ca11w@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2014 at 10:10:13AM +0200, Linus Walleij wrote:
> On Fri, May 30, 2014 at 10:25 AM, Mika Westerberg
> <mika.westerberg@linux.intel.com> wrote:
> 
> > I'm thinking that could we solve this so that we call
> > acpi_gpiochip_request_interrupts() at the end of gpiochip_irqchip_add()
> > and convert both pinctrl-baytrail and gpio-lynxpoint to use
> > gpiochip_irqchip_add()?
> 
> Yes that seems like a great way to solve it actually.
> 
> Is someone able to do this refactoring?

I have both Haswell and Baytrail hardware here so I can take a look if I
have time.

> I don't know if you have a case of an ACPI-based GPIO controller
> that is *not* supplying interrupts? Because in that case this
> would even be required for the thing to work, right?

Both Haswell and Baytrail support interrupts but only the later provides
ACPI events as far as I can tell.
