Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327AbaCGNy4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 08:54:56 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41452 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752306AbaCGNyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 08:54:54 -0500
Message-ID: <5319CFA7.7040402@pengutronix.de>
Date: Fri, 07 Mar 2014 14:54:47 +0100
From: Marc Kleine-Budde <mkl@pengutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.3.0
MIME-Version: 1.0
To: Stanislav Meduna <stano@meduna.org>, wg@grandegger.com,
        linux-can@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>
Subject: Re: FlexCAN on i.MX28 interrupt flooding retrying send
References: <53197E8A.5050409@meduna.org> <53198753.8000900@pengutronix.de> <5319CB58.4070708@meduna.org>
In-Reply-To: <5319CB58.4070708@meduna.org>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="IHBpVPKpNi4vbRlWxnkJmRuUiCtuWTdqI"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--IHBpVPKpNi4vbRlWxnkJmRuUiCtuWTdqI
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 03/07/2014 02:36 PM, Stanislav Meduna wrote:
>> Adding the linux-can mailinglist to Cc.
>=20
> I am not subscribed so maybe that's why the original mail
> did not get through - I did Cc: linux-can@vger.kernel.org

My bad, linux-can was on Cc, but it arrived on linux-can late.

>> Your kernel is missing the patch:
>>
>> e358784 can: flexcan: fix mx28 detection by rearanging OF match table
>>
>> With this patch the CAN core properly detected as an mx28, so that bus=

>> errors stay disabled (unless you enable them). If you need bus errors =
to
>> detect not connected CAN busses, you need another patchset berr_limit,=

>> which is not yet mainline. I can repost it here, if you need it.
>=20
> Ah ok.
>=20
> Thank you, this probably points me to the right direction - I'll try
> to implement this behaviour in my kernel (unfortunately
> I cannot move to more recent one at the moment).

The flexcan driver in you kernel doesn't have the improvements for mx28,
i.e. that the bus error is not needed on that CAN core. I think for non
DT we never added that support.

Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--IHBpVPKpNi4vbRlWxnkJmRuUiCtuWTdqI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Icedove - http://www.enigmail.net/

iEYEARECAAYFAlMZz6cACgkQjTAFq1RaXHMYjgCdGlf3gH577VT96aw0cPFBefd8
65sAmwZ6AdIK9bhiIVb4UEnuCnD9WAXK
=Kgy0
-----END PGP SIGNATURE-----

--IHBpVPKpNi4vbRlWxnkJmRuUiCtuWTdqI--
