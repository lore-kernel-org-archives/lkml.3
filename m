Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161Ab3ELOeO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 10:34:14 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:55635 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753528Ab3ELOeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 10:34:13 -0400
Date: Sun, 12 May 2013 18:33:44 +0400
From: Mark Brown <broonie@kernel.org>
To: =?iso-8859-1?Q?S=F6ren?= Brinkmann <soren.brinkmann@xilinx.com>
Cc: Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Message-ID: <20130512143344.GC3200@sirena.org.uk>
References: <1368207091-32538-1-git-send-email-soren.brinkmann@xilinx.com>
 <1368207091-32538-2-git-send-email-soren.brinkmann@xilinx.com>
 <20130510212422.GY3200@sirena.org.uk>
 <7e18bed3-ae6b-4aa0-bf23-b6c61ba8b85b@CO9EHSMHS030.ehs.local>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZNveOOYjKturpEFp"
Content-Disposition: inline
In-Reply-To: <7e18bed3-ae6b-4aa0-bf23-b6c61ba8b85b@CO9EHSMHS030.ehs.local>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.247.243.210
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH RFC] clk: Introduce userspace clock driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZNveOOYjKturpEFp
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, May 11, 2013 at 09:54:22AM -0700, S=F6ren Brinkmann wrote:
> On Fri, May 10, 2013 at 10:24:22PM +0100, Mark Brown wrote:

> > For your use case should these things be exposed by the FPGA device
> > asking for that rather than by having the clocks available separately?
> > Or is this part of the DT blob that's loaded incrementally along with
> > the FPGA (which does make things more interesting of course...).

> Here may be some misunderstanding.
> The clocks are not in the FPGA. The clocks are always there and part of
> the processing system (PS), they are just routed to the FPGA where they
> can be used as clocks for the FPGA design.

No, there's no confusion here - the clocks that are being exposed to
userspace are the clocks which enter the FPGA.  The driver or whatever
that understands the FPGA can do what is needed to control them,
including routing them on to subdevices it instantiates or exposing them
to userspace.

> > > +		clk_disable_unprepare(pdata->clk);
> >=20
> > > +	if (ret)
> > > +		return -EBUSY;
> >=20
> > Why not pass back the actual error?

> Good question. Was there some spec saying, that these sysfs callbacks
> should return this error? Otherwise this will be fixed.

Not to my knowledge.

--ZNveOOYjKturpEFp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRj6g/AAoJELSic+t+oim9FE8P/3n+9qpWqWmKgrrEKngHSWP9
yNv35oh6MM4AwegiAygcgtqXy083xMULWElHJdM/1cVyq0jF/kfXGzjZfn3VMmsb
giiVjb7YpncPl1VQfFg93fQIP0XblvYFsiHIXHdtHHOoYy9HGXYEtBvQfPdFjpNq
cSEMTNhbl5FVNn7NVunYJv7otmA2b6lC0pP9MY8y7SlggizIIRfk5Ke6u2UGXAKE
PealZIwB2DRHgrwyffbvmKo9veTSodlt5yLnwLT/Whg3aWsiKK5+qkefEK77MOKv
u2wVnRTn8miVCDItWTWNNReQT8lIrmMuBmeaqjXxm0qm+m7OzKP285OyAyr659Uo
AB3S3u024GFbxHtCyaIvIU1dvCHGwHDA19mUrlyI07kWyfCRidWvxSKpoHf3wOOm
5Bqcmeiog74LrdQksoZ7vpdpfqgFwhbvQ0cffJ/ai4lNA0zIxbevVDdAhEYa7prs
tRSXGtpBdWibsGHjG3zavql30cgFhUq1syi0qQfyoBxrYM4vbw2eRl43Ua2Q3IWx
qF0ey5VcTwNYuUEE+d4Y51XfF6igH5488wRAH7iTiYbR4ADKsDPDLkUuq5lbER0W
GtVZHgpIqM7mrcidYCrN6RjVVGkH5IEm5gQa5YkWiNOq87klg8vposfVnkCbyJLN
AlYRPXc4zWB5yt9njYpT
=PdPc
-----END PGP SIGNATURE-----

--ZNveOOYjKturpEFp--
