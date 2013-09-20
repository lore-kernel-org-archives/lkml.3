Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752902Ab3ITQdZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 12:33:25 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:24150 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752210Ab3ITQdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 12:33:24 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/Do5Gnbf7XmlLfbbwepx9r
Date: Fri, 20 Sep 2013 09:33:18 -0700
From: Tony Lindgren <tony@atomide.com>
To: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, Aaro Koskinen <aaro.koskinen@iki.fi>,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ADP1653 board code for Nokia RX-51
Message-ID: <20130920163318.GT9994@atomide.com>
References: <201302171616.50152@pali>
 <201309181800.10486@pali>
 <20130918174211.GU9994@atomide.com>
 <201309200030.36606@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201309200030.36606@pali>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pali Rohár <pali.rohar@gmail.com> [130919 15:38]:
> On Wednesday 18 September 2013 19:42:12 Tony Lindgren wrote:
> > * Pali Rohár <pali.rohar@gmail.com> [130918 09:08]:
> > > On Wednesday 18 September 2013 15:16:44 Pavel Machek wrote:
> > > > On Sun 2013-09-08 02:02:52, Aaro Koskinen wrote:
> > > > > Hi,
> > > > > 
> > > > > On Fri, Sep 06, 2013 at 10:34:05PM +0200, Pali Rohár 
> wrote:
> > > > > > > --- /dev/null
> > > > > > > +++ b/arch/arm/mach-omap2/board-rx51-camera.c
> > > > > 
> > > > > [...]
> > > > > 
> > > > > > Ping, can you review this patch v2?
> > > > > 
> > > > > I don't think Tony will accept any new board stuff for
> > > > > RX-51/N900. See for example:
> > > > > http://marc.info/?l=linux-kernel&m=137629626213187&w=2
> > > > > 
> > > > > There should be initial Nokia N900 DTS file in 3.12-rc1,
> > > > > and we should continue converting this board fully to
> > > > > DT.
> > > > 
> > > > That's not reasonable. N900 is pretty far away from
> > > > working with device tree. Yes, I was able to get some
> > > > bits merged, but that should not be excuse to halt other
> > > > N900 development.
> > > > 
> > > > 									Pavel
> > > 
> > > Right. So Tony, will you accept future patches for board
> > > files?
> > 
> > Only fixes to board-*.c files please unless there's a _really_
> > good reason to make things more complex with the platform
> > data. Let's not make the DT conversion any more complex than
> > it already is.
> > 
> > Getting things working with DT for the devices is pretty
> > trivial in most cases. And we can also still initialize the
> > legacy devices using platform data the same way as earlier.
> > 
> > Regards,
> > 
> > Tony
> 
> So, what to this with this patch v2 (it was sent 06.03.2013)?
> It adding board support for ADP1653 flash torch which is part of 
> rx51 camera code. Driver itself is already in kernel tree.
> Can you comment/review this patch?

Yeah I'm not taking any more of new platform data like this,
this all is already very trivial to do with device tree
directly in the driver. Adding this would make the pains of
moving to device tree based booting just more of a pain and
guess who has to deal with all of that.

For the hwrng platform data makes still sense even for the
device tree as we don't have any better way currently to do
the SMC callbacks.

Regards,

Tony
