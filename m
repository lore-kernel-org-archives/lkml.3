Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751302AbaK1K3N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 05:29:13 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:62386 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbaK1K3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 05:29:11 -0500
MIME-Version: 1.0
In-Reply-To: <1416383487-15993-1-git-send-email-acourbot@nvidia.com>
References: <1416383487-15993-1-git-send-email-acourbot@nvidia.com>
Date: Fri, 28 Nov 2014 11:29:11 +0100
Message-ID: <CACRpkdZV-nQPXDnxiBgPTZTpyQ2eiKNL8qJY9jRq=A5foc-xmw@mail.gmail.com>
Subject: Re: [PATCH] gpio: remove gpio_descs global array
From: Linus Walleij <linus.walleij@linaro.org>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2014 at 8:51 AM, Alexandre Courbot <acourbot@nvidia.com> wrote:

> Replace the ARCH_NR_GPIOS-sized static array of GPIO descriptors by
> dynamically-allocated arrays for each GPIO chip.
>
> This change makes gpio_to_desc() perform in O(n) (where n is the number
> of GPIO chips registered) instead of O(1), however since n is rarely
> bigger than 1 or 2 no noticeable performance issue is expected.
> Besides this provides more incentive for GPIO consumers to move to the
> gpiod interface. One could use a O(log(n)) structure to link the GPIO
> chips together, but considering the low limit of n the hypothetical
> performance benefit is probably not worth the added complexity.
>
> This patch uses kcalloc() in gpiochip_add(), which removes the ability
> to add a chip before kcalloc() can operate. I am not aware of such
> cases, but if someone bisects up to this patch then I will be proven
> wrong...
>
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>

OK patch applied. Let's see if the world explodes.

Yours,
Linus Walleij
