Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752920Ab3IYSoq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 14:44:46 -0400
Received: from top.free-electrons.com ([176.31.233.9]:39574 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750814Ab3IYSop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 14:44:45 -0400
Date: Wed, 25 Sep 2013 21:44:35 +0300
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: cinifr <cinifr@gmail.com>
Cc: coosty@163.com, Daniel Lezcano <daniel.lezcano@linaro.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "pawel.moll@arm.co" <pawel.moll@arm.co>,
        Rob Herring <rob.herring@calxeda.com>,
        "linux-sunxi@googlegroups.com" <linux-sunxi@googlegroups.com>
Subject: Re: [PATCH V3: Add Smp support for Allwinner A20. 1/3] Add smp
 support for Allwinner A20(sunxi 7i).
Message-ID: <20130925184435.GH2954@lukather>
References: <1379852488-32147-1-git-send-email-cinifr@gmail.com>
 <1379852488-32147-2-git-send-email-cinifr@gmail.com>
 <20130923181707.GR2779@lukather>
 <CAK3cCBwLrnV7L9WzJ+1P_62PEjEEtgzVjFH8m6SZzWG1O+2vEw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xHbokkKX1kTiQeDC"
Content-Disposition: inline
In-Reply-To: <CAK3cCBwLrnV7L9WzJ+1P_62PEjEEtgzVjFH8m6SZzWG1O+2vEw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xHbokkKX1kTiQeDC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Fan,

On Wed, Sep 25, 2013 at 12:22:44AM +0800, cinifr wrote:
> > You still haven't said why you don't want to use smp_init_cpus there.
> I find that of_funcation liking of_find_matching_node and of_iomap can
> not run well in smp_init_cpus. It cause kernel crash. So I have to use
> early_initcall.

Ah, right.

Then, can't we use smp_prepare_cpus for this? it looks to be late enough
so that we can use ioremap there.

I don't want it to be an initcall. The code will be different on the
A31, and we don't want it to be run on all the other machines whenever
we boot a multiplatform kernel anyway.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--xHbokkKX1kTiQeDC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSQy8TAAoJEBx+YmzsjxAgEJMQALv6+l3exqacAQSZl2VX72qB
T4u3FduML2CLMERDdp9B22uL5UecDSxn7dkWF8Q/IpUsJ1m2YeFOVqELCjkIa313
/qwuuKoH0dS99ClmviSqaKZDRqMYVmsZHcVY/isw25RYJa1tMIXTrxfi1Hy2rjSl
bJCIZ2mVRNXLlb4x0d/p56Wh9Zfs7+Byg7yBoVBjE2jWeQmxi7l2sQfgXVy2q1sU
Vp/YiJ4lHft5E0ms05YrJq8OXnwc8x2URCrwgvB2qeXgMY64EoJoD4f6Gyws6b0M
2+JrjRJnW9xWV4IWMMbcXA5w0r3N+LbovPqkQlpL/RrY/WxwBhWapWde4k4S95NU
vfpKKY5hkNru9Mlg3b+UByxHDxLO8LznIyhQiJfgc+EtAaSb4M+eqXsHHcj31J5S
F+tXgdF6uftTf8z3gxkpIw/md/+pjEbU3wLpvM10ftwb3ySSZCna1+7rN7UyOXXI
fmZgd4EC7C9pqp1SAYJnc6SaABB79zpWr2lCLL9PBkbWecSebayW7gsd5DtQhHLz
KxVef/WkhdMh0mv4UbaAs71FxVMpwQE8DvKIX09r5WgKyCDCg7hW2BSW4LkLqsbH
vYDkEwHZJ9Ofxxl8m1E6NM2CHEVjIDcJ5XFYxFrO8wj0ZXw6W992koJDqnsBKXyn
yaTlzzvQpjonnokQiOeB
=OvUD
-----END PGP SIGNATURE-----

--xHbokkKX1kTiQeDC--
