Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751761AbaGJHiF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 03:38:05 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:63155 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbaGJHiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 03:38:03 -0400
MIME-Version: 1.0
In-Reply-To: <20140709224647.GA23929@kroah.com>
References: <1401731125-19780-1-git-send-email-emilgoode@gmail.com>
	<20140709224647.GA23929@kroah.com>
Date: Thu, 10 Jul 2014 09:38:00 +0200
X-Google-Sender-Auth: RAnYHducSNTE9yKSwgS9PCCp-5A
Message-ID: <CAMuHMdVq3BX=NwaCsma-N5iTdTkCS-rsX16dQL1Qr9Sepo8qww@mail.gmail.com>
Subject: Re: [PATCH] usb: usb5303: make use of uninitialized err variable
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Emil Goode <emilgoode@gmail.com>, Mark Brown <broonie@linaro.org>,
        Olof Johansson <olof@lixom.net>, Dongjin Kim <tobetter@gmail.com>,
        Julius Werner <jwerner@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        USB list <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Thu, Jul 10, 2014 at 12:46 AM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Mon, Jun 02, 2014 at 07:45:25PM +0200, Emil Goode wrote:
>> The variable err is not initialized here, this patch uses it
>> to store an eventual error value from devm_clk_get().
>>
>> Signed-off-by: Emil Goode <emilgoode@gmail.com>
>> Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
>> ---
>>  drivers/usb/misc/usb3503.c |   10 +++++++---
>>  1 file changed, 7 insertions(+), 3 deletions(-)

> This patch fails to apply to my tree :(

You've already applied
commit ec5734c41bee2ee7c938a8f34853d31cada7e67a
Author: Tushar Behera <tushar.b@samsung.com>
Date:   Tue Jun 17 16:38:50 2014 +0530

    usb: misc: usb3503: Update error code in print message

    'err' is uninitialized, rather print the error code directly.

which fixes it slightly different.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
