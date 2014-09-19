Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757998AbaISUmI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 16:42:08 -0400
Received: from mail-by2on0115.outbound.protection.outlook.com ([207.46.100.115]:17925
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757483AbaISUmH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 16:42:07 -0400
Message-ID: <1411159315.13320.81.camel@snotra.buserror.net>
Subject: Re: [PATCH 1/4] drivers/bus: Added Freescale Management Complex APIs
From: Scott Wood <scottwood@freescale.com>
To: Alexander Graf <agraf@suse.de>
CC: Kim Phillips <kim.phillips@freescale.com>,
        Yoder Stuart-B08248 <stuart.yoder@freescale.com>,
        Rivera Jose-B46482 <German.Rivera@freescale.com>,
        "<gregkh@linuxfoundation.org>" <gregkh@linuxfoundation.org>,
        "<arnd@arndb.de>" <arnd@arndb.de>,
        "<linux-kernel@vger.kernel.org>" <linux-kernel@vger.kernel.org>,
        "<linuxppc-release@linux.freescale.net>" 
	<linuxppc-release@linux.freescale.net>
Date: Fri, 19 Sep 2014 15:41:55 -0500
In-Reply-To: <541C92F9.1020805@suse.de>
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
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2601:2:5800:3f7:2d6a:b3e0:e03e:359e]
X-ClientProxiedBy: SN2PR10CA0021.namprd10.prod.outlook.com (25.160.12.159) To
 BN1PR0301MB0721.namprd03.prod.outlook.com (25.160.78.140)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0721;
X-Forefront-PRVS: 0339F89554
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(24454002)(189002)(199003)(377424004)(51704005)(42186005)(86362001)(83322001)(92566001)(79102003)(110136001)(107046002)(87976001)(19580405001)(85306004)(33646002)(19580395003)(93916002)(104166001)(77156001)(81342003)(83072002)(81542003)(46102003)(92726001)(85852003)(80022003)(74502003)(77982003)(76482002)(103116003)(93886004)(89996001)(50986999)(50466002)(99396002)(76176999)(77096002)(102836001)(64706001)(97736003)(90102001)(4396001)(31966008)(101416001)(87286001)(95666004)(106356001)(105586002)(74662003)(62966002)(88136002)(47776003)(20776003)(50226001)(23676002)(21056001)(3826002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR0301MB0721;H:[IPv6:2601:2:5800:3f7:2d6a:b3e0:e03e:359e];FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-09-19 at 22:32 +0200, Alexander Graf wrote:
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
> How much is the interface set in stone? Can we indicate to the MC that
> we want version x of the protocol? Then the MC can tell us whether it's
> compatible or not.

I don't trust that new versions will be 100% backwards compatible
(though I hope they will be), but do we normally bother making a driver
refuse to run on newer versions?  Sure, if we need to explicitly match a
comptible string or PCI ID, the match will be rejected if the driver
doesn't know about it, but if it's a version in a register we usually
only check for known issues with certain versions.
 
> >>   The driver will have to be changed
> >> in the future to dynamically deal with different versions.
> >>
> >> We could add a TODO in the driver to note that.
> > 
> > "TODO: add support for new h/w versions" is almost universally true
> > for all drivers, we don't need to write that down.
> > 
> > Support for new h/w versions with new features should be
> > incrementally added once they're known.
> 
> The "version id" is basically the equivalent of the pci device id. We
> don't add wildcards there either for unknown pieces of hardware, so
> limiting to driver to "known good" devices is sane IMHO.

How would you go about adding a wildcard to a PCI ID even if you wanted
to?  Version information on PCI is not separate from device
identification.

-Scott


