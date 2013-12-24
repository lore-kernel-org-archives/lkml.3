Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762Ab3LXOjz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Dec 2013 09:39:55 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:48098 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340Ab3LXOjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Dec 2013 09:39:51 -0500
MIME-Version: 1.0
In-Reply-To: <1385135247-9068-1-git-send-email-geert@linux-m68k.org>
References: <1385135247-9068-1-git-send-email-geert@linux-m68k.org>
Date: Tue, 24 Dec 2013 15:39:50 +0100
X-Google-Sender-Auth: 8CmCWfE7pVk51d91IFErpXW_NtM
Message-ID: <CAMuHMdVcqiNQiMHD3pgRWUzt7n3+F0dwmeXVnmZtgCxyo=GmFw@mail.gmail.com>
Subject: Re: [PATCH 1/2] TTY: pmac_zilog, check existence of ports in pmz_console_init()
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, stable <stable@vger.kernel.org>
Cc: linux-serial@vger.kernel.org, "Linux/m68k" <linux-m68k@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Finn Thain <fthain@telegraphics.com.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 22, 2013 at 4:47 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> When booting a multi-platform m68k kernel on a non-Mac with "console=ttyS0"
> on the kernel command line, it crashes with:

Can we please get this in stable, too?

commit dc1dc2f8a5dd863bf2e79f338fc3ae29e99c683a

Thanks!

> Unable to handle kernel NULL pointer dereference at virtual address   (null)
> Oops: 00000000
> PC: [<0013ad28>] __pmz_startup+0x32/0x2a0
> ...
> Call Trace: [<002c5d3e>] pmz_console_setup+0x64/0xe4
>
> The normal tty driver doesn't crash, because init_pmz() checks
> pmz_ports_count again after calling pmz_probe().
>
> In the serial console initialization path, pmz_console_init() doesn't do
> this, causing the driver to crash later.
>
> Add a check for pmz_ports_count to fix this.
>
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Finn Thain <fthain@telegraphics.com.au>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
