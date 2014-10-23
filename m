Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751768AbaJWNUI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 09:20:08 -0400
Received: from down.free-electrons.com ([37.187.137.238]:60599 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751180AbaJWNUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 09:20:04 -0400
Date: Thu, 23 Oct 2014 15:19:33 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: dmaengine@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Antoine =?iso-8859-1?Q?T=E9nart?= <antoine@free-electrons.com>,
        lars@metafoo.de, Russell King <linux@arm.linux.org.uk>,
        Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v3 58/59] dmaengine: Add a warning for drivers not using
 the generic slave caps retrieval
Message-ID: <20141023131933.GO7893@lukather>
References: <1413992653-21963-1-git-send-email-maxime.ripard@free-electrons.com>
 <1413992653-21963-59-git-send-email-maxime.ripard@free-electrons.com>
 <2006617.Jsn4xl9O1U@avalon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wr1Q/2bz0MCWWNYv"
Content-Disposition: inline
In-Reply-To: <2006617.Jsn4xl9O1U@avalon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wr1Q/2bz0MCWWNYv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Oct 23, 2014 at 12:21:31AM +0300, Laurent Pinchart wrote:
> Hi Maxime,
>=20
> Thank you for the patch.
>=20
> On Wednesday 22 October 2014 17:44:12 Maxime Ripard wrote:
> > For the slave caps retrieval to be really useful, most drivers need to
> > implement it.
> >=20
> > Hence, we need to be slightly more aggressive, and trigger a warning at
> > registration time for drivers that don't fill their caps infos in order=
 to
> > encourage them to implement it.
> >=20
> > Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> > ---
> >  drivers/dma/dmaengine.c | 3 +++
> >  1 file changed, 3 insertions(+)
> >=20
> > diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
> > index 98e9431f85ec..4e18981b16bd 100644
> > --- a/drivers/dma/dmaengine.c
> > +++ b/drivers/dma/dmaengine.c
> > @@ -827,6 +827,9 @@ int dma_async_device_register(struct dma_device *de=
vice)
> > BUG_ON(!device->device_issue_pending);
> >  	BUG_ON(!device->dev);
> >=20
> > +	WARN(dma_has_cap(DMA_SLAVE, device->cap_mask) &&
> > !device->generic_slave_caps,
> > +	     "this driver doesn't support generic slave capabilities
> > reporting\n");
> > +
>=20
> This might be slightly too aggressive.

I disagree with that. If we want at some point to have the drivers
implement it, we should be aggressive (and note that we don't break
anything, the driver will still work as it used to).

> I agree with your previous comment on all DMA engine drivers
> returning the same capabilities for all channels, but it might not
> be true anymore in the future, in which case drivers will need to
> implement a custom slave caps function. We could delay support for
> that to when it's needed though.

Actually, my next patch (59) is removing such possibility... And you
acked it ;)

Is it still something we should be concerned about?

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--wr1Q/2bz0MCWWNYv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUSQBlAAoJEBx+YmzsjxAgEdoP/jt9fuct/5f+cUXsIs3ZpIdQ
YcyGDnEAvcu/HO5+t9G44+NW9M7/vzx0cpC2r/viQky+m169Wc3kI49gInds/zOI
2okX0yeqUXkgpWMBZBGzlFbAp55nEqchGzBJnmoQbAX7vgqUmZw1FIg+2gchb+IG
o9ZvHFZvkGN+FxXg4aw/aP58WpoxN3DzySgngQeJFoENTLtBNn6Fx7190HtzKCmT
D0oUNOHLSVP8MwOCNipKQyEClvUxFt/o31vUG/wbUE4RwYx/ADEqdD8QmbU9yMOZ
AZx04fStc7DU0kRoVacudD7t2D+v0wr/v2LlQRKN1Eeh7Wa3Wcw+UBm4QaL3f842
USbe0dfJCwAO2HOT+18ldOI6qExmJh8bGAG2QQLWWEh9ta5SiM6J8UvH4mNqJzQW
nHt84sh9uH9ZSCgHUg1U63XRmyB3+OaLDFUPPH2HbJByj8QbSEjVidqGw8axTyB2
nWmU3oqGcXiq/Tpfs+ieQ6c+069z8wtJtvzDoAf1YPFely46+JXKsbP0jTHON3ux
IF4U/ONB8ZdAa1yvGxsj3laMwURw3z/s/XmEXXHtnASxLw0V62DuviQC5lsB6vZN
WUTPuwyUlPaC6dUOPBjDzetagHVSpTttR1zvfLTl/NS2sjKy6tyXHoGVZgo8Q01V
HR/hDfEUh0kMWXyYcwWv
=WUSH
-----END PGP SIGNATURE-----

--wr1Q/2bz0MCWWNYv--
