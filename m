Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752060AbaLQLDQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 06:03:16 -0500
Received: from mail-lb0-f170.google.com ([209.85.217.170]:56364 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbaLQLDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 06:03:14 -0500
MIME-Version: 1.0
In-Reply-To: <CAAVeFuKp89U=tUwOSUYktdPamK2=HXqpnJxR7M=H0LSmSYqcDQ@mail.gmail.com>
References: <1418226977-17128-1-git-send-email-ricardo.ribalda@gmail.com> <CAAVeFuKp89U=tUwOSUYktdPamK2=HXqpnJxR7M=H0LSmSYqcDQ@mail.gmail.com>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Wed, 17 Dec 2014 12:02:53 +0100
Message-ID: <CAPybu_2eXhh7PuOTb=qpnoOOKYwwFynowHpDL-2PdsEqQEWYTQ@mail.gmail.com>
Subject: Re: [PATCH v4 2/4] gpio/xilinx: Convert the driver to platform device interface
To: Alexandre Courbot <gnurou@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Michal Simek <michal.simek@xilinx.com>,
        =?UTF-8?Q?S=C3=B6ren_Brinkmann?= <soren.brinkmann@xilinx.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Alexandre

> This should not be here. The mapping and call to gpiochip_add() are
> performed by of_mm_gpiochip_add(). We should thus have a
> of_mm_gpiochip_remove() function that undoes what _add did instead of
> expected all users to do unmap themselves. Can you add a patch to your
> series that adds this function?

>
> Also I am not sure I understand why the unmapping is done only once.
> Both chips are supposed to have been added (and thus mapped) at this
> stage. Oh right I see, so this driver ends up mapping the same area
> twice! Not only are you iomapping the same area twice, you are
> unmapping it only once, and only if the chip is dual. This looks very
> broken.
>

If you look carefully you can see that it is unmapped twice if it is
called twice. iounmap is called inside the  for loop.


> Couldn't you redesign the driver the following way: only add one chip
> (since you have 1 DT node), with an extra member to track which GPIOs
> belong to the second chip (in case it is dual), and change the other
> functions to handle this.

I do not mind rearranging the driver so there is only one gpio device,
even for dual chips, but I think this should be done in a separate
patch.

What about?

1) Keep the current patchset

and then

2) Add another patchset with

  - xilinx-gpio: only one gpio device
  - add  of_mm_gpiochip_remove() to the api
  - xilinx gpio: use of_mm_gpiochip_remove
  - others: use of_mm_gpiochip_remove


Regards!




-- 
Ricardo Ribalda
