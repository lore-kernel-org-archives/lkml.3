Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751856AbaGaQ1Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 12:27:16 -0400
Received: from top.free-electrons.com ([176.31.233.9]:36976 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750911AbaGaQ1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 12:27:12 -0400
Date: Thu, 31 Jul 2014 18:23:30 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Vinod Koul <vinod.koul@intel.com>
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
Message-ID: <20140731162330.GE3952@lukather>
References: <1406736193-26685-1-git-send-email-maxime.ripard@free-electrons.com>
 <20140730160607.GM8181@intel.com>
 <20140731074440.GY3952@lukather>
 <20140731115628.GQ8181@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="95nVhCDQCgPWiQqT"
Content-Disposition: inline
In-Reply-To: <20140731115628.GQ8181@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--95nVhCDQCgPWiQqT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 31, 2014 at 05:26:28PM +0530, Vinod Koul wrote:
> On Thu, Jul 31, 2014 at 09:44:40AM +0200, Maxime Ripard wrote:
> > Hi Vinod,
> >=20
> > On Wed, Jul 30, 2014 at 09:36:07PM +0530, Vinod Koul wrote:
> > > On Wed, Jul 30, 2014 at 06:03:13PM +0200, Maxime Ripard wrote:
> > > > The dmaengine is neither trivial nor properly documented at the mom=
ent, which
> > > > means a lot of trial and error development, which is not that good =
for such a
> > > > central piece of the system.
> > > >=20
> > > > Attempt at making such a documentation.
> > >=20
> > > Did you miss Documentation/dmaengine.txt, lots of this is already cov=
ered
> > > there. But yes i would be really glad to know what isnt, so that we c=
an fix
> > > that.
> >=20
> > I didn't miss it. But I feel like it describes quite nicely the slave
> > API, but doesn't help at all whenever you're writing a DMAengine driver.
> >=20
> > The first lines of the existing document makes it quite clear too.
> >=20
> > There's still a bit of duplication, but I don't feel it's such a big
> > deal.
> And that made me think that you might have missed it.
>=20
> I am okay for idea to have this document but it needs to co-exist one. No
> point in duplicating as it can create ambiguity in future.

The only duplication I'm seeing is about the device_prep* operations,
that get described in dmaengine.txt too.

There's also a minor one about struct dma_slave_config, but both are
rather generic and point to dmaengine.h, so I guess we won't be at
risk of any real ambiguity.

Do you see anything else?

> > What I'd like to do with the documentation I just sent is basically
> > have a clear idea whenever you step into dmaengine what you can/cannot
> > do, and have a reference document explaining what's expected by the
> > framework, and hopefully have unified drivers that follow this
> > pattern.
> Sure, can you pls modify this to avoid duplication. I would be happy to
> apply that :)

See above :)

Also, feel free to add anything that you feel like you keep saying
during the review. If mistakes keep coming, it's probably worth
documenting what you expect.

> > Because, for the moment, we're pretty much left in the dark with
> > different drivers doing the same thing in completetely different ways,
> > with basically no way to tell if it's either the framework that
> > requires such behaviour, or if the author was just feeling creative.
> >=20
> > There's numerous examples for this at the moment:
> >   - The GFP flags, with different drivers using either GFP_ATOMIC,
> >     GFP_NOWAIT or GFP_KERNEL in the same functions
> >   - Having to set device_slave_caps or not?
> >   - Some drivers use dma_run_depedencies, some other don't
> >   - That might just be my experience, but judging from previous
> >     commits, DMA_PRIVATE is completely obscure, and we just set it
> >     because it was making it work, without knowing what it was
> >     supposed to do.
> >   - etc.
>=20
> Thanks for highlighting we should definitely add these in Documentation

It's quite clear in the case of the GFP flags now, Lars-Peter and you
cleared up device_slave_caps, but I still could use some help with
DMA_PRIVATE.

> > And basically, we have no way to tell at the moment which one is
> > right and which one needs fixing.
> >=20
> > The corollary being that it cripples the whole community ability to
> > maintain the framework and make it evolve.
> >=20
> > > > +  * device_slave_caps
> > > > +    - Isn't that redundant with the cap_mask already?
> > > > +    - Only a few drivers seem to implement it
> > > For audio to know what your channel can do rather than hardcoding it
> >=20
> > Ah, yes, I see it now. It's not related to the caps mask at all.
> >=20
> > Just out of curiosity, wouldn't it be better to move this to the
> > framework, and have these informations provided through the struct
> > dma_device? Or would it have some non-trivial side-effects?
> Well the problem is ability to have this queried uniformly from all drive=
rs
> across subsystems. If we can do this that would be nice.

I can work on some premelinary work to do just that, and see if it
works for you then.

> > > > +  * dma cookies?
> > > cookie is dma transaction representation which is monotonically incre=
menting
> > > number.
> >=20
> > Ok, and it identifies a unique dma_async_tx_descriptor, right?
> Yup and this basically represents transactions you have submitted. Thats =
why
> cookie is allocated at tx_submit.

Ok, thanks.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--95nVhCDQCgPWiQqT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT2m2CAAoJEBx+YmzsjxAgaWAQAJsmFfyMypqHmZHxZKY1VAEe
nuR0TE8o4eV3xcVC0BcKLFVWk1b1DUg/NrBw/Gxz3u7fUlEmwaKbLFakU6r4peRe
IArD+pC1zCbM9Zf/P8TNtJ+gNJZZsh7rNITbBGXb/cOIwyYMxwN+K00eLEdzzPlO
s+fHWkdf30B7IkzvEqtytRt6KdW6mhY62EB+ucIIVRtoVQbTdlLEcwvmcaS05GnO
m9TgdQLP1FuM4i/2XoqTdZxelOoRLEy3s4e99rluqmFWi9Rb7aF00eRZRv8uffAu
5MUHfXe7BbaVsZcQ1jEctFaxVjuFRI+EbktYoe/8ttIheqHj9EAa8jguAS2mjIzF
99KzCLBOQFHeseUrWhtx7R3NzC0VMhAiKtn1AFiblU6Eg7SPFUuhjWlMUaL46cX7
fC/RpnnTjWyGWPlzsGZWtxxzA41bUnss/4/C/BjKPt+RnFCpDQsVDT5syRHBGSEw
YeI92Rpkc2PWQSo63+1gmfccul0xEhFTGNN7WOUXIomtSqRSl8lUL2E+iCyjQZtv
hsn1sr+ynv2o/+XM6Hmmb4mtKpFQEUpeJIGCLT71cySb52c/vbEzbB+v994EwYm0
P4NxDH27qw8LKmARn7KhlAeBks8KpcLZTMPHTdhq9ZegViBe144nAFk5Rm+GRwGI
9CD/uHxvhdHCeDl0BICh
=25UP
-----END PGP SIGNATURE-----

--95nVhCDQCgPWiQqT--
