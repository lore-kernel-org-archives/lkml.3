Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752AbaAFOnl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 09:43:41 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34891 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbaAFOnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 09:43:39 -0500
Date: Mon, 6 Jan 2014 14:43:33 +0000
From: Luis Henriques <luis.henriques@canonical.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, stable <stable@vger.kernel.org>,
        linux-serial@vger.kernel.org, Linux/m68k <linux-m68k@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Finn Thain <fthain@telegraphics.com.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 1/2] TTY: pmac_zilog, check existence of ports in
 pmz_console_init()
Message-ID: <20140106144333.GE2776@hercules>
References: <1385135247-9068-1-git-send-email-geert@linux-m68k.org>
 <CAMuHMdVcqiNQiMHD3pgRWUzt7n3+F0dwmeXVnmZtgCxyo=GmFw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdVcqiNQiMHD3pgRWUzt7n3+F0dwmeXVnmZtgCxyo=GmFw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 24, 2013 at 03:39:50PM +0100, Geert Uytterhoeven wrote:
> On Fri, Nov 22, 2013 at 4:47 PM, Geert Uytterhoeven
> <geert@linux-m68k.org> wrote:
> > When booting a multi-platform m68k kernel on a non-Mac with "console=ttyS0"
> > on the kernel command line, it crashes with:
> 
> Can we please get this in stable, too?
> 
> commit dc1dc2f8a5dd863bf2e79f338fc3ae29e99c683a
> 
> Thanks!

Thanks Geert, I'm queuing it for the 3.5 and 3.11 kernels as well.

Cheers,
--
Luis

> > Unable to handle kernel NULL pointer dereference at virtual address   (null)
> > Oops: 00000000
> > PC: [<0013ad28>] __pmz_startup+0x32/0x2a0
> > ...
> > Call Trace: [<002c5d3e>] pmz_console_setup+0x64/0xe4
> >
> > The normal tty driver doesn't crash, because init_pmz() checks
> > pmz_ports_count again after calling pmz_probe().
> >
> > In the serial console initialization path, pmz_console_init() doesn't do
> > this, causing the driver to crash later.
> >
> > Add a check for pmz_ports_count to fix this.
> >
> > Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> > Cc: Finn Thain <fthain@telegraphics.com.au>
> > Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> 
> Gr{oetje,eeting}s,
> 
>                         Geert
> 
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
