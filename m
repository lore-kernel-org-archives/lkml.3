Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935724Ab3DJCei (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 22:34:38 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35902 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762730Ab3DJCeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 22:34:36 -0400
Message-ID: <1365561254.5814.44.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 3.8.y] drm/i915: add quirk to invert brightness on
 eMachines e725
From: Ben Hutchings <ben@decadent.org.uk>
To: Josh Boyer <jwboyer@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Jani Nikula <jani.nikula@intel.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 10 Apr 2013 03:34:14 +0100
In-Reply-To: <20130409142230.GD32476@hansolo.jdub.homelinux.org>
References: <20130409123833.GC32476@hansolo.jdub.homelinux.org>
	 <87y5crpzct.fsf@intel.com>
	 <20130409142230.GD32476@hansolo.jdub.homelinux.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-KcRV7n0IDH0Z39tWh2Qq"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:e0f7:a9f9:4e26:347a
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-KcRV7n0IDH0Z39tWh2Qq
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2013-04-09 at 10:22 -0400, Josh Boyer wrote:
> On Tue, Apr 09, 2013 at 05:12:18PM +0300, Jani Nikula wrote:
> > On Tue, 09 Apr 2013, Josh Boyer <jwboyer@redhat.com> wrote:
> > > Upstream commit 01e3a8feb40e54b962a20fa7eb595c5efef5e109
> >=20
> > This patch seems to be the above commit and
> >=20
> > commit 1ffff60320879830e469e26062c18f75236822ba
> > Author: Jani Nikula <jani.nikula@intel.com>
> > Date:   Tue Jan 22 12:50:34 2013 +0200
> >=20
> >     drm/i915: add quirk to invert brightness on eMachines G725
> >=20
> > squashed together. There's a separate bug for that too:
> > https://bugs.freedesktop.org/show_bug.cgi?id=3D59628
>=20
> Oh...  that actually does seem to be the case.  I did a cherry-pick
> of just the commit I mentioned on top of 3.8.6 and it seems I resolved
> the conflict by including in changes for both.  The conflict came up as:
>=20
> <<<<<<< HEAD
>         /* Acer Aspire 4736Z */
>         { 0x2a42, 0x1025, 0x0260, quirk_invert_brightness },
> =3D=3D=3D=3D=3D=3D=3D
>         /* Acer/eMachines G725 */
>         { 0x2a42, 0x1025, 0x0210, quirk_invert_brightness },
>=20
>         /* Acer/eMachines e725 */
>         { 0x2a42, 0x1025, 0x0212, quirk_invert_brightness },
> >>>>>>> 01e3a8f... drm/i915: add quirk to invert brightness on eMachines =
e725
>=20
> Thanks for catching that.
>=20
> > I think both are okay for stable, but by the stable rules you should
> > probably split this up, with the appropriate upstream references in
> > both. Or do whatever the stable team tells you to do. ;)
>=20
> Yeah.  I'm happy to split them up and send them out separately.  Or if
> Greg wants to just list both upstream commit IDs with a single backport,
> that would also be fine.

I cherry-picked the following series for Debian:

[pre-3.8]
7bd90909bbf9 drm/i915: panel: invert brightness via parameter
4dca20efb1a9 drm/i915: panel: invert brightness via quirk
5a15ab5b93e4 drm/i915: panel: invert brightness acer aspire 5734z
5f85f176c2f1 DRM/i915: Add QUIRK_INVERT_BRIGHTNESS for NCR machines.
[post-3.8]
1ffff6032087 drm/i915: add quirk to invert brightness on eMachines G725
01e3a8feb40e drm/i915: add quirk to invert brightness on eMachines e725
5559ecadad5a drm/i915: add quirk to invert brightness on Packard Bell NCL20

Should these all be applied to the various 3.x.y stable branches?

Ben.

--=20
Ben Hutchings
The program is absolutely right; therefore, the computer must be wrong.

--=-KcRV7n0IDH0Z39tWh2Qq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUWTPpue/yOyVhhEJAQrRtA/6AtBASNBMgN/Lo/mvdyX4o3LHwQIb03q0
fnwA3HKfJWxRsSDXnkfr9ktC5zR42gvVyhuooue5zvhIfh7rMycAwuKBZ3kRhyib
3K/KsDHD4CS+UA/uAVdmB0mwmF0/3DD+YK0dvQjke+v2MEp0QIxfjkMl9RyhPe/z
5YCGNG46cRy078f3f+/DrIRjyJgpDmLnjNQ1SQmWtfXLxnY+bFFszaAe7g8IoavG
tved53EGgvIMX0I/uz7POwM+PSRL3OMzn5ZHPuxtraKFrmZdWMmGf0rqktXjkp+N
7LDccJsoVfpzJ4RJt6J+Box0kAOd/j0vkVXNLegnv0niEF13SMdpLPOhoRwWOKKi
++K6sZ9XP6PIZm0PQE6LodTLLNCbzC2Rfgx79nE/LPd4E3eaClwF3mBZYUgZXweE
oVIMSY+QGjokgrQqMN87qYlUYWrJieAZ2jNvl3rJRRTVXnQ1tneKi8Ym9XjOF6YG
n77bnwlNq8+ohdRrimyUQF5PZw/VV5o70ItB/GD37uDzcJvVxj50ju+iPeAv/Ozz
xabZdze8NnwgKQ/ucJ7KNNAb6HKd+51dFdwZ77ujtDGE4SxtVpMxmEeoS+f6cPlN
DdRzzQ4mxB1x/Z+js+y+J9DDX/gEtU8u0aOv+seE9oSN//i8pycSWkLMKlYM2WCK
oVi2vp6gtSs=
=nf5F
-----END PGP SIGNATURE-----

--=-KcRV7n0IDH0Z39tWh2Qq--
