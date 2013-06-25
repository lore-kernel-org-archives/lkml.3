Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247Ab3FYUpG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 16:45:06 -0400
Received: from smtp3-g21.free.fr ([212.27.42.3]:42359 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753149Ab3FYUpB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 16:45:01 -0400
Message-ID: <1372193037.8189.24.camel@scapa>
Subject: Re: [PATCH 0/3] Fix backlight issues on some Windows 8 systems
From: Yves-Alexis Perez <corsac@debian.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-acpi@vger.kernel.org, seth.forshee@canonical.com,
        joeyli.kernel@gmail.com, daniel.vetter@ffwll.ch,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, lenb@kernel.org, rjw@sisk.pl,
        Henrique de Moraes Holschuh <hmh@debian.org>
Date: Tue, 25 Jun 2013 22:43:57 +0200
In-Reply-To: <20130625160848.GA27123@srcf.ucam.org>
References: <1370818899-8595-1-git-send-email-matthew.garrett@nebula.com>
	 <1371937599.17761.19.camel@scapa> <20130625160848.GA27123@srcf.ucam.org>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-h0qekHEZ+L+n3AONK2yC"
X-Mailer: Evolution 3.8.2-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-h0qekHEZ+L+n3AONK2yC
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On mar., 2013-06-25 at 17:08 +0100, Matthew Garrett wrote:
> On Sat, Jun 22, 2013 at 11:46:39PM +0200, Yves-Alexis Perez wrote:
>=20
> > Before Linux support for acpi_osi("Windows 2012") (and when booting wit=
h
> > acpi_osi=3D"!Windows 2012"), brightness keys were handled by the kernel
> > just fine, whether in console, in the display manager or in my desktop
> > environment (Xfce). xfce4-power-manager just needs to be told that the
> > brightness keys are already handled and it doesn't need to do anything.
>=20
> Right, the kernel has special-casing to hook the backlight keys up to=20
> the ACPI backlight control. This is an awful thing, because there's no=
=20
> way to detect this case other than parsing a single driver-specific=20
> module parameter.

I'm not sure what that means. To detect what case exactly? That the
brightness is handled by video.ko?
>=20
> Could this functionality be duplicated across other backlight drivers?=
=20
> Not easily. The ACPI driver receives keypresses and performs backlight=
=20
> control. The i915 driver doesn't receive keypresses. We could easily tie=
=20
> certain keycodes into backlight events, but which backlight should they=
=20
> control? You're really starting to get into the kind of complex policy=
=20
> decision that's best left to userspace, which is where it should have=20
> been to begin with.
>=20
Well, I get the reasoning, but I'm not sure I agree. That means
userspace behavior is inconsistent depending on who does it
(gnome-power-manager, gnome-setting-daemon, whatever), and it usually
means there's nothing handling the brightness before those are running,
not to mention people not running them because they don't run a full
blown desktop environment (until someone starts thinking it's a good
idea to handle brightness in systemd).

And in the end, the user just want the brightness keys to correctly
handle the brightness, full stop. Having multiple brightness daemons
using different policies on different hardware is a nightmare for the
end user, imho. From a user point of view, having it handled all in the
kernel works really pretty fine and is completely transparent (I have to
admit that from that point of view, it was even better when it was
handled by the EC but those times seem long gone).

Regards,
--=20
Yves-Alexis

--=-h0qekHEZ+L+n3AONK2yC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQEcBAABCAAGBQJRygENAAoJEG3bU/KmdcCl3PgIAJWjGaTnGC4da9Pb1h4Wtyvu
fGVBCqky+23sKfVovt8BjgU0asnRoZ+4pkz6QSbLlU/hVsD27m+2i0k4/bdrxOzK
2AT+SqcWXE+leObHHe181SnFC9xglXxz8HnzxzUnNoTDWuOzXdNQWNQfh5iLqaq5
Qqiiu6wNZttHzlD0Yb3ym/jtM0OuhZ/K3HHULlqOxLxOuHqDuvbFIW03+MJPrq0L
HYNR5SGb+NQER9h4CCx1pS8VO+86ofB4a7QicjOSWALAG+mgBdOzCbP43q4GJncU
R+IUHtO4piTArTo3ckfI2Yc78jz4kzj7CqyeS+jBpxXtMjvBbA8Z5rHJM8auePk=
=ddvU
-----END PGP SIGNATURE-----

--=-h0qekHEZ+L+n3AONK2yC--
