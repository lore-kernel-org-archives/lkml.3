Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932310AbaIIJqv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 05:46:51 -0400
Received: from mga01.intel.com ([192.55.52.88]:55968 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755007AbaIIJqt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 05:46:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,491,1406617200"; 
   d="scan'208";a="476288433"
Date: Tue, 9 Sep 2014 12:46:44 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Alexandre Courbot <gnurou@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Ning Li <ning.li@intel.com>,
        Alan Cox <alan@linux.intel.com>, Mark Brown <broonie@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
Subject: Re: [PATCH 1/2] x86, gpio: Increase ARCH_NR_GPIOs to 512
Message-ID: <20140909094644.GP13406@lahna.fi.intel.com>
References: <1410176880-22524-1-git-send-email-mika.westerberg@linux.intel.com>
 <CACRpkdb=yO3TbStfEesJCGDL3D_bq6_C0jwPUmKVuE+Otg8G4g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdb=yO3TbStfEesJCGDL3D_bq6_C0jwPUmKVuE+Otg8G4g@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 09, 2014 at 09:24:59AM +0200, Linus Walleij wrote:
> On Mon, Sep 8, 2014 at 1:47 PM, Mika Westerberg
> <mika.westerberg@linux.intel.com> wrote:
> 
> > Some newer Intel SoCs like Braswell already have more than 256 GPIOs
> > available so the default limit is exceeded. In order to support these add
> > back the custom GPIO header with limit of 512 GPIOs for x86.
> >
> > Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> 
> Argh! This is the kind of stuff I want to get rid of ....
> 
> Preferably gpio should be a subsystem without a lot of hooks all over
> the place with arch-specific modifications for this and that, including
> the max number of GPIOs.
> 
> I would actually prefer if you bump the value in
> include/asm-generic/gpio.h to 512 over this.

OK, this makes sense and I can do the change for the next revision of
the patch.

> But better still, now that we have descriptors etc would be to define
> some new per-arch selectable config option like
> CONFIG_ONLY_DYNAMIC_GPIO that changes the GPIO
> core to use something like a radix tree to store and retrieve
> descriptors.
> 
> I.e. in drivers/gpio/gpiolib.c get rid of this:
> static struct gpio_desc gpio_desc[ARCH_NR_GPIOS];
> 
> Replace it with a radix tree of descriptors.
> 
> This however makes it *impossible* to use things like desc_to_gpio()
> and/or gpio_to_desc() so the code has to be augmented all over the
> place to avoid any uses of GPIO numbers on that architecture,
> but I am sure it *can* be done on pure ACPI or device tree
> systems, and that's what we should aim for.
> 
> Comments?

That's a rather big rework to the GPIO subsystem and its users. I agree
that it should be the goal eventually. For x86 such conversion is not
that simple because we have systems out there that have neither ACPI nor
DT available.
