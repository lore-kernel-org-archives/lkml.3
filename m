Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754961Ab3AaH2T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 02:28:19 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:58085 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754860Ab3AaH2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 02:28:12 -0500
Date: Thu, 31 Jan 2013 08:28:08 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 1/1] dma: pl330: Convert to devm_ioremap_resource()
Message-ID: <20130131072808.GA2041@avionic-0098.mockup.avionic-design.de>
References: <1359616024-11640-1-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1yeeQ81UyVL57Vl7"
Content-Disposition: inline
In-Reply-To: <1359616024-11640-1-git-send-email-sachin.kamat@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:evaPukrACUegXxcUB7QPYNt2cTXgxHk599IqPPQx2vI
 kwHt42S+Xe8g9EyxoaHa1wZtHbuSOfPVaFSVi2v4jFTma/D4QE
 TX4oAUqrPg/+kGKPIkYZ4FgD3lvk74loeHa50jTvQnrQ7s1Vi9
 G7LTcq6tlQ6anDhEg61EZQwMg9yUNOdPG+8/CxYapXwqNQpT5F
 sx1IS51GjgPe/ucWAycRx8+MvYljNnQx1hAsMZTD/EdKsVfuIu
 6PiY9E+gH5qW7RI2m0sADMni2Mezhy6mXH1BI8o7zg0Fe7w1N9
 MfkVPTUOxHHyM3+zEEGoXrEYAsnVEqVc2oBRo3Qq5yfysOI7L8
 qYXPtGQ4J/3booQ+yDTwl76BObVJBgdUmGE91+kxxNqCyF8Dn/
 4hgy5+XkWhw02kF94MR0rLx18jaMftbx34=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1yeeQ81UyVL57Vl7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 31, 2013 at 12:37:04PM +0530, Sachin Kamat wrote:
> Use the newly introduced devm_ioremap_resource() instead of
> devm_request_and_ioremap() which provides more consistent error handling.
>=20
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> Cc: Vinod Koul <vinod.koul@intel.com>
> Cc: Thierry Reding <thierry.reding@avionic-design.de>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
> This change is based against linux-next tree (20130128).
> This change however introduces the followign sparse warning:
> drivers/dma/pl330.c:2883:22: warning: incorrect type in argument 1 (diffe=
rent address spaces)
> drivers/dma/pl330.c:2883:22:    expected void const *ptr
> drivers/dma/pl330.c:2883:22:    got void [noderef] <asn:2>*base
> drivers/dma/pl330.c:2884:34: warning: incorrect type in argument 1 (diffe=
rent address spaces)
> drivers/dma/pl330.c:2884:34:    expected void const *ptr
> drivers/dma/pl330.c:2884:34:    got void [noderef] <asn:2>*base

Yes, those are false positives. They can be fixed with the two patches I
posted a few hours ago, starting here:

	https://lkml.org/lkml/2013/1/30/455

Note that the first patch is against sparse. The problem, in a nutshell,
is that sparse complains that the pointer address spaces and noderef
attributes differ. In the case of the IS_ERR() function and friends the
attributes aren't relevant because only the pointer value is only used
arithmetically. Unfortunately there is no way you can cast away these
attributes without causing other warnings, so the solution is somewhat
more complex.

Thierry

--1yeeQ81UyVL57Vl7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRCh0IAAoJEN0jrNd/PrOhzzoQAI1tm565rkDzgZOMDtI4Pl0k
wfJPsk7eeiWOCfhLdMRDjeiyaPnnuYPgf3ppbmuIhRDkoVS7C1uKZA30ZCl6ikVD
xxmZdaNKwx+ZIK7O1ayX3GqxICKxG+xfhkOlQZuG7L7ge2UboLGtkom/9hU8QIiQ
SIk0fZt8R0zwJmSWQjbUNE09mOwyADa9zBIGZoLaRVAblTgZIQh4Bkek6Ws/k6Xd
5yj42AXVQIEw3f5PxaPDry6MVH0UNvINWLU+g6Kk/nluFwruKXPswZkQ0IVKwP7h
QLXa/Kns6bf9VJ27t7mLBeU36shdRJGyBsx67+iazEe46paki93N7+6FLyvStSAb
G+aC2wUMwUc2XfO+Oh5jzG5RtWeDDiIMCazjGnlZdKlSvyB3Y/3H4G07LiNqJzQu
W14uK15ZEtvhrdmNBm+DqTVPwfaigdh2Sd5rnDBlP8IoOSJGcCqALdu8yrDPKpXI
rkyhtaMIy1TrNpyCSRVH3BRrDFe5V0+a3dwf41I8fOfMRsn1S9aBRjXZ6mpzDA/Q
ABFpHs43jzHdMC/NwJr0VwnoZRhOEKJS0aqgpJCg2R7LJRIJ7Z5i2R5cXs3sNH3u
7qgnNX98oQJnQcXVogmOAQQ9k83cIfO7tC03cbIndfWJqMEb/3PjzLuRGvTwvKIb
1tUVjVDB07lSmxzi5kcV
=W1m4
-----END PGP SIGNATURE-----

--1yeeQ81UyVL57Vl7--
