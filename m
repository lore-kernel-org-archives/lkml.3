Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753644Ab3ISLWV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 07:22:21 -0400
Received: from mail-bk0-f52.google.com ([209.85.214.52]:42945 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753606Ab3ISLWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 07:22:17 -0400
Date: Thu, 19 Sep 2013 13:21:04 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ASoC: rt5640: Omit ACPI match table only if !ACPI
Message-ID: <20130919112104.GB10852@ulmo>
References: <1379582286-10600-1-git-send-email-treding@nvidia.com>
 <20130919104525.GJ21013@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BwCQnh7xodEAoBMC"
Content-Disposition: inline
In-Reply-To: <20130919104525.GJ21013@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BwCQnh7xodEAoBMC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 19, 2013 at 11:45:25AM +0100, Mark Brown wrote:
> On Thu, Sep 19, 2013 at 11:18:06AM +0200, Thierry Reding wrote:
> > The ACPI_PTR() macro evaluates to NULL if ACPI is disabled and hence the
> > ACPI match table won't be used, causing the compiler to complain. Avoid
> > this by protecting the table using an #ifdef CONFIG_ACPI.
>=20
> Applied, thanks.  Like I was saying to Olof we really should be able to
> do better than needing the ifdefs though.

The struct device_driver's .acpi_match_table field is unconditionally
declared and the ACPI table with one entry and the sentinel weighs in
at 26 bytes, so perhaps doing away with the conditionals would be an
equally good option.

Or perhaps we can annotate the table so that the compiler will stop
complaining but remove the table nonetheless if it isn't used. Similarly
to what we can do with

	if (IS_ENABLED(CONFIG_FOO)) {
		...
	}

constructs. I can't really think of a way to do that, though. Perhaps
gcc will throw away the table anyway, so we'll just need a way to make
it shut up?

Thierry

--BwCQnh7xodEAoBMC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSOt4fAAoJEN0jrNd/PrOhhfgP/2n44EedI+4yGfxiJSYeK3LW
Od9cT6CGmyRmCAw2dzcpWrvP9oIOkq/kCnOUmfsawX7eJnnsWyDL2aZtTT3qcaGq
ASmABxlpl2FI8+t1PJ4w/MmFiKyWRUCIV1p4Xt6rtlLeMmNTRZUtxuPx+2Qd8OOB
yE5HfTlc8kYEDDTvLSp4+AwAwrRWuQAXikJYL/5vDjRdLas0wLkNBkmAThXXpDr4
Ha7aVKbVgmEKRtPoach3xtdkWiGpZNHZQSM8jFumVv2eVEM+oq5nJzj5iLjCJW7n
/9kqxOajZ9C7+jEQ3cjJOYVnL/sfKMCKxl55Z/lgNEWgr9MWVTsWX9N65srYzZb0
Ue1NoQYFpVZusw/ILgKG14f3dXkRT4iC8srDw6sGg0ohrkIZ8Vmjsu6atPXspcY7
JGbxMKYJSCFeVhHLurknTuqxgYnTPT9aaaHPZ3eRLj1D0xkpYL1HM2LWSt937pgJ
3KzgvDvz29pzOzD1qbNbjvTcGCuZ6Yv7Bkt49I0LFAIbk9PBiZ+2FmmcwXjfrRVh
VgZixTqOJPgTPHdLlOSk3bhoOOkCiRhrmFWjXmCs2b85AuIPaTX0ANpc1YKDLSFO
8ngP3bcXLOKbs1B9TgCTLhIRprCDdRgoJyeyw4D79dTlraJlUtWJOjcBmvGhgTRL
CiTHi7LKlkzRlyEhxQzj
=EKGL
-----END PGP SIGNATURE-----

--BwCQnh7xodEAoBMC--
