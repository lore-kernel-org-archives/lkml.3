Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932194AbaDWPTz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 11:19:55 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:42997 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757733AbaDWPTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 11:19:51 -0400
Date: Wed, 23 Apr 2014 16:19:32 +0100
From: Mark Brown <broonie@kernel.org>
To: Michal Simek <monstr@monstr.eu>
Cc: Lee Jones <lee.jones@linaro.org>, Michal Simek <michal.simek@xilinx.com>,
        linux-kernel@vger.kernel.org, pankaj.dubey@samsung.com,
        Samuel Ortiz <sameo@linux.intel.com>, arnd@arndb.de
Message-ID: <20140423151932.GD12304@sirena.org.uk>
References: <3eb785d83c406f4a57508dc03610b05492e12bfd.1396969250.git.michal.simek@xilinx.com>
 <20140423100530.GG21613@lee--X1>
 <20140423114217.GW12304@sirena.org.uk>
 <5357BA5C.6000606@monstr.eu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uGFHQAFHhqmxrJxI"
Content-Disposition: inline
In-Reply-To: <5357BA5C.6000606@monstr.eu>
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


--uGFHQAFHhqmxrJxI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 23, 2014 at 03:04:28PM +0200, Michal Simek wrote:

> In early_syscon_probe np->data contains pointer to struct syscon which
> stores base, regmap and res - driver private data for system controller.
> (init in early_syscon_probe)
> This is the way I am aware of how to share driver private data without pdev.
> Maybe there is better way how to do it that's why please let me know
> if you are aware about it.

The main issue I'm seeing is that the fact that the pointer in the node
is being used without a reference being held; I'd expect something to
explicitly own the reference.  Either hold the reference somewhere and
hand it off between the various stages or free the syscon object and
allocate a new one each time it's used prior to the device being
instantiated.

--uGFHQAFHhqmxrJxI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTV9oAAAoJELSic+t+oim9AOsP/0oaiVSNi6xUR7OcqpSMZJRN
q/s8sbzgjM3kejE6h2YBrYqCzuHVCchmHZyvdHi11GfyrF20R6lC+xGbXM3Y6OuQ
YWpqaV39pCxsIr5JZj2QbsQ0VPvQZYAZM+Y2zFb3g5e9yQw5AxZV79DmYXh530Td
RFPy+z2pUAQdo7M3Mc+mXVCkhu+umgJIoMJ3SVRl96gSjeR6ExZCVOOcq/S4KEFw
ly1Wd0r3N9Ydp0Wj8NKfc8IQITWxezl27yu/SxZw+9K2Ut/2ua58Z+0KDAyfbDR8
P+VDcWCN1paV6I22ImR8wZrdT1XmrIqHY57b0mWpBS+B0SZZwN1HPchEi2z/EM/O
YaUXeDGtQmhCnw7NOrD+DI4t5N3eOHcPBpmB0dcnFSKpg/s5TX6PhBXQmD6Unese
ZlhoRXqpsq8onMEwNxk50GZOgewLxfYmPiaV8pzEwGBUBpL0U/kvaXAQMjcaaADT
h8xrJws18kC9gOjBPXyF0r/vMDjg3usOfiu3I2sVJkbJuwMWi2xRQa/eMjsf/+tX
J3rrzpGnYUl0XSCqYRREpPGuRzeAHEL/32SZiLdUrzyIxcdphrzf8gROp+K8FBSi
2t7jV97MMWe9HqsiqZjuEsUiGA0rQ8b/tW2SIlgKKOy8iiivv4KnHXsWEOIrpGYJ
i6drqA/X6lmbWmiMS7MC
=E5U5
-----END PGP SIGNATURE-----

--uGFHQAFHhqmxrJxI--
