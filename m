Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751656AbaGKAcb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 20:32:31 -0400
Received: from ozlabs.org ([103.22.144.67]:50434 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751313AbaGKAc3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 20:32:29 -0400
Date: Fri, 11 Jul 2014 10:32:21 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jianqun <xjq@rock-chips.com>
Cc: Jim Davis <jim.epost@gmail.com>, linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, lgirdwood@gmail.com,
        broonie@kernel.org, perex@perex.cz, tiwai@suse.de,
        grant.likely@linaro.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org
Subject: Re: randconfig build error with next-20140710, in
 sound/soc/rockchip/rockchip_i2s.c
Message-ID: <20140711103221.70c856fb@canb.auug.org.au>
In-Reply-To: <53BF2AB8.7050307@rock-chips.com>
References: <CA+r1ZhgB=BG5jsSaWBLMvRUjZ=X4gKJzv6KysyvPSOtFuUTbng@mail.gmail.com>
	<53BF2AB8.7050307@rock-chips.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/3SaueMEO6+a84lsp2H+BZl="; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/3SaueMEO6+a84lsp2H+BZl=
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Jianqun,

On Fri, 11 Jul 2014 08:07:20 +0800 Jianqun <xjq@rock-chips.com> wrote:
>
> Is it caused by the headfile ?
> #include <linux/module.h>
>=20
> Adviced by the maintainers, I tried not to include the headfile one by on=
e, then to compile
> driver each time, I found that is success to compile it without module.h,=
 of course

Who ever gave you that advice is wrong.  You should always (except in
very rare circumstances) include every header file that your code
references things from.  We have over 20 architectures and many, many
possible configurations in the kernel build system and the fact that a
file builds for one is not guarantee that it will build for another
combination if you depend on implicit includes.

See Rule 1 in Documentation/SubmitChecklist.

> I just compiled driver with command "ARCH=3Darm".

Which just proves my point.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/3SaueMEO6+a84lsp2H+BZl=
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJTvzCaAAoJEMDTa8Ir7ZwVyL8P/2PY6YGi7UgSv5n6CMNMqHnX
bgmdmtYVTfAp8G8XjUtkV5gXw5+i+53X1+3mtt7z5r8gCyg7Th1d4PE3eDBD9u3v
m1rjh2hiUKwYZ7tgu8aWXZiRnv6NT10He2ixGlK89ipoM1gDC5rBki8JV1Ed2uS2
ocvLkLuhyYS5wEk0AGpZmFI8jAgb5MhoMV9gjHOZowgn3Cb9GPelDvQxTt5TAyLt
VMfz2y+D7yx3aOv3+ni/e30etZkl7Jt3/4SldZYUQjLI4aThOC/hUcxZ/R/WjfFO
xGR9a09wWNKDFI1igYrmRZ5qD7Y2KuulB5lxHNISas/WBH21MTS1IAvN1RDXL4Qw
W8AAWp92VvFFD3Bh7S/voxo1/87CpHfFKTpxdazRnS8DSLIx27lV2ioOT13sfpB8
9PqKU9PklsTcWV3OdaPhuKzUPFu5QY8C1OdouaxmoYPUJ9tpqsnG0QdE6AEaovD4
+Auh04d3hxc2e/IpYOA8q1Rru+X6+n7URnMi6knRcdM+uILq3CSrY0Bl1j3H2dFp
ezF0JUsHSlk3ZIv64O2D/x/qhkGAyKP/dyOxWltKxMAE4NOp0P8PgNfDSiKKJyis
UxdlaTfolYJjMLW9gCXsFHJ+kJWHyLPeR6I9nQiAZlhsQEbFdbRnfNeiaugiHMAm
f8VK3x/U9hsQZ2Db/nfo
=m2KO
-----END PGP SIGNATURE-----

--Sig_/3SaueMEO6+a84lsp2H+BZl=--
