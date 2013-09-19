Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216Ab3ISJgP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 05:36:15 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45805 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629Ab3ISJgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 05:36:13 -0400
Message-ID: <523AC589.5040006@pengutronix.de>
Date: Thu, 19 Sep 2013 11:36:09 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130518 Icedove/17.0.5
MIME-Version: 1.0
To: Andre Naujoks <nautsch2@gmail.com>
CC: davem@davemloft.net, Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 1/3] slip/slcan: added locking in wakeup function
References: <1379093833-4949-1-git-send-email-nautsch2@gmail.com> <1379093833-4949-2-git-send-email-nautsch2@gmail.com>
In-Reply-To: <1379093833-4949-2-git-send-email-nautsch2@gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="VACTNhKFEl9krSAacK6o99Mq1EP5LRWUW"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--VACTNhKFEl9krSAacK6o99Mq1EP5LRWUW
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 09/13/2013 07:37 PM, Andre Naujoks wrote:
> The locking is needed, since the the internal buffer for the CAN frames=
 is
> changed during the wakeup call. This could cause buffer inconsistencies=

> under high loads, especially for the outgoing short CAN packet skbuffs.=

>=20
> The needed locks led to deadlocks before commit
> "5ede52538ee2b2202d9dff5b06c33bfde421e6e4 tty: Remove extra wakeup from=
 pty
> write() path", which removed the direct callback to the wakeup function=
 from the
> tty layer.

What does that mean for older kernels?
(< 5ede52538ee2b2202d9dff5b06c33bfde421e6e4)

> As slcan.c is based on slip.c the issue in the original code is fixed, =
too.
>=20
> Signed-off-by: Andre Naujoks <nautsch2@gmail.com>
Acked-by: Marc Kleine-Budde  <mkl@pengutronix.de>

Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--VACTNhKFEl9krSAacK6o99Mq1EP5LRWUW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Icedove - http://www.enigmail.net/

iEYEARECAAYFAlI6xYkACgkQjTAFq1RaXHP3WQCfb9iLAgL99AkUY46wJgSpmFrL
cywAnAgai9lg5kttki3STC3xU5aweDXR
=4evM
-----END PGP SIGNATURE-----

--VACTNhKFEl9krSAacK6o99Mq1EP5LRWUW--
