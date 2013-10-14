Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751194Ab3JNGEv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 02:04:51 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:58913 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750796Ab3JNGEu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 02:04:50 -0400
Message-ID: <525B8973.3030807@ti.com>
Date: Mon, 14 Oct 2013 09:04:35 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: =?UTF-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<freemangordon@abv.bg>
CC: <pali.rohar@gmail.com>, <pc+n900@asdf.org>, <linux-kernel@vger.kernel.org>
Subject: Re: OMAPFB: CMA allocation failures
References: <950342286.150022.1381588988533.JavaMail.apache@mail83.abv.bg>
In-Reply-To: <950342286.150022.1381588988533.JavaMail.apache@mail83.abv.bg>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="dBPB20AaeVKfAox1CQ0oqX1gaXgx3NGgN"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--dBPB20AaeVKfAox1CQ0oqX1gaXgx3NGgN
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi,

On 12/10/13 17:43, =D0=98=D0=B2=D0=B0=D0=B9=D0=BB=D0=BE =D0=94=D0=B8=D0=BC=
=D0=B8=D1=82=D1=80=D0=BE=D0=B2 wrote:
>  Hi Tomi,
>=20
> patch http://lists.infradead.org/pipermail/linux-arm-kernel/2012-Novemb=
er/131269.html modifies
> omapfb driver to use DMA API to allocate framebuffer memory instead of =
preallocating VRAM.
>=20
> With this patch I see a lot of:
>=20
> Jan  1 06:33:27 Nokia-N900 kernel: [ 2054.879577] cma: dma_alloc_from_c=
ontiguous(cma c05f5844, count 192, align 8)
> Jan  1 06:33:27 Nokia-N900 kernel: [ 2054.914215] cma: dma_alloc_from_c=
ontiguous(): memory range at c07df000 is busy, retrying
> Jan  1 06:33:27 Nokia-N900 kernel: [ 2054.933502] cma: dma_alloc_from_c=
ontiguous(): memory range at c07e1000 is busy, retrying
> Jan  1 06:33:27 Nokia-N900 kernel: [ 2054.940032] cma: dma_alloc_from_c=
ontiguous(): memory range at c07e3000 is busy, retrying
> Jan  1 06:33:27 Nokia-N900 kernel: [ 2054.966644] cma: dma_alloc_from_c=
ontiguous(): memory range at c07e5000 is busy, retrying
> Jan  1 06:33:27 Nokia-N900 kernel: [ 2054.976867] cma: dma_alloc_from_c=
ontiguous(): memory range at c07e7000 is busy, retrying
> Jan  1 06:33:27 Nokia-N900 kernel: [ 2055.038055] cma: dma_alloc_from_c=
ontiguous(): memory range at c07e9000 is busy, retrying
> Jan  1 06:33:27 Nokia-N900 kernel: [ 2055.038116] cma: dma_alloc_from_c=
ontiguous(): returned   (null)
> Jan  1 06:33:27 Nokia-N900 kernel: [ 2055.038146] omapfb omapfb: failed=
 to allocate framebuffer
>=20
> errors while trying to play a video on N900 with Maemo 5 (Fremantle) on=
 top of linux-3.12rc1.
> It is deffinitely the CMA that fails to allocate the memory most of the=
 times, but I wonder
> how reliable CMA is to be used in omapfb. I even reserved 64MB for CMA,=
 but that made no
> difference. If CMA is disabled, the memory allocation still fails as ob=
viously it is highly
> unlikely there will be such a big chunk of continuous free memory on RA=
M limited device like
> N900.=20
>=20
> One obvious solution is to just revert the removal of VRAM memory alloc=
ator, but that would
> mean I'll have to maintain a separate tree with all the implications th=
at brings.
>=20
> What would you advise on how to deal with the issue?

I've not seen such errors, and I'm no expert on CMA. But I guess the
contiguous memory area can get fragmented enough no matter how hard one
tries to avoid it. The old VRAM system had the same issue, although it
was quite difficult to hit it.

64MB does sound quite a lot, though. I wonder what other drivers are
using CMA, and how do they manage to allocate so much memory and
fragment it so badly... With double buffering, N900 should only need
something like 3MB for the frame buffer.

With a quick glance I didn't find any debugfs or such files to show
information about the CMA area. It'd be helpful to find out what's going
on there. Or maybe normal allocations are fragmenting the CMA area, but
for some reason they cannot be moved? Just guessing.

There's also dma_declare_contiguous() that could be used to reserve
memory for omapfb. I have not used it, and I have no idea if it would
help here. But it's something you could try.

 Tomi



--dBPB20AaeVKfAox1CQ0oqX1gaXgx3NGgN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJSW4lzAAoJEPo9qoy8lh71JUwP/3dqkEeuGfPFNBtFKi73l/ud
GaudwHCD3bon7arDe2fWIM0qZlmn4V8i3NoCxPLfEZSoXDQqXKgCJbgy1tXpsk71
6DiG2h11cZ8tpIHeIg1FdzFO3EfbZGGFFri+c1pTtfynpccr3KIkSGG2DLaK1y9n
iBcet5uoA0qukUfI3JNdzFZKc6lOBLnwecGrjE43cv6/U061/YYqEQ/AxtHbxs8O
Y/zWKU8/oOhHgxnlo9zR/FHfx8gi7LgfI7154pgh/z1bbjI/9CDvPB52cLqnKs+K
KIK9nKKEDpUn8eR9QGnVWE1bsyRHSnTIgG/I18jH2tT3yJ1km6qTdLP/NnGeVrpW
LEbxdNWUDYslMUzggudAqahY5pLov9OsW4mnCUurNQiMXvF//PFjpNfGGiink1zE
c37l/6ctwPavhFmp35Yk17/imJvNi5SHshoqULHhqSF1/BAgyINm2yEBeL4DZj6S
hHYxShRdemdfPsf9V+A0cFqvV281B12ZvdyK7MOLJ9xkLGr3IKJyaGgYsF8lbfwd
kY0EvhfqmQ2Ja10pVPUf7zZabLaYpgUPSMqOmupo6Mw+6AAMgmUqi+evn9Ox9ldB
b/lWmQo2YdV2RNQjHtx5zZlnnmTCiIR+J2QasNG/PR9J9jY1tgN6OiPeC59URaoX
DSUkAiBLah3JxY5+2PdP
=vj0p
-----END PGP SIGNATURE-----

--dBPB20AaeVKfAox1CQ0oqX1gaXgx3NGgN--
