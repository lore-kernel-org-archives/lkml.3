Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568AbaIXIv2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 04:51:28 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:59447 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006AbaIXIvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 04:51:24 -0400
MIME-Version: 1.0
In-Reply-To: <1409930524-1529-1-git-send-email-octavian.purdila@intel.com>
References: <1409930524-1529-1-git-send-email-octavian.purdila@intel.com>
Date: Wed, 24 Sep 2014 10:51:23 +0200
Message-ID: <CACRpkdZGBe1UfazBUgtq=oHgRpFPkRcxYtJz++JgUbzUSiOsyg@mail.gmail.com>
Subject: Re: [PATCH] gpiolib: fix a few issues with gpiochip_remove
From: Linus Walleij <linus.walleij@linaro.org>
To: Octavian Purdila <octavian.purdila@intel.com>
Cc: Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 5, 2014 at 5:22 PM, Octavian Purdila
<octavian.purdila@intel.com> wrote:

> The current implementation of gpiochip_remove() does not check to see
> if the GPIO pins are busy before removing the associated irqchip and
> this is causing the following warning:
(...)
> A retry operation is needed in the case of MFD devices that bundles a
> GPIO device and another device that is an indirect consumer of the
> GPIO device (typical an I2C bus).

We have just finalized a set of patches making gpiochip_remove()
not return an error code, because it just must work.

It seems like this patch want us to sort of reverse that whole train
of work and go back to the old style of having gpiochip_remove()
be able to fail :-/

I would suggest that if this usecase is to be supported for thing
like MFD devices, we need to introduce gpiochip_try_remove()
in parallel with the current implementation, so that those drivers
that actually want to retry the remove the chip can use that
interface explicitly.

Can you look into this option?

Please also look over gpiochip_remove() as it looks right now
in linux-next...

Yours,
Linus Walleij
