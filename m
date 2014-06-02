Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165AbaFBMro (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 08:47:44 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:50861 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752201AbaFBMrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 08:47:43 -0400
Date: Mon, 2 Jun 2014 13:46:38 +0100
From: Mark Brown <broonie@kernel.org>
To: Chew Chiau Ee <chiau.ee.chew@intel.com>
Cc: Eric Miao <eric.y.miao@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Darren Hart <dvhart@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-spi@vger.kernel.org,
        devicetree@vger.kernel.org
Message-ID: <20140602124638.GD31751@sirena.org.uk>
References: <1401738379-4107-1-git-send-email-chiau.ee.chew@intel.com>
 <1401738379-4107-2-git-send-email-chiau.ee.chew@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BRE3mIcgqKzpedwo"
Content-Disposition: inline
In-Reply-To: <1401738379-4107-2-git-send-email-chiau.ee.chew@intel.com>
X-Cookie: Big book, big bore.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 92.40.249.174
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] spi/pxa2xx-pci: Add common clock framework support
 in PCI glue layer
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BRE3mIcgqKzpedwo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 03, 2014 at 03:46:18AM +0800, Chew Chiau Ee wrote:

> ---
>  drivers/spi/spi-pxa2xx-pci.c |   20 ++++++++++++++++++++
>  1 files changed, 20 insertions(+), 0 deletions(-)

> +	clk = clk_register_fixed_rate(&dev->dev, "spi_pxa2xx_clk", NULL,
> +					CLK_IS_ROOT, c->max_clk_rate);
> +	 if (IS_ERR(clk))
> +		return PTR_ERR(clk);

This is pretty much fine code wise but I'd expect to see some Kconfig
updates adding dependencies on the clock API - clk_register_fixed_rate()
is only provided if the fixed rate driver is present.  I'm also not
seeing any changes to unregister the fixed rate clock as the device is
removed.

--BRE3mIcgqKzpedwo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTjHIrAAoJELSic+t+oim9/7EP/1Pbt4XAJ5TpW6TYrXPk+sMS
NZftP4t9eQPYSH46P8RRpqilmZ2dFOQZwKoDgmAFVt/tKJx34Vdmr5ZUE0FVn+TV
ud/YKjTN6fvDd38ESKstpKpYE8Qg/oAWosoLsAWGRj+2smU1k6ezQVLM69Q1D3y5
2gP0QR3XQw7MGYZ9k1BXVCjvTZbSdyHCqVJ8/hvjpJ2MZAfSqmvIeiHFF2weCnea
ty9jis54P5HqCjnL76UpnruiJKZNB7+ZmfajuHCBJxfgiOGqYlsfIihH1I6aunYo
t6l66UUdQjamjEsBlyWkFRBS6HgjIuOiCAb7QUGzFyK/yhAsWe5zgM59eCNSjBiH
NgChnAml7Phl2gPisMg0Rl5CfzB4fA1zd3aq9FsZ+7FL3GsReJAlQCOWYNGe5LBK
nmd47AcgIndDTgeNPGQImraspBSxnYs4dC1UgBY2s3OLvvhZV+E3sNWmtIkPvYvE
huKeIh9Ey8RqJjFR+TVn2K+EEfJm20QSQeD5et2SLKxMQ/suSUKdFvgoB+sB2JKX
reGSMxsQc97iWA4r2VlOljWsYe0nze+umBvgpT0dTug+yzHdpsMHUhWEEwoGQ6sL
YVYvmpuK7jvYuZfzX12w4Oct3zk2dMziECg0Tz5/gBWSagUBL3MWYm7PZR8JLo+X
ZWhJtknrJDlTIYDdMEX0
=/dfd
-----END PGP SIGNATURE-----

--BRE3mIcgqKzpedwo--
