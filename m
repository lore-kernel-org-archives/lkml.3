Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097Ab3IIPk4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 11:40:56 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:50017 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196Ab3IIPky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 11:40:54 -0400
Date: Mon, 9 Sep 2013 16:40:28 +0100
From: Mark Brown <broonie@kernel.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-i2c@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lv Zheng <lv.zheng@intel.com>, Aaron Lu <aaron.lu@intel.com>,
        linux-arm-kernel@lists.infradead.org
Message-ID: <20130909154028.GP29403@sirena.org.uk>
References: <1378733679-19500-1-git-send-email-mika.westerberg@linux.intel.com>
 <1378733679-19500-2-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gAsw9DVneI/FTEJd"
Content-Disposition: inline
In-Reply-To: <1378733679-19500-2-git-send-email-mika.westerberg@linux.intel.com>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH RESEND 1/2] i2c: prepare runtime PM support for I2C
 client devices
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gAsw9DVneI/FTEJd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 09, 2013 at 04:34:38PM +0300, Mika Westerberg wrote:

> +	/*
> +	 * Enable runtime PM for the client device. If the client wants to
> +	 * participate on runtime PM it should call pm_runtime_put() in its
> +	 * probe() callback.
> +	 *
> +	 * User still needs to allow the PM runtime before it can actually
> +	 * happen.
> +	 */
> +	pm_runtime_forbid(&client->dev);
> +	pm_runtime_get_noresume(&client->dev);
> +	pm_runtime_set_active(&client->dev);
> +	pm_runtime_enable(&client->dev);

How is this going to interact with client devices which are already
enabling runtime PM for themselves, and what are the advantages of doing
this over having the client device enable runtime PM for itself (given
that the client still needs an explicit put() adding)?

Given that it's relatively common for devices to have both I2C and SPI
control it seems like it'd be sensible to keep the policy common between
the two buses to simplify driver implementation.

--gAsw9DVneI/FTEJd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSLevpAAoJELSic+t+oim9s3IP/iZpmbUH+6uxtJTlHnrHrQJW
HqP9yX7CyAfxdna0s/v5Oy8jqZzpHrBPSuBf/6NQcex94W8d7ZCM2a66rOO1Qpl+
BgBHTG4Ttl9hzqjiAwkebG25fPUiRyacF2Btwx6kTeibKi2kvxtg8c388kN8gO/5
RLJg2/t9daiI/jeaJmtDlCaPlO1wvHfJl/CYw8OoikewvGzaP3bdNE/5mYWmNHom
CI9IE/NeDaP82Q5FCV260OMG2sEFo9tPgBRe0eVx9piUsQ126ZnBxLxnoBFNwWau
aONZrMNeaqwaZNCakGslCmyY7w8JRPvUlJ6YmH3cor4AEs5EfZaCGHMcsus1i0Zh
1bPTYFJNWAkZD0ZE8/4XIa9Omqdf9M8Sl4ZezLbWY5VIUc9qxVasxHdfJEBOLTui
kJGPRaHueaKyNVKFEAb4LFzXNATRR9WYAS17kwrGIBF6Y2xem88g27lyHB85BjzE
hs1Dl1SRcIFKkvZLT31W8JFZcMZt190g7FNA+5wN81eIjEmde4CP0PVIAIDSaN2e
i7ADjXa0U9Ro2QN8+zJLRNvXYzq+TpZrOYXiaiawea3PDnfaFtafyhw2QBD+qHJq
us10IO56AgPQDyLCRfB1mnYRF3/d+MwLqBMcwjmqPl8RjSu1dAv8jg7CYFhU8F7z
T/TGDS2HJJck+nQ/P7QQ
=rXnG
-----END PGP SIGNATURE-----

--gAsw9DVneI/FTEJd--
