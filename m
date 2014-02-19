Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950AbaBSPH7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 10:07:59 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:48930 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753151AbaBSPH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 10:07:57 -0500
Date: Thu, 20 Feb 2014 00:07:29 +0900
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Yadwinder Singh Brar <yadi.brar01@gmail.com>,
        Sangbeom Kim <sbkim73@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Tomasz Figa <t.figa@samsung.com>
Message-ID: <20140219150729.GF2669@sirena.org.uk>
References: <1392282847-25444-1-git-send-email-k.kozlowski@samsung.com>
 <1392282847-25444-12-git-send-email-k.kozlowski@samsung.com>
 <CAKew6eWcwVm1EAUAdFu48y_O5puu+eGvGW3k6923MdXfMa3UAw@mail.gmail.com>
 <1392383156.12506.20.camel@AMDC1943>
 <20140214210502.GX4451@sirena.org.uk>
 <1392624454.3755.12.camel@AMDC1943>
 <20140218003555.GJ2669@sirena.org.uk>
 <1392711129.14646.9.camel@AMDC1943>
 <20140219040818.GQ2669@sirena.org.uk>
 <1392819540.12624.14.camel@AMDC1943>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3RdaoY0kx43CqfUw"
Content-Disposition: inline
In-Reply-To: <1392819540.12624.14.camel@AMDC1943>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 106.188.144.10
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 11/14] regulator: s2mps11: Add opmode for S2MPS14
 regulators
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3RdaoY0kx43CqfUw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 19, 2014 at 03:19:00PM +0100, Krzysztof Kozlowski wrote:

> As I understand the suspend mode (correct me if I'm wrong), the
> regulator core during suspend to mem:
> 1. Calls suspend_set_state().
> 2. rstate->disabled is true so the ops->set_suspend_disable() is called.
> 3. The ops->set_suspend_disable() function (implemented by the driver)
> disables the regulator (e.g. through I2C commands /regmap/).
> 4. During resume the regulator is enabled normal way (ops->enable(), I2C
> again).

No, set_suspend_disable() should *not* disable the regulator, it should
configure what the regulator will do when the hardware enters suspend
mode.  If we were just disabling the regulator there would be no point
in having a special operation, we could just use the normal operation.

> Possible problems:
> A. What happens if some driver using this regulator resumes earlier then
> regulator_suspend_finish()?

Nothing, if the system is not in suspend mode then configuring suspend
mode will have no impact.

> B. What happens if resuming regulator requires some other driver to be
> resumed earlier (e.g. I2C bus)? If regulator resumes before I2C bus then
> calling ops->enable() would fail.

It is expected that as part of exiting suspend mode the hardware will
revert to normal operational mode.

--3RdaoY0kx43CqfUw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTBMiuAAoJELSic+t+oim9n7cQAIGerpe1gXEf56eM6OpC8YvI
yiIexlbqwGC3+6Ux3sAFob2P/6LlNyxgrD2PMP5ZsodfIdgpLKY1lrkKa4O8UkBH
3gnKgYxinVBD6HClyJ3p4mLfjZ7Yaf8KiXpATmbIYMMm++sFR7Pn5w/tvlxJslip
fFRxvIIjvR3H9AdHcf/WPi746O3fp8aZhm7sOiEzLdm0kAgKBSqvRY7TUM84xERE
BDhA8QyQ9K2qXIqZEEcH19aZzmb8D/D3lZdhy15gGpPBwE4fW9nhTdmXup2re95/
MAOxZYdHbc/Q8cOVaqEHc0i8hQQzcnthjl3lcnHCGRBl5mDaI9YhvyV8GQHJhCa0
v5zRLzHKfvQdaVilRgP1f1AC7+bGpl8PyAOcIEWANo3wza3aw8AvoGt/vVDayNSP
5eLYW3HFwr6462xjujHvjfSYbP32NchvO7DC01n5Plyh+giwdeXCt3LQKwGdJ2y8
8H6/iUveLI/chpt4xFfesbO8ocA5A4UrH+IWoJzZe1kwn/gh8EazwTMUuL5alSmw
f3Ee6M7wiHigCsruYpOnDCV7SFFIQENPNpf/yETI/M2OLEoLjEsvWSOLdcCOlZyS
DdTZiU7DpJVydyN02DA/n31326T6DpyeOUNq0eyXriKUIuYfBfSB5WYhGsgucv/a
vUMhJIEK8lFsxhRhh7fO
=aR1Y
-----END PGP SIGNATURE-----

--3RdaoY0kx43CqfUw--
