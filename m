Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932669AbaGUPL5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 11:11:57 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:58104 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932511AbaGUPLz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 11:11:55 -0400
Date: Mon, 21 Jul 2014 10:10:43 -0500
From: Felipe Balbi <balbi@ti.com>
To: Lothar =?iso-8859-1?Q?Wa=DFmann?= <LW@KARO-electronics.de>
CC: <balbi@ti.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        George Cherian <george.cherian@ti.com>,
        <linux-arm-kernel@lists.infradead.org>, Roger Quadros <rogerq@ti.com>
Subject: Re: [PATCH 8/9] usb: phy: am335x: call
 usb_gen_phy_init()/usb_gen_phy_shutdown() in am335x_init()/am335x_shutdown()
Message-ID: <20140721151043.GF6852@saruman.home>
Reply-To: <balbi@ti.com>
References: <1405675890-8802-2-git-send-email-LW@KARO-electronics.de>
 <1405675890-8802-3-git-send-email-LW@KARO-electronics.de>
 <1405675890-8802-4-git-send-email-LW@KARO-electronics.de>
 <1405675890-8802-5-git-send-email-LW@KARO-electronics.de>
 <1405675890-8802-6-git-send-email-LW@KARO-electronics.de>
 <1405675890-8802-7-git-send-email-LW@KARO-electronics.de>
 <1405675890-8802-8-git-send-email-LW@KARO-electronics.de>
 <1405675890-8802-9-git-send-email-LW@KARO-electronics.de>
 <20140718135713.GH24914@saruman.home>
 <20140721100307.21172b65@ipc1.ka-ro>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eNMatiwYGLtwo1cJ"
Content-Disposition: inline
In-Reply-To: <20140721100307.21172b65@ipc1.ka-ro>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--eNMatiwYGLtwo1cJ
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,,

On Mon, Jul 21, 2014 at 10:03:07AM +0200, Lothar Wa=DFmann wrote:
> Hi,
>=20
> > On Fri, Jul 18, 2014 at 11:31:29AM +0200, Lothar Wa=DFmann wrote:
> > > This patch makes it possible to use the musb driver with HW that
> > > requires external regulators or clocks.
> >=20
> > can you provide an example of such HW ? Are you not using the internal
> > PHYs ?
> >=20
> The Ka-Ro electronics TX48 module uses the mmc0_clk pin as VBUSEN
> rathern than usb0_drvvbus. This patch makes it possible to use an
> external regulator to handle the VBUS switch through the 'vcc-supply'
> property of the underlying generic_phy device.

OK, I get it now. But why would not use usb0_drvvbus ? You could still
route usb0_drvvbus to the regulator enable pin and the regulator would
be enabled for you once correct values are written to the IP's mailbox.

I suppose this has something to do with layout constraints ?

cheers

--=20
balbi

--eNMatiwYGLtwo1cJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTzS1zAAoJEIaOsuA1yqREXWMP/2+LIUYq5BLkYGbp3qpBPu7o
kt8YaZ5jnFWQyz5//jt6I/eA59tyMBClRKl7vVri2ZXeozIGMQnmZx092TUJHCYk
Wv+j8gW6j4qc1GjREWa/Zcd95nrFTgNjNEeTiFRUcs44qWy2siAyai+cllz3Afpa
Q7RQlJSh86X4+XK5GO5JWnNPzdHWQ4RLSVJrZndzhURxlrFKPCVFJQ7eRma+kIjJ
0JU3u3lgzoH8M8S1a7pjWMqzZUDbBIfpAASYgzdGz+voLGbpAyAG7aOpyuZ9pyZq
BhBw9kIJc1T/tIRfv7dOLhc8QzqS6ByvOwnUZuEUBWICOMzdFFZWjKAM5YEYpjNQ
DkRgiwTul/NJdomeva1PTZvAKALdCBtCQk2oszbr11laR5W69/dvqGlkpuyy9NP1
S6kPyfxSEz+6ukGucen9O0kpj80a4aLUHR4+j5HKTRYdbWym+WdySnJl8qcubJwf
mS76kbxYlyjc+LGscDMnMGbTQTKvcc+YDa5cd6XUeLYXkGUPA30gcFUSs3UYSyek
iB8l0OMjT6r0b1vBKeE24y1Wx9eN3xP4XgPeojTzeDeEVUgOwMHLJ+5Js0ZOq23q
ehE775uwIHwEETIGIYf8gAFt9qTl1+tSiwITgwLru6sV9u18dbWUaJFphfQiEDuW
ANC33EH6EJvp74in7N19
=J6Mq
-----END PGP SIGNATURE-----

--eNMatiwYGLtwo1cJ--
