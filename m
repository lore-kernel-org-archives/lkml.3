Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932178Ab3IZNNh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 09:13:37 -0400
Received: from top.free-electrons.com ([176.31.233.9]:43937 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932125Ab3IZNNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 09:13:31 -0400
Date: Thu, 26 Sep 2013 16:13:29 +0300
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Emilio =?iso-8859-1?Q?L=F3pez?= <emilio@elopez.com.ar>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] clocksource: Add Allwinner SoCs HS timers driver
Message-ID: <20130926131329.GQ2954@lukather>
References: <1380117790-19390-1-git-send-email-maxime.ripard@free-electrons.com>
 <1380117790-19390-3-git-send-email-maxime.ripard@free-electrons.com>
 <52437062.5040705@elopez.com.ar>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hOh8F6DNH/RZBSFD"
Content-Disposition: inline
In-Reply-To: <52437062.5040705@elopez.com.ar>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hOh8F6DNH/RZBSFD
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 25, 2013 at 08:23:14PM -0300, Emilio L=F3pez wrote:
> El 25/09/13 11:03, Maxime Ripard escribi=F3:
> >Most of the Allwinner SoCs (at this time, all but the A10) also have a
> >High Speed timers that are not using the 24MHz oscillator as a source
> >but rather the AHB clock running much faster.
> >
> >The IP is slightly different between the A10s/A13 and the one used in
> >the A20/A31, since the latter have 4 timers available, while the former
> >have only 2 of them.
> >
> >Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> >---
>=20
> [...]
>=20
> >+static void __init sun5i_timer_init(struct device_node *node)
> >+{
> >+	unsigned long rate;
> >+	struct clk *clk;
> >+	int ret, irq;
> >+	u32 val;
> >+
> >+	timer_base =3D of_iomap(node, 0);
> >+	if (!timer_base)
> >+		panic("Can't map registers");
> >+
> >+	irq =3D irq_of_parse_and_map(node, 0);
> >+	if (irq <=3D 0)
> >+		panic("Can't parse IRQ");
> >+
> >+	clk =3D of_clk_get(node, 0);
> >+	if (IS_ERR(clk))
> >+		panic("Can't get timer clock");
>=20
> I'm not familiar with clocksources, but does this have to be as
> fatal as it is considering the kernel also supports the slower sun4i
> timer?

Hmmm, I don't know, one might choose to enable only this timer, in that
case that would make sense to panic, since it would be the only timer in
that case.

> Also, would any special considerations be needed when adjusting the
> ahb clock? A future cpufreq driver will most likely need to.

While this will be needed at some point, I don't really see how to
handle that properly. The clock framework doesn't seem to have any
callback when it comes to reconfiguring a clock that a device might
use.

This will also creates trouble for IPs such as the I2C that have to
setup internal dividers, and use clk_get_rate to do so.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--hOh8F6DNH/RZBSFD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSRDL4AAoJEBx+YmzsjxAg1p4QAJMKQV5hwZh3VJkpincND17J
1cuzEhFUJ4ufB59M8N+toKffO4kUXe7BiqSaLpYfbVvWCGvgrnnurm3R+Tb5ImH8
Iup87csuu5pF/N2k2RzofDTui/fCAG75lGlPU1/7d0vVSuroCLSEu8/Z1hGXudMf
kOtEd2ZDoJM8aIi/xxxgyPnsS+l8yBn93chVji7NmwRWkc3wto6yBe523HE1l5XE
Qppw/8mrRCcGiBBo5KQgMssXp6Ub5YHhcGzefHWXN+okHUt1y3bLzraoIRNDbyOS
DF/HD6M4qD2R1RhSnB8PHWgPWxDlnpgZvCur/VCCboYwtOuF0m0CJ5waRYE+szxv
aro7D7h0Pu7zbiHJenbqqnMYOmNGy/iryfI6uVsA5ET7Dx2lD7OzzucwCmlLH00B
m489gXtw54Pbk24XgpitOPbVS2q0HOQfGgTcvrN7Nfh0aIgLMwHTqSabjNHMjepP
2CdvzZvVpLVFAD8PhBappr2ESlmjGt45pfHhGa5Ou2eutwhNc5WyyUvblNQRDRAn
6EPrTSVgQASTsIt33HL+NDSkPNK1nTuBGGjZzyso4Nk/EgEEIoNgDliGjXRCG0R2
dLchbSVnaG7ACXlvqtjLTOLhBw0Vy9HgQY53F4yRdOqQVRhwg8iOYiepHxYFNm/r
mVVt9GLRtDz30kAKovR+
=iji/
-----END PGP SIGNATURE-----

--hOh8F6DNH/RZBSFD--
