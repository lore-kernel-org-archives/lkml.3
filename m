Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224Ab3F1KTQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 06:19:16 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:59154 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754688Ab3F1KTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 06:19:15 -0400
Date: Fri, 28 Jun 2013 12:19:11 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Siarhei Siamashka <siarhei.siamashka@gmail.com>
Cc: linux-sunxi@googlegroups.com, John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Emilio Lopez <emilio@elopez.com.ar>, kevin@allwinnertech.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com
Subject: Re: [linux-sunxi] [PATCH 2/8] clocksource: sun4i: Add clocksource
 and sched clock drivers
Message-ID: <20130628101911.GF4319@lukather>
References: <1372281421-2099-1-git-send-email-maxime.ripard@free-electrons.com>
 <1372281421-2099-3-git-send-email-maxime.ripard@free-electrons.com>
 <20130627131729.5fff8468@i7>
 <20130627170228.GC4319@lukather>
 <20130627225101.358208c1@i7>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="E7i4zwmWs5DOuDSH"
Content-Disposition: inline
In-Reply-To: <20130627225101.358208c1@i7>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--E7i4zwmWs5DOuDSH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Siarhei,

> > > If we can be absolutely sure that nothing else may ever change
> > > the TIMER_CNT64_CTL_REG, then its default value can be probably
> > > cached instead of doing expensive read from the hardware register
> > > each time?
> >=20
> > Since it's a free-running counter, its value will always change, so the
> > caching will bring no additions at all, right?
>=20
> Sorry, 'caching' was not a very good description for something that is
> already a compile time constant. I mean just replace
>=20
>     u32 reg =3D readl(timer_base + TIMER_CNT64_CTL_REG);
>=20
> with=20
>=20
>     u32 reg =3D TIMER_CNT64_CTL_CLR;
>=20
> Because we know that the TIMER_CNT64_CTL_REG is already supposed
> to have the default TIMER_CNT64_CTL_CLR value (initialized in the
> 'sun4i_timer_init' function) between calls to 'sun4i_timer_sched_read'.
> Inside of 'sun4i_timer_sched_read' we set an extra TIMER_CNT64_CTL_RL
> bit in this register, but wait until it clears, effectively reverting
> TIMER_CNT64_CTL_REG register back to the default TIMER_CNT64_CTL_CLR
> value.
>=20
> Removing this extra HW register read can save roughly a hundred of CPU
> cycles here and provide a ~10% overall improvement for gettimeofday
> (these estimates are based on the earlier benchmarks done with the
> Allwinner 3.4 kernel).
>=20
> Or maybe I'm overlooking something?

Ah, I get what you mean now. We don't even need to bother about
TIMER_CNT64_CTL_CLR now, since it's suppose to be cleared once the
counter is reset.

However, I'd very much prefer to take the safer approach for now, and
try to optimise afterwards.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--E7i4zwmWs5DOuDSH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRzWMfAAoJEBx+YmzsjxAgSD8P/1DG7nLLDXxRNx6qHrXVMvPa
kisoys3OGD+2jYrDDVmsyRbdV5i6szYDfxIIf3Sfh2JNsOT4OAhqSHc9VF23tA35
U8O8NvXB7smgUYE2t2ODZe/NTZnBG1poawf43BBpV4SLsoSx7wplTRf/mwLoUsJi
561MJJwXWmmDgmuwS3Z7/2fouu2uyuWeSqGAWibAusC6WD8pLO16Yq4wFdW7kbHJ
oUwuwXw6plLPWmi+ovLbtZUB6XLVgaxC3SxlU3/gCuD8sy/x644wTgutZ/LVSnJ1
+C24Wanaao56tVmTIbxyFH2K5w8UT7+ZV0QtEbErmNeiHC0X7l8pBiGXRRAMDqF6
XtNmTR5cbQY5Counzf7fFYwM3xlzhA03zV/OhOKJsJNQhyubwhpPvltGlKawZ3zf
UnJsbQBNJbzCnLDkDbq7YYI++aYcfPo1xNPScCBWabQS2moSjcrJYFdWStHeVLXk
UEqJ9f4epv789ZqqqZHQzzq7ltps0D07iRrqtEKJY025dU6xsGgjzpSmVL5ShEu3
MXBQpZDN+UNfH9YPy5R4/68tw66IMUj4rTF8M6Ke58rtYLQHyXfl4ZAQFDLEDeTc
REyueZoFgt7mXs/Aq0OYA4YfVTpUHU/3q6XJylGfk8gmUzfxZsYOHKyCWkombXp+
r8hYSKyt1bBI3WRwNLQh
=KUpa
-----END PGP SIGNATURE-----

--E7i4zwmWs5DOuDSH--
