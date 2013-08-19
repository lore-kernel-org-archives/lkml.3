Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751542Ab3HSMM5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 08:12:57 -0400
Received: from mail-bk0-f48.google.com ([209.85.214.48]:53421 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334Ab3HSMMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 08:12:55 -0400
Date: Mon, 19 Aug 2013 14:12:39 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: kernel-janitors@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-tegra@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] PCI: tegra: replace devm_request_and_ioremap by
 devm_ioremap_resource
Message-ID: <20130819121238.GB5740@ulmo>
References: <1376911241-27720-1-git-send-email-Julia.Lawall@lip6.fr>
 <1376911241-27720-2-git-send-email-Julia.Lawall@lip6.fr>
 <20130819120249.GA5740@ulmo>
 <alpine.DEB.2.02.1308191405450.2313@hadrien>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1UWUbFP1cBYEclgG"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1308191405450.2313@hadrien>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1UWUbFP1cBYEclgG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 19, 2013 at 02:07:54PM +0200, Julia Lawall wrote:
>=20
>=20
> On Mon, 19 Aug 2013, Thierry Reding wrote:
>=20
> > On Mon, Aug 19, 2013 at 01:20:35PM +0200, Julia Lawall wrote:
> > > From: Julia Lawall <Julia.Lawall@lip6.fr>
> > >
> > > Use devm_ioremap_resource instead of devm_request_and_ioremap.
> > >
> > > This was done using the semantic patch
> > > scripts/coccinelle/api/devm_ioremap_resource.cocci
> > >
> > > Error-handling code was manually removed from the associated calls to
> > > platform_get_resource.
> > >
> > > Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> > >
> > > ---
> > > The first block of modified code is followed by a call to
> > > devm_request_mem_region for pcie->cs with no associated ioremap.  Sho=
uld
> > > ioremap be used in this case as well?
> >
> > No. The pcie->cs resource is 256 MiB so it's challenging to map it at
> > once. Furthermore it requires a non-linear mapping so we do it on
> > demand.
>=20
> OK, thanks for the explanation.  Is the comment, though, a little
> misleading, since the mapping is not done here?
>=20
> /* request and remap configuration space */

Yes, that's misleading. Given that it doesn't really add anything useful
information either, perhaps I should just remove it.

Thanks,
Thierry

--1UWUbFP1cBYEclgG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSEgu2AAoJEN0jrNd/PrOhmpsQAKb6aXgLHss4xGOsb3X9t/bT
Q7DlJBlTdTfUqsbBGt/GvzZBA5H4w3I9KY95L2zJSd8gRHq85Wg/zz7cs1DfnsAF
TG9QNplpaVXZjrSKD7s+FByxT/gzf+b9qkqT1XnDN9X5x34wegRhaZt4k8yKBVn5
VH7Rm4QsIWzPq9DPi8+FjbuK0fBLrWB9pMbw+Ebd1kGormHbMuIJ5uz5GvwxYyCS
/wG1eYkW7W/UEoI9VqRrtRLfxyFcdqnj1MM6ZScsVGt41LbVK6DUjTVYbbYN+T9C
clSzi7JEj8IJOlIaEJRGYkcvkwl0UnBPCSJRy/Pds4znDLrwFDGPzP2xGAihgH9g
RTAeAFN5QuT8+Ik3uZ/NhySTg57C0qcLJXBnSsSbPOE86xjyKnAOw1bvFnS0Hpsf
ijA8Hc9DbdfMzlZMpcKtdKM3DT80/aK2yI/+XOx02i4thavJkLq68gi1zZT4WoW0
cUMXoK08qvUTD8z/c4u5Q/kA+KkDrlMciMC5CpPOPY+k2Hg88qcelY3xFCBo2Oqg
nabPvbB63o2UG0v1WcIB5ud1/3T0Im+xa04CV6H975CZ/OZR9x60yUQQWWYZoOfy
ANhe5qBlEo92LnQTqbFSNY6VR5THF3Wt4LZUzrwvyzVBNYjNJshs0vl8Fz03BsuC
yZMGobA1UNTUhzPz46GD
=M3fL
-----END PGP SIGNATURE-----

--1UWUbFP1cBYEclgG--
