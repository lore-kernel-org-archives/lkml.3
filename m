Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932775AbaFLH4v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 03:56:51 -0400
Received: from mail-bn1lp0139.outbound.protection.outlook.com ([207.46.163.139]:31060
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932501AbaFLH4u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 03:56:50 -0400
Date: Thu, 12 Jun 2014 14:31:05 +0800
From: Peter Chen <peter.chen@freescale.com>
To: Alan Stern <stern@rowland.harvard.edu>, Felipe Balbi <balbi@ti.com>
CC: Greg KH <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: Disable bus's drivers_autoprobe before rootfs has mounted
Message-ID: <20140612063104.GB18009@shlinux1.ap.freescale.net>
References: <20140611191017.GA15120@kroah.com>
 <Pine.LNX.4.44L0.1406111520270.890-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1406111520270.890-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(24454002)(51704005)(189002)(199002)(74502001)(87936001)(74662001)(31966008)(92566001)(6806004)(19580395003)(44976005)(92726001)(83322001)(77096999)(86362001)(54356999)(50986999)(83072002)(76176999)(85852003)(2171001)(102836001)(104016001)(26826002)(97736001)(97756001)(15975445006)(68736004)(84676001)(83506001)(99396002)(46406003)(4396001)(15202345003)(77982001)(46102001)(76482001)(80022001)(79102001)(20776003)(47776003)(64706001)(33656002)(50466002)(21056001)(81342001)(81542001)(23726002);DIR:OUT;SFP:;SCL:1;SRVR:BN1PR0301MB0626;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BL:0;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:
X-Forefront-PRVS: 02408926C4
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Peter.Chen@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2014 at 03:27:13PM -0400, Alan Stern wrote:
> On Wed, 11 Jun 2014, Greg KH wrote:
> 
> > We can't break existing systems, so I don't understand the issue here.
> > Just don't configure your kernel for a system you don't have / want,
> > right?
> > 
> > > > > From what I read code, we can't implement above feature, but I may
> > > > > be wrong, if you have some solutions, give me some hints please.
> > > > > If there is no solution for above feature, do we agree with exporting
> > > > > .drivers_autoprobe for bus driver or something similar?
> > > > 
> > > > I don't understand what you mean by this, care to show me with code?
> > > 
> > > I mean the individual bus driver can't change bus->p->drivers_autoprobe?
> > > bus->p->drivers_autoprobe is handled at drivers/base/bus.c.
> > > 
> > > If the individual bus driver can change bus->p->drivers_autoprobe, we
> > > can disable autoprobe (auto-binding) during booting.
> > 
> > No, that's a core only thing.
> 
> Peter, correct me if this is wrong.  It sounds like you want to have a 
> way for the user to control which gadget driver gets bound to which UDC 
> driver when everything is compiled into the kernel, nothing is built 
> as a separate module.  Is that the basic idea?

Yes, I know it can be done by gadget-configfs, but how about the user
chooses other gadgets, eg: g_webcam, g_audio?

I forget to introduce the background of this topic, I have this issue
when I implement gadget bus patch set.
(http://www.spinics.net/lists/linux-usb/msg107797.html)
The current behaviour for other gadgets is auto-binding, so I want
to keep auto-binding at my gadget bus implementation, but manual-binding
is also a feature we need to support for other gadgets, so I
want auto-binding is the default binding way, and the user can switch
the two binding ways, eg, module parameters or sys entry.

But if both udc driver and gadget driver are built in, the user can't
let manual-binding work during the boot since the device-model will
do probe, and do auto-binding.

My v1 patch set [3/4] do a tricky way to work around it, I would like to
know if it can be supported by device model framework?

> 
> This shouldn't be a problem if you use configfs or libusbg.
> 
> Alan Stern
> 

-- 

Best Regards,
Peter Chen
