Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140Ab3FJTuf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 15:50:35 -0400
Received: from mail-bk0-f41.google.com ([209.85.214.41]:49118 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030Ab3FJTud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 15:50:33 -0400
Date: Mon, 10 Jun 2013 21:50:29 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Jay Agarwal <jagarwal@nvidia.com>, linux@arm.linux.org.uk,
        bhelgaas@google.com, ldewangan@nvidia.com, olof@lixom.net,
        hdoyu@nvidia.com, pgaikwad@nvidia.com, mturquette@linaro.org,
        pdeschrijver@nvidia.com, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, jtukkinen@nvidia.com, kthota@nvidia.com
Subject: Re: [PATCH V3 2/4] ARM: tegra: pcie: Add tegra3 support
Message-ID: <20130610195028.GB25859@mithrandir>
References: <1370372252-4332-1-git-send-email-jagarwal@nvidia.com>
 <1370372252-4332-2-git-send-email-jagarwal@nvidia.com>
 <51AE3D3B.6080102@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="H1spWtNR+x+ondvy"
Content-Disposition: inline
In-Reply-To: <51AE3D3B.6080102@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--H1spWtNR+x+ondvy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 04, 2013 at 01:17:15PM -0600, Stephen Warren wrote:
> On 06/04/2013 12:57 PM, Jay Agarwal wrote:
[...]
> >  struct tegra_pcie_port {
> > @@ -384,7 +408,7 @@ static int tegra_pcie_read_conf(struct pci_bus *bus=
, unsigned int devfn,
> >  		struct tegra_pcie_port *port;
> > =20
> >  		list_for_each_entry(port, &pcie->ports, list) {
> > -			if (port->index + 1 =3D=3D slot) {
> > +			if (port->index =3D=3D slot) {
>=20
> This and the equivalent change in tegra_pcie_write_conf() seem like a
> bug-fix unrelated to the addition of Tegra30 support. Hence, they should
> be a separate patch.

What exactly is this change supposed to fix? The description doesn't
provide any details about why this is required. Furthermore this was
done on purpose to model the Tegra PCIe controller according to what
typical Linux systems provide.

Device 0:00.0 is usually the root complex, and device 0:01.0, 0:02.0
etc are the root ports. The change proposed above makes 0:00.0 the
first root port, therefore breaking what systems usually expect.

Thierry

--H1spWtNR+x+ondvy
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRti4EAAoJEN0jrNd/PrOheKEP/2YMzqZVmy1qIqpFkajuHvxE
pWNb91OOFiWW73fBrRtu5krgL9u8qG+K6qta55DqgwZCCldanEq0vESaQ/U1thVk
vOtuzbV7jY1afQmdbeM/Cj5/+BdZcZ4Zrpj/pD5EDz9cBaW/OW5AHitUwMQj6r7x
kHHGlT39Fg7TlU/b+CFOGqSQF0MMURPa2M0nRLvJ+pryahAg1NHrJeMvXSVwONX7
QtSEljXjp2/iOMjb+INJoQjep7lJnBSrpk82RkNhzl4oCY0iaZXUNwoYjKRd0rwH
fdVoJFaWtWAnfRdMcRl3Lkt06O1rIC4qOi5M17LXYrp1Y5RIskGb6RbmvxbPUTg5
QFPjh4wltNyva6swErkMWYXmUw/GcSnjUktJLR6SYEH7tGAzxArkJWdp3c+T7vsE
QhFgphWA160/6anrLSrSQqrFIE/JLxxd760kf6QF4DMXTeuulwXgda++y3KPJkVm
3arbv0ZknrRqNLrhpKG1EdUoPpWMGUUFkxwa7UrOtV6QQeNJCkLHvFdrINRKbJtk
eJY4qHnijlTbI8Xs7Hlt3SQAPkcPw4MHDh0a2+qcGas6MdO1wQzXvTtDVFNoXJUt
poos8renfcJ1hpwmmLWHnl1ehO5yD/lexhrqMErdxP0BDThUzPiXxx7Dl9npvad2
IZz8+5uClV99qR/Z92Fq
=A5ws
-----END PGP SIGNATURE-----

--H1spWtNR+x+ondvy--
