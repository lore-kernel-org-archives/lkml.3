Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756268AbaCRQTx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 12:19:53 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:57150 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755044AbaCRQTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 12:19:52 -0400
Date: Tue, 18 Mar 2014 16:19:23 +0000
From: Mark Brown <broonie@kernel.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        sameo@linux.intel.com, lee.jones@linaro.org, lgirdwood@gmail.com,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Message-ID: <20140318161923.GF11706@sirena.org.uk>
References: <1395139757-6907-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <1395139757-6907-5-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <20140318111542.GK11706@sirena.org.uk>
 <20140318160701.GD1665@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3Y2Mr1SP1gWKl0+e"
Content-Disposition: inline
In-Reply-To: <20140318160701.GD1665@opensource.wolfsonmicro.com>
X-Cookie: Turn the other cheek.
User-Agent: Mutt/1.5.22 (2013-10-16)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 4/8] regulator: arizona-ldo1: Add processing of init_data
 from device tree
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3Y2Mr1SP1gWKl0+e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 18, 2014 at 04:07:01PM +0000, Charles Keepax wrote:
> On Tue, Mar 18, 2014 at 11:15:42AM +0000, Mark Brown wrote:
> > On Tue, Mar 18, 2014 at 10:49:13AM +0000, Charles Keepax wrote:

> > > +	np_init = of_get_child_by_name(arizona->dev->of_node, "wlf,ldo1");

> > You're missing an of_node_put() for this and if you're going to use
> > hungarian notation please use a convention other people use.  Calling
> > things _node seems more common.

> The DCVDD one needs an of_node_put but I am not sure this one
> does. As it will be copied into the regulator device of_node by
> the regulator core so wont of_node_put be called when the device
> is destroyed? Admittedly I haven't checked that but seems
> sensible that the device structure would put its of_node when it
> closes down.

You just took an extra reference by calling of_get_child_by_name(), you
need to free it.

--3Y2Mr1SP1gWKl0+e
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTKHIIAAoJELSic+t+oim90E0P/iHHIsA1CoaQO2jm+zvh3zWp
PWbMEXNDO51FlvLi96d+U9TeeshhhI8WAnu+a38YIYrm/icySRqIYWvxnBCpm6b9
eXinFu8AkboxzeY42v3EduV4D6pk+KO99bHArqEkMfJWmjOr34rNRN8iFNdCvaLc
jfniGsKrqEBFkhbXxtA0WmiMIGnmekeu/MLJQkVcLG3r1HSO0gXAUF9CYTXB71Cw
2+T44FqHhwEHBeCdymILvEjGpocRbrsXxnsrvnyBQHQDUK7f2YJdoH0YP2BFnRNM
m/YQOuphWHimCY+5v9RtPMNFGgFvAHMwt65LQJNaP7H1R9fgAqHj70/2dl1pMt4G
H2VxqY3iiAiRzS+PIhRqhZYV9fd0fvn0g+xbSnR1W4R/Yy9u7SgI3+v5AzPgQhmw
FjGpA2gn1EH7C3+lS3pOIEaOVA4Ow1JetnhV/7Ta0hfFFWpLZKu2pCszikZCCJnH
lc+ITeuyIgAEF/ukAQPEMafmoIRCUdC9VqRh8ke5Ds2Sd93vPky2paZ7z/h1xYGn
Z1DqIuk/r0cNW9rQiktL4rVks9k7taGvOZj0/2d4ZVYRy9GxQETJIXTy9G97Z0Rb
FYJmpldX3XncMnrNhSyWjRtS7XbUADN+NGpvrw9i6xdeqhBbIngGXbog1+jY7fNl
WnRNw0tPWq0et9I9HoUY
=KMnn
-----END PGP SIGNATURE-----

--3Y2Mr1SP1gWKl0+e--
