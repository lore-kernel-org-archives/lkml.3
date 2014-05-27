Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752060AbaE0Iq1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 04:46:27 -0400
Received: from mga09.intel.com ([134.134.136.24]:65533 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751202AbaE0IqZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 04:46:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,917,1392192000"; 
   d="scan'208";a="547002770"
Date: Tue, 27 May 2014 11:46:15 +0300
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
Message-ID: <20140527084615.GC1801@lahna.fi.intel.com>
References: <1400810423-14067-1-git-send-email-lejun.zhu@linux.intel.com>
 <CAAVeFu+F=nHDCpL6Vfmq26QNr74mfRD5p9at_osB3R97v7xBSA@mail.gmail.com>
 <538459E8.6010701@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <538459E8.6010701@ti.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2014 at 12:24:56PM +0300, Grygorii Strashko wrote:
> >> +
> >> +       if (retval) {
> >> +               dev_warn(&pdev->dev, "request irq failed: %d\n", retval);
> >> +               goto out;
> >> +       }
> >> +
> >> +       retval = gpiochip_add(&cg->chip);
> >> +       if (retval) {
> >> +               dev_warn(&pdev->dev, "add gpio chip error: %d\n", retval);
> >> +               goto out_free_irq;
> >> +       }
> 
> As to my mind, It'll be better to setup IRQ as last probing step and
> free it as the first step of driver removing.

When gpiochip_add() is called the chip is exported to outside world. At
that point anyone can start requesting GPIOs and setup GPIO based
interrupts. How does that work if you setup the IRQ after you call
gpiochip_add()?
