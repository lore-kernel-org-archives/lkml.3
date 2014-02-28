Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751711AbaB1Djk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 22:39:40 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:53411 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbaB1Djj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 22:39:39 -0500
Date: Fri, 28 Feb 2014 12:39:35 +0900
From: Mark Brown <broonie@kernel.org>
To: Andrew Bresticker <abrestic@chromium.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20140228033935.GF9383@sirena.org.uk>
References: <1393473057-19919-1-git-send-email-abrestic@chromium.org>
 <20140227113748.GY9383@sirena.org.uk>
 <CAL1qeaF2RtC--K06qWkMRjBAOzoVfxi845RwZX05QwXS66Ns9Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+te1M04ZWIfilseV"
Content-Disposition: inline
In-Reply-To: <CAL1qeaF2RtC--K06qWkMRjBAOzoVfxi845RwZX05QwXS66Ns9Q@mail.gmail.com>
X-Cookie: Q:	Are we not men?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 175.126.181.153
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regmap: don't use spinlocks with
 REGCACHE_{RBTREE,COMPRESSED}
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+te1M04ZWIfilseV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 27, 2014 at 06:32:53PM -0800, Andrew Bresticker wrote:
> On Thu, Feb 27, 2014 at 3:37 AM, Mark Brown <broonie@kernel.org> wrote:

> > Have all the users been audited to verify that they're actually safe
> > with this?  I just took a quick look at the Tegra drivers and they're
> > doing regmap operations in their trigger operations which is done from
> > atomic context so they should run into problems trying to take mutexes
> > anyway.

> Oops, you're right, I didn't look through all the regmap operations
> carefully enough.  It is in fact the Tegra drivers I've ran into this
> issue with.

Yeah, I suspected it might be :)

> > I think we need to either ensure that all users allocate their caches at
> > probe time (which is fine and is hopefully what the current users are
> > doing), provide a mechanism for them to do cache allocations outside of
> > the spinlock (which sounds hairy) or convert them to flat cache.

> Allocations are made in the write path for rbtree and in both the read
> and write paths for lzo.  I suppose we can pre-allocate everything at
> init time, but I haven't looked too much at that.  For at least the
> Tegra drivers, the best option for now appears to be to convert to a
> flat cache.

OK, that's certainly simple to implement.  Currently to allocate at
startup the standard thing is to supply the hardware defaults as data,
though going through and reading everything should also do the trick.

--+te1M04ZWIfilseV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTEAT0AAoJELSic+t+oim9mM0P/33RiLzGZ8zrReKu2apdzBgK
QBV70I+tL21KMK3nXAcy2XaudojP+4xyYlNWBY76GS3rOO0abgFuJ3qNncBD6aGf
BIBy+yiTc8vWbwDPRvHaSEG6lVJVndmVYd8v5qhnRAfz7lifKypD+1hhDVGKehZx
Yb26NNTfLWudynNkBlMGocH+PBOp6t18oJUGFcDCbY9QI/QgG7PxW6kKdVh+rrN6
hKWwdK+QV6kmFRdHggJc7Qu7sxInVbrDVHKMFDpHIsqI3Tv4fU9eQKG1Qino0bQC
SYaUXfGVXfIq2behja4V9glSLvweDY0C+LDi8Hccge5ibbbJXR0yRWLbfnDv6uXK
cHsoRiQOT3q6hS5mcWmF8NK3Cr5URckVHtE1VNkICVlraQEVxXSREW2yc5IgvaaG
/q5f8lyBWEbI7YLNCwzBqouTx2MtDwJRss0ZoPLrPd+1x0zaPAEjwVLK5mtDr3T7
yJWpTo3fU2ec0yRgFZmG2Np4XF+vWJMleG8DZG1h6GA/7/JwqMTgwnRXO1cjCPVU
dl/8lJq3uH2Yqmh3BDPYB7kf+ATJVAW0IM2ChsSdYK40rJ2UHYFSNofLifcrBR8H
TZCUjjrnWvgzkhRyARS1f68bywuGSIO7uq+Pgob0vuYns/Eord04z+wx+oLWQZvU
1iSt9jmK8y6YOUFZ405V
=vCGJ
-----END PGP SIGNATURE-----

--+te1M04ZWIfilseV--
