Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754985Ab3DWKWK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 06:22:10 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59207 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751204Ab3DWKWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 06:22:08 -0400
Date: Tue, 23 Apr 2013 11:22:04 +0100
From: Mark Brown <broonie@kernel.org>
To: "Opensource [Anthony Olech]" <anthony.olech.opensource@diasemi.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Steven Toth <stoth@kernellabs.com>,
        Michael Krufky <mkrufky@kernellabs.com>,
        LKML <linux-kernel@vger.kernel.org>,
        David Dajun Chen <david.chen@diasemi.com>
Subject: Re: [NEW DRIVER V6 1/7] drivers/mfd: DA9058 MFD core driver
Message-ID: <20130423102204.GC5019@opensource.wolfsonmicro.com>
References: <201304191722.r3JHMGqA019124@latitude>
 <20130422133417.GN30351@opensource.wolfsonmicro.com>
 <24DF37198A1E704D9811D8F72B87EB514191F6B6@NB-EX-MBX02.diasemi.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GZVR6ND4mMseVXL/"
Content-Disposition: inline
In-Reply-To: <24DF37198A1E704D9811D8F72B87EB514191F6B6@NB-EX-MBX02.diasemi.com>
X-Cookie: Caution: Keep out of reach of children.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GZVR6ND4mMseVXL/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 23, 2013 at 05:08:12AM +0000, Opensource [Anthony Olech] wrote:

> > No, you're totally missing the point here.  Your regulator driver needs
> > to be generic and work on any machine using the device.  This means you
> > can't specify any constraints, the constraints need to come from the
> > system integration.

> As far as I can see there are two types of constraints:-
> 1) the absolute max/min that the PMIC itself is designed for.
> 2) the max/min that the board is designed for, ie system integration.

> Thus constraints type (1) must come from the driver and constraints type =
(2)
> must come from the machine driver, which for my testing is the mach-smdk6=
410.

No, this is not the case.  We only have system design constraints in
Linux.  This should be clear from the fact that there's no mechanism for
regulator drivers to supply constraints.

> Also, I believe that two further principles apply:
> A) the machine driver should only specify a constraint if it restricts a =
value from (1) above.

No, this is not the case.  As you can see from looking at the code the
regulator API will only change the hardware settings if the system
integration code explicitly enables this.

> B) sensible defaults should be specified in the driver so that a system s=
hould have some
>    chance of operating in the case that the machine driver provides no co=
nstraints/overrides.

No, this is not how the API works.  There is no way to safely guess what
operations can be performed so the API defaults to doing nothing at all.

> Thus, in the case of this PMIC, the big BUCK is designed to provide power=
 to the processor,
> so the only possible sensible default can be "boot_on =3D=3D 1". It then =
makes sense that if a
> PMIC is to be used in the situation it is designed for, then the number o=
f system integration=20
> constraints should be almost zero.

You can't know that this is how the device has been used in a particular
system, nor can you tell what voltages are supported by the board.

> From your comment it seems that I have missed a point, but what?

You need to redo this so that it works like other regulator drivers.

--GZVR6ND4mMseVXL/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRdmDGAAoJELSic+t+oim9E1QP/28zfG8ZhggaaHVfCL2DuMDZ
kwobfmelIjyL9QOLbOohZzOIJZD5VAbHmAcy0H33tfLDtI9TlR3auTaa1ghUQqzB
13o9UbsA0mCtMNk0jYA6eRTXcvjEHRlKaGnE2m/CvfsnZrJRhaFS5cdno/RvFa5i
cJkixTfrfLNbcFS8ArIsddbn+bw+A1Sapn6EoyPb7OAVG5NA46oM/ZGN/Z4rOGh0
Tmvfs0I7+KROxq3Lt215yCaAnQq9mJhkKu5RxnDpOYZfrAYTPCQSLHGJHoBTkPDh
Vf/ZrKXTEXwptl+0Ecbqg4AUD6MFzArwoAzDQYu4drNqQeCtinK70ZVJfpIakL5X
oxDH33OonlKfse6MjgcW+5ljh+YUj0EYl9dOBbuQxhUmCBYmgZufGhmQiU6eApY6
KuklBdXj6gPhylMdeZJwnt1gYZ7fVQJpH2QYGM5Mm0IXhkgbTXDPqjzzCy9EODEP
f1I3COHekoRiuAoH0i//HjuQg7rIXjwxPy5pah5TzHOw8BAWmmAMCOnX2/nWpunY
Oi4hKXX+9W/cz3clykk9qpUCpYbkRcNMLmxxwZ4JhClv2FpOqxy3uME99XuzqSqG
V/WeI3YqMxzwPeSNnf4MOeKCzWaywVvLGwFJOa7bipvt4imcYIE2fvETxKQWIldg
LRNLW6rrdMGhXN9bcLgS
=Dtxq
-----END PGP SIGNATURE-----

--GZVR6ND4mMseVXL/--
