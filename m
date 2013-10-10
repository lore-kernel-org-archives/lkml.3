Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754312Ab3JJGur (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 02:50:47 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:45566 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753951Ab3JJGun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 02:50:43 -0400
Date: Thu, 10 Oct 2013 08:50:37 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linus Walleij <linus.walleij@linaro.org>, Rob Landley <rob@landley.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ksummit-2013-discuss@lists.linuxfoundation.org
Subject: Re: Serial consoles (was: [Ksummit-2013-discuss] [HOBBYIST ATTEND]
 IIO maintainer and developer)
Message-ID: <20131010065037.GB1535@xo-6d-61-c0.localdomain>
References: <CAMuHMdUUkKQjEA58W_HhQWtPUa4D2eRypPNQZgwXb+ZJutR4pQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdUUkKQjEA58W_HhQWtPUa4D2eRypPNQZgwXb+ZJutR4pQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu 2013-09-19 09:15:13, Geert Uytterhoeven wrote:
> > On Thu, Sep 12, 2013 at 10:12 PM, Rob Landley <rob at landley.net> wrote:
> > > 3) QEMU command line to boot to a shell prompt with serial console. x86 is
> > > ttyS0, arm versatile is ttyAMA0, sh4 is ttySC1. Get it wrong and you have no
> > > output.
> >
> > Can't we long-term fix this? Can we bring up both say ttyS0 and ttyAMA0
> > on a machine and remove the other one when the first is opened,
> > then print a friendly reminder to move over to ttyS0 if ttyAMA0 is
> > used instead, so people are encouraged to switch to ttyS0
> > for everything over time?
> >
> > Or do these separate serialport namespaces have a real utility?
> 
> I'd say they make life more difficult.
> Making it easier to distinguish ports may have been the original reason, but
> in other subsystems ("SCSI" disks, Ethernet ports, IDE, ...) there is a uniform
> device namespace.
> We still have different namepaces for other types of block devices, though, but
> that's (usually) handled automatically by udev, file system UUIDs, etc.
> 
> Note that on m68k we never followed the non-16550-ports-should-use-a-different-
> name-franze, and always continued using /dev/ttyS* for all serial ports.

Well.. spitz (ARM) does the same -- registers ttyS0 for its serial ports. But then
I plugged bluetooth CF card... with 16550 port... and things got "interesting".

I don't think it was ever solved, as serial layer does not support uniform device
namespace...

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
