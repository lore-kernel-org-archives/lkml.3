Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751290AbaJAIkJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 04:40:09 -0400
Received: from top.free-electrons.com ([176.31.233.9]:32844 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750782AbaJAIkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 04:40:04 -0400
Date: Wed, 1 Oct 2014 10:39:17 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: dmaengine@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Antoine =?iso-8859-1?Q?T=E9nart?= <antoine@free-electrons.com>,
        lars@metafoo.de
Subject: Re: [PATCH 2/9] dmaengine: Make channel allocation callbacks optional
Message-ID: <20141001083917.GG6884@lukather>
References: <1411808085-27792-1-git-send-email-maxime.ripard@free-electrons.com>
 <1411808085-27792-3-git-send-email-maxime.ripard@free-electrons.com>
 <20140928160757.GJ1638@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jaoouwwPWoQSJZYp"
Content-Disposition: inline
In-Reply-To: <20140928160757.GJ1638@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jaoouwwPWoQSJZYp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Vinod,

On Sun, Sep 28, 2014 at 09:37:57PM +0530, Vinod Koul wrote:
> On Sat, Sep 27, 2014 at 10:54:38AM +0200, Maxime Ripard wrote:
> > Nowadays, some drivers don't have anything in there channel allocation
> > callbacks anymore.
> >=20
> > Remove the BUG_ON if those callbacks aren't implemented, in order to al=
low
> > drivers to not implement them.
> >=20
> > Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> > ---
> >  drivers/dma/dmaengine.c | 2 --
> >  1 file changed, 2 deletions(-)
> >=20
> > diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
> > index d5d30ed863ce..cfcb181b1184 100644
> > --- a/drivers/dma/dmaengine.c
> > +++ b/drivers/dma/dmaengine.c
> > @@ -817,8 +817,6 @@ int dma_async_device_register(struct dma_device *de=
vice)
> >  	BUG_ON(dma_has_cap(DMA_INTERLEAVE, device->cap_mask) &&
> >  		!device->device_prep_interleaved_dma);
> > =20
> > -	BUG_ON(!device->device_alloc_chan_resources);
> > -	BUG_ON(!device->device_free_chan_resources);
> Dont think we have drivers without free. IIRC cppi one might be only
> instance

It was more a matter of simmetry to be honest, I'm fine dropping it if
you want.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--jaoouwwPWoQSJZYp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUK721AAoJEBx+YmzsjxAgeR8P/2MXr0OjpzrNrTguuTMar8F/
SNn09hK/+pWdFnMNfTBxv39BtHHJZoSDv/2cQxTE2HWOZyk1NPkwSs60lPHbaYPb
OxlKuzG4DJ16Z9zznnQTgisNm/JOYJ6YSUJdgzPXd224cZSDTdR13NagRTl+CNf+
61PFXBjtdNonxSyDoQzUWjTMCiP84puCVid+e0MZdLteD4Tge/wfoS25s7weV5Mc
eXHD/qcHwFLeve0gF79KCuoYkE4z5zoln65Vu7AP07y8t6NvSbFj3+L6L+UxKYy2
oTNI1WVpaTCJZ/cM04jK56PwyCP4JHOfveNCYcFSSgSQXsNYUyq7uAXUTCmRplTx
Trrt0yDqBA4ezBhwOaQKpzmhX7e/shXgRxkbDF9+LLBuX6U6rYFv5hOteJtt3jq/
Z0DA6nrZQ9qBq2L0Egn/0937u+DdhcFtZbVYYwhcUZdaNXh4VMC2FqMXKbqIZMAA
sPclJ8yAggWipTDRUpC0913KXT5DmQ1BH64OUlrUugROT2aXErrBoHIety0ch3CX
F3n+KHNp39xBsKIoQuScHaQm1RpF63XBJ+IlsGu5L/X9FiLP0Bspg6W0nesvcKm+
sV5hX19EKcItghf5DdEMTYrpNA8STx5xVMxgSVVv2CUs1xLGtT4B+FZGgNv8X5K3
mxSbN9+v1HkHXreWJ5Gy
=vBzS
-----END PGP SIGNATURE-----

--jaoouwwPWoQSJZYp--
