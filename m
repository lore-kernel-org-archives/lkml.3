Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860AbaK0JbM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 04:31:12 -0500
Received: from ozlabs.org ([103.22.144.67]:38560 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754256AbaK0JbI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 04:31:08 -0500
Date: Thu, 27 Nov 2014 20:31:01 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>, Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>
Subject: Re: linux-next: manual merge of the staging tree with the vfs tree
Message-ID: <20141127203101.346ea550@canb.auug.org.au>
In-Reply-To: <20141127201156.62487051@canb.auug.org.au>
References: <20141127201156.62487051@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/82qs52q0uDyLnyyClUMX6ux"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/82qs52q0uDyLnyyClUMX6ux
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Thu, 27 Nov 2014 20:11:56 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> diff --cc drivers/staging/lustre/lustre/llite/llite_lib.c
> index 7b6b9e2e0102,3b0336029da3..000000000000
> --- a/drivers/staging/lustre/lustre/llite/llite_lib.c
> +++ b/drivers/staging/lustre/lustre/llite/llite_lib.c
> @@@ -698,8 -690,10 +690,8 @@@ void lustre_dump_dentry(struct dentry *
>   	list_for_each(tmp, &dentry->d_subdirs)
>   		subdirs++;
>  =20
> - 	CERROR("dentry %p dump: name=3D%pd parent=3D%p, inode=3D%p, count=3D%u=
,"
> - 	       " flags=3D0x%x, fsdata=3D%p, %d subdirs\n", dentry, dentry,
>  -	CERROR("dentry %p dump: name=3D%.*s parent=3D%.*s (%p), inode=3D%p, co=
unt=3D%u, flags=3D0x%x, fsdata=3D%p, %d subdirs\n",
>  -	       dentry,
>  -	       dentry->d_name.len, dentry->d_name.name,
>  -	       dentry->d_parent->d_name.len, dentry->d_parent->d_name.name,
> ++	CERROR("dentry %p dump: name=3D%pd parent=3D%p, inode=3D%p, count=3D%u=
, flags=3D0x%x, fsdata=3D%p, %d subdirs\n",
> ++	       dentry, dentry,
>   	       dentry->d_parent, dentry->d_inode, d_count(dentry),
>   	       dentry->d_flags, dentry->d_fsdata, subdirs);
>   	if (dentry->d_inode !=3D NULL)

The actual resolution for this file ended up being this:

diff --cc drivers/staging/lustre/lustre/llite/llite_lib.c
index 7b6b9e2e0102,3b0336029da3..52f0a7e40063
--- a/drivers/staging/lustre/lustre/llite/llite_lib.c
+++ b/drivers/staging/lustre/lustre/llite/llite_lib.c
@@@ -698,8 -690,10 +690,8 @@@ void lustre_dump_dentry(struct dentry *
  	list_for_each(tmp, &dentry->d_subdirs)
  		subdirs++;
 =20
- 	CERROR("dentry %p dump: name=3D%pd parent=3D%p, inode=3D%p, count=3D%u,"
- 	       " flags=3D0x%x, fsdata=3D%p, %d subdirs\n", dentry, dentry,
 -	CERROR("dentry %p dump: name=3D%.*s parent=3D%.*s (%p), inode=3D%p, coun=
t=3D%u, flags=3D0x%x, fsdata=3D%p, %d subdirs\n",
 -	       dentry,
 -	       dentry->d_name.len, dentry->d_name.name,
 -	       dentry->d_parent->d_name.len, dentry->d_parent->d_name.name,
++	CERROR("dentry %p dump: name=3D%pd parent=3D%p, inode=3D%p, count=3D%u, =
flags=3D0x%x, fsdata=3D%p, %d subdirs\n",
++	       dentry, dentry,
  	       dentry->d_parent, dentry->d_inode, d_count(dentry),
  	       dentry->d_flags, dentry->d_fsdata, subdirs);
  	if (dentry->d_inode !=3D NULL)
@@@ -709,7 -703,8 +701,8 @@@
  		return;
 =20
  	list_for_each(tmp, &dentry->d_subdirs) {
 -		struct dentry *d =3D list_entry(tmp, struct dentry, d_u.d_child);
 +		struct dentry *d =3D list_entry(tmp, struct dentry, d_child);
+=20
  		lustre_dump_dentry(d, recur - 1);
  	}
  }

--=20
Cheers,
Stephen Rothwell                   <sfr@canb.auug.org.au>

--Sig_/82qs52q0uDyLnyyClUMX6ux
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUdu9aAAoJEMDTa8Ir7ZwVXkIP/1FAi/e+D8ektWNuW2rAXjgb
5kWH6jqbhzlobEJRVWFcMcLMmXRkCkimFDurwaSdxWSJ4hEvQzNh5+PhZnB6FUCg
DvpMy31N3vkTWyJv6Npm8fFiExThauwNLgakbNabEpap62rHv3pl9tLX7xPM5OPx
q4S7MqMBb6ycYNq9Nc60CMwBkMqzP/1YPFsqkYX/XQ1iLs3ZzdRn9ZWBkuUCdnpM
ua+Pkelx82+jwJkufEAbDyOHAdkNucjy1P7JI6QjqxXQInn4Qbvshd5jrEsWhmdK
8qmu4/KPn1YRfy7a135xYOvcFDe6E3HklJCQdzKirIem8ny83h6k0V2Wc8fUqvo1
CsdHPuPIRb/lasJ0tZFlFl0295PqpOHmy0o5gJuDUwtumzcARa+b235x7+w1SSvK
uGfSnMHTvUZcVEQVAa4W856gutrLXwoJM34HRSzS64n1bhf4I730f4NYEwcWwrU+
Mhwboy+YlEc4AN8wF5AlgRUVHKwzh4R8PxQz+U8DWwUIfZYhcoiwjiYv5f1tFzZo
KuNvgXAMqCSpVYbWQ2BnvLYKRYB997W00wkl2Qna5na4tDL4VqD5cHdZ+Qcf3ZF+
EA9baIdV/eZliWe6cd020oBAKGVaI1uaEtPrFw93fJmb7NsA5OIr225i5wY4cRuG
GA3DyS8l9sgUKw0CBD/k
=zkZu
-----END PGP SIGNATURE-----

--Sig_/82qs52q0uDyLnyyClUMX6ux--
