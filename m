Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934442Ab3FSKDK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 06:03:10 -0400
Received: from sauhun.de ([89.238.76.85]:41986 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933830Ab3FSKDI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 06:03:08 -0400
Date: Wed, 19 Jun 2013 12:05:09 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Oleksandr Dmytryshyn <oleksandr.dmytryshyn@ti.com>
Cc: Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5] i2c: omap: correct usage of the interrupt enable
 register
Message-ID: <20130619100509.GD2950@katana>
References: <1370245040-14753-1-git-send-email-oleksandr.dmytryshyn@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wLAMOaPNJ0fu1fTG"
Content-Disposition: inline
In-Reply-To: <1370245040-14753-1-git-send-email-oleksandr.dmytryshyn@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wLAMOaPNJ0fu1fTG
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

Last paragraph should be below "---".

>=20
> Verified on OMAP4430.
>=20
> Signed-off-by: Oleksandr Dmytryshyn <oleksandr.dmytryshyn@ti.com>

Applied to for-next, thanks!


--wLAMOaPNJ0fu1fTG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRwYJUAAoJEBQN5MwUoCm2j4AP/1F5wnUamC3jUqG125RbwgIh
zT2GN9bn/zV1QfLjLfECgfbhTXxtyjg9QQk+4Cl+EzaEAgRO6zYh/HmCHLNdCl7k
7pcF6XLJQ4GSyCRlPUn8nvdk1/hRZnQRXSUbBMx8bhEaSgqSmARJxwlVAmn/HVJv
1cPaT+WAIw/zYBWx4LtTvcimDO5K24gQMpn7GD7Ptjf3YqHzKhA/2QDVmmK6e6aC
BI7QIj69FqfljcAPvxT3Gis/2Ph/wyamrN1SSdlmZ3U6A0Ag8A0A37pizYHETg14
XHIJjiK5O/IIzuKlxZ/FD5Bg+hRY65NXjL08QmTbM3TYJH/WLzZ6zh7WMh4J5rtv
KXqM1nM0r/BKpUF16jPu2Q14gU6nhnq8Ad3NupTX2o1RPPmF+mwaKKVYfOCXJSqj
XsaJFuRvtBV10Oa2ta1ID1PZHL3yepfUbRxdDHw8ZcxMVlsQLzHEsFImo0Mkghc0
EZNs2JIYy4tk+eIFtadntCYj43mufA9FSN/b8pWrcxWJQJl80tHIy4wdhfykUpPW
CfjZCwsFCYb/FXaDvw0ddodjJUTDhLVEEGfO4i/KdwAJzdM1tpC17Y5aGoLn7Sjd
zzaAQpaHkJQXaA596oEEAl98mPhsmWB/m5ohZ9rEEubOv6CE9b7xci7IpGSt/u2C
0V7X0DGAqSpp7eF+2OqX
=Y/pC
-----END PGP SIGNATURE-----

--wLAMOaPNJ0fu1fTG--
