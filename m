Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752661AbaFMKPn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 06:15:43 -0400
Received: from mail-bn1blp0187.outbound.protection.outlook.com ([207.46.163.187]:4932
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751449AbaFMKPl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 06:15:41 -0400
From: Peter Chen <Peter.Chen@freescale.com>
To: Alan Stern <stern@rowland.harvard.edu>
CC: Felipe Balbi <balbi@ti.com>, Greg KH <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: Disable bus's drivers_autoprobe before rootfs has mounted
Thread-Topic: Disable bus's drivers_autoprobe before rootfs has mounted
Thread-Index: AQHPhSbNvHNYX7he+UqiXaXh7d5QNZtrS7gAgAB5FQCAAIJ0gIAABLyAgAE/lgD///rvAIABTkkg
Date: Fri, 13 Jun 2014 10:15:38 +0000
Message-ID: <fa47f0c3798b48c781bc0a8c344e6c57@BL2PR03MB226.namprd03.prod.outlook.com>
References: <20140612063104.GB18009@shlinux1.ap.freescale.net>
 <Pine.LNX.4.44L0.1406121003370.1138-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1406121003370.1138-100000@iolanthe.rowland.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.50]
x-microsoft-antispam: BL:0;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:
x-forefront-prvs: 0241D5F98C
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(428001)(189002)(199002)(51704005)(99396002)(87936001)(74502001)(76482001)(46102001)(79102001)(2171001)(101416001)(74662001)(2656002)(33646001)(15975445006)(74316001)(99286001)(54356999)(76176999)(4396001)(50986999)(31966008)(76576001)(83072002)(86362001)(92566001)(85852003)(20776003)(64706001)(21056001)(77982001)(81342001)(66066001)(81542001)(83322001)(19580395003)(15202345003)(80022001)(105586001)(21314002)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BL2PR03MB225;H:BL2PR03MB226.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Peter.Chen@freescale.com; 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
> 
> > > Peter, correct me if this is wrong.  It sounds like you want to have
> > > a way for the user to control which gadget driver gets bound to
> > > which UDC driver when everything is compiled into the kernel,
> > > nothing is built as a separate module.  Is that the basic idea?
> >
> > Yes, I know it can be done by gadget-configfs, but how about the user
> > chooses other gadgets, eg: g_webcam, g_audio?
> >
> > I forget to introduce the background of this topic, I have this issue
> > when I implement gadget bus patch set.
> > (http://www.spinics.net/lists/linux-usb/msg107797.html)
> > The current behaviour for other gadgets is auto-binding, so I want to
> > keep auto-binding at my gadget bus implementation, but manual-binding
> > is also a feature we need to support for other gadgets, so I want
> > auto-binding is the default binding way, and the user can switch the
> > two binding ways, eg, module parameters or sys entry.
> >
> > But if both udc driver and gadget driver are built in, the user can't
> > let manual-binding work during the boot since the device-model will do
> > probe, and do auto-binding.
> >
> > My v1 patch set [3/4] do a tricky way to work around it, I would like
> > to know if it can be supported by device model framework?
> 
> I think we can keep everything a lot simpler.  Let's agree that the old
> non-composite gadget drivers (like g_ether, g_mass_storage, and so on)
> should only be used one at a time.  That is, there should never be more
> than one of them compiled into the kernel or loaded as a module, and they
> shouldn't be used if there is more than one unbound UDC.
> 
> If a user wants to work with more than one UDC or more than one gadget
> driver then he should use function drivers with the configfs interface
> (or functionfs or gadgetfs or whatever).
> 
> Does that seem reasonable?  It doesn't solve your problem so much as
> declare it an unsupported case, but I don't think there is any reasonable
> way to solve the problem without using something like configfs.
> 

OK, we can keep our g_xxx gadget driver just support the basic feature. But
the bug that causes gadget driver load fail due to udc is probed deferral should
be fixed, do you think so, we can't wait until configfs has total been ready.

Peter

