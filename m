Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932471AbaHYNtf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 09:49:35 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:35294 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932274AbaHYNtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 09:49:33 -0400
Date: Mon, 25 Aug 2014 15:49:29 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Shawn Guo <shawn.guo@freescale.com>
Cc: Liu Ying <Ying.Liu@freescale.com>, linux-pwm@vger.kernel.org,
        s.hauer@pengutronix.de, LW@KARO-electronics.de,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 3/3] pwm: i.MX: Avoid sample FIFO overflow for i.MX
 PWM version2
Message-ID: <20140825134927.GK4163@ulmo.nvidia.com>
References: <1401274213-8954-1-git-send-email-Ying.Liu@freescale.com>
 <1401274213-8954-3-git-send-email-Ying.Liu@freescale.com>
 <20140825115628.GA7008@dragon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NqNl6FRZtoRUn5bW"
Content-Disposition: inline
In-Reply-To: <20140825115628.GA7008@dragon>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NqNl6FRZtoRUn5bW
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 25, 2014 at 07:59:01PM +0800, Shawn Guo wrote:
> On Wed, May 28, 2014 at 06:50:13PM +0800, Liu Ying wrote:
> > The i.MX PWM version2 is embedded in several i.MX SoCs,
> > such as i.MX27, i.MX51 and i.MX6SL.  There is a 4-word(16bit)
> > sample FIFO in this IP.  Each FIFO slot determines the duty
> > period of a PWM waveform in one full cycle.  The IP spec
> > mentions that we should not write a fourth sample because
> > the FIFO will become full and triggers a FIFO write error
> > (FWE) which will prevent the PWM from starting once it is
> > enabled.  In order to avoid any sample FIFO overflow issue,
> > this patch clears all sample FIFO by doing software reset
> > in the configuration hook when the controller is disabled
> > or waits for a full PWM cycle to get a relinquished FIFO
> > slot when the controller is enabled and the FIFO is fully
> > loaded.
> >=20
> > The FIFO overflow issue can be reproduced by the following
> > commands on the i.MX6SL EVK platform, assuming we use PWM2
> > for the debug LED which is driven by the pin HSIC_STROBE
> > and the maximal brightness is 255.
> > echo 0   > /sys/class/leds/user/brightness
> > echo 0   > /sys/class/leds/user/brightness
> > echo 0   > /sys/class/leds/user/brightness
> > echo 0   > /sys/class/leds/user/brightness
> > echo 255 > /sys/class/leds/user/brightness
> > Here, FWE happens(PWMSR register reads 0x58) and the LED
> > can not be lighten.
> >=20
> > Another way to reproduce the FIFO overflow issue is to run
> > this script:
> > while true;
> > 	do echo 255 > /sys/class/leds/user/brightness;
> > done
> >=20
> > Cc: Thierry Reding <thierry.reding@gmail.com>
> > Cc: Sascha Hauer <s.hauer@pengutronix.de>
> > Cc: Shawn Guo <shawn.guo@freescale.com>
> > Cc: Lothar Wa=C3=9Fmann <LW@KARO-electronics.de>
> > Cc: linux-pwm@vger.kernel.org
> > Cc: linux-arm-kernel@lists.infradead.org
> > Signed-off-by: Liu Ying <Ying.Liu@freescale.com>
>=20
> The whole series,
>=20
> Acked-by: Shawn Guo <shawn.guo@freescale.com>
>=20
> Thierry,
>=20
> Can you pick them up if they look good to you?

All three patches applied with your Acked-by (and some minor
reformatting of the commit message).

Thanks,
Thierry

--NqNl6FRZtoRUn5bW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT+z7nAAoJEN0jrNd/PrOh/fIQALbB9Swl33dg9AASGeV39IpS
yql8xpluscr7YQMhQwQgfhfNa+CAhYDnT5/sCj3Wgm3sTR2zthc1u1uTZ4VDD0Sm
9DG9fQJO5Z+/A7k2wY2SdvgAECdx4cIyyacQFMd5Y/H0OwVhsrUMBGVBL4k2A91D
BjQdKofv/Ae08vfi8Xm508l8WEbKNh0AGAbEGWCflZULbgsAOJsYLBff1wFF+I0Q
lFuCnDbwwBBxzysbUqEJP6pL60ozckaH1hRPX74XRwSMKhdbvKTA/+wfbuROlE24
6AcOpkkeJkTBJIqCbeHg8DmNP2hlK+t3L3d3A9O2VTcdmN+9+09cRbOMPBSaoPvi
ruVuXgtysciXo9Uk0+yWzfA4tCjUPDElAjbWHJLZHvyIUTIEUmKqpodNIxvyExqs
2V28QXvfShvPHBgvsPuw7L6h8KvXa0zTwwb6Z/Olp9+Ww+IErPmsI67gTXtb0MNm
qQUn854EP8AeFk+LU3pscP28v66r44s6Yzw3KqO1P6t+0RyzMY0ceahERPopdHL8
zEfJfwlyeuO5TNWi036GEDnWz0juqjqx4l+Ff15/QTvJaDkFV1CFpg5WCgKUcXST
OuqhOhYoonajS2zVcCvDPmL/dooFYchmUaKJ/o25ym+Wg0yHR2ficEMMvSQGUvwg
SgVw+GJbzqrQQCebp+Kv
=cNKn
-----END PGP SIGNATURE-----

--NqNl6FRZtoRUn5bW--
