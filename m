Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758623Ab3BGNcP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 08:32:15 -0500
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:56465 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261Ab3BGNcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 08:32:14 -0500
Date: Thu, 7 Feb 2013 14:32:06 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Takashi Iwai <tiwai@suse.de>, axboe@kernel.dk, cbou@mail.ru,
        davem@davemloft.net, dtor@mail.ru, dwmw2@infradead.org,
        grant.likely@secretlab.ca, gregkh@linuxfoundation.org, jkosina@suse.cz,
        jslaby@suse.cz, khali@linux-fr.org, mchehab@redhat.com, perex@perex.cz,
        sameo@linux.intel.com, w.sang@pengutronix.de,
        linux-kernel@vger.kernel.org, sebott@linux.vnet.ibm.com,
        gerald.schaefer@de.ibm.com, schwidefsky@de.ibm.com
Subject: Re: [PATCH 12/15] sound: add missing HAS_IOPORT and GENERIC_HARDIRQS
 dependencies
Message-ID: <20130207133206.GB3929@osiris>
References: <1360167843-3587-1-git-send-email-heiko.carstens@de.ibm.com>
 <s5hmwvh73rp.wl%tiwai@suse.de>
 <20130206181242.GA3281@osiris>
 <201302062156.55910.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201302062156.55910.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 13020713-5024-0000-0000-00000525F544
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 06, 2013 at 09:56:55PM +0000, Arnd Bergmann wrote:
> On Wednesday 06 February 2013, Heiko Carstens wrote:
> > On Wed, Feb 06, 2013 at 06:26:02PM +0100, Takashi Iwai wrote:
> > > At Thu, 07 Feb 2013 02:13:19 +0100,
> > > Arnd Bergmann wrote:
> > > > Why not just make CONFIG_GENERIC_HARDIRQS mandatory for all
> > > > platforms. It is use almost everywhere now.
> > > 
> > > I wonder it, too...
> > 
> > I haven't looked into it, but I doubt if that is possible without large
> > effort, if at all. s390 doesn't have any irq chips, nor something like
> > edge or level triggered irqs.
> > Instead we have floating interrupts. Does that fit into the concept of
> > GENERIC_HARDIRQS at all?
> > If so, we can give it a try, sure. But that won't happen any time soon.
> > 
> > Or are you simply proposing we should have both, our own irq handling plus
> > GENERIC_HARDIRQS with dummy functions?
> 
> I think you should use GENERIC_HARDIRQ just for PCI, and rename the s390
> interrupt handling to something that does not conflict. I understand
> that the concepts are quite different, but with PCI support, you actually
> do get all the weird interrupt hardware.
> More importantly, some features provided by GENERIC_HARDIRQ are replacing
> the traditional interfaces now, e.g. devm_request_irq() is actually
> recommended over request_irq() for normal drivers these days, as it
> simplifies the error handling.

That sounds reasonable. And a quick grep seems to indicate that s390
is the last architecture with !GENERIC_HARDIRQS.
However having two completely different IRQ subsystems within one
architecture will bring up some interesting questions like e.g.
how should /proc/interrupts look like? Or /proc/stat:intr ?

Jan considered turning GENERIC_HARDIRQS on for PCI support, but didn't.
I don't know why he didn't and since he left, we can't ask him anymore.

So for the time being I'd appreciate it if we can simply add the
additional GENERIC_HARDIRQS dependencies where needed, since I consider
a working allmodconfig quite important.
Later on we should indeed try to switch to GENERIC_HARDIRQS and then
git rid of that config option completely. However I leave that to
Sebastian and Gerald who now take care of our PCI code ;)

Thanks,
Heiko

