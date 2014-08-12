Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505AbaHLSDe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 14:03:34 -0400
Received: from [207.46.163.142] ([207.46.163.142]:23091 "EHLO
	na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752765AbaHLSDd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 14:03:33 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dexuan Cui <decui@microsoft.com>, Vojtech Pavlik <vojtech@suse.cz>
CC: Greg KH <gregkh@linuxfoundation.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: [PATCH] Input: serio: make HYPERV_KEYBOARD depend on
 SERIO_I8042=y
Thread-Topic: [PATCH] Input: serio: make HYPERV_KEYBOARD depend on
 SERIO_I8042=y
Thread-Index: AQHPtdURKhRh2vngR0qUNwc31sHvgZvMTW8AgAAp0QCAAAK0AIAAFMGAgACylYCAAABHUA==
Date: Tue, 12 Aug 2014 18:01:54 +0000
Message-ID: <423148fadd52409a95064eca25e71340@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <1407814240-4275-1-git-send-email-decui@microsoft.com>
 <20140812032148.GB6867@kroah.com>
 <EE124450C0AAF944A40DD71E61F878C9920A1C@SINEX14MBXC417.southpacific.corp.microsoft.com>
 <20140812060108.GA13231@kroah.com>
 <EE124450C0AAF944A40DD71E61F878C9920EAF@SINEX14MBXC417.southpacific.corp.microsoft.com>
 <20140812175435.GA22386@core.coreip.homeip.net>
In-Reply-To: <20140812175435.GA22386@core.coreip.homeip.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [131.107.192.56]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;UriScan:;
x-o365ent-eop-header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
x-forefront-prvs: 0301360BF5
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(51704005)(377454003)(189002)(13464003)(199003)(24454002)(86362001)(85306004)(1511001)(77982001)(561944003)(66066001)(79102001)(46102001)(93886004)(83072002)(77096002)(74316001)(85852003)(76576001)(64706001)(2656002)(108616004)(76482001)(20776003)(4396001)(101416001)(92566001)(86612001)(95666004)(99286002)(107046002)(106116001)(74502001)(31966008)(74662001)(19580405001)(105586002)(19580395003)(81342001)(83322001)(54356999)(33646002)(87936001)(106356001)(80022001)(99396002)(21056001)(81542001)(76176999)(50986999)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR0301MB0711;H:BY2PR0301MB0711.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Dmitry Torokhov [mailto:dmitry.torokhov@gmail.com]
> Sent: Tuesday, August 12, 2014 10:55 AM
> To: Dexuan Cui
> Cc: Greg KH; linux-input@vger.kernel.org; linux-kernel@vger.kernel.org;
> driverdev-devel@linuxdriverproject.org; olaf@aepfle.de;
> apw@canonical.com; jasowang@redhat.com; KY Srinivasan; Haiyang Zhang
> Subject: Re: [PATCH] Input: serio: make HYPERV_KEYBOARD depend on
> SERIO_I8042=y
> 
> On Tue, Aug 12, 2014 at 07:15:25AM +0000, Dexuan Cui wrote:
> > > -----Original Message-----
> > > From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> > > owner@vger.kernel.org] On Behalf Of Greg KH
> > > > > What exactly needs to be done to fix this "correctly" that is
> > > > > going to take too much work at the moment?
> > > >
> > > > To decouple the dependency between the hyperv-keyboard and i8042
> > > > modules, I suppose we probably have to re-implement
> > > > hyperv-keyboard by using input_allocate_device(),
> > > > input_register_device(), and using
> > > > input_report_key() to pass the key strokes to the high level.
> > >
> > > Yes, that would be the best thing to do,
> 
> Why? The backend still delivers AT keyboard data, so why does it make sense
> to write a new driver instead of making sure you can load
> atkbd/libps2 even without i8042 loaded?
> 
> > > and shouldn't be that hard to
> > > create an input driver, it's pretty simple code, right?
> > Hi Greg,
> > Thanks for the confirmation!
> > I didn't use the APIs before.
> > I think I need a couple of days to code, test and debug it while I
> > have many  things at hand at present. :-(
> >
> > > > I'll have to need some time for further investigation and a new
> > > > implementation. Before the new code is completely ready, IMHO the
> > > > patch can help to avoid a bad user experience like Arch Linux
> > > > working as a Generation 2 hyper-v guest.
> > >
> > > You are still preventing Arch from working here, as the driver can't
> > > be built at all, right?
> > The driver can build(compile) fine.
> > The issue is: the latest Arch Linux release doesn't have a working
> > (virtual) keyboard when it runs as Generation 2 hyper-v guest -- when
> > it runs as a "traditional" Generation 1 hyper-v guest, everything works fine.
> > I hope this patch can temporarily help Arch users if they find the
> > issue and if they can rebuild the kernel.
> 
> The Arch users can simply select to build i8042 into the kernel as a
> workaround.
> 
> The proper solution is to allow loading libps2 module even if i8042 did not find
> its device. I wish I could simply drop this i8042_lock_chip and stuff, but
> unfortunately i8042 ports are not truly independent. We need to figure a
> way for libps2 to engage locking in i8042 if the driver is loaded, otherwise just
> ignore it.

When I first wrote this driver, we took the decision not to replicate all the code in the at keyboard driver and to
make this  a serio based driver. I like the proposal made by Dmitry here.

Regards,

K. Y
