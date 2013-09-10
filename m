Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555Ab3IJRF6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 13:05:58 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:44894 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952Ab3IJRF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 13:05:56 -0400
Date: Tue, 10 Sep 2013 18:04:38 +0100
From: Mark Brown <broonie@kernel.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Guenter Roeck <linux@roeck-us.net>, Wei Ni <wni@nvidia.com>,
        "khali@linux-fr.org" <khali@linux-fr.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20130910170438.GS29403@sirena.org.uk>
References: <522DB253.6000707@roeck-us.net>
 <20130909135022.GZ29403@sirena.org.uk>
 <20130909155043.GA18975@roeck-us.net>
 <522E9059.3070305@nvidia.com>
 <522E93D6.2010304@roeck-us.net>
 <522E94AE.7000804@wwwdotorg.org>
 <522E97CE.4070300@roeck-us.net>
 <522E9C84.9070405@wwwdotorg.org>
 <20130910100939.GW29403@sirena.org.uk>
 <522F35BF.6070909@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IGm81t4p5ot0iv02"
Content-Disposition: inline
In-Reply-To: <522F35BF.6070909@wwwdotorg.org>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3 1/2] hwmon: (lm90) Add power control
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IGm81t4p5ot0iv02
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 10, 2013 at 09:07:43AM -0600, Stephen Warren wrote:
> On 09/10/2013 04:09 AM, Mark Brown wrote:

> > No.  There are a couple of issues here.  One is that we don't want
> > to litter all drivers with conditional code to check if they
> > actually got the regulator and so on, that's just pointless make
> > work on the part of consumers.

> So that's exactly the difference between (a) and (b) above.

Right, but the idea is that we just only ignore a failure to get a
supply if we can usefully run without that supply being present and
there's more code there than simply ignoring the error - if the driver
can genuinely just ignore all errors and otherwise not do anything
different then requesting the regulator in the first place is clearly a
waste of time and enabling it would be a waste of power.

A driver should only be carrying code for a missing regulator if it can
usefully work without it, like the cases where devices can use an
internal reference if one is not available.

> > The other is that just ignoring errors is generally terrible=20
> > practice which we don't want to encourage - ignoring the specific
> > case where nothing is provided and the system has control of that
> > is one thing but just ignoring any error is another.

> Yes, obviously the code somewhere needs to distinguish between
> missing-so-use-a-dummy, and specified-but-in-a-broken-way. Doesn't
> regulator_get_optional() already distinguish those two cases? Perhaps
> that's the enhancement to regulator_get_optional() that you were
> requesting.

Both calls are identical in terms of handling genuine errors.  If the
driver is just trying to ignore errors it will be more work to use
_optional() since it has to cope with the regulator not being present in
a system.

--IGm81t4p5ot0iv02
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSL1EjAAoJELSic+t+oim91HsP/i1liqlb5wPN4CBbA4tvEHPS
HFMOCRpjvfr4EyxGexcHjVwYBgeyfhe494Z9Kawq7AoA6F+LmHLhL3oX/v9M/V37
5LVyIA6HG6gfc5OkP72D0wTn9iNPu0Jz/B0QgcEejWCUpINGugC0emdzy0Bg9A+d
+Jvh8Nm55rI+TqbUcMu7Sr8S32xacrkGWt6m3EiAVAyB9T7kMjQoMBaF7OKndRFi
pHaRqyvkHhAIcuCPJ0aGe5pPCzdrBiXuqIqJlvpVUwtzF18RgokkofzHLfeXck0z
emungdz71hBvdtFc0ojxwMfMD/Nr/sF2iDCi57dpoSlf7Pz0Sn3mt1uxhRm1IZdO
EDqSmse8h4vtd2/Q+Sw9d2g43RyarEbHsfJz4R+GIlwYsbo6eTzPDOv5pyO5xT9z
OYZIfQ9HJNJfAtEfglNWy9cZSNdU2zxaYLMxvNbWW8JgU6g4TTJXzzbuQ/e7h4q1
B00cCDME98dwiJzRQf8jJL1kFoLcAq1lQdp+GfcAgrs5qYfE1gYFZUKmXIl8iCxO
RynkWGccB3KWdgWz44J/3CUrYPtqhIVD0DDQSrC1R5bBKtjMeuaULSuGrMW1V8D3
QPuVgYr/bWW8EDMNl9OBM9FW3/1iSanCtOMNgkUcFR/JiWjcA37XU3xLXSJ9gI+r
UY35emSi2m2gjbllBfp3
=xfIU
-----END PGP SIGNATURE-----

--IGm81t4p5ot0iv02--
