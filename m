Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751767Ab3HSMDK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 08:03:10 -0400
Received: from mail-bk0-f47.google.com ([209.85.214.47]:41991 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334Ab3HSMDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 08:03:07 -0400
Date: Mon, 19 Aug 2013 14:02:50 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: kernel-janitors@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-tegra@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] PCI: tegra: replace devm_request_and_ioremap by
 devm_ioremap_resource
Message-ID: <20130819120249.GA5740@ulmo>
References: <1376911241-27720-1-git-send-email-Julia.Lawall@lip6.fr>
 <1376911241-27720-2-git-send-email-Julia.Lawall@lip6.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/04w6evG8XlLl3ft"
Content-Disposition: inline
In-Reply-To: <1376911241-27720-2-git-send-email-Julia.Lawall@lip6.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 19, 2013 at 01:20:35PM +0200, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
>=20
> Use devm_ioremap_resource instead of devm_request_and_ioremap.
>=20
> This was done using the semantic patch
> scripts/coccinelle/api/devm_ioremap_resource.cocci
>=20
> Error-handling code was manually removed from the associated calls to
> platform_get_resource.
>=20
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
>=20
> ---
> The first block of modified code is followed by a call to
> devm_request_mem_region for pcie->cs with no associated ioremap.  Should
> ioremap be used in this case as well?

No. The pcie->cs resource is 256 MiB so it's challenging to map it at
once. Furthermore it requires a non-linear mapping so we do it on
demand.

>  drivers/pci/host/pci-tegra.c |   29 +++++++++--------------------
>  1 file changed, 9 insertions(+), 20 deletions(-)

Tested-by: Thierry Reding <treding@nvidia.com>
Acked-by: Thierry Reding <treding@nvidia.com>

Bjorn, how do you want to handle patches to the Tegra PCIe driver in the
future? Do you want me to prepare a branch and pull from that or would
you rather just take simple patches?

Thierry

--/04w6evG8XlLl3ft
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSEglpAAoJEN0jrNd/PrOhOTcQAKuObLu6NluZG2adbr82G6Wi
xzDJrTTVkyWS5CFDmhnRa7EutpxJODMBQhlZ6/gto1ii81rCMIHZLpzrpUV6e3BY
YDMwwfIyjYaf/Nq1c5YA7sQSpIkw+FTRudoHSdwQub0gJr5hWXS6aI3MCsRT6gKp
eiMA6cjYBsYs7czGXpdj6mwOTWv8qO4oey+gpdYhSMonzHg7v86W2JQ+jbnDqzXe
1xmNFF89rnujJ2Uh/aAccRD25fO5B/d5H1d5VSKemO2Pmh4Gs1Ge1U5NN8slPE0w
5Y8IYJg3lIT4KF1pxLtncvwJfb2y1/o7L19yCodrrfQShMh3BUm/+W4WENl7Y+TS
NxP7CAgDM1+8Amrmqau3mbdCIPKMyhL+UOYOmTSlh4aQQSKn313rRlECYYX9cXdK
1pzP1hRs2IQruFxVJwt98oqV//CTAvnzMfl0b/eKXY/8ojP789e3uVNu6m37iuNv
y7SD9GCaL9QSkD9n7CHQKOcrc14nBszCk7jIEa8vurmqGvEZrEL8uuo3UbkyZ5rC
BRS1B02i6RHBrZ7AVC4fErtS8nR0lqav4AG6n2azs0eWeRA6dvIi/p6vrS/zjkEN
itII9CF3kUxuaKeT9Qi/eVCq2FyLM4ZfOhce6xSyCGQq4r3ade4bSKg2L8ktBEcl
WxOPwJFYhAbderurSJDL
=N18C
-----END PGP SIGNATURE-----

--/04w6evG8XlLl3ft--
