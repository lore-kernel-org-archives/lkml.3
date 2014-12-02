Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932997AbaLBNQ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 08:16:26 -0500
Received: from sauhun.de ([89.238.76.85]:41822 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932211AbaLBNQY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 08:16:24 -0500
Date: Tue, 2 Dec 2014 14:16:11 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Harini Katakam <harinikatakamlinux@gmail.com>
Cc: Mark Rutland <mark.rutland@arm.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "michal.simek@xilinx.com" <michal.simek@xilinx.com>,
        "soren.brinkmann@xilinx.com" <soren.brinkmann@xilinx.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "vishnum@xilinx.com" <vishnum@xilinx.com>
Subject: Re: [PATCH 3/4] devicetree: bindings: Add defeature-repeated-start
 property for Cadence I2C
Message-ID: <20141202131611.GC4072@katana>
References: <1417514749-24319-1-git-send-email-harinik@xilinx.com>
 <1417514749-24319-4-git-send-email-harinik@xilinx.com>
 <20141202111907.GC23671@leverpostej>
 <CAFcVECLtPx6shBXJbg9Uf_8fnhkMoO1zpoxGcdda7PSA7z_2rA@mail.gmail.com>
 <20141202125203.GA4072@katana>
 <CAFcVECJwFoFd6GrmF282CG+fELnYb=FNCTDq=RYKky_dHha=Jg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eHhjakXzOLJAF9wJ"
Content-Disposition: inline
In-Reply-To: <CAFcVECJwFoFd6GrmF282CG+fELnYb=FNCTDq=RYKky_dHha=Jg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--eHhjakXzOLJAF9wJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


> But given the bugs, it will be useful to just disable it if the system doesn't
> require repeated start.

What do you do when disable repeated start? Sending STOP and START? If
so, this is really something different than repeated start. By using
I2C_FUNC_I2C a user expects repeated start, so if the HW does not
support it, we should say so and don't try to emulate it with something
different.

> If you think DT entry is not the way to go, do you think a CONFIG option or
> something better will work?

No, check at runtime if the transfer is possible on this HW. Bail out if
not.

> We chose a DT property because there is a good chance the user has multiple
> cadence I2C controllers - one connected to a slave that needs repeated start
> (like a power controller) and another that doesn't care.

The user should not need to know with this level of detail if we can
avoid it IMO.


--eHhjakXzOLJAF9wJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUfbubAAoJEBQN5MwUoCm29vUP/joDQCiY2g+Bc/f63BDzYevg
vlqzOgmZghenJ0flPZL06Tx2MQkIHXWVoMn4OisvNmXS0Z+15g7m6sZZCdfS14nj
e/IjuUHR2vuwTIUbXZlxaBKqIqKsXfl0LYVHDr99aABD7iBfIIHzzKmYJ+uuR11g
+Jo5CmW2HzfLz+tTBVS3ZuoM/e+vniuUWNIJsnCN5d4YY/TcBWUNgosPpf1/vp1J
S0KDgJWbD6vIKUADrgz8t8LMUQb2YJbvG4F+BvT6rWb3LouBU0x5XiVdOmX56Cvy
N5mGlqhzSMqOjIJ4NP7qK3o1bxCdU2F8sOlf6MRfIqX6Rs0SumNliDIc9s42CMPA
cizhJ0EkxU2eff/pfsXxQSCJwxtX+Ul+ypA80Y9KE47c4//9OPJeE33i1tZdLJra
6ZrPXVpUyQO78DiaBa3FPaTmyBj3uuZ0X+qCeelFmLjt4JCNMtlTkmL64rMHr/Qw
FEfqMga7HmJWnHGXmiAaasFzdXY4/CQPQG84qMAD+ffxFSZmuzfg3j8Ge7A0rjw7
koDWyh4tiwkOTJgFXbjl6K4goHalnwquYC6ArRnc1l0r7XVIBlcjfK43aKPNnK/j
xwgWPb9f9pASB4GlMqUECHTrOX9psJezna5G3Q0ZzbUlqtDHHKjhATq864a3ewQ8
b87LjQUxtKyPHc+7G2jY
=av0D
-----END PGP SIGNATURE-----

--eHhjakXzOLJAF9wJ--
