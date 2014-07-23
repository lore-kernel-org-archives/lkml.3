Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758366AbaGWPco (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 11:32:44 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:59393 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757859AbaGWPcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 11:32:43 -0400
MIME-Version: 1.0
In-Reply-To: <1405966336-6605-1-git-send-email-linux@roeck-us.net>
References: <1405966336-6605-1-git-send-email-linux@roeck-us.net>
Date: Wed, 23 Jul 2014 17:32:42 +0200
Message-ID: <CACRpkdbn+nNJ4L71ZkLzNWWvmAq=bTYTBg1AJWe7TAtGq+3pKw@mail.gmail.com>
Subject: Re: [PATCH RESEND] gpio: Add support for GPIOF_ACTIVE_LOW to
 gpio_request_one functions
From: Linus Walleij <linus.walleij@linaro.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2014 at 8:12 PM, Guenter Roeck <linux@roeck-us.net> wrote:

> The gpio include file and the gpio documentation declare and document
> GPIOF_ACTIVE_LOW as one of the flags to be passed to gpio_request_one
> and related functions. However, the flag is not evaluated or used.
>
> This can cause problems in at least two areas: First, the same API can
> be used to auto-export pins to user space. The missing support for
> GPIOF_ACTIVE_LOW results in unexpected behavior for such auto-exported
> pins. Second, the requested gpio pin can be convered for use by
> gpiod functions with gpio_to_desc(). While gpio API functions do not
> support GPIOF_ACTIVE_LOW, gpiod functions do, which again results in
> unexpected behavior.
>
> Check the flag in gpio_request_one and set the gpio internal flag
> FLAG_ACTIVE_LOW if it is set to address those problems.
>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> Reviewed-by: Alexandre Courbot <acourbot@nvidia.com>

Patch applied after manually rebasing so it hits gpiolib-legacy.c.

Yours,
Linus Walleij
