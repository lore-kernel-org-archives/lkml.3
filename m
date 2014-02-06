Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756178AbaBFK6I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 05:58:08 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42486 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756135AbaBFK6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 05:58:06 -0500
Message-ID: <52F36AAA.9000704@pengutronix.de>
Date: Thu, 06 Feb 2014 11:57:46 +0100
From: Marc Kleine-Budde <mkl@pengutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.2.0
MIME-Version: 1.0
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Florian Vaussard <florian.vaussard@epfl.ch>,
        Wolfgang Grandegger <wg@grandegger.com>
CC: Andreas Larsson <andreas@gaisler.com>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 5/5] can: sja1000: of: add reg-io-width property for
 8, 16 and 32-bit register access
References: <1391175277-19833-1-git-send-email-florian.vaussard@epfl.ch> <1391175277-19833-6-git-send-email-florian.vaussard@epfl.ch> <52EBAE41.8060403@cogentembedded.com>
In-Reply-To: <52EBAE41.8060403@cogentembedded.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="GXkxwWb545oR4MXOXRBlnhG69k877C0W4"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--GXkxwWb545oR4MXOXRBlnhG69k877C0W4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 01/31/2014 03:08 PM, Sergei Shtylyov wrote:
> Hello.
>=20
> On 31-01-2014 17:34, Florian Vaussard wrote:
>=20
>> Add the 'reg-io-width' property for 8, 16 and 32-bit access, like
>> what is currently done with IORESOURCE_MEM_{8,16,32}BIT for non-OF
>> boot.
>=20
>> Signed-off-by: Florian Vaussard <florian.vaussard@epfl.ch>
>> ---
>>   drivers/net/can/sja1000/sja1000_platform.c | 16 ++++++++++++++--
>>   1 file changed, 14 insertions(+), 2 deletions(-)
>=20
>> diff --git a/drivers/net/can/sja1000/sja1000_platform.c
>> b/drivers/net/can/sja1000/sja1000_platform.c
>> index 50dece8..25122bf 100644
>> --- a/drivers/net/can/sja1000/sja1000_platform.c
>> +++ b/drivers/net/can/sja1000/sja1000_platform.c
>> @@ -102,8 +102,20 @@ static void sp_populate_of(struct sja1000_priv
>> *priv, struct device_node *of)
>>       int err;
>>       u32 prop;
>>
>> -    priv->read_reg =3D sp_read_reg8;
>> -    priv->write_reg =3D sp_write_reg8;
>> +    err =3D of_property_read_u32(of, "reg-io-width", &prop);
>> +    if (err)
>> +        prop =3D 1;
>> +
>> +    if (prop =3D=3D 4) {
>=20
>    This is asking to be a *switch* statement instead.

Good point, I'll send a v4.

Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--GXkxwWb545oR4MXOXRBlnhG69k877C0W4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Icedove - http://www.enigmail.net/

iEYEARECAAYFAlLzaqoACgkQjTAFq1RaXHNO1gCfb/yEcJjJwDr+JfgsIbzd+1rA
VXYAn10t+Ad+bq+d3MJuAwxFoiciVpSK
=bbVC
-----END PGP SIGNATURE-----

--GXkxwWb545oR4MXOXRBlnhG69k877C0W4--
