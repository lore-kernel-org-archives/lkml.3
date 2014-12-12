Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965576AbaLLJv7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 04:51:59 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:45207 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934514AbaLLJv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 04:51:56 -0500
Date: Fri, 12 Dec 2014 10:51:54 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Sebastian Reichel <sre@debian.org>, Sebastian Reichel <sre@ring0.de>,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>, khilman@kernel.org,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        =?utf-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<ivo.g.dimitrov.75@gmail.com>,
        "Gustavo F. Padovan" <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-bluetooth@vger.kernel.org
Subject: Re: __hci_cmd_sync() not suitable for nokia h4p
Message-ID: <20141212095153.GB2905@amd>
References: <20141209190210.GA15641@amd>
 <304050AD-DB11-4A2B-A1F7-8B1BBB5F04F0@holtmann.org>
 <20141209201328.GA18003@amd>
 <7EFD3C33-E503-4FB6-BCCF-52836080ABD6@holtmann.org>
 <20141210131519.GA14748@amd>
 <EE1A4B9D-30D5-4BD9-9A43-532619494A0C@holtmann.org>
 <20141211221306.GA2905@amd>
 <CAA1630D-1A2E-4D3D-9BBC-2EE86256D58B@holtmann.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA1630D-1A2E-4D3D-9BBC-2EE86256D58B@holtmann.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >>>> What needs to be done is the bring up of the device including the proper UART settings and speed and then just run the firmware downloads. All firmware files on the Nokia devices where just HCI commands with vendor specific details. Some from CSR, some from Broadcom and some from TI. You can actually decode them if you really want to. Shouldn't be that hard.
> >>>> 
> >>> 
> >>> Speed changes at the end of firmware load, but I guess that's detail?
> >>> Anyway, patch would look like this.
> >> 
> >> You should really look into providing hdev->setup() callback. That is normally the callback where you want to load the firmware.
> >> 
> > 
> > I can provide setup() callback and load firmware from there.
> > 
> > I have created provisional device tree binding, and the driver still
> > works.
> > 
> > Some time ago you mentioned that with the "big" issues fixed, you'd be
> > willing to take it into the tree. What way forward do you see? Would
> > it make sense to re-enable the driver in staging, so that "big"
> > changes could be applied, followed by renames?
> 
> If the driver is clean, there is no point in taking it through staging. It can be cleaned up and then merged all together.
>

Ok, so you can revert a4102f90e87cfaa3fdbed6fdf469b23f0eeb4bfd in your
tree, and I can post patches against that?

> I think the important part is to focus on the N900 derivative with
>the Broadcom chip inside. And just ignore all the rest. So start
>small and do not try to carry the N770, N800, N810 hacks over.

Well, I did remove non-relevant firmware loaders, and I can remove the
switches for different firmware loaders, too, but spending time
removing support for different hardware does not sound quite right.

> However you might want to check Neil Brown's patches for TTY-slave
>devices he just posted. Maybe the N900 devices should be exposed as
>TTY and we just attach N_HCI line discipline to it. If all the GPIO
>wiggling can be done automatically at TTY open, then that should be
>the way to go. I also send an email about using the new unconfigured
>stage to get this done cleanly.

I seen them, but they don't help, I'm afraid. The GPIOs are used for
power saving, and they are used in various places including the serial
irq handler.

Best regards,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
