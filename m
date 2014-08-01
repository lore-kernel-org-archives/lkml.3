Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755630AbaHARWL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 13:22:11 -0400
Received: from mga03.intel.com ([143.182.124.21]:39384 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752571AbaHARWI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 13:22:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,780,1400050800"; 
   d="asc'?scan'208";a="464051610"
Date: Fri, 1 Aug 2014 22:43:06 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, dmaengine@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Antoine =?iso-8859-1?Q?T=E9nart?= <antoine@free-electrons.com>,
        Thomas Petazzoni <thomas@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris Brezillon <boris@free-electrons.com>,
        Matt Porter <matt.porter@linaro.org>,
        laurent.pinchart@ideasonboard.com, ludovic.desroches@atmel.com,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [PATCH] Documentation: dmaengine: Add a documentation for the
 dma controller API
Message-ID: <20140801171306.GF8181@intel.com>
References: <1406736193-26685-1-git-send-email-maxime.ripard@free-electrons.com>
 <20140730160607.GM8181@intel.com>
 <20140731074440.GY3952@lukather>
 <20140731115628.GQ8181@intel.com>
 <20140731162330.GE3952@lukather>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1giRMj6yz/+FOIRq"
Content-Disposition: inline
In-Reply-To: <20140731162330.GE3952@lukather>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1giRMj6yz/+FOIRq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 31, 2014 at 06:23:30PM +0200, Maxime Ripard wrote:
> On Thu, Jul 31, 2014 at 05:26:28PM +0530, Vinod Koul wrote:
>=20
> Also, feel free to add anything that you feel like you keep saying
> during the review. If mistakes keep coming, it's probably worth
> documenting what you expect.
I think the common issues seen would be:
- prpeare calls in atomic context and usuage of GFP_NOWAIT for memory
  allocations
- residue callculation, though situation is much better now but still lots
  of driver do it worng and folks do get it wrong

>=20
> > > Because, for the moment, we're pretty much left in the dark with
> > > different drivers doing the same thing in completetely different ways,
> > > with basically no way to tell if it's either the framework that
> > > requires such behaviour, or if the author was just feeling creative.
> > >=20
> > > There's numerous examples for this at the moment:
> > >   - The GFP flags, with different drivers using either GFP_ATOMIC,
> > >     GFP_NOWAIT or GFP_KERNEL in the same functions
> > >   - Having to set device_slave_caps or not?
> > >   - Some drivers use dma_run_depedencies, some other don't
> > >   - That might just be my experience, but judging from previous
> > >     commits, DMA_PRIVATE is completely obscure, and we just set it
> > >     because it was making it work, without knowing what it was
> > >     supposed to do.
> > >   - etc.
> >=20
> > Thanks for highlighting we should definitely add these in Documentation
>=20
> It's quite clear in the case of the GFP flags now, Lars-Peter and you
> cleared up device_slave_caps, but I still could use some help with
> DMA_PRIVATE.
>=20
> > > And basically, we have no way to tell at the moment which one is
> > > right and which one needs fixing.
> > >=20
> > > The corollary being that it cripples the whole community ability to
> > > maintain the framework and make it evolve.
> > >=20
> > > > > +  * device_slave_caps
> > > > > +    - Isn't that redundant with the cap_mask already?
> > > > > +    - Only a few drivers seem to implement it
> > > > For audio to know what your channel can do rather than hardcoding it
> > >=20
> > > Ah, yes, I see it now. It's not related to the caps mask at all.
> > >=20
> > > Just out of curiosity, wouldn't it be better to move this to the
> > > framework, and have these informations provided through the struct
> > > dma_device? Or would it have some non-trivial side-effects?
> > Well the problem is ability to have this queried uniformly from all dri=
vers
> > across subsystems. If we can do this that would be nice.
>=20
> I can work on some premelinary work to do just that, and see if it
> works for you then.
Sure sounds excellent to me

--=20
~Vinod

--1giRMj6yz/+FOIRq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJT28qhAAoJEHwUBw8lI4NHx7QP/301us4uGF6t4k8LM/o0XVrA
y/c4G0oGSqcE4AW7mbB7wv76smw0AlaPt+P5PMsiITszsyp6g5uOJs2eC33K5q1+
2vkg8IKpVi1LL+IbRTFfFE08LGo/3R5JyRGILkVAcpgKiU+0QLoB0Y7rcByfiQOk
+8ULya84bS/ZBwdTbEcoSjYXeyz0I53tGmEFzoJycpKs+TL8e0yF1oD5tERty6yo
CoTRO2au5EfJmpWchYrYI6ToEyZMYK0lWgnB+fBaXfAD+hFf0vfPQ+u4+AEoypAl
vb2QQ02pkUcJi5F/L+LMbCGqXzw7fqBS/mAGqCeYWamgOptY9NBZTNPAdlYXJP78
xpM2Hdmi8D0CFnKV+HK/+7799ZTAf00HQztqkxjs4D1OmUD34Mld3Z8n5RsOaXbl
VkHW+/OPOY9YaE9/lRtGgFfIWyrjmtVLJYGwxDGSUBN8nyJOIrsZPHcPpW4a6VRb
7Jv81mpObR1u8IMCgYMxQ+z3NrLKq1TAnIOK+fGGPWSW0xVtEIQ32RgHJET2MLOo
V+HRiM084D17MbKTWM/rpEBBK5L0tU0evcs5gsyxiH5ctu0WgqVR/ZRPW+MlXwA0
x8El1UUKvRhXbJW7LWvgtbyZreKM9pKHpvJuEEJq8AcZXe2TRUkmOpodJu5IPsFh
Ymq/aN35GATV5G++HP0Q
=C7h4
-----END PGP SIGNATURE-----

--1giRMj6yz/+FOIRq--
