Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875Ab3JCSyh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 14:54:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56409 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754536Ab3JCSyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 14:54:35 -0400
Date: Thu, 3 Oct 2013 11:54:34 -0700
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
Message-ID: <20131003185434.GA26123@kroah.com>
References: <20131002151413.GG63102@lvm>
 <9F6FE96B71CF29479FF1CDC8046E15036D405D@039-SN1MPN1-003.039d.mgd.msft.net>
 <1380738758.12932.43.camel@snotra.buserror.net>
 <20131002184330.GC5108@cbox>
 <20131002203735.GA10871@kroah.com>
 <1380748121.12932.89.camel@snotra.buserror.net>
 <20131002211631.GA11914@kroah.com>
 <1380749715.12932.109.camel@snotra.buserror.net>
 <20131002234009.GA27714@kroah.com>
 <1380825207.12932.151.camel@snotra.buserror.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380825207.12932.151.camel@snotra.buserror.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 03, 2013 at 01:33:27PM -0500, Scott Wood wrote:
> What it looks like we do still want from the driver core is the ability
> for a driver to say that it should not be bound to a device except via
> explicit sysfs bind,

You can do that today by not providing any device ids in your driver
structure, relying on the dynamic ids the driver core creates.

> and the ability for a user to say that a device should not be bound to
> a driver except via explicit sysfs bind.

That's not going to happen, as how can the kernel know a specific device
is going to want this, before it asks the drivers about it?

Or, just don't ever create a driver that matches that device, then rely
on userspace to do the binding explicitly.

Either way, no driver core changes are needed from what I can tell.

greg k-h
