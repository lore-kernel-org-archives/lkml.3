Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755602Ab3JKWH1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 18:07:27 -0400
Received: from top.free-electrons.com ([176.31.233.9]:53221 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755498Ab3JKWHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 18:07:21 -0400
Date: Fri, 11 Oct 2013 20:33:41 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Emilio Lopez <emilio@elopez.com.ar>, linux-kernel@vger.kernel.org,
        kevin.z.m.zh@gmail.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/5] clocksource: Add Allwinner SoCs HS timers driver
Message-ID: <20131011183341.GM3041@lukather>
References: <1380117790-19390-1-git-send-email-maxime.ripard@free-electrons.com>
 <1380117790-19390-3-git-send-email-maxime.ripard@free-electrons.com>
 <52436EBE.9010002@codeaurora.org>
 <20131010191311.GL3041@lukather>
 <52572E33.2090609@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aiCxlS1GuupXjEh3"
Content-Disposition: inline
In-Reply-To: <52572E33.2090609@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--aiCxlS1GuupXjEh3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Stephen,

On Thu, Oct 10, 2013 at 03:46:11PM -0700, Stephen Boyd wrote:
> On 10/10/13 12:13, Maxime Ripard wrote:
> > On Wed, Sep 25, 2013 at 04:16:14PM -0700, Stephen Boyd wrote:
> >> On 09/25/13 07:03, Maxime Ripard wrote:
> >>> +	sun5i_clockevent.cpumask =3D cpumask_of(0);
> >> Can this timer interrupt any CPU or is it hardwired to CPU0? If the
> >> interrupt can go to any CPU this should be cpu_possible_mask instead.
> > I've changed the few other things you spotted, but this one making the
> > timer unusable.
> >
> > I think what happens here is that we have the A31 I've tested these
> > patches on is a quad-core SoC. As such, the device tree has 4 CPUs
> > declared. However, we don't have any SMP support for it now. So we end
> > up having 4 cpus set as possible, and only one online (the boot cpu),
> > which isn't working.
>=20
> Can you explain more why it isn't working? Is the timer being rejected
> in favor of another timer?

Hmm, right, I forgot it, sorry about that.

The timers actually seem to not be working at all. I get stuck at the
delay loop calibration.

I'm away from my hardware right now, so I couldn't debug it further, but
reverting to using cpumask_of(0) makes the kernel boot flawlessly.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--aiCxlS1GuupXjEh3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSWESEAAoJEBx+YmzsjxAglcMP/3ftuHaV9NRcSuqas/5hSUkA
ow6U2n5tZlsS9M9MiRS65jksVyLJfcRbpU2pwDYUX9PkXrHuYy9qS3FUIRvIDMeH
LtFIAmo28LVrMt9aHGAi7okxANZE8SJ+AAJutRAkEjPj+/aMPQ+kzi6pwg400txL
spXGtsUA0hA3mB8linRBiKQwIgVi3fZAdSmk9ePgF5YjtvZJiTn/E9fyy81kZXmg
pchApbg9Xx80KuGrXonWgFJtdrvA1O4LzK3z6DLp4lhYJD/wDj+RWp7STuYyE2qY
2YwwnIUyp6l0pNjlazFwYhinzTmtsDCKChOyqWZ+j4y3QUVn4i0Ro4meJOGB95mM
aBCLXxw1f3srcOOPwpaPPsEDjn89tOe/avZ02x8MCVq10t0fpyB2c1Ze2/2ebjpg
Yy2oql7+HRI3Bf4hmjTJRkLcjBlm/pQ3TNQt5IewnJ/8b1WFBuzxINjGGFgIfPpK
M3MyyckZ5LC3bD8bhlQBptqOKti9Zxh7kSQPiuu++jkCU9aZ5z313QgTAmAL0C2X
TZdmWo9vDvAB42bus97Dm78aaiJo35KOlVWg7YNtNjXkRk8L06MAjfa6iv7i4LqG
d5DmnNe7sHNj5TRl5upr/50RVrD5cxMgsvgmspmKb5bG/MBFls/E6bPpDXHkQdA8
EstV641ppzHmcbBBq10u
=Zc6P
-----END PGP SIGNATURE-----

--aiCxlS1GuupXjEh3--
