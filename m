Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079AbaESKv2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 06:51:28 -0400
Received: from sauhun.de ([89.238.76.85]:56841 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752243AbaESKvZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 06:51:25 -0400
Date: Mon, 19 May 2014 12:50:56 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Doug Anderson <dianders@chromium.org>
Cc: lee.jones@linaro.org, swarren@nvidia.com, abrestic@chromium.org,
        dgreid@chromium.org, olof@lixom.net, sjg@chromium.org,
        linux-samsung-soc@vger.kernel.org, linux-tegra@vger.kernel.org,
        Vincent Palatin <vpalatin@chromium.org>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, sameo@linux.intel.com, jdelvare@suse.de,
        shane.huang@amd.com, maxime.ripard@free-electrons.com,
        laurent.pinchart+renesas@ideasonboard.com,
        u.kleine-koenig@pengutronix.de, bjorn.andersson@sonymobile.com,
        kevin.strasser@linux.intel.com, linux@prisktech.co.nz, andrew@lunn.ch,
        andriy.shevchenko@linux.intel.com, schwidefsky@de.ibm.com,
        matt.porter@linaro.org, ch.naveen@samsung.com,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
Subject: Re: [PATCH v3 6/7] i2c: ChromeOS EC tunnel driver
Message-ID: <20140519105055.GA2612@katana>
References: <1398879850-9111-1-git-send-email-dianders@chromium.org>
 <1398879850-9111-7-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pf9I7BMVVzbSWLtt"
Content-Disposition: inline
In-Reply-To: <1398879850-9111-7-git-send-email-dianders@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pf9I7BMVVzbSWLtt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


> +I2C bus that tunnels through the ChromeOS EC (cros-ec)
> +======================================================
> +On some ChromeOS board designs we've got a connection to the EC (embedded
> +controller) but no direct connection to some devices on the other side of
> +the EC (like a battery and PMIC).  To get access to those devices we need
> +to tunnel our i2c commands through the EC.
> +
> +The node for this device should be under a cros-ec node like google,cros-ec-spi
> +or google,cros-ec-i2c.
> +
> +
> +Required properties:
> +- compatible: google,cros-ec-i2c-tunnel
> +- google,remote-bus: The EC bus we'd like to talk to.
> +
> +Optional child nodes:
> +- One node per I2C device connected to the tunnelled I2C bus.
> +
> +
> +Example:
> +	cros-ec@0 {
> +		compatible = "google,cros-ec-spi";

Ooookay, now I get it. From the compatible name of this snipplet, I
assumed this node describes only an SPI IP core inside the EC. This is
why I complained about the location of the I2C busses, since placing it
as subnodes of the EC based SPI didn't make sense to me, even though the
connection of the tunnel was SPI. Now I understand that this is the core
driver for the EC, talking to it via SPI. Since this driver is an SPI
child node I would not have expected the "-spi" suffix. Sorry, for this
confusion :/ Now, the bindings make much more sense to me.

> +			google,remote-bus = <0>;

I am still not too happy about this one, but it is good enough for now,
I suppose.

Code looks good, so

Reviewed-by: Wolfram Sang <wsa@the-dreams.de>

I don't mind how it gets upstream. I can take it, but you can also keep
it in this series.


--pf9I7BMVVzbSWLtt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJTeeIPAAoJEBQN5MwUoCm2oW0P/j8JB1WuVh1unAN3oJOQVJlN
1gd6qurO+IlAf77yBAVfJa1cMZGxo5+KGmHo6TQmqv1BgNygntU+TlUeO8acwFdj
RDQ2j7qGx/ZwcN8GELw4fVpFNcNAJ/nQmOi4nPHYC8sUNjrHYVG4ybjC9ogJbM+Z
Y+gyc1b/t7crdLhg92c63nZxy7n6R2Kez1ZPhXj1djeu30klh8LLqshZA04muL+t
n7Kac/sISeKv0pkv70V0qX06WPCwwbgbticIkMf1Z3kOmfFUeCi83QQOjYJXDltB
ohnebK/6rfF+vG6Lsrsorl5pKc/fQlv6dIKO2seRFUbmpQXJ4d2roFhozd1eh1Qw
R0bc02a1aLjExluyjLX1/bYfgu+NsFk0Cx/O+EoTF/kocpDaznBR/DmJ6IeQBCDP
MjsH3ppXSnJYx+iqvTtiIbL1g4BTriBtgDC/bKVecdi9WypbEqFYWIRvIGmHt7x5
W4i1Dr2fv08EOO7BWeN9580+fFIi+Y8Z8+17fuEeSelkZvCVDsyXemCEoiea7nQl
RKqsKYGTXJqhc/hgJ4rjqRknSc14Byta64uYFCRnbw9tDe+EppiNwzGP4eIz2jE0
r8W4+1IQU1TSsW8lPTBSDghuzi3SZrfibw2wFpZSoieRW7x8jg1ByuDU2DLFegbr
NYJrAKmVyWcucMSBGWhn
=W4a9
-----END PGP SIGNATURE-----

--pf9I7BMVVzbSWLtt--
