Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754494AbaBTMv5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 07:51:57 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:47419 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754448AbaBTMvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 07:51:55 -0500
Date: Thu, 20 Feb 2014 21:51:30 +0900
From: Mark Brown <broonie@kernel.org>
To: Markus Pargmann <mpa@pengutronix.de>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel@pengutronix.de,
        stable@vger.kernel.org
Message-ID: <20140220125130.GQ2669@sirena.org.uk>
References: <1392894472-11956-1-git-send-email-mpa@pengutronix.de>
 <1392894472-11956-3-git-send-email-mpa@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="F85KFVxTQmf/0nzl"
Content-Disposition: inline
In-Reply-To: <1392894472-11956-3-git-send-email-mpa@pengutronix.de>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 106.188.156.234
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 2/2] regulator: core: Replace direct ops->disable usage
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--F85KFVxTQmf/0nzl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 20, 2014 at 12:07:52PM +0100, Markus Pargmann wrote:

> --- a/drivers/regulator/core.c
> +++ b/drivers/regulator/core.c
> @@ -1908,8 +1908,6 @@ static int _regulator_do_disable(struct regulator_d=
ev *rdev)
> =20
>  	trace_regulator_disable_complete(rdev_get_name(rdev));
> =20
> -	_notifier_call_chain(rdev, REGULATOR_EVENT_DISABLE,
> -			     NULL);
>  	return 0;
>  }
> =20
> @@ -1933,6 +1931,8 @@ static int _regulator_disable(struct regulator_dev =
*rdev)
>  				rdev_err(rdev, "failed to disable\n");
>  				return ret;
>  			}
> +			_notifier_call_chain(rdev, REGULATOR_EVENT_DISABLE,
> +					NULL);
>  		}
> =20
>  		rdev->use_count =3D 0;

This change doesn't seem obviously related?

--F85KFVxTQmf/0nzl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTBfpPAAoJELSic+t+oim9xX0P/1HwkmNibydYh7yExcXO5VL6
iC+hJ4Oc8cYQMMAJl0oVmSFftU+zfPF8XMQf3CHwmbdRoEy3l6213sNUcvhfnBvz
osRaCCNRCBWmKxF5jYLhAe3FTn9GMCzrPob3GOTxnY5eUSAFcr5Dx946aBw+Odya
LLcAVDS8MChvOlsXwihCX5ZAgTuH+UIThhmhhF1QSn25BuIKfuYkI+IyFUIUGiJO
LO0lCcMlYXmeIDPuOcYF9Kb7kYCYv7nBC0OpjUzWWSAXzaO9rEy14j80PUEWqZis
1+3eS+C5dVPxmch/eAQRSQ7pvCDp2uozAxiSz/XdSXSIogNjAmVnoTePbX6rBiMi
UrHq28GolclDoWgvOtlhpBGr5JOCs6JB922kU9vqNvqRDeTnuPKtOFGhB55fKp+8
U7uKCrEDrKvlec/RiGBOsAufOG5ibkeEa5NJTof0/9iiW0dNKWTwCQdtldQVrRbs
3qaE6LL8Y2bCkcZEfMhmjOZhjNn30rXBIr6NQ4cBRgzkltHMDb+gv6UwHbZx6wuV
OrTWz/XJdBcNtK5DWW3zbCfox5x/sK+jh0f5t0EaY9eqoENWHIEHW8/PFLUQNpc6
RR/5eQG0GQOLCWpsLVvew9liCkkXMnxTS2uZ+PGpUScAKU+pJslI2A2TajwNG77n
lmOxl4W5RCQ6sbzq5RJO
=af1V
-----END PGP SIGNATURE-----

--F85KFVxTQmf/0nzl--
