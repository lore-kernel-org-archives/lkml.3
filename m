Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944AbaD1XKJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 19:10:09 -0400
Received: from top.free-electrons.com ([176.31.233.9]:53981 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751379AbaD1XKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 19:10:07 -0400
Date: Mon, 28 Apr 2014 16:07:02 -0700
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Arnd Bergmann <arnd@arndb.de>, wim@iguana.be, dbaryshkov@gmail.com,
        dwmw2@infradead.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: Re: [PATCH 1/5] wdt: sunxi: Move restart code to the watchdog driver
Message-ID: <20140428230702.GN3134@lukather>
References: <1398265476-29373-1-git-send-email-maxime.ripard@free-electrons.com>
 <1398265476-29373-2-git-send-email-maxime.ripard@free-electrons.com>
 <535BD13B.103@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JVu9XMG6uEpKCPDY"
Content-Disposition: inline
In-Reply-To: <535BD13B.103@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JVu9XMG6uEpKCPDY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Sat, Apr 26, 2014 at 08:31:07AM -0700, Guenter Roeck wrote:
> On 04/23/2014 08:04 AM, Maxime Ripard wrote:
> >Most of the watchdog code is duplicated between the machine restart code=
 and
> >the watchdog driver. Add the restart hook to the watchdog driver, to be =
able to
> >remove it from the machine code eventually.
> >
> >Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> >---
> >  drivers/watchdog/sunxi_wdt.c | 33 +++++++++++++++++++++++++++++++++
> >  1 file changed, 33 insertions(+)
> >
> >diff --git a/drivers/watchdog/sunxi_wdt.c b/drivers/watchdog/sunxi_wdt.c
> >index cd00a7836cdc..0644c45d2b60 100644
> >--- a/drivers/watchdog/sunxi_wdt.c
> >+++ b/drivers/watchdog/sunxi_wdt.c
> >@@ -14,6 +14,7 @@
> >   */
> >
> >  #include <linux/clk.h>
> >+#include <linux/delay.h>
> >  #include <linux/err.h>
> >  #include <linux/init.h>
> >  #include <linux/io.h>
> >@@ -22,9 +23,12 @@
> >  #include <linux/moduleparam.h>
> >  #include <linux/of.h>
> >  #include <linux/platform_device.h>
> >+#include <linux/reboot.h>
> >  #include <linux/types.h>
> >  #include <linux/watchdog.h>
> >
> >+#include <asm/system_misc.h>
> >+
> >  #define WDT_MAX_TIMEOUT         16
> >  #define WDT_MIN_TIMEOUT         1
> >  #define WDT_MODE_TIMEOUT(n)     ((n) << 3)
> >@@ -70,6 +74,30 @@ static const int wdt_timeout_map[] =3D {
> >  	[16] =3D 0b1011, /* 16s */
> >  };
> >
> >+static struct sunxi_wdt_dev *sunxi_restart_ctx;
> >+
> >+static void sun4i_wdt_restart(enum reboot_mode mode, const char *cmd)
> >+{
> >+	if (!sunxi_restart_ctx)
> >+		return;
> >+
> The only condition where this can happen if is there is a race between th=
e calling
> code and the remove function below. If that race really exists, it could =
as well
> happen after this check, so the check does not really provide any value a=
nd can
> be removed.
>=20
> Note that I find the variable name a bit misleading. It isn't a context,
> it is the poitner to sunxi_wdt_dev. What is really needed is wdt_base,
> not this pointer. Would it make more sense to provide that pointer
> directly instead, like you did in the code for the A31 ?

Hmm, right, I'll change this.

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--JVu9XMG6uEpKCPDY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTXt8WAAoJEBx+YmzsjxAgt/oQAIQbtUdUDvRdW4FxijMDb0Xm
AeE8NZ6xr09X1IeRa2rU8Wp7dtax6ISod+NWhx6RrXiyrLwJyh1bV0QdeECBF/15
mQruwZIEw77QtTzJON4AoJk/GTa8K6xZJv6FeCXwaKkY6KhiLZUHh/sUiYz5Tdst
DaG/d/WkNfNnFraVpfE8rlEp8pAQWOIwZdLWXhRAiJq/WoizQZBz90ZLRkihpHis
kG9kj6n1EezqMeGioFjvf+nVXRLGT26c/ZKtK19Uu0a5n0ozek7ugEvjF/qiS6fJ
HTs8m0J0hEeNf7kA21peNtQBmkdB0S+2OfQ3bJK3sUkp3vQEC633kd8yn1rE89ep
3y1+CzxrWxlDjIpBBOrTdIg/ksS8VG8Wd0XhXxMgjZ2+mpW0M7uypKdPKD+Q6xW2
+1gkmyMX2NSaitb251nx8KcV0sUKDSGiLi6Q+yaLiLwLrgxoQSmyNGSQr9bmvD5u
vWTNw7Uk61moumS3v1wvm+zbzhbOO1si1dsNo9ryrYT4IGtPkh9k6a2WSUNbWxmq
wJIXz89E8rOmGDcw9Cap0csZmzMeZ6Z5KIwmGBSmUKITWts1c4dgFevawRLy7zjx
r+KQMEHh1F4PDBas5gopp6UvS+oawYv1wH/qIcz3pgaWQA0jR80fc5iHkyg3l5jb
uBAbREpnTW1kljxrbVd5
=uRYE
-----END PGP SIGNATURE-----

--JVu9XMG6uEpKCPDY--
