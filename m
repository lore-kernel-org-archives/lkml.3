Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932357AbaISVh1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 17:37:27 -0400
Received: from mail-bn1on0134.outbound.protection.outlook.com ([157.56.110.134]:12997
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932195AbaISVh0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 17:37:26 -0400
From: Stuart Yoder <stuart.yoder@freescale.com>
To: Alexander Graf <agraf@suse.de>, Kim Phillips <Kim.Phillips@freescale.com>
CC: Jose Rivera <German.Rivera@freescale.com>,
        "<gregkh@linuxfoundation.org>" <gregkh@linuxfoundation.org>,
        "<arnd@arndb.de>" <arnd@arndb.de>,
        "<linux-kernel@vger.kernel.org>" <linux-kernel@vger.kernel.org>,
        Scott Wood <scottwood@freescale.com>,
        "<linuxppc-release@linux.freescale.net>" 
	<linuxppc-release@linux.freescale.net>,
        "nir.erez@freescale.com" <nir.erez@freescale.com>
Subject: RE: [PATCH 1/4] drivers/bus: Added Freescale Management Complex APIs
Thread-Topic: [PATCH 1/4] drivers/bus: Added Freescale Management Complex APIs
Thread-Index: AQHP0veD82/OvXJh/kGwROtkyAcbyZwG3uaAgAB3uYCAAHB1gIAA7qUAgAAQKlCAACO3gIAAAkGAgAAQT/A=
Date: Fri, 19 Sep 2014 21:37:20 +0000
Message-ID: <9b652c60dd604df5b56c1fd2f2695881@CY1PR0301MB0748.namprd03.prod.outlook.com>
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
 <541C92F9.1020805@suse.de>
In-Reply-To: <541C92F9.1020805@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [192.88.168.50]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;UriScan:;UriScan:;
x-forefront-prvs: 0339F89554
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(24454002)(189002)(13464003)(51704005)(199003)(377454003)(105586002)(46102003)(99286002)(108616004)(79102003)(76576001)(76176999)(87936001)(95666004)(85852003)(86362001)(97736003)(31966008)(19580395003)(74662003)(83072002)(106116001)(33646002)(99396002)(64706001)(107046002)(77096002)(20776003)(93886004)(106356001)(81542003)(76482002)(66066001)(90102001)(77982003)(74502003)(19580405001)(21056001)(83322001)(74316001)(85306004)(80022003)(92566001)(50986999)(101416001)(81342003)(2656002)(4396001)(54356999)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:CY1PR0301MB0715;H:CY1PR0301MB0748.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Alexander Graf [mailto:agraf@suse.de]
> Sent: Friday, September 19, 2014 3:33 PM
> To: Phillips Kim-R1AAHA; Yoder Stuart-B08248
> Cc: Rivera Jose-B46482; <gregkh@linuxfoundation.org>; <arnd@arndb.de>; <linux-kernel@vger.kernel.org>; Wood
> Scott-B07421; <linuxppc-release@linux.freescale.net>
> Subject: Re: [PATCH 1/4] drivers/bus: Added Freescale Management Complex APIs
> 
> 
> 
> On 19.09.14 22:24, Kim Phillips wrote:
> > On Fri, 19 Sep 2014 14:06:32 -0500
> > Yoder Stuart-B08248 <stuart.yoder@freescale.com> wrote:
> >
> >>>>>>>>> +/**
> >>>>>>>>> + * @brief    Management Complex firmware version information
> >>>>>>>>> + */
> >>>>>>>>> +#define MC_VER_MAJOR 2
> >>>>>>>>> +#define MC_VER_MINOR 0
> >>>>>>>>
> >>>>>>>> code should be adjusted to run on all *compatible* versions of h/w,
> >>>>>>>> not strictly the one set in these defines.
> >>>>>>> This comment is not precise enough be actionable.
> >>>>>>> What exactly you want to be changed  here?
> >>>>>>
> >>>>>> I think the easy thing to do is to convert the exact version check into a ranged version check: have
> >>> minimum and maximum versions you support. Or a list of exact versions you support. Or not check for the
> >>> version at all - or only for the major version and guarantee that the major version indicates backwards
> >>> compatibility.
> >>>>>
> >>>>> yes, this was my point: elsewhere I noticed the code denies to run
> >>>>> iff those defines are not matched exactly: that code should change
> >>>>> to run as Alex describes.
> >>>>>
> >>>> As I mentioned in the reply to Alex, I will remove the minor version check.
> >>>
> >>> the code should be able to run on all subsequent versions of the
> >>> h/w, even in the major version case.
> >>
> >> You're right, in the future if there are future major versions we would want this
> >> same driver to function on multiple versions of the hardware.  But at this
> >> point in time we don't know what future evolutions there will be and we
> >> need the check to error out for now.
> >
> > why?  We have to make the standard assumption that newer versions
> > will be backward compatible, in which case the driver should be left
> > to run.
> 
> How much is the interface set in stone?

It is set in stone, in that a particular version has an specific set of
commands.

> Can we indicate to the MC that
> we want version x of the protocol? Then the MC can tell us whether it's
> compatible or not.

No, it's not that clever.  For the DPRC object there is a set of commands
with a binary interface. The major/minor version number tell us what version
of the hw object we are dealing with...what commands are there, what version
of the binary interface is there.

Stuart
