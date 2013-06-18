Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933283Ab3FRSJx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 14:09:53 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:36360 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932812Ab3FRSJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 14:09:52 -0400
Date: Tue, 18 Jun 2013 19:09:48 +0100
From: Mark Brown <broonie@kernel.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Grant Likely <grant.likely@linaro.org>
Message-ID: <20130618180948.GP1403@sirena.org.uk>
References: <1371565785-31332-1-git-send-email-mika.westerberg@linux.intel.com>
 <1371565785-31332-2-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tSYSuzF6Gv/xq7Ry"
Content-Disposition: inline
In-Reply-To: <1371565785-31332-2-git-send-email-mika.westerberg@linux.intel.com>
X-Cookie: Tomorrow, you can be anywhere.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/2] spi/pxa2xx: use a flag to check if the device is
 runtime suspended
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tSYSuzF6Gv/xq7Ry
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 18, 2013 at 05:29:45PM +0300, Mika Westerberg wrote:
> Current code calls pm_runtime_suspended() in the interrupt handler to check
> if the device is suspended or not. However, runtime PM status of the device
> is only set to suspended once all PM runtime suspend hooks have executed.

> In our case we have the device bound to the ACPI power domain and its
> runtime suspend hook will put the device to D3hot (or D3cold if possible).
> This effectively means that the device is powered off before its state is
> set to runtime suspended. During this time, it might get an interrupt that
> is meant for another device (as the interrupt line is shared), and because
> the device is powered off accessing its registers will return 0xffffffff
> that the driver misinterprets as an invalid state. When this happens user
> will see messages like below on the console:

This sounds like a problem which will affect a lot of devices and hence
ought to be handled better by the PM core or at least frameworks in
general.  Is it really device specific?

--tSYSuzF6Gv/xq7Ry
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRwKJpAAoJELSic+t+oim9jdYP/3Sqb2sgX62xC0FQbzyDnhiQ
dO4tqVN/ZrgzWBEhkpILMS4XOyQ0gZ0Q5/qerJMM2chnKYbZNAFORefQ0/CulafF
/SP8iS3DXyPyzB3DHdXoRjLJdq/rThWVTBdoWrSbqAeZwlDayh8cTJRWOAT6CyC4
Dy7tcvgrNVeg/yLFXc9TpJ6SRQI48CsGLPNi3r3jPEb0y1lHgmEbs8p+MsDdSsyy
r6PFoegvKjoMQ70SziQn2F73Y3b9kt2YqWEiWobAgZQ1UQXqckOFJLjmtT1l1DnS
mpZmn0NhC/Kt6XUAQWgWh0GNZNyfinKYZSI0lrryqeiiiI6pAFJKFeREpsmmfKMP
1ml/QMziVOEYUomj+1vPM1Es31AY4jROKYFVP+pmwio4OKSkgDGuymG2XFD1qfJd
ZufVKUMnVmfmHDgrHn8JO0+kmdeWsMmbTks16uQD4r5w9XTN2KswUXl2c5e4ZNF1
TTqf1SDYBqjREbH37K/Dpk7PdSalqMRUiJEnL0VP/lh2aPC+D/7hOM/3NCR9t0xy
Xro7YKmpb9MlJTVXI6mGcf4Q1o3HexloTExD+QYfeECj2YJXIj2l8+Q7KKKiDdiM
SCovxClgc6lXcZEeo2pmUOmPitOhkCiLOhDD3EXy2agmWhbUQxjrPg3XPBDHkTgz
uirpjvyt4yYfsnCRZ+we
=jy6S
-----END PGP SIGNATURE-----

--tSYSuzF6Gv/xq7Ry--
