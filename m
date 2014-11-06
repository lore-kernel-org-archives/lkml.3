Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751494AbaKFTJx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 14:09:53 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:33925 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750955AbaKFTJu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 14:09:50 -0500
Date: Thu, 6 Nov 2014 13:07:44 -0600
From: Felipe Balbi <balbi@ti.com>
To: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
CC: "balbi@ti.com" <balbi@ti.com>, Romain Perier <romain.perier@gmail.com>,
        Kever Yang <kever.yang@rock-chips.com>,
        Dinh Nguyen <dinguyen@opensource.altera.com>,
        Heiko Stuebner <heiko@sntech.de>,
        "dianders@chromium.org" <dianders@chromium.org>,
        "sonnyrao@chromium.org" <sonnyrao@chromium.org>,
        "addy.ke@rock-chips.com" <addy.ke@rock-chips.com>,
        Eddie Cai <cf@rock-chips.com>,
        "xjq@rock-chips.com" <xjq@rock-chips.com>,
        "hj@rock-chips.com" <hj@rock-chips.com>,
        "dkl@rock-chips.com" <dkl@rock-chips.com>,
        "huangtao@rock-chips.com" <huangtao@rock-chips.com>,
        "linux-rockchip@lists.infradead.org" 
	<linux-rockchip@lists.infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] usb: dwc2: add bus suspend/resume for dwc2
Message-ID: <20141106190744.GA19460@saruman>
Reply-To: <balbi@ti.com>
References: <1415237402-24665-1-git-send-email-kever.yang@rock-chips.com>
 <CABgxDo+9aZJ8BP3h=3sUUbSBD5R_FQmWF9f8kbzDbZrVG01n1A@mail.gmail.com>
 <20141106174011.GI16896@saruman>
 <A2CA0424C0A6F04399FB9E1CD98E0304844E9C67@US01WEMBX2.internal.synopsys.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qDbXVdCdHGoSgWSk"
Content-Disposition: inline
In-Reply-To: <A2CA0424C0A6F04399FB9E1CD98E0304844E9C67@US01WEMBX2.internal.synopsys.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--qDbXVdCdHGoSgWSk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Nov 06, 2014 at 06:35:53PM +0000, Paul Zimmerman wrote:
> > From: Felipe Balbi [mailto:balbi@ti.com]
> > Sent: Thursday, November 06, 2014 9:40 AM
> >=20
> > On Thu, Nov 06, 2014 at 06:21:42PM +0100, Romain Perier wrote:
> > >
> > > 2014-11-06 2:30 GMT+01:00 Kever Yang <kever.yang@rock-chips.com>:
> > > >
> > > > +static int _dwc2_hcd_suspend(struct usb_hcd *hcd)
> > > > +{
> > > > +       struct dwc2_hsotg *hsotg =3D dwc2_hcd_to_hsotg(hcd);
> > > > +       u32 hprt0;
> > > > +
> > > > +       if (!((hsotg->op_state =3D=3D OTG_STATE_B_HOST) ||
> > > > +               (hsotg->op_state =3D=3D OTG_STATE_A_HOST)))
> > > > +               return 0;
> > > > +
> > > > +       if (hsotg->lx_state !=3D DWC2_L0)
> > > > +               return 0;
> > > > +
> > > > +       hprt0 =3D dwc2_read_hprt0(hsotg);
> > > > +       if (hprt0 & HPRT0_CONNSTS)
> > > > +               dwc2_port_suspend(hsotg, 1);
> > > > +
> > > > +       return 0;
> > > > +}
> > > > +
> > > > +static int _dwc2_hcd_resume(struct usb_hcd *hcd)
> > > > +{
> > > > +       struct dwc2_hsotg *hsotg =3D dwc2_hcd_to_hsotg(hcd);
> > > > +       u32 hprt0;
> > > > +
> > > > +       if (!((hsotg->op_state =3D=3D OTG_STATE_B_HOST) ||
> > > > +               (hsotg->op_state =3D=3D OTG_STATE_A_HOST)))
> > > > +               return 0;
> > > > +
> > > > +       if (hsotg->lx_state !=3D DWC2_L2)
> > > > +               return 0;
> > > > +
> > > > +       hprt0 =3D dwc2_read_hprt0(hsotg);
> > > > +       if ((hprt0 & HPRT0_CONNSTS) && (hprt0 & HPRT0_SUSP))
> > > > +               dwc2_port_resume(hsotg);
> > > > +
> > > > +       return 0;
> > > > +}
> > >
> > > Could you also define these functions under #ifdef CONFIG_PM ?
> >=20
> > please don't. I'm actually considering ripping all ifdefs from all these
> > drivers and also stop using SIMPLE_DEV_PM_OPS or any of its friends.
> >=20
> > There's really nobody today would would build a kernel with CONFIG_PM.
>=20
> I'm sure Felipe meant *without* CONFIG_PM.

oops, that's correct.

> Kever, in that case you should remove the #ifdef CONFIG_PM around the
> .bus_suspend and .bus_resume assignments also, otherwise there will be
> compiler warnings when built without CONFIG_PM. After that, you can
> add my acked-by.

tks

--=20
balbi

--qDbXVdCdHGoSgWSk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUW8cAAAoJEIaOsuA1yqREJdkP/jKUpxJ8Gwwq19Hzg1G0ciGG
cBa58F/j6rljSugOEtY5Q0UyrV9tQJ/MsxccHXJx9/sNhDud8FcWLmECLa0kIesd
DBEmHrisLT1wdl5S0KJZKtyaS1Vo9BzPn115ayNYlWsaBKjig4uTDg9Guys09r31
b15FeCstP6IEiX+6ueyhRxj/f2HpOb1h2sYHYcWXxYY78lU7hBjmg+lmhPXFlq6+
g8cJgRm8/5I6Zt5NOtw9ncO872HQdV459Kd2aM9EnpbfMLHZkijh4HkilhAeNMRz
eTP/aMHo42X/PhKMQLPYhFm25RR59g11BOvsWBQm1n0Nhtc0vJJYkyzmsQZdjYW4
VspJxMC8nzjfHWaHcj8rh+rMznkdTN/o4/bEKN89NqI7hfoRCa53OQy/d+IPWhwq
JHHO+yIBBk/iQ8n4GGSsufs7HgS9jXTYrNv0OT5sCsdsyVTutwvM7FQcbxa/tujD
bSvyip6G9+JvVFm7lxVBIqYAcPOe9xqr+V9OLmIEOWzKEeUkFfJDJ5hRRd9T+96F
vqGn7m8gr3eRlDjcQ0Pacwjq4V+fEe2lRVo1sSjgQBKBkoFBr1wZblFaO1/13edW
XA3hwm+kFj7xbkhNXv/K6HF8kMs+xO2v8WdBmYDyEURG/mHpxxZvv2zr4ZtgfueF
ZYZM+REOnUipsmg6PEvx
=CB3v
-----END PGP SIGNATURE-----

--qDbXVdCdHGoSgWSk--
