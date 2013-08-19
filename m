Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751676Ab3HSVmB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 17:42:01 -0400
Received: from mail-bk0-f42.google.com ([209.85.214.42]:39495 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132Ab3HSVmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 17:42:00 -0400
Date: Mon, 19 Aug 2013 23:41:56 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Hiroshi Doyu <hdoyu@nvidia.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 2/4] driver core: Allow early registration of devices
Message-ID: <20130819214155.GB9885@mithrandir>
References: <1376685563-1053-1-git-send-email-treding@nvidia.com>
 <1376685563-1053-3-git-send-email-treding@nvidia.com>
 <20130816210637.GC2198@kroah.com>
 <20130816215530.GA14464@mithrandir>
 <20130816220807.GA6848@kroah.com>
 <20130817111747.GB1536@mithrandir>
 <5212757F.2080107@wwwdotorg.org>
 <20130819201042.GB5191@mithrandir>
 <521285D1.2050500@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qcHopEYAB45HaUaB"
Content-Disposition: inline
In-Reply-To: <521285D1.2050500@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qcHopEYAB45HaUaB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 19, 2013 at 02:53:37PM -0600, Stephen Warren wrote:
> On 08/19/2013 02:10 PM, Thierry Reding wrote:
> > On Mon, Aug 19, 2013 at 01:43:59PM -0600, Stephen Warren wrote:
> >> On 08/17/2013 05:17 AM, Thierry Reding wrote: ...
> >>> Well, the most obvious cases where early initialization is
> >>> needed are interrupt controllers and clocks.
> >>=20
> >> ... and IOMMUs, which apparently need to initialize before any
> >> devices whose transactions are routed through the IOMMU, in order
> >> to set themselves up as the IOMMU for the relevant devices.
> >>=20
> >> It's possible that the CPU-visible bus structure isn't a strict=20
> >> inverse/reverse of the device-visible bus-structure. A device may
> >> have CPU-visible registers on one bus segment, but inject master=20
> >> transactions onto an unrelated bus segment. So it may not be as
> >> simple as making a bus driver for the bus segment affected by the
> >> IOMMU, and having that driver trigger instantiation of all its
> >> children.
> >=20
> > Well, perhaps that can be handled via deferred probing? The only
> > thing preventing that right now is that drivers aren't actively
> > aware of the IOMMUs existence. If we can make it a requirement that
> > each driver needing the services of an IOMMU actively requests that
> > service, then deferred probing should be able to deal with it.
>=20
> I believe the hope was to specifically avoid drivers knowing about the
> presence of an IOMMU. Drivers would simply use standard dma
> alloc/map/unmap APIs, and those APIs would internally set up any IOMMU
> HW is present and necessary.
>=20
> Having e.g. a DT property that says "this is your IOMMU" which drivers
> had to explicitly handle parsing, and/or requiring drivers to make
> some call during probe to say "bind to an IOMMU" (unless that API can
> simply be called in all cases including when there actually is no
> IOMMU) would be a bit annoying.

Yes, I don't think drivers should have to do that manually either. In my
opinion it falls in the same category as setting up the default pinmux
state, which is now handled by the core as well.

> > That doesn't necessarily mean that drivers need to be doing it
> > manually. It strikes me as the kind of thing that could easily be
> > done by the core. In fact I've been thinking of doing something
> > similar to resolve devicetree IRQ references at probe time, rather
> > than at device creation time to remove the need for interrupt chips
> > to register early.
>=20
> If we can make this automatic and hidden yet still use deferred
> probing, then that'd likely be just fine.

I plan to investigate how this could be done for the IRQ reference
resolution and if that can be done it should be possible to do it for
IOMMUs as well.

Thierry

--qcHopEYAB45HaUaB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSEpEjAAoJEN0jrNd/PrOh2HgQALj4MrnOZ+h0MSsrBhD+bOpg
cHN6h93Qx2smB7rcGfkg2LZBaUf5sFOqjaRfFeNmqKqk02QlPUrreGRqEKxWEnD0
0ISB8z5yZ8jQPid40Ou6MtdGsssXAUZALl0ObBUu1CU/R63tBnbPsDBaEsXkfjft
K5nQgmveTPB4xahgkZbKkc4xNa5jYIzOCUVYwQ+DHGs3SdIrDN97bx0kPRpH5lyQ
jke14j8Mzktts/mDerDgVRbCef7Hhf/fioSsiRAvaIBAcvn0RhgV2nJcYAVIZGLc
M+5JLFqMVs2Af/zwfkImfCnHpeSXqbDmXT4sYYTvSZ8uU0h8mUiZn/Sn6prnat7w
C2YzsCavM+bCGPsawC4VAKZSBRMoAtuY4B2QRencoqyeQv7Pn69voA728fqDpgPd
pAIcBeeHqwp0u6Sv+Pb2TnkaQYPRxRvv7Lftag4xsKdxoZX1qr5wBtWw7AO6/0s/
texVhpSS78BujK4aJ/f2t7CTEaK61MERsWHjsO03zcCt68+PzB3TKz9wB9tp98NP
D+tVw0F/Ovy5En2Eyir7MDPBAzmvku8b0BtzB8ydfXuoP4QEsu5ZtxCOptmml2Ad
AFH6O+OqmJB5DCEx1xOdFXmPMjCLJH7ihnG8H0CSWkHmVhZ6ZBWmJ4hOs3QylAeM
dHrPkxKqBgUmjtK8JSP4
=E1TI
-----END PGP SIGNATURE-----

--qcHopEYAB45HaUaB--
