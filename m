Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647AbaJHHpJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 03:45:09 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:57714 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753326AbaJHHpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 03:45:07 -0400
Date: Wed, 8 Oct 2014 09:45:03 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Vidya Sagar <vidyas@nvidia.com>, bhelgaas@google.com, kthota@nvidia.com,
        linux-tegra@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] PCI: tegra: Enable root port specific features
Message-ID: <20141008074502.GD4999@ulmo>
References: <1412677678-12011-1-git-send-email-vidyas@nvidia.com>
 <54340A45.4050005@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9UV9rz0O2dU/yYYn"
Content-Disposition: inline
In-Reply-To: <54340A45.4050005@wwwdotorg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9UV9rz0O2dU/yYYn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 07, 2014 at 08:44:05AM -0700, Stephen Warren wrote:
> On 10/07/2014 03:27 AM, Vidya Sagar wrote:
> > Enables root port to advertise its ASPM-L1 capability
> >  resulting in possible link entry to L1 when an ASPM-L1 capable
> >  device is connected
> > Enables per-controller & per-TMS clock clamping by default
> > Enabling above features result in more power saving
> >=20
> > It also avoids PM message truncation by waiting for DLLP to finish
> > before entering into L1 or L2
> >=20
> > Also, it adds helper functions to access root port registers
>=20
> > diff --git a/drivers/pci/host/pci-tegra.c b/drivers/pci/host/pci-tegra.c
>=20
> > @@ -1870,8 +1920,10 @@ static int tegra_pcie_enable(struct tegra_pcie *=
pcie)
> > =20
> >  		tegra_pcie_port_enable(port);
> > =20
> > -		if (tegra_pcie_port_check_link(port))
> > +		if (tegra_pcie_port_check_link(port)) {
> > +			tegra_pcie_enable_rp_features(port);
> >  			continue;
> > +		}
> > =20
> >  		dev_info(pcie->dev, "link %u down, ignoring\n", port->index);
>=20
> Wouldn't it be better to have the error case inside the if block; most
> error-handling is that way. For example:
>=20
> if (!tegra_pcie_port_check_link(port)) {
> 	dev_info(pcie->dev, "link %u down, ignoring\n", port->index);
> 	tegra_pcie_port_disable(port);
> 	tegra_pcie_port_free(port);
> 	continue;
> }
>=20
> tegra_pcie_enable_rp_features(port);
> ... any other "good case" code (of which there admittedly is none at
> present)

Yes, that's a little more idiomatic. I think it could be a separate
cleanup patch, though.

Thierry

--9UV9rz0O2dU/yYYn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUNOt+AAoJEN0jrNd/PrOhmewP/RBXhTBw5sHJGT30binD1OK+
wLbDQhnNCVoPw2WF20+ceD4Iy4hBghkjA2C2hpDxTUs4nMVqI7zvjDg9ZE3adSYH
kNoKma7hZIJNkCwtwtb/aRqSKmdff3kMFmXUMv2e1KoM3uQMvYSAwiDXfS/P+jZg
dhQCnIcWcOom5VOXmO4xn7IW1m1QQyClJH8U72S45SOYB/Yo1POlbX4jQnQu6CKY
j+Unk2hxQ3H8Slrz7ObRNOWa4UioaJHrXa2h10yqlTQiwWvfFZjC7jtN9CY+5Hla
NlTFQP96Ujta3lykL4j4oKsIRv9jXknvNwTN3rjf2riP322PR0d4Iz20k3ksSA/L
DrHi/vFRLgsxi7j1mQPr/BQQmAJw+SETZXasDl6zFv0im27eHr69Rcg/N1NjzMR/
XC50Xlx6rNAaEITKMB2Snk5rJw+yh7iaK8qZqwes/Cytz9ozfKsuCKB8GcrXH/uu
c1DxABnaGgkKHfKzUWw+8vTq8OYY1cG76s/2Jn9u3ME9fFGhMqUvyiex1DOPwXVM
dnKkgBAtIDkEsbRdLI9/Jd7tmw0HnPPwY/kmbKnxp+qBUPcsPJZuoPVhZ03N2jO4
XG4B4E+MuU8vPXvuddex3IILrb62Qxv/tjDFOcMp1kSjA/hZ76QmHob+23aylQbm
k6JjuNXwePm1ArA2mKCj
=l9qc
-----END PGP SIGNATURE-----

--9UV9rz0O2dU/yYYn--
