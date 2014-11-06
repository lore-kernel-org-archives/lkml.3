Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751541AbaKFKSx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 05:18:53 -0500
Received: from ozlabs.org ([103.22.144.67]:51996 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751021AbaKFKSu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 05:18:50 -0500
Date: Thu, 6 Nov 2014 21:18:43 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Davidlohr Bueso <dave@stgolabs.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the akpm-current tree
Message-ID: <20141106211843.6c23a5dd@canb.auug.org.au>
In-Reply-To: <1415264981.15424.3.camel@linux-t7sj.site>
References: <20141106164444.2123e6d5@canb.auug.org.au>
	<1415264981.15424.3.camel@linux-t7sj.site>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/Kkj/ANRrFhC4QXuDt=Wq5bc"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Kkj/ANRrFhC4QXuDt=Wq5bc
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, 06 Nov 2014 01:09:41 -0800 Davidlohr Bueso <dave@stgolabs.net> wrot=
e:
>
> On Thu, 2014-11-06 at 16:44 +1100, Stephen Rothwell wrote:
> >=20
> > After merging the akpm-current tree, today's linux-next build (powerpc
> > ppc64_defconfig) failed like this:
> >=20
> > mm/fremap.c: In function 'SYSC_remap_file_pages':
> > mm/fremap.c:241:22: error: 'struct address_space' has no member named '=
i_mmap_mutex'
> >    mutex_lock(&mapping->i_mmap_mutex);
> >                       ^
> > mm/fremap.c:247:24: error: 'struct address_space' has no member named '=
i_mmap_mutex'
> >    mutex_unlock(&mapping->i_mmap_mutex);
> >                         ^
> >=20
> > Caused by commit 1f8c97e79f66 ("mm: convert i_mmap_mutex to rwsem").
> >=20
> > I applied this patch for today (not sure if there is a better way):
> >=20
> > From: Stephen Rothwell <sfr@canb.auug.org.au>
> > Date: Thu, 6 Nov 2014 16:26:41 +1100
> > Subject: [PATCH] mm: convert i_mmap_mutex to rwsem fix
> >=20
> > Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> > ---
> >  mm/fremap.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >=20
> > diff --git a/mm/fremap.c b/mm/fremap.c
> > index 9129013732d7..2805d71cf476 100644
> > --- a/mm/fremap.c
> > +++ b/mm/fremap.c
> > @@ -238,13 +238,13 @@ get_write_lock:
> >  			}
> >  			goto out_freed;
> >  		}
> > -		mutex_lock(&mapping->i_mmap_mutex);
> > +		i_mmap_lock_write(mapping);
>=20
> That's the correct fix, thanks. However, I had particularly dropped that
> modification because linux-next no longer even has mm/fremap.c so I'm
> not sure what went wrong here...

Andrew's tree gets added in two sections and he put your patch in the
first part but the patch that removes this file is in the second part,
so all that really needs to happen is for the patches to be reordered.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/Kkj/ANRrFhC4QXuDt=Wq5bc
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUW0sIAAoJEMDTa8Ir7ZwVyEcP+wTkNEsOh5TDdXSKmXNA2iEU
VbUYiZ+1tpcE/Z+G9L0wy9L8UvRJu3a9+V801XSYF7mGshuYISMjA9dnSc49ckC5
Mr0oY2rHf9lHAKt0+SAnnp5TzL+OiWygFWY3B1hlMjlhWNu7D9feOtQVx6xB0gVn
fTtHwoFv5XuhyUtnYYrmxMRkjh4ZfanBj7DBmCUkavspI1QAw/U+cI/l0eELNhUi
RTGVVx5OankdgBkMEenlPha1dCSgHh1i+WgbxkAj9WFThN6qxZC0eORnZ6SJHv3r
kUfDXAr5bQSA1kvCqV3fPHCOSCWL+jh9x0qk4tBoqo4r9ZiIzP070ysoMPeReowL
2dokVwKjX3cIilwWqIh7lUBJQ0LE0qrfIR4J3ltbs0GZ+QkYI0t/0yMg/5dYPkeq
WAp63VnCHYbKUuK9cTZ33kyV/NBb2svP1qfO6SPT9wAz+FJObNoG0EvNsK+B+uxy
0gFX6J3xVEu30W15qH8Yjirv39umkGcxx4YWlfz4mSykis9UKNHDCojBTsXw29VJ
Anqqo4I1zozvcsfT2I2Sbrr9soEc4syQY1syHrub3MiUTyA8wTcAEoSU2KLiV6mJ
AZo/IfFuIPHDLIlMRDwi8fq7Y24z7ApgFpjwQkFc8NgjN3C1Wb3dwwfQhyNnzv2Z
o94ua5GL+hzRgXHeWNjo
=UQXK
-----END PGP SIGNATURE-----

--Sig_/Kkj/ANRrFhC4QXuDt=Wq5bc--
