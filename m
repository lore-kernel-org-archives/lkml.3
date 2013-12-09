Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933734Ab3LIOMW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 09:12:22 -0500
Received: from mail-ob0-f178.google.com ([209.85.214.178]:51490 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753514Ab3LIOMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 09:12:21 -0500
MIME-Version: 1.0
In-Reply-To: <1386295616-14192-1-git-send-email-acourbot@nvidia.com>
References: <1386295616-14192-1-git-send-email-acourbot@nvidia.com>
Date: Mon, 9 Dec 2013 15:12:20 +0100
Message-ID: <CACRpkdb_XXV=oriu5t+maRmpVM0A+xJTQG3kTh1Vv4SdiQmLTQ@mail.gmail.com>
Subject: Re: [PATCH] gpiolib: return -ENOENT when no GPIO mapping exists
From: Linus Walleij <linus.walleij@linaro.org>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 6, 2013 at 3:06 AM, Alexandre Courbot <acourbot@nvidia.com> wrote:

> Some devices drivers make use of optional GPIO parameters. For such
> drivers, it is important to discriminate between the case where no
> GPIO mapping has been defined for the function they are requesting, and
> the case where a mapping exists but an error occured while resolving it
> or when acquiring the GPIO.
>
> This patch changes the family of gpiod_get() functions such that they
> will return -ENOENT if and only if no GPIO mapping is defined for the
> requested function. Other error codes are used when an actual error
> occured during the GPIO resolution.
>
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> ---
> I think this change should be merged early as not having it may prevent
> some users to switch to gpiod. I stumbled upon this issue while
> considering porting a simple driver (pwm_bl) that has an optional GPIO
> parameter.
>
> Mika, Andy: if Linus agrees with this change, could you take care of
> having -ENOENT returned as well for the ACPI and SFI GPIOs lookup?
> My understanding of ACPI was not sufficient to allow me to do it myself.
> SFI OTOH should be trivial as it is a simple table.

I'm aligned with this change, just waiting for a v2 with the fix
requested by Andy to appear (maybe it's further up in the mail log
I don't know...)

Yours,
Linus Walleij
