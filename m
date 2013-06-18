Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932322Ab3FRPCn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 11:02:43 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:44948 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754995Ab3FRPCm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 11:02:42 -0400
Date: Tue, 18 Jun 2013 18:00:50 +0300
From: Felipe Balbi <balbi@ti.com>
To: Alan Stern <stern@rowland.harvard.edu>
CC: Felipe Balbi <balbi@ti.com>, Roger Quadros <rogerq@ti.com>,
        Chao Xie <chao.xie@marvell.com>, <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <xiechao.mail@gmail.com>
Subject: Re: [PATCH] USB: initialize or shutdown PHY when add or remove host
 controller
Message-ID: <20130618150050.GD10318@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <20130618082428.GF5461@arwen.pp.htv.fi>
 <Pine.LNX.4.44L0.1306181046180.1157-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Qrgsu6vtpU/OV/zm"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1306181046180.1157-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Qrgsu6vtpU/OV/zm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Jun 18, 2013 at 10:53:26AM -0400, Alan Stern wrote:
> > > If the controllers don't want HCD core to manage the PHY they can jus=
t set it
> > > to some error code.
> >=20
> > they shouldn't have the choice, otherwise it'll be a bit of a PITA to
> > maintain the code. ehci core tries to grab the PHY, if it's not there,
> > try to continue anyway. Assume it's not needed.
>=20
> Felipe, are all these issues straightened out to your satisfaction?  I
> can't tell from the email thread.
>=20
> Looking through the EHCI glue source files, there appears to be a=20
> variety of different ways of getting the PHY.  It's not at all clear=20
> that they can be moved into the ehci-hcd core (or even better, the USB=20
> core -- which is what Chao is trying to do).

yeah, Roger brought up a big problem with OMAP's EHCI depending on the
mode so, at least for now, we should keep phy_get and, in case of EHCI
OMAP, phy_init in the glue :-(

Roger has all the details, and they're also in the list archives, but
basically, depending on the mode, PHY *must* be initialized at a
particular point.

> Given that the glue module has to be responsible for getting the PHY,
> it should also be responsible for error checking.  So the code added to
> hcd.c doesn't need to apply an IS_ERR check; it can simply assume that
> if hcd->phy is NULL then either there is no software-controllable PHY
> or else the HCD doesn't want the core to manage it.

makes sense to me, add the requirement to:

if (IS_ERR(hcd->phy))
	hcd->phy =3D NULL;

--=20
balbi

--Qrgsu6vtpU/OV/zm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRwHYiAAoJEIaOsuA1yqRETuAP/2QyoJ7l9vPmhAqrqF/Baf55
eI6NX+jlhLXhwYI/ShEwZXX6dwEzd9I/An41TJYMQs2ntMxVybp2i6BIJ/YsQIQJ
e7EtgJHEC4gTTBYcBt9g/7VMNJN9xPJHugwXfqtqVvhI4hhIbAz9mcwh4qX3D45Q
sW2NrJRuZW6XpsMA0JAT3XkVMLD/IlgiKjugtOtZOQmtNl/7S2dW987ln7s0jXLb
pHuWx4FsESByXo25d8A7AtHJ8Jg/BVW+GlHpdFUJEx5KuD9nsjlWtZ/78oZPEWu5
7Z45BZG2wlxp+ZtCSMfwgRzl/ICT8U1NIKyj2Zr04gYGhOIMuekjH31IdnT2JuBs
WHy5Xwds6WO0KibNcilVGGlQZkiXZdPBfLkYmLLzG0u74coJfvOZnk2BZCpW6HSs
phNc8vaXkcPRnIA3P3mz09E8lodXeTwnL6L1RwGlLqraQJDWHyjpQ++x5C7CAp7C
XV3JAoY7/E0d8qg72JoiFiTk9L/3hYMOeEEUhfgl1nsqFKavf9ctnqPsF9Of3Cwr
15+xP+sTZZWsd9VHjeOcUI11IlUtEt4bc5HgmxRSS0vK5O+wqVaBmyKGVnXZMrba
AOcDXELEzJVob5HHhlQ2uTcSv9CcfoJQFvnkVJ/xVF7xegSqdYvg9qCvYAk8apIk
JBu4voCEsv4wFLrajLtZ
=vlNj
-----END PGP SIGNATURE-----

--Qrgsu6vtpU/OV/zm--
