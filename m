Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932255Ab3CGIXL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 03:23:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16195 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754620Ab3CGIXK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 03:23:10 -0500
Date: Thu, 7 Mar 2013 13:53:01 +0530
From: Amit Shah <amit.shah@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Virtualization List <virtualization@lists.linux-foundation.org>,
        linux-kernel@vger.kernel.org, hpa@zytor.com,
        Anthony Liguori <anthony@codemonkey.ws>
Subject: Re: [PATCH 1/1] virtio: rng: disallow multiple device registrations,
 fixes crashes
Message-ID: <20130307082301.GA4135@amit.redhat.com>
References: <58c84c464bca72f80fec188f0ae0269058c6cf03.1362557573.git.amit.shah@redhat.com>
 <8762149fxk.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8762149fxk.fsf@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(CC'ing lkml and hpa for thoughts on multiple active hwrng devices)

On (Thu) 07 Mar 2013 [12:06:31], Rusty Russell wrote:
> Amit Shah <amit.shah@redhat.com> writes:
> > The code currently only supports one virtio-rng device at a time.
> > Invoking guests with multiple devices causes the guest to blow up.
> >
> > Check if we've already registered and initialised the driver.  Also
> > cleanup in case of registration errors or hot-unplug so that a new
> > device can be used.
> >
> > Reported-by: Peter Krempa <pkrempa@redhat.com>
> > Reported-by: <yunzheng@redhat.com>
> > Signed-off-by: Amit Shah <amit.shah@redhat.com>
> > ---
> >
> > Also valid for stable?
> 
> Yes.  We could fix virtio-rng to allow multiple rngs, but of course it
> will fail anyway since hwrng wants unique names.  And changing the name
> to be virtio-%u will probably break things, for no real upside.

The hwrng interface also sources its input from one active device at a
time, and that's selectable via a sysfs interface.

If we extend the hwrng interface to source from multiple devices at
the same time, and taking in whatever it gets from whichever device
has data to give, wlil having multiple virtio devices make sense.

But, several active hwrng devices has its own set of problems: on need
for entropy, which device do you ask from?  Just asking all devices
for precious entropy, when only one could give out all of it is not
productive (or secure?).

> Applied, and Cc:stable added.

Thanks!

		Amit
