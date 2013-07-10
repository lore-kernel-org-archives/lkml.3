Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753701Ab3GJFYJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 01:24:09 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:54720 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750924Ab3GJFYH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 01:24:07 -0400
Date: Wed, 10 Jul 2013 08:23:43 +0300
From: Felipe Balbi <balbi@ti.com>
To: George Cherian <george.cherian@ti.com>
CC: Kishon Vijay Abraham I <kishon@ti.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        <linux-usb@vger.kernel.org>, <balbi@ti.com>,
        <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <linux-omap@vger.kernel.org>
Subject: Re: [PATCH 0/5] Add phy support for AM335X platform using Generic
 PHy framework
Message-ID: <20130710052343.GA15674@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1373280201-31785-1-git-send-email-george.cherian@ti.com>
 <51DB16A1.6010006@linutronix.de>
 <51DBA23A.8000505@ti.com>
 <51DBF59F.1030109@ti.com>
 <51DCE979.8010108@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HlL+5n6rz5pIUxbD"
Content-Disposition: inline
In-Reply-To: <51DCE979.8010108@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 10, 2013 at 10:26:25AM +0530, George Cherian wrote:
> On 7/9/2013 5:05 PM, Kishon Vijay Abraham I wrote:
> >Hi,
> >
> >On Tuesday 09 July 2013 11:10 AM, George Cherian wrote:
> >>On 7/9/2013 1:14 AM, Sebastian Andrzej Siewior wrote:
> >>>On 07/08/2013 12:43 PM, George Cherian wrote:
> >>>>This patch series adds phy support for AM335X platform.
> >>>>This patch series is based on Generic PHY framework [1].
> >>>>
> >>>>
> >>>>This series has
> >>>>     - adds dual musb instances support for am335x platform (just for=
 testing)
> >>>>     - adds phy-amxxxx-usb driver used in AMxxxx platforms
> >>>>     - adds dt  bindings for the phys
> >>>>     - removes usb-phy and replaced with generic phy apis in glue lay=
er
> >>>No, I don't like this all. You did the one thing I tried to avoid while
> >>>posting my quick-and-dirty phy driver recently: You duplicated a lot of
> >>>code which can be served by the nop driver and added only power
> >>>on/power off callbacks.
> >>I wanted to add phy wakeup control also, but currently phy_ops  dont ha=
ve an op
> >>for wkup_ctrl
> >>Kishon, Can we add one?
> >Since this should be a capability of the PHY, can't we have wkup_ctrl al=
ways
> >enabled if the PHY has such a capability?
>=20
> No, we cant have wakeup always enabled. Normally we enable it only
> when we go to low power states and
> if the user needs USB a wakeup source.
>=20
> So how about enable/disable  phy wakeup from phy suspend/resume?

you should use something like so on your ->suspend() or
->runtime_suspend() method

static int my_phy_{suspend,runtime_suspend}(struct device *dev)
{
	struct my_phy *phy =3D dev_get_drvdata(dev);

	if (device_may_wakeup(dev))
		my_phy_enable_wakeup(phy);

	return 0;
}

> >or if it needs more user control,
> >should we implement a sysfs entry to enable wakeup?

that already exists ;-)

--=20
balbi

--HlL+5n6rz5pIUxbD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR3O/fAAoJEIaOsuA1yqREX9UQAIrHwsVyJYPwkTCDoaW6GSPM
Kl2XLM4QDo0pFCEGNV1g/lIYxsGVIDACh6OMDpn6P5c8CRWlEpfoFadn/9KiurCc
qZ6zjlsf04zQ4mpL84hmN5FjKLd1i8ewwuz3nktLz+kDJvBR5SJAuA1gsn3cE0Qv
7q7jV0zhOl7mU+YQlyiTswJvsRGrgMHudjbbzuVvrT1b8uqcc/QXFpyI9FDLoTje
V2R5lJaun/el6KLjjz9wAxO7SO7g2bQfrkxaEWFCBHGuD0iMQsZ9rbIB7oBoyNNR
jJocIOukuDAznR2ASRnNgq2mn7AeoGpRuTfBFPEPPnLKCjqR/QhPcQ6loVgDI/J2
Hm65HynqIvvtGA+3EfBi+hQFcN96Pk9A/LUWd2vCstTj1jARYVrnf4UEbUMIeyAV
5sQSoqbi+vj0x3UeNe6oKB3UFOC50nktzBtho6gPA76eaQhEn/0VujqqZQlYpaqP
JDlX4Mpa6WzK2r7DO0vXYEVXfKpH21nvrjPux/6cmPk5ZvFodt/1UDRoMiPuFQ1G
7iNmwYDrU9KdCCMwN40VKBTnrZGOrcZmv+7CoD7c0OEEQmyHeIDeEbL0p7XrqeTd
Ohw4oJCaVNE2os54y+a2Fey0+mosmRRlPiHSyR2rgTEwfXFbbjOy5fbW7PCe2m/G
p3oztTOTpcvK+n659hOU
=m1pC
-----END PGP SIGNATURE-----

--HlL+5n6rz5pIUxbD--
