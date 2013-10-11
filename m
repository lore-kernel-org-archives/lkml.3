Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388Ab3JKOZR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 10:25:17 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:50805 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754562Ab3JKOZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 10:25:15 -0400
MIME-Version: 1.0
In-Reply-To: <1380909598-6382-1-git-send-email-acourbot@nvidia.com>
References: <1380909598-6382-1-git-send-email-acourbot@nvidia.com>
Date: Fri, 11 Oct 2013 16:25:14 +0200
Message-ID: <CACRpkdb=rEiXJqnkS8mQeo1gO3r7r8GYCNmopsjh9iDC4HagvQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] gpiolib: safer implementation of desc_to_gpio()
From: Linus Walleij <linus.walleij@linaro.org>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: "Dr. H. Nikolaus Schaller" <hns@goldelico.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 4, 2013 at 7:59 PM, Alexandre Courbot <acourbot@nvidia.com> wrote:

> The current implementation of desc_to_gpio() relies on the chip pointer
> to be set to a valid value in order to compute the GPIO number. This
> was done in the hope that we can get rid of the gpio_desc global array,
> but this is not happening anytime soon.
>
> This patch reimplements desc_to_gpio() in a fashion similar to that of
> gpio_to_desc(). As a result, desc_to_gpio(gpio_to_desc(gpio)) == gpio is
> now always true. This allows to call desc_to_gpio() on non-initialized
> descriptors as some error-handling code currently does.
>
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> Reported-by: Dr. H. Nikolaus Schaller <hns@goldelico.com>

Patch applied.

Yours,
Linus Walleij
