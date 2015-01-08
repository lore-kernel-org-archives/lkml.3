Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040AbbAHIZR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 03:25:17 -0500
Received: from mga01.intel.com ([192.55.52.88]:55938 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753966AbbAHIZO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 03:25:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,721,1413270000"; 
   d="scan'208";a="658598787"
Date: Thu, 8 Jan 2015 10:25:10 +0200
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Alexandre Courbot <gnurou@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] gpio: support for GPIO forwarding
Message-ID: <20150108082510.GA19346@kuha.fi.intel.com>
References: <1418890998-23811-1-git-send-email-heikki.krogerus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418890998-23811-1-git-send-email-heikki.krogerus@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 18, 2014 at 10:23:18AM +0200, Heikki Krogerus wrote:
> This makes it possible to assign GPIOs at runtime. The
> motivation for it is because of need to forward GPIOs from
> one device to an other. That feature may be useful for
> example with some mfd devices, but initially it is needed
> because on some Intel Braswell based ACPI platforms the GPIO
> resources controlling signals of the USB PHY are given to
> the controller device object for whatever reason, so the
> driver of that controller needs be able to pass them to the
> PHY device somehow.
> 
> So basically this is meant to allow patching of bad (bad
> from Linux kernels point of view) hardware descriptions
> provided by system fw in the drivers.
> 
> Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> ---
> 
> Hi,
> 
> I'm sending this first as a RFC in case you guys have some better
> idea how to solve our problem. I actually already have couple
> platforms where the GPIO resources are given to the "wrong" device
> objects now.
> 
> Originally we were thinking about simply handling our problem with
> hacks to the PHY drivers, basically also checking if the parent has
> GPIOs. That would only work if the controller is always the parent,
> which it's not, but even if it was, it would be too risky. The PHY
> drivers don't know which controller they are attached to, so what is
> to say that the GPIOs aren't really attached to the controller.
> 
> So the safest way to handle our problem is to deal with it in quirks
> in the controller drivers. Solving it by bouncing the GPIOs did not
> feel ideal there doesn't seem to be any other way. The API is copied
> from clkdev (clk_register_clkdev). In the end it's really only one
> function for adding the lookups and one for removing them.
> 
> The way it's implemented is by modifying the current style of handling
> the lookups a little bit. The per device lookup table is basically
> reverted back to the single linked-list format since it seems that
> these lookups may have to be assigned from several sources.
> 
> Thanks,

Gentle ping on this.

-- 
heikki
