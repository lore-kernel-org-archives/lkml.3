Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753185Ab3CGHO1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 02:14:27 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37001 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751184Ab3CGHO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 02:14:26 -0500
Date: Thu, 7 Mar 2013 15:13:52 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ashish Jangam <ashish.jangam@kpitcummins.com>
Cc: linux-kernel@vger.kernel.org, David Dajun Chen <dchen@diasemi.com>
Subject: Re: virtual irq isssue - regmap_irq
Message-ID: <20130307071349.GF22554@opensource.wolfsonmicro.com>
References: <1362639472.484.22.camel@dhruva>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dWYAkE0V1FpFQHQ3"
Content-Disposition: inline
In-Reply-To: <1362639472.484.22.camel@dhruva>
X-Cookie: Excellent day to have a rotten day.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dWYAkE0V1FpFQHQ3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 07, 2013 at 12:27:52PM +0530, Ashish Jangam wrote:

> In regmap_irq if irq_base is unknown then regmap creates virq starting from 0
> and it seems that in kernel 3.8 virq 0 usage is not permitted, since during irq
> registration kernel throws a message "error: irq_desc already associated".

> I'm not sure if this requires fix in regmap_irq or kernel, can you please
> comment on this?

This is a bug in your platform which will affect anything using a linear
domain.  The platform isn't setting up its interrupts correctly so that
the core knows that those interrupts are reserved, ideally the platform
would just use domains for everything but at least irq_alloc_decs()
needs to know what is going on.

--dWYAkE0V1FpFQHQ3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJROD2kAAoJELSic+t+oim95osP/177t9gAbGbYyjvdbahq3C/R
4+WEpZLD8vJFyatz+yEoOpYOGt2+3blj+W5F1xHZC3VE2kRO0/z60TlkkDs1W4cf
brEkItof7jtDsEZwMnobE/ctcPgetapwR/vkWF+0fFAoy0A359RhgxUDZbOqQDZu
eYnQpKOSCtJJIiMQK8W/fAcH8BXb6YafTs2GdalYMH9hy7Xn9XVdPrhNA8y5g9sI
0QSDwyhBL+FU5FCRynVxwU6yZBmfqSRX2rhpfM00G2wrRUQBCG1RXsAULVXSrW0U
lT0PilR/NJyNuCQuuTQnxJztpEteE0xkiMxFS5RqKG1Xijhh9FawKci4s/7wywJJ
ScfnFD035p2hCkUGBL3mcUQNhl4eCxPXUsLF7/y4YRxxAHtxZAeTPqvJNTL592Ui
vl52BdkaOfaEP8ciXrYLCEZ8Z97N2MVmcS5vICVYD6qf/yY7DU8zEQWFTHkDObrA
XW9HHoHusj7EE76kS3KxYylYNc+CzTqxEYfSVukFBh9IoorFLXnJaDI3WYPX1Ynj
QjbTAnGET9Y+U1UONXRJNg24pqD1uqwolj2mUB5MuFlQji7oUV+TyFgXB9G0Exuq
47yqG79EgkNutHJYP5eCstAujWdr8tU6ulO25krs2ozyGr8og+WKEbuFGgiCOi0y
BVO0at2Q/6VQgMoW2ihv
=aGvz
-----END PGP SIGNATURE-----

--dWYAkE0V1FpFQHQ3--
