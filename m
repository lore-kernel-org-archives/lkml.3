Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367AbaJMJA5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 05:00:57 -0400
Received: from mail-qg0-f45.google.com ([209.85.192.45]:45215 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752876AbaJMJAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 05:00:54 -0400
Date: Mon, 13 Oct 2014 05:01:53 -0400
From: Tom Rini <trini@ti.com>
To: Jeroen Hofstee <jeroen@myspectrum.nl>
Cc: Simon Glass <sjg@chromium.org>, U-Boot Mailing List <u-boot@lists.denx.de>,
        lk <linux-kernel@vger.kernel.org>,
        "Yann E. MORIN" <yann.morin.1998@free.fr>,
        linux-kbuild@vger.kernel.org
Subject: Re: [U-Boot] [PATCH resend] kconfig: Fix compiler warning in menu.c
Message-ID: <20141013090153.GB25506@bill-the-cat>
References: <1413109527-10718-1-git-send-email-hdegoede@redhat.com>
 <543AA8BF.7090809@myspectrum.nl>
 <CAPnjgZ1KvytMYp3RHkMiuW8x6_x4uf=GUUUMoL9RAGsgP_cXrQ@mail.gmail.com>
 <543B75C7.60105@myspectrum.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eKYtUF67Wby7L9E8"
Content-Disposition: inline
In-Reply-To: <543B75C7.60105@myspectrum.nl>
Organization: Texas Instruments
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--eKYtUF67Wby7L9E8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 13, 2014 at 08:48:39AM +0200, Jeroen Hofstee wrote:
> Hello Simon,
>=20
> On 13-10-14 07:14, Simon Glass wrote:
> >Hi Jeroen,
> >
> >On 12 October 2014 10:13, Jeroen Hofstee <jeroen@myspectrum.nl> wrote:
> >
> >>Hello Hans,
> >>
> >>On 12-10-14 12:25, Hans de Goede wrote:
> >>
> >>>Hi,
> >>>
> >>>This one seems to have fallen through the cracks.
> >>>
> >>>Regards,
> >>>
> >>>Hans
> >>>
> >>>  (for U-boot)
> >>nope, you replace an innocent warning (_might_ be) with
> >>bad code, without any comment it is just because gcc failed
> >>to recognize it is fine. Nor did you respond to the suggestion
> >>if it helps gcc to recognize that if the two booleans are merged
> >>into a single one. [or even split it in an if () if ()]. With this patch
> >>you prevent any serious warning in case the variable is actually
> >>used but not initialized, which is even worse if you ask me.
> >>
> >That is a pretty acerbic tone to take on the U-Boot list at least. Are y=
ou
> >two drinking buddies or something?
>=20
> no, it is because we have discussed this patch before and resending
> it won't address the issue raised. But you are right, it is likely done w=
ith
> less evil intends then I took it for, so let me explain my concern again
> in a politer way. The problem is that gcc 4.9 starts warning in the
> following case:
>=20
> int *ptr;
>=20
> if (a)
>     ptr =3D something;
>=20
> if (a && b)
>     ptr->bla =3D value;
> else
>    do_something_else();
>=20
>=20
> it will warn that ptr _might_ be used uninitialized (but it always is).
> This is fixed in this patch by assigning NULL to ptr, and while that makes
> the warning go away it actually prevents the valid warning, ptr _is_ used
> uninitialized if you start using it in the else case. Hence my request if=
 we
> can't find a better solution for this.
>=20
> Does anyone know a better solution for this or should we consider
> disabling the might be unused warning?

Frankly, looking at the code, this is a compiler bug since as you note
the pointer will always be initalized.  Since we share this code as-is
with upstream kernel, we should see if there's any interst there in
trying to re-write the code so that it's (roughly):
if (a)
 ptr =3D valid;

if (a && b && ptr)
 ptr->foo =3D bar;

Or if this gets the required "compiler is being stupid, file a bug"
volume required.

--=20
Tom

--eKYtUF67Wby7L9E8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJUO5UBAAoJENk4IS6UOR1W4xUP/RqSw1jDdYhcq0c3N6w7CbJb
jjgZIOB+H204LcMEpv2cKuoQeVYU8cXacV5m4qSubQOQ/LOJDPy1gIdvpLjrwOgU
anWuOUEBwIai5vJUMLpjOlD+NWH2ySQ9IxHUyIHXXEfBX/sj2F/reyLbU54UzaKz
FulVNLfzAXll7NtaLyOS+4CsG9mHnnmQ3NkmSKImThNdk588XqieJrY2Wh7K/r0M
La+5uXUlBbg3O7vM7DdIBvClZNu/hSHr0MhXxVh0B+jReK0wbdsg87yi5V3VAJmz
Imx749ajN9cLXQrhiBzHVmTaeh9pBib/PPfZRwxU032GpwuKo3GhfAEdDEhPsA0e
M8UKo+wWlBYtojJ9A0mkjGQzO9rbH4ZcJl/FE8yf9aCSJcihNdxtmIM1kanIL4xH
9oWkMlqUPVhA5LtiGsIN1Pkwxwz3ftSRBw9Sjx0gYhLaecC+wPqrsSJtyO1EUSsF
Wh/Ls9NUBQf5DjPjxFvx3cSQZTNJydZbz6BY+Fr+LdruvHo5oxS13DdqrA9m+3sf
FbVBL4VntPUfAQWQIDz4PsZ+PXvdffsgKH4/Rn97IyzVY2emo3n87ecbpzkzgMZt
DmM2PWPsZEi6eOaP6v/yAZA7hTe9iOpvO42veL154NfpwkX8bcd4uzLTiNbZhkf7
yOXWskmc10aWkQ32fG/C
=UuO2
-----END PGP SIGNATURE-----

--eKYtUF67Wby7L9E8--
