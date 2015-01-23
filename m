Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585AbbAWG6h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 01:58:37 -0500
Received: from mail-lb0-f176.google.com ([209.85.217.176]:47010 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514AbbAWG6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 01:58:34 -0500
From: Andrey Skvortsov <andrej.skvortzov@gmail.com>
X-Google-Original-From: Andrey Skvortsov <Andrej.Skvortzov@gmail.com>
Date: Fri, 23 Jan 2015 09:58:34 +0300
To: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>, Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/slub: suppress BUG messages for
 kmem_cache_alloc/kmem_cache_free
Message-ID: <20150123065834.GI25900@localhost.localdomain>
Mail-Followup-To: Andrey Skvortsov <Andrej.Skvortzov@gmail.com>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	Jesper Dangaard Brouer <brouer@redhat.com>,
	linux-kernel@vger.kernel.org
References: <1421932519-21036-1-git-send-email-Andrej.Skvortzov@gmail.com>
 <alpine.DEB.2.10.1501221518020.27807@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="AQYPrgrEUc/1pSX1"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1501221518020.27807@chino.kir.corp.google.com>
X-PGP-Key: fp="21AF 2E6F 04EC 7E11 21C6  E399 2236 2F26 57A3 AEAD";
 id="0x57A3AEAD";
 get=<hkp://pgp.mit.edu/pks/lookup?search=0x22362F2657A3AEAD&op=get>;
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AQYPrgrEUc/1pSX1
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 22, 2015 at 03:19:18PM -0800, David Rientjes wrote:
> On Thu, 22 Jan 2015, Andrey Skvortsov wrote:
>=20
> > diff --git a/mm/slub.c b/mm/slub.c
> > index ceee1d7..6bcd031 100644
> > --- a/mm/slub.c
> > +++ b/mm/slub.c
> > @@ -2404,7 +2404,7 @@ redo:
> >  	 */
> >  	do {
> >  		tid =3D this_cpu_read(s->cpu_slab->tid);
> > -		c =3D this_cpu_ptr(s->cpu_slab);
> > +		c =3D raw_cpu_ptr(s->cpu_slab);
> >  	} while (IS_ENABLED(CONFIG_PREEMPT) && unlikely(tid !=3D c->tid));
> > =20
> >  	/*
> > @@ -2670,7 +2670,7 @@ redo:
> >  	 */
> >  	do {
> >  		tid =3D this_cpu_read(s->cpu_slab->tid);
> > -		c =3D this_cpu_ptr(s->cpu_slab);
> > +		c =3D raw_cpu_ptr(s->cpu_slab);
> >  	} while (IS_ENABLED(CONFIG_PREEMPT) && unlikely(tid !=3D c->tid));
> > =20
> >  	/* Same with comment on barrier() in slab_alloc_node() */
>=20
> This should already be fixed with=20
> http://ozlabs.org/~akpm/mmotm/broken-out/mm-slub-optimize-alloc-free-fast=
path-by-removing-preemption-on-off-v3.patch

> You can find the latest mmotm, which was just released, at=20
> http://ozlabs.org/~akpm/mmotm and it should be in linux-next tomorrow.
ok. I've just looked at linux-next/master and
linux-next/akpm branches and that was not fixed there. Thanks for the
link. I'll look there in the future for mm-related patches posting a
new one.

--=20
Best regards,
Andrey Skvortsov

Secure eMail with gnupg: See http://www.gnupg.org/
PGP Key ID: 0x57A3AEAD

--AQYPrgrEUc/1pSX1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJUwfEaAAoJEAF8y6L1SLCtHtYQAKKwaJbRsFlchx7cK98xaXAR
wH18lsI/BL4+r4kLBEcW7ISP6HN895EXHE64Ie23I+eYV5CKEGxkcxEPyc0p37ma
I47s1nhox3FHhI9+ax8d5z8dX5hmVf6+GXdLxauxpEYptDn/rO9KppBoPZ5ixD7E
OaPuggO9ApDSzTfBn7FbLEOfGSxSyYoYedzXsr54jMf9IzqAZpHCzTtEofBynbQv
5DEM1IhR0HkdyqbtbhBozbNbEnuU3WwUH4iD0eRyLc1YXX1yVHlIIvB4Nj6v0ci6
Hm7VJcWGWQBC0X8IEOXMElanIRuK8irJoPt8AJmCXVJryZX+MnBZHxxJsKevJE7p
OAMWmEf/S+JpypfgV8N/MTN604ZEzFISjr/cbmrBEt9vXcxyjWjbMZ984h+pkf7C
jEqTuFS1SZydBHV8DJluXl3TJWxBk8sJKM5IwkvG+eshjZtU/Dw8xhNOfGQb8B90
RYN3/Qu9sHi7Y7TLs7/iPSSdDUDqnIUcE8cSGYC/c6OsHlvYs/V0u6IPKTwaFv5B
eDtIV3qFfDOfcOwTjAOUHQwzA10Vbd4WMFUVUMCjRFkWTnsbq7aDyycuEEMqmkPE
qgLUnPUQ88jPa3aHlWv88Pj4QBZcx0N3XrhvcQvyxpDbqqsZ5JsQDShp9kmN5utf
Z+iUgeqYtJn23+fkb7sU
=TID4
-----END PGP SIGNATURE-----

--AQYPrgrEUc/1pSX1--
