Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932332AbaIIHmN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 03:42:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36871 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932185AbaIIHmJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 03:42:09 -0400
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH 1/2] x86, gpio: Increase ARCH_NR_GPIOs to 512
From: "H. Peter Anvin" <hpa@zytor.com>
X-Mailer: iPad Mail (11D257)
In-Reply-To: <CACRpkdb=yO3TbStfEesJCGDL3D_bq6_C0jwPUmKVuE+Otg8G4g@mail.gmail.com>
Date: Tue, 9 Sep 2014 00:41:47 -0700
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>, Ning Li <ning.li@intel.com>,
        Alan Cox <alan@linux.intel.com>, Mark Brown <broonie@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
Content-Transfer-Encoding: 7bit
Message-Id: <8B06FF90-41FC-49F8-B330-EC3911BEA2AE@zytor.com>
References: <1410176880-22524-1-git-send-email-mika.westerberg@linux.intel.com> <CACRpkdb=yO3TbStfEesJCGDL3D_bq6_C0jwPUmKVuE+Otg8G4g@mail.gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Isn't this exactly what ida is for?

Sent from my tablet, pardon any formatting problems.

> On Sep 9, 2014, at 0:24, Linus Walleij <linus.walleij@linaro.org> wrote:
> 
> On Mon, Sep 8, 2014 at 1:47 PM, Mika Westerberg
> <mika.westerberg@linux.intel.com> wrote:
> 
>> Some newer Intel SoCs like Braswell already have more than 256 GPIOs
>> available so the default limit is exceeded. In order to support these add
>> back the custom GPIO header with limit of 512 GPIOs for x86.
>> 
>> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> 
> Argh! This is the kind of stuff I want to get rid of ....
> 
> Preferably gpio should be a subsystem without a lot of hooks all over
> the place with arch-specific modifications for this and that, including
> the max number of GPIOs.
> 
> I would actually prefer if you bump the value in
> include/asm-generic/gpio.h to 512 over this.
> 
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
> 
> Yours,
> Linus Walleij
