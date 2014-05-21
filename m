Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751659AbaEUFql (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 01:46:41 -0400
Received: from mga11.intel.com ([192.55.52.93]:63521 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750875AbaEUFqk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 01:46:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,878,1392192000"; 
   d="asc'?scan'208";a="535270359"
Date: Wed, 21 May 2014 11:01:05 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
        linux-arm-kernel@lists.infradead.org, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-sunxi@googlegroups.com, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        zhuzhenhua@allwinnertech.com, andriy.shevchenko@intel.com,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v7] DMA: sun6i: Add driver for the Allwinner A31 DMA
 controller
Message-ID: <20140521053105.GI21128@intel.com>
References: <20140430070408.GR32284@intel.com>
 <20140513134258.GA29258@lukather>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wLAMOaPNJ0fu1fTG"
Content-Disposition: inline
In-Reply-To: <20140513134258.GA29258@lukather>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wLAMOaPNJ0fu1fTG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 13, 2014 at 03:42:58PM +0200, Maxime Ripard wrote:
> Hi Vinod,
>=20
> On Wed, Apr 30, 2014 at 12:34:08PM +0530, Vinod Koul wrote:
> > > +
> > > +static int sun6i_dma_terminate_all(struct sun6i_vchan *vchan)
> > > +{
> > > +	struct sun6i_dma_dev *sdev =3D to_sun6i_dma_dev(vchan->vc.chan.devi=
ce);
> > > +	struct sun6i_pchan *pchan =3D vchan->phy;
> > > +	unsigned long flags;
> > > +	LIST_HEAD(head);
> > > +
> > > +	spin_lock(&sdev->lock);
> > > +	list_del_init(&vchan->node);
> > > +	spin_unlock(&sdev->lock);
> > > +
> > > +	spin_lock_irqsave(&vchan->vc.lock, flags);
> > > +
> > > +	vchan_get_all_descriptors(&vchan->vc, &head);
> > > +
> > > +	if (pchan) {
> > > +		writel(DMA_CHAN_ENABLE_STOP, pchan->base + DMA_CHAN_ENABLE);
> > > +		writel(DMA_CHAN_PAUSE_RESUME, pchan->base + DMA_CHAN_PAUSE);
> > > +
> > > +		vchan->phy =3D NULL;
> > > +		pchan->vchan =3D NULL;
> > > +		pchan->desc =3D NULL;
> > > +		pchan->done =3D NULL;
> > > +	}
> > > +
> > > +	spin_unlock_irqrestore(&vchan->vc.lock, flags);
> > > +
> > > +	vchan_dma_desc_free_list(&vchan->vc, &head);
> >=20
> > shouldn't you kill the tasklet as well here?
>=20
> Just to be clear, which tasklet? vchan's or the driver's?
You need to take care of both. But I suspect if we ensure irq is not trigge=
red
and any pending ones are completed you can simply kill both of the tasklets
happily. See the fixes merged in dmaengine last cycle (hint: patchlog shows=
 what
we need to do)

Btw just noticed, you *should* use dmaengine: as the subsytem name on the p=
atch
series...

--=20
~Vinod

--wLAMOaPNJ0fu1fTG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJTfDoZAAoJEHwUBw8lI4NHOdsQAMJItjE0rchKgQkgUxxEufWy
x74+z76IOiwGttCzpWadq4d0u7+obaTNKW/i5RU7jfmue2973pj+/zqcbSJNN10f
NjguD+CcX5w2Jxoi3mcOkbpyvoai8wWubi+U3WFMPFnAv4c7r/cMsf5A7QF7uMd0
jV/1kmZcd1oj+aDWOkpIfA560MSv1b/9HH3c6IqGCAKpoEUbavmzWJ6VJyJmhuLS
H6RTR3IhXHJMw3tbkVz0h+JDoga1GtC+1mmtSokRQyTc24qVA4p78ApjJ0oGu6CX
Nq+sDnt8UHtwyCaFKL68BKP2n4/WxTeeFR5DUsJ0m5PpkNSwFDPY6zIQBPg+7Qse
a98mtClhwQSap6nJJ4juEjo/VfqrjYPmwV9at1OdkAbuCKo0mU9fZvLDIMgP1wK4
XJrZy0ELpZBurr6T0v6NNFr9yWm7ZZVVe+fymBdTSVNJgxwFuXHF0oIjz+oJjd7s
f6xuD5w6b98S7sPiS0nYX+dpyrO4XPOzHH4rGFl5VpUcqtHrYSLzhJetLTgDOiQw
6DezEYe9nGXdYWRhDfObLgB1ak7CjOmwtdEgDoBVuYPJT0Q/gYUOa7S0JW0vG90V
6piimRZ3N0TLL+dF58hxiyZKEcuqvtQxnQRs1cSWZsPptgwviASL6k88QpWA2Rh7
uRIf2zeugOuv71zugcU9
=I1zu
-----END PGP SIGNATURE-----

--wLAMOaPNJ0fu1fTG--
