Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933964AbaHZHbJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 03:31:09 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:38478 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933945AbaHZHbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 03:31:07 -0400
Date: Tue, 26 Aug 2014 09:31:03 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Doug Anderson <dianders@chromium.org>
Cc: Heiko =?utf-8?Q?St=C3=BCbner?= <heiko@sntech.de>,
        Caesar Wang <caesar.wang@rock-chips.com>,
        Sonny Rao <sonnyrao@chromium.org>, Olof Johansson <olof@lixom.net>,
        Eddie Cai <eddie.cai@rock-chips.com>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tomasz Figa <tomasz.figa@gmail.com>
Subject: Re: [PATCH 1/4] ARM: rockchip: rk3288: Switch to use the proper PWM
 IP
Message-ID: <20140826073055.GD15573@ulmo>
References: <1408381749-14156-1-git-send-email-dianders@chromium.org>
 <20140820153801.GB3427@ulmo>
 <CAD=FV=Xf4Hm5tCaaW3QG-ZSQGovh6RKH=1Og1K-yxj+jKyGsmA@mail.gmail.com>
 <2927513.T62GI7nq9T@phil>
 <20140821063637.GB4486@ulmo>
 <CAD=FV=XKr0T-mwma1WdTKQDVyS06rbj3=J4GwbAkc1KsXQspOw@mail.gmail.com>
 <20140821164705.GA1172@ulmo>
 <CAD=FV=U6S3idZds57G2itFw6mdb-fTVt41Lv_jpBuNuq0fimnA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PHCdUe6m4AxPMzOu"
Content-Disposition: inline
In-Reply-To: <CAD=FV=U6S3idZds57G2itFw6mdb-fTVt41Lv_jpBuNuq0fimnA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PHCdUe6m4AxPMzOu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 25, 2014 at 04:40:57PM -0700, Doug Anderson wrote:
[...]
> I was doing some thinking about what to do, then.  I wondered whether
> the right thing to do is not to make a "rk3288 syscon" driver that
> configures these bits, but rather to make a "rk3288" driver has access
> to the syscon.  It could live in drivers/soc/rockchip/rk3288.c and we
> could give it a handle to the syscon.  It could do the one-time
> initialization.  It would also be a place to put special rk3288 APIs
> in cases where other drivers need similar things.
>=20
> What do you think?

Yes, that could work. There have been recent discussions about adding
such machine drivers that match on the top-level compatible string in
the DT.

I still think that subclassing syscon would be the cleanest solution,
though.

Thierry

--PHCdUe6m4AxPMzOu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT/DevAAoJEN0jrNd/PrOhdSIQAJ3w4525yRQR1KcGeC3Pb4h3
FWR4AZqfVEaFiHS+md8yHmreiTEL0EyICvlSEMM9gzEtsSCnLFkUglPw3XCcyd44
wNzqU92180xI+WQAoH17xijXkoAYc69TRocnsCu2ddreDunBVZgbxVSKwZo39Sbq
9rqPv7ecuQLDsb5B8RrNQDmzd+HCBJjjKXjUArW10vkjaYDKYoUBR2Nijas3suYe
J3S3UDZ8bwDZg0Mlwx3Dv28wlxuEBvX+euB33nhEyIsbpWok5RQn9bAPuaKlaip3
B5+/5umjsw7bfWii4o/14UvW4lpO0sPrLgLd0iJHxJWwURUSr7nvLNkQ8Y428p4d
yJuz6PD8xwXMu+M++LRm7DEcxaIr08jn3ekHsAfmgKf9YpH4ktO4u429URfRlWIG
S8pkc3fm6xQ5EqkrZnNWd17Fb2+k668Cp6WihE0PKd1MzTAc1nb1YPZXNsLAjjvQ
HDL7Lmy+KjzUCFXkTGBj1jdWctDwTBl3Et58efA769FUuI+smbgcVuWMbALksxAu
jzYz+lRz7OeSeLOpsxMPtoIVlLNpqbFZKSBa9rGEySSK4WgXL5DVrL1U7gANgw1R
RZRhF9PX4qvuFPNbMSaCPjxlUUU7BZnwlU0USP4pD03z5/oCXqNpmRzA+Cj3rk6t
Q0Ymng20Mg5Al09Hjxiw
=cPIp
-----END PGP SIGNATURE-----

--PHCdUe6m4AxPMzOu--
