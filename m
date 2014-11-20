Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757055AbaKTIuH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 03:50:07 -0500
Received: from down.free-electrons.com ([37.187.137.238]:44912 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750848AbaKTIuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 03:50:04 -0500
Date: Thu, 20 Nov 2014 09:49:00 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Sonny Rao <sonnyrao@chromium.org>
Cc: linux-arm-kernel@lists.infradead.org, Mark Rutland <Mark.Rutland@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, dianders@chromium.org,
        Marc Zyngier <marc.zyngier@arm.com>,
        Sudeep Holla <Sudeep.Holla@arm.com>, Olof Johansson <olof@lixom.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH v4] clocksource: arch_timer: Fix code to use physical
 timers when requested
Message-ID: <20141120084900.GC24143@lukather>
References: <1412753937-29343-1-git-send-email-sonnyrao@chromium.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Bu8it7iiRSEf40bY"
Content-Disposition: inline
In-Reply-To: <1412753937-29343-1-git-send-email-sonnyrao@chromium.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Bu8it7iiRSEf40bY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Oct 08, 2014 at 12:38:57AM -0700, Sonny Rao wrote:
> This is a bug fix for using physical arch timers when
> the arch_timer_use_virtual boolean is false.  It restores the
> arch_counter_get_cntpct() function after removal in
>=20
> 0d651e4e "clocksource: arch_timer: use virtual counters"
>=20
> We need this on certain ARMv7 systems which are architected like this:
>=20
> * The firmware doesn't know and doesn't care about hypervisor mode and
>   we don't want to add the complexity of hypervisor there.
>=20
> * The firmware isn't involved in SMP bringup or resume.
>=20
> * The ARCH timer come up with an uninitialized offset between the
>   virtual and physical counters.  Each core gets a different random
>   offset.
>=20
> * The device boots in "Secure SVC" mode.
>=20
> * Nothing has touched the reset value of CNTHCTL.PL1PCEN or
>   CNTHCTL.PL1PCTEN (both default to 1 at reset)
>=20
> One example of such as system is RK3288 where it is much simpler to
> use the physical counter since there's nobody managing the offset and
> each time a core goes down and comes back up it will get reinitialized
> to some other random value.
>=20
> Fixes: 0d651e4e65e9 ("clocksource: arch_timer: use virtual counters")
> Cc: stable@vger.kernel.org
> Signed-off-by: Sonny Rao <sonnyrao@chromium.org>
> Acked-by: Olof Johansson <olof@lixom.net>

Has this been merged yet?

If not, you can add my Tested-by, it makes the Allwinner A31 boot
flawlessly with the arch timers (together with the patch "clocksource:
arch_timer: Allow the device tree to specify uninitialized timer
registers")

Thanks!
Maxime

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--Bu8it7iiRSEf40bY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUbar7AAoJEBx+YmzsjxAgm3EQAIUedeLNoc1+K4dpNr4ckolN
KRYTd2icTo1QqQZz8ildRXWrEfY0/WAH+WK+Y62ZVJOdjUeB5+AbC/9WtM4Py4Y9
mT9zgpL2n0JRp9I6/2fO0l28piVHdkK9uXw6eEdJLKLYapqAMKWUowLR0joX2OZ4
8YCwZ9FnQsH0+D0gUBjcxpgyGVxwm6kuD7Nv7YFplwB0XIdn/WuEaFDOw0N4BCXQ
k7t7HnlULe91jJFYNtpvKb5f5E7/wyYpfQGtMEp2BBOaGQ4jD3zc1vvUaQSKmWFr
v16jlUc/WSS9BjgDLOqZM1JioGcn2ZQ4fFatd1jK5ViJ8rgxyc/U0hQMBP567DKo
jA2EjT4lBcv/DISuF7FKVHwkBlw49LtQ5UC6TY13XYTEEVQzZetF6/P3wnrjb8mG
U2BIdxnKa669CsZuHv+3Pr1qkMYUFrxzoEi59odZOt72pp/aph29EL5zqzzQLohF
6K/cq+IwzsA/Z/JSfCwXulsQ4yR2eF/9kPpSnfMZi0n2eEOYtn2szeuSoQlMdnJt
YNOOuYhHp3fKSmQuNJBO1JIldVreYRBuEpLnO6WSLIvDy4XTUYQBEb/52c9Y6rLr
LvyfgQYYVWtvW1ZcdPZkq3hMxGTNsVpLxXggHM693qqv4EHupsakF43E33YRWWJF
ScXQUK7Zab4dKhSdIa6w
=BADU
-----END PGP SIGNATURE-----

--Bu8it7iiRSEf40bY--
