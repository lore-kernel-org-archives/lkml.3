Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752992Ab3KNKZG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 05:25:06 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:52372 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752881Ab3KNKZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 05:25:00 -0500
Date: Thu, 14 Nov 2013 10:24:19 +0000
From: Mark Brown <broonie@kernel.org>
To: Kyungmin Park <kmpark@infradead.org>
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Anton Vorontsov <anton@enomsg.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Message-ID: <20131114102419.GE26614@sirena.org.uk>
References: <1384328457-5147-1-git-send-email-k.kozlowski@samsung.com>
 <1384328457-5147-2-git-send-email-k.kozlowski@samsung.com>
 <20131113131328.GF878@sirena.org.uk>
 <CAH9JG2U9VDnRW9JZ7j7OyRmVhSXWJ5Yp_gNqUPK=xCST7SY=xg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EgVrEAR5UttbsTXg"
Content-Disposition: inline
In-Reply-To: <CAH9JG2U9VDnRW9JZ7j7OyRmVhSXWJ5Yp_gNqUPK=xCST7SY=xg@mail.gmail.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 86.30.59.107
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/4] mfd: max14577: Add max14577 MFD driver core
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EgVrEAR5UttbsTXg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 14, 2013 at 10:33:22AM +0900, Kyungmin Park wrote:
> On Wed, Nov 13, 2013 at 10:13 PM, Mark Brown <broonie@kernel.org> wrote:

> > Are you *positive* this is a falling triggered IRQ?  All the code to do
> > with spinning reading the GPIO state during handling makes it look like
> > this is in fact an active low interrupt and a lot of the code in here is
> > working around trying to handle that as the wrong kind of IRQ.

> It's not work with level triggering. as wm8994, it requires edge
> triggering. previous time I send RFC patch to handle edge triggering
> at regmap.

No, wm8994 is level triggered only - the edge triggering stuff there is
to work around some SoCs that could only support edge triggering and not
level triggering.  Is this a similar issue or is there something else
going on, what's the differeence with a level triggered scheme?

> >> +static int __init max14577_i2c_init(void)
> >> +{
> >> +     return i2c_add_driver(&max14577_i2c_driver);
> >> +}
> >> +subsys_initcall(max14577_i2c_init);

> > Why not module_i2c_driver?

> there's ordering issue, it should provide regulator which is used
> others before USB probe. if not, it failed to use USB.
> Other PMICs use also subsys_initcall for this reason.

Modern systems should be able to use deferred probing to resolve these
dependencies, subsys_initcall() is mostly there for legacy reasons and
new systems ought to be able to move away from it.

--EgVrEAR5UttbsTXg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJShKTQAAoJELSic+t+oim9sXwP/3Ciaj6wWtzmt1TEQMOaI4iV
XkCLNoGLC4+sr+75gTI/BwP4K3l0c1D+r4awlcrV3UTDul7EXhPm1IGtm7dVH2LJ
cBH+VS8NgkDhJjT/SKHv+Yjd/yBY9SGxMf4bkE/FbZdA+znHpI5tS/Pirv9ftnvi
IZCnC2lygoiqJxjLWLO7l/nqkDUiBIYv6OaY0iNbghg2QUFE4M+uA+I+lqfVSvEO
6pYCzVxe2akjly3Yxb0lFmTncTATSWQ+pHBmHc0yHAetMzqohWS27/4kzMEgtbkM
Qd2mkN5t9wudu0X1/WIqhXCFNvkgJzFJuG2Le+AXTgzN1NPuPzBTpoIT9oUXWVd4
CSbZ9Sn2eHG5KrGMIULt6XoG+jOlHC/6LiBYB9isSCfzzj+7BH5VjtbyBUX85bI8
Cfy2o2Gpiolhrn1pEFUHDoKHRiLOno2I1zlr236BdLQ3SKBNdm5TpKlprJvh0yy2
dg0JMw9HkA67l3oU4m7MG2ZTUUnaptQd3TEp8gJy5rHlNUGRB/dLKc7xS9abagy2
ObkM2Q05ss+2pfAEx/uKVt6iLTuG63E90atA5mqQNwMr5kyP1az6dC1yviUjMbec
e/gBYqjlcHD5NS4ez9RrmQybNbN43txvJZfAvrsSy6JhQpRruh4BcduEvaERL9BJ
9fs58/uLl5R4bn/BxBeb
=dgL7
-----END PGP SIGNATURE-----

--EgVrEAR5UttbsTXg--
