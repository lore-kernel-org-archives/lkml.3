Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753022AbaESKFd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 06:05:33 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:36148 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316AbaESKFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 06:05:31 -0400
Date: Mon, 19 May 2014 12:03:17 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Lucas Stach <l.stach@pengutronix.de>
Cc: Alexandre Courbot <acourbot@nvidia.com>, gnurou@gmail.com,
        nouveau@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, Ben Skeggs <bskeggs@redhat.com>,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH 4/4] drm/nouveau: introduce CPU cache flushing macro
Message-ID: <20140519100316.GE7138@ulmo>
References: <1400483458-9648-1-git-send-email-acourbot@nvidia.com>
 <1400483458-9648-5-git-send-email-acourbot@nvidia.com>
 <20140519090202.GC7138@ulmo>
 <1400491331.8467.8.camel@weser.hi.pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="so9zsI5B81VjUb/o"
Content-Disposition: inline
In-Reply-To: <1400491331.8467.8.camel@weser.hi.pengutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--so9zsI5B81VjUb/o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 19, 2014 at 11:22:11AM +0200, Lucas Stach wrote:
> Am Montag, den 19.05.2014, 11:02 +0200 schrieb Thierry Reding:
> > On Mon, May 19, 2014 at 04:10:58PM +0900, Alexandre Courbot wrote:
> > > Some architectures (e.g. ARM) need the CPU buffers to be explicitely
> > > flushed for a memory write to take effect. Not doing so results in
> > > synchronization issues, especially after writing to BOs.
> >=20
> > It seems to me that the above is generally true for all architectures,
> > not just ARM.
> >=20
> No, on PCI coherent arches, like x86 and some PowerPCs, the GPU will
> snoop the CPU caches and therefore an explicit cache flush is not
> required.

I was criticizing the wording in the commit message. Perhaps it could be
enhanced with what you just said.

> > > diff --git a/drivers/gpu/drm/nouveau/nouveau_bo.c b/drivers/gpu/drm/n=
ouveau/nouveau_bo.c
> > [...]
> > > index 0886f47e5244..b9c9729c5733 100644
> > > --- a/drivers/gpu/drm/nouveau/nouveau_bo.c
> > > +++ b/drivers/gpu/drm/nouveau/nouveau_bo.c
> > > @@ -437,8 +437,10 @@ nouveau_bo_wr16(struct nouveau_bo *nvbo, unsigne=
d index, u16 val)
> > >  	mem =3D &mem[index];
> > >  	if (is_iomem)
> > >  		iowrite16_native(val, (void __force __iomem *)mem);
> > > -	else
> > > +	else {
> > >  		*mem =3D val;
> > > +		nv_cpu_cache_flush_area(mem, 2);
> > > +	}
> > >  }
> > > =20
> > >  u32
> > > @@ -461,8 +463,10 @@ nouveau_bo_wr32(struct nouveau_bo *nvbo, unsigne=
d index, u32 val)
> > >  	mem =3D &mem[index];
> > >  	if (is_iomem)
> > >  		iowrite32_native(val, (void __force __iomem *)mem);
> > > -	else
> > > +	else {
> > >  		*mem =3D val;
> > > +		nv_cpu_cache_flush_area(mem, 4);
> > > +	}
> >=20
> > This looks rather like a sledgehammer to me. Effectively this turns nvbo
> > into an uncached buffer. With additional overhead of constantly flushing
> > caches. Wouldn't it make more sense to locate the places where these are
> > called and flush the cache after all the writes have completed?
> >=20
> I don't think the explicit flushing for those things makes sense. I
> think it is a lot more effective to just map the BOs write-combined on
> PCI non-coherent arches. This way any writes will be buffered. Reads
> will be slow, but I don't think nouveau is reading back a lot from those
> buffers.
> Using the write-combining buffer doesn't need any additional
> synchronization as it will get flushed on pushbuf kickoff anyways.

Sounds good to me.

Thierry

--so9zsI5B81VjUb/o
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTedbkAAoJEN0jrNd/PrOhvYUP/A4m7Wk8Sh4MMqV1dPnmCXA+
Isff4gDoCTQOI7MtUxzMWJde5HKoV+hJIxMhduG66qIhtPqnzyFk15BUqlIv4WxN
nyGDFX26GJaJAQf9hUBQ/mLcTHwVTDmXP4S9AAaFPIrHKqEAFupi2V0LQ/XCPqbF
kbiDWkbZwOmHbV8b1xYkdOU7A+UgcPIMidTExig1qagg5mLT7RRrq8s4H85KttoH
KTwqm7fz77Mr/E8dqOHn57CiJlx9kCUFjSeusXk5mbJD7TYKWUKJLYSJcyHC5YEi
fiwiamZrEIB/xSuaFQHLaHD+ziZnMfWmYsqDRcDGTUR5QalyM0iw49JhqAv05Oxs
tBSJ+Jo7fz3JPVZLMhF+pV+YEbe+IpuPrUrBhYkOto+pZ3cXoQk0zY7ANUJDCEjl
7yHL9rnYiVns5/j7rmxOfC+10IJM2WMg9dZjEU7Fmf/Kq0miA0oGv9ZaafLM9Das
VVFt98eyfnp2EaQUHAh9jXpYiKkLe+IobEMEjiaYPaXA4IPatNd7OlA00MYlkisF
ru2V0JWt9IAFD+jPusSsaGU97dDSxOlUTL4wzuqSPYHjsl8aCht95887TSdPSdlO
oazK4GCnKS8gYP6ZTjN1okRS4DLB8c3zujXK9mZZTH6qCc/oqHpDoI4GCskKoRL6
T2k6kke5TjXxDCtbOgS6
=9GWG
-----END PGP SIGNATURE-----

--so9zsI5B81VjUb/o--
