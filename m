Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181AbaIBOgT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 10:36:19 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:38802 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753898AbaIBOgQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 10:36:16 -0400
Date: Tue, 2 Sep 2014 09:35:39 -0500
From: Felipe Balbi <balbi@ti.com>
To: Vivek Gautam <gautam.vivek@samsung.com>
CC: Mark Rutland <mark.rutland@arm.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "balbi@ti.com" <balbi@ti.com>, "kishon@ti.com" <kishon@ti.com>,
        "kgene.kim@samsung.com" <kgene.kim@samsung.com>
Subject: Re: [PATCH 1/5] usb: dwc3: exynos: Add support for SCLK present on
 Exynos7
Message-ID: <20140902143539.GC16872@saruman.home>
Reply-To: <balbi@ti.com>
References: <1409212920-28526-1-git-send-email-gautam.vivek@samsung.com>
 <1409212920-28526-2-git-send-email-gautam.vivek@samsung.com>
 <20140828184847.GA18464@leverpostej>
 <CAFp+6iHLSaUjHqaKXXX0QLiRd3h+O67DRSQdExag-KUH0dnpag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="32u276st3Jlj2kUU"
Content-Disposition: inline
In-Reply-To: <CAFp+6iHLSaUjHqaKXXX0QLiRd3h+O67DRSQdExag-KUH0dnpag@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--32u276st3Jlj2kUU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 02, 2014 at 04:09:08PM +0530, Vivek Gautam wrote:
> Hi,
>=20
>=20
> On Fri, Aug 29, 2014 at 12:18 AM, Mark Rutland <mark.rutland@arm.com> wro=
te:
> > On Thu, Aug 28, 2014 at 09:01:56AM +0100, Vivek Gautam wrote:
> >> Exynos7 also has a separate special gate clock going to the IP
> >> apart from the usual AHB clock. So add support for the same.
> >>
> >> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> >> ---
> >>  drivers/usb/dwc3/dwc3-exynos.c |   16 ++++++++++++++++
> >>  1 file changed, 16 insertions(+)
> >>
> >> diff --git a/drivers/usb/dwc3/dwc3-exynos.c b/drivers/usb/dwc3/dwc3-ex=
ynos.c
> >> index f9fb8ad..bab6395 100644
> >> --- a/drivers/usb/dwc3/dwc3-exynos.c
> >> +++ b/drivers/usb/dwc3/dwc3-exynos.c
> >> @@ -35,6 +35,7 @@ struct dwc3_exynos {
> >>       struct device           *dev;
> >>
> >>       struct clk              *clk;
> >> +     struct clk              *sclk;
> >>       struct regulator        *vdd33;
> >>       struct regulator        *vdd10;
> >>  };
> >> @@ -141,10 +142,17 @@ static int dwc3_exynos_probe(struct platform_dev=
ice *pdev)
> >>               return -EINVAL;
> >>       }
> >>
> >> +     /* Exynos7 has a special gate clock going to this IP */
> >> +     exynos->sclk =3D devm_clk_get(dev, "usbdrd30_sclk");
> >> +     if (IS_ERR(exynos->sclk))
> >> +             dev_warn(dev, "couldn't get sclk\n");
> >
> > Doesn't this introduce a pointless warning for Exynos SoCs other than
> > Exynos7?
>=20
> True, it will introduce an unnecessary warning for non-Exynos7 systems.
> I initially thought of introducing a compatible check for Exynos7-dwc3, b=
ut that
> way we may end up adding such checks for future SoCs which have similar
> controller but have some clock difference or some other small change, no ?

maybe dev_dbg() is what you want ? :-)

--=20
balbi

--32u276st3Jlj2kUU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUBdW7AAoJEIaOsuA1yqRER9MP/Rfxiw14D8S0v1u0+6i+UUp0
EHmL8AcwmVDX+BVPIr9sE9NsA+odnmE3YlZ8Bt599lEcqj/CZVMe0A2pWrWY/c7D
R2iUgZsXj0GIuptziznCEqDV9uzkdHK7sAqbExk2TSBGhq2CIC8O25jneRr7cblr
dHkTh/i/6hr0+2wY7RHWR4K7OUAlDF0CCcsRbAvibWd07r6E8sIkS9+5rTFtCALJ
tQF45y5RdRYBdt+kxelpVwCbO4Rp1Dr6Wbz2aJLHCs4Ea1HZKWaTIYe2JP77gUb1
WYzL6qfIHTeHvrXO58HsVA1tUrCE2BqmxW/Q4f4E0wltcGHWl82KxPeEULHYBiuM
1bvyrx5jT7qeul4Aqz2Ojm6D9rZpkr2rhZFjnAK94ivbQMsmgqlsXBZqzLiDakZg
rkExqDVqddKucfrrJpPj0vgo3/1FQFR1fvvyGUntEj0UcnhkFpFprz8nu6vPUGoZ
r0cFdPS4v9QqSJxGi/G2zdAOBma6ZWFvN7I3tmh8IKfHvS+W3F/M/qQpmgG6VllP
1KYfboLLwwZIRS9Wk72n77CWYaZTUgXMI7lhZKroeFrzkBwixjTZsHuyUrdZdSf2
UbRWpXbRg8mPi9mS5UId580ljB01qw3yCpoc0bdmhlKosomDVH8ZB9r0GPw+K9QF
lEjoMXx/Z3dYwAKXmCIf
=klBf
-----END PGP SIGNATURE-----

--32u276st3Jlj2kUU--
