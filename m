Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759259AbaGYNGW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 09:06:22 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35271 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109AbaGYNGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 09:06:21 -0400
Message-ID: <53D2563B.1090703@pengutronix.de>
Date: Fri, 25 Jul 2014 15:06:03 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Wolfram Sang <wsa@sang-engineering.com>,
        Mugunthan V N <mugunthanvnm@ti.com>
CC: Wolfgang Grandegger <wg@grandegger.com>, Pavel Machek <pavel@denx.de>,
        Thor Thayer <tthayer@altera.com>,
        Prabhakar Lad <prabhakar.csengg@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Chen Gang <gang.chen@asianux.com>,
        George Cherian <george.cherian@ti.com>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [can-next PATCH 1/1] net: can: c_can_platform: Use devm_ioremap
 instead of devm_ioremap_resource.
References: <1406269181-4092-1-git-send-email-mugunthanvnm@ti.com> <4a97162dedd6ab064e83c52757f2ce42@mail.zeus03.de>
In-Reply-To: <4a97162dedd6ab064e83c52757f2ce42@mail.zeus03.de>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="duembwfNjUBjNsAK8or8Qhho4rhcAMHTq"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--duembwfNjUBjNsAK8or8Qhho4rhcAMHTq
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 07/25/2014 12:49 PM, Wolfram Sang wrote:
> Am 25-07-2014 08:19, schrieb Mugunthan V N:
>> From: George Cherian <george.cherian@ti.com>
>>
>> The raminit register is shared register for both can0 and can1.
>> Using devm_ioremap_resource fails the mapping for can1 interface
>> leading to a non functional can interface.
>>
>> Signed-off-by: George Cherian <george.cherian@ti.com>
>> Signed-off-by: Mugunthan V N <mugunthanvnm@ti.com>
>=20
> The patch is a hack, or? It simply works because we drop all sanity
> checking on the resource.

Well, thinking about it, yes, a bit.

> I am on holiday and can't really check, yet I believe the AM335x has
> devicetree support for accessing single bits in SYSCONF. This is what
> needs to be applied here, too, AFAICT.

I cannot find any generic driver for the sysconf, USB and Ethernet have
an extra driver for their shared register space. I think the d_can can
access the raminit register via a syscon driver.

Enjoy your holiday :)
Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--duembwfNjUBjNsAK8or8Qhho4rhcAMHTq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Icedove - http://www.enigmail.net/

iEYEARECAAYFAlPSVjsACgkQjTAFq1RaXHMPMACfUlhII5nD4DcN1u5YEoXtVeUZ
hP8Ani5sxhhe6a6WfzL48KqolRBU1Bt+
=sQbT
-----END PGP SIGNATURE-----

--duembwfNjUBjNsAK8or8Qhho4rhcAMHTq--
