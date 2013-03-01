Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752083Ab3CAJWp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 04:22:45 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41969 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751370Ab3CAJWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 04:22:43 -0500
Date: Fri, 1 Mar 2013 17:22:12 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>,
        "Jett.Zhou" <jtzhou@marvell.com>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC/RFT][PATCH 1/3] regulator: core: Add enable_pulldown flag
 to indicate pulldown on EN input
Message-ID: <20130301092142.GS25302@opensource.wolfsonmicro.com>
References: <1360919961.23894.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/FJxnyttrH06HRq2"
Content-Disposition: inline
In-Reply-To: <1360919961.23894.2.camel@phoenix>
X-Cookie: Condense soup, not books!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/FJxnyttrH06HRq2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 15, 2013 at 05:19:21PM +0800, Axel Lin wrote:
> Add enable_pulldown flag to indicate pulldown on EN input when using
> regulator_enable_regmap and friends APIs.

> -	return (val & rdev->desc->enable_mask) != 0;
> +	if (rdev->desc->enable_pulldown)
> +		return (val & rdev->desc->enable_mask) == 0;
> +	else
> +		return (val & rdev->desc->enable_mask) != 0;

Pulldown isn't the word here...  it's saying that enable is inverted,
not that it's pulled down.  Pulling something down is more an electrical
engineering thing saying what the default value for a signal is if it's
not otherwise driven, it doesn't really make sense in terms of a
register value.

Something like enable_active_low or enable_invert?

--/FJxnyttrH06HRq2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRMHMtAAoJELSic+t+oim9i7YP+gOXDS/p4YOn0l0kwAzCKBas
s9vTYIgR5ws3HWW+BV1x/uYb6J5ZJMYm2+VmabdZm4nqxcwLm560+I2muwKS5dgc
v9Vgi8yx/gMGvjppZTZgyc/4lkDivr9FdVEEDy+45eia0mk7vWluc82w5c3Ufh5r
vqkxL1UTnuD8I8Y+Z1hvFFbJlwpjjKLdvWAPyGVqELfCuStoBO/UUB3bBzNIlTH3
dSq/X7EyKYbSfbbY464UwT+oL28+OZBBFnwL/8VhYxeWLSH8w3zgYF01OQ7+vFKV
380uczyOrxAgSPrLAPcVF+XLTMYge/i2YfmAKoENlO6WkzK2lpSUsf+INHQFH7Rk
9EKObjR70/U7j01e7YHWFT/7pBvTN0oxNweR784cMy6+8M6D8DZTkJRc7P0YeIB/
FDv5oghVtkXHfXZJCTJld2+D0oLsUWvAdwUrF48Bu7yVOslB1RiQN/0x4PRs5xnB
Kda1yvkCEBgsuC5KnOWAR7pD/tm8tdxnT96uMsw8up2TerlU0LrqVGUBv1vqe/IR
XklO48fKQ+kaoqPMYVciaqc07Y4HCMTAeA0rssH7RMwHzWH7QpdWhprGXd59F51i
BXT52X9kDyHwaSEfjqWqeqSygYJLPOAIAfWPJc9uPOjWn2qwtfq5y2a+o9U8O2lo
v0seKofC0yerCvHJbT9+
=yaB3
-----END PGP SIGNATURE-----

--/FJxnyttrH06HRq2--
