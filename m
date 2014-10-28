Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752183AbaJ1TT1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 15:19:27 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:58046 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751030AbaJ1TTZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 15:19:25 -0400
Date: Tue, 28 Oct 2014 14:18:52 -0500
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
Message-ID: <20141028191852.GJ25735@saruman>
Reply-To: <balbi@ti.com>
References: <1414497280-3126-1-git-send-email-ray.huang@amd.com>
 <1414497280-3126-2-git-send-email-ray.huang@amd.com>
 <A2CA0424C0A6F04399FB9E1CD98E0304844E68B7@US01WEMBX2.internal.synopsys.com>
 <20141028185059.GE25735@saruman>
 <A2CA0424C0A6F04399FB9E1CD98E0304844E68E4@US01WEMBX2.internal.synopsys.com>
 <20141028190122.GF25735@saruman>
 <A2CA0424C0A6F04399FB9E1CD98E0304844E691D@US01WEMBX2.internal.synopsys.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7ArrI7P/b+va1vZ8"
Content-Disposition: inline
In-Reply-To: <A2CA0424C0A6F04399FB9E1CD98E0304844E691D@US01WEMBX2.internal.synopsys.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--7ArrI7P/b+va1vZ8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 28, 2014 at 07:15:29PM +0000, Paul Zimmerman wrote:
> > From: Felipe Balbi [mailto:balbi@ti.com]
> > Sent: Tuesday, October 28, 2014 12:01 PM
> >=20
> > On Tue, Oct 28, 2014 at 06:55:50PM +0000, Paul Zimmerman wrote:
> > > > From: Felipe Balbi [mailto:balbi@ti.com]
> > > > Sent: Tuesday, October 28, 2014 11:51 AM
> > > >
> > > > On Tue, Oct 28, 2014 at 06:47:08PM +0000, Paul Zimmerman wrote:
> > > > > > From: Huang Rui [mailto:ray.huang@amd.com]
> > > > > > Sent: Tuesday, October 28, 2014 4:54 AM
> > > > > >
> > > > > > It enables hibernation if the function is set in coreConsultant.
> > > > > >
> > > > > > Suggested-by: Felipe Balbi <balbi@ti.com>
> > > > > > Signed-off-by: Huang Rui <ray.huang@amd.com>
> > > > > > ---
> > > > > >  drivers/usb/dwc3/core.c | 1 +
> > > > > >  1 file changed, 1 insertion(+)
> > > > > >
> > > > > > diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
> > > > > > index fa396fc..bf77509 100644
> > > > > > --- a/drivers/usb/dwc3/core.c
> > > > > > +++ b/drivers/usb/dwc3/core.c
> > > > > > @@ -449,6 +449,7 @@ static int dwc3_core_init(struct dwc3 *dwc)
> > > > > >  	case DWC3_GHWPARAMS1_EN_PWROPT_HIB:
> > > > > >  		/* enable hibernation here */
> > > > > >  		dwc->nr_scratch =3D DWC3_GHWPARAMS4_HIBER_SCRATCHBUFS(hwpara=
ms4);
> > > > > > +		reg |=3D DWC3_GCTL_GBLHIBERNATIONEN;
> > > > > >  		break;
> > > > > >  	default:
> > > > > >  		dev_dbg(dwc->dev, "No power optimization available\n");
> > > > >
> > > > > What effect does this have when the controller is in device mode?=
 I
> > > > > expect it will start generating DWC3_DEVICE_EVENT_HIBER_REQ inter=
rupt
> > > > > events when this register bit is set. So the dev_WARN_ONCE in
> > > > > dwc3_gadget_interrupt() will start firing, I think.
> > > >
> > > > Ok, so this *has* to wait for proper hibernation support ?
> > >
> > > Ah, never mind. Since the hibernation event is not enabled in the
> > > DEVTEN register, the controller shouldn't generate that event after
> > > all. So I think it should be OK. Sorry for the noise.
> >=20
> > do you think it's still nice to have a comment here ?
>=20
> Maybe something along the lines of "enabling this bit so that host-mode
> hibernation will work, device-mode hibernation is not implemented yet"?

sounds good to me. Huang, can you update your patch to add this comment
Paul suggested ?

thanks

--=20
balbi

--7ArrI7P/b+va1vZ8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUT+wcAAoJEIaOsuA1yqREUTwP+QGFATRBtzkuN4vPlmh7sfyi
Een/Ig8itjp0Bs5MVxGW4ounfa50LHrVKXg+AdgExLWVg8nS0Ku++mitqrWXPH1v
DJ+NripiWsiOOzgNYXZQ+ZOoUn7YKmWZYBf4JOUcSVOZwzwn50P2wXI4u8ma+YOE
dGPJkwlPimXKtxbZoNnuCHuLuAgqNBOksZUcO/w589VRWHBS+lhRkbv5O+LvN4SK
txop2DbGSi44/iMmkGS9hnpCu++o+yESW5TMZjCCKtiVyH+lp++9Cv+RfYHe7G8C
RyPyUHlzmH9geK7I0FCSzS+drAcFlqyKN3YQIGFuUvvcQYrtvnnwGt197aL8e8oW
HI/jR35d7/pwkUVzFHVeA4498qAwzdcc0RGjrUJMu4QOR3pYaxEW6XNQwB6E2UQM
5z8gb+ehp68dcW8SSAIa2/ehqivWQEOXhUOQ9AyqlRX42FaIp5h/mFTJ6Sy+jKZ9
boGkoHYV+NF4T9OzpqnSI4KSvCH+JAITEG/0sgzUUM9NSMsT98pxw9RdZIazyV3V
6E4Io/xsNYi3NkiS9te8vVa3RlqXEETgN4RV/Dt+m8Nytbq3Gdl5+5ZPSXnG7sBU
Wcmzo/PIufrEiwXoiiJXnKfyHoWZpp3zjzzxpK91hnWGmdlCZcaho37ZwsEFCuBx
8RlGG8EHGOnc3H7iyfYn
=6V8Y
-----END PGP SIGNATURE-----

--7ArrI7P/b+va1vZ8--
