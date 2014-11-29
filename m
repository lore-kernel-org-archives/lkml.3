Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751680AbaK2Ko6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2014 05:44:58 -0500
Received: from ozlabs.org ([103.22.144.67]:34467 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751642AbaK2Ko4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2014 05:44:56 -0500
Date: Sat, 29 Nov 2014 21:44:48 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jeremiah Mahler <jmmahler@gmail.com>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        "Theodore Ts'o" <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>,
        linux-fsdevel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: Re: [BUG] linux-next: 20141127 boot hang
Message-ID: <20141129214448.625baea8@canb.auug.org.au>
In-Reply-To: <20141129091510.GA1366@newt.localdomain>
References: <20141127231619.GA1713@hudson.localdomain>
	<20141128233250.GA4921@hudson.localdomain>
	<20141129091510.GA1366@newt.localdomain>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/RgMqtBe/neEyodVfE1XPoXW"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/RgMqtBe/neEyodVfE1XPoXW
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Jeremiah,

On Sat, 29 Nov 2014 01:15:10 -0800 Jeremiah Mahler <jmmahler@gmail.com> wro=
te:
>
> all,
>=20
> On Fri, Nov 28, 2014 at 03:32:50PM -0800, Jeremiah Mahler wrote:
> > On Thu, Nov 27, 2014 at 03:16:19PM -0800, Jeremiah Mahler wrote:
> > >=20
> > > I just tried the latest linux-next 20141127 (commit 3bcf494d225fd19) =
and
> > > it hangs very early in the boot sequence, after decompressing the ker=
nel
> > > and after fsck (see attached screen shot).  I have tried it with two
> > > different machines and they both have the same problem.  It worked wi=
th
> > > version 20141126.
> > >=20
> > []
> >=20
> > My bisect results so far indicate that the bug was introduced by this
> > merge commit.
> >=20
> >   commit 0305904a7416ced1358c5ff575e58135453bfc1d
> >   Merge: 38a4751 2ef5864
> >   Author: Stephen Rothwell <sfr@canb.auug.org.au>
> >   Date:   Thu Nov 27 14:53:44 2014 +1100
> >  =20
> >       Merge remote-tracking branch 'block/for-next'
> >      =20
> >       Conflicts:
> >           fs/fs-writeback.c
> >=20
> []
>=20
> Something is definitely broken at this merge commit.  I haven't
> quite figured out how to bisect the patches inside the merge commit.
> Any suggestions are welcome.

It could easily actually be the merge itself. There was a conflict in
that merge that I fixed up as best I could and asked others to check
the resolution.

I know that Cristoph thinks that the lazytime stuff is not ready for
-next yet, but are there any other comments?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/RgMqtBe/neEyodVfE1XPoXW
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUeaOlAAoJEMDTa8Ir7ZwVUbQP/RyMgRSEE2Ts2FKOQosOUtNp
FoMMVI1vregKHTZgWvVrKm60vFEs01UG04+MLbSAEAItWAxZ3Q4xiJESjBd1VKvA
3MavJ52KSupF8v3cRZd/AdyTRDQKD10aKhdmvxoinyjRJm/fxoqyuujwexItsqwf
lt34yItOmEU0GtF2GU8u0IVMbeYvJgHQxc73JuoYeubzuJW+YYHnhl3xiQm00lLX
87USycQpprd3x2XQFZu5FemIU0RmpQv/JSXqxBI17FGjQeCiX74hhzPK3a5bHK19
YB3D9UHPRqPwWNP4auhBOxp1LgM1sk4vBPllWHYQz9FRwobRKzUAaZ+BnpHTaCrh
rcWQeaA0E7zAvEX++vJEyWTaqc3P4vAH/xfCmYmMM6XYU+mGHeWpIr9OS0R6/R6e
BU/uicIUKCpTO5peqtjW98VEGeBvB/tts7DVVvC4s2tHylGGu/i2mm8Xv7w+WtmY
Qq4kvJm0fAsA5A7+yIMft1ZMz3siygKRkPKMDoQaO9TNo98c/EOnV83yn3MdLm4v
1Wyj4M/XVu0voxPQnczSSP3/4W7x5HgqpOJDszzbPQUKC5fxj2jlDlKpC/MZHHfX
D0m12vqhd+38UXkB7mYSQ4sUguYR339VxFREuytw527Q6FG1pFvM1ylhsXsx5NNZ
EOQRuPPnvwsdCQjIfPqE
=oegq
-----END PGP SIGNATURE-----

--Sig_/RgMqtBe/neEyodVfE1XPoXW--
