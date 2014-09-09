Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756736AbaIIOnY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 10:43:24 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:56663 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751495AbaIIOnW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 10:43:22 -0400
Date: Tue, 9 Sep 2014 09:42:25 -0500
From: Felipe Balbi <balbi@ti.com>
To: Vivek Gautam <gautam.vivek@samsung.com>
CC: Felipe Balbi <balbi@ti.com>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>, kishon <kishon@ti.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Jingoo Han <jg1.han@samsung.com>
Subject: Re: [PATCH v6 4/4] phy: exynos5-usbdrd: Calibrate LOS levels for
 exynos5420/5800
Message-ID: <20140909144225.GF6151@saruman.home>
Reply-To: <balbi@ti.com>
References: <1409656338-20337-1-git-send-email-gautam.vivek@samsung.com>
 <1409656338-20337-5-git-send-email-gautam.vivek@samsung.com>
 <20140902143438.GB16872@saruman.home>
 <CAFp+6iEyqmbwMLFrBKD7NVLDAC=b+h1hPKFS=BG4k9D69hn_dg@mail.gmail.com>
 <20140903144225.GD31855@saruman.home>
 <CAFp+6iETPJCWMMkjHrpDcdCv=K0PbefYLa4eBOwN=aUY2=EHLA@mail.gmail.com>
 <20140905175651.GK24449@saruman.home>
 <CAFp+6iGU86yL8Ry3ArJJjBy2Cs0Em2B49yssH3BK5fJwyaZbtA@mail.gmail.com>
 <20140908134454.GK22409@saruman.home>
 <CAFp+6iG+gmD_JseytYuVQcRK9ErOqQrUEWJoU1KUU7PqMd=aRw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DO5DiztRLs659m5i"
Content-Disposition: inline
In-Reply-To: <CAFp+6iG+gmD_JseytYuVQcRK9ErOqQrUEWJoU1KUU7PqMd=aRw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--DO5DiztRLs659m5i
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 09, 2014 at 07:19:50AM +0530, Vivek Gautam wrote:
> Hi,
>=20
>=20
> On Mon, Sep 8, 2014 at 7:14 PM, Felipe Balbi <balbi@ti.com> wrote:
> > Hi,
> >
> > On Mon, Sep 08, 2014 at 09:53:09AM +0530, Vivek Gautam wrote:
> >> On Fri, Sep 5, 2014 at 11:26 PM, Felipe Balbi <balbi@ti.com> wrote:
> >> > On Thu, Sep 04, 2014 at 12:01:19PM +0530, Vivek Gautam wrote:
> >> >> > Don't we have phy_power_on()
> >> >> > for that ? It looks like you could just as well do this from
> >> >> > phy_power_on() ?
> >> >>
> >> >> No, unfortunately keeping these calibration settings in phy_power_o=
n()
> >> >> doesn't help, since we need to do this after XHCI reset has happene=
d.
> >> >
> >> > teach xHCI about PHYs ?
> >>
> >> sorry i couldn't understand you here.
> >> Aren't we trying to do the same with Heikki's patch about dwc3 :
> >> [PATCH 6/6] usb: dwc3: host: convey the PHYs to xhci
> >>
> >> and the 2nd patch in this series :
> >> [PATCH v6 2/4] usb: host: xhci-plat: Get PHYs for xhci's hcds
> >>
> >> Is there something else that is expected ?
> >
> > right, use that to call phy_init() at the right time, then you need to
> > add a new ->calibrate() method which, likely, will only be used by you
> > ;-)
>=20
> so you mean, the xhci should itself call phy_init() at a time suitable,
> so that ->calibrate() is not required at all ?
>=20
> i think you meant there - "then you __do not__ need to

right :-)

> > add a new ->calibrate() method which, likely,
> will only be used by you", is it ?

yup

--=20
balbi

--DO5DiztRLs659m5i
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUDxHRAAoJEIaOsuA1yqRE2wAP/R2EshzK10SMAvnGqNGl8SnA
CIFqb9R0HKjtuWOLwPlcC0gAwkObrKzv+eJaD4adnhfARwee1HN2PzZ/QNmvSU2G
FNHeOfT2WPnopmPkqAixsH1hF0llP3xhLnBOHgeHTYBQxCEi1x6eMpcp4RGGvhjI
YXM+eF+lrLE9CotyUEt2YW79tt0Vgjp/GIWoftZL5GCK4Y8QoNrsfwZEeD5Nxn9Z
xgG/z4Nw9QWR3uarUlvYw0l2sq+j4h5JGgXerNTRjOJ3Pb+iLTiEj8mT7HOKUA4+
qHq1hDog2szmYcTWaqLroFUSbURP20XQgRdD2xYjpuzjTl900uiSRVeL77fnWzO3
TNeuvCOMK+wMq1m42WnlR3ErSYCtOUJhBg5TRVLsrGI3Viadm7hmSelcKxpZaIal
EDucYL2KovBqtarq1qrmQr0MjdvaFTjIpi/zswwuvDIQdxEkiUIbyXWwgdlgC1HW
uePAtDnIKXF0oD60wxtROtP9e0BRwvD1OW/3lH+InM5rlRhikHaBhgqxx/VA/G5z
5ZsArc9fycjwl3Jnhc+0Qfb7I0PLos1zaOQeZgO9/5yGdtsuYFMlV91TUbGvbDCC
xD03xsO8TFJfqUk4bcPniRcFIvxalsrqEf8UiAYfVt50is0Gn5YSIlwrDbzvu/bt
CQaAnJV/ebQiA8odRnYJ
=5c+5
-----END PGP SIGNATURE-----

--DO5DiztRLs659m5i--
