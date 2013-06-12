Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757963Ab3FLSSz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 14:18:55 -0400
Received: from sauhun.de ([89.238.76.85]:33656 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757939Ab3FLSSv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 14:18:51 -0400
Date: Wed, 12 Jun 2013 20:20:47 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Oleksandr Dmytryshyn <oleksandr.dmytryshyn@ti.com>
Cc: Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5] i2c: omap: correct usage of the interrupt enable
 register
Message-ID: <20130612182046.GC3018@katana>
References: <1370245040-14753-1-git-send-email-oleksandr.dmytryshyn@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VywGB/WGlW4DM4P8"
Content-Disposition: inline
In-Reply-To: <1370245040-14753-1-git-send-email-oleksandr.dmytryshyn@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VywGB/WGlW4DM4P8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 03, 2013 at 10:37:20AM +0300, Oleksandr Dmytryshyn wrote:
> We've been lucky not to have any interrupts fire during the suspend
> path, otherwise we would have unpredictable behaviour in the kernel.
>=20
> Based on the logic of the kernel code interrupts from i2c should be
> prohibited during suspend. Kernel writes 0 to the I2C_IE register in
> the omap_i2c_runtime_suspend() function. In the other side kernel
> writes saved interrupt flags to the I2C_IE register in
> omap_i2c_runtime_resume() function. I.e. interrupts should be disabled
> during suspend.
>=20
> This works for chips with version1 registers scheme. Interrupts are
> disabled during suspend. For chips with version2 scheme registers
> writting 0 to the I2C_IE register does nothing (because now the
> I2C_IRQENABLE_SET register is located at this address). This register
> is used to enable interrupts. For disabling interrupts
> I2C_IRQENABLE_CLR register should be used.
>=20
> Because the registers I2C_IRQENABLE_SET and I2C_IE have the same
> addresses, the interrupt enabling procedure is unchanged.
>=20
> I've checked that interrupts in the i2c controller are still enabled
> after writting 0 to the I2C_IRQENABLE_SET register. With this patch
> interrupts are disabled in the omap_i2c_runtime_suspend() function.
>=20
> Patch is based on:
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
> tag: v3.10-rc2
>=20
> Verified on OMAP4430.
>=20
> Signed-off-by: Oleksandr Dmytryshyn <oleksandr.dmytryshyn@ti.com>

Kevin, I think you are fine with this patch now?


--VywGB/WGlW4DM4P8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRuLv+AAoJEBQN5MwUoCm2agoP/0Xdkhgc0bekBGA8p/GLMg37
5iCp2bk0l94wGbd4gG7PvpKGZDom9el2BFmmM9moE7K/58MDe0e/yqNSFBBjtwLT
Xbgbzul2t/kdmizJ5AXZ/LEKRSlc2fZV3WhgOTw3NyMi0mUvVP3YqtbPT4zgsq9D
c7jZ5ER05PxAFJyj6noMMR3DYHmBWbLYp17/E7cTvzVO2GnUTS2JuZbkgX7AT+tz
OST3AvdK883un8j9JHmHiQDHJh6qfA8dwbkIs42K/t8pZHF8JRocLOY8L04RUJO3
qfORi+dUcgYBLcgCpIxbuR4Y+EYcSwLJVPDtixQrOWMmb180PtlFc1909d6cKkqB
hZBEwnXdHkx10OjkT+4ens6yvZAh6/8q0MdKbG8RRPAQNlFvyKsDKRho16lz07yb
b8L+wlUqjDbzZ+pnrX+eXXba2whOn9vm0p17gAENL1hvl0HSQjCPaVrZMUEgMp6K
9jdI2mCaCkkVcDJSVfJizWJpgVvIi0sOobaNyzThJsqJle4G24kS3cPajjsj3HkX
i9cCwxhDKdIrY+o7E53ZqcO9v7ZlAe1TuMLfOi1cXBxQU1unOEtbxs0bAyvFUSzD
g7VJU/k01Gv7Dye0Eajn9qrtY2o6PJEeRm1gbkYngDHy/ndQ14UiyoQgXUv4hJam
bULgo8KlEVzHie4nRVco
=+2iR
-----END PGP SIGNATURE-----

--VywGB/WGlW4DM4P8--
