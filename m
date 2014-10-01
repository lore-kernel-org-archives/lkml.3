Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752357AbaJASII (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 14:08:08 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:57253 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762AbaJASIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 14:08:07 -0400
Date: Wed, 1 Oct 2014 19:07:59 +0100
From: Mark Brown <broonie@kernel.org>
To: Romain Perier <romain.perier@gmail.com>
Cc: devicetree@vger.kernel.org, lgirdwood@gmail.com,
        linux-kernel@vger.kernel.org, heiko@sntech.de
Message-ID: <20141001180759.GH4273@sirena.org.uk>
References: <1412098186-5042-1-git-send-email-romain.perier@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="F/Utwcm1z9NLCQJH"
Content-Disposition: inline
In-Reply-To: <1412098186-5042-1-git-send-email-romain.perier@gmail.com>
X-Cookie: So you're back... about time...
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC][PATCH 1/4] regulator: Add helper function to get
 "poweroff-source" property
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--F/Utwcm1z9NLCQJH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 30, 2014 at 05:29:43PM +0000, Romain Perier wrote:

> +/**
> + * of_get_regulator_poweroff_source - Get poweroff-source for given device_node
> + * @np: Pointer to the given device_node
> + *
> + * return true if present false otherwise
> + */
> +bool of_get_regulator_poweroff_source(const struct device_node *np)
> +{
> +	return of_property_read_bool(np, "poweroff-source");
> +}
> +EXPORT_SYMBOL_GPL(of_get_regulator_poweroff_source);

This isn't really a regulator specific thing - it's common for the
actual implementation to be to simply cut power but it could be
something that doesn't look like a regulator doing it like a system
monitor.  I'd rename this to something like is_system_poweroff_source().

You probably also want to CC the DT maintainers on this and add some
documentation of this as a standard property, not entirely sure where
exactly but I'm sure the DT people could advise.

--F/Utwcm1z9NLCQJH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJULEL+AAoJECTWi3JdVIfQuUoH/3OwQcmOJqD1LIk0cl0vDcO4
99Lu87MH012JMB/WImwSCMAAYbSvjv46SrljzL1rqb6nSAQqj03ITOT/VfZPldFE
v86CXC4ENUqXCdjCtC0KyHtfDSkj0v10NTTFhzUz4eKwESadOZFVeADv9CE4yfbz
vqt59Ja/Zfhq4meMvFj9svEWm8xs3DD0VSL4Rip/oUCXeeMZIlUJzQRwnTwMj174
mbsPyswowvuRuyigYnxDSw7P/3iq2ILyHwvzh8blAyeey5E7trpq3KDfBdDmf3ou
D9QPTuY7aA7r4QMpLHqixviutucIqaFQs0YH0YqSYDWRDMwY6sA2bG6ymVykoxo=
=emsi
-----END PGP SIGNATURE-----

--F/Utwcm1z9NLCQJH--
