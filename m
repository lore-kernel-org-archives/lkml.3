Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754319AbaCCKMo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 05:12:44 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:45049 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753750AbaCCKMm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 05:12:42 -0500
Message-ID: <53145591.4070004@ti.com>
Date: Mon, 3 Mar 2014 12:12:33 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: David Herrmann <dh.herrmann@gmail.com>, <dri-devel@lists.freedesktop.org>
CC: Ingo Molnar <mingo@kernel.org>, <linux-fbdev@vger.kernel.org>,
        Dave Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, <linux-kernel@vger.kernel.org>,
        Tom Gundersen <teg@jklm.no>
Subject: Re: [PATCH 00/11] SimpleDRM & Sysfb
References: <1390486503-1504-1-git-send-email-dh.herrmann@gmail.com>
In-Reply-To: <1390486503-1504-1-git-send-email-dh.herrmann@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="RC68gLni9ceQvHrJ9vPhe5OjFqhaqk9gW"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--RC68gLni9ceQvHrJ9vPhe5OjFqhaqk9gW
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,

On 23/01/14 16:14, David Herrmann wrote:
> Hi
>=20
> Another round of SimpleDRM patches. I somehow lost track of the last on=
es and as
> this is a major rewrite, I'll just start at v1 again.
>=20
> Some comments up-front:
>=20
>  - @Ingo: Patch #1 and #2 are unchanged from the previous ML discussion=
s. I
>    included them in this series as the other patches depend on them. Co=
uld you
>    pick them up for the x86 tree? The other 9 patches won't make it in =
3.14 so
>    no reason to put them through the DRM tree.
>    All mentioned issues should be addressed. If there's still sth missi=
ng,
>    please let me know.
>=20
>  - The DRM patches depend on my "DRM Anonymous Inode" patches. But it s=
hould be
>    trivial to apply them on drm-next (I think only one line needs to be=
 changed:
>    i_mapping =3D> dev_mapping).
>=20
>  - I tested the SimpleDRM fbdev fallback with linux-console+Xorg and it=
 works
>    fine. The DRM backend is only tested with some DRM tests I have loca=
lly. I
>    have no idea how to make Xorg pick up a specific /dev/dri/card0 card=
=2E It
>    always tells me "no screens found" (as the underlying device is not =
marked as
>    boot_vga..). If someone knows how to tell Xorg to use card0, I'd gla=
dly test
>    this. But I'm no longer used to writing xorg.confs..
>=20
>=20
> This series introduces two new concepts: sysfb and SimpleDRM
> Sysfb is just a generalization of the x86-sysfb concept. It allows to r=
egister
> firmware-framebuffers with the system as platform-devices. This way, dr=
ivers can
> properly bind to these devices and we prevent multiple drivers from acc=
essing
> the same firmware-framebuffer.
> Sysfb also provides hooks to get a safe handover to real hw-drivers (li=
ke i915).
> Please see the "video: sysfb: add generic firmware-fb interface" patch =
for a
> thorough description of the API. This patch also adds a rather verbose
> documentation of all known firmware-fb facilities.
>=20
> As second part, this series introduces SimpleDRM. It's a very basic DRM=
 driver
> that can replace efifb, vesafb, simplefb and friends. It's 100% compati=
ble to
> the "udl" DRM driver, so user-space like xf86-video-modesetting can pic=
k them up
> just fine. User-space that cannot deal with drmModeDirtyFB() (like west=
on and
> friends) currently cannot use SimpleDRM. However, that's also true for =
all other
> DRM drivers which provide shadow framebuffers. We could provide somethi=
ng like
> FB-DEFIO, but that's just useless overhead to paper of lazy user-space.=

>=20
> I have tested this with all hardware that I have at home, with a lot ha=
nd-over
> combinations (with/without SYSFB, with efifb/vesafb/simplefb, with Simp=
leDRM,
> ...) and all worked great so far.

What's the status with this one? Headed for 3.15?

Are the SimpleDRM and sysfb linked somehow? (I.e. do they need to be in
the same series?)

And jfyi, the drivers/video/ changes will conflict with the
drivers/video/ directory reorganization series, which may be merged for
3.15.

 Tomi



--RC68gLni9ceQvHrJ9vPhe5OjFqhaqk9gW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTFFWRAAoJEPo9qoy8lh715kQP/jz8q3O1kWOClkx1DCEr/K1V
UoVTzeU2OcjZtl/N5rrtXvalJxqMI02nNQpvCzZPZgjSlezAJhF30iyQmJXtmq+x
ZhiFjTK1l+zKpRL/imvp97fnP8kMosv3JKFxSv3ZfvQjQx6gpAw4UjUWfYwLSUK9
TNj6tgXTTiGkZAel4zL4hTeTQzlZ1p/PIPtF6h0SNsQiehHKJTnLsnqPAszCg4Ty
OElNYX/C53J5lCcv2CZiulwwkWbRDgdIEc+fXeWc8kVw3T0vtd8ILFhPOlMU37oX
HNkCbHmAJ81LGpe6kOAEA2CsehmJFi3CvyH6MPN4O+/aXOmAtUfwLRnRrHhs9bDj
ARVCfP4XOPi1TB5XjtkgrKfvjZ6cxfpFoLi5QL7D7I3HZ6qczE/ay7bCtWFN2/IM
+aDmeAd9zWGNDgdA3FpEqv/ozywOwnoHkmx2KaIvvS6dcvrCIvnpEm0BUygznCi5
RQ0YAA4Rdu+D+8lzY0xBBVmkuhc5GtnLHmuBfZJguWJZJ4mSD6Y6jSAgRj7ALZwE
EHGWcXUQGPJmkwT3TzhECsjxrydtceXi/RRCNJgch4mom5ckAk10d/Bl98+cWSob
qNBZbwbKGxrjANhRVQY5ttGBIjto5Rb5xJZHMgjzGimdAgmpQ6AS2JwASWBCVucM
wRRKRLb7cSAMI+CXW0fC
=fd/2
-----END PGP SIGNATURE-----

--RC68gLni9ceQvHrJ9vPhe5OjFqhaqk9gW--
