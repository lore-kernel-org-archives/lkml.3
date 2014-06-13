Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752952AbaFMHqF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 03:46:05 -0400
Received: from mail-bn1blp0186.outbound.protection.outlook.com ([207.46.163.186]:13699
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751174AbaFMHqD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 03:46:03 -0400
From: Peter Chen <Peter.Chen@freescale.com>
To: "balbi@ti.com" <balbi@ti.com>, Alan Stern <stern@rowland.harvard.edu>
CC: Greg KH <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matt Porter <matt.porter@linaro.org>
Subject: RE: Disable bus's drivers_autoprobe before rootfs has mounted
Thread-Topic: Disable bus's drivers_autoprobe before rootfs has mounted
Thread-Index: AQHPhSbNvHNYX7he+UqiXaXh7d5QNZtrS7gAgAAHBYCAAHPmAIAAh+6AgAFFtICAAB8KgIAA71jw
Date: Fri, 13 Jun 2014 07:30:38 +0000
Message-ID: <646601284e0347799a4e32aa10882e2b@BL2PR03MB226.namprd03.prod.outlook.com>
References: <20140611021439.GA25082@shlinux1.ap.freescale.net>
 <20140611041000.GB15184@kroah.com> <20140611043507.GA30126@saruman.home>
 <20140611032956.GC25082@shlinux1.ap.freescale.net>
 <20140611193627.GA19366@saruman.home>
 <20140612070211.GC18009@shlinux1.ap.freescale.net>
 <20140612165317.GD21753@saruman.home>
In-Reply-To: <20140612165317.GD21753@saruman.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.50]
x-microsoft-antispam: BL:0;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:
x-forefront-prvs: 0241D5F98C
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(428001)(51704005)(189002)(199002)(20776003)(86362001)(92566001)(85852003)(77982001)(64706001)(21056001)(83072002)(76576001)(80022001)(93886003)(105586001)(81342001)(66066001)(83322001)(81542001)(76482001)(46102001)(79102001)(74502001)(74662001)(101416001)(2656002)(33646001)(2171001)(87936001)(99396002)(31966008)(50986999)(99286001)(74316001)(4396001)(54356999)(76176999)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BL2PR03MB225;H:BL2PR03MB226.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Peter.Chen@freescale.com; 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
> > > > I am just worried if we change the behaviour of using gadget
> > > > driver, can it be accepted by user? If you think it can be
> > > > accepted if we can have some docs, we can implement manually
> > > > binding for gadget driver from now on.
> > >
> > > user shouldn't have to deal with direct module insertion/removal
> > > (unless he's a developer and actually *wants* to do that). Docs are
> > > already in tree. The entire configfs interface has been documented,
> > > it's based on those documents that Matt started writing libusbg.
> > >
> > > --
> > > balbi
> >
> > Yes, gadget-configfs is a good direction.
> >
> > I would like to know your plan for other gadget drivers
> > (g_mass_storage, g_webcam, etc)
> 
> they can be built dynamically too. We only provided a version of
> g_mass_storage in order to avoid regressions. We can't simply remove that
> driver from the kernel.
> 
> > All functions will be supported by configfs in future, and current
> > driver will be deleted?
> 
> I don't think we will be able to delete legacy drivers, but they're all
> supported through configfs. I guess only webcam is missing.
> 
> > - If yes, how to cover the user who still use the old file system?
> > - If no, which binding way for udc and gadget driver will be used?
> 
> going forward, we want to stick with configfs.
> 

ok, then, what's the plan for current bug for legacy gadget driver (eg, we
can't load gadget driver before udc is ready)? I know this bug is existed
from 3.10, we may need to at least 1 year for switch to configfs, it
includes lots of user habit problems. The user will complaint this problem
for more than 2 years. 

If you think we should fix this bug before we totally switch to configfs, I will
continue to enhancement my gadget bus implementation,
and let it support configfs and legacy gadget driver well.

Peter
 
