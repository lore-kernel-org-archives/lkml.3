Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753783AbaFEBaT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 21:30:19 -0400
Received: from mail-bn1blp0185.outbound.protection.outlook.com ([207.46.163.185]:54053
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753032AbaFEBaQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 21:30:16 -0400
From: Peter Chen <Peter.Chen@freescale.com>
To: Alan Stern <stern@rowland.harvard.edu>,
        "Yang,Wei" <Wei.Yang@windriver.com>
CC: Michal Nazarewicz <mina86@mina86.com>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Felipe Balbi <balbi@ti.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v1] USB:gadget: Fix a warning while loading g_mass_storage
Thread-Topic: [PATCH v1] USB:gadget: Fix a warning while loading
 g_mass_storage
Thread-Index: AQHPfw914N6/1BltqEeVaM9JvGUSI5tfd7eAgACwf4CAAAVUAIAAGvUAgACy+wCAAL/hUA==
Date: Thu, 5 Jun 2014 01:30:12 +0000
Message-ID: <82bb5df19e9047298f4e80aa870cceec@BL2PR03MB226.namprd03.prod.outlook.com>
References: <538E8F70.2010600@windriver.com>
 <Pine.LNX.4.44L0.1406040953400.15745-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1406040953400.15745-100000@netrider.rowland.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.88.158.211]
x-microsoft-antispam: BL:0;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:
x-forefront-prvs: 0233768B38
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(428001)(51704005)(377454003)(479174003)(189002)(199002)(24454002)(83072002)(76576001)(92566001)(4396001)(86362001)(33646001)(79102001)(81542001)(101416001)(64706001)(81342001)(2656002)(85852003)(66066001)(80022001)(2171001)(50986999)(20776003)(87936001)(77982001)(76176999)(54356999)(83322001)(19580405001)(76482001)(19580395003)(46102001)(21056001)(74316001)(31966008)(99396002)(74502001)(74662001)(99286001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BL2PR03MB228;H:BL2PR03MB226.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Peter.Chen@freescale.com; 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
> On Wed, 4 Jun 2014, Yang,Wei wrote:
> 
> > On 06/04/2014 09:45 AM, Peter Chen wrote:
> > >
> > >> commit d18f7116a5ddb8263fe62b05ad63e5ceb5875791
> > >> Author: Robert Baldyga <r.baldyga@samsung.com>
> > >> Date:   Thu Nov 21 13:49:18 2013 +0100
> > >>
> > >>       usb: gadget: s3c-hsotg: fix disconnect handling
> > >>
> > >>       This patch moves s3c_hsotg_disconnect function call from
> > >> USBSusp interrupt
> > >>       handler to SET_ADDRESS request handler.
> > >>
> > > It is a little strange we call gadget's disconnect at SET_ADDRESS?
> > > How the udc calls gadget driver the disconnection has happened when
> > > the usb cable is disconnected from the host?
> > >
> > > Usually, we call gadget's disconnect at two situations
> > >
> > > - udc's reset handler if udc's speed is not UNKNOWN, it is usually
> > > happened when the host sends reset after enumeration.
> > > - udc's disconnect handler, it is usually happened when the usb
> > > cable is disconnected from host.
> >
> > Hmm, usually the two situations, but according to the commit log, s3c
> > hsotg does not support Disconnected interrupt for device mode, so the
> > second situation does not happen for s3c hsotg, therefore, he has to
> > disconnect the connection before it is connected again.
> 
> Why does he need to do that?  Why not just skip the disconnect
> notification if the hardware can't detect a disconnect?
> 

We must call gadget driver's disconnect, otherwise, there at least
has a warning when unload module, please refer to __composite_unbind
at drivers/usb/gadget/composite.c

Peter

> It makes no sense at all to call a disconnect handler from within the
> SET_ADDRESS routine.
> 
> Alan Stern

