Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757724AbaKUGu6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 01:50:58 -0500
Received: from sauhun.de ([89.238.76.85]:48895 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750897AbaKUGu4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 01:50:56 -0500
Date: Fri, 21 Nov 2014 07:52:20 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Alexander Kochetkov <al.kochet@gmail.com>
Cc: linux-omap@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>, Felipe Balbi <balbi@ti.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: Re: [PATCH] i2c: omap: fix NACK and Arbitration Lost irq handling
Message-ID: <20141121065220.GD1480@katana>
References: <1416242517-29885-1-git-send-email-al.kochet@gmail.com>
 <1416330058-21473-1-git-send-email-al.kochet@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AkbCVLjbJ9qUtAXD"
Content-Disposition: inline
In-Reply-To: <1416330058-21473-1-git-send-email-al.kochet@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AkbCVLjbJ9qUtAXD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 18, 2014 at 09:00:58PM +0400, Alexander Kochetkov wrote:
> commit 1d7afc95946487945cc7f5019b41255b72224b70 (i2c: omap: ack IRQ in pa=
rts)
> changed the interrupt handler to complete transfers without clearing
> XRDY (AL case) and ARDY (NACK case) flags. XRDY or ARDY interrupts will be
> fired again. As a result, ISR keep processing transfer after it was alrea=
dy
> complete (from the driver code point of view).
>=20
> A didn't see real impacts of the 1d7afc9, but it is really bad idea to
> have ISR running on user data after transfer was complete.
>=20
> It looks, what 1d7afc9 violate TI specs in what how AL and NACK should be
> handled (see Note 1, sprugn4r, Figure 17-31 and Figure 17-32).
>=20
> According to specs (if I understood correctly), in case of NACK and AL dr=
iver
> must reset NACK, AL, ARDY, RDR, and RRDY (Master Receive Mode), and
> NACK, AL, ARDY, and XDR (Master Transmitter Mode).
>=20
> All that is done down the code under the if condition:
> if (stat & (OMAP_I2C_STAT_ARDY | OMAP_I2C_STAT_NACK | OMAP_I2C_STAT_AL)) =
=2E..
>=20
> The patch restore pre 1d7afc9 logic of handling NACK and AL interrupts, so
> no interrupts is fired after ISR informs the rest of driver what transfer
> complete.
>=20
> Note: instead of removing break under NACK case, we could just replace 'b=
reak'
> with 'continue' and allow NACK transfer to finish using ARDY event. I fou=
nd
> that NACK and ARDY bits usually set together. That case confirm TI wiki:
> http://processors.wiki.ti.com/index.php/I2C_Tips#Detecting_and_handling_N=
ACK
>=20
> In order if someone interested in the event traces for NACK and AL cases,
> I sent them to mailing list.
>=20
> Tested on Beagleboard XM C.
>=20
> Signed-off-by: Alexander Kochetkov <al.kochet@gmail.com>
> Fixes: 1d7afc9 i2c: omap: ack IRQ in parts
> Cc: <stable@vger.kernel.org> # v3.7+
>=20

Applied to for-current, thanks!


--AkbCVLjbJ9qUtAXD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUbuEkAAoJEBQN5MwUoCm2omEP/1TpprY/VbTARF16EQBG5zdF
DHP7rdfyCWswzoAZrpEBDn+U3w9qDxL/yDiJchJp9Qp7kBIoB1y37ICscOPE8dwK
ikQCzqnb3EABCZKVHQD6+7gzQYiUhz+jk1c4031wRRoe5U3SP14h1F9lAQomBSMB
H80FMO9VXLYqU5yNiS7eSRn/Pejcrx13FVQB5y8PQuLEC5+V9CST7hAaw1O08Ktq
q0FhMamma4+SJm5g5gR/3DdzgWb1Dmb5X2rR98/g9OejAmN0M4/BKTFa93sjZdAW
S2UIFNtxiAoH6qEgzrp5c6sGgiiIfyJQRQ6Y1RLa5DvF9bYOrPBnj5fsVoDKaaQH
tuGBSX+D7ZypytCiCNtJVeW7WxANlPFDJW4aV0047zC6OYRVgSg8uNbFtWa39S6R
f1TUwL50BKGo0+iGhXqAqcjmMIXXgs2kDK3oGU9hoF86IvOlSDUCb+bV1RsKtoNE
i7QqKd14XJeL5ogewgxjdGJkNQ83bGkCeE4KdgK9ct3CFl0MwHgvbV2OYzuB5BCu
geD3C/NMv/A6rI00Gf19BnXR7eg+pM8RDPdJ10jnHSZGaWLu0oltDDcJAw6AX3Jr
6ffXhAfHhwReN0fkHStt1/sf9rFUp0jJGvn+eE8XhIsrXjhMv3mCxdlvRv3tXJiT
x3BXRQqKPHeB4dpsRERZ
=8eVQ
-----END PGP SIGNATURE-----

--AkbCVLjbJ9qUtAXD--
