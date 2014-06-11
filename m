Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753222AbaFKEsq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 00:48:46 -0400
Received: from dns-bn1lp0143.outbound.protection.outlook.com ([207.46.163.143]:4104
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751260AbaFKEsp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 00:48:45 -0400
Date: Wed, 11 Jun 2014 11:23:23 +0800
From: Peter Chen <peter.chen@freescale.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: Disable bus's drivers_autoprobe before rootfs has mounted
Message-ID: <20140611032322.GB25082@shlinux1.ap.freescale.net>
References: <20140611021439.GA25082@shlinux1.ap.freescale.net>
 <20140611041000.GB15184@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140611041000.GB15184@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199002)(24454002)(189002)(51704005)(47776003)(21056001)(92726001)(20776003)(102836001)(4396001)(46406003)(23726002)(83322001)(76482001)(99396002)(64706001)(44976005)(92566001)(76176999)(77096999)(54356999)(6806004)(50986999)(74662001)(46102001)(83506001)(77982001)(97756001)(80022001)(81542001)(97736001)(31966008)(79102001)(26826002)(84676001)(86362001)(33656002)(50466002)(68736004)(85852003)(83072002)(104016001)(87936001)(74502001)(81342001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR0301MB0630;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BL:0;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:
X-Forefront-PRVS: 0239D46DB6
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Peter.Chen@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2014 at 09:10:00PM -0700, Greg KH wrote:
> On Wed, Jun 11, 2014 at 10:14:40AM +0800, Peter Chen wrote:
> > Hi Greg,
> > 
> > Currently, we can't disable auto probe function during booting
> > if both device and device driver register code are built in due
> > to .drivers_autoprobe is a private value for bus core and this
> > value can only be changed by sys entry.
> 
> Then don't build them into the kernel :)
> 
> > It causes we can't implement feature that the user can choose
> > manual binding and auto binding through module parameters.
> 
> Wait, you just asked about building the stuff into the kernel, not a
> module.

Yes, build the code into the kernel.
> 
> > Eg, the default binding is automatic, but the user can override
> > it by module parameter.
> 
> Do we do that for any other "bus" anywhere?

I don't know.

> 
> > Let's take USB peripheral as an example, there is a device for
> > udc, and a device driver for usb gadget driver, at default, we want
> > the device to be bound to driver automatically, this is what
> > we have done now. But if there are more than one udcs and gadget
> > drivers (eg one B port for mass storage, another B port for usb ethernet),
> > the user may want to have specific binding (eg, udc-0 -> mass storage,
> > udc-1 -> usb ethernet), so the binding will be established
> > after rootfs has mounted. (This feature is implementing)
> 
> Then there better be a way to describe this on the kernel command line
> (i.e. module paramaters), right?  Which is a total mess, why not just
> not bind anything in this case and let the user pick what they want?

If the user is used to do nothing at rootfs for current or earlier kernel,
Is it ok we change the driver's behaviour and a sys entry is mandatory
for user?

> 
> > From what I read code, we can't implement above feature, but I may
> > be wrong, if you have some solutions, give me some hints please.
> > If there is no solution for above feature, do we agree with exporting
> > .drivers_autoprobe for bus driver or something similar?
> 
> I don't understand what you mean by this, care to show me with code?

I mean the individual bus driver can't change bus->p->drivers_autoprobe?
bus->p->drivers_autoprobe is handled at drivers/base/bus.c.

If the individual bus driver can change bus->p->drivers_autoprobe, we
can disable autoprobe (auto-binding) during booting.

-- 

Best Regards,
Peter Chen
