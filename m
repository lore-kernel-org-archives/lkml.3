Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553Ab3KVKga (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 05:36:30 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:58167 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315Ab3KVKg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 05:36:26 -0500
Date: Fri, 22 Nov 2013 10:35:33 +0000
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Anton Vorontsov <anton@enomsg.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Message-ID: <20131122103533.GI14725@sirena.org.uk>
References: <1385109972-28059-1-git-send-email-k.kozlowski@samsung.com>
 <1385109972-28059-3-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="boAH8PqvUi1v1f55"
Content-Disposition: inline
In-Reply-To: <1385109972-28059-3-git-send-email-k.kozlowski@samsung.com>
X-Cookie: Your supervisor is thinking about you.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3 2/5] extcon: max14577: Add extcon-max14577 driver to
 support MUIC device
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--boAH8PqvUi1v1f55
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 22, 2013 at 09:46:09AM +0100, Krzysztof Kozlowski wrote:

> +#define	DELAY_MS_DEFAULT		17000		/* unit: millisecond */

This delay is sufficiently large that the delayed work using it probably
ought to use the power efficient workqueues instead of just a regular
schedule_delayed_work().  This will mean that instead of being scheduled
on the core which scheduled it the work can run on any CPU, avoiding the
need to power up a currently idle CPU just to run the work.

--boAH8PqvUi1v1f55
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSjzNyAAoJELSic+t+oim9w/IP+wQa4UdcAp36KDye/BZezVYK
XFHXJ5cQaJv0GPNRmrfH9nTAPblin2kE1gtF+zc+YEy8jqeDVWMVozdPzmxlASZh
c7HqvprBnJuCy7Z1iOXwsTxlLXZwu/X1sEggdYbPgDCbMWy+BlDrldkKs2e9JAtl
CR63fh1R4OZoWUKsxmNg+1kaGps7mV5nqGyBo6pUUiqCT/xmsFvm/Qg1Mx4+9qRx
T6drwdc1IIdP4F4rcpne9X9miKLVx9T6OvAg+uAoZ97PFhz2S67sotOPLXuaGXj1
repiEVjjYBmSyCNHtaFaDHga5IFam7KOKLmgMzVrCkcE9LTWPAI4gsOGvGemz3S0
jFnGPOlO/rH4+4+Jgwb0ViAc54WTVBNc4JNXui5stl6yjrj54e7xfbsX6N39vS8Y
IsQ8w/kCuGrHRsh21JezgA/MXmq0P7P6NO2/PR7aKKbRtU6kMA8tSh8Atl98mExI
jO6cnmFvkbyPRSe5H2qXe8+/oZKQjmF5FBW1O/pevVeGqvu1/TS/1BoU+rQ1iCpe
f7CyjL2yexvFnBwx5P0Hj7nFKd2B8q6aElR6S/uY5J/YbBWSWDQKw989hD3dyAQJ
ivlir8tKW4QBqoKrJmCcCxkn0YATrtQvOTHS5UGecfbik3/BA6SFMnH+MYmKHH7U
Qom+IQ3+b/EcpglcFMwy
=vYTX
-----END PGP SIGNATURE-----

--boAH8PqvUi1v1f55--
