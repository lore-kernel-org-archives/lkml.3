Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750949AbaGUWwH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 18:52:07 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:48497 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbaGUWwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 18:52:05 -0400
Date: Mon, 21 Jul 2014 23:51:53 +0100
From: Mark Brown <broonie@kernel.org>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Terje Bergstrom <tbergstrom@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20140721225153.GJ17528@sirena.org.uk>
References: <1404303560-32209-1-git-send-email-acourbot@nvidia.com>
 <1404303560-32209-5-git-send-email-acourbot@nvidia.com>
 <53B42B60.1000600@wwwdotorg.org>
 <53B4C9C0.4000605@nvidia.com>
 <53CD333F.2070805@wwwdotorg.org>
 <20140721211630.GA12076@mithrandir>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="w47z9evyjOavafUr"
Content-Disposition: inline
In-Reply-To: <20140721211630.GA12076@mithrandir>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 4/4] ARM: tegra: roth: add display DT node
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--w47z9evyjOavafUr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 21, 2014 at 11:16:32PM +0200, Thierry Reding wrote:
> On Mon, Jul 21, 2014 at 09:35:27AM -0600, Stephen Warren wrote:

> > > vdd-2v8-display needs to remain always-on however. Here we may hit a
> > > limitation of the simple-panel driver, where only one power supply can
> > > be provided.

> > Can't we fix the simple-panel driver to allow a list of regulators in
> > the property?

> I have no objection to allowing that. But I don't think there's a way to
> do that with the current regulator API. You can use the bulk API, but
> that requires separate properties, not multiple regulators in one
> property.

> Perhaps one idea to solve this would be to make the regulator API return
> a regulator handle that in fact controls an array of regulators? Adding
> Mark.

I'm really not comfortable with that idea, it seems like most of the
users would be abusing it - one of the biggest issues is always getting
people to understand that their driver may be used in other systems with
the supplies mapped differently.  If you were going to do something
along those lines you'd need to do something that enumerated all the
supply properties on the device.

--w47z9evyjOavafUr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTzZmAAAoJELSic+t+oim9nwUP/jK/eXoKVl99dSmhUmDtv+9E
CeL0oOyWN7ovsIbFi800l43DW19imQqvN6JA2lwWqGan0uZ7EyChCqe3ttv9y8Ul
a5HtfqM8Yhoigosz6FMmVLhY2//XAaYpnUBTrjo3SZmN4ZDdI6cNWrTRx1IhJHIM
YNR9mvCLQJM3B8/Fxh+FM8Ayly3rdkvzIVbfurw6bhqQ1z06zWTO8bGdXFaKU+xh
YgBMDrtH1ctgNlCwsD35MdNjh6GD4SYrWOyR3s7Ki0v5VI0RdMxGBbW7j/m+h6Zf
PvJrjqUsqpM/FX1GsIHttsm6+Cmhj8cQuvStBgOKIP4TQuML5Q/k58R914bUAjv7
Oy0Zhrs0Xed+S95sL9Va0B45El4reSe+GGRDwD4etFojQ36zCUZOlamzRwtZ3AKB
eDmMwdh53DHWL6iYkwsQVT15L7yLc519SRHh6/M0jjYfjpCc3OjXCx7VmFBJToOD
4zSc8ObXFEcBY+6JEES/I66PY/7lQ50cEfeOAu+MWpKcTxtJscYCDsKibMo3lT+8
etEAkPGqCPO/DOB0CedkAF0/vfqu+1sd3dN5nS4M1ovv4tsIztLaI+QWMqcquLAc
vQo8SfPKXlsdoJ2kEZaYIVhuuj+pBuztkPQPqXQjDbzdKQROqssH7GocuT3iHbpa
P18re0tQtirmXt9c4mS+
=3it+
-----END PGP SIGNATURE-----

--w47z9evyjOavafUr--
