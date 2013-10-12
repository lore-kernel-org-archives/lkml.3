Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752942Ab3JLMcr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Oct 2013 08:32:47 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:34552 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493Ab3JLMcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Oct 2013 08:32:45 -0400
Date: Sat, 12 Oct 2013 13:32:17 +0100
From: Mark Brown <broonie@kernel.org>
To: yi zhang <yizhang.mrvl@gmail.com>
Cc: Yi Zhang <yizhang@marvell.com>, zhouqiao@marvell.com, zhangwm@marvell.com,
        linux-kernel@vger.kernel.org
Message-ID: <20131012123217.GK2443@sirena.org.uk>
References: <CAK=oMXetPxaQ-MeL9L9+182X220ivu2G5+i-42kqtAUjbfvg2w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dxRQSzdsN/lOP445"
Content-Disposition: inline
In-Reply-To: <CAK=oMXetPxaQ-MeL9L9+182X220ivu2G5+i-42kqtAUjbfvg2w@mail.gmail.com>
X-Cookie: Time and tide wait for no man.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [Question]should we not ignore the masked interrupt in regmap?
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dxRQSzdsN/lOP445
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Oct 12, 2013 at 11:14:27AM +0800, yi zhang wrote:

> 1) interrupt is triggered;
> 2) a thread disables it(then the mask bit is set);
> 3) _Then_ the interrupt thread is executed, it _ignore _ and doesn=E2=80=
=99t
> handle this interrupt;
>    because the interrupt is not ACKed, the interrupt status is not cleare=
d;
> 4) in Marvell's PMIC, the interrupt line to SOC is always asserted,
> then irq storm happens;

This sounds like you need the workaround activated by init_ack_masked.
It's basically the hardware failing to implement masking sensibly - the
general expectation for a mask bit is that it will have no effect on the
actual state of the interrupt, only on if it's reported.

--dxRQSzdsN/lOP445
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSWUFNAAoJELSic+t+oim9vWwP/32zIWSSU46XF/pS+2UuSYAr
fCRCwQ3FG6c4yV/BQ9fwYYmGj8fnFMI5qdGwE3Hi/aA0A4mu3zfLKENAopZ0YFp3
BfDwctB3a7r3EAodq/ztEZeH49F9mQkN8qOrSfvpCte4edtFQJDOtX1hIeilEMZr
RJjQXMz8v6Wub3lqee+WAYJLkkjHbAgc4uM2J2I5SYglOlAo39idimDHkhBIBF/j
8WZL2d2Nlf7OoPT7WKvs+qPMuGG8vthoXu9Koc0GS30UwwiL9FZ/EGv4AjSIoBEX
mPSW7Bg5gYN/jhXinjlpTFKUJ7ppZgBEAmhcz/jpgCJNUARtSbLoUfDinLFpvxxp
7AJNnPNQQ1MfPrl4Vg3ilN6feofuIEjTi9gvHEiCaGfZH10jXWlTgv8XNk4+UOuN
rdwpkLpnGlzyI9SeimjVkIp1QJThcWKlTYQjotsgG0poFsq3kEU0+aUnxqugzeyP
AtJuxtZ+LSnLTzijGLL4LjcqhF2E9iblxrl+JPM2SxcuhF/3EmQg55xCGE2Yhcxl
cHN7hcXWYK52DfrkUxJkVRwEwnhIVEPflHEKy+yOA+0+vvNUyszNDgp81nqdGhJ1
GJA1iYnuQVZ66ZeQzIPt3ZDo4IYIiofjo2u8+HIv/JbxqvbJiIde5FuzUZ1IlMWY
7qovbhzKZqPlHrbodvkI
=LyHy
-----END PGP SIGNATURE-----

--dxRQSzdsN/lOP445--
