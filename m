Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760065AbaGDGaZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 02:30:25 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:62554 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755361AbaGDGaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 02:30:23 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/DcZZGKdK3LUhy4uY+PtAt
Date: Thu, 3 Jul 2014 23:30:10 -0700
From: Tony Lindgren <tony@atomide.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Javier Martinez Canillas <javier@dowhile0.org>,
        Sebastian Reichel <sre@kernel.org>,
        Robert Nelson <robertcnelson@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux kernel <linux-kernel@vger.kernel.org>,
        linux-serial@vger.kernel.org,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH] tty: serial: Add 8250-core based omap driver
Message-ID: <20140704063010.GY28884@atomide.com>
References: <CAOCHtYgxMeA+Arfe40XeFDEKuCJ8qo1RqNR0hYBGr_Wp6sRfdA@mail.gmail.com>
 <20140703073411.GX28884@atomide.com>
 <20140703132509.GA5814@saruman.home>
 <CAOCHtYi0JwRO12gHa+KFGH1k7pPk4TL40igwhzRRxutw-tqf6A@mail.gmail.com>
 <20140703140736.GF5814@saruman.home>
 <20140703154425.GC23309@earth.universe>
 <20140703155240.GU5814@saruman.home>
 <20140703160622.GE23309@earth.universe>
 <CABxcv=nGPyK7SeQZ+W1ZEfBPQ-RraVTawyYuKOGz02df0g=6Qg@mail.gmail.com>
 <20140703170822.GB5814@saruman.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140703170822.GB5814@saruman.home>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Felipe Balbi <balbi@ti.com> [140703 10:10]:
> On Thu, Jul 03, 2014 at 06:19:47PM +0200, Javier Martinez Canillas wrote:
> > On Thu, Jul 3, 2014 at 6:06 PM, Sebastian Reichel <sre@kernel.org> wrote:
> > > Hi,
> > >
> > > On Thu, Jul 03, 2014 at 10:52:40AM -0500, Felipe Balbi wrote:
> > >> > DT is supposed to contain information about the hardware, so it
> > >> > should stay the same? I think there is no non-hackish way to decide
> > >>
> > >> compatible would change, at a minimum.
> > >
> > > why? I would expect it to stay the same (and the current patch uses
> > > the same compatible strings).
> > >
> > 
> > Exactly, the new driver must support all the compatible strings
> > defined in Documentation/devicetree/bindings/serial/omap_serial.tx
> > (which already does as you pointed out).
> > 
> > Otherwise the current drivers/tty/serial/omap-serial.c could never be
> > removed since that would mean breaking DT backward compatibility.
> 
> that settles it then... good. I'll start testing this next week.

Yeah full compability is the way to go here.

FYI we cannot switch over completely until runtime PM works as it
will block the deeper idle states for omaps and make it impossible
to debug PM features.

Regards,

Tony
