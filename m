Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498Ab3EIOhK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 10:37:10 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:55967 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411Ab3EIOhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 10:37:07 -0400
Date: Thu, 9 May 2013 15:37:02 +0100
From: Mark Brown <broonie@kernel.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Mike Turquette <mturquette@linaro.org>,
        Ming Lei <tom.leiming@gmail.com>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Liam Girdwood <lrg@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Message-ID: <20130509143702.GE3200@sirena.org.uk>
References: <1368076726-11492-1-git-send-email-skannan@codeaurora.org>
 <1368076726-11492-2-git-send-email-skannan@codeaurora.org>
 <CACVXFVMd_iRtEM8ZLK6Ps66gZO6SCp1mXSgY6JbWtRJjJUh+ag@mail.gmail.com>
 <CACxGe6uHBNUcbD9SeRP5c3E8NN-Z2yjVV+9VAhuoJnXoBtTu2w@mail.gmail.com>
 <20130509135017.GD3200@sirena.org.uk>
 <20130509141444.GV18614@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gDGSpKKIBgtShtf+"
Content-Disposition: inline
In-Reply-To: <20130509141444.GV18614@n2100.arm.linux.org.uk>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/3] driver core: Add API to wait for deferred probe to
 complete during init
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gDGSpKKIBgtShtf+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 09, 2013 at 03:14:45PM +0100, Russell King - ARM Linux wrote:
> On Thu, May 09, 2013 at 02:50:17PM +0100, Mark Brown wrote:

> > Even if the driver copes fine it can still be desirable to avoid the
> > power down/up cycle if it involves some user visible effect - things
> > like blinking the display off then on for example.  That said I am a
> > little suspicious about this approach, it doesn't feel as robust as it
> > should to go round individual callers.

> What if the driver for something like your display is a module which
> needs to be loaded from userland?

That's clearly a "don't do that then" sort of thing; while we don't want
to be unhelpful there's no guarantees with this approach.

> Where the design bug lies is in the "lets probe all the drivers and then
> shut down resources which drivers haven't claimed".  That contains an
> implied assumption: that all drivers have been loaded and probed at the
> point where you shut down those resources.

Well, that's not really the intention - it's not a strong guarantee,
it never has been given things like the module case you mention.

> So, trying to solve the problem may be totally fruitless because you
> can't actually solve it - you can only put a sticky plaster over it and
> hope that it catches most of the problem.  But reality is that you can't
> have both a shutdown of unused resources _and_ avoid the down/up cycle.

Yes, exactly - all we're trying to do here is cover the 90% case, not
solve all the possible problems since as you say that's not achievable. =20
There's a clear and reasonable desire to turn off resources we know
aren't in use at the current time, but equally well doing so as soon as
we start controlling the resources is pretty much guranteed to introduce
user visible issues on some systems so it's a question of picking some
reasonable point after that.

Another option here which is more in tune with deferred probing and
hotplugging would be to switch the delay over to be time based rather
than initcall based; do the shutdown at some point based on the time the
last resource was registered.  That still won't cover everything
though we could make the delay tunable.

--gDGSpKKIBgtShtf+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRi7SKAAoJELSic+t+oim9eW8P/R0gWGkMddPr1BW0cG5twZmR
BKXAPMEvbtAM/NVhFvDoxC/Wvr/Tmpi1hFCv5BvkZQWt8T2NnXzhJZRL+fd6JRuH
ek2BFm8+hqKQimHE6cb4nua3WFj6d/A/XXqokoldEnazsQSZMo4sIcThb3/6za/9
k38xz0k0Lf8F2MTDaAVJ06abay1K4Q+UZB4Z8NbkrfVjxwCRWVMo6/4+sEqg3Rxy
8ciD1FdcILKygR8TzXC21/XL/4qY9U5HKS3hEjcm93PZyIyDsG5/iPJ9JImwXRUR
KcVC3S+cy2dzMTNeqZx4QoS6GahJt8+BwunTu/YYJSmi28+J+pgDNt1LvO6Zm8go
OJBFzuQz5MYc23mumSB6EJi+nUVtsM72+YIG9Fvq2x0f84c8IM87qI1+ekVt+ast
MbD6HEGPIG76ivDLfssLWmQTX/zXMEnXofpI7MYVFIRHmg/OHU1uWOwFniTY419G
3CioHSC27WskjRb694kjPgA6WSYfyBWTRXmNnN9892bquqjejB1zz9xr8IPOg1g/
5uzaPa2LHorrWAom04JKWtY/4LsymRi/htiypP1Ls+SUJqK6QDjoQ1xgSoFGfLZ4
59CcQl5sUKZBdH6Rcluu4do2H/bxVUje7Aest+zEOi9kBPNcEvs8cq59QPmzy26E
eTwrL2ftLWGbnC8TOjb5
=43dd
-----END PGP SIGNATURE-----

--gDGSpKKIBgtShtf+--
