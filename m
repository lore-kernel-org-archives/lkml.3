Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757518AbaISRsE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 13:48:04 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:42416 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756107AbaISRsC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 13:48:02 -0400
MIME-Version: 1.0
In-Reply-To: <CAAVeFuKK0BNpYPwZ8c4DbhWmbFnRVuaDo2AqfSNBgBPyUou0_A@mail.gmail.com>
References: <1410176880-22524-1-git-send-email-mika.westerberg@linux.intel.com>
	<CACRpkdb=yO3TbStfEesJCGDL3D_bq6_C0jwPUmKVuE+Otg8G4g@mail.gmail.com>
	<CAAVeFuKK0BNpYPwZ8c4DbhWmbFnRVuaDo2AqfSNBgBPyUou0_A@mail.gmail.com>
Date: Fri, 19 Sep 2014 10:48:01 -0700
Message-ID: <CACRpkdYbmcxi=BXEyGzLpxN4omt+v_Cg_BxCiN4vS9ZUwYTLzQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] x86, gpio: Increase ARCH_NR_GPIOs to 512
From: Linus Walleij <linus.walleij@linaro.org>
To: Alexandre Courbot <gnurou@gmail.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Ning Li <ning.li@intel.com>, Alan Cox <alan@linux.intel.com>,
        Mark Brown <broonie@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2014 at 12:20 AM, Alexandre Courbot <gnurou@gmail.com> wrote:
> On Tue, Sep 9, 2014 at 4:24 PM, Linus Walleij <linus.walleij@linaro.org> wrote:

>> This however makes it *impossible* to use things like desc_to_gpio()
>> and/or gpio_to_desc() so the code has to be augmented all over the
>> place to avoid any uses of GPIO numbers on that architecture,
>> but I am sure it *can* be done on pure ACPI or device tree
>> systems, and that's what we should aim for.
>
> desc_to_gpio()/gpio_to_desc() could still work even if we remove the
> big array of GPIO descriptors. Actually that's what I intended to do
> when I first submitted the gpiod patches some time ago but it was
> rejected for performance reasons.

OK. I'm ready to revisit the subject.

> desc_to_gpio() actually doesn't even access this array - it does its
> job using the chip base and the beginning address of its descriptors
> array.

Right.

> gpio_to_desc() would suffer a performance hit. What I initially
> proposed was to parse the linked list of GPIO chips and check if the
> requested number is in their assigned range. This is obviously slower
> than accessing an array, but if we consider that we generally don't
> have too many GPIO chips on a given hardware I don't think the hit
> would be that bad. It would also give some incentive for people to
> move to the gpiod interface.

I think the performance hit is acceptable, because this should
not be on a hot path anyway. I would say go ahead with this refactoring.

> I also have a patch in my queue that enables multiple users on the
> same GPIO descriptor (something requested since some time already).
> What happens with it is that descriptors ownership is fully
> transferred to the gpio_chip instances, and the static array becomes a
> array of double-pointers, making it considerable smaller and reducing
> the impact of increasing its size. Maybe I should submit that change
> just for this case?

Ummmmm I think that is an orthogonal thing, but honestly I'm
not following the double-pointers thing, so I guess I need to see
the patch.

Yours,
Linus Walleij
