Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757680AbaCRSqq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 14:46:46 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59457 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757662AbaCRSqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 14:46:44 -0400
Message-ID: <5328947F.7070902@pengutronix.de>
Date: Tue, 18 Mar 2014 19:46:23 +0100
From: Marc Kleine-Budde <mkl@pengutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.3.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>
CC: Wolfgang Grandegger <wg@grandegger.com>,
        Markus Pargmann <mpa@pengutronix.de>,
        Benedikt Spranger <b.spranger@linutronix.de>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [patch 03/12] can: c_can: Make it SMP safe
References: <20140318171007.528610837@linutronix.de> <20140318171126.844179673@linutronix.de>
In-Reply-To: <20140318171126.844179673@linutronix.de>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="K2uvFKNjlNf1dOAWOnSaqPPwuQrgXHlnl"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--K2uvFKNjlNf1dOAWOnSaqPPwuQrgXHlnl
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 03/18/2014 06:19 PM, Thomas Gleixner wrote:
> The hardware has two message control interfaces, but the code only
> uses the first one. So on SMP the following can be observed:
>=20
> CPU0 	       	CPU1
> rx_poll()
>   write IF1	xmit()
> 		write IF1
>   write IF1		=09
>=20
> That results in corrupted message object configurations. The TX/RX is
> not globally serialized it's only serialized on a core.
>=20
> Simple solution: Let RX use IF1 and TX use IF2 and all is good.

Do both c_can and d_can have two control interfaces?

> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Otherwise, looks good.

Tnx,
Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--K2uvFKNjlNf1dOAWOnSaqPPwuQrgXHlnl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Icedove - http://www.enigmail.net/

iEYEARECAAYFAlMolH8ACgkQjTAFq1RaXHN5MQCbBmucP8ZFcoGpKLXMm9Ixz/VN
XGUAn0+IclBW2Mm1OvR74E3ysPOGX4I0
=k3+W
-----END PGP SIGNATURE-----

--K2uvFKNjlNf1dOAWOnSaqPPwuQrgXHlnl--
