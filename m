Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752391AbaBCPRm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 10:17:42 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:34733 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294AbaBCPRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 10:17:40 -0500
Date: Mon, 3 Feb 2014 15:17:21 +0000
From: Mark Brown <broonie@kernel.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "Shimoda, Yoshihiro" <yoshihiro.shimoda.uh@renesas.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, linux-spi@vger.kernel.org,
        SH-Linux <linux-sh@vger.kernel.org>, devicetree@vger.kernel.org,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Message-ID: <20140203151721.GA22609@sirena.org.uk>
References: <52EEF452.4060205@renesas.com>
 <alpine.DEB.2.02.1402030939520.25794@ayla.of.borg>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9989e9MCpLPr9Uiv"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1402030939520.25794@ayla.of.borg>
X-Cookie: PARDON me, am I speaking ENGLISH?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] spi: rspi: fix build error when CONFIG_OF is not set
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9989e9MCpLPr9Uiv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 03, 2014 at 09:47:25AM +0100, Geert Uytterhoeven wrote:

> Thanks, obviously I missed that of_match_device() still uses the ID table
> parameter if CONFIG_OF=n :-(

> Below I have two alternative solutions:
>   1. Uses rspi_of_match() to nullify the ID table pointer, like is done in
>      the platform_driver structure,
>   2. Fixes it at the OF subsystem level, by nullifying the ID table pointer
>      inside of_match_device().

> If 2 is accepted, drivers don't have to care about this anymore.

I think if we can fix it at the subsystem level that's clearly nicer
since it means nothing else will run into the same issue.  Your patch
looks OK to me, I'd suggest submitting it.

--9989e9MCpLPr9Uiv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS77L+AAoJELSic+t+oim9zuoP/2cjnKAG84aAxFK/gcB7lzHd
iPdkAwcBIgGY8dDqxaMSVJVbRQflKHO2UXimmClAf1kmU4Xg386bWrNoPHuATdy3
5M07hQlzBnCeJkPWkizvr/0viJn3bW/HAv0eJPcVzWpHBpNSKq03U5C/WFtYS8VL
2nBAf/qYitKX73dT2AiD3DJETr2TgtAQkA1Zfvm0JC9pZa7Ayx/OpDvrLl3wH6zg
E4lmPVdhG14N/pYQ4EsnGLvQV3Y1wBwVvxei23yA5blgf5tu/vmHW5CS08lGNQJr
9RyFETv45blrQQyqg9fpxw98krahGAHEDrrrdfMi+jdMCq5L4/Mr0cAQx3kkMyNs
1C+CF/YLIakGD+WyAA2YJ+RcS0BjnP+JXjAaUR2YyasK9xs/8dW8RMto2p6mx2Ea
dfUA4nRT47KG9WDDvk9DDuzTqikuYXHQ+n+DbOM8HYq5pdVVssKIiGvl1ZMhDctW
CbH1LSZ/DllDa9YfCb+q+qxt8OAhBdHB5+eIj+wEwFKRWBw7ITA/NCCE6+a/pHvd
zmV46VkjEnCFXrvJNJjMcqYqOUtgPk6352H7t2EExoLExXXmNxncdNO8RB+yq5y1
Pv1ucKVSpYlAzIEroPsG5UjlU0hEHjTnWXeGX26vie75n0kaVjDRzf87pco0ZWIw
eE3CanuYUNvpzTKjp6yA
=GCNg
-----END PGP SIGNATURE-----

--9989e9MCpLPr9Uiv--
