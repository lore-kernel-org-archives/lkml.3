Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934154Ab3CSWFw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 18:05:52 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:45214 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933917Ab3CSWFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 18:05:51 -0400
Date: Wed, 20 Mar 2013 09:05:40 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: manual merge of the workqueues tree with Linus'
 tree
Message-Id: <20130320090540.81c687d28ffe3a6abe905816@canb.auug.org.au>
In-Reply-To: <20130319211233.GN3042@htj.dyndns.org>
References: <20130319131938.73dd0f1233c8aba41742aded@canb.auug.org.au>
	<20130319211233.GN3042@htj.dyndns.org>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__20_Mar_2013_09_05_40_+1100_D4RR3TCg2r+0RJLg"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__20_Mar_2013_09_05_40_+1100_D4RR3TCg2r+0RJLg
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tejun,

On Tue, 19 Mar 2013 14:12:33 -0700 Tejun Heo <tj@kernel.org> wrote:
>
> On Tue, Mar 19, 2013 at 01:19:38PM +1100, Stephen Rothwell wrote:
> > @@@ -456,40 -462,30 +462,30 @@@ static int worker_pool_assign_id(struc
> >   {
> >   	int ret;
> >  =20
> > - 	mutex_lock(&worker_pool_idr_mutex);
> > - 	ret =3D idr_alloc(&worker_pool_idr, pool, 0, 0, GFP_KERNEL);
> > - 	if (ret >=3D 0)
> > - 		pool->id =3D ret;
> > - 	mutex_unlock(&worker_pool_idr_mutex);
> > + 	lockdep_assert_held(&wq_mutex);
> > +=20
> > + 	do {
> >  -		if (!idr_pre_get(&worker_pool_idr, GFP_KERNEL))
> >  -			return -ENOMEM;
> >  -		ret =3D idr_get_new(&worker_pool_idr, pool, &pool->id);
> > ++		ret =3D idr_alloc(&worker_pool_idr, pool, 0, 0, GFP_KERNEL);
> > ++		if (ret >=3D 0)
> > ++			pool->id =3D ret;
> > + 	} while (ret =3D=3D -EAGAIN);
> >  =20
> >  -	return ret;
> >  +	return ret < 0 ? ret : 0;
>=20
> We don't need the loop anymore, so it should look like
>=20
>   static int worker_pool_assign_id(struct worker_pool *pool)
>   {
> 	  int ret;
>=20
> 	  lockdep_assert_held(&wq_mutex);
>=20
> 	  ret =3D idr_alloc(&worker_pool_idr, pool, 0, 0, GFP_KERNEL);
> 	  if (ret >=3D 0) {
> 		  pool->id =3D ret;
> 		  return 0;
> 	  }
> 	  return ret;
>   }
>=20
> Anyways, I pulled master into wq/for-next and resolved it there, so it
> shouldn't cause you any more trouble.

Ah, OK, thanks.   One small point, when you do a back merge like that,
you should always put an explanation in the commit message for the merge.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__20_Mar_2013_09_05_40_+1100_D4RR3TCg2r+0RJLg
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRSOE0AAoJEECxmPOUX5FEKSUP/3UZCWTzIwi07hlLDjLmbzSh
rVAWDS3PoeX3TZlmaKWeFY6rSwSZGPiKqBnUtgb5izkaE2BPFs3ta3Jr85PRG26q
1DGugWiNfhDhuzh865lHjCny9xNLt5AoGI21f79CJ+Fn/0gdal4KpVQg8yx8Dx5O
FrdgsLbqRNOe/qy1uuEGsOQMgrtrDCjGpG0gZiHnLK/X3ppJaJiig+naUq6de0gf
czjHd0/pahOlMeXqPadVw9sEvXe7+A6NijaLbPyEo6JPwHl60js6kXoTaKfFehv0
gFwlXVjZEHY9hnREUNSDVd07b/YOzGEEsxwHyfNZx6kLPqHSJ0+CC2dorwMQgV7p
9myq/lzJaLB5IQW3lovcX4Bn2qGoDEh7SLTy5jKz5iGtERayEIfZUraqewyWndRL
oo52sPnM3iMAhHzkd49Ut8SfXFtcvE2GLsl+E60nq1sxjUYbunhjC0HQ75GfC9i3
tNejpmDU9sAxUykmqqOJx2GzL9UxzWtadnXUDDg94D3/AgiD06zPss80bDLrzdgz
ftmYfcLe+ph6RQwp8KfaJ7vecg8A8ASrG34ivowJuAxxBbuSZ7ZeFQiQUrxAV8z+
OLX0rWxse0fdOeipsA3St7svXlko3u9psCWt+FVKZaAQgmxHJKYkGBmMoZRBD2Im
lsSjp0ViC/H1HU+kCmSF
=Fw4X
-----END PGP SIGNATURE-----

--Signature=_Wed__20_Mar_2013_09_05_40_+1100_D4RR3TCg2r+0RJLg--
