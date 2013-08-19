Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751258Ab3HSTdq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 15:33:46 -0400
Received: from mail-bk0-f42.google.com ([209.85.214.42]:57608 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833Ab3HSTdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 15:33:44 -0400
Date: Mon, 19 Aug 2013 21:33:40 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: kernel-janitors@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-tegra@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] PCI: tegra: replace devm_request_and_ioremap by
 devm_ioremap_resource
Message-ID: <20130819193339.GB4961@mithrandir>
References: <1376911241-27720-1-git-send-email-Julia.Lawall@lip6.fr>
 <1376911241-27720-2-git-send-email-Julia.Lawall@lip6.fr>
 <20130819120249.GA5740@ulmo>
 <alpine.DEB.2.02.1308191405450.2313@hadrien>
 <20130819121238.GB5740@ulmo>
 <alpine.DEB.2.02.1308191414360.2313@hadrien>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="b5gNqxB1S1yM7hjW"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1308191414360.2313@hadrien>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--b5gNqxB1S1yM7hjW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 19, 2013 at 02:15:39PM +0200, Julia Lawall wrote:
>=20
>=20
> On Mon, 19 Aug 2013, Thierry Reding wrote:
>=20
> > On Mon, Aug 19, 2013 at 02:07:54PM +0200, Julia Lawall wrote:
> > >
> > >
> > > On Mon, 19 Aug 2013, Thierry Reding wrote:
> > >
> > > > On Mon, Aug 19, 2013 at 01:20:35PM +0200, Julia Lawall wrote:
> > > > > From: Julia Lawall <Julia.Lawall@lip6.fr>
> > > > >
> > > > > Use devm_ioremap_resource instead of devm_request_and_ioremap.
> > > > >
> > > > > This was done using the semantic patch
> > > > > scripts/coccinelle/api/devm_ioremap_resource.cocci
> > > > >
> > > > > Error-handling code was manually removed from the associated call=
s to
> > > > > platform_get_resource.
> > > > >
> > > > > Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> > > > >
> > > > > ---
> > > > > The first block of modified code is followed by a call to
> > > > > devm_request_mem_region for pcie->cs with no associated ioremap. =
 Should
> > > > > ioremap be used in this case as well?
> > > >
> > > > No. The pcie->cs resource is 256 MiB so it's challenging to map it =
at
> > > > once. Furthermore it requires a non-linear mapping so we do it on
> > > > demand.
> > >
> > > OK, thanks for the explanation.  Is the comment, though, a little
> > > misleading, since the mapping is not done here?
> > >
> > > /* request and remap configuration space */
> >
> > Yes, that's misleading. Given that it doesn't really add anything useful
> > information either, perhaps I should just remove it.
>=20
> OK, or maybe something like
>=20
> /* request configuration space, but remap later, on demand */
>=20
> To make it clear that something different is intended than the
> devm_ioremap_resources that come just before..

Yes, that works for me too. Can you respin the patch with the comment
updated and my Acked-by and Tested-by so Bjorn can pick it up?

Thierry

--b5gNqxB1S1yM7hjW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSEnMTAAoJEN0jrNd/PrOhXm0P/Aq1cDNbUVylWq4kk1+i8YD5
W6NdJOrjZyYk5YH7PI4w0hIrtTbWWmun+SrWjXZvLOZF83DOxhXwrCeksQrINY8A
C5GSRxzTq/7utJDZNZGDZa8meBVTFPlyP40fvBan5BYLDr1qkIht0IMZDojK1HLR
bH5iRTAe6d5/Dowqj1kQKCqa7NG4W0Oo9X4uDirHo4f24vQIx1g21ZOb9XTFOdDE
J3nRNGcCglbqUi4DTiaAikU27QvUSoX4Dx04lZOaBsKHHh4hNBjOMKfi+PPeLJl+
OS3thlgCyznonXGCMV+6gMCZhdZTyOhecFacENfJLJF08dneqMaKzy/qNsUXgDHQ
IXCtryAd8mwhcP0HcX78eaBWlVs6NAy6hVMyGK9QXkbw0JQ5+JHAltuKn6IsCytH
K2XXnrqA4L+1t/yB7IfjJfwHC2ry7q1zCpQNFSP8M0cA4NaCMnL7M77TtTk+1Mm1
ycAM1DH8lk5PJSFBxT2pXMmBgBLGWHcL8B2ghZwMtVxDv6qyX2HOEcehEJyiKzNy
kojKCELRy9AeeqGVlygRT6ui1CRCu41JJTikxIPmMF7AuDcuFUjpmWtZEcjY67CU
I4l0i3C75coEnXKB3qofU6M9pNFyenlr+Yyl+v8IV7Rowy9M75q+BaEklohRvxEN
SBXOzFok/8xXdwiF/z91
=Wcy4
-----END PGP SIGNATURE-----

--b5gNqxB1S1yM7hjW--
