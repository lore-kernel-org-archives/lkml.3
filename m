Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758016AbaISUaR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 16:30:17 -0400
Received: from mail-by2on0125.outbound.protection.outlook.com ([207.46.100.125]:8128
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757740AbaISUaM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 16:30:12 -0400
X-Greylist: delayed 86544 seconds by postgrey-1.27 at vger.kernel.org; Fri, 19 Sep 2014 16:30:12 EDT
Date: Fri, 19 Sep 2014 15:24:53 -0500
From: Kim Phillips <kim.phillips@freescale.com>
To: Yoder Stuart-B08248 <stuart.yoder@freescale.com>
CC: Rivera Jose-B46482 <German.Rivera@freescale.com>,
        Alexander Graf <agraf@suse.de>,
        "<gregkh@linuxfoundation.org>" <gregkh@linuxfoundation.org>,
        "<arnd@arndb.de>" <arnd@arndb.de>,
        "<linux-kernel@vger.kernel.org>" <linux-kernel@vger.kernel.org>,
        Wood Scott-B07421 <scottwood@freescale.com>,
        "<linuxppc-release@linux.freescale.net>" 
	<linuxppc-release@linux.freescale.net>
Subject: Re: [PATCH 1/4] drivers/bus: Added Freescale Management Complex
 APIs
Message-ID: <20140919152453.9a7095a77c0752998ed8621b@freescale.com>
In-Reply-To: <3e06c5d2f97e446c8a9d8d8211c69a3e@CY1PR0301MB0748.namprd03.prod.outlook.com>
References: <1410456864-27890-1-git-send-email-German.Rivera@freescale.com>
	<1410456864-27890-2-git-send-email-German.Rivera@freescale.com>
	<20140915184451.962a3a19c4940792d182f10a@freescale.com>
	<541A5CF1.8000409@freescale.com>
	<C6468126-D7AF-4144-992A-311C642CAD7F@suse.de>
	<20140918152233.41647ee517393816bb35b72a@freescale.com>
	<541B9D5F.20008@freescale.com>
	<20140919121912.197b15bd3b79fb90d7f97602@freescale.com>
	<3e06c5d2f97e446c8a9d8d8211c69a3e@CY1PR0301MB0748.namprd03.prod.outlook.com>
Organization: Freescale Semiconductor, Inc.
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.13; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(24454002)(199003)(189002)(51704005)(26826002)(97736003)(102836001)(68736004)(79102003)(36756003)(83322001)(6806004)(104016003)(50226001)(85306004)(88136002)(85852003)(46406003)(69596002)(77156001)(106466001)(84676001)(100306002)(62966002)(76482002)(81342003)(19580405001)(50986999)(46102003)(81542003)(50466002)(44976005)(83072002)(77982003)(80022003)(107046002)(105606002)(81156004)(20776003)(31966008)(87286001)(95666004)(19580395003)(92726001)(33646002)(89996001)(92566001)(74502003)(21056001)(76176999)(110136001)(4396001)(90102001)(64706001)(74662003)(23726002)(86362001)(99396002)(104166001)(93886004)(93916002)(47776003)(87936001);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR03MB333;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR03MB333;
X-Forefront-PRVS: 0339F89554
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Kim.Phillips@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Sep 2014 14:06:32 -0500
Yoder Stuart-B08248 <stuart.yoder@freescale.com> wrote:

> > > >>>>> +/**
> > > >>>>> + * @brief    Management Complex firmware version information
> > > >>>>> + */
> > > >>>>> +#define MC_VER_MAJOR 2
> > > >>>>> +#define MC_VER_MINOR 0
> > > >>>>
> > > >>>> code should be adjusted to run on all *compatible* versions of h/w,
> > > >>>> not strictly the one set in these defines.
> > > >>> This comment is not precise enough be actionable.
> > > >>> What exactly you want to be changed  here?
> > > >>
> > > >> I think the easy thing to do is to convert the exact version check into a ranged version check: have
> > minimum and maximum versions you support. Or a list of exact versions you support. Or not check for the
> > version at all - or only for the major version and guarantee that the major version indicates backwards
> > compatibility.
> > > >
> > > > yes, this was my point: elsewhere I noticed the code denies to run
> > > > iff those defines are not matched exactly: that code should change
> > > > to run as Alex describes.
> > > >
> > > As I mentioned in the reply to Alex, I will remove the minor version check.
> > 
> > the code should be able to run on all subsequent versions of the
> > h/w, even in the major version case.
> 
> You're right, in the future if there are future major versions we would want this
> same driver to function on multiple versions of the hardware.  But at this
> point in time we don't know what future evolutions there will be and we 
> need the check to error out for now.

why?  We have to make the standard assumption that newer versions
will be backward compatible, in which case the driver should be left
to run.

>   The driver will have to be changed
> in the future to dynamically deal with different versions.
> 
> We could add a TODO in the driver to note that.

"TODO: add support for new h/w versions" is almost universally true
for all drivers, we don't need to write that down.

Support for new h/w versions with new features should be
incrementally added once they're known.

Kim
