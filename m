Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753583Ab3KNM6W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 07:58:22 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:53955 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752902Ab3KNM6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 07:58:20 -0500
Date: Thu, 14 Nov 2013 12:58:13 +0000
From: Mark Brown <broonie@kernel.org>
To: Caizhiyong <caizhiyong@hisilicon.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Wanglin (Albert)" <albert.wanglin@hisilicon.com>,
        Levente Kurusa <ilevex.linux@gmail.com>,
        Levente Kurusa <levex@linux.com>
Message-ID: <20131114125813.GP26614@sirena.org.uk>
References: <C3050A4DBA34F345975765E43127F10F1C08B5D7@szxeml512-mbs.china.huawei.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5G50dybFf3pRZKd7"
Content-Disposition: inline
In-Reply-To: <C3050A4DBA34F345975765E43127F10F1C08B5D7@szxeml512-mbs.china.huawei.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 149.254.58.211
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regmap: Fix 'ret' would return an uninitialized value
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5G50dybFf3pRZKd7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 11, 2013 at 11:35:52AM +0000, Caizhiyong wrote:

> +	int ret = 0;

With the if statement below you probably don't need to do this any more.

> +	if (num_regs <= 0) {
> +		WARN_ONCE(1, "Call regmap_register_patch with num_regs <= 0.");
> +		return 0;
> +	}

WARN_ONCE actually returns the result of the test so you should be able
to write this as:

	if (WARN_ONCE(num_regs <= 0))
		return 0;

which is slightly neater.

--5G50dybFf3pRZKd7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJShMjiAAoJELSic+t+oim9mbEP/09Xp1jsGBm3QckkSUXtcITY
Itj805snAVsH+XinVeEdqPpDsyfyC4kB1+vxWVNoL5RqcxqBsKXnVx1TWc0BE4/e
407T6ilBMUEGKreEm5nW5CxnlhrHwTQtzJ21wsMvuzOq06SGfAdPVyTDMcSdcxQ/
EcJwVEAhpGWknMTcetq9dRXL9/HvmKSlJoG8/6fUHK4MsyxXM9Eeu26G1BdgLhuH
ZrMTCcCWv7BzriXm7+8mp6w0xL53xOh6lDVBG6z8IyfLwXAtjIxd98JFnnbOTwZv
LvkchZ/UAImNa9tUUz5O6tvudyq1hyC5225Gt6i0CLMp8T5iyzpU0yhoWOUeYLC4
HMI0EzD141NZ0el1b6I+Ty+pAZ8AbvW1aUXFlUZNw7NGbiQB7/ZDSXdIjp65maxU
7dvnlZhQWf+DDjHlQbO773zyRWyPrZfVosVGNzMeRgRE2IOpHGyyhTPexR3kBbyw
MJdvcdpuTdvhLwdEvkt0kGsD3zCo1QC/iUPpO5oriiHwQdspD5vwkcUVaPd8j6Ey
6DqvNiYMrYFShP9GpPwAWPZSGoFYZszlIl++fFY578JTHPswu2/MieWg+lGhitSx
NXttkHTgzp6S+a9j6jlyuLFffDq0tGdFKd2zDVIQgAwITiGsFEAigO0u3pQ+MqjK
cLpQdgB2qA18FqACkFoB
=bt5H
-----END PGP SIGNATURE-----

--5G50dybFf3pRZKd7--
