Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753035Ab3ISHPQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 03:15:16 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:64568 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752784Ab3ISHPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 03:15:14 -0400
MIME-Version: 1.0
Date: Thu, 19 Sep 2013 09:15:13 +0200
X-Google-Sender-Auth: ViCqEPCgKtMw3p1qCoZjCzFx1kA
Message-ID: <CAMuHMdUUkKQjEA58W_HhQWtPUa4D2eRypPNQZgwXb+ZJutR4pQ@mail.gmail.com>
Subject: Serial consoles (was: [Ksummit-2013-discuss] [HOBBYIST ATTEND] IIO
 maintainer and developer)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Rob Landley <rob@landley.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ksummit-2013-discuss@lists.linuxfoundation.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, Sep 12, 2013 at 10:12 PM, Rob Landley <rob at landley.net> wrote:
> > 3) QEMU command line to boot to a shell prompt with serial console. x86 is
> > ttyS0, arm versatile is ttyAMA0, sh4 is ttySC1. Get it wrong and you have no
> > output.
>
> Can't we long-term fix this? Can we bring up both say ttyS0 and ttyAMA0
> on a machine and remove the other one when the first is opened,
> then print a friendly reminder to move over to ttyS0 if ttyAMA0 is
> used instead, so people are encouraged to switch to ttyS0
> for everything over time?
>
> Or do these separate serialport namespaces have a real utility?

I'd say they make life more difficult.
Making it easier to distinguish ports may have been the original reason, but
in other subsystems ("SCSI" disks, Ethernet ports, IDE, ...) there is a uniform
device namespace.
We still have different namepaces for other types of block devices, though, but
that's (usually) handled automatically by udev, file system UUIDs, etc.

Note that on m68k we never followed the non-16550-ports-should-use-a-different-
name-franze, and always continued using /dev/ttyS* for all serial ports.

BTW, perhaps we can keep the non-ksummit discussions on lkml?
I'm only reading Ksummit-2013-discuss from the list archives occasually...

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
