Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932605AbaJXP35 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 11:29:57 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:50073 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751510AbaJXP3z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 11:29:55 -0400
Date: Fri, 24 Oct 2014 10:29:33 -0500
From: Felipe Balbi <balbi@ti.com>
To: Huang Rui <ray.huang@amd.com>
CC: Felipe Balbi <balbi@ti.com>, Paul Zimmerman <Paul.Zimmerman@synopsys.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Vincent Wan <vincent.wan@amd.com>, Tony Li <tony.li@amd.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 16/16] usb: dwc3: enable usb suspend phy
Message-ID: <20141024152933.GF26941@saruman>
Reply-To: <balbi@ti.com>
References: <1413536021-4886-1-git-send-email-ray.huang@amd.com>
 <1413536021-4886-17-git-send-email-ray.huang@amd.com>
 <20141017145942.GL26260@saruman>
 <A2CA0424C0A6F04399FB9E1CD98E0304844E3423@US01WEMBX2.internal.synopsys.com>
 <20141017184819.GX26260@saruman>
 <20141020084153.GD24357@hr-slim.amd.com>
 <20141020090124.GE24357@hr-slim.amd.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dWYAkE0V1FpFQHQ3"
Content-Disposition: inline
In-Reply-To: <20141020090124.GE24357@hr-slim.amd.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--dWYAkE0V1FpFQHQ3
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 20, 2014 at 05:01:25PM +0800, Huang Rui wrote:
> On Mon, Oct 20, 2014 at 04:41:54PM +0800, Huang Rui wrote:
> > On Fri, Oct 17, 2014 at 01:48:19PM -0500, Felipe Balbi wrote:
> > > Hi,
> > >=20
> > > On Fri, Oct 17, 2014 at 06:41:04PM +0000, Paul Zimmerman wrote:
> > > > > From: Felipe Balbi [mailto:balbi@ti.com]
> > > > > Sent: Friday, October 17, 2014 8:00 AM
> > > > >=20
> > > > > On Fri, Oct 17, 2014 at 04:53:41PM +0800, Huang Rui wrote:
> > > > > > AMD NL needs to suspend usb3 ss phy, but this doesn't enable on=
 simulation
> > > > > > board.
> > > > > >
> > > > > > Signed-off-by: Huang Rui <ray.huang@amd.com>
> > > > > > ---
> > > > > >  drivers/usb/dwc3/core.c          | 7 ++++++-
> > > > > >  drivers/usb/dwc3/dwc3-pci.c      | 3 ++-
> > > > > >  drivers/usb/dwc3/platform_data.h | 1 +
> > > > > >  3 files changed, 9 insertions(+), 2 deletions(-)
> > > > > >
> > > > > > diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
> > > > > > index 3ccfe41..4a98696 100644
> > > > > > --- a/drivers/usb/dwc3/core.c
> > > > > > +++ b/drivers/usb/dwc3/core.c
> > > > > > @@ -395,6 +395,9 @@ static void dwc3_phy_setup(struct dwc3 *dwc)
> > > > > >  	if (dwc->quirks & DWC3_QUIRK_TX_DEEPH)
> > > > > >  		reg |=3D DWC3_GUSB3PIPECTL_TX_DEEPH(1);
> > > > > >
> > > > > > +	if (dwc->quirks & DWC3_QUIRK_SUSPHY)
> > > > >=20
> > > > > should be:
> > > > >=20
> > > > > 	if (!dwc->suspend_usb3_phy_quirk)
> > > > >=20
> > > > > > +		reg |=3D DWC3_GUSB3PIPECTL_SUSPHY;
> > > > >=20
> > > > > IIRC, databook asks us to set that bit anyway, so the quirk is di=
sabling
> > > > > that bit. Am I missing something ? Paul ?
> > > >=20
> > > > It looks to me that Huang's patch is enabling that bit, not disabli=
ng
> > > > it.
> > >=20
> > > right, but that's what's actually quirky right ? IIRC, Databook asks =
us
> > > to set usb2 and usb3 suspend phy bits and we're just not doing it.
> > >=20
> > > > Currently the driver does not set either DWC3_GUSB3PIPECTL_SUSPHY or
> > > > DWC3_GUSB2PHYCFG_SUSPHY (unless it has been added by that big patch
> > > > series you just posted). According to the databook, both of those
> > > > bits should be set to 1 after the core initialization has completed.
> > >=20
> > > there you go. So unless that quirk bit flag is set, we're safe of
> > > setting SUSPHY bit for everybody.
> > >=20
> >=20
>=20
> I read the databook again, below words (DWC3_GUSB3PIPECTL_SUSPHY) is
> copied from databook:
>=20
> For DRD/OTG configurations, it is recommended that this bit is set to=E2=
=80=98
> 0=E2=80=99 during coreConsultant configuration. If it is set to =E2=80=99=
1=E2=80=99, then the
> application should clear this bit after power-on reset. Application
> needs to set it to =E2=80=991=E2=80=99 after the core initialization is c=
ompleted.
> For all other configurations, this bit can be set to =E2=80=991=E2=80=99 =
during core
> configuration.
>=20
> I see it's recommended to set '0' if on DRD/OTG configuration.

0 at the beginning of probe() sequence so core can communicate with its
PHYs, then set it to one at the end of probe().

--=20
balbi

--dWYAkE0V1FpFQHQ3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUSnBdAAoJEIaOsuA1yqREKWMQAJbbFfUiBsFCMnBvujcsl2Uo
pAAdW1PdW1wESrvwkN1+xXTHbnUtoXlPDwoumPO25VBPGd4ZFoF31LkEMUN/Wuvz
hhWYINqi01Nqp+cppc536w3RsONhobxgdLsDGEkcKzME5s5zm1HfyEcBZWRHvHm1
tJ+l7MBV6pyj8ZDnVi5SbVBLgszY7OC2bltKi7C68vg75zcpup5WijdQU7UwXUKq
GDVBye57yYTHe+NEqU+hW5Jnue/ApLkpbELvP7atq7zroW/OdLoS3AGXNjT0Avzg
olANiCqm7qpCXfLO4oHutCSsLQ3kN2MQJQhz/I2nkHe+Sht8/zPNej3WF+hRInpf
oNsjhF1Yqn0dl8KD8TqyqmPa4pc+FHcAvjUzFNj6wYsCrC4FOXcxth6T9JJklDf1
kA/uQusu7+8ykWfiU7HHRcx/rGdctMfnngjQKkEm/mo2xxc0Myzs2X2ShiIvCrSW
BQGYl6EQ5L90Coua1ss3ZqwgXGq/4jSYTy/2r56mtCGpdWspQGUY38eh4zhnxzsj
Dv1hPO5tTOp42ewWw4oe9AorllyqqjaQSak9USRLcdCbDbzlft2H6xpL3vG+DXq5
BaB4g7iLGqHW/9ZpnAyJ4jlegHFBMX5mTGFAUr2NNZDgOaqxYGWZUA0GKRMMreyC
gGnqY33TzqCkvAlzeC+l
=S+8w
-----END PGP SIGNATURE-----

--dWYAkE0V1FpFQHQ3--
