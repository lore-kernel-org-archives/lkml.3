Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756708Ab3LSXJA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 18:09:00 -0500
Received: from mail-by2lp0238.outbound.protection.outlook.com ([207.46.163.238]:14386
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754470Ab3LSXI6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 18:08:58 -0500
From: Stuart Yoder <stuart.yoder@freescale.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Scott Wood <scottwood@freescale.com>
CC: Kim Phillips <kim.phillips@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Bharat.Bhushan@freescale.com" <Bharat.Bhushan@freescale.com>,
        "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "a.motakis@virtualopensystems.com" <a.motakis@virtualopensystems.com>,
        "agraf@suse.de" <agraf@suse.de>,
        Varun Sethi <Varun.Sethi@freescale.com>
Subject: RE: [REPOST][PATCH 1/2] driver core: Add new device_driver flag to
 allow binding via sysfs only
Thread-Topic: [REPOST][PATCH 1/2] driver core: Add new device_driver flag to
 allow binding via sysfs only
Thread-Index: AQHO/GO/mMi+aThEXEWI8i8J6hWd3ppb9zeAgAADToCAAAVTkIAADh4AgAAIyYCAAATYgIAABy4w
Date: Thu, 19 Dec 2013 23:08:55 +0000
Message-ID: <e5b60a9c612c4a30b62d702f84ef400e@DM2PR03MB352.namprd03.prod.outlook.com>
References: <20131203123446.42fbff34a8ebd7afd38159a5@linaro.org>
 <20131219010729.GC23055@kroah.com>
 <1387484531.3140.134.camel@snotra.buserror.net>
 <20131219203401.GA11290@kroah.com>
 <dd683e36cc334893b193f4d36a33238c@BY2PR03MB348.namprd03.prod.outlook.com>
 <20131219214336.GA24629@kroah.com>
 <1387491303.3140.156.camel@snotra.buserror.net>
 <20131219223223.GA2801@kroah.com>
In-Reply-To: <20131219223223.GA2801@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.88.168.50]
x-forefront-prvs: 006546F32A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(13464003)(377454003)(51704005)(199002)(377424004)(24454002)(189002)(66066001)(80022001)(83322001)(19580405001)(74706001)(19580395003)(76576001)(80976001)(54316002)(76796001)(65816001)(76786001)(56776001)(77982001)(74366001)(90146001)(81542001)(69226001)(63696002)(50986001)(47736001)(56816005)(47976001)(49866001)(4396001)(33646001)(74662001)(31966008)(51856001)(74502001)(47446002)(46102001)(85852003)(74876001)(83072002)(2656002)(59766001)(81342001)(79102001)(81686001)(54356001)(81816001)(87266001)(74316001)(87936001)(53806001)(76482001)(85306002)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR03MB399;H:DM2PR03MB352.namprd03.prod.outlook.com;CLIP:192.88.168.50;FPR:;RD:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg Kroah-Hartman [mailto:gregkh@linuxfoundation.org]
> Sent: Thursday, December 19, 2013 4:32 PM
> To: Wood Scott-B07421
> Cc: Yoder Stuart-B08248; Kim Phillips; linux-kernel@vger.kernel.org;
> kvm@vger.kernel.org; Bhushan Bharat-R65777; christoffer.dall@linaro.org;
> alex.williamson@redhat.com; a.motakis@virtualopensystems.com;
> agraf@suse.de; Sethi Varun-B16395
> Subject: Re: [REPOST][PATCH 1/2] driver core: Add new device_driver flag
> to allow binding via sysfs only
> 
> On Thu, Dec 19, 2013 at 04:15:03PM -0600, Scott Wood wrote:
> > On Thu, 2013-12-19 at 13:43 -0800, Greg Kroah-Hartman wrote:
> > > On Thu, Dec 19, 2013 at 09:06:21PM +0000, Stuart Yoder wrote:
> > > >
> > > >
> > > > > -----Original Message-----
> > > > > From: Greg Kroah-Hartman [mailto:gregkh@linuxfoundation.org]
> > > > > Sent: Thursday, December 19, 2013 2:34 PM
> > > > > To: Wood Scott-B07421
> > > > > Cc: Kim Phillips; linux-kernel@vger.kernel.org;
> kvm@vger.kernel.org;
> > > > > Bhushan Bharat-R65777; Yoder Stuart-B08248;
> christoffer.dall@linaro.org;
> > > > > alex.williamson@redhat.com; a.motakis@virtualopensystems.com;
> > > > > agraf@suse.de; Sethi Varun-B16395
> > > > > Subject: Re: [REPOST][PATCH 1/2] driver core: Add new
> device_driver flag
> > > > > to allow binding via sysfs only
> > > > >
> > > > > No.  But you can use bind/unbind along with the existing new_id
> file to
> > > > > get what you want today.
> > > >
> > > > Yes, but that only works for PCI.
> > >
> > > No, not only PCI.
> > >
> > > > There is no such concept for platform drivers.
> > >
> > > Then fix that.
> >
> > We've already explained why that would be bad.
> 
> No you haven't, or if you have, my squirrel-brain doesn't remember it...
> 
> > > Or make your device not be a platform device, odds are that's the
> better
> > > solution in the end, right?
> >
> > How would that solve anything?  We'd just be talking about there not
> > being such a mechanism for the device tree "bus" instead.
> 
> Nope, you could add it there, like PCI and other busses have.
> 
> > > > > I don't like this patch as we are adding lots of special and odd
> logic
> > > > > to the core, for use by almost no one, which ensures that it will
> never
> > > > > get tested, and will probably get broken in some subtle way in
> the
> > > > > future.
> > > >
> > > > It certainly will be used by users of vfio-platform.
> > > >
> > > > Here is the problem-- the new platform device "match_any_dev"
> mechanism
> > > > in patch 2 of this series is not going to work without
> "sysfs_bind_only".
> > > > A platform driver that just sets "match_any_dev" will grab any or
> all
> > > > platform devices during normal bus probing.
> > >
> > > No it will not, it will fail in the probe function as it knows to not
> > > grab the device, just like any driver for other busses that say it
> can
> > > "handle all Intel PCI devices" and the like.
> >
> > How will it "know not to grab the device"?  The knowledge of whether
> the
> > binding was explicitly requested or not does not get passed through to
> > the probe function.
> 
> Nor should it, as a driver should not know, nor care about this.
> 
> It's up to the BUS to handle this if it really wants to, and I'm afraid
> that I really am not convinced that the driver core needs to handle it
> either.
> 
> But again, as you don't have anything that could actually use this code
> that is mergable, it's a totally moot point, sorry.

Understand, but what assumption do we develop vfio-plaform with?  That
a driver core 'sysfs_bind_only' flag is not an option, period?  If that
is the case we need to go back to square one and invent some new mechanism
to bind devices to the vfio-platform driver.

I guess it would need to be the platform bus equivalent of new_id.

But, then we're left with the potential racy situation where multiple drivers
can potentially grab a device and it's ambiguous and non-deterministic at to which
driver binds to it.

Stuart
