Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468Ab3ISKfN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 06:35:13 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44021 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774Ab3ISKfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 06:35:11 -0400
Message-ID: <523AD356.70607@pengutronix.de>
Date: Thu, 19 Sep 2013 12:35:02 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130518 Icedove/17.0.5
MIME-Version: 1.0
To: Andre Naujoks <nautsch2@gmail.com>
CC: davem@davemloft.net, Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 1/3] slip/slcan: added locking in wakeup function
References: <1379093833-4949-1-git-send-email-nautsch2@gmail.com> <1379093833-4949-2-git-send-email-nautsch2@gmail.com> <523AC589.5040006@pengutronix.de> <523AD21C.8030102@gmail.com>
In-Reply-To: <523AD21C.8030102@gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="Bsi90GNntWM4JHFX1pg3u0Mev0Ak7vCkD"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Bsi90GNntWM4JHFX1pg3u0Mev0Ak7vCkD
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 09/19/2013 12:29 PM, Andre Naujoks wrote:
> On 19.09.2013 11:36, schrieb Marc Kleine-Budde:
>> On 09/13/2013 07:37 PM, Andre Naujoks wrote:
>>> The locking is needed, since the the internal buffer for the CAN
>>> frames is changed during the wakeup call. This could cause buffer
>>> inconsistencies under high loads, especially for the outgoing
>>> short CAN packet skbuffs.
>>>
>>> The needed locks led to deadlocks before commit=20
>>> "5ede52538ee2b2202d9dff5b06c33bfde421e6e4 tty: Remove extra
>>> wakeup from pty write() path", which removed the direct callback
>>> to the wakeup function from the tty layer.
>>
>> What does that mean for older kernels? (<
>> 5ede52538ee2b2202d9dff5b06c33bfde421e6e4)
>=20
> It seems the slcan (and slip) driver is broken for older kernels. See
> this thread for a discussion about the patch in pty.c.
>=20
> http://marc.info/?l=3Dlinux-kernel&m=3D137269017002789&w=3D2

Thanks for the info.

> The patch from Peter Hurley was actually already in the queue, when I
> ran into the problem, and is now in kernel 3.12.
>=20
> Without the pty patch and slow CAN traffic, the driver works, because
> the wakeup is called directly from the pty driver. That is also the
> reason why there was no locking. It would just deadlock.
>=20
> When the pty driver defers the wakeup, we ran into synchronisation
> problems (which should be fixed by the locking) and eventually into a
> kernel panic because of a recursive loop (which should be fixed by the
> pty.c patch).
>=20
> Maybe it is possible to get both patches back into the stable branches?=


Sounds reasonable. You might get in touch with Peter Hurley, if his
patch is scheduled for stable. Documentation/stable_kernel_rules.txt
suggests a procedure if your patch depends on others to be cherry picked.=


Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--Bsi90GNntWM4JHFX1pg3u0Mev0Ak7vCkD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Icedove - http://www.enigmail.net/

iEYEARECAAYFAlI601YACgkQjTAFq1RaXHMlCwCfSTLHbAtsj/i+0htOE0sXkr1u
49kAoI3MAPyf3rZyT3NSCxyJpTGgVZsM
=0A5A
-----END PGP SIGNATURE-----

--Bsi90GNntWM4JHFX1pg3u0Mev0Ak7vCkD--
