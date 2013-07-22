Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932260Ab3GVLEI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 07:04:08 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:48325 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932170Ab3GVLEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 07:04:06 -0400
Date: Mon, 22 Jul 2013 12:03:41 +0100
From: Mark Brown <broonie@kernel.org>
To: Andrea Adami <andrea.adami@gmail.com>
Cc: linux-mmc@vger.kernel.org, Chris Ball <cjb@laptop.org>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        Marko Katic <dromede@gmail.com>
Message-ID: <20130722110341.GR9858@sirena.org.uk>
References: <1374361668-3184-1-git-send-email-andrea.adami@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PEWkPmBCIbC5Tcj0"
Content-Disposition: inline
In-Reply-To: <1374361668-3184-1-git-send-email-andrea.adami@gmail.com>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] mmc: pxamci: Refactor regulator support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PEWkPmBCIbC5Tcj0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jul 21, 2013 at 01:07:48AM +0200, Andrea Adami wrote:

> The ADS7846 driver _requires_ the use of a voltage regulator
> or if not present, CONFIG_REGULATOR_DUMMY should be used for proper operation.
> This was made mandatory by the following commit:

No, CONFIG_REGULATOR_DUMMY should *never* be used in production.

> The ADS7846 in spitz machines is not connected to
> any power regulator so it needs CONFIG_REGULATOR_DUMMY enabled.

I don't think that's the case, it would be a very unusual piece of
silicon that was able to operate without power.  It may be that it's not
using a software controllable regulator but there will be one or more
power supplies.  Judging by your problem here it seems like there is
actually a software controllable regulator though...

> However, enabling CONFIG_REGULATOR and CONFIG_REGULATOR_DUMMY
> will break pxamci driver and cause the following error output:

This is why you should never use CONFIG_REGULATOR_DUMMY in production,
it's just a crutch to help things boot during development.

> Regulator support in pxamci_init_ocr() is not
> written with the existence of the dummy regulator driver in
> mind. It does not check the return value of mmc_regulator_get_ocrmask()
> and it will only fall back to platform data if no regulator was found.

No regulator driver should be written with CONFIG_REGULATOR_DUMMY in
mind.  My guess here is that your custom callbacks for this board should
be being replaced by a regulator, for example the fixed voltage
regulator if there's only one voltage supported.

--PEWkPmBCIbC5Tcj0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR7RGKAAoJELSic+t+oim9YkQP/11tnhVpDCcb9F0M8CafRWrb
uGb4LLPtNaCTac0r2JPt6RA6aeROEdX1eiwZxG6UiEn/HGkXsnSLw2DhYzd260mW
Aau8jwMhCuI1VfGYomc0c9IMBQoM+yo1nIAyKTYqvLr/eFHWrglgpNYEY7LIlyxd
NT94As+hf3zyM9Nul8HQ3iDkdJriGkaLf2/62IJ++CKNpvh4FwtqEBfXo1ycOgf0
mhPi5jWqx0fASYHkYptXHrKmSlKbDsbpzcDPgQBPE6IPMsiMTSW1zbDHlXPUyjI5
StJ/bd22ET7kPe13xMXbscMNtXfujdryaTmQFO4fQnfNRbMni1Il3wHJO+1eOsfJ
eXquimxrUXxU50h/YBWhlM61orVcMx5AXIoYW7dJATEEsQA+8IPpSiod3rFGRXxh
21Cy1y1/Eja4RACSkNit5lUJVw8hjGTox+cz5GgPg5fnah0BSl8/AzZlilf0d5Pf
/KuMnWwrELh1rXgCzaJZ8Ax5Gbo86bQ4H5uoM3SUAzyhA3mPMEgwLW/DIvK2aH8t
NroB3iV1mXk1eA30ePhlPoZocnY36VUSqrmTJZoRSD2mZNUBlCZ3bAjHWqj41xEe
dIFGKdStyL21CsTd0oS7wYaTAvICNkuUIFvd8jYcGsxmpXCJJJoQqnE2jqO+O4hj
wwFcnSzh/Ts81hsj26Z/
=F/nN
-----END PGP SIGNATURE-----

--PEWkPmBCIbC5Tcj0--
