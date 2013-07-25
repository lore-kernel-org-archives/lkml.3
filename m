Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756457Ab3GYO7s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 10:59:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47229 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755994Ab3GYO7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 10:59:44 -0400
Message-ID: <1374764373.5374.42.camel@fourier>
Subject: Re: Linux 3.11-rc2 (acpi backlight, revert)
From: Kamal Mostafa <kamal@canonical.com>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, James Hogan <james@albanarts.com>,
        Aaron Lu <aaron.lu@intel.com>, Kalle Valo <kvalo@adurom.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Steven Newbury <steve@snewbury.org.uk>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        =?ISO-8859-1?Q?J=F6rg?= Otte <jrg.otte@gmail.com>,
        Martin Steigerwald <Martin@lichtvoll.de>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Jani Nikula <jani.nikula@linux.intel.com>
Date: Thu, 25 Jul 2013 07:59:33 -0700
In-Reply-To: <20130725144625.GO5939@phenom.ffwll.local>
References: <CA+55aFy330bSRjK5HT1n0wXioPykL3RquHXyBPjm5GpTz_Y=DQ@mail.gmail.com>
	 <CA+55aFyrMRDD8qe9DYXixaSLJXEURMYYku1azABA72m71_X+cA@mail.gmail.com>
	 <9012759.Alzqtdvh5b@vostro.rjw.lan> <2218913.HKGjJcYT1G@vostro.rjw.lan>
	 <1374763397.5374.30.camel@fourier>
	 <20130725144625.GO5939@phenom.ffwll.local>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-ylRWJXiniZUHIcCQ9j2b"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ylRWJXiniZUHIcCQ9j2b
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2013-07-25 at 16:46 +0200, Daniel Vetter wrote:
> On Thu, Jul 25, 2013 at 07:43:17AM -0700, Kamal Mostafa wrote:
> > On Thu, 2013-07-25 at 15:00 +0200, Rafael J. Wysocki wrote:
> > > On Monday, July 22, 2013 09:54:21 PM Rafael J. Wysocki wrote:
> > > > On Monday, July 22, 2013 11:11:54 AM Linus Torvalds wrote:
> > > > > On Mon, Jul 22, 2013 at 6:02 AM, Rafael J. Wysocki <rjw@sisk.pl> =
wrote:
> > > > > >
> > > > > > Linus, do you want me to send a pull request reverting 8c5bd7a =
and efaa14c?
> > > > >=20
> > > > > Yes, but let's wait a while. Not because I think we'll fix the pr=
oblem
> > > > > (hey, miracles might happen), but because I think it would be use=
ful
> > > > > to couple the reverts with information about the particular machi=
nes
> > > > > that broke (and the people who reported it). So that when we
> > > > > inevitably try again, we can perhaps get some testing effort with
> > > > > those machines/people.
> > > > >=20
> > > > > It doesn't seem to be a show-stopped for a large number of people=
, so
> > > > > there's no huge hurry. I'd suggest doing the revert just in time =
for
> > > > > rc3, but waiting until then to gather info about people who see
> > > > > breakage.
> > > > >=20
> > > > > Sound like a plan?
> > > >=20
> > > > Yes, it does.
> > >=20
> > > OK, time to revert I guess.
> > >=20
> > > James, Kamal, Steven, J=C3=B6rg, Martin, Kalle, please check if the a=
pppended patch
> > > fixes the backlight for you.
> >=20
> > Yes, this revert patch does re-enable backlight control for the affecte=
d
> > Dell XPS13 models.
>=20
> Are these the same models that neeed the special quirk to not write
> PCH_PWM_ENABLE? Or do they need both?

Hi Daniel-

Yes, these are the same models (Dell XPS13) that need the PCH_PWM_ENABLE
quirk, but that's not related to this ACPI problem...

All of the XPS13 models still need the PCH_PWM_ENABLE quirk which is now
present in mainline (e85843b "drm/i915: quirk no PCH_PWM_ENABLE for Dell
XPS13 backlight").

Separately from that, some of the XPS13 models were _also_ adversely
affected (as were some other machines) by the ACPI changes that are
about to be reverted.

 -Kamal


--=-ylRWJXiniZUHIcCQ9j2b
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABCAAGBQJR8T1VAAoJEHqwmdxYrXhZ3BcP/361yS+awomMVvSAQK0NnkC2
a1MbWxrlK1Ck1KXvkk0Xx5JZrQ7X+Kfsjc8apDaX+WAYmAnymzAH5NmMF7PEKQaP
mtJ6RGZOAO6K/I/pZpNGTPXcUic+r51E/dkjlfFTe1kDYGVXe5T76urx1UoeCemS
kX+WfsJZYHxfA/1yXAgyDK0wcAwSDNgcT9jL0KE7EWLwawmzrdXNAiF3HgKSSyz3
EjMSAAVLj8dMeitQE1V9oIH3d5Ig43aWHI7D1wi2ZFGRn2Q7XZ5ORm5AvZVqGa+9
JOMjIdZ//4HXcgLxv5n4UHSRxNn50Mm15NWSjNhsfx+z3nbZcRi/2V9lglB2yhhk
bT4QxkfmYwlmYbEoSRZk6bTjeJxAeCli+BLYyDmHyiXmhz19uPbs+N5JLh4DlBea
0/O+1pemW3Z+8qGO88F+mSgsxip1nEbcqtuuY40NHfWquPo9R6LXRgTXSy3g3tsh
AvZ5KXQsIteLCNgv2veiBV1GUhLaLtwdw63vSgsVpsLYZDUfmVqzNi+9O9bUVRpI
oOdmTg1TlyVzIJH4pQaskxbi0o/J+CgyWt0KAHKiCel5bmbdExotrao870A5yk9b
5IOBVMMxtyLka12QcjxSvup01OTt+7DxbHMChWMxWpVMvQqW9h7Bd47rpRV8/UJ1
ZeNL1Df3eRW6lK9DX/NV
=wJNb
-----END PGP SIGNATURE-----

--=-ylRWJXiniZUHIcCQ9j2b--

