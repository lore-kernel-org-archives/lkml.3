Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755719AbaKRQnc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 11:43:32 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:50168 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753832AbaKRQna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 11:43:30 -0500
Date: Tue, 18 Nov 2014 10:41:00 -0600
From: Felipe Balbi <balbi@ti.com>
To: Alan Stern <stern@rowland.harvard.edu>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
CC: Kever Yang <kever.yang@rock-chips.com>,
        Paul Zimmerman <paulz@synopsys.com>, Felipe Balbi <balbi@ti.com>,
        Dinh Nguyen <dinguyen@opensource.altera.com>,
        <romain.perier@gmail.com>, Heiko Stuebner <heiko@sntech.de>,
        <dianders@chromium.org>, <sonnyrao@chromium.org>,
        <addy.ke@rock-chips.com>, <cf@rock-chips.com>, <wulf@rock-chips.com>,
        <huangtao@rock-chips.com>, <linux-rockchip@lists.infradead.org>,
        Roy Li <roy.li@rock-chips.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] usb: dwc2: resume root hub when device detect with
 suspend state
Message-ID: <20141118164100.GD6179@saruman>
Reply-To: <balbi@ti.com>
References: <1416273684-11300-1-git-send-email-kever.yang@rock-chips.com>
 <Pine.LNX.4.44L0.1411181104280.1500-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZJcv+A0YCCLh2VIg"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1411181104280.1500-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--ZJcv+A0YCCLh2VIg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 18, 2014 at 11:07:34AM -0500, Alan Stern wrote:
> On Tue, 18 Nov 2014, Kever Yang wrote:
>=20
> > After we implement the bus_suspend/resume, auto suspend id enabled.
> > The root hub will be auto suspend if there is no device connected,
> > we need to resume the root hub when a device connect detect.
> >=20
> > This patch tested on rk3288.
> >=20
> > Signed-off-by: Roy Li <roy.li@rock-chips.com>
> > Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
> > ---
> >=20
> > Changes in v2:
> > - add definition for hcd structure
> > - remove check for bus->root_hub
> >=20
> >  drivers/usb/dwc2/hcd_intr.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> >=20
> > diff --git a/drivers/usb/dwc2/hcd_intr.c b/drivers/usb/dwc2/hcd_intr.c
> > index 551ba87..680206f 100644
> > --- a/drivers/usb/dwc2/hcd_intr.c
> > +++ b/drivers/usb/dwc2/hcd_intr.c
> > @@ -329,6 +329,7 @@ static void dwc2_port_intr(struct dwc2_hsotg *hsotg)
> >  {
> >  	u32 hprt0;
> >  	u32 hprt0_modify;
> > +	struct usb_hcd *hcd =3D (struct usb_hcd *)hsotg->priv;
> > =20
> >  	dev_vdbg(hsotg->dev, "--Port Interrupt--\n");
> > =20
> > @@ -354,6 +355,10 @@ static void dwc2_port_intr(struct dwc2_hsotg *hsot=
g)
> >  		hsotg->flags.b.port_connect_status =3D 1;
> >  		hprt0_modify |=3D HPRT0_CONNDET;
> > =20
> > +		/* resume root hub? */
> > +		if (hcd->state =3D=3D HC_STATE_SUSPENDED)
> > +			usb_hcd_resume_root_hub(hcd);
>=20
> You should be aware that it's not safe to use hcd->state for anything=20
> in a host controller driver.  That field is owned by usbcore, not by=20
> the HCD, and it is not protected by any locks.
>=20
> Thus, for example, hcd->state does not get set to HC_STATE_SUSPENDED
> until some time after the bus_suspend routine has returned.  A
> port-change interrupt might occur during that time interval.

In that case, XHCI has a bug :-) Mathias, care to add it to your TODO
list ?

--=20
balbi

--ZJcv+A0YCCLh2VIg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUa3acAAoJEIaOsuA1yqRECyAP/RU5FGigEDx6U5MpDnbSOVkx
zrf+DkRbTi2NKwjWwqDtkEP9RPmbt2rC5T0b6V1C3DTi4m3Ft/ZdVA/1v6kK0WOz
bAmytMBnG4MxHF7lSv00HKWW1CT+DT289WOwKvmyopGbSIJjoRpknovCPBmVZsF6
s8INdxf4iudKHjuXBFpI7kcnX1tw65460TrQLIupav/caSuBb+WYjLiH9nqWwCmW
40SVY9uznA987qenaDa6zzDxmwfWdcv4vzNgPc+x7CsmYys57k9V2lRa7llJXsQE
rtkplBXNPsaXv4b5YfpLzkL/VjJxJ3fkCF5q6qqiB6TAuZR6fmZW1fs23rjreKTh
1XTzCO8eZVDA4cEkF/KhH4oIQXCQumGWX8TCGwsOUXh/5JjnLk7LSbrIAaMSy/8x
5sqI/6aWtYnrzIwuGwdl4ISj+FbFihOvRLE9WV9ILzNfazrFgnchK4MPeQMsD6vk
euaIvAT9Kc7OdURQh0BEGuXiWUlubujV+YYB6PRmAirsnVtBYoBt/4F+lKzXqAKP
x+o1EdxSc7rxs7ZxxjbiSaHEPUHP0uW1E/5yaEHW3RBXLimLWLV7WQ6cNl+yxidj
a9k+pwlA2qlqAH/hftK/o8bD3+AevnQwCfrWCcny6tmMBNA0kqCPkfkt3H4OUWUa
OxBwcXCHzvKRC9U09jcL
=zikY
-----END PGP SIGNATURE-----

--ZJcv+A0YCCLh2VIg--
