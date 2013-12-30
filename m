Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932082Ab3L3OxR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 09:53:17 -0500
Received: from ring0.de ([91.143.88.219]:50868 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755990Ab3L3OxP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 09:53:15 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	*  0.0 URIBL_BLOCKED ADMINISTRATOR NOTICE: The query to URIBL was blocked.
	*       See http://wiki.apache.org/spamassassin/DnsBlocklists#dnsbl-block
	*      for more information.
	*      [URIs: merproject.org]
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
Date: Mon, 30 Dec 2013 15:52:51 +0100
From: Sebastian Reichel <sre@ring0.de>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Marcel Holtmann <marcel@holtmann.org>,
        =?utf-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<freemangordon@abv.bg>,
        "Gustavo F. Padovan" <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>, Pavel Machek <pavel@ucw.cz>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org development" 
	<linux-bluetooth@vger.kernel.org>
Subject: Re: [PATCH v2] Bluetooth: Add hci_h4p driver
Message-ID: <20131230145250.GA16904@earth.universe>
Mail-Followup-To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	=?utf-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= <freemangordon@abv.bg>,
	"Gustavo F. Padovan" <gustavo@padovan.org>,
	Johan Hedberg <johan.hedberg@gmail.com>,
	Pavel Machek <pavel@ucw.cz>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	"linux-bluetooth@vger.kernel.org development" <linux-bluetooth@vger.kernel.org>
References: <1379703710-5757-1-git-send-email-pali.rohar@gmail.com>
 <1727897.LBX8128hIo@izba>
 <C8D1F470-7964-4EAC-82E0-D53CF54DE086@holtmann.org>
 <201312301531.29768@pali>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="SLDf9lqlvOQaIe6s"
Content-Disposition: inline
In-Reply-To: <201312301531.29768@pali>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SLDf9lqlvOQaIe6s
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Dec 30, 2013 at 03:31:25PM +0100, Pali Roh=C3=A1r wrote:
> [...] I think that correct commit message is not needed now.

Please add patch descriptions as early as possible. Patches without
descriptions are anoying for misc. reasons. It's not too much work
to do and helps everyone to understand what's going on. Especially
if the patch gets forgotten for some reason and somebody wants to
pick it up at a later time.

Wolfram Sang gave a talk about that at 30C3 yesterday. Official
recordings of his talk are not yet ready, but the live stream
has been recorded and uploaded to youtube:

http://www.youtube.com/watch?v=3DDjI7IFbvU0s (starting at 14:30)

> > > diff --git a/drivers/bluetooth/Kconfig
> > > b/drivers/bluetooth/Kconfig index 11a6104..95155c3 100644
> > > --- a/drivers/bluetooth/Kconfig
> > > +++ b/drivers/bluetooth/Kconfig
> > > @@ -242,4 +242,14 @@ config BT_WILINK
> > >=20
> > > 	  Say Y here to compile support for Texas Instrument's
> > > 	  WiLink7 driver into the kernel or say M to compile it as
> > > 	  module.
> > >=20
> > > +
> > > +config BT_HCIH4P
> > > +	tristate "HCI driver with H4 Nokia extensions"
> > > +	depends on BT && ARCH_OMAP
> >=20
> > Since then we moved away from doing hci_* prefix of drivers
> > since that is misleading. See btusb.ko, btmrvl_sdio.ko etc.
> >=20
> > So this might be better named BT_NOK_H4P or BT_NOKIA_H4P and
> > the module named btnok_h4p.ko or btnokia_h4p.ko.
> >=20
> > I still never understood what =E2=80=9Cp=E2=80=9D was for.
> >=20
>=20
> I do not know too, I did not invent that name. I just copied
> kernel driver from nokia kernel and patched it to work with 3.12.
>=20
> Maybe 'p' means plus (+) as H4+.

AFAIR there is a H4+ reference in the code, so I also guess H4P =3D
H4+.  Apart from that I assume, that it's meant as a short for "H4
plus some extensions"

> > Can we also make this just depend on some device tree
> > information and not on a specific architecture. I know that
> > this driver is pretty much OMAP specific, but if we want this
> > upstream, we should at least try to make it more generic.
> >=20
>=20
> Sebastian, can you look at code how hard is to add DT support?

I already have it on my TODO list.

> > > +MODULE_DESCRIPTION("Bluetooth h4 driver with nokia
> > > extensions"); +MODULE_LICENSE("GPL");
> > > +MODULE_AUTHOR("Ville Tervo");
> > > +MODULE_FIRMWARE(FW_NAME_TI1271_PRELE);
> > > +MODULE_FIRMWARE(FW_NAME_TI1271_LE);
> > > +MODULE_FIRMWARE(FW_NAME_TI1271);
> > > +MODULE_FIRMWARE(FW_NAME_BCM2048);
> > > +MODULE_FIRMWARE(FW_NAME_CSR);
> >=20
> > Do we actually have all these firmware files still available.
> > If not, then focus on the ones we have.
>=20
> Firmware files are available for download from nemo project:
>=20
> https://api.merproject.org/public/source/nemo:devel:hw:ti:omap3:n900/bcm-=
bt-firmware/bcm-bt-firmware-0.21rc3.tar.bz2
> https://api.merproject.org/public/source/nemo:devel:hw:ti:omap3:n950-n9/t=
i-wl1273-bt-firmware/bt-firmware-ti1273_0.23+0m6.tar.gz

Would be nice to have them added to the linux-firmware.git.

-- Sebastian

--SLDf9lqlvOQaIe6s
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBCAAGBQJSwYjCAAoJENju1/PIO/qa0KUP/1pyRNxIEOOUM+vrqvLyYD4+
GV0+HvloGtgEpF/Y22uaG6ATzQOxY/tzXLFwhEiE06+k49ybpVPZjPXqAJsmT4Fb
eTbN2SysigChTQ1NUpFbgXwvyy9x9zX/BC8Q3UYBvEsxXBckBXc85Wk+BQnqpUtU
5cB6riTx7FGtWnrnA8TNTxhB/cFCxDfX4NyZCdlOORw6gXJe4dP10icWLawIup4b
OAWLGhYzH/GEpTAZHjoioTKSzO1/X972TtMnlrFQNGEDlr1pvMZNetrRWI0wd2+Q
2qytNvimf69sUnbfymUI9giSymhC1NmEm3UgEDbsjll+kUSOGLIPEw/1zaWEVp4G
vTeOO6j4pwM+W2DcMm/LFa6HdbYuBuh6XJ1Xb7tcT7Mgp0ktbCa5aNLm/66IPA5C
AS7E+Dh3Evz3PNPtWwN8W1MlWe+uDxE6pT0dnWaRb/k24Suj/r24VeYjY8Dj5gnH
bahqyiZP0mfjgPp9GM/p/7zUt4d5tKcPl0g1egb4mLvCQW1ADKBaGf9TlinKeKPu
JK8rAT7KIc0CZ93E4UCm9kx8MbfD84OpTZ+dCv23b4moxlfa4thR7MLuiyFsNnGG
lxnqqyLJjRFf/s4FAKWrHRZLwnN9bANeZHoerfBsycM8kYfhbc4I22BoAaxHT7EN
zud6LjO4K9ccVijeJlnm
=hOse
-----END PGP SIGNATURE-----

--SLDf9lqlvOQaIe6s--
