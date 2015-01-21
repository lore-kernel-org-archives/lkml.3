Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752260AbbAUJUO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 04:20:14 -0500
Received: from down.free-electrons.com ([37.187.137.238]:34856 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751177AbbAUJUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 04:20:04 -0500
Date: Wed, 21 Jan 2015 10:17:36 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/5] clocksource: sun5i: Switch to request_irq
Message-ID: <20150121091736.GE4367@lukather>
References: <1420976410-7826-1-git-send-email-maxime.ripard@free-electrons.com>
 <1420976410-7826-2-git-send-email-maxime.ripard@free-electrons.com>
 <54BBFE38.5000204@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BtLpl2nkGUzqmEOn"
Content-Disposition: inline
In-Reply-To: <54BBFE38.5000204@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BtLpl2nkGUzqmEOn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 18, 2015 at 07:40:56PM +0100, Daniel Lezcano wrote:
> On 01/11/2015 12:40 PM, Maxime Ripard wrote:
> >The current code uses setup_irq, while it could perfectly use the much s=
impler
> >request_irq. Switch to that.
> >
> >Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> >---
> >  drivers/clocksource/timer-sun5i.c | 10 ++--------
> >  1 file changed, 2 insertions(+), 8 deletions(-)
> >
> >diff --git a/drivers/clocksource/timer-sun5i.c b/drivers/clocksource/tim=
er-sun5i.c
> >index 02268448dc85..738853873a3b 100644
> >--- a/drivers/clocksource/timer-sun5i.c
> >+++ b/drivers/clocksource/timer-sun5i.c
> >@@ -130,13 +130,6 @@ static irqreturn_t sun5i_timer_interrupt(int irq, v=
oid *dev_id)
> >  	return IRQ_HANDLED;
> >  }
> >
> >-static struct irqaction sun5i_timer_irq =3D {
> >-	.name =3D "sun5i_timer0",
> >-	.flags =3D IRQF_TIMER | IRQF_IRQPOLL,
> >-	.handler =3D sun5i_timer_interrupt,
> >-	.dev_id =3D &sun5i_clockevent,
> >-};
> >-
> >  static u64 sun5i_timer_sched_read(void)
> >  {
> >  	return ~readl(timer_base + TIMER_CNTVAL_LO_REG(1));
> >@@ -178,7 +171,8 @@ static void __init sun5i_timer_init(struct device_no=
de *node)
> >
> >  	ticks_per_jiffy =3D DIV_ROUND_UP(rate, HZ);
> >
> >-	ret =3D setup_irq(irq, &sun5i_timer_irq);
> >+	ret =3D request_irq(irq, sun5i_timer_interrupt, IRQF_TIMER | IRQF_IRQP=
OLL,
> >+			  "sun5i_timer", &sun5i_clockevent);
>=20
> Is the timer name change done in purpose ?

Hmm, no, it's a mistake. I'll resend a v2.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--BtLpl2nkGUzqmEOn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUv26wAAoJEBx+YmzsjxAguMQQAICXF1yQAYPTj0wyZKv7giAi
SZ1bXBUHeTfMFFZCsozEYMOen2WhQCcGteVvFwDuUsJOB/LyB5ftuu/K309N3/1E
FVAVfjR7+icG8PbOUt4X5TZkhbg39YBnyQa7xvMo3CF4qeBPgo8XOn+Qg8HXuPJs
Bh1lgrEo8gWlSd4OTuDB/l3/iWOo1a+ND/H6BI4v20WBx4W43B6k9gXXINwWDcIX
VivnKn26blaIvOF9grAjE6y832iZfTuc7pxRSllD/IB2w9Zqo0KBfq22tD+K9WM6
rsK8mPJwKXae8NkZBtI7zqdX6nqQhuw9q74s08THmpwTFU1epVIAdAyK1EDSDAyQ
AeEOaKvSSMzIgaULpFdLhIITOUsVVK5Zwrmu2xfGEBd6CwaB1G0PWoTDijQGgsyU
7x501gmrux+gtbaln4OdP60ft0pPyj1Etx9XbsQVo3vxlGqwedSShYyVQ79Ubvvg
2PX6fUpH4c3Sz5aWbe1eMTPu0/Glxkn9VazhXJVhZdMS3pk0toe+E4GekgHOREXe
kXBhpk7xTKwzn2C4JOVnngAoVHubnO/Oa+YpbQS6Doit5oTTb4e/3AGHg2HQH7iY
z0Z+zEPjp0FCSWzSE2twzqajiRo9l5wzMx+RcHbWmRIM7R/NVPRT2WjAsYLf9V7f
kjCmNKqnbeW9d7dTvVje
=Idul
-----END PGP SIGNATURE-----

--BtLpl2nkGUzqmEOn--
