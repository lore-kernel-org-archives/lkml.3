Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946042Ab3BHGsE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 01:48:04 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:51874 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946022Ab3BHGsC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 01:48:02 -0500
MIME-Version: 1.0
In-Reply-To: <1360246728-3490-1-git-send-email-michal.simek@xilinx.com>
References: <1360246728-3490-1-git-send-email-michal.simek@xilinx.com>
Date: Fri, 8 Feb 2013 07:48:01 +0100
X-Google-Sender-Auth: ymF10CPcCj6jyncopqlT4ApVpK0
Message-ID: <CAMuHMdWEr-uZqc6P1CGNw0P6JG3FGsRKJLB1tLWzuYuBujTzfQ@mail.gmail.com>
Subject: Re: [PATCH] asm-generic: io: Fix ioread16/32be and iowrite16/32be
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Michal Simek <michal.simek@xilinx.com>
Cc: linux-kernel@vger.kernel.org, monstr@monstr.eu,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Arnd Bergmann <arnd@arndb.de>, Will Deacon <will.deacon@arm.com>,
        linux-arch@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 7, 2013 at 3:18 PM, Michal Simek <michal.simek@xilinx.com> wrote:
> Fix ioreadXXbe and iowriteXXbe functions which did
> additional little endian conversion on native big endian systems.
> Using be_to_cpu (cpu_to_be) conversions with __raw_read/write
> functions have resolved it.
>
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> CC: Arnd Bergmann <arnd@arndb.de>
> CC: Geert Uytterhoeven <geert@linux-m68k.org>
> CC: Will Deacon <will.deacon@arm.com>
> CC: linux-arch@vger.kernel.org

I have one question (see below). Apart from that:
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

> -#define ioread16be(addr)       be16_to_cpu(ioread16(addr))
> +#define ioread16be(addr)       __be16_to_cpu(__raw_readw(addr))

Why did you change it to the __beX_to_cpu variant with underscores?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
