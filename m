Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754278Ab3HPWRo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 18:17:44 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:44845 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754215Ab3HPWRm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:17:42 -0400
MIME-Version: 1.0
In-Reply-To: <20130816202702.GD4568@roeck-us.net>
References: <520A1D56.2050507@roeck-us.net>
	<20130813175858.GC7336@kroah.com>
	<20130813201936.GA18358@roeck-us.net>
	<20130815063158.GB25754@kroah.com>
	<520C86BD.2020903@roeck-us.net>
	<CAMuHMdU+EOC_etihOzUC6N0cqc2qHaGm3_L+gyTRxESCGhOzEg@mail.gmail.com>
	<520DB045.7000309@roeck-us.net>
	<20130816051041.GA23784@kroah.com>
	<520DE21D.8000905@roeck-us.net>
	<20130816124140.GD24550@kroah.com>
	<20130816202702.GD4568@roeck-us.net>
Date: Fri, 16 Aug 2013 23:55:02 +0200
X-Google-Sender-Auth: V5s-jvDrGM-Kyn7v61tHhUC-kHc
Message-ID: <CAMuHMdW6Ji7ibMeQj5FBQsJS3B-WWx=Lbhmjx4CCFEGg_uobHQ@mail.gmail.com>
Subject: Re: [ 00/17] 3.4.58-stable review
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>,
        Linux MIPS Mailing List <linux-mips@linux-mips.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 16, 2013 at 10:27 PM, Guenter Roeck <linux@roeck-us.net> wrote:
> Still failing:
>         sparc64:allmodconfig
> /opt/buildbot/slave/stable-queue-3_4/build/usr/include/linux/types.h:27:1: error: unknown type name ‘__u16’

According to my log collection, this same error message was fixed in v3.3-rc2,
but I couldn't easily find a matching commit.
But this is v3.4-stable, which is after v3.3-rc2, so it got reintroduced?

>         xtensa:defconfig
> dev.c:(.text.unlikely+0x3): dangerous relocation: l32r: literal placed after use: .literal.unlikely

Fixed in v3.7-rc1:

commit f6a03a12ecdbe0dd80a55f6df3b7206c5a403a49
Author: Max Filippov <jcmvbkbc@gmail.com>
Date:   Mon Sep 17 05:44:31 2012 +0400

    xtensa: fix linker script transformation for .text.unlikely

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
