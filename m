Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751601AbaLMRqs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2014 12:46:48 -0500
Received: from mail.kernel.org ([198.145.19.201]:43652 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750761AbaLMRqq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2014 12:46:46 -0500
Date: Sat, 13 Dec 2014 18:46:41 +0100
From: Sebastian Reichel <sre@kernel.org>
To: Grant Likely <grant.likely@linaro.org>
Cc: NeilBrown <neilb@suse.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Rutland <mark.rutland@arm.com>, Jiri Slaby <jslaby@suse.cz>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] TTY: add support for "tty slave" devices.
Message-ID: <20141213174640.GA18961@earth.universe>
References: <20141211214801.4127.93914.stgit@notabene.brown>
 <20141211215943.4127.24792.stgit@notabene.brown>
 <20141212115920.4277AC408F1@trevor.secretlab.ca>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="HcAYCG3uE/tztfnV"
Content-Disposition: inline
In-Reply-To: <20141212115920.4277AC408F1@trevor.secretlab.ca>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HcAYCG3uE/tztfnV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Dec 12, 2014 at 11:59:20AM +0000, Grant Likely wrote:
> [...]
> > --- a/Documentation/devicetree/bindings/serial/of-serial.txt
> > +++ b/Documentation/devicetree/bindings/serial/of-serial.txt
> > @@ -39,6 +39,10 @@ Optional properties:
> >    driver is allowed to detect support for the capability even without =
this
> >    property.
> > =20
> > +Optional child node:
> > +- a platform device listed as a child node will be probed and
> > +  powered-on whenever the tty is in use (open).
> > +
>=20
> The biggest concern I have is what happens to nodes that already have
> child devices that /don't/ match this use case? It is possible that some
> UART nodes already have a child node used to store other data. There are
> two ways to handle this; 1) add a new bool property that indicates the
> child nodes are tty slave devices, or 2) Make each uart driver
> explicitly enable the feature so that driver authors can check if it is
> a problem for that device. I personally would suggest #1 because then it
> can be enabled in generic code.

maybe simple depend on the compatible value? If the UART node has
child nodes to store other random data it should not have a
compatible value?

-- Sebastian

--HcAYCG3uE/tztfnV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJUjHt+AAoJENju1/PIO/qaBNkP/RILKWmQxOsqhnr6kxoUGF6t
RrGr+NJ8cELaS9fxaAP9EB0mlOQPJeR5Xe8sY0lNEjo2XVvdsOyHQssLTbNaJDM0
LXdU3cN441fhL6h2fUFZG1cUtBDSqj0VcqAkepd9vS+cF8x+NYAz6MKS2drut5Bz
/SaG8670aXNLhZN6CgbTXdSrklN/oU6f7aIosSDs5UNCtk3btU1u+F7vDCB4C+q4
0jYDRMfhVK0rtVzwQ6bGzE2+8SfY/rCak8ODAiVxXQ/UQxUR47pJR9TuY3bELGlU
4IrNURia2LS9VKjej8YWx51B8/NiAC6ve/lUL7xp3B2xWuWG+LzaTTLxpsEFVEFX
FXeHfcMIplef8ELNAseQE9KzpA7YKpKeEnENamsRYzVlxwvW3t3tjh5hM2bgV7Ir
0QzwmCS0go7n0pXBYwyR+crRWurJPmCLSRJq3EEO42rEQp9XcYiPLBsH4bPIlN7L
h4h1yRyw8KH1rL8uY+yAjNFz3/D9K2FAvWPCoswshEYiMuyf4BfI8W6XF8ANPGR8
D1OqKz/Lanf4iZSFtaAlTvX6cEiIn8oj4A+5jKp2IJqMqS0NevLqM2SAZbiIJ+un
M0CMaCD3iyyx+jiaZ0M34ufC01N/GdamvxvOVgTo3YyZgBvokDhhDAz8AcTigZhq
A/F9BRz1HdmvCb17S9tk
=Sw0H
-----END PGP SIGNATURE-----

--HcAYCG3uE/tztfnV--
