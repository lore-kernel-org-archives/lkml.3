Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153AbaEUJAJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 05:00:09 -0400
Received: from top.free-electrons.com ([176.31.233.9]:37870 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750761AbaEUJAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 05:00:04 -0400
Date: Wed, 21 May 2014 10:58:29 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
        linux-arm-kernel@lists.infradead.org, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-sunxi@googlegroups.com, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        zhuzhenhua@allwinnertech.com, andriy.shevchenko@intel.com,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v7] DMA: sun6i: Add driver for the Allwinner A31 DMA
 controller
Message-ID: <20140521085829.GP27329@lukather>
References: <20140430070408.GR32284@intel.com>
 <20140513134258.GA29258@lukather>
 <20140521053105.GI21128@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dJyWBSYfjLochwFK"
Content-Disposition: inline
In-Reply-To: <20140521053105.GI21128@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dJyWBSYfjLochwFK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 21, 2014 at 11:01:05AM +0530, Vinod Koul wrote:
> On Tue, May 13, 2014 at 03:42:58PM +0200, Maxime Ripard wrote:
> > Hi Vinod,
> >=20
> > On Wed, Apr 30, 2014 at 12:34:08PM +0530, Vinod Koul wrote:
> > > > +
> > > > +static int sun6i_dma_terminate_all(struct sun6i_vchan *vchan)
> > > > +{
> > > > +	struct sun6i_dma_dev *sdev =3D to_sun6i_dma_dev(vchan->vc.chan.de=
vice);
> > > > +	struct sun6i_pchan *pchan =3D vchan->phy;
> > > > +	unsigned long flags;
> > > > +	LIST_HEAD(head);
> > > > +
> > > > +	spin_lock(&sdev->lock);
> > > > +	list_del_init(&vchan->node);
> > > > +	spin_unlock(&sdev->lock);
> > > > +
> > > > +	spin_lock_irqsave(&vchan->vc.lock, flags);
> > > > +
> > > > +	vchan_get_all_descriptors(&vchan->vc, &head);
> > > > +
> > > > +	if (pchan) {
> > > > +		writel(DMA_CHAN_ENABLE_STOP, pchan->base + DMA_CHAN_ENABLE);
> > > > +		writel(DMA_CHAN_PAUSE_RESUME, pchan->base + DMA_CHAN_PAUSE);
> > > > +
> > > > +		vchan->phy =3D NULL;
> > > > +		pchan->vchan =3D NULL;
> > > > +		pchan->desc =3D NULL;
> > > > +		pchan->done =3D NULL;
> > > > +	}
> > > > +
> > > > +	spin_unlock_irqrestore(&vchan->vc.lock, flags);
> > > > +
> > > > +	vchan_dma_desc_free_list(&vchan->vc, &head);
> > >=20
> > > shouldn't you kill the tasklet as well here?
> >=20
> > Just to be clear, which tasklet? vchan's or the driver's?
> You need to take care of both. But I suspect if we ensure irq is not trig=
gered
> and any pending ones are completed you can simply kill both of the taskle=
ts
> happily. See the fixes merged in dmaengine last cycle (hint: patchlog sho=
ws what
> we need to do)

I still don't get why I should kill the driver tasklet in terminate_all.

The tasklet is common to all the channels, if you kill it, you'll
prevent it from scheduling while other channels might have had a need
for it to actually run.

About the commits themselves, I guess you talk about 9068b032 and
ccc7aad0. Both these commits only fix the remove path, not the
terminate_all one, and both these drivers are not doing anything
related to the tasklet in terminate_all.

> Btw just noticed, you *should* use dmaengine: as the subsytem name on the=
 patch
> series...

Ok, I will.

Thanks,
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--dJyWBSYfjLochwFK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTfGq1AAoJEBx+YmzsjxAgjiAQAISBPjbBYQ2w1I1KjjkPPtgG
roq4ZOP6pmClDOFBJPXv3Q9QGGMMRv7HP1mremQKH/kbAvu9bi53br7KWvsFUpLF
3MUHuwARRpSOK1ZQMT5CPW2k7KFtARd8AMVVdOkTbpoCbWBGZuWw7oxs/mrMmhJf
gLpLvCgEqAfVVfdP6ca/hK2FYVavHIysXdsrd0u2bgntygM5fgaDLrE5IDpwEy3D
HeEbox8Wy/O5mnVkefVLJD9zIZHt3rFYr1r52Hmi+oXJCqnCujUSfCk3NQ7ZgqcW
NQoNPIove3pZne6GNyG14tMgr9lSzba6G2JUKJKYHUWL1PszxFIarudyoo+m0+wW
PnUpjHaKC161ZPgqMBHWdAXHPDC8ZWrahxMfo7N1LjZeWZ7nlLpfg2Nh1ApsjVg/
OPwOQuwq5tBB6cf5Pnd1ka6uX3o5VTX5mero0aTdxIytYHvTl1x8Yla9cE+DnpcB
GwNz3F/03WKKnEzehgLOzpe4//iVaGMEnZnSSSBFjrG3dAddcYNBYgx/HWzm87l3
jzpH7Y8ZtmhZP99M4FHmwI53ZlPpjDkI7b4jY2sql+JM0KYw3iemezHu3pG+RLwt
ejIFRYOvPAAENTXnS7D/c7X1b56v5spNcMoCgjD6oSNXeC6XMwnaBxDffJP0LrcA
jiZpMDGsxCnxiuC0YdAy
=6gGe
-----END PGP SIGNATURE-----

--dJyWBSYfjLochwFK--
