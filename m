Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964977Ab3BMVeL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 16:34:11 -0500
Received: from mail-da0-f41.google.com ([209.85.210.41]:63595 "EHLO
	mail-da0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861Ab3BMVeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 16:34:09 -0500
Date: Wed, 13 Feb 2013 13:34:05 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, Takashi Iwai <tiwai@suse.de>,
        axboe@kernel.dk, cbou@mail.ru, davem@davemloft.net,
        dwmw2@infradead.org, grant.likely@secretlab.ca,
        gregkh@linuxfoundation.org, jkosina@suse.cz, jslaby@suse.cz,
        khali@linux-fr.org, mchehab@redhat.com, perex@perex.cz,
        sameo@linux.intel.com, w.sang@pengutronix.de,
        linux-kernel@vger.kernel.org, sebott@linux.vnet.ibm.com,
        gerald.schaefer@de.ibm.com, schwidefsky@de.ibm.com
Subject: Re: [PATCH 12/15] sound: add missing HAS_IOPORT and GENERIC_HARDIRQS
 dependencies
Message-ID: <20130213213405.GA23390@core.coreip.homeip.net>
References: <1360167843-3587-1-git-send-email-heiko.carstens@de.ibm.com>
 <s5hmwvh73rp.wl%tiwai@suse.de>
 <20130206181242.GA3281@osiris>
 <201302062156.55910.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201302062156.55910.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 06, 2013 at 09:56:55PM +0000, Arnd Bergmann wrote:
> On Wednesday 06 February 2013, Heiko Carstens wrote:
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

I would be very careful with this statement. While devm_request_irq()
does simplify error handling in several cases I have also seen countless
examples when it was used with non devm_*-managed structures that are
freed by hand opening race window where interrupts can be delivered and
use structure that is already freed.

Thanks.

-- 
Dmitry
