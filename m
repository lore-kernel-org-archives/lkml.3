Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757828AbaISTGh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 15:06:37 -0400
Received: from mail-bl2on0103.outbound.protection.outlook.com ([65.55.169.103]:57440
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757476AbaISTGg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 15:06:36 -0400
From: Stuart Yoder <stuart.yoder@freescale.com>
To: Kim Phillips <Kim.Phillips@freescale.com>,
        Jose Rivera <German.Rivera@freescale.com>
CC: Alexander Graf <agraf@suse.de>,
        "<gregkh@linuxfoundation.org>" <gregkh@linuxfoundation.org>,
        "<arnd@arndb.de>" <arnd@arndb.de>,
        "<linux-kernel@vger.kernel.org>" <linux-kernel@vger.kernel.org>,
        Scott Wood <scottwood@freescale.com>,
        "<linuxppc-release@linux.freescale.net>" 
	<linuxppc-release@linux.freescale.net>
Subject: RE: [PATCH 1/4] drivers/bus: Added Freescale Management Complex APIs
Thread-Topic: [PATCH 1/4] drivers/bus: Added Freescale Management Complex APIs
Thread-Index: AQHP0veD82/OvXJh/kGwROtkyAcbyZwG3uaAgAB3uYCAAHB1gIAA7qUAgAAQKlA=
Date: Fri, 19 Sep 2014 19:06:32 +0000
Message-ID: <3e06c5d2f97e446c8a9d8d8211c69a3e@CY1PR0301MB0748.namprd03.prod.outlook.com>
References: <1410456864-27890-1-git-send-email-German.Rivera@freescale.com>
	<1410456864-27890-2-git-send-email-German.Rivera@freescale.com>
	<20140915184451.962a3a19c4940792d182f10a@freescale.com>
	<541A5CF1.8000409@freescale.com>
	<C6468126-D7AF-4144-992A-311C642CAD7F@suse.de>
	<20140918152233.41647ee517393816bb35b72a@freescale.com>
	<541B9D5F.20008@freescale.com>
 <20140919121912.197b15bd3b79fb90d7f97602@freescale.com>
In-Reply-To: <20140919121912.197b15bd3b79fb90d7f97602@freescale.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [192.88.168.50]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;UriScan:;
x-forefront-prvs: 0339F89554
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(199003)(51704005)(189002)(87936001)(85852003)(77096002)(95666004)(83072002)(4396001)(2656002)(97736003)(31966008)(83322001)(21056001)(74316001)(64706001)(99286002)(90102001)(106116001)(54356999)(66066001)(76176999)(105586002)(20776003)(85306004)(50986999)(93886004)(101416001)(106356001)(107046002)(86362001)(76576001)(92566001)(76482002)(74662003)(46102003)(80022003)(79102003)(81542003)(33646002)(108616004)(99396002)(77982003)(74502003)(81342003)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:CY1PR0301MB0731;H:CY1PR0301MB0748.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > >>>>> +/**
> > >>>>> + * @brief    Management Complex firmware version information
> > >>>>> + */
> > >>>>> +#define MC_VER_MAJOR 2
> > >>>>> +#define MC_VER_MINOR 0
> > >>>>
> > >>>> code should be adjusted to run on all *compatible* versions of h/w,
> > >>>> not strictly the one set in these defines.
> > >>> This comment is not precise enough be actionable.
> > >>> What exactly you want to be changed  here?
> > >>
> > >> I think the easy thing to do is to convert the exact version check into a ranged version check: have
> minimum and maximum versions you support. Or a list of exact versions you support. Or not check for the
> version at all - or only for the major version and guarantee that the major version indicates backwards
> compatibility.
> > >
> > > yes, this was my point: elsewhere I noticed the code denies to run
> > > iff those defines are not matched exactly: that code should change
> > > to run as Alex describes.
> > >
> > As I mentioned in the reply to Alex, I will remove the minor version check.
> 
> the code should be able to run on all subsequent versions of the
> h/w, even in the major version case.

You're right, in the future if there are future major versions we would want this
same driver to function on multiple versions of the hardware.  But at this
point in time we don't know what future evolutions there will be and we 
need the check to error out for now.   The driver will have to be changed
in the future to dynamically deal with different versions.

We could add a TODO in the driver to note that.

Stuart
