Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040Ab3CCSvA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 13:51:00 -0500
Received: from mail-ve0-f178.google.com ([209.85.128.178]:50090 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753931Ab3CCSu7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 13:50:59 -0500
MIME-Version: 1.0
In-Reply-To: <CACxGe6sweLxtsW9OYb8m7esYguGmStEsuZc0tOgZN6H5Zfy1+g@mail.gmail.com>
References: <CACxGe6sweLxtsW9OYb8m7esYguGmStEsuZc0tOgZN6H5Zfy1+g@mail.gmail.com>
Date: Sun, 3 Mar 2013 10:50:58 -0800
X-Google-Sender-Auth: 7uKKO3ab4AaQgVB2SKnkkREFR0M
Message-ID: <CA+55aFxzN7=z7_iVQ=JvYms1WaCoX-hQ2jKNqLU2dLy63AYK1g@mail.gmail.com>
Subject: Re: [GIT PULL] gpio changes for v3.9; second round
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 2, 2013 at 6:24 AM, Grant Likely <grant.likely@secretlab.ca> wrote:
>
> 2nd round of GPIO changes for Linux 3.9
>
> This branch contains a few bug fixes that I missed the first time around
> and updates to the gpio_desc series included in the first pull request.
>
> ----------------------------------------------------------------
> Gabriel Fernandez (1):
>       gpio/stmpe: pass DT node to irqdomain

This breaks the build for me. I get

  drivers/gpio/gpio-stmpe.c: In function ‘stmpe_gpio_irq_init’:
  drivers/gpio/gpio-stmpe.c:313:23: error: ‘struct gpio_chip’ has no
member named ‘of_node’
  drivers/gpio/gpio-stmpe.c:316:61: error: ‘struct gpio_chip’ has no
member named ‘of_node’
  drivers/gpio/gpio-stmpe.c: In function ‘stmpe_gpio_probe’:
  drivers/gpio/gpio-stmpe.c:351:18: error: ‘struct gpio_chip’ has no
member named ‘of_node’

and I don't think this is a merge error.

Should this driver depend on CONFIG_OF_GPIO, or should it have
#ifdef's? Regardless, it's clearly broken right now.

Unpulled.

                Linus
