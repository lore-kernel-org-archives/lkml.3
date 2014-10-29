Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933965AbaJ2OMX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 10:12:23 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:47276 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932555AbaJ2OMU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 10:12:20 -0400
Date: Wed, 29 Oct 2014 09:11:46 -0500
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
Message-ID: <20141029141146.GF11572@saruman>
Reply-To: <balbi@ti.com>
References: <1414497280-3126-1-git-send-email-ray.huang@amd.com>
 <1414497280-3126-20-git-send-email-ray.huang@amd.com>
 <20141028133856.GB8123@saruman>
 <20141028143536.GA4519@hr-slim.amd.com>
 <20141029091342.GC10840@hr-slim.amd.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="twz1s1Hj1O0rHoT0"
Content-Disposition: inline
In-Reply-To: <20141029091342.GC10840@hr-slim.amd.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--twz1s1Hj1O0rHoT0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 29, 2014 at 05:13:43PM +0800, Huang Rui wrote:
> Hi Felipe, Paul,
>=20
> On Tue, Oct 28, 2014 at 10:35:37PM +0800, Huang Rui wrote:
> > On Tue, Oct 28, 2014 at 08:38:56AM -0500, Felipe Balbi wrote:
>=20
> <snip>
>=20
> > >=20
> > > however, as I mentioned before, the core shouldn't have to know that
> > > it's running on an AMD platform. We already support several different
> > > platforms (OMAP5, AM437x, DRA7xx, Exynos5, Exynos7, Qcom, Merrifield,
> > > Baytrail, Braswell, HAPS PCIe, and STiH407) and none of them get their
> > > $my_awesome_platform flag in dwc3, why should AMD be any different ?
> > >=20
> > > This is the only part of $subject that I cannot accept because it wou=
ld
> > > mean we would be giving AMD a special treatment when there shouldn't =
be
> > > any, for anybody.
> > >=20
> >=20
> > That's because I used this flag to enable below quirks on AMD NL FPGA
> > board, and FPGA flag only can be detected on core. Can I set
> > disable_scramble_quirk, dis_u3_susphy_quirk, and dis_u2_susphy_quirk
> > for all the FPGA platforms?
> >=20
> > if (dwc->amd_nl_plat && dwc->is_fpga) {
> >         dwc->disable_scramble_quirk =3D true;
> >         dwc->dis_u3_susphy_quirk =3D true;
> >         dwc->dis_u2_susphy_quirk =3D true;
> > }
> >=20
>=20
> I confirmed with HW designer, these three quirks only will be needed
> on FPGA board. And these should *not* be used on non-FPGA board, as you
> known.
>=20
> So I would like to use below conditions on dwc3 core. When I set these
> quirk flags in pci glue layer, then core can filter them by is_fpga
> flag to support both on FPGA and SoC. Is there any concern? If that, I
> should remove WARN_ONCE at disable_scramble flag.
>=20
> if (dwc->disable_scramble_quirk && dwc->is_fpga) {..}
>=20
> if (dwc->dis_u2_susphy_quirk && dwc->is_fpga) {..}
>=20
> if (dwc->dis_u3_susphy_quirk && dwc->is_fpga) {..}

the problem is that somebody might need this on non-FPGA. Currently,
only AMD needs these and only on FPGA, but you never know.

I guess we can add it like this for now and once we have a real AMD
product, we drop FPGA support from AMD.

cheers

--=20
balbi

--twz1s1Hj1O0rHoT0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUUPWiAAoJEIaOsuA1yqREQTgQAKy7FvVXwO1O3wKAm18qq3WF
uIGcusiKZP92MHw2nmUv88T7bdadeThhkUzCA4Uryk4IvAQeYruLpSJRTM2gXKgN
HmRJO17YL4uowWTXrRNYEWuPv7zgWAsFFztKwn1TGoQTimDiILGbc0JiadDP7VmH
M0mXBVSYUInSRiIb0iEGp9F1QO/E8Yvw45F04b8WNeY28lTnhiSUJ9GGMDcFxOIo
DURVvy38GcJq4hf3/P7ziNSWid3DJX/2ey662jW6XG+sjcpdpDwRdfr+BYKEWiP8
/B3A8vzjCVeE1vWd9b22iFmM4ovB0B8thhuzAkm2dc6SzeURcejmsu/DNG68YqNp
GCzqcecQb7DkX7ZAcxToi/MCsJx/Vg5pJPzAEZy3kXtzrG6mV5PN0MJyA2HEzLZ+
6EfLvxWAGLtkLFMASxPMUp3AO+X0WLJl+RwCHbuEKfapkik31dx5jLfE7HNNI7BA
Ef/29nlSsY4wVHS4Jj8YkJpXyfF9VU52L0vhJAlPQ8ry+aeUkwNQCL7ta/e0jnYS
VIz0ZN12VfHwd3hRUdCgvbb2WHSGS8qRo7oOg0xzTusVFAuKVPDNwRqcWDwg7eTG
p+Fhez4a/chlCOVK0GgreH2Rrj21fUce/eHegAN7AiIE/7iYoEcUYkHV7DugIkcF
AH1yvGrjYsytwmlSNBfM
=Mh5b
-----END PGP SIGNATURE-----

--twz1s1Hj1O0rHoT0--
