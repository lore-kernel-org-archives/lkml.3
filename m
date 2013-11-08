Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756793Ab3KHIp3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 03:45:29 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:49279 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756258Ab3KHIp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 03:45:26 -0500
Date: Fri, 8 Nov 2013 19:45:11 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <axboe@kernel.dk>
Cc: Stephen Warren <swarren@wwwdotorg.org>, Tomasz Figa <t.figa@samsung.com>,
        Tushar Behera <tushar.behera@linaro.org>, linux-next@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        Chris Mason <chris.mason@fusionio.com>
Subject: Re: Boot failure on Arndale with next-20131105
Message-Id: <20131108194511.545e99151b4fe5efb9ed6f0f@canb.auug.org.au>
In-Reply-To: <5279622C.8040509@kernel.dk>
References: <CAHbNUh1Cw3bc4WR0VcD1H_eKYqGBtv_215_euh6mwTbZ41ejUw@mail.gmail.com>
	<1451170.jb5zbRXgpt@amdc1227>
	<52792D13.70704@wwwdotorg.org>
	<5279622C.8040509@kernel.dk>
X-Mailer: Sylpheed 3.4.0beta6 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__8_Nov_2013_19_45_11_+1100_oDf0H/C1P1yURSh3"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__8_Nov_2013_19_45_11_+1100_oDf0H/C1P1yURSh3
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jens,

On Tue, 05 Nov 2013 14:25:00 -0700 Jens Axboe <axboe@kernel.dk> wrote:
>
> On 11/05/2013 10:38 AM, Stephen Warren wrote:
> > I note that compiling next-20131105 generates quite a few warnings re:
> > uninitialized variables. Reverting the commit doesn't solve those.
> >=20
> >> block/blk-merge.c: In function =E2=80=98blk_bio_map_sg=E2=80=99:
> >> block/blk-merge.c:133:8: warning: =E2=80=98bvprv.bv_len=E2=80=99 may b=
e used uninitialized in this function [-Wmaybe-uninitialized]
> >> block/blk-merge.c:233:23: note: =E2=80=98bvprv.bv_len=E2=80=99 was dec=
lared here
> >> block/blk-merge.c:133:8: warning: =E2=80=98bvprv.bv_offset=E2=80=99 ma=
y be used uninitialized in this function [-Wmaybe-uninitialized]
> >> block/blk-merge.c:233:23: note: =E2=80=98bvprv.bv_offset=E2=80=99 was =
declared here
> >> block/blk-merge.c:133:8: warning: =E2=80=98bvprv.bv_page=E2=80=99 may =
be used uninitialized in this function [-Wmaybe-uninitialized]
> >> block/blk-merge.c:233:23: note: =E2=80=98bvprv.bv_page=E2=80=99 was de=
clared here
> >> block/blk-merge.c: In function =E2=80=98blk_rq_map_sg=E2=80=99:
> >> block/blk-merge.c:133:8: warning: =E2=80=98bvprv.bv_page=E2=80=99 may =
be used uninitialized in this function [-Wmaybe-uninitialized]
> >> block/blk-merge.c:171:23: note: =E2=80=98bvprv.bv_page=E2=80=99 was de=
clared here
> >> block/blk-merge.c:133:8: warning: =E2=80=98bvprv.bv_offset=E2=80=99 ma=
y be used uninitialized in this function [-Wmaybe-uninitialized]
> >> block/blk-merge.c:171:23: note: =E2=80=98bvprv.bv_offset=E2=80=99 was =
declared here
> >> block/blk-merge.c:133:8: warning: =E2=80=98bvprv.bv_len=E2=80=99 may b=
e used uninitialized in this function [-Wmaybe-uninitialized]
> >> block/blk-merge.c:171:23: note: =E2=80=98bvprv.bv_len=E2=80=99 was dec=
lared here
> >> block/blk-merge.c: In function =E2=80=98attempt_merge=E2=80=99:
> >> block/blk-merge.c:108:7: warning: =E2=80=98end_bv.bv_offset=E2=80=99 m=
ay be used uninitialized in this function [-Wmaybe-uninitialized]
> >> block/blk-merge.c:89:17: note: =E2=80=98end_bv.bv_offset=E2=80=99 was =
declared here
> >> block/blk-merge.c:108:7: warning: =E2=80=98end_bv.bv_page=E2=80=99 may=
 be used uninitialized in this function [-Wmaybe-uninitialized]
> >> block/blk-merge.c:89:17: note: =E2=80=98end_bv.bv_page=E2=80=99 was de=
clared here
> >> block/blk-merge.c:108:7: warning: =E2=80=98end_bv.bv_len=E2=80=99 may =
be used uninitialized in this function [-Wmaybe-uninitialized]
> >> block/blk-merge.c:89:17: note: =E2=80=98end_bv.bv_len=E2=80=99 was dec=
lared here
>=20
> Looks like an incomplete merge. The patch to silence those warnings
> (which aren't bugs, BTW) is definitely in my for-next branch.

I am still getting those warnings in linux-next for various builds
(include 1386 defconfig).  Any hints would be good.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__8_Nov_2013_19_45_11_+1100_oDf0H/C1P1yURSh3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSfKSbAAoJEMDTa8Ir7ZwVVfYP/2QAPYFpZWnvh9/kNAxKpPx9
SLplRxcGzPh8azlgwAaQxlD3jOp94B8vwmtdUqcGSChBPUIOVDsR1F+D7dzGK6es
KawfriA7pynnAv/0RhvM/LQWYHwxqqp19Nt7TlibjOmQLPTZvvsCZm7ZAxClbyHL
ekyh5gnd39Mbo9TOejRSyYXJYmto4wbnc8dA3KW2NnU2kOlZnN5zHd0+TFba37vy
Vb1hvWQDy3iVNvuZImd+r/kZPvKCq4s09dD75mj2X5GciWV9IJ2pIBPjqE8LeBrX
4RxwPRG3VKUfNPDDUPe4jB4Y8bv9wGIHwSf3eOKSblrgMNrPVEKWWAK+F9vIBtMy
J2Ra0mnLWikDCZ2PfhVPaUrUGlK5/ievKUEevE+RcV4Ok7t32ZszGtzbFMUbQR8d
XQDauyZyGxLrL3jQ4z5ojIAI6dCOmjthArTxafT6LLGxDrmhC67N5BdpaibN1tzN
z9EwIgM1socCMji8/WG7nC/2dFd++BqEP22YpJUp603rYVXx/98V4xAdhcWG+GLD
6oFm5B/2+Yl95abv4pHgXlT9muyBDRQFxs8HsFLzjROWURTz0LmiJV53HzFt9cVg
0nGSZHVsZX4xtgP/vWdnwTIBYRnHdccDIfxC5dt2a65QTPwJQLnP9Puqiix/bgn4
YRefDIxehRDNjZ9DaPyB
=fTaN
-----END PGP SIGNATURE-----

--Signature=_Fri__8_Nov_2013_19_45_11_+1100_oDf0H/C1P1yURSh3--
