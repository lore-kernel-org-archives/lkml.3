Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057AbaDWLmg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 07:42:36 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:42796 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660AbaDWLme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 07:42:34 -0400
Date: Wed, 23 Apr 2014 12:42:17 +0100
From: Mark Brown <broonie@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        monstr@monstr.eu, pankaj.dubey@samsung.com,
        Samuel Ortiz <sameo@linux.intel.com>, arnd@arndb.de
Message-ID: <20140423114217.GW12304@sirena.org.uk>
References: <3eb785d83c406f4a57508dc03610b05492e12bfd.1396969250.git.michal.simek@xilinx.com>
 <20140423100530.GG21613@lee--X1>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DIb3sg5pdHOHT/bM"
Content-Disposition: inline
In-Reply-To: <20140423100530.GG21613@lee--X1>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3] mfd: syscon: Support early initialization
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DIb3sg5pdHOHT/bM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 23, 2014 at 11:05:30AM +0100, Lee Jones wrote:

> > +struct regmap *syscon_early_regmap_lookup_by_phandle(struct device_node *np,
> > +						     const char *property)
> > +{
> > +	struct device_node *syscon_np;
> > +	struct syscon *syscon;
> > +
> > +	syscon_np = of_parse_phandle(np, property, 0);
> > +	if (!syscon_np)
> > +		return ERR_PTR(-ENODEV);
> > +
> > +	syscon = syscon_np->data;
> > +
> > +	of_node_put(syscon_np);
> > +
> > +	return syscon->regmap;
> > +}
> > +EXPORT_SYMBOL_GPL(syscon_early_regmap_lookup_by_phandle);

I don't know what this is doing but it looks dodgy, we're returning
something stored in the DT node after dropping our reference to the DT
node.  For FDT systems this probably makes no difference since we don't
actually free the node but someone might decide to do something like
clear data that's associated with a node (however that happened) when
the node goes unreferenced.

> > -	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > -	if (!res)
> > -		return -ENOENT;
> > +	*syscon_p = (struct syscon *)&syscon;

What's this cast for?

--DIb3sg5pdHOHT/bM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTV6cVAAoJELSic+t+oim9mVwP/1Z0gYhiXUxGNQqd6JGp04XT
0vDtE3F9T70vWmsPvcUtJ9aq0pqzmopHCqkzFDL6exyHY/2VcqdiqubCzizV20Bh
wVEwJHc4/aVphKdEnJStNGVoS5X/6ozjFqZP5N6J9Y/YVhem7/5InpZhSGLyT0+e
sZLmq8xar5K18tMNbxt+9dwnYR6jkcyasW+SX2807mpk5wmN+JCMdFQKo/8HI2an
lFsqd2a7MYJAA26NoDV8A8GAtG4NpoK3KUtd0RrJxG3EEnBlr4iL6+fGfUxMbHBu
ZdfIrBxQman5BEe/xFgwgfk4mYPXtbuI/p1fphIWNXftIXb1GONvw9/jYx2PkZJo
SdZYEfPJzxdnBztRn0+/FoQAs2HZOb4tUXCXpnZTZQSraHPSmvJnmFuRhyKDcdyS
88ECGPmbgc2qbP4j8fyIVCCzsDKxed2qKYe5Fx8RboZPAFs7k0KtpLPt8E2Ktg49
Ds/r68ji3sIW4YR5zh1r7aQYjQabn/WZ4O8Te1gaPwyPTK01s4OwvopBMuKdNiKO
RaqwhQotXyMNTcJ+UJ+UkI61ap49oMqmwYNpM4HPJ05Gcb1cUPRyNNzPYF0QUw8F
wtawFJOYzMfnGxOHEfP34qfNzR9eqFAQEKZCW9d9PHSRNrjU0/4QLc2umaU92dAn
hn9IvMbhEjM6MD91T28L
=H9kr
-----END PGP SIGNATURE-----

--DIb3sg5pdHOHT/bM--
