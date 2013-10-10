Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755136Ab3JJIJ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 04:09:29 -0400
Received: from sauhun.de ([89.238.76.85]:45152 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752251Ab3JJIJZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 04:09:25 -0400
Date: Thu, 10 Oct 2013 10:09:19 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-acpi@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Aaron Lu <aaron.lu@intel.com>,
        Lv Zheng <lv.zheng@intel.com>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] i2c: attach/detach I2C client device to the ACPI
 power domain
Message-ID: <20131010080919.GC2638@katana>
References: <1381327461-10562-1-git-send-email-mika.westerberg@linux.intel.com>
 <1381327461-10562-3-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GZVR6ND4mMseVXL/"
Content-Disposition: inline
In-Reply-To: <1381327461-10562-3-git-send-email-mika.westerberg@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GZVR6ND4mMseVXL/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 09, 2013 at 05:04:20PM +0300, Mika Westerberg wrote:
> From: Lv Zheng <lv.zheng@intel.com>
>=20
> If the I2C client device is enumerated from ACPI namespace it might have
> ACPI methods that needs to be called in order to transition the device to
> different power states (such as _PSx).
>=20
> Implement this for I2C client devices by checking if the device has an AC=
PI
> handle and if that's the case, attach it to the ACPI power domain. In
> addition we make sure that the device is fully powered when its ->probe()
> function gets called.
>=20
> For non-ACPI devices this patch is a no-op.
>=20
> Signed-off-by: Lv Zheng <lv.zheng@intel.com>
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> ---
>  drivers/i2c/i2c-core.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>=20
> diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
> index 29d3f04..f25dee3 100644
> --- a/drivers/i2c/i2c-core.c
> +++ b/drivers/i2c/i2c-core.c
> @@ -254,10 +254,16 @@ static int i2c_device_probe(struct device *dev)
>  					client->flags & I2C_CLIENT_WAKE);
>  	dev_dbg(dev, "probe\n");
> =20
> +	if (ACPI_HANDLE(&client->dev))
> +		acpi_dev_pm_attach(&client->dev, true);

I'd prefer to drop the 'if's in case they are checked inside the acpi_*
calls anyway. Not a show-stopper, though, so:

Acked-by: Wolfram Sang <wsa@the-dreams.de>


--GZVR6ND4mMseVXL/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJSVmCvAAoJEBQN5MwUoCm2vX8QAIm6y2W45orHnvxDkqZb5hO/
RWmYovEd9GccUoCJWLRh3vZusjDM6bOsMqPmfkuLZ93s/Tk2j6DpnRj/2yNiwF4/
DuyP8GEdQwN1b9Jjhy7EAqeeZY/qcuhu6C0yWQw9A7lmECDDIDoGKMkXpA3s28vc
Y+HGJjlzkagV58akwrvnA2VievfpgteXTmLj+lRl4Dm3G+uQAx8L8f1TbIRhxazB
qYwcATmEfy8eiu8JNIhBo+mFLc2r2E8UtExyHx0MwQv62lPK0Xz1XJUjUM/W0uhr
7YRwd2+5+cjW8u7XCJ0uz0H+prVLnLryOq78zpbb63eWpeC8TD0MEqzq2BQ2JqXI
Xpz/u4/eIfMVZfXZw2UJ+rg047Jw36H4WaLd+3SBpoJeuWEfVtmKjGrgjj3a17u+
ky7zoQ3O36GxKgALPmD1Jc7HVxuVrgDYBQ1xyJY+cugqUN9O3hMPeeUl6/SpXEtL
aVw3Kl94QgG0X0vJLRQdDzv6vXMNZ1vWtHnBTr+7ur+BOGHIYKt8Iz6XY37gzGU+
VV/m7ZjDL3EBPSgDymAT/90VnZ7HGRsbrZb6mPe2enPBWR9T1st0QWQcedH0dsQ6
9qzfKob4p2XQUBrpu04JU36Gc3WgyfFFez+GS+T0E7FmqZzt382L5Y5Lf46HZwGc
oEjJvr5zlpDKVk8Z5SLq
=JPAE
-----END PGP SIGNATURE-----

--GZVR6ND4mMseVXL/--
