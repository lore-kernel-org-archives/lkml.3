Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752044Ab3IRIwF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 04:52:05 -0400
Received: from mail.karo-electronics.de ([81.173.242.67]:59070 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850Ab3IRIwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 04:52:04 -0400
Message-ID: <21049.26895.978512.36292@ipc1.ka-ro>
Date: Wed, 18 Sep 2013 10:49:19 +0200
From: =?utf-8?Q?Lothar_Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: Markus Pargmann <mpa@pengutronix.de>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: Re: dev->of_node overwrite can cause device loading with different
 driver
In-Reply-To: <20130918083155.GB10126@pengutronix.de>
References: <20130913155331.GC14456@pengutronix.de>
	<20130913171046.GA26207@kroah.com>
	<20130914071653.GA26512@pengutronix.de>
	<20130914121729.GA7823@kroah.com>
	<20130914122809.GI12758@n2100.arm.linux.org.uk>
	<20130918083155.GB10126@pengutronix.de>
X-Mailer: VM 8.1.0 under 23.2.1 (x86_64-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Markus Pargmann writes:
> On Sat, Sep 14, 2013 at 01:28:09PM +0100, Russell King - ARM Linux wrote:
> > On Sat, Sep 14, 2013 at 05:17:29AM -0700, Greg Kroah-Hartman wrote:
> > > On Sat, Sep 14, 2013 at 09:16:53AM +0200, Markus Pargmann wrote:
> > > > 3. We could fix up all drivers that change the of_node. But there are
> > > >    ARM DT frameworks that require a device struct as parameter instead
> > > >    of a device_node parameter (e.g. soc-generic-dmaengine-pcm). So a
> > > >    driver core, initialized by a glue driver with DT bindings, has to
> > > >    set dev->of_node to use those frameworks. I think it is strange to
> > > >    have such DT framework interfaces if a driver is not supposed to
> > > >    overwrite dev->of_node permanently.
> > > 
> > > How about any driver that does muck with this structure, restore it
> > > properly if their probe() function fails?  Yes, you show that this is
> > > going to be tricky in some places (i.e. musb), but it makes sense that
> > > the burden of fixing this issue would rest on them, as they are the ones
> > > causing this problem, right?
> > 
> > It's not about overwriting at all.
> 
> musb does not overwrite of_node, but other drivers do, e.g. USB chipidea
> core driver which uses its parent of_node. When probe fails in this
> case, we could end up with similar issues.
> 
This has already been fixed in commit:
e98b44e9 usb: chipidea: prevent endless loop registering platform_devices when probe fails
in linux-next


Lothar Waßmann
-- 
___________________________________________________________

Ka-Ro electronics GmbH | Pascalstraße 22 | D - 52076 Aachen
Phone: +49 2408 1402-0 | Fax: +49 2408 1402-10
Geschäftsführer: Matthias Kaussen
Handelsregistereintrag: Amtsgericht Aachen, HRB 4996

www.karo-electronics.de | info@karo-electronics.de
___________________________________________________________
