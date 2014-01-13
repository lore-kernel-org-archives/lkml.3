Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751478AbaAMKyd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 05:54:33 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:61889 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959AbaAMKyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 05:54:31 -0500
MIME-Version: 1.0
In-Reply-To: <52D3C36E.9020107@ti.com>
References: <1389384793-4710-1-git-send-email-stefan.kristiansson@saunalahti.fi>
	<52D3A1FC.4090706@ti.com>
	<20140113102006.GA30877@chokladfabriken.org>
	<52D3C36E.9020107@ti.com>
Date: Mon, 13 Jan 2014 11:54:30 +0100
X-Google-Sender-Auth: Gr5ayqSQn9744NgBjbt_e7dygAE
Message-ID: <CAMuHMdU0AU80HqxOx_hhX8dP9xrJoNO+UhAZ=Ov4y64Hs7y5rw@mail.gmail.com>
Subject: Re: [PATCH v5] video: add OpenCores VGA/LCD framebuffer driver
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 13, 2014 at 11:43 AM, Tomi Valkeinen <tomi.valkeinen@ti.com> wrote:
> On 2014-01-13 12:20, Stefan Kristiansson wrote:
>> The VGA/LCD in the subject comes from the name of the core,
>> the core itself presents a "vga-type" interface, but it can basically
>> be hooked up to any type of display (with a bit of glue-logic in some cases).
>>
>> That said - the reason why I went for the mode_options solution in the
>> first place, is that when I initially wrote this driver
>> (>2 years ago, time flies...) the display-timing device-tree bindings weren't
>> invented yet, so it seemed like the most viable option without coming up
>> with custom device-tree bindings.
>>
>> It's completely possible that this design choice should be revised now,
>> and I wouldn't mind converting this driver to make use of the display-timing
>> dt properties if you think that's a good idea?
>
> I don't have a strong opinion on this. It looks to me that even if the
> current driver is merged, it would be easy to add device tree
> display-timing later, and still keep full backward compatibility.
>
> Then again, you already have DT support in the driver, and if it's clear
> that the DT based videomode selection is better, then I'd just go
> straight to that one without intermediate steps.

With a VGA connector, it's handy to be able to specify the video mode on
the kernel command line, instead of having to put it in the DT.

With hardwired LCDs with fixed timing, it's different.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
