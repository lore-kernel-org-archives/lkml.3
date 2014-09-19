Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758104AbaISVa7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 17:30:59 -0400
Received: from mail-bl2on0111.outbound.protection.outlook.com ([65.55.169.111]:5728
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757740AbaISVa6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 17:30:58 -0400
From: Stuart Yoder <stuart.yoder@freescale.com>
To: Kim Phillips <Kim.Phillips@freescale.com>
CC: Jose Rivera <German.Rivera@freescale.com>, Alexander Graf <agraf@suse.de>,
        "<gregkh@linuxfoundation.org>" <gregkh@linuxfoundation.org>,
        "<arnd@arndb.de>" <arnd@arndb.de>,
        "<linux-kernel@vger.kernel.org>" <linux-kernel@vger.kernel.org>,
        Scott Wood <scottwood@freescale.com>,
        "<linuxppc-release@linux.freescale.net>" 
	<linuxppc-release@linux.freescale.net>
Subject: RE: [PATCH 1/4] drivers/bus: Added Freescale Management Complex APIs
Thread-Topic: [PATCH 1/4] drivers/bus: Added Freescale Management Complex APIs
Thread-Index: AQHP0veD82/OvXJh/kGwROtkyAcbyZwG3uaAgAB3uYCAAHB1gIAA7qUAgAAQKlCAACO3gIAAERwQ
Date: Fri, 19 Sep 2014 21:30:54 +0000
Message-ID: <5bb3042da7df488ea01e9869ebc40545@CY1PR0301MB0748.namprd03.prod.outlook.com>
References: <1410456864-27890-1-git-send-email-German.Rivera@freescale.com>
	<1410456864-27890-2-git-send-email-German.Rivera@freescale.com>
	<20140915184451.962a3a19c4940792d182f10a@freescale.com>
	<541A5CF1.8000409@freescale.com>
	<C6468126-D7AF-4144-992A-311C642CAD7F@suse.de>
	<20140918152233.41647ee517393816bb35b72a@freescale.com>
	<541B9D5F.20008@freescale.com>
	<20140919121912.197b15bd3b79fb90d7f97602@freescale.com>
	<3e06c5d2f97e446c8a9d8d8211c69a3e@CY1PR0301MB0748.namprd03.prod.outlook.com>
 <20140919152453.9a7095a77c0752998ed8621b@freescale.com>
In-Reply-To: <20140919152453.9a7095a77c0752998ed8621b@freescale.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [192.88.168.50]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;UriScan:;
x-forefront-prvs: 0339F89554
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(13464003)(199003)(24454002)(189002)(377454003)(51704005)(46102003)(74502003)(101416001)(90102001)(86362001)(92566001)(76176999)(76576001)(4396001)(85306004)(81342003)(80022003)(106116001)(81542003)(74662003)(79102003)(85852003)(66066001)(33646002)(110136001)(77982003)(77096002)(76482002)(19580405001)(106356001)(74316001)(31966008)(83322001)(20776003)(93886004)(107046002)(95666004)(19580395003)(99396002)(105586002)(21056001)(87936001)(2656002)(108616004)(83072002)(97736003)(99286002)(50986999)(54356999)(64706001)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:CY1PR0301MB0713;H:CY1PR0301MB0748.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Kim Phillips [mailto:kim.phillips@freescale.com]
> Sent: Friday, September 19, 2014 3:25 PM
> To: Yoder Stuart-B08248
> Cc: Rivera Jose-B46482; Alexander Graf; <gregkh@linuxfoundation.org>; <arnd@arndb.de>; <linux-
> kernel@vger.kernel.org>; Wood Scott-B07421; <linuxppc-release@linux.freescale.net>
> Subject: Re: [PATCH 1/4] drivers/bus: Added Freescale Management Complex APIs
> 
> On Fri, 19 Sep 2014 14:06:32 -0500
> Yoder Stuart-B08248 <stuart.yoder@freescale.com> wrote:
> 
> > > > >>>>> +/**
> > > > >>>>> + * @brief    Management Complex firmware version information
> > > > >>>>> + */
> > > > >>>>> +#define MC_VER_MAJOR 2
> > > > >>>>> +#define MC_VER_MINOR 0
> > > > >>>>
> > > > >>>> code should be adjusted to run on all *compatible* versions of h/w,
> > > > >>>> not strictly the one set in these defines.
> > > > >>> This comment is not precise enough be actionable.
> > > > >>> What exactly you want to be changed  here?
> > > > >>
> > > > >> I think the easy thing to do is to convert the exact version check into a ranged version check: have
> > > minimum and maximum versions you support. Or a list of exact versions you support. Or not check for the
> > > version at all - or only for the major version and guarantee that the major version indicates backwards
> > > compatibility.
> > > > >
> > > > > yes, this was my point: elsewhere I noticed the code denies to run
> > > > > iff those defines are not matched exactly: that code should change
> > > > > to run as Alex describes.
> > > > >
> > > > As I mentioned in the reply to Alex, I will remove the minor version check.
> > >
> > > the code should be able to run on all subsequent versions of the
> > > h/w, even in the major version case.
> >
> > You're right, in the future if there are future major versions we would want this
> > same driver to function on multiple versions of the hardware.  But at this
> > point in time we don't know what future evolutions there will be and we
> > need the check to error out for now.
> 
> why?  We have to make the standard assumption that newer versions
> will be backward compatible, in which case the driver should be left
> to run.

If future changes are backward compatible then only the minor version changes.  That is
the explicit definition of the meaning of major/minor version for this device.

If the major number changes, then it is not backward compatible and will require
driver changes.  So this "error out" check is temporary until we reach that future
point, where it can be removed and we can hopefully implement dynamic handling
of the incompatibility.

Stuart

