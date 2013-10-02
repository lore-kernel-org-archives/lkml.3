Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754362Ab3JBVQU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 17:16:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42844 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753630Ab3JBVQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 17:16:19 -0400
Date: Wed, 2 Oct 2013 14:16:31 -0700
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: Scott Wood <scottwood@freescale.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>,
        Yoder Stuart-B08248 <B08248@freescale.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Kim Phillips <kim.phillips@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "a.motakis@virtualopensystems.com" <a.motakis@virtualopensystems.com>,
        "agraf@suse.de" <agraf@suse.de>,
        Wood Scott-B07421 <B07421@freescale.com>,
        Sethi Varun-B16395 <B16395@freescale.com>,
        Bhushan Bharat-R65777 <R65777@freescale.com>,
        "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
        "santosh.shukla@linaro.org" <santosh.shukla@linaro.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: RFC: (re-)binding the VFIO platform driver to a platform device
Message-ID: <20131002211631.GA11914@kroah.com>
References: <20131001200054.GA27330@kroah.com>
 <20131001170244.ff4fb81d9a7a09598c4c6247@linaro.org>
 <20131002015355.GD63102@lvm>
 <1380681356.14271.57.camel@ul30vt.home>
 <20131002151413.GG63102@lvm>
 <9F6FE96B71CF29479FF1CDC8046E15036D405D@039-SN1MPN1-003.039d.mgd.msft.net>
 <1380738758.12932.43.camel@snotra.buserror.net>
 <20131002184330.GC5108@cbox>
 <20131002203735.GA10871@kroah.com>
 <1380748121.12932.89.camel@snotra.buserror.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380748121.12932.89.camel@snotra.buserror.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 02, 2013 at 04:08:41PM -0500, Scott Wood wrote:
> On Wed, 2013-10-02 at 13:37 -0700, gregkh@linuxfoundation.org wrote:
> > On Wed, Oct 02, 2013 at 11:43:30AM -0700, Christoffer Dall wrote:
> > > > What's wrong with a non-vfio-specific flag that a driver can set, that
> > > > indicates that the driver is willing to try to bind to any device on the
> > > > bus if explicitly requested via the existing sysfs bind mechanism?
> > > > 
> > > It sounds more hackish to me to invent some 'generic' flag to solve a
> > > very specific case.  What you're suggesting would let users specify that
> > > a serial driver should handle a NIC hardware, no?  That sounds much much
> > > worse to me.
> > 
> > You can do that today, with any PCI driver (or USB driver as well), just
> > use the bind/unbind files in sysfs and you had better "know" what you
> > are doing...
> 
> sysfs bind won't work if it driver_match_device() fails.  PCI has
> PCI_ANY_ID, so the missing piece for PCI is a way to say that the driver
> should not bind to a device except when explicitly requested via sysfs
> bind.
> 
> I don't see any equivalent functionality to PCI_ANY_ID for platform
> devices.

Nor should it.  If you are wanting to bind platform devices to different
things based on "ids" or "strings" or something else, then you had
better not be using a platform device because that is not what you have
anymore.

Yes, I know the OF stuff uses platform devices, and again, it's one
reason why I don't like it at all.  So fix OF devices "properly",
creating your own bus and device type, and then you will not have these
issues.

thanks,

greg "I should never have let platform devices be created" k-h
