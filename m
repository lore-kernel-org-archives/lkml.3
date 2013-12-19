Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756577Ab3LSWcV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 17:32:21 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46474 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754699Ab3LSWcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 17:32:20 -0500
Date: Thu, 19 Dec 2013 14:32:23 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Scott Wood <scottwood@freescale.com>
Cc: Stuart Yoder <stuart.yoder@freescale.com>,
        Kim Phillips <kim.phillips@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Bharat.Bhushan@freescale.com" <Bharat.Bhushan@freescale.com>,
        "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "a.motakis@virtualopensystems.com" <a.motakis@virtualopensystems.com>,
        "agraf@suse.de" <agraf@suse.de>,
        Varun Sethi <Varun.Sethi@freescale.com>
Subject: Re: [REPOST][PATCH 1/2] driver core: Add new device_driver flag to
 allow binding via sysfs only
Message-ID: <20131219223223.GA2801@kroah.com>
References: <20131203123446.42fbff34a8ebd7afd38159a5@linaro.org>
 <20131219010729.GC23055@kroah.com>
 <1387484531.3140.134.camel@snotra.buserror.net>
 <20131219203401.GA11290@kroah.com>
 <dd683e36cc334893b193f4d36a33238c@BY2PR03MB348.namprd03.prod.outlook.com>
 <20131219214336.GA24629@kroah.com>
 <1387491303.3140.156.camel@snotra.buserror.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387491303.3140.156.camel@snotra.buserror.net>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19, 2013 at 04:15:03PM -0600, Scott Wood wrote:
> On Thu, 2013-12-19 at 13:43 -0800, Greg Kroah-Hartman wrote:
> > On Thu, Dec 19, 2013 at 09:06:21PM +0000, Stuart Yoder wrote:
> > > 
> > > 
> > > > -----Original Message-----
> > > > From: Greg Kroah-Hartman [mailto:gregkh@linuxfoundation.org]
> > > > Sent: Thursday, December 19, 2013 2:34 PM
> > > > To: Wood Scott-B07421
> > > > Cc: Kim Phillips; linux-kernel@vger.kernel.org; kvm@vger.kernel.org;
> > > > Bhushan Bharat-R65777; Yoder Stuart-B08248; christoffer.dall@linaro.org;
> > > > alex.williamson@redhat.com; a.motakis@virtualopensystems.com;
> > > > agraf@suse.de; Sethi Varun-B16395
> > > > Subject: Re: [REPOST][PATCH 1/2] driver core: Add new device_driver flag
> > > > to allow binding via sysfs only
> > > > 
> > > > No.  But you can use bind/unbind along with the existing new_id file to
> > > > get what you want today.
> > > 
> > > Yes, but that only works for PCI.
> > 
> > No, not only PCI.
> > 
> > > There is no such concept for platform drivers.
> > 
> > Then fix that.
> 
> We've already explained why that would be bad.

No you haven't, or if you have, my squirrel-brain doesn't remember it...

> > Or make your device not be a platform device, odds are that's the better
> > solution in the end, right?
> 
> How would that solve anything?  We'd just be talking about there not
> being such a mechanism for the device tree "bus" instead.

Nope, you could add it there, like PCI and other busses have.

> > > > I don't like this patch as we are adding lots of special and odd logic
> > > > to the core, for use by almost no one, which ensures that it will never
> > > > get tested, and will probably get broken in some subtle way in the
> > > > future.
> > > 
> > > It certainly will be used by users of vfio-platform.
> > > 
> > > Here is the problem-- the new platform device "match_any_dev" mechanism
> > > in patch 2 of this series is not going to work without "sysfs_bind_only".
> > > A platform driver that just sets "match_any_dev" will grab any or all 
> > > platform devices during normal bus probing.
> > 
> > No it will not, it will fail in the probe function as it knows to not
> > grab the device, just like any driver for other busses that say it can
> > "handle all Intel PCI devices" and the like.
> 
> How will it "know not to grab the device"?  The knowledge of whether the
> binding was explicitly requested or not does not get passed through to
> the probe function.

Nor should it, as a driver should not know, nor care about this.

It's up to the BUS to handle this if it really wants to, and I'm afraid
that I really am not convinced that the driver core needs to handle it
either.

But again, as you don't have anything that could actually use this code
that is mergable, it's a totally moot point, sorry.

greg k-h
