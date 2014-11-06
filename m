Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069AbaKFRmR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 12:42:17 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:59406 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751365AbaKFRmP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 12:42:15 -0500
Date: Thu, 6 Nov 2014 11:40:11 -0600
From: Felipe Balbi <balbi@ti.com>
To: Romain Perier <romain.perier@gmail.com>
CC: Kever Yang <kever.yang@rock-chips.com>,
        Paul Zimmerman <paulz@synopsys.com>, Felipe Balbi <balbi@ti.com>,
        Dinh Nguyen <dinguyen@opensource.altera.com>,
        Heiko Stuebner <heiko@sntech.de>, <dianders@chromium.org>,
        <sonnyrao@chromium.org>, <addy.ke@rock-chips.com>,
        Eddie Cai <cf@rock-chips.com>, <xjq@rock-chips.com>,
        <hj@rock-chips.com>, <dkl@rock-chips.com>, <huangtao@rock-chips.com>,
        <linux-rockchip@lists.infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] usb: dwc2: add bus suspend/resume for dwc2
Message-ID: <20141106174011.GI16896@saruman>
Reply-To: <balbi@ti.com>
References: <1415237402-24665-1-git-send-email-kever.yang@rock-chips.com>
 <CABgxDo+9aZJ8BP3h=3sUUbSBD5R_FQmWF9f8kbzDbZrVG01n1A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xQR6quUbZ63TTuTU"
Content-Disposition: inline
In-Reply-To: <CABgxDo+9aZJ8BP3h=3sUUbSBD5R_FQmWF9f8kbzDbZrVG01n1A@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--xQR6quUbZ63TTuTU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 06, 2014 at 06:21:42PM +0100, Romain Perier wrote:
> Hi Kever,
>=20
>=20
> 2014-11-06 2:30 GMT+01:00 Kever Yang <kever.yang@rock-chips.com>:
> >
> > +static int _dwc2_hcd_suspend(struct usb_hcd *hcd)
> > +{
> > +       struct dwc2_hsotg *hsotg =3D dwc2_hcd_to_hsotg(hcd);
> > +       u32 hprt0;
> > +
> > +       if (!((hsotg->op_state =3D=3D OTG_STATE_B_HOST) ||
> > +               (hsotg->op_state =3D=3D OTG_STATE_A_HOST)))
> > +               return 0;
> > +
> > +       if (hsotg->lx_state !=3D DWC2_L0)
> > +               return 0;
> > +
> > +       hprt0 =3D dwc2_read_hprt0(hsotg);
> > +       if (hprt0 & HPRT0_CONNSTS)
> > +               dwc2_port_suspend(hsotg, 1);
> > +
> > +       return 0;
> > +}
> > +
> > +static int _dwc2_hcd_resume(struct usb_hcd *hcd)
> > +{
> > +       struct dwc2_hsotg *hsotg =3D dwc2_hcd_to_hsotg(hcd);
> > +       u32 hprt0;
> > +
> > +       if (!((hsotg->op_state =3D=3D OTG_STATE_B_HOST) ||
> > +               (hsotg->op_state =3D=3D OTG_STATE_A_HOST)))
> > +               return 0;
> > +
> > +       if (hsotg->lx_state !=3D DWC2_L2)
> > +               return 0;
> > +
> > +       hprt0 =3D dwc2_read_hprt0(hsotg);
> > +       if ((hprt0 & HPRT0_CONNSTS) && (hprt0 & HPRT0_SUSP))
> > +               dwc2_port_resume(hsotg);
> > +
> > +       return 0;
> > +}
>=20
> Could you also define these functions under #ifdef CONFIG_PM ?

please don't. I'm actually considering ripping all ifdefs from all these
drivers and also stop using SIMPLE_DEV_PM_OPS or any of its friends.

There's really nobody today would would build a kernel with CONFIG_PM.

--=20
balbi

--xQR6quUbZ63TTuTU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUW7J7AAoJEIaOsuA1yqREPnsP/1dzwCbl5u+y960EcQXbaUFn
WfXvA/5MQtjSHkqvN7nE4n7ScbaeoKk+DwC+rmHgNe9iIMhq6WEpv9adEZMtQvBs
jALSlSBlz1sPafLLoFhBvGfwQALemzgZQxR+QAlUY5wUcZi/Zzb6QhYuojfCRnSM
aE9vWikyB2jH34fNb5Nmm+SeVHIzDd3CmozGxGGO73MrxaDr3cv0NBD7qv+2ge7P
lwnmIUckYTV3XBaw7WvCP0+YzfjRbFeVBg91+KuXtFVg7TADpbBTkvXD+qEegeb3
Xz2lH7oY5myDqGJXv0T/0jDXFD06hJI30OU9XghP9YM80m9u/IXAYUJeaPf42phw
bwixMYuepdRX4A24P2RaqeBA5ldjxb6HxGi6vY2NH5vCsLcBF87qzkTbmXryhNPM
Nnenb3KA6tpmmLF9Ebeo9DCMEurk7qRterifadSCJm/1Wrwvh6ANmqtqSzMP33Hb
Nt08GEOcxtGVaoaep2SMVUQddHR1aAxZm2FCjoH3Gu6NlPdBdOS9gJAW5cOdqm2f
9v5Rirz5PUg6+d4+5lr8kzXS/imu5ze6zA9WGh7+ubpGbDiBbBWHqvH0rQ8+fu6m
5QqpnoH1aPTcoE6RLd9joB7d3haxRfnfttjahweDLyDxzf/SGsUOcVprQ/KqPDRT
z830tsWuZuywoyYjHVyt
=xggn
-----END PGP SIGNATURE-----

--xQR6quUbZ63TTuTU--
