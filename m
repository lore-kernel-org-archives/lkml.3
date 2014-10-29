Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933357AbaJ2OtS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 10:49:18 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:49338 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933055AbaJ2OtQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 10:49:16 -0400
Date: Wed, 29 Oct 2014 09:48:44 -0500
From: Felipe Balbi <balbi@ti.com>
To: Huang Rui <ray.huang@amd.com>
CC: Felipe Balbi <balbi@ti.com>, Alan Stern <stern@rowland.harvard.edu>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Zimmerman <Paul.Zimmerman@synopsys.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Jason Chang <jason.chang@amd.com>, Vincent Wan <vincent.wan@amd.com>,
        Tony Li <tony.li@amd.com>, <linux-usb@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 19/19] usb: dwc3: add support for AMD NL platform
Message-ID: <20141029144844.GK11572@saruman>
Reply-To: <balbi@ti.com>
References: <1414497280-3126-1-git-send-email-ray.huang@amd.com>
 <1414497280-3126-20-git-send-email-ray.huang@amd.com>
 <20141028133856.GB8123@saruman>
 <20141028143536.GA4519@hr-slim.amd.com>
 <20141029091342.GC10840@hr-slim.amd.com>
 <20141029141146.GF11572@saruman>
 <20141029143319.GD10840@hr-slim.amd.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DfnuYBTqzt7sVGu3"
Content-Disposition: inline
In-Reply-To: <20141029143319.GD10840@hr-slim.amd.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--DfnuYBTqzt7sVGu3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 29, 2014 at 10:33:19PM +0800, Huang Rui wrote:
> On Wed, Oct 29, 2014 at 09:11:46AM -0500, Felipe Balbi wrote:
> > On Wed, Oct 29, 2014 at 05:13:43PM +0800, Huang Rui wrote:
> > > Hi Felipe, Paul,
> > >=20
> > > On Tue, Oct 28, 2014 at 10:35:37PM +0800, Huang Rui wrote:
> > > > On Tue, Oct 28, 2014 at 08:38:56AM -0500, Felipe Balbi wrote:
> > >=20
> > > <snip>
> > >=20
> > > > >=20
> > > > > however, as I mentioned before, the core shouldn't have to know t=
hat
> > > > > it's running on an AMD platform. We already support several diffe=
rent
> > > > > platforms (OMAP5, AM437x, DRA7xx, Exynos5, Exynos7, Qcom, Merrifi=
eld,
> > > > > Baytrail, Braswell, HAPS PCIe, and STiH407) and none of them get =
their
> > > > > $my_awesome_platform flag in dwc3, why should AMD be any differen=
t ?
> > > > >=20
> > > > > This is the only part of $subject that I cannot accept because it=
 would
> > > > > mean we would be giving AMD a special treatment when there should=
n't be
> > > > > any, for anybody.
> > > > >=20
> > > >=20
> > > > That's because I used this flag to enable below quirks on AMD NL FP=
GA
> > > > board, and FPGA flag only can be detected on core. Can I set
> > > > disable_scramble_quirk, dis_u3_susphy_quirk, and dis_u2_susphy_quirk
> > > > for all the FPGA platforms?
> > > >=20
> > > > if (dwc->amd_nl_plat && dwc->is_fpga) {
> > > >         dwc->disable_scramble_quirk =3D true;
> > > >         dwc->dis_u3_susphy_quirk =3D true;
> > > >         dwc->dis_u2_susphy_quirk =3D true;
> > > > }
> > > >=20
> > >=20
> > > I confirmed with HW designer, these three quirks only will be needed
> > > on FPGA board. And these should *not* be used on non-FPGA board, as y=
ou
> > > known.
> > >=20
> > > So I would like to use below conditions on dwc3 core. When I set these
> > > quirk flags in pci glue layer, then core can filter them by is_fpga
> > > flag to support both on FPGA and SoC. Is there any concern? If that, I
> > > should remove WARN_ONCE at disable_scramble flag.
> > >=20
> > > if (dwc->disable_scramble_quirk && dwc->is_fpga) {..}
> > >=20
> > > if (dwc->dis_u2_susphy_quirk && dwc->is_fpga) {..}
> > >=20
> > > if (dwc->dis_u3_susphy_quirk && dwc->is_fpga) {..}
> >=20
> > the problem is that somebody might need this on non-FPGA. Currently,
> > only AMD needs these and only on FPGA, but you never know.
> >=20
> > I guess we can add it like this for now and once we have a real AMD
> > product, we drop FPGA support from AMD.
> >=20
>=20
> OK, agree.
>=20
> Then I comments below WARN_ONCE, OK?
>=20
> /* FIXME it should be used after AMD NL product taps out */
> #if 0
> WARN_ONCE(dwc->disable_scramble_quirk && !dwc->is_fpga,
> "disable_scramble cannot be used on non-FPGA builds\n");
> #endif

just remove it, we don't like commented out code.

--=20
balbi

--DfnuYBTqzt7sVGu3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUUP5MAAoJEIaOsuA1yqREOzwP/RTOSU69MaEoRcF3nrcKilHh
QRGyXMeXikHce1eq7l8++PUxTnZgk7g5CAD0QOXsxVhj44QN6o/avDfiVbPhP+HG
iUCvuzdDKpS1fGYrHyyke70fLAs/9PBKf4V1LHeMVv6j+pMaOFzC+g4f24tCm8SY
gwdf3hPrJ4PIiVM8F/dPxZFKYEbExrwvhvBqqDAZr+jK0X8toJ8KCW6Ctp7vmb55
A/eFKNVaI0tenDAStZ9BjQ3yvriYy4uzr4nm2x4BbPgIPe9ZF4Z2hAoHAqQQIO/d
EiLFqsyQQ6Yxv2BVLwICzAvc4DSY1ti0QMKa6Y9cfGmPBBc6+9wxC7hgvc057sph
95YHnDtbwwOR6JUHkw6CvVNAdhFDOUqsWG2O4edxamkYqA7kveycet0c+0ggupL0
vNrz3rHKo/eL/+nqDSKJtBjnBCt3WPSZfRKX1/Tt1Q97OKMOb/h9jJvQ6fOdfQgw
AbdUbD7tIoe9Y/40HmSeJTCO3CB4S0K6zkHuaVgwIYevoUc/tKSAnBGm31jmP6x1
VWaRmGX12YxC1IT5N4gxxK38hqGh8rt97ctOz/+qKvggS2D665NqxLlpfkrIDDJE
cVkv773DBEiPRc1FXUSQyp3AAxpns6SfFJ0XZ6IaGgvxTv57BxOlph2N90oBrbK2
1SP57MyUMRA7o2CHqOxi
=WFiM
-----END PGP SIGNATURE-----

--DfnuYBTqzt7sVGu3--
