Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752011AbbABLyT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 06:54:19 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:3203 "EHLO
	imgpgp01.kl.imgtec.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750765AbbABLyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 06:54:18 -0500
X-PGP-Universal: processed;
	by imgpgp01.kl.imgtec.org on Fri, 02 Jan 2015 11:54:16 +0000
Message-ID: <54A686E6.1040105@imgtec.com>
Date: Fri, 2 Jan 2015 11:54:14 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
CC: Ralf Baechle <ralf@linux-mips.org>,
        Markos Chandras <markos.chandras@imgtec.com>,
        Paul Burton <paul.burton@imgtec.com>,
        "Leonid Yegoshin" <Leonid.Yegoshin@imgtec.com>,
        John Crispin <blogic@openwrt.org>, <linux-mips@linux-mips.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arch: mips: kernel: traps: Remove some unused functions
References: <1420134507-540-1-git-send-email-rickard_strandqvist@spectrumdigital.se>	<54A67541.7040707@imgtec.com> <CAKXHbyOLteCgVH8OMrB9zr6=eCmM8qQBN4o4_HN086mhHg+DJw@mail.gmail.com>
In-Reply-To: <CAKXHbyOLteCgVH8OMrB9zr6=eCmM8qQBN4o4_HN086mhHg+DJw@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="J8l00NWcLWnM75iOfAL4gMOMmFVtNxgWl"
X-Originating-IP: [192.168.154.101]
X-ESG-ENCRYPT-TAG: da4c5968
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--J8l00NWcLWnM75iOfAL4gMOMmFVtNxgWl
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 02/01/15 11:20, Rickard Strandqvist wrote:
> 2015-01-02 11:38 GMT+01:00 James Hogan <james.hogan@imgtec.com
> <mailto:james.hogan@imgtec.com>>:
>=20
>     On 01/01/15 17:48, Rickard Strandqvist wrote:
>     > Removes some functions that are not used anywhere:
>     > do_bp() do_ftlb() do_dsp() do_mcheck() do_mdmx() do_msa() do_msa_=
fpe()
>     >
>     > This was partially found by using a static code analysis program =
called cppcheck.
>=20
>     To elaborate on Leonid's comment, These functions are used from
>     arch/mips/kernel/genex.S. See BUILD_HANDLER assembly macro. Each on=
e
>     builds a handle_* assembly function which saves appropriate excepti=
on
>     state and calls do_*() with return address pointing to
>     ret_from_exception. The handle_* functions are set as handlers for
>     various exceptions by set_except_vector() in arch/mips/kernel/traps=
=2Ec.
>=20
> Hi
>=20
> Nope no New Years joke, did not even know they were something that
> occurred:)
>=20
> My tests before submitting a patch is to search through the entire
> kernel after function name, see if it seems reasonable, Delete and test=

> build three times as allyesconfig allmodconfig allnoconfig.
>=20
> Is not mips a port of these build?

If you built on a PC then you probably would have built x86_64 kernel
images which wouldn't have used any code in arch/ except arch/x86/. To
build for another architecture you need a cross compiler, and use e.g.
ARCH=3Dmips CROSS_COMPILE=3D/path/to/your/mips-linux- on your make comman=
d
line, both for the *config target and for the build itself.

In any case your best bet to know whether a source file is actually
built by the configuration (e.g. for the platform specific code you're
touching in other patches) is to check whether a corresponding .o file
is created by the build or use something like #error. Kernels are
generally built for a single platform on MIPS at the moment rather than
all of them.

You may find the following link useful to quickly get cross compilers
for different architectures:

https://www.kernel.org/pub/tools/crosstool/

Cheers
James

>=20
> Kind regards
> Rickard Strandqvist


--J8l00NWcLWnM75iOfAL4gMOMmFVtNxgWl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUpobmAAoJEGwLaZPeOHZ63zIP/0IzaxCUsw6U6Oi6R5UbH0L1
zO4F9EFUniq2fbf+w3SvOBBoDAp2mfIrYRi/2qIFZyTgbR0Bij+D7Di5Ylb1cRLN
staGp+8ZJF8M0yfcTNC1eNhwhZ/fEn4nGhuRsC3mAQyuAGrGcvA6Hwp3zMljntX+
fDQhjkCubddYQt7L3uGCtX+3U1EOgE3H1pW7V3IhBq8Gi/SueSiXzFIegjNTHQ3i
z5sjk9vGN31r1VLWI+n9jV2t7g/LrtW3qnO0K60lc1S40U2uIzMG89SkkD2tDxNY
mqewnmfDjx+wo/tEt2a7r7mJ7gzsZZsd9MxpUTocuBJQOuBWnlvyUBWXfe8jpC4l
4ydqNm9yKKJLSACFeEeacb4bLYuxkGiVzTOT4MCXgt18Cs1cd6RYMoKiBxl1ZepD
s8JpCVA+XP455VZIfBKpCOx40pyd4yl7buN5Cd4B++edGkbkD/3aMVZDga4pTTPY
ysTqSpy7AjESAUZZexuA6EKY3AaAJVUlYs7+pt2/hvREA9+8JCqf9A1N3f1sHAa6
oVtXtxFC7ZICd/tF6jF2txlMotBMmOKtHtvsWtJ/xi41uwWWj9FaxKYGSq9rDE4b
k/1jpor4rPQYG8GpblVZEYl7BVQm8gkGCMIlCFI/sUGNuJHgcSKyD5wFZl4Ui8jx
ajF8HOToKbq503DwOmcS
=Zong
-----END PGP SIGNATURE-----

--J8l00NWcLWnM75iOfAL4gMOMmFVtNxgWl--
