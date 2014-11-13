Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933662AbaKMRpx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 12:45:53 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:36852 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933495AbaKMRpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 12:45:51 -0500
Date: Thu, 13 Nov 2014 17:44:05 +0000
From: Mark Brown <broonie@kernel.org>
To: Andrew Bresticker <abrestic@chromium.org>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        James Hartley <James.Hartley@imgtec.com>,
        Ezequiel Garcia <Ezequiel.Garcia@imgtec.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-spi@vger.kernel.org
Message-ID: <20141113174405.GJ3815@sirena.org.uk>
References: <1415848096-20079-1-git-send-email-abrestic@chromium.org>
 <1415848096-20079-3-git-send-email-abrestic@chromium.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KFqA3NAzXT9iu/Yo"
Content-Disposition: inline
In-Reply-To: <1415848096-20079-3-git-send-email-abrestic@chromium.org>
X-Cookie: Some optional equipment shown.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH V2 2/2] spi: Add driver for IMG SPFI controller
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--KFqA3NAzXT9iu/Yo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 12, 2014 at 07:08:16PM -0800, Andrew Bresticker wrote:

> +#ifdef CONFIG_PM_SLEEP
> +static int img_spfi_suspend(struct device *dev)
> +{
> +	struct spi_master *master =3D dev_get_drvdata(dev);
> +
> +	return spi_master_suspend(master);
> +}

This should really be checking that the device is runtime suspended and
disabling the clocks if not, if nothing else someone might be running
with !CONFIG_RUNTIME_PM. =20

One of these days we'll get runtime and system PM playing more
frictionlessly but not today.

--KFqA3NAzXT9iu/Yo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUZO3kAAoJECTWi3JdVIfQtLwH/RvmbswLLjnV97UEwcv5mbmt
O1MtBjlqfg64Ls6llZYSAjq1gInOzM4An3Wn36zEcHaYYRKiLLQPB5NO1qouTpVD
c09Zm9le2W2Rkw2f10gXQLOPeKSev7meTEk/c7Rh0TBHV6XKrDUDHzNPu8Cw8MuV
4+PyU0Q3liBdOG5qJTuCz/rGSfsBIHa8sn805Z2iIn8yfKo62VYHkQtfydJJ/UZt
wFgrtzZ8bChJ2csOh9CSGweXEzBGFKvVBPPGizx7LOUUuj+AO0DjJxFh4wWRCigw
myq5IxLOhLJoG4IMVngxM2wRbvcjupBxrygeTfJPrF9v+K+aQGo+AYa8mlJG84U=
=TciD
-----END PGP SIGNATURE-----

--KFqA3NAzXT9iu/Yo--
