Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751737AbaAESa2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 13:30:28 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:39707 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293AbaAESa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 13:30:26 -0500
MIME-Version: 1.0
In-Reply-To: <1388944204-13008-1-git-send-email-linux@roeck-us.net>
References: <1388944204-13008-1-git-send-email-linux@roeck-us.net>
Date: Sun, 5 Jan 2014 19:30:25 +0100
X-Google-Sender-Auth: K8nSEf99DATf4DJc6hdIkzvDafE
Message-ID: <CAMuHMdVfr0ExtrU7bNUttJwkMXv-ZRo0A=j3gJ-=9nakP0uP+g@mail.gmail.com>
Subject: Re: [PATCH] isdn: Build telespci and hfc_pci only for little endian CPUs
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Karsten Keil <isdn@linux-pingi.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 5, 2014 at 6:50 PM, Guenter Roeck <linux@roeck-us.net> wrote:
> -       depends on PCI && (BROKEN || !(SPARC || PPC || PARISC || M68K || (MIPS && !CPU_LITTLE_ENDIAN) || FRV || (XTENSA && !CPU_LITTLE_ENDIAN)))
> +       depends on CPU_LITTLE_ENDIAN && PCI && (BROKEN || !(SPARC || PPC || PARISC || M68K || MIPS || FRV || XTENSA))

Unfortunately CPU_LITTLE_ENDIAN is only available on architectures
that support two endiannesses. So the above will preclude e.g. x86, which is
where most ISDN users are.

One solution is to move CPU_LITTLE_ENDIAN and CPU_BIG_ENDIAN to the
common Kconfig parts. After that, the dependency above can just become

    depends on CPU_LITTLE_ENDIAN && PCI.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
