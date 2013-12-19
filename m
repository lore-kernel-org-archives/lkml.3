Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755875Ab3LSWPb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 17:15:31 -0500
Received: from mail-bl2lp0203.outbound.protection.outlook.com ([207.46.163.203]:40178
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754124Ab3LSWP3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 17:15:29 -0500
Message-ID: <1387491303.3140.156.camel@snotra.buserror.net>
Subject: Re: [REPOST][PATCH 1/2] driver core: Add new device_driver flag to
 allow binding via sysfs only
From: Scott Wood <scottwood@freescale.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Stuart Yoder <stuart.yoder@freescale.com>,
        Kim Phillips <kim.phillips@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Bharat.Bhushan@freescale.com" <Bharat.Bhushan@freescale.com>,
        "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "a.motakis@virtualopensystems.com" <a.motakis@virtualopensystems.com>,
        "agraf@suse.de" <agraf@suse.de>,
        "Varun Sethi" <Varun.Sethi@freescale.com>
Date: Thu, 19 Dec 2013 16:15:03 -0600
In-Reply-To: <20131219214336.GA24629@kroah.com>
References: <20131203123446.42fbff34a8ebd7afd38159a5@linaro.org>
	 <20131219010729.GC23055@kroah.com>
	 <1387484531.3140.134.camel@snotra.buserror.net>
	 <20131219203401.GA11290@kroah.com>
	 <dd683e36cc334893b193f4d36a33238c@BY2PR03MB348.namprd03.prod.outlook.com>
	 <20131219214336.GA24629@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2601:2:5800:3f7:12bf:48ff:fe84:c9a0]
X-ClientProxiedBy: BLUPR08CA001.namprd08.prod.outlook.com (10.255.219.169)
 To BL2PR03MB387.namprd03.prod.outlook.com (10.141.91.152)
X-Forefront-PRVS: 006546F32A
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009001)(13464003)(199002)(189002)(51704005)(377424004)(377454003)(24454002)(33646001)(74876001)(50986001)(77156001)(46102001)(74706001)(50466002)(49866001)(50226001)(47736001)(47976001)(74366001)(76482001)(23676002)(51856001)(77096001)(53806001)(42186004)(81542001)(63696002)(81342001)(19580395003)(19580405001)(47776003)(88136002)(79102001)(54316002)(83322001)(65816001)(80976001)(80022001)(81816001)(87286001)(81686001)(87266001)(31966008)(74502001)(47446002)(85306002)(74662001)(4396001)(89996001)(85852003)(62966002)(59766001)(87976001)(77982001)(76796001)(76786001)(69226001)(90146001)(83072002)(56776001)(56816005)(3826001);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2PR03MB387;H:[IPv6:2601:2:5800:3f7:12bf:48ff:fe84:c9a0];CLIP:2601:2:5800:3f7:12bf:48ff:fe84:c9a0;FPR:;RD:InfoNoRecords;A:1;MX:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-12-19 at 13:43 -0800, Greg Kroah-Hartman wrote:
> On Thu, Dec 19, 2013 at 09:06:21PM +0000, Stuart Yoder wrote:
> > 
> > 
> > > -----Original Message-----
> > > From: Greg Kroah-Hartman [mailto:gregkh@linuxfoundation.org]
> > > Sent: Thursday, December 19, 2013 2:34 PM
> > > To: Wood Scott-B07421
> > > Cc: Kim Phillips; linux-kernel@vger.kernel.org; kvm@vger.kernel.org;
> > > Bhushan Bharat-R65777; Yoder Stuart-B08248; christoffer.dall@linaro.org;
> > > alex.williamson@redhat.com; a.motakis@virtualopensystems.com;
> > > agraf@suse.de; Sethi Varun-B16395
> > > Subject: Re: [REPOST][PATCH 1/2] driver core: Add new device_driver flag
> > > to allow binding via sysfs only
> > > 
> > > No.  But you can use bind/unbind along with the existing new_id file to
> > > get what you want today.
> > 
> > Yes, but that only works for PCI.
> 
> No, not only PCI.
> 
> > There is no such concept for platform drivers.
> 
> Then fix that.

We've already explained why that would be bad.

> Or make your device not be a platform device, odds are that's the better
> solution in the end, right?

How would that solve anything?  We'd just be talking about there not
being such a mechanism for the device tree "bus" instead.

> > > If you just happen to bind a device to a wrong
> > > driver for a while, that's not really a problem, right?
> > 
> > It's annoying but not the end of the world.

Lots of bugs are "not the end of the world" but that doesn't mean we
don't fix them.  It certainly doesn't mean we duplicate the source of
the bug in new subsystems.

> > > I don't like this patch as we are adding lots of special and odd logic
> > > to the core, for use by almost no one, which ensures that it will never
> > > get tested, and will probably get broken in some subtle way in the
> > > future.
> > 
> > It certainly will be used by users of vfio-platform.
> > 
> > Here is the problem-- the new platform device "match_any_dev" mechanism
> > in patch 2 of this series is not going to work without "sysfs_bind_only".
> > A platform driver that just sets "match_any_dev" will grab any or all 
> > platform devices during normal bus probing.
> 
> No it will not, it will fail in the probe function as it knows to not
> grab the device, just like any driver for other busses that say it can
> "handle all Intel PCI devices" and the like.

How will it "know not to grab the device"?  The knowledge of whether the
binding was explicitly requested or not does not get passed through to
the probe function.

It would be a shame to have to implement code in VFIO, and a userspace
interface to go along with it, to keep track of which devices have been
authorized to be bound when we already have sysfs bind -- we just need a
way to differentiate that from automatic binding.

-Scott


