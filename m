Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756557Ab3ANMXX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 07:23:23 -0500
Received: from mail-vc0-f177.google.com ([209.85.220.177]:51896 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756530Ab3ANMXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 07:23:22 -0500
MIME-Version: 1.0
In-Reply-To: <1635127.Ytukyo95FQ@bentobox>
References: <1635127.Ytukyo95FQ@bentobox>
Date: Mon, 14 Jan 2013 13:23:21 +0100
X-Google-Sender-Auth: Wm6yVbf-v65SdAo_gov6FBCuL0I
Message-ID: <CAMuHMdVR_pviGjD4qUZtkSQR9Cst2cRQv53205E00CUxEGr33Q@mail.gmail.com>
Subject: Re: container-of Implementation
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Schrober <franzschrober@yahoo.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2013 at 11:46 AM, Schrober <franzschrober@yahoo.de> wrote:
> I wondered why the container_of implementation is so complicated.
>
> #define container_of(ptr, type, member) ({                      \
>         const typeof( ((type *)0)->member ) *__mptr = (ptr);    \
>         (type *)( (char *)__mptr - offsetof(type,member) );})
>
> isn't the __mptr not unnecessary? Why not following version?
>
> #define container_of(ptr, type, member) \
>     ((type *)((char *)(ptr) - offsetof(type, member)))

The __mptr construct will cause a compiler warning if ptr is of the
wrong type.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
