Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932648Ab3HNRas (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 13:30:48 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:33057 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759967Ab3HNRaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 13:30:46 -0400
Date: Wed, 14 Aug 2013 18:30:28 +0100
From: Mark Brown <broonie@kernel.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>, Felipe Balbi <balbi@ti.com>,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20130814173028.GB2401@sirena.org.uk>
References: <20130814153906.GU6427@sirena.org.uk>
 <Pine.LNX.4.44L0.1308141209410.1701-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vGgW1X5XWziG23Ko"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1308141209410.1701-100000@iolanthe.rowland.org>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: Non-enumerable devices on USB and other enumerable buses
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vGgW1X5XWziG23Ko
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 14, 2013 at 12:14:06PM -0400, Alan Stern wrote:
> On Wed, 14 Aug 2013, Mark Brown wrote:

> > Yes, so you'd want callbacks when the device actually appears and
> > disappears.

> No, no -- this is exactly the point I was trying to make.  The on-board
> hub _won't_ appear on the USB bus until the GPIOs are set.  Therefore
> the callback to set the GPIOs needs to be at a different place, not
> when the device appears.

What I'm proposing is that we have a way of telling buses that devices
exist via a mechanism other than their actually being visible on the bus
at the current time.  If you're doing that the driver can be running
prior to the hardware being there, just like it does with all the
non-enumerable buses.

> > > Perhaps the platform-level code would need to hook into the places
> > > where the discoverable bus is registered and unregistered.

> > We'd need some way to get information to the drivers still, and to
> > handle drivers that want to stop and start things.

> Um...  What exactly does this mean?  It's so generic, it could apply to
> anything under drivers/.  After all, what driver doesn't want to stop
> and start things?

It means that there are situations where a driver wants to take the
hardware offline but still offer services to userspace which will
require the hardware to be brought on line again.  The fact that this is
a very generic thing is exactly why I'm raising this as a generic issue.

--vGgW1X5XWziG23Ko
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSC76xAAoJELSic+t+oim9HQAP/0l6Vhxdy9jeDjPohHWTguIV
f9MEnTlBPnEcvIIAQI/vUawEa44hyKw0Zrf/yEwQy5L8SBTFM4U+KEE5vNnc5h5N
pAKjXLYtnWdRP3WfLrI87qiuWEpYhYc/xEDA6beSqNlj+qMaBqy5wa2oGE2cCtzn
0i2C34PsUFzCmX+m1/+1/cjIK52muAtV1tzCvpIefODZ1RQfZp5fUHx2Lw4KlZac
8nkjMOnm40TSzTDosvj159F53BLiS/Yi1JrCirBaAVZn70x6JyNswV4tsBlunNxO
xu0K3mN40FfwCyTExw7l2gidb9H5+RFupImBIaIbZNttTgsLkW3K6MIrPn9MxSDn
3hUbhmHM6w6G7MUYvQ/w8+XXM4GzsUP6pSeJpd5dzmqQANlrOvKqA1W8CRbCjZGr
GwWVW9Va7JN8Ojvs2o5JGiru50xCOu2OetnNQ53dWpTz6VRcsyZ8ISzlnAz0FlRw
VbyhEoPzeWK4yE+AsVXw2lrRxgSXjKsHAM3wDvg+/3BbONzQ59iYAJQxfRTiPg+I
zoVBzle6G7Fsry6hIUI/reWD0yabhB+i+PyaTl/bXnO4ODGJM0vYnFS6aXzrA1pn
gAEbrQyDcC+xJvWNOtK2wxntjEwHzArAMPV0xOGSkfLIUeHiV4e6uUq/wAQl0ixc
tYTCsOt1DyFmIufOtD5j
=2sdc
-----END PGP SIGNATURE-----

--vGgW1X5XWziG23Ko--
