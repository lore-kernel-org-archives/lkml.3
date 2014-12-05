Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751275AbaLEO4U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 09:56:20 -0500
Received: from mga09.intel.com ([134.134.136.24]:35989 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751046AbaLEO4T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 09:56:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="asc'?scan'208";a="494252304"
Date: Fri, 5 Dec 2014 20:26:42 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Antoine =?iso-8859-1?Q?T=E9nart?= <antoine@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>, lars@metafoo.de
Subject: Re: [PATCH v5 34/61] dmaengine: omap: Split device_control
Message-ID: <20141205145642.GI3411@intel.com>
References: <1416231775-31252-1-git-send-email-maxime.ripard@free-electrons.com>
 <1416231775-31252-35-git-send-email-maxime.ripard@free-electrons.com>
 <20141205142702.GF3411@intel.com>
 <20141205143359.GV30256@lukather>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fdj2RfSjLxBAspz7"
Content-Disposition: inline
In-Reply-To: <20141205143359.GV30256@lukather>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fdj2RfSjLxBAspz7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 05, 2014 at 03:33:59PM +0100, Maxime Ripard wrote:
> Hi Vinod,
>=20
> On Fri, Dec 05, 2014 at 07:57:02PM +0530, Vinod Koul wrote:
> > On Mon, Nov 17, 2014 at 02:42:28PM +0100, Maxime Ripard wrote:
> > > Split the device_control callback of the TI OMAP DMA driver to make u=
se
> > > of the newly introduced callbacks, that will eventually be used to re=
trieve
> > > slave capabilities.
> > >=20
> > > Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> > > ---
> > >  drivers/dma/omap-dma.c | 51 +++++++++++++++-------------------------=
----------
> > >  1 file changed, 15 insertions(+), 36 deletions(-)
> > >=20
> > > diff --git a/drivers/dma/omap-dma.c b/drivers/dma/omap-dma.c
> > > index a8aa5b6bb5e2..1cadf812f3b3 100644
> > > --- a/drivers/dma/omap-dma.c
> > > +++ b/drivers/dma/omap-dma.c
> > > @@ -948,8 +948,10 @@ static struct dma_async_tx_descriptor *omap_dma_=
prep_dma_cyclic(
> > >  	return vchan_tx_prep(&c->vc, &d->vd, flags);
> > >  }
> > > =20
> > > -static int omap_dma_slave_config(struct omap_chan *c, struct dma_sla=
ve_config *cfg)
> > > +static int omap_dma_slave_config(struct dma_chan *chan, struct dma_s=
lave_config *cfg)
> > >  {
> > > +	struct omap_chan *c =3D to_omap_dma_chan(chan);
> > > +
> > >  	if (cfg->src_addr_width =3D=3D DMA_SLAVE_BUSWIDTH_8_BYTES ||
> > >  	    cfg->dst_addr_width =3D=3D DMA_SLAVE_BUSWIDTH_8_BYTES)
> > >  		return -EINVAL;
> > > @@ -959,8 +961,9 @@ static int omap_dma_slave_config(struct omap_chan=
 *c, struct dma_slave_config *c
> > >  	return 0;
> > >  }
> > > =20
> > > -static int omap_dma_terminate_all(struct omap_chan *c)
> > > +static int omap_dma_terminate_all(struct dma_chan *chan)
> > >  {
> > > +	struct omap_chan *c =3D to_omap_dma_chan(chan);
> > >  	struct omap_dmadev *d =3D to_omap_dma_dev(c->vc.chan.device);
> > >  	unsigned long flags;
> > >  	LIST_HEAD(head);
> > > @@ -996,8 +999,10 @@ static int omap_dma_terminate_all(struct omap_ch=
an *c)
> > >  	return 0;
> > >  }
> > > =20
> > > -static int omap_dma_pause(struct omap_chan *c)
> > > +static int omap_dma_pause(struct dma_chan *chan)
> > >  {
> > > +	struct omap_chan *c =3D to_omap_dma_chan(chan);
> > > +
> > >  	/* Pause/Resume only allowed with cyclic mode */
> > >  	if (!c->cyclic)
> > >  		return -EINVAL;
> > > @@ -1010,8 +1015,10 @@ static int omap_dma_pause(struct omap_chan *c)
> > >  	return 0;
> > >  }
> > > =20
> > > -static int omap_dma_resume(struct omap_chan *c)
> > > +static int omap_dma_resume(struct dma_chan *chan)
> > >  {
> > > +	struct omap_chan *c =3D to_omap_dma_chan(chan);
> > > +
> > >  	/* Pause/Resume only allowed with cyclic mode */
> > >  	if (!c->cyclic)
> > >  		return -EINVAL;
> > > @@ -1029,37 +1036,6 @@ static int omap_dma_resume(struct omap_chan *c)
> > >  	return 0;
> > >  }
> > > =20
> > > -static int omap_dma_control(struct dma_chan *chan, enum dma_ctrl_cmd=
 cmd,
> > > -	unsigned long arg)
> > > -{
> > > -	struct omap_chan *c =3D to_omap_dma_chan(chan);
> > > -	int ret;
> > > -
> > > -	switch (cmd) {
> > > -	case DMA_SLAVE_CONFIG:
> > > -		ret =3D omap_dma_slave_config(c, (struct dma_slave_config *)arg);
> > > -		break;
> > > -
> > > -	case DMA_TERMINATE_ALL:
> > > -		ret =3D omap_dma_terminate_all(c);
> > > -		break;
> > > -
> > > -	case DMA_PAUSE:
> > > -		ret =3D omap_dma_pause(c);
> > > -		break;
> > > -
> > > -	case DMA_RESUME:
> > > -		ret =3D omap_dma_resume(c);
> > > -		break;
> > > -
> > > -	default:
> > > -		ret =3D -ENXIO;
> > > -		break;
> > > -	}
> > > -
> > > -	return ret;
> > > -}
> > > -
> > >  static int omap_dma_chan_init(struct omap_dmadev *od, int dma_sig)
> > >  {
> > >  	struct omap_chan *c;
> > > @@ -1136,7 +1112,10 @@ static int omap_dma_probe(struct platform_devi=
ce *pdev)
> > >  	od->ddev.device_issue_pending =3D omap_dma_issue_pending;
> > >  	od->ddev.device_prep_slave_sg =3D omap_dma_prep_slave_sg;
> > >  	od->ddev.device_prep_dma_cyclic =3D omap_dma_prep_dma_cyclic;
> > > -	od->ddev.device_control =3D omap_dma_control;
> > this should be assigned to omap_dma_slave_config. omap_dma_control is n=
ot
> > here :(
>=20
> I'm not sure what you mean here. I'm removing this line, together with
> the whole omap_dma_control function.
Sorry wrong quote and not good explanations. the lines i quoted is
wrong one...=20

-       od->ddev.device_control =3D omap_dma_control;
+       od->ddev.device_config =3D omap_dma_config;
this is troubling line here...

we dont have omap_dma_config. It should be omap_dma_slave_config instead

--=20
~Vinod

+       od->ddev.device_pause =3D omap_dma_pause;
+       od->ddev.device_resume =3D omap_dma_resume;
+       od->ddev.device_terminate_all =3D omap_dma_terminate_all;

>=20
> Maxime
>=20
> --=20
> Maxime Ripard, Free Electrons
> Embedded Linux, Kernel and Android engineering
> http://free-electrons.com



--=20

--fdj2RfSjLxBAspz7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJUgceqAAoJEHwUBw8lI4NHI1UQAKjGnJsRIitQbpjAgTAqx451
oGlDS+yKanoiV0MzS5fw6KnF1gq6eiMxk1FnOpsMRcKOW6k0qRW6MtQ1cns8cMH6
/zHlaBAlNXbZzD+vsTLw9BhmgF6TREP1N17tP2QEWpD0dKZXcPhtrCGaHO4GTmVZ
hsrEf+SIxmFa7EnyP5an5ZAamGglXI9hFRuXubidN3DsrteYmTam7Dsliai73TYP
ChskT/loyzgWrm8E1enGP4AaNKqBzd3Af4oUm4EqnPKHqH0Ub2t+p5OelM+ZNAiS
OW9Mxg97nsQ9Fc0VxVmTbJwlFa8GJpCn9DBsh+B7c9TWs62EkU78GhB3AUSaOJwo
cmz4/M5i73awe0YWSUdkHSa0iA6qMAU24tJX/DL0/SVHVVKZD9KcUBf23gAwN0AC
Wy3Vq7enDPZxHP78VW5b0wgJkctFOUGxpUJEo74KSMtl1XXDrSruDV4aJcfpaF/1
mfKShnIITQjYGi5dbfH9i/7pLeLL0bjKyiyfTDw9SxUTDb7p8YpNtnaGio/2yciu
OkLAhDL3J5FI+xVa4c+ZzXNavdnrgJ38gHiN/e6b+rQMcaxqPyB1bqM5jFWY5ULK
Lm2AqZhNrcqG26OPqb3YVaJWVqLnAnjCaBlCeYDwf6rAIPxrwf9UVuLlltiWhco/
8xiFALa5bcGOEMxF8yu6
=C8nM
-----END PGP SIGNATURE-----

--fdj2RfSjLxBAspz7--
