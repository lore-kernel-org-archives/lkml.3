Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882AbaLNJFx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 04:05:53 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:61314 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053AbaLNJFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 04:05:44 -0500
MIME-Version: 1.0
In-Reply-To: <20141208072124.GA21031@dtor-ws>
References: <20141208071930.GA20802@dtor-ws>
	<20141208072124.GA21031@dtor-ws>
Date: Sun, 14 Dec 2014 10:05:43 +0100
Message-ID: <CACRpkdZsHbUVNsG60veYPpAKP+dngpUq=gLjncaUb+Lvq+h1-A@mail.gmail.com>
Subject: Re: [PATCH 2/2] Input: gpio_keys - replace timer and workqueue with
 delayed workqueue
From: Linus Walleij <linus.walleij@linaro.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Linux Input <linux-input@vger.kernel.org>,
        Alexander Stein <alexander.stein@systec-electronic.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Alexander Shiyan <shc_work@mail.ru>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 8, 2014 at 8:21 AM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:

> We do not need to roll our own implementation of delayed work now that we
> have proper implementation of mod_delayed_work.
>
> For interrupt-only driven buttons we retain the timer, but we rename
> it to release_timer to better reflect its purpose.
>
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

What I want to do with this, on top of this, is to move debouncing to
the GPIO subsystem. I want gpio(d)_set_debounce() to *always*
work and the timer moved to gpiolib.c.

We can't have debouncing in every subsystem using GPIOs, it
belongs in the GPIO core.

Yours,
Linus Walleij
