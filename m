Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751219AbaAGLqF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 06:46:05 -0500
Received: from ring0.de ([91.143.88.219]:55372 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751168AbaAGLp4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 06:45:56 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
Date: Tue, 7 Jan 2014 12:45:53 +0100
From: Sebastian Reichel <sre@ring0.de>
To: Satish Patel <satish.patel@ti.com>
Cc: Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob@landley.net" <rob@landley.net>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH v1 2/5] misc: tda8026: Add NXP TDA8026 PHY driver
Message-ID: <20140107114552.GA900@earth.universe>
Mail-Followup-To: Satish Patel <satish.patel@ti.com>,
	Mark Rutland <mark.rutland@arm.com>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"arnd@arndb.de" <arnd@arndb.de>,
	"gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"rob@landley.net" <rob@landley.net>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
References: <1389010062-17185-1-git-send-email-satish.patel@ti.com>
 <1389010062-17185-3-git-send-email-satish.patel@ti.com>
 <20140106153033.GB24664@e106331-lin.cambridge.arm.com>
 <52CBA075.8080506@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="Qxx1br4bt0+wmkIi"
Content-Disposition: inline
In-Reply-To: <52CBA075.8080506@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Qxx1br4bt0+wmkIi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 07, 2014 at 12:06:37PM +0530, Satish Patel wrote:
> >> +       if (pdata->irq =3D=3D 0) {
> >> +               /* look for the field irq-gpio in DT */
> >> +               irq_gpio =3D of_get_named_gpio(np, "irq-gpio", 0);
> >> +               if (!gpio_is_valid(irq_gpio)) {
> >> +                       dev_err(dev, "Failed to get irq gpio,\n");
> >> +                       return -EIO;
> >> +               }
> >=20
> > This is horrible. If the gpio controller can act as an irq controller
>=20
> No it's not true. Let me clarify the signal flow,
>=20
> Pins =3D> GPIO =3D> GPIO BANK =3D> Interrupt controller =3D> CPU/MPU

This is done automatically if you use the gpio controller as
interrupt source (here with GPIO line 22 as example):

device-tree-node {
    interrupts-extended =3D <&gpio1 22>;
};

alternatively, but then the irqs from the normal irq controller
can't be used:

device-tree-node {
    interrupt-parent =3D <&gpio1>;
    interrupts =3D <22>;
};

-- Sebastian

--Qxx1br4bt0+wmkIi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBCAAGBQJSy+jwAAoJENju1/PIO/qaOIoP/0tsaStyDB2S3j3R6eoEEiST
rytQS559jkb5Q37AOXKuc+4+oNqkGj8y/26VppiefRZnKlYHQ8cesPs2USh0Xhkq
agd43W6Oha7iPZajrbc0pmx7Wc/xq4vKHNJEQ8KiQLOLOm6zDAPDenTH3SUJoVzw
Eq8ms/a0at/hAo8sLy+yH+ugaX9QeE9c9/QA9vx1wtkxfY4D/83PwjiRmUDoB1NS
QE4Iaulf3/Vit4YdJWpj2BJhPiyhBmF3+xi2ePGJ5zIlT/nIABi4JxhhemSYcO5h
14cFQnBpkG/rzekBav2vRL62f5QIagQOI1PhQ5Vz9qWTyftWW4ZEl6liJf9Sj3c0
gcmxnk914WzNwK47smryCt5B/juAS+njSlVLbaiuNglUb3JVbzmG7M3X/d9XB15V
ZNPvfyqy6juEKEjudXF1kcKAm9GGLXMCdrWDoVl4dbemC+eDP7U6C3581jOgTlNV
o73nQd2SdWEPy3qBIebq4hqWCA45aSJXg4nu4s9M4d0cZvL1TYpAcciSYFOxpVSN
r9Gao3vrWNhatA7R4mvuEwJXFkYFvxXjFXPVZJ0JQYUKoSeizg78qTlZLpfj+cv9
NkLpqmYJ6W8Jkevex8EjDkUW2sCbAT9ErEsMs2Skbe+HXaGqNqhCJMcr9UkvEaM2
07oTIH9E+Yq5sVVRm0aS
=H4KI
-----END PGP SIGNATURE-----

--Qxx1br4bt0+wmkIi--
