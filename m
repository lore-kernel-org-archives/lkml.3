Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752928Ab3DMKXe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Apr 2013 06:23:34 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:62557 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354Ab3DMKXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Apr 2013 06:23:32 -0400
Date: Sat, 13 Apr 2013 12:23:19 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Jay Agarwal <jagarwal@nvidia.com>, Prashant Gaikwad <pgaikwad@nvidia.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        Krishna Thota <kthota@nvidia.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "olof@lixom.net" <olof@lixom.net>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "mturquette@linaro.org" <mturquette@linaro.org>,
        Juha Tukkinen <jtukkinen@nvidia.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Hiroshi Doyu <hdoyu@nvidia.com>
Subject: Re: [PATCH 1/3] ARM: tegra: pcie: Add tegra3 support
Message-ID: <20130413102319.GA30758@avionic-0098.mockup.avionic-design.de>
References: <1365435688-4179-1-git-send-email-jagarwal@nvidia.com>
 <51630852.1000107@wwwdotorg.org>
 <C79B248886DD134989C8FF6B096A91AB91B36FB2FD@BGMAIL01.nvidia.com>
 <51682975.1080302@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fUYQa+Pmc3FrFX/N"
Content-Disposition: inline
In-Reply-To: <51682975.1080302@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:eVZ55WhWVA9vBNaMKXwzLAj7HiIlChruRely5gnXCIU
 5ORWZa7t0sW1Ia+eqHADL6V//UeDvt5LdTRszD2plOoiXXAJaw
 1JxD8q5QrA8oJx4E9OmEMEbuhpHt8BingkHUPfQ39MLgY9g4lT
 7Ta+8X50lar/pFW4EqRBf1v7sqr3b/tqZekFJ2yCOdXJrlAdPr
 qW1jvTA15a3/Hx5N+FClZUVN/yIPZjwF4WtcUqZsGFbaDyMG15
 j83qIsGL5sjj8mv+OPoNJ/iLt8YmrbmawWrvtHoytBi5XmhOor
 SinkWJcCbC9uxFThXmO098RQcHgWBP2jg3kJqdDVRtkT5NGYU6
 yWggUry1Ytcvhv9P5fbTy0CIF0/q0XC+97vCDzK8iSSW2QKNE5
 JwIZtTUUCcv1UTKp0npxNqnEDatEf9/LDY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fUYQa+Pmc3FrFX/N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 12, 2013 at 09:34:13AM -0600, Stephen Warren wrote:
> On 04/12/2013 08:58 AM, Jay Agarwal wrote:
> >>>  	err =3D regulator_disable(pcie->pex_clk_supply);
> >>>  	if (err < 0)
> >>> -		dev_err(pcie->dev, "failed to disable pex-clk regulator:
> >> %d\n",
> >>> +		dev_warn(pcie->dev, "failed to disable pex-clk regulator:
> >> %d\n",
> >>>  			err);
> >>>
> >>>  	err =3D regulator_disable(pcie->vdd_supply);
> >>>  	if (err < 0)
> >>> -		dev_err(pcie->dev, "failed to disable VDD regulator: %d\n",
> >>> +		dev_warn(pcie->dev, "failed to disable VDD regulator:
> >> %d\n",
> >>>  			err);
> >>
> >> Please explain why that change is correct. If the regulators only exis=
t on
> >> Tegra20, please represent that fact in the SoC data. Regulators must a=
lways
> >> exist, so enable/disable should never fail due to missing regulators. =
Actual
> >> run-time failures seem like something that really is an error.
> >>
> > [>] These regulators are needed for both tegra20 & tegra30. Since we ar=
e not returning error here, so changed to dev_warn.
>=20
> If the regulators are required, then any failure to operate them should
> be an error, hence dev_err() seems correct.
>=20
> As to why the code doesn't actually return an error? I'm not sure.
> Perhaps that should be fixed with a separate patch, although I don't
> recall exactly where in the code the above excerpt is; if it's in
> remove(), then continuing on without returning an error would be
> appropriate.

That code is from tegra_pcie_power_off(), which is called only during
error cleanup or from tegra_pcie_put_resources() which in turn is also
only called in cleanup paths or during module/device removal. Disabling
as many regulators as possible is still what we want in that case, so
returning an error prematurely might leave more regulators turned on
than necessary.

Thierry

--fUYQa+Pmc3FrFX/N
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRaTIXAAoJEN0jrNd/PrOhIKcP/1dW4nFdFzAQqxKDGXy3ig+W
ZWCpjQ/K6k8pw6DDoWdTTOfnP+VF/1WWzyPDSeUzbCmZgUxCBKKeANh6yxqtL3TV
EWQi/rLBMhMLgBdo2VSg2AqVIE3mhP7XdJ2UZMt15qxkER46t+GvQr9pW0OeCxsp
4nQPwX1WlsCAjov7/ZZiIxwBEjH65Mb2GweME/MU9jMBN7AmsyKgx8+l7QZuyj5B
ps4RkbSJ9YjNLiHgGmu/ivZaDowsplWuI0vb5FnaAxMVS1dqW5yqv+W5D+Z4zSd7
O3DspYgHkqAP3WQiFiams+NWlBCyKkKLjLnriQ0s7x0/mRQABJF+WPtB6af5PDC/
njR1gi96tgDigQQZZxPtuMlFFr8Vkp3H99ZsX+EIVKl/i0NpNAYc6h1LxbNITnES
5g2z4WhgPDeVwiv7PnS6d5WtwIsEeRYQK0WT04cf7jffvLgeUi7FVTgP0bkrd1BP
d0m0TSsmO7sI4qzeELaO0wrdwXYg6TV6NB0pf3RDm3dApH/n4Ope02iWE16rP1Dz
7ZdJvmT5Sg4raoCZab9gm7N5KWnue9Tm3f2tgB6bLbDRis1q1dkHMmFXUDy99FKS
ugr7mzsTD0W6bI9VZhjrVyT8wRw1LHp9oi6ahmSMMzD9Z5HpisK3Ft409JktZtV6
X70BkMHKl9nPEl7DRoiG
=yLzJ
-----END PGP SIGNATURE-----

--fUYQa+Pmc3FrFX/N--
