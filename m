Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932993AbaFQONm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 10:13:42 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:45948 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932534AbaFQONk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 10:13:40 -0400
Date: Tue, 17 Jun 2014 15:12:54 +0100
From: Mark Brown <broonie@kernel.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Mike Turquette <mturquette@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Sjoerd Simons <sjoerd.simons@collabora.co.uk>,
        Daniel Stone <daniels@collabora.com>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20140617141254.GP5099@sirena.org.uk>
References: <1402941758-11216-1-git-send-email-javier.martinez@collabora.co.uk>
 <1402941758-11216-8-git-send-email-javier.martinez@collabora.co.uk>
 <20140616192500.GJ5099@sirena.org.uk>
 <53A01D54.10506@collabora.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HTXHNxsBjQ105pMi"
Content-Disposition: inline
In-Reply-To: <53A01D54.10506@collabora.co.uk>
X-Cookie: Ditat Deus.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 07/10] regulator: Add driver for Maxim 77802 PMIC
 regulators
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HTXHNxsBjQ105pMi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 17, 2014 at 12:49:56PM +0200, Javier Martinez Canillas wrote:
> On 06/16/2014 09:25 PM, Mark Brown wrote:

> >> +	config.dev = &pdev->dev;

> > Are you sure this shouldn't be the MFD?

> I just looked at regulator_register() and saw that it does rdev->dev.parent =
> dev, so yes this has to be the MFD.

Do the regulators manage to get their supplies?

> So, for now I thought it made sense to set the operating mode to normal on
> probe() but I'll change it to read from the hardware if that is better.

Yes, otherwise if the device is configured otherwise then when we change
the configuration we may break something.

> I guess I should check in the datasheet if a sane default operating mode for
> LDOs is expected when the chip is reseted or if this is left undefined and also
> if the bootloader already set this.

You can't do anything based on the particular bootloader you're using in
your current system, this has to work in other systems.

--HTXHNxsBjQ105pMi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJToEzjAAoJELSic+t+oim94pMP/0GKul0j4lmBWAiv6ExCujGe
2k6gUmT3JjPnAmaVdF158pnvuiIsHgqF8J4FkF9+gpIOdr8bQrbigyAesJM/6QrK
4+QIiteqcZRu48H7sljyPhOxZeMxUGsKSVF8N79p21YeJwh6XDUr2atflqorTCY4
exQwtoCmZEou8vp/Thy63T0My2DyAdm5P5+VaPdknOWW6p8PIzIgodET0XpnLWx2
JJmZE1GiddbVPuLRNbc8YFZDA6vJi0FVs3sIWJ3A1VuIAZ4NiAz5YTVlC/ftB5Qf
PnxQl0qc6ChJCPdQn0K5zy/8zlVQmt3+kbJUGnKzq1BF/1zhqtbiASOJWU8F901U
f7sZi5YUYKjmPRRQagV7H5l8WLFQqEc07reanHyXfw5V03CX5VCCQfLJ3O7Pldl5
agnElJnw8CrxPnZ3b78KTuxI6e/umIKJapt8Nx8+zEHjPmnX83ugMyaBCwzVQX2X
9sLRPHUTIDhqhTAjKpxK7rv51GodzaM8d8LUm8wfl5RmFibhFH0lDkCZ0PSZ2xO3
6gaxhghI/t9EbolrgIJRzsUfasfYUXyQbETJLUzf4GWUkGJrIf5AjknEOmVcq1Ov
2GJFRk5SYMDucx5aS0XiP5LlnZJ/NxwHQrNB2zn/+lLuVmxVDQEoG0nJ+xXW7qh9
UrRCEyOMpAyk34TJsu/Q
=UvUW
-----END PGP SIGNATURE-----

--HTXHNxsBjQ105pMi--
