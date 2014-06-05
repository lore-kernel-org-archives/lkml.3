Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752952AbaFEPuL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 11:50:11 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:55629 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664AbaFEPuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 11:50:08 -0400
Date: Thu, 5 Jun 2014 16:49:31 +0100
From: Mark Brown <broonie@kernel.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: carlo@caione.org, Boris Brezillon <boris@free-electrons.com>,
        lgirdwood@gmail.com, lee.jones@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kevin.z.m.zh@gmail.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com, zhuzhenhua@allwinnertech.com
Message-ID: <20140605154931.GY2520@sirena.org.uk>
References: <1401297069-7423-1-git-send-email-maxime.ripard@free-electrons.com>
 <1401297069-7423-4-git-send-email-maxime.ripard@free-electrons.com>
 <20140528185051.GB22488@sirena.org.uk>
 <20140603131204.GJ27722@lukather>
 <20140603144319.GD31751@sirena.org.uk>
 <20140605142729.GG5765@lukather>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Cou6PmgoyP0+llr2"
Content-Disposition: inline
In-Reply-To: <20140605142729.GG5765@lukather>
X-Cookie: Your lucky color has faded.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 86.140.13.77
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3/5] regulator: axp20x: Update the bindings to use a
 local parent regulator
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Cou6PmgoyP0+llr2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 05, 2014 at 04:27:29PM +0200, Maxime Ripard wrote:

> You already list the regulators available and their supply in the
> regulator driver, why do you need to set the regulator parents in the
> mfd driver as well?

Unless they're being used by the MFD directly there should be no need
for the MFD to know anything about the supplies.

> My guess is that it's to work around the fact that
> regulator_dev_lookup only looks for the regulator's device of_node (so
> not the PMIC one, but one of its child), which doesn't have the supply
> properties, and then just falls back on the regulator alias
> list. Would it make some sense to add a lookup in the parent device
> of_node (which would be the "main" PMIC node in our case)?

This sounds like you are passing the MFD child device into the regulator
API when you should be passing the parent device in.

> Also, there's also the fact that all the supply properties seems to
> also be mandatory in the DT, even though the regulator itself might
> not be used at all on the board, and the input voltage not wired to
> anything.

For electrical engineering reasons it's unlikely that the supplies are
actually floating but yes, they are mandatory.  This is an issue with
registering one device for the entire regulator subsystem on the PMIC,
it interacts somewhat poorly with deferred probe.  However for systems
with full constraints like DT and ACPI ones it should be mostly
sidestepped since the if there is no supply mapped a dummy supply will
be substituted.

--Cou6PmgoyP0+llr2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTkJGDAAoJELSic+t+oim9+CAP/0x66+3T6sxnSiaMeTAbHGIV
vP86d0HAtJqwV23CGcW768IctbSwdd+wfH9qUAwJ5/8ykzVKeWUZnJ3nuH+g0D+z
q8sc4y3BBLj8rXB73lXVwfCOXSJWjBpct/g/3HQVExZeP7rY2OJP1h1fKWW922o1
IaJ3IZ1kniJ2B31W9Rhx43uhlSsw6/aIafi41eBqTmUakLBfBMh5qWjMtWALP3WU
10ktLzDE50k5M/zYJJj3AMkLWiGywDWT87ts8EH4Xk7GIqU6iFfrV63uv9Hv7Qoe
FjPqwOFwX+F81fMNDhoPtJk70Mv+sOwMVWpWwYe8ov19xhxJ8y8W06IEnuCmTNg7
/+SyNs97DwN0sXfOb89dnh2OAU33k+4T6aDPk5lB+Z0vk5eFGsKU8PdG7pXwg0pC
gvBg7sF/Is9Xdyj68SFSjWoxxt1E3YrEMHXqseBcGZjXBBG/FRDdjl+l/DqqrWOh
IwjqtCa7WfLpEzzsZDQL5jFLONRJvu82omXPQv33toDK46ZXJkml6FisCcOQkrwk
Ur4/DzjO0GdhY+OGd4d1wBZC19zgUT4UlUYTnI0XIQaRVWYPhcprD1COF2NoPwpe
qBX0z1KU7dhEHRr0qy7/FRvce2THVuwMewigU8iVLmv2iLwtDKkH7lDGZCR0z1Jg
Pg95L/HOnlPhO5hfHXvV
=ItRp
-----END PGP SIGNATURE-----

--Cou6PmgoyP0+llr2--
