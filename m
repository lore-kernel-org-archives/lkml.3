Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374Ab3I0NZV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 09:25:21 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:48025 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234Ab3I0NZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 09:25:18 -0400
Date: Fri, 27 Sep 2013 14:25:11 +0100
From: Mark Brown <broonie@kernel.org>
To: Rhyland Klein <rklein@nvidia.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>, linux-spi@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        Simon Glass <sjg@chromium.org>, Olof Johansson <olof@lixom.net>
Message-ID: <20130927132511.GD19304@sirena.org.uk>
References: <1380214904-12899-1-git-send-email-rklein@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4AmJdx/+JAF2YHMk"
Content-Disposition: inline
In-Reply-To: <1380214904-12899-1-git-send-email-rklein@nvidia.com>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [Patch V2] spi/tegra114: Correct support for cs_change
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4AmJdx/+JAF2YHMk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Sep 26, 2013 at 01:01:43PM -0400, Rhyland Klein wrote:
> The tegra114 driver wasn't currently handling the cs_change
> functionality. cs_change is meant to invert the decisions of whether
> or not to deactivate CS after each transfer. Without cs_change, after
> every transfer (other than the last in the message) the normal behavior
> is to leave CS active. For the last transfer, normally CS is
> deactivated when the transfer is complete.

Applied, thanks.

One thing I've got planned is to build on the existing factoring out of
the queue code so that we have several operations decomposing the
message transfer, something like:

 - Set /CS
 - Map/unmap data to be transferred
 - Actually transfer data

partly to avoid issues such as the one you're seeing here with fiddly
stuff like /CS and partly because the mapping operations should be the
same for many devices, as should the /CS manipulation for devices using
GPIOs.

I've started working on this today.

--4AmJdx/+JAF2YHMk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSRYc0AAoJELSic+t+oim9SREP+QFVT0/aLicB3VJ0u0oWzuBt
+E5bx6dX2BlmpaXUxYz236YQTDPm1aoXt/DfDU1hpgnrIOkELfZbSlyE6IRPDPCa
GNqpsonDli072PafE5yTp59tJha8H++AKZCkiQpDe9J7SCXjHosd1UiHcy5hzv/h
3OLp+InW3TXEvF4JvbRTmhpEbvLY7U0mNewOUcNdL+EiExuXa31d+SOo9H/PFFeU
x643m09zGpMJ512aobSvjmQ+u6lo7j2An0ovHWESibDOtb+NJk+GU8jeUXxX+S1C
Q4qo8FMvWfrp5lwE4S6miPfSTPRk6zG4n2rWIPsz+sB+7/8OYi0Je8C0CEQAcOwP
QKVMlUja34rDcYLC5qZBtfRT+UqtDKfuuBW1voXjeugaqYr6QsdlaFO4HA2T0TE/
vUD3rcUSMBD/ydMElszDEj0jYL00T+Sj+7pnQO5gFzJmToyG7KkOBSNJdNz8yho0
1tpd8G/qcoz3kbA2VLjPATbqqQkJ/DtRJDszX24XOqK6xqX9F8wIdvWvybXeFy8q
eQhduW6hcJNAdepF61kDtTD4RNGFU/LKNCbI9YFOnUK9iXVBCHeSkDq9zvIWlPKy
SeRzdWUGjV5I0hrzrDSt3xNoW1BfY6XH2LHP7XXcDz1FyB8gFGPJZtsyuubpbKGw
4U+RVNZuZmCc9sfbMfT2
=b6wR
-----END PGP SIGNATURE-----

--4AmJdx/+JAF2YHMk--
