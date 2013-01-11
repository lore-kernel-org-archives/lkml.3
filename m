Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394Ab3AKSso (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 13:48:44 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:58405 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755136Ab3AKSsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 13:48:42 -0500
Date: Fri, 11 Jan 2013 19:48:19 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-tegra@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 14/14] ARM: tegra: trimslice: Initialize PCIe from DT
Message-ID: <20130111184819.GA18717@avionic-0098.adnet.avionic-design.de>
References: <1357764194-12677-1-git-send-email-thierry.reding@avionic-design.de>
 <1357764194-12677-15-git-send-email-thierry.reding@avionic-design.de>
 <50EF5537.6080602@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Dxnq1zWXvFF0Q93v"
Content-Disposition: inline
In-Reply-To: <50EF5537.6080602@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:yVo++4m+OTlWiEMnc/rAWGysNJ3zWOmIsGTIUo8ZWan
 QTS6EqalJnnDbUO/D4u08YQIpPnKwFKmSO1vpd9tv4jp1I434V
 7AIoxrnmj8zZnl+eeLi+YNPU2HZTSFg++RYfw380gD3/+ggudj
 u+XZufvKCD0avgnSq5kT/RPqWvAb1lZzjB/ANqdZZetk/3r3gk
 Guhx88Ym5ez0RAxrFN/VBMCTTRdtNzs+C68+7cOU+PoycK5dHM
 PuEy6Fz2O98uGSgePIsOdLQNJA7AJuYGX0CTX8/Oh194yNxjhx
 otcGPeutRLY9z71Eg7Fzgj05FxKKyfkOq6+tsSEkUF6+ov62Gh
 CcuUeOZzvXeazEC/BAc6m/R/vaqZ6ix/Muu7S60u9vmA5Tnf38
 Yg/eUdsqvUyW+ESH+ow0qfPBk9c3vmwmjw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Dxnq1zWXvFF0Q93v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 10, 2013 at 04:56:39PM -0700, Stephen Warren wrote:
