Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545AbaKQSXC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 13:23:02 -0500
Received: from sauhun.de ([89.238.76.85]:37607 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751180AbaKQSXA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 13:23:00 -0500
Date: Mon, 17 Nov 2014 19:24:13 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Yuan Yao <yao.yuan@freescale.com>
Cc: marex@denx.de, LW@KARO-electronics.de, mark.rutland@arm.com,
        fugang.duan@freescale.com, shawn.guo@linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH v10 3/3] i2c: imx: add DMA support for freescale i2c
 driver
Message-ID: <20141117182413.GC12644@katana>
References: <1416220836-7666-1-git-send-email-yao.yuan@freescale.com>
 <1416220836-7666-4-git-send-email-yao.yuan@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rQ2U398070+RC21q"
Content-Disposition: inline
In-Reply-To: <1416220836-7666-4-git-send-email-yao.yuan@freescale.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rQ2U398070+RC21q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 17, 2014 at 06:40:36PM +0800, Yuan Yao wrote:
> Add dma support for i2c. This function depend on DMA driver.
> You can turn on it by write both the dmas and dma-name properties in dts =
node.
> DMA is optional, even DMA request unsuccessfully, i2c can also work well.
>=20
> Signed-off-by: Yuan Yao <yao.yuan@freescale.com>

gcc found a bug:

drivers/i2c/busses/i2c-imx.c:703:7: warning: 'orig_jiffies' may be used uni=
nitialized in this function [-Wuninitialized]
drivers/i2c/busses/i2c-imx.c:672:16: note: 'orig_jiffies' was declared here

> +	result =3D wait_for_completion_interruptible_timeout(
> +				&i2c_imx->dma->cmd_complete,
> +				msecs_to_jiffies(DMA_TIMEOUT));

And are you sure you want to use
wait_for_completion_interruptible_timeout() instead of
wait_for_completion_timeout() here? Unless you confirm you tested it a
lot with signals, I really cannot recommend the *_interruptible_*
version.

Other than that, good. I liked the logfile of what you tested very much!

Thanks,

   Wolfram


--rQ2U398070+RC21q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUaj1MAAoJEBQN5MwUoCm2iAQP+gLvU7RvnQ8HxMQwrz7EKPab
gLmHNnokSivV0hk/pKscDE+OIW7ep8JkVqGBn9EnyTbx3IMXpZlr+b+sYMmp7gi9
fw57Oat4JTP5sQWk46f6K26ptUQDQMAXhSFg33JByQ1P10UJkKpDpjtohB6jh4iS
e7Q6q0pI0p3AyWcoCNqSfzGa3cXKT1cpQhAk+Az/HrmhA/1A004XuPJP/L6cYnik
cdMKYKOLTShl/QYqMHn6BzsZejAqFU3k2BHE8s8wpnjCQ5gA+VKwJMAdLufrdsEM
//yQsnzuZIX+uKXJW3xTbLCG4A4Y+I9EUKfTwLSrT22rTnPe1WY0fYS3yLMRU4hw
Qs9BxKux7Pa49Kml7s/XAqxID3r+G9yWuea0V8wK5Um6jfNyD1jUQP8bzFU2+szW
LAA5XiscFrxn+jztD9Nc9PIf+okCHwClM+wG6YYOjX+BUfzwNGtvWMn8j9lcStkT
RWh3HVbs5+APXw/hRzGIHLWDG1g4yDCnLQn7TaxFqa2dEY0uJ2QMU2QLsGEmGMKm
NiaWcQXs5WNYl8FGX6WUEQ1CwQBMUf/mDhw2l+pknpCV2kzRiF0yuT4bqCbMJQ6W
7mhUiJgdH8Ko6T0OMfeGTwV+8A243bYC41G7s2BauJXOstYP0tHzAFDXMcXVt5IP
eKgD7RMzCIyTvTuswvzu
=q3Tk
-----END PGP SIGNATURE-----

--rQ2U398070+RC21q--
