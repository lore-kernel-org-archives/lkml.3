Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755684AbaIIAil (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 20:38:41 -0400
Received: from ozlabs.org ([103.22.144.67]:52809 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755656AbaIIAik (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 20:38:40 -0400
Date: Tue, 9 Sep 2014 10:38:29 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: Re: "mm: introduce dump_vma fix 2" still broken
Message-ID: <20140909103829.05c0889f@canb.auug.org.au>
In-Reply-To: <540DBD62.5040605@oracle.com>
References: <2815658.dHHBXc7oHP@wuerfel>
	<540DBD62.5040605@oracle.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/hWqF=AIJGd5A5ezHNpWUtYX"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/hWqF=AIJGd5A5ezHNpWUtYX
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Sasha,

On Mon, 08 Sep 2014 10:29:54 -0400 Sasha Levin <sasha.levin@oracle.com> wro=
te:
>
> On 09/08/2014 07:02 AM, Arnd Bergmann wrote:
> >=20
> > I saw this commit today in linux-next, which fixes a build error, but i=
ntroduces
> > a new warning:
> >=20
> > commit a60224c708f880dd937b352b7461cbf14e93012d
> > Author: Stephen Rothwell <sfr@canb.auug.org.au>
> > Date:   Mon Sep 8 19:41:54 2014 +1000
> >=20
> >     mm: introduce dump_vma fix 2
> >    =20
> >     Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> >=20
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index cb510c08073b..0de60769bcf6 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -6739,7 +6739,7 @@ void dump_vma(const struct vm_area_struct *vma)
> >                 "prot %lx anon_vma %p vm_ops %p\n"
> >                 "pgoff %lx file %p private_data %p\n",
> >                 vma, (void *)vma->vm_start, (void *)vma->vm_end, vma->v=
m_next,
> > -               vma->vm_prev, vma->vm_mm, vma->vm_page_prot.pgprot,
> > +               vma->vm_prev, vma->vm_mm, pgprot_val(vma->vm_page_prot),
> >                 vma->anon_vma, vma->vm_ops, vma->vm_pgoff,
> >                 vma->vm_file, vma->vm_private_data);
> >         dump_flags(vma->vm_flags, vmaflags_names, ARRAY_SIZE(vmaflags_n=
ames));
> >=20
> >=20
> > /git/arm-soc/mm/page_alloc.c: In function 'dump_vma':
> > /git/arm-soc/mm/page_alloc.c:6744:3: warning: format '%lx' expects argu=
ment of type 'long unsigned int', but argument 8 has type 'pgprot_t' [-Wfor=
mat=3D]
> >    vma->vm_file, vma->vm_private_data);
> >    ^
> >=20
> > This happens on machines that use ARM LPAE, where pgprot_t is in fact
> > a 64-bit integer. The simplest fix I see would be add a cast to u64
> > and always print this as a 64bit value.
>=20
> Hi Arnd,
>=20
> The fix for the original issue would be:
>=20
> 	http://ozlabs.org/~akpm/mmots/broken-out/introduce-dump_vma-fix-2.patch
>=20
> Which includes the casting that Stephen's patch didn't have.

Thanks for pointing it out, I will replace my patch with that (unless
Andrew does a new mmotm today).

> Stephen, in the future, is there a way to get build fixes faster to you? =
From
> what I understand -mm syncs up only once in a couple of days. It might ma=
ke
> everyone=E2=80=99s life much easier if build errors wouldn't drag over a =
week.

Andrew (and others) sometime cc's me on such fixes in which case I add
them to linux-next until Andrew does a new mmotm.

It didn't help that I have been away for a week.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/hWqF=AIJGd5A5ezHNpWUtYX
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUDkwJAAoJEMDTa8Ir7ZwVGtoQAI4oRTlycFnGQPbwrKcyWzet
3TG8VxPhbK0+yNUIOVToxp7gj2Hu+dJEe2Io6Q9Knnc9F0T4wYThefDw0EaM2e9h
kruFRHm5zDQb3Pm2pOtrC5sAH6grF4pA7ynMT5thLy5sBuRFBI7JJkODYNTLNg/4
6Vm9k+IAzrXSk44BZltnsAY6toFHE0+VYtAsT1ISTWaN4zIyPRhnjxWmPQ4XC6w0
LMkkYpDxzB9PvYL2dayx5lmXLjTxz8cor2sYFXz82YLnV5bWEN/czQYGA0mj7PUB
RHPMuBKqmJjT4h33q4uFzoC8oT6aGvbezT0H/csjvBUmPCj7roCuEvCc9Hn6oIg+
6R2V+ZBx/qm3J+dIkI2B6ITE1KmLFL7f1pRa+t1kDpki3JRQFxv0+y60VapLiJn7
woXuPjsU+0ZmoR4igI3lF8fvxjXHtY5BpFU4ks2jBu69P+NjTkwVZh3qSNf71zVu
5Yy7NfSP9DxLJlsrKkNUZKYIcJkHxUDujwXFWNtSjgHYpp430KNjUCEw2o8AIExX
IyK4oeV4Hnt1AHHDm5dWL3maFsAFZypHLtJ7Y50XSYRslqe2TJFNk9mY5VzWgClv
x//DQFf7Cf6fEgQlFm8xSRF8BB6SAqAa5TSfTQ1/rTCDObsF8ovzXvMJWhnGcgou
HdNvyBOawQ1xAAQIszzu
=u3FQ
-----END PGP SIGNATURE-----

--Sig_/hWqF=AIJGd5A5ezHNpWUtYX--
