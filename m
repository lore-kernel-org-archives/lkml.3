Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751624AbaLERKL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 12:10:11 -0500
Received: from down.free-electrons.com ([37.187.137.238]:55812 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750748AbaLERKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 12:10:09 -0500
Date: Fri, 5 Dec 2014 18:07:44 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Antoine =?iso-8859-1?Q?T=E9nart?= <antoine@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>, lars@metafoo.de
Subject: Re: [PATCH v5 34/61] dmaengine: omap: Split device_control
Message-ID: <20141205170744.GW30256@lukather>
References: <1416231775-31252-1-git-send-email-maxime.ripard@free-electrons.com>
 <1416231775-31252-35-git-send-email-maxime.ripard@free-electrons.com>
 <20141205142702.GF3411@intel.com>
 <20141205143359.GV30256@lukather>
 <20141205145642.GI3411@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RCcFxJ34+mAtH0DM"
Content-Disposition: inline
In-Reply-To: <20141205145642.GI3411@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RCcFxJ34+mAtH0DM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 05, 2014 at 08:26:42PM +0530, Vinod Koul wrote:
> On Fri, Dec 05, 2014 at 03:33:59PM +0100, Maxime Ripard wrote:
> > Hi Vinod,
> >=20
> > On Fri, Dec 05, 2014 at 07:57:02PM +0530, Vinod Koul wrote:
> > > On Mon, Nov 17, 2014 at 02:42:28PM +0100, Maxime Ripard wrote:
> > > > Split the device_control callback of the TI OMAP DMA driver to make=
 use
> > > > of the newly introduced callbacks, that will eventually be used to =
retrieve
> > > > slave capabilities.
> > > >=20
> > > > Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> > > > ---
> > > >  drivers/dma/omap-dma.c | 51 +++++++++++++++-----------------------=
------------
> > > >  1 file changed, 15 insertions(+), 36 deletions(-)
> > > >=20
> > > > diff --git a/drivers/dma/omap-dma.c b/drivers/dma/omap-dma.c
> > > > index a8aa5b6bb5e2..1cadf812f3b3 100644
> > > > --- a/drivers/dma/omap-dma.c
> > > > +++ b/drivers/dma/omap-dma.c
> > > > @@ -948,8 +948,10 @@ static struct dma_async_tx_descriptor *omap_dm=
a_prep_dma_cyclic(
> > > >  	return vchan_tx_prep(&c->vc, &d->vd, flags);
> > > >  }
> > > > =20
> > > > -static int omap_dma_slave_config(struct omap_chan *c, struct dma_s=
lave_config *cfg)
> > > > +static int omap_dma_slave_config(struct dma_chan *chan, struct dma=
_slave_config *cfg)
> > > >  {
> > > > +	struct omap_chan *c =3D to_omap_dma_chan(chan);
> > > > +
> > > >  	if (cfg->src_addr_width =3D=3D DMA_SLAVE_BUSWIDTH_8_BYTES ||
> > > >  	    cfg->dst_addr_width =3D=3D DMA_SLAVE_BUSWIDTH_8_BYTES)
> > > >  		return -EINVAL;
> > > > @@ -959,8 +961,9 @@ static int omap_dma_slave_config(struct omap_ch=
an *c, struct dma_slave_config *c
> > > >  	return 0;
> > > >  }
> > > > =20
> > > > -static int omap_dma_terminate_all(struct omap_chan *c)
> > > > +static int omap_dma_terminate_all(struct dma_chan *chan)
> > > >  {
> > > > +	struct omap_chan *c =3D to_omap_dma_chan(chan);
> > > >  	struct omap_dmadev *d =3D to_omap_dma_dev(c->vc.chan.device);
> > > >  	unsigned long flags;
> > > >  	LIST_HEAD(head);
> > > > @@ -996,8 +999,10 @@ static int omap_dma_terminate_all(struct omap_=
chan *c)
> > > >  	return 0;
> > > >  }
> > > > =20
> > > > -static int omap_dma_pause(struct omap_chan *c)
> > > > +static int omap_dma_pause(struct dma_chan *chan)
> > > >  {
> > > > +	struct omap_chan *c =3D to_omap_dma_chan(chan);
> > > > +
> > > >  	/* Pause/Resume only allowed with cyclic mode */
> > > >  	if (!c->cyclic)
> > > >  		return -EINVAL;
> > > > @@ -1010,8 +1015,10 @@ static int omap_dma_pause(struct omap_chan *=
c)
> > > >  	return 0;
> > > >  }
> > > > =20
> > > > -static int omap_dma_resume(struct omap_chan *c)
> > > > +static int omap_dma_resume(struct dma_chan *chan)
> > > >  {
> > > > +	struct omap_chan *c =3D to_omap_dma_chan(chan);
> > > > +
> > > >  	/* Pause/Resume only allowed with cyclic mode */
> > > >  	if (!c->cyclic)
> > > >  		return -EINVAL;
> > > > @@ -1029,37 +1036,6 @@ static int omap_dma_resume(struct omap_chan =
*c)
> > > >  	return 0;
> > > >  }
> > > > =20
> > > > -static int omap_dma_control(struct dma_chan *chan, enum dma_ctrl_c=
md cmd,
> > > > -	unsigned long arg)
> > > > -{
> > > > -	struct omap_chan *c =3D to_omap_dma_chan(chan);
> > > > -	int ret;
> > > > -
> > > > -	switch (cmd) {
> > > > -	case DMA_SLAVE_CONFIG:
> > > > -		ret =3D omap_dma_slave_config(c, (struct dma_slave_config *)arg);
> > > > -		break;
> > > > -
> > > > -	case DMA_TERMINATE_ALL:
> > > > -		ret =3D omap_dma_terminate_all(c);
> > > > -		break;
> > > > -
> > > > -	case DMA_PAUSE:
> > > > -		ret =3D omap_dma_pause(c);
> > > > -		break;
> > > > -
> > > > -	case DMA_RESUME:
> > > > -		ret =3D omap_dma_resume(c);
> > > > -		break;
> > > > -
> > > > -	default:
> > > > -		ret =3D -ENXIO;
> > > > -		break;
> > > > -	}
> > > > -
> > > > -	return ret;
> > > > -}
> > > > -
> > > >  static int omap_dma_chan_init(struct omap_dmadev *od, int dma_sig)
> > > >  {
> > > >  	struct omap_chan *c;
> > > > @@ -1136,7 +1112,10 @@ static int omap_dma_probe(struct platform_de=
vice *pdev)
> > > >  	od->ddev.device_issue_pending =3D omap_dma_issue_pending;
> > > >  	od->ddev.device_prep_slave_sg =3D omap_dma_prep_slave_sg;
> > > >  	od->ddev.device_prep_dma_cyclic =3D omap_dma_prep_dma_cyclic;
> > > > -	od->ddev.device_control =3D omap_dma_control;
> > > this should be assigned to omap_dma_slave_config. omap_dma_control is=
 not
> > > here :(
> >=20
> > I'm not sure what you mean here. I'm removing this line, together with
> > the whole omap_dma_control function.
> Sorry wrong quote and not good explanations. the lines i quoted is
> wrong one...=20
>=20
> -       od->ddev.device_control =3D omap_dma_control;
> +       od->ddev.device_config =3D omap_dma_config;
> this is troubling line here...
>=20
> we dont have omap_dma_config. It should be omap_dma_slave_config instead

Ah, right.

I have no idea why it haven't been picked up by intel's build bot
thuough.

Anyway. Do you want me to send a new version of these patches for this
trivial fix and the mxs one, or do you want me to send a follow-up?

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--RCcFxJ34+mAtH0DM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUgeZgAAoJEBx+YmzsjxAgdv0P/3oaQxtE+wYwuAOC6xagF7ZM
BqnU1ncAukC8CsX0TgI5Fwe9y7v5NIRO6Xd84t555JJwDpzdO4xnhO42x8EbTaio
BvJO0lCtuFFQ6jOrs2NrGWgE1U1dtX0452aLA2O+I0mEZcfsPwTS7H4q5UFGEwSe
XEBbKObpUp5om8s3YkYlBwCV8WzFQ3dCMcvPOrzfTmRs+PS+PK3wkp6EuoL35LgA
tdkk7Ez9ZVKSe3qvazgRHekpihNBPAy8qf4rnSf7JhaPSKxCwQGyFXTvXBCvZzjU
gNTu3jH843OhFXH5ePuz4KirDFvN8CFUh+5PWhJaHjZcNctENLn4U+IcpTjCZOTs
TlYtjM28dOxjgiyICI97KDTq+JGbyUZ4TXx6SW22+xyOMtxOi+W7wRye8pM4DiIG
6UETT0Qf8ZVr1x0oT/SPwy1aq61Arz56bBr3V6d426w79YE8lDq4qSj/Ec8obduK
8M7h2p3wcUqx6xszvRfl2VszvJTHztwtbSXvwamtPWpm5syGiP4dJnervqSO+ZRj
kf0U/62oBKaXmR0Y0xwoVjVelwzGznYjejvO5T1IWxYl4nNF90UqGgk7/OThZ8s3
56y9eIwSU8BmLTN/iegk2L/yAqlLxPy2gbtwwarN5RhBP2FRv3bE/LLt6vK+4vR6
2maBAzpN3DdSEmu+vzGU
=afTZ
-----END PGP SIGNATURE-----

--RCcFxJ34+mAtH0DM--
