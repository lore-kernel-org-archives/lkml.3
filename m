Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753057AbbAMPvD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 10:51:03 -0500
Received: from sauhun.de ([89.238.76.85]:35823 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751931AbbAMPvA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 10:51:00 -0500
Date: Tue, 13 Jan 2015 16:50:59 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-i2c@vger.kernel.org,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c / ACPI: Pick the first address if device has multiple
Message-ID: <20150113155059.GN7660@katana>
References: <1419860928-195404-1-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="20XocjIeMTCm4X0r"
Content-Disposition: inline
In-Reply-To: <1419860928-195404-1-git-send-email-mika.westerberg@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--20XocjIeMTCm4X0r
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 29, 2014 at 03:48:48PM +0200, Mika Westerberg wrote:
> ACPI specification allows I2C devices with multiple addresses. The current
> implementation goes over all addresses and assigns the last one to the
> device. This is typically not the primary address of the device.
>=20
> Instead of doing that we assign the first address to the device and then
> let the driver handle rest of the addresses as it wishes.
>=20
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> Cc: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

Yes, seems better than what we do know. But maybe taking the lowest
address is a bit better heuristic than taking the first address?
Not sure, though...

> ---
>  drivers/i2c/i2c-core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
> index 39d25a8cb1ad..a06be43b7842 100644
> --- a/drivers/i2c/i2c-core.c
> +++ b/drivers/i2c/i2c-core.c
> @@ -102,7 +102,7 @@ static int acpi_i2c_add_resource(struct acpi_resource=
 *ares, void *data)
>  		struct acpi_resource_i2c_serialbus *sb;
> =20
>  		sb =3D &ares->data.i2c_serial_bus;
> -		if (sb->type =3D=3D ACPI_RESOURCE_SERIAL_TYPE_I2C) {
> +		if (!info->addr && sb->type =3D=3D ACPI_RESOURCE_SERIAL_TYPE_I2C) {
>  			info->addr =3D sb->slave_address;
>  			if (sb->access_mode =3D=3D ACPI_I2C_10BIT_MODE)
>  				info->flags |=3D I2C_CLIENT_TEN;
> --=20
> 2.1.4
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-i2c" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--20XocjIeMTCm4X0r
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUtT7iAAoJEBQN5MwUoCm2fMEP/3pNQ4grR9mUkxah4zFyf/ER
r0U5tqD2VsaPj0sJMauYLXPJ3G8t148+WVdn07XJRREtBIKepleacim4Vbuwgc2D
kiI+ipcrq8I3ixTVjmOnRqbCr0vJs6jZkZC+PBxlEm+n+s8TOdUbpSwS5tZ4V5IX
tVSaYjkf7bHpD4+0sCDUPSa2X6dCBbDnRqa+ZuyAZV9JagHJfQM5EnIygXiXMVLM
obFP8Ctq0DAYalG74XIkvQR451a7820A5MmdJZTRIzL+LkEw53v9nbX8QgdpP9dZ
5/K/3xrnmFDzVMdmMaqvP15Cg9zl/Bs/CXvXXM60sDWSLtlvZJX2uMJXvSHyh9L+
QxQnXnHHp2wDSdm/NshcO4DQzdB8UzxtaWMs0w8CttlHEP0eVm2fWIeM9SanXLRF
B7OLnqrrmpIOGy6LiH8djSs0VJmZ7RpbeCiiKwn/qB/qIzYqFpovs/YdVt1ILQdu
EJpLnLQzFtxUpDGfvQRz+1xj32lXoiAgzgXsNNBYZ5pm3rWElqLs7qZTy9uon3sG
WNQhmpYYLKr5VpHsL9XQpnoevICfbnksJepen666hwSQQKFg10AxxGdJMxd08m5a
ylDRUJaWssCGZkvmMqRlHEcgMFxeyZ2uKw8lvsCizQBNWsa3a3p0vCOTxC5wqDZF
u1GYOO5OHmZ2IPV9vryL
=CRnM
-----END PGP SIGNATURE-----

--20XocjIeMTCm4X0r--
