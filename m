Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498AbaIPJfM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 05:35:12 -0400
Received: from mga11.intel.com ([192.55.52.93]:61070 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752706AbaIPJfH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 05:35:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,534,1406617200"; 
   d="scan'208";a="600256885"
Date: Tue, 16 Sep 2014 12:34:31 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>, Alan Cox <alan@linux.intel.com>,
        Ning Li <ning.li@intel.com>, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] gpio: Increase ARCH_NR_GPIOs to 512
Message-ID: <20140916093431.GW10854@lahna.fi.intel.com>
References: <1410790185-31101-1-git-send-email-mika.westerberg@linux.intel.com>
 <201409151850.34472.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201409151850.34472.arnd@arndb.de>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2014 at 06:50:34PM +0200, Arnd Bergmann wrote:
> On Monday 15 September 2014, Mika Westerberg wrote:
> > Some newer Intel SoCs, like Braswell already have more than 256 GPIOs
> > available so the default limit is exceeded. Instead of adding more
> > architecture specific gpio.h files with custom ARCH_NR_GPIOs we increase
> > the gpiolib default limit to be twice the current.
> > 
> > Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> > ---
> > Changes to previous version is that now we increase the common limit
> > instead of adding x86 specific gpio.h
> 
> Can you please include the reasoning for this decision in the
> changeset description? I'm sure you have your reasons, but from
> the text above, it sounds like a rather bad idea. What other
> architectures are impacted by this, and what is the kernel size
> cost for it on those architectures?

How about,

Current generic ARCH_NR_GPIOS limit is 256 which starts to be too small
for newer Intel SoCs like Braswell. In order to support GPIO controllers
on these SoCs we increase ARCH_NR_GPIOS to be 512 which should be
sufficient for now.

The kernel size increases a bit with this change. Below is an example of
x86_64 kernel image.

ARCH_NR_GPIOS=256
 text     data    bss     dec      hex    filename
 11476173 1971328 1265664 14713165 e0814d vmlinux

ARCH_NR_GPIOS=512
 text     data    bss     dec      hex    filename
 11476173 1971328 1269760 14717261 e0914d vmlinux

So the BSS size and this the kernel image size increases by 4k.
