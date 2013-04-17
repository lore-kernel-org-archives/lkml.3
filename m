Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966740Ab3DQPLb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 11:11:31 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43854 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966551Ab3DQPL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 11:11:27 -0400
Date: Wed, 17 Apr 2013 16:11:24 +0100
From: Mark Brown <broonie@kernel.org>
To: Matthias Brugger <matthias.bgg@gmail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Daniel Mack <zonque@gmail.com>,
        Enric Balletbo Serra <eballetbo@gmail.com>,
        Javier Martinez Canillas <martinez.javier@gmail.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
        linux-omap@vger.kernel.org, ezequiel.garcia@free-electrons.com
Subject: Re: [PATCH] spi: spi-omap2-mcspi.c: Add dts for slave device
 configuration.
Message-ID: <20130417151124.GY13687@opensource.wolfsonmicro.com>
References: <1364252415-3613-1-git-send-email-matthias.bgg@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="iRaAnoDFBoP0sW/E"
Content-Disposition: inline
In-Reply-To: <1364252415-3613-1-git-send-email-matthias.bgg@gmail.com>
X-Cookie: Be different: conform.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--iRaAnoDFBoP0sW/E
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 26, 2013 at 12:00:15AM +0100, Matthias Brugger wrote:

> +- The spi slave nodes can provide the following information which is used
> +  by the spi controller.

> +- ti,spi-cs-per-word: Set chipselect to be toggled on every word send.

Why is this part of the DT binding for the SPI controller?  Surely if
the devices attached to the SPI bus want to configure this they should
be setting things up appropriately in the transfers?  There might be
devices that both want and do not want this on the same bus for example,
and this isn't something that should depend on controller support.

> +- ti,spi-turbo-mode: Set turbo mode for this device.

> +		controller-data {
> +			ti,spi-cs-per-word = <1>;
> +			ti,spi-turbo-mode = <0>;

Better to use a boolean property here - check with of_find_property() to
see if the property is defined at all rather than using a value.

--iRaAnoDFBoP0sW/E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRbrt9AAoJELSic+t+oim9mNgP/1Ur05zvRjGfz4+puXCqslo1
qgYOwUFXI4KFBCem64s4zcNAgSzhyqVpESO+2n1sVOWGKhQRft6m70Gdjvs+2RfD
xCwaQFe0bcstFoO6bF+imE3QqId9W2tPTDDAmBxv5qqqZLgdKQ4Ub8niX9RbvMdu
lqoSEmZiIrm2cFFFhB2JxT65UeZMYtrR9BoTuUpH7OV2fEXffb6Vxa8LBjswK2RP
ndw7s53HEewXpdWHdWE6mqvlhYlhPYYJG85ql/SjuBBuFlmLiludsAFRl1zVaWx1
uwRszVptPvREYDYOd27zAzrTlk8tJ14o1TfoCVu1m06Ea3lqDWymRys+jwhbOLN6
JfVVrzYv+Zy3Yuy5peEuNOmkbTNav9VLLsKjucQcOZ0EjxZPosLZGDWuVINBXmTA
X07FeJ7wzYUEu5TOfgIDm7TdjczpFW2sGYVr3+994I5el/dTdeovBfaYIqPgqMm5
YBACrqcfbjLfRoUVuJt2zxmQO7+ECkdC0DvXbQ0Htg8TiD0TIAKydo1D29kGjGpS
SN/rpNqLOCYJPM++5IS9n9IQjLFn9eoAU3C5/WsT48EoVS1xXF+VtW3jej3xivp9
RKU97m+RwlM//0kQkEeGMaVvNTUx24rD65OxUeFRCxTIN6wjhNDmjk0PEW6W1dKa
62eWBTZdzPYqYC69riXx
=HRwu
-----END PGP SIGNATURE-----

--iRaAnoDFBoP0sW/E--
