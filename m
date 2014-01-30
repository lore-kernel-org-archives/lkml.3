Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752873AbaA3MNA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 07:13:00 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:32920 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816AbaA3MM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 07:12:58 -0500
Date: Thu, 30 Jan 2014 12:12:51 +0000
From: Mark Brown <broonie@kernel.org>
To: Kuninori Morimoto <kuninori.morimoto.gx@gmail.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Lee Jones <lee.jones@linaro.org>,
        Simon <horms@verge.net.au>, Magnus <magnus.damm@gmail.com>,
        Linux-SH <linux-sh@vger.kernel.org>, linux-kernel@vger.kernel.org
Message-ID: <20140130121251.GO22609@sirena.org.uk>
References: <87r47r6v48.wl%kuninori.morimoto.gx@gmail.com>
 <20140129124516.GZ11841@sirena.org.uk>
 <87mwieib5x.wl%kuninori.morimoto.gx@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GTGEtWEe6jD60dxL"
Content-Disposition: inline
In-Reply-To: <87mwieib5x.wl%kuninori.morimoto.gx@gmail.com>
X-Cookie: PARDON me, am I speaking ENGLISH?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: About gpio-regulator setting on DT
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GTGEtWEe6jD60dxL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 29, 2014 at 04:08:30PM -0800, Kuninori Morimoto wrote:

>     /* build initial state from gpio init data. */
>     state = 0;
>     for (ptr = 0; ptr < drvdata->nr_gpios; ptr++) {
>         if (config->gpios[ptr].flags & GPIOF_OUT_INIT_HIGH)     <== we need this
>                state |= (1 << ptr);
>     }
>     drvdata->state = state;

So this just looks like a bug in the code - the DT has all the data
needed but the parsing code isn't setting everything up that the rest of
the code needs and/or we should drop one of the ways of configuring
things in the main probe function.  Avoiding having two ways of doing
the same thing in the main probe would definitely be good.

--GTGEtWEe6jD60dxL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS6kG/AAoJELSic+t+oim9s0cP/16C9I4fzfxkSMAmMu56Qlww
TMWA/wKctewkQm/Wa53Ij2+ttrlak0GolARyxUfbUCMhWVb35q1cWVwmNEy4pbAI
rfWzjl55pCYYo0r42Ag704vcM4evnNPaVXW0QYuJjqwsO+8sY6XONti3+JeBh9a/
oJr5tr8hwxnk5n9p44Q1kdaPHaWHUlwpD9nN3QkwXJMsndDb2M05U1DcM9u6eMSs
dvyR9jMVOGLBE3kYkGr2KrrbkL5ztDNY6sLJGatJGJWDMwG6zaTxck1RnE8PzgWL
1wC0MFX4rs0V1y4jbpeKs6ynexhvmkehHMD7UTkIUIHJMKYixTLaYbWdq76sBvdG
Cio2zkOystmDCLtwkwPx4Ryos2rHPTtbyepnsmzc3os7hNNFMzxDxFtFKxtxFEY7
q7SUrJ6CK8DCcxGpGrnBg65zFDMJWXcm9Ol/HvMLfOnkImqvENvVxkYP5w6K0G+L
qKyUKSexSNmskNPx4d1JyWSZLCU0ghWEjhw/IS0uC/GTtefRskoFm37rcvmLsOAn
UsEQDGtJ8qQpwWQDGDf5tqhBfP3nCyfhS8P1dJTBQwmbbUPVo+eqfhB/g3BV1oUH
n9PPXTA3qt4wLKAMR+0lAu3ZgPQYKEIAnhDwJsDuMH9c2Fo7k8Tpib6FBGo3JDuR
Ko1m09anoEO3llBbc6Cu
=nakD
-----END PGP SIGNATURE-----

--GTGEtWEe6jD60dxL--
