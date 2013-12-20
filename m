Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756728Ab3LTAAd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 19:00:33 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46853 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756397Ab3LTAAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 19:00:32 -0500
Date: Thu, 19 Dec 2013 16:00:35 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Stuart Yoder <stuart.yoder@freescale.com>
Cc: Scott Wood <scottwood@freescale.com>,
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
Message-ID: <20131220000035.GA5462@kroah.com>
References: <20131203123446.42fbff34a8ebd7afd38159a5@linaro.org>
 <20131219010729.GC23055@kroah.com>
 <1387484531.3140.134.camel@snotra.buserror.net>
 <20131219203401.GA11290@kroah.com>
 <dd683e36cc334893b193f4d36a33238c@BY2PR03MB348.namprd03.prod.outlook.com>
 <20131219214336.GA24629@kroah.com>
 <1387491303.3140.156.camel@snotra.buserror.net>
 <20131219223223.GA2801@kroah.com>
 <e5b60a9c612c4a30b62d702f84ef400e@DM2PR03MB352.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e5b60a9c612c4a30b62d702f84ef400e@DM2PR03MB352.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19, 2013 at 11:08:55PM +0000, Stuart Yoder wrote:
> > > How will it "know not to grab the device"?  The knowledge of whether
> > the
> > > binding was explicitly requested or not does not get passed through to
> > > the probe function.
> > 
> > Nor should it, as a driver should not know, nor care about this.
> > 
> > It's up to the BUS to handle this if it really wants to, and I'm afraid
> > that I really am not convinced that the driver core needs to handle it
> > either.
> > 
> > But again, as you don't have anything that could actually use this code
> > that is mergable, it's a totally moot point, sorry.
> 
> Understand, but what assumption do we develop vfio-plaform with?  That
> a driver core 'sysfs_bind_only' flag is not an option, period?  If that
> is the case we need to go back to square one and invent some new mechanism
> to bind devices to the vfio-platform driver.

Ok, why the total confusion between PCI and platform devices here?  Why
keep mentioning both of them in a semi-interchangeable way?

> I guess it would need to be the platform bus equivalent of new_id.

Then add it, there's nothing stopping the platform bus from supporting
this.

> But, then we're left with the potential racy situation where multiple drivers
> can potentially grab a device and it's ambiguous and non-deterministic at to which
> driver binds to it.

Welcome to life in hotpluggable systems, this is nothing new :)

Seriously, userspace has the ability to sort this all out after devices
show up, use it.  Don't try to create convoluted schemes in the driver
core that are confusing and don't really seem to work.

People have asked for a "priority" of drivers binding to devices for
over a decade now, as "other" operating systems have it.  Turns out, no
one has ever needed it badly enough to actually implement it...

good luck,

greg k-h
