Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371AbaJ1TBx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 15:01:53 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:54974 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750855AbaJ1TBw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 15:01:52 -0400
Date: Tue, 28 Oct 2014 14:01:22 -0500
From: Felipe Balbi <balbi@ti.com>
To: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
CC: "balbi@ti.com" <balbi@ti.com>, Huang Rui <ray.huang@amd.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Jason Chang <jason.chang@amd.com>, Vincent Wan <vincent.wan@amd.com>,
        Tony Li <tony.li@amd.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 01/19] usb: dwc3: enable hibernation if to be supported
Message-ID: <20141028190122.GF25735@saruman>
Reply-To: <balbi@ti.com>
References: <1414497280-3126-1-git-send-email-ray.huang@amd.com>
 <1414497280-3126-2-git-send-email-ray.huang@amd.com>
 <A2CA0424C0A6F04399FB9E1CD98E0304844E68B7@US01WEMBX2.internal.synopsys.com>
 <20141028185059.GE25735@saruman>
 <A2CA0424C0A6F04399FB9E1CD98E0304844E68E4@US01WEMBX2.internal.synopsys.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ExXT7PjY8AI4Hyfa"
Content-Disposition: inline
In-Reply-To: <A2CA0424C0A6F04399FB9E1CD98E0304844E68E4@US01WEMBX2.internal.synopsys.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--ExXT7PjY8AI4Hyfa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 28, 2014 at 06:55:50PM +0000, Paul Zimmerman wrote:
> > From: Felipe Balbi [mailto:balbi@ti.com]
> > Sent: Tuesday, October 28, 2014 11:51 AM
> >=20
> > On Tue, Oct 28, 2014 at 06:47:08PM +0000, Paul Zimmerman wrote:
> > > > From: Huang Rui [mailto:ray.huang@amd.com]
> > > > Sent: Tuesday, October 28, 2014 4:54 AM
> > > >
> > > > It enables hibernation if the function is set in coreConsultant.
> > > >
> > > > Suggested-by: Felipe Balbi <balbi@ti.com>
> > > > Signed-off-by: Huang Rui <ray.huang@amd.com>
> > > > ---
> > > >  drivers/usb/dwc3/core.c | 1 +
> > > >  1 file changed, 1 insertion(+)
> > > >
> > > > diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
> > > > index fa396fc..bf77509 100644
> > > > --- a/drivers/usb/dwc3/core.c
> > > > +++ b/drivers/usb/dwc3/core.c
> > > > @@ -449,6 +449,7 @@ static int dwc3_core_init(struct dwc3 *dwc)
> > > >  	case DWC3_GHWPARAMS1_EN_PWROPT_HIB:
> > > >  		/* enable hibernation here */
> > > >  		dwc->nr_scratch =3D DWC3_GHWPARAMS4_HIBER_SCRATCHBUFS(hwparams4);
> > > > +		reg |=3D DWC3_GCTL_GBLHIBERNATIONEN;
> > > >  		break;
> > > >  	default:
> > > >  		dev_dbg(dwc->dev, "No power optimization available\n");
> > >
> > > What effect does this have when the controller is in device mode? I
> > > expect it will start generating DWC3_DEVICE_EVENT_HIBER_REQ interrupt
> > > events when this register bit is set. So the dev_WARN_ONCE in
> > > dwc3_gadget_interrupt() will start firing, I think.
> >=20
> > Ok, so this *has* to wait for proper hibernation support ?
>=20
> Ah, never mind. Since the hibernation event is not enabled in the
> DEVTEN register, the controller shouldn't generate that event after
> all. So I think it should be OK. Sorry for the noise.

do you think it's still nice to have a comment here ?

--=20
balbi

--ExXT7PjY8AI4Hyfa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUT+gCAAoJEIaOsuA1yqRE4isP/2suNJRt7UP73/aRm8J7uAR4
MMFmH+/KdZm94Zswlgdt3GCArnuLe/9xTjnYoSO2xPLLb5Km3lNYK/I7YjMvLI9Y
21GW7N0XQsYxwcSXqf+tWDK27I2ATScIWLFEVmA7SzdiAbc5ltJWsY4zJ/dNdGqw
P43/OFazl/aTqeWsV/QDkrBR77KSZ7tQ9i8/mUNJ6HmFAxraJJk9NkQQA83yBdLi
TCIpgdcYdFq9NaODr+Vlzpfwx18vCjENzV9rhKuDHsd6UT6J7XRV4VBfifwkmlrk
QG/EMT8SoD+8Vp1JmXZI6Z3oSyXVZ5M4hO4bh0W31mQuKFWh/kHmPhkTRP6p/MpJ
WWMRC5udwPs/vaeQxEwLhOu9X/BAMCktnP+ii1mtyxvhqaUi1V7ppoTwj3p4BQFn
jN4w4bhr9UxODtE9Q3U+7ggC6YuEx1txpfK++dJFkcHGsoKhP+nko5xwnQhiBn5l
d00CNf8DPpeeS2LOBGrCyzZIuEJkOauFVDDZ+cX+RJcozjabwVyxamWc5wJuivwK
QV4xaEilalDt3g00+XvgQQjbZ7g6g4ih5x0+Xf0rsqbS3+NnMWQdNndpY/LdpF5U
hdG9+1TwJYRuGQ6pRrahaTMGLkDkkE/8Wg/x3O9F7Vfqj5QqICYybKkdFMr8s6f2
8AUw+LSMaDm97FJ8WRM5
=X2we
-----END PGP SIGNATURE-----

--ExXT7PjY8AI4Hyfa--
