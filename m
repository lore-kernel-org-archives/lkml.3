Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312AbaFKEze (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 00:55:34 -0400
Received: from mail-by2lp0237.outbound.protection.outlook.com ([207.46.163.237]:18241
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751245AbaFKEzV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 00:55:21 -0400
Date: Wed, 11 Jun 2014 11:29:57 +0800
From: Peter Chen <peter.chen@freescale.com>
To: Felipe Balbi <balbi@ti.com>
CC: Greg KH <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Matt Porter <matt.porter@linaro.org>
Subject: Re: Disable bus's drivers_autoprobe before rootfs has mounted
Message-ID: <20140611032956.GC25082@shlinux1.ap.freescale.net>
References: <20140611021439.GA25082@shlinux1.ap.freescale.net>
 <20140611041000.GB15184@kroah.com> <20140611043507.GA30126@saruman.home>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140611043507.GA30126@saruman.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(199002)(51704005)(24454002)(81342001)(81542001)(99396002)(68736004)(21056001)(84676001)(83072002)(23726002)(87936001)(26826002)(102836001)(46406003)(85852003)(104016001)(83506001)(97736001)(54356999)(76176999)(50986999)(97756001)(20776003)(31966008)(46102001)(92726001)(74662001)(92566001)(74502001)(76482001)(86362001)(50466002)(77982001)(47776003)(64706001)(77096999)(80022001)(33656002)(6806004)(83322001)(44976005)(4396001)(79102001);DIR:OUT;SFP:;SCL:1;SRVR:BN1PR0301MB0625;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BL:0;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:
X-Forefront-PRVS: 0239D46DB6
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Peter.Chen@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2014 at 11:35:07PM -0500, Felipe Balbi wrote:
> Hi,
> 
> On Tue, Jun 10, 2014 at 09:10:00PM -0700, Greg KH wrote:
> > > Let's take USB peripheral as an example, there is a device for
> > > udc, and a device driver for usb gadget driver, at default, we want
> > > the device to be bound to driver automatically, this is what
> > > we have done now. But if there are more than one udcs and gadget
> > > drivers (eg one B port for mass storage, another B port for usb ethernet),
> > > the user may want to have specific binding (eg, udc-0 -> mass storage,
> > > udc-1 -> usb ethernet), so the binding will be established
> > > after rootfs has mounted. (This feature is implementing)
> > 
> > Then there better be a way to describe this on the kernel command line
> > (i.e. module paramaters), right?  Which is a total mess, why not just
> > not bind anything in this case and let the user pick what they want?
> 
> you can also blacklist all gadget drivers and manually probe them or -
> get this - you can refrain from using gadget drivers and use libusbg to
> build the gadget drivers out of raw usb functions, then bind them to the
> UDC of your liking.
> 

I am just worried if we change the behaviour of using gadget driver,
can it be accepted by user? If you think it can be accepted if we can
have some docs, we can implement manually binding for gadget driver
from now on.

-- 

Best Regards,
Peter Chen
