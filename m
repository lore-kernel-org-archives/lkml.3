Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130AbaDVDHb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 23:07:31 -0400
Received: from [101.0.96.218] ([101.0.96.218]:47468 "EHLO pide.tip.net.au"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751446AbaDVDH1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 23:07:27 -0400
Date: Tue, 22 Apr 2014 13:06:55 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Chris Ball <chris@printf.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: linux-next: build failure after merge of the mmc tree
Message-Id: <20140422130655.51daec1807bde98ade65d691@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.23; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__22_Apr_2014_13_06_55_+1000_c7MfBUJEg/P9Ghlg"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__22_Apr_2014_13_06_55_+1000_c7MfBUJEg/P9Ghlg
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Chris,

After merging the mmc tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

drivers/net/wireless/rsi/rsi_91x_sdio.c: In function 'rsi_reset_card':
drivers/net/wireless/rsi/rsi_91x_sdio.c:288:20: error: 'MMC_STATE_HIGHSPEED=
' undeclared (first use in this function)
    card->state &=3D ~MMC_STATE_HIGHSPEED;
                    ^
drivers/net/wireless/rsi/rsi_91x_sdio.c:288:20: note: each undeclared ident=
ifier is reported only once for each function it appears in
drivers/net/wireless/rsi/rsi_91x_sdio.c:299:4: error: implicit declaration =
of function 'mmc_card_set_highspeed' [-Werror=3Dimplicit-function-declarati=
on]
    mmc_card_set_highspeed(card);
    ^
drivers/net/wireless/rsi/rsi_91x_sdio.c:306:2: error: implicit declaration =
of function 'mmc_card_highspeed' [-Werror=3Dimplicit-function-declaration]
  if (mmc_card_highspeed(card))
  ^

Caused by commit 395784826a81 ("mmc: drop the speed mode of card's state").

I have used the version of the mmc tree from next-20140417 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__22_Apr_2014_13_06_55_+1000_c7MfBUJEg/P9Ghlg
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTVdzTAAoJEMDTa8Ir7ZwVp6YQAJGhvcDnd1oJFkgmc4Iy/Yiv
INTn3KmWi9UgMIIxy86ElQkRf/xiTQXRayCQQhZquuy2YnM58If0mTIXkEcq00Pj
QRBd81Z65GZW2r3FYzk4ZhutLaHjjucTAIFUeLL4NjoDU8d0cpyihYebf7TXrCh+
6POE3xZo8t3RO5Ug5g17HYsZSqNjVggbwy4eKjgNNw5Mvx8UGXXqZbGV/q7jBDRF
Zd8htB0gQY2/0HsIBiKgZojdeSWcDK2YK4IwJKznpO+137mF9ftiF8q+3aKQfE5R
VQ4W6nSawb/yO+6adCwoKfAk+kKbyuLpoy4HQMBiIrNVtOpHTjp2E+7y3mgvRtr2
XRjTrGzByc2YPHliQBx6G827cXVwTr8Ivc/d2nt2CDy/lOMtkv+d7xt1gKEPW7Te
W+6MgMOqT4ItBSX9/gmVAU2cDm/UY0MaS2NAr543oDo9xOvIFK4ScKg3OYKG3S1r
C8eJ7XG2Vlsd0kzjTJVEa4rfNLrrJymUFbCEVJSXVfvv84pCx/KnGXBaw9heV9nQ
XeYED7J0mHMFAdUcjSbx+BOgJ1ByYU54p6gNldmXcWRSGxtJB3+vg6nKjrOqksut
dPPPnOPg9Ju8J7kulLvSO0UHk/WyKOjPzbqRncAL0c0mEDNS7rMd7KFmIkVITzJB
aiMQvyo235nk6rdWxA4W
=Xyt5
-----END PGP SIGNATURE-----

--Signature=_Tue__22_Apr_2014_13_06_55_+1000_c7MfBUJEg/P9Ghlg--
