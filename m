Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822AbaKYLH5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 06:07:57 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:37868 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754038AbaKYLHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 06:07:54 -0500
Date: Tue, 25 Nov 2014 11:05:41 +0000
From: Mark Brown <broonie@kernel.org>
To: Pramod Gurav <pramod.gurav@smartplayin.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        lgirdwood@gmail.com
Message-ID: <20141125110540.GL7712@sirena.org.uk>
References: <1416912803-10772-1-git-send-email-pramod.gurav@smartplayin.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="M9Kk/RdPrqDAodVL"
Content-Disposition: inline
In-Reply-To: <1416912803-10772-1-git-send-email-pramod.gurav@smartplayin.com>
X-Cookie: Celebrity voices impersonated.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC PATCH] regulator: core: do not disable regulator if boot_on
 is set
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--M9Kk/RdPrqDAodVL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 25, 2014 at 04:23:23PM +0530, Pramod Gurav wrote:
> Currently the regulator core disables the regulators which are unused
> or whose reference count is zero or if they are configured always_on.

No, it does *not* disable them if they are configured always_on (as the
code you're modifying shows).

> This change adds a check in this logic to see if a regulator is
> configured as boot_on and does not disable it if found true.

> -		if (c && c->always_on)
> +		if (c && (c->always_on || c->boot_on))
>  			continue;

This isn't what boot_on means.  It just means that the regulator is
expected to be enabled at initial power on, it doesn't mean it needs to
be enabled all the time.  Otherwise there'd be no point in having a
separate always_on flag.

--M9Kk/RdPrqDAodVL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUdGKEAAoJECTWi3JdVIfQzbwH/20Ey4/j+ekiC9dCtHq2NLEV
uk9hvyY9fbr/mSrbi2T4jVXN3CGfBgqk0fw3Qp03aejDTPg74FLbbs32EXTl4Crb
bttFDJ1xTHy8DeQAaxpeJn2RVsN/9QfATJYmuhS+cmVccCsVnoUOnsYii9Wg1nwb
IGJx1cb20aY5FfUZOUJCevrZZjxr60I6zf98KRRTZPUw55hgYbFbQ4Vr/B96XhsT
0+srXgzszoOVZyDyx9VaEYxjKJAiqvQNUZCpCtjqfgFk8WOdE78TMM3/Yzb2s48P
SC8zq7/qobpIh9G7UMyR9TkEeePVx1LpKa9aISDaA7ooa9e6FgRnHWT9phlUcfs=
=yJpw
-----END PGP SIGNATURE-----

--M9Kk/RdPrqDAodVL--