> On 01/09/2013 01:43 PM, Thierry Reding wrote:
> > With the device tree support in place, probe the PCIe controller from
> > the device tree and remove the corresponding workaround in the board
> > file.
>=20
> Thierry, there are a couple things missing from this patch; I include a
> fixup for you to squash in, but also see beyond that for a problem.
>=20
> >  arch/arm/boot/dts/tegra20-trimslice.dts |   26 +++++++++++++++++++++--=
---
> >  1 file changed, 21 insertions(+), 5 deletions(-)
> >=20
> > diff --git a/arch/arm/boot/dts/tegra20-trimslice.dts b/arch/arm/boot/dt=
s/tegra20-trimslice.dts
> > index ebb4c17..41fc45b 100644
> > --- a/arch/arm/boot/dts/tegra20-trimslice.dts
> > +++ b/arch/arm/boot/dts/tegra20-trimslice.dts
> > @@ -303,12 +303,10 @@
> > =20
> >  	pcie-controller {
> >  		status =3D "okay";
> > +		pex-clk-supply =3D <&pci_clk_reg>;
> > +		vdd-supply =3D <&pci_vdd_reg>;
> > =20
> > -		pci@0 {
> > -			status =3D "okay";
> > -		};
> > -
> > -		pci@1 {
> > +		pci@1,0 {
> >  			status =3D "okay";
> >  		};
> >  	};
> > @@ -366,6 +364,24 @@
> >  			regulator-max-microvolt =3D <1800000>;
> >  			regulator-always-on;
> >  		};
> > +
> > +		pci_clk_reg: regulator@2 {
> > +			compatible =3D "regulator-fixed";
> > +			reg =3D <2>;
> > +			regulator-name =3D "pci_clk";
> > +			regulator-min-microvolt =3D <3300000>;
> > +			regulator-max-microvolt =3D <3300000>;
> > +			regulator-always-on;
> > +		};
> > +
> > +		pci_vdd_reg: regulator@3 {
> > +			compatible =3D "regulator-fixed";
> > +			reg =3D <3>;
> > +			regulator-name =3D "pci_vdd";
> > +			regulator-min-microvolt =3D <1050000>;
> > +			regulator-max-microvolt =3D <1050000>;
> > +			regulator-always-on;
> > +		};
> >  	};
> > =20
> >  	sound {
> > --=20
> > 1.7.10.4
>=20
> However, PCIe still doesn't work on TrimSlice; the device enumeration
> fails. The log is below:
>=20
> > [    0.790425] tegra-pcie 80003000.pcie-controller: link 0 down, retryi=
ng
> > [    0.801351] tegra-pcie 80003000.pcie-controller: PCI host bridge to =
bus 0000:00
> > [    0.808945] pci_bus 0000:00: root bus resource [io  0x82000000-0x820=
0ffff]
> > [    0.816109] pci_bus 0000:00: root bus resource [mem 0xa0000000-0xaff=
fffff]
> > [    0.823303] pci_bus 0000:00: root bus resource [mem 0xb0000000-0xbff=
fffff pref]
> > [    0.830893] pci_bus 0000:00: root bus resource [bus 00-ff]
> > [    0.836728] pci 0000:00:01.0: [10de:0bf0] type 01 class 0x060000
> > [    0.843097] pci 0000:00:01.0: PME# supported from D0 D1 D2 D3hot D3c=
old
> > [    0.850047] PCI: bus0: Fast back to back transfers disabled
> > [    0.855853] pci 0000:00:01.0: bridge configuration invalid ([bus 00-=
00]), reconfiguring
> > [    0.864308] tegra-pcie 80003000.pcie-controller: AXI response decodi=
ng error, signature: 10010001
> > [    0.873489] tegra-pcie 80003000.pcie-controller:   FPCI address: fe1=
0010000
>=20
> ^^^ For some reason, the config register access fails.
>=20
> > [    0.880760] PCI: bus1: Fast back to back transfers enabled
> > [    0.886482] pci_bus 0000:01: busn_res: [bus 01-ff] end is updated to=
 01
> > [    0.893381] pci 0000:00:01.0: PCI bridge to [bus 01]
> > [    0.898577] PCI: enabling device 0000:00:01.0 (0140 -> 0143)
> > [    0.904535] pci 0000:00:01.0: nv_msi_ht_cap_quirk didn't locate host=
 bridge
>=20
> With plain next-20130109, the device enumeration succeeds.

That's very strange. I haven't seen that on my setup. Looks like I need
to dig out the TrimSlice again and debug this. It'll take me a while and
there are plenty of other requested changes already, so if I find a fix
I can roll it into the next version.

Thanks for testing,
Thierry

--Dxnq1zWXvFF0Q93v
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQ8F5zAAoJEN0jrNd/PrOhEMoP/2BFh+/9wwBhVAuVQ1RQXZ7Q
pvWFIhuJ9EdZwPXGVHU8559hT0MV0e6MS61sQQ0YQzxHxTe4Taip8AeUWayget6L
BKnO3/gc9P7zikFb0pr9p3u5pRUlLiG77XfQtas98X3YSFp4Ba6me0oA1Lw+9tr1
os14griipvxRzLlTJKUYHyg13rZXyhrIETLns/sWguQeucb1InUKA/bkDm+3PnEM
rjDk1W1ZRiM1e2dQsV8O8gpzIsELe6Zz7zYwM5UVtBHvT+NyNGqWFNzLWO6bqoZV
uQ5pS5sYynry+Il+J+xkMVpivSR7627zNDAqgClHFBw9mhcG+XntzBjSVAgEIiLX
qrKyik1skdDHW16HtEeanJ8lgfSB60Zc41D5PFsUVz4/xqIaHFZLqNlzz5bZRuXg
nZXnOvcWmgBw6D8zxz+h+oev/Hzh/V3Y97w8g96Exy5DQFfwdEY4HtOJwilcJ67v
hF6bEaKSvvvDT81qPmCx4uGi1jUyLLp4b8YFZQ0Fc/YO9XkcCqoCdFwBJ68ZGdGL
zEZ5Y72/W6j5cGDZKceAPO1Mx1DkY4ENNJwK7y5jwQTXD0pwbz0IU5vE0xO/Er8X
i9GO2oMug+IPkTr1+nMUEVJ3i16AgmTL28tMJsOiU7XTG5HJNicN/Ep9iCsKTd5z
4NV/7TZ0frYQq/Rt7ZRY
=8nAN
-----END PGP SIGNATURE-----

--Dxnq1zWXvFF0Q93v--
