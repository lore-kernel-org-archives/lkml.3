Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755679Ab3BVCUJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 21:20:09 -0500
Received: from mail-ie0-f176.google.com ([209.85.223.176]:54195 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755219Ab3BVCUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 21:20:05 -0500
MIME-Version: 1.0
In-Reply-To: <1360907177-6468-1-git-send-email-acourbot@nvidia.com>
References: <1360907177-6468-1-git-send-email-acourbot@nvidia.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Fri, 22 Feb 2013 11:19:44 +0900
Message-ID: <CAAVeFuLP0KLVL-0SS+nGWSoK1RMPCmKgZV-OjMJo-h7E1UVuXw@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] gpiolib: some fixup patches
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Linus Walleij <linus.walleij@linaro.org>, Ryan Mallon <rmallon@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "acourbot@nvidia.com" <acourbot@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant, will you be able to include these for 3.9? They fix code that
you merged recently, so I'd be glad if they could be squashed into the
patch mentioned in the description.

Thanks,
Alex.


On Fri, Feb 15, 2013 at 2:46 PM, Alexandre Courbot <acourbot@nvidia.com> wrote:
> This short series is a fixup to patch 6/9 of my previous series ("gpiolib: use
> descriptors internally"), which mainly addresses issues raised by Linus W. in
> this patch and a few other minor ones caught while proof-reading gpiolib.
>
> First patch is the most significant. It mostly avoids oopses when passing an
> invalid GPIO to some functions. Also gpio_get/set_value*() now return 0 when
> given an invalid GPIO number instead of oopsing. I tend to think that's an
> improvement, but if it's not please let me know.
>
> Ideally these patches should be melded into the above-mentioned patch since
> they were intended to become a new revision, but I leave that decision to
> Grant's discretion.
>
> This patchset has been tested on Tegra 2/Ventana with a GPIO backlight driver
> and the sysfs interface.
>
> Changes from v1:
> - as suggested by Ryan Mallon, add a dedicated control flow for signaling
>   invalid GPIOs to avoid meaningless error messages and ugly ternary operators
> - use pr_warn instead of pr_debug to signal invalid GPIOs
> - do descriptors validity check before acquiring any lock
>
> Alexandre Courbot (4):
>   gpiolib: check descriptors validity before use
>   gpiolib: use const parameters when possible
>   gpiolib: move comment to right function
>   gpiolib: rename local offset variables to "hwgpio"
>
>  drivers/gpio/gpiolib.c | 213 +++++++++++++++++++++++++++----------------------
>  1 file changed, 117 insertions(+), 96 deletions(-)
>
> --
> 1.8.1.3
>
