Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082AbaC1OpM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 10:45:12 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:33716 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751921AbaC1OpK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 10:45:10 -0400
Date: Fri, 28 Mar 2014 09:42:45 -0500
From: Felipe Balbi <balbi@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Felipe Balbi <balbi@ti.com>, Greg KH <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        <linux-pm@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, Kevin Hilman <khilman@linaro.org>,
        Tero Kristo <t-kristo@ti.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [RFC/PATCH] base: platform: add generic clock handling for
 platform-bus
Message-ID: <20140328144245.GD17820@saruman.home>
Reply-To: <balbi@ti.com>
References: <1391191965-31102-1-git-send-email-balbi@ti.com>
 <2775124.TXohNNxBKa@avalon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4zI0WCX1RcnW9Hbu"
Content-Disposition: inline
In-Reply-To: <2775124.TXohNNxBKa@avalon>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--4zI0WCX1RcnW9Hbu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Mar 12, 2014 at 04:37:19PM +0100, Laurent Pinchart wrote:
> Hi Felipe,
>=20
> (CC'ing Geert Uytterhoeven as we happen to discuss runtime PM and clock=
=20
> handling for the Renesas SoCs at the moment)
>=20
> Thank you for the patch. This is a bit of a late reply, but that's better=
 than=20
> no reply I suppose. Please see below for a small comment.
>=20
> On Friday 31 January 2014 12:12:45 Felipe Balbi wrote:
> > Still TODO a commit log. Not for merging!!!!!
> >=20
> > NYET-Signed-off-by: Felipe Balbi <balbi@ti.com>
> > ---
> >=20
> > This patch is an idea I've had recently in order to combine several
> > different PM implementations into the platform-bus.
> >=20
> > This patch is bare minimum for platforms which need to handle functiona=
l and
> > interface clocks but the whole thing is made optional.
> >=20
> > Note that this patch makes sure that by the time a platform_driver's pr=
obe
> > is called, we already have clocks enabled and pm_runtime_set_active() h=
as
> > been called, thus making sure that a device driver's pm_runtime_get_syn=
c()
> > will solely increase the pm usage counter.
> >=20
> > I have *NOT* tested this anywhere *YET*, but I suppose it shouldn't cau=
se
> > any issues since the clock API has ref counting too.
> >=20
> > Would really like to get some review from several folks involved with A=
RM
> > SoC PM so that's the reason for the wide audience. If I have missed
> > anybody, please add them to Cc.
> >=20
> > As mentioned above, this is *NOT* meant for merging, but serves as a
> > starting point for discussing some convergence of several PM domain
> > implementations on different arch/arm/mach-* directories.
> >=20
> > For OMAP, this has the added benefit of removing clock handling from
> > omap_device/omap_hwmod and, thus, dropping the need for so many DT_CLK()
> > tables under drivers/clk/ti/
> >=20
> >  drivers/base/platform.c         | 169 ++++++++++++++++++++++++++++++++=
+++--
> >  include/linux/platform_device.h |   9 +++
> >  2 files changed, 173 insertions(+), 5 deletions(-)
> >=20
> > diff --git a/drivers/base/platform.c b/drivers/base/platform.c
> > index 3a94b79..86aeb5b 100644
> > --- a/drivers/base/platform.c
> > +++ b/drivers/base/platform.c
> > @@ -484,6 +484,21 @@ static int platform_drv_probe(struct device *_dev)
> >  	if (ACPI_HANDLE(_dev))
> >  		acpi_dev_pm_attach(_dev, true);
> >=20
> > +	dev->fck =3D devm_clk_get(_dev, "fck");
> > +	dev->ick =3D devm_clk_get(_dev, "ick");
>=20
> My concern with this that some devices might want to handle their functio=
nal=20
> and interface clocks manually if they have exotic requirements. They woul=
d=20
> thus need a way to signal that the platform bus core should not try to pe=
rform=20
> clock management on its own.
>=20
> One possible way would be to name the clocks differently for those device=
s,=20
> but we might then have a backward compatibility issue with DT.
>=20
> Another concern is how to handle the DT backward compatibility for device=
s=20
> that would benefit from core management of their functional and interface=
=20
> clocks, but that currently don't name those clocks "fck" and "ick". Renam=
ing=20
> those clocks in DT wouldn't be a problem for the future, but backward=20
> compatibility needs to be handled. Maybe platforms could provide aliases =
in=20
> that case.

yeah, I guess alias would be the way to go. Another possible way would
be grab the clocks by phandle if of_node is a valid pointer. At the end
of the day, the name of the clock shouldn't matter.

--=20
balbi

--4zI0WCX1RcnW9Hbu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTNYplAAoJEIaOsuA1yqRE+18P/1poTi3azvbrCIUT3hgqdS7b
S6aBvIkLPOWBn7nDQH59NCnphd9zs6aR2WtwlPhf8yyCGfOfnQYcohiDNzyVBCe1
nThRi8oyprgjNqLGVSczR5Rf3vzfbk3jnWEWCaeGEXCujbma7+IXTfo2BXcSPM+7
lb8iN1PyG815ZtHhYpizNhNzuR8jb/qTcqoMEwj0KGwGbpm4FHzKFRDn7kXfQcHs
OnL1vetQ6uysAj7MWLoELAfBbG83c0owFOoAW6eT8GKlJGOHhwZg07qzFBHV8BOC
2y6y2pdwFMpMualBy9e7lczKR5JeZLaVqzdUJaifb13V4bq6B31Io7rhTHQnBLm1
riZCmCaxhs8aeWrTPbfJQZEqnMdJmhqcbotDGFp5vQb8fdMSmAr3jz2xH+M+1sO4
IPLURYnTKfMCfUORiaJzMIaUHoS8Eagjxl+a66TDWIx0YDosATyUbsrX50ejhI0+
5dt1OfLgo+7orUNmZVIEVMowIQdtLRKDdC3bpnPibw2wsW2bl7YqbWyzmhPyVOTq
MKhqopASsUKu/vcFM0P3Zm6ENIX+eJov78T1TbCI9G3E389UDp+RH6tiTkEI48B9
QyDxInuW7iVWa9dRblZh+CEFZAhUUtWY1thb3c5MC0q/Ne7GRB0bUK9c8rEjisAz
wyiUVlARS30KdEBRffI2
=HaQi
-----END PGP SIGNATURE-----

--4zI0WCX1RcnW9Hbu--
