Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751634AbaANSiv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 13:38:51 -0500
Received: from sauhun.de ([89.238.76.85]:48352 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751472AbaANSis (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 13:38:48 -0500
Date: Tue, 14 Jan 2014 19:38:45 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: RAGHAVENDRA GANIGA <ravi23ganiga@gmail.com>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] i2c: i2c-core: fix coding style issues in i2c-core.c
Message-ID: <20140114183845.GD10340@katana>
References: <525C0CDB.6020305@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GyRA7555PLgSTuth"
Content-Disposition: inline
In-Reply-To: <525C0CDB.6020305@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GyRA7555PLgSTuth
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


> --- a/drivers/i2c/i2c-core.c
> +++ b/drivers/i2c/i2c-core.c
> @@ -1737,9 +1737,9 @@ int i2c_transfer(struct i2c_adapter *adap, struct i2c_msg *msgs, int num)
>  		for (ret = 0; ret < num; ret++) {
>  			dev_dbg(&adap->dev, "master_xfer[%d] %c, addr=0x%02x, len=%d%s\n",
>  				ret,
> -				((msgs[ret].flags & I2C_M_RD) ? 'R' : 'W'),
> +				msgs[ret].flags & I2C_M_RD ? 'R' : 'W',
>  				msgs[ret].addr, msgs[ret].len,
> -				(msgs[ret].flags & I2C_M_RECV_LEN) ? "+" : "");
> +				msgs[ret].flags & I2C_M_RECV_LEN ? "+" : "");

Don't spend time changing too much here like the paranthesis. It will
probably be removed soon in favour of the tracing approach.

> @@ -2120,7 +2120,8 @@ EXPORT_SYMBOL(i2c_smbus_read_byte);
>  s32 i2c_smbus_write_byte(const struct i2c_client *client, u8 value)
>  {
>  	return i2c_smbus_xfer(client->adapter, client->addr, client->flags,
> -				I2C_SMBUS_WRITE, value, I2C_SMBUS_BYTE, NULL);
> +			      I2C_SMBUS_WRITE, value,
> +			      I2C_SMBUS_BYTE, NULL);

Not worth the change IMO. Just drop this patch.


--GyRA7555PLgSTuth
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJS1YQ1AAoJEBQN5MwUoCm2cWUP/iPQ/gtly2Xlct1tCpcpehdR
6BURkU26U5+BKU4dmJUoBkgt3ipC6lvID8mKyV2/pFipv0n8yTjnllP4W/6eckTU
y2F9craZizBgLE2XQVT4LDtUBuf9AqoI4ynjLIePHVU35WmwkBJ+rjTJ/C+tU2pQ
kFQxWrAthhtxiyPWFO+0kQyu3KB82T8fpxXnHIlKk35bRhV9elmUZk5UDcwR7c3v
1UhyK5ELfj/ANAmZqb2T8SefTMM84HVyfrUYt02To0uERZShMKGuhwaHA5dktz+N
h9P+QAFO5+ksGQdCLiLeFSSIsx/wFMaeh5pO8nS6Ie25+/JPFRfoQb3KyGQ2DZDo
lUuD1A+c+/it6O6jiwjz1VjiCvqLSvaVeCYw7EdSLpGbu6JO1+mUciTk/+QLOPqC
33evlEyvxm7ntyZVy/Bf2/0/Wmv0o1BGGJ/4CTBxU2l2HKyJrGtEM8hwQg6vQXwr
FW7FxShTYWZEVHhNLJpanjRU+LnFrQOfBbzhkp7mfZBvwTCKKm2qHSwYR0DBtgji
SubgrGxHshRsxJOlytW+10e3abgYs/wKZZeSTpBLnvGeaBCYnUTHLtJOq2V/Srmn
Bg/ue1p2r+oi1P9426cArbxk2nDRQn+rvKyEPQ4P4DImROjYAAsmHN6A8+XQNJST
L6dNMjA8g/OSqSx3Y6Pk
=N2k1
-----END PGP SIGNATURE-----

--GyRA7555PLgSTuth--
