Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932134AbbAYUGj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 15:06:39 -0500
Received: from mail.kernel.org ([198.145.29.136]:32834 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755518AbbAYUGe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 15:06:34 -0500
Date: Sun, 25 Jan 2015 21:06:26 +0100
From: Sebastian Reichel <sre@kernel.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-pm@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] power/reset: arm-versatile: Register with kernel
 restart handler
Message-ID: <20150125200626.GA6536@earth.universe>
References: <1422209622-31994-1-git-send-email-linux@roeck-us.net>
 <20150125184017.GA29704@earth.universe>
 <54C53EE4.4070109@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="AqsLC8rIMeq19msA"
Content-Disposition: inline
In-Reply-To: <54C53EE4.4070109@roeck-us.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AqsLC8rIMeq19msA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Guenter,

On Sun, Jan 25, 2015 at 11:07:16AM -0800, Guenter Roeck wrote:
> On 01/25/2015 10:40 AM, Sebastian Reichel wrote:
> >On Sun, Jan 25, 2015 at 10:13:37AM -0800, Guenter Roeck wrote:
> >>Register with kernel restart handler instead of setting arm_pm_restart
> >>directly. Select high priority since the restart handler is instantiated
> >>through devicetree, indicating that it should be used if configured.
> >
> >This does not apply clean for me. Please rebase on top of
> >
> >http://git.infradead.org/battery-2.6.git/
>=20
> Sure, will do. I assume you mean battery/next-next since it applies clean=
ly
> to battery/master.

uhm no, I was talking about battery/master.
It does not apply cleanly for me:

Applying: power/reset: arm-versatile: Register with kernel restart handler
error: patch failed: drivers/power/reset/arm-versatile-reboot.c:13
error: drivers/power/reset/arm-versatile-reboot.c: patch does not apply

The error looks correct:

$ grep -A8 "+++ b/drivers/power/reset/arm-versatile-reboot.c" guenter_roeck=
=2Epatch
+++ b/drivers/power/reset/arm-versatile-reboot.c
@@ -13,7 +13,6 @@
 #include <linux/reboot.h>
 #include <linux/regmap.h>
 #include <linux/of.h>
-#include <asm/system_misc.h>
=20
 #define REALVIEW_SYS_LOCK_OFFSET   0x20
 #define REALVIEW_SYS_LOCK_VAL      0xA05F
$ git blame -L13,20 drivers/power/reset/arm-versatile-reboot.c
0e545f57 (Linus Walleij 2014-05-22 10:20:38 +0200 13) #include <linux/reboo=
t.h>
0e545f57 (Linus Walleij 2014-05-22 10:20:38 +0200 14) #include <linux/regma=
p.h>
0e545f57 (Linus Walleij 2014-05-22 10:20:38 +0200 15) #include <linux/of.h>
0e545f57 (Linus Walleij 2014-05-22 10:20:38 +0200 16) #include <asm/system_=
misc.h>
0e545f57 (Linus Walleij 2014-05-22 10:20:38 +0200 17)=20
0160817d (Linus Walleij 2014-12-19 16:56:27 +0100 18) #define INTEGRATOR_HD=
R_CTRL_OFFSET        0x0C
0160817d (Linus Walleij 2014-12-19 16:56:27 +0100 19) #define INTEGRATOR_HD=
R_LOCK_OFFSET        0x14
0160817d (Linus Walleij 2014-12-19 16:56:27 +0100 20) #define INTEGRATOR_CM=
_CTRL_RESET  (1 << 3)
$ git show -s --format=3D%ci 0160817d
2015-01-20 13:58:27 +0100

Maybe update the battery/master branch?

-- Sebastian

--AqsLC8rIMeq19msA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJUxUy2AAoJENju1/PIO/qaL40QAJaFRyCwir/FzUIOjv0bgrwc
4dPE9dJeAr0A6LRWrUwGQ9RZzxSOfJVkO4VbSTKcoUH16XqYHZV8+n4IXJTW94JV
xW4fdN3Cx14xdrLS/asgEtDnrTWCHC+pnLdPGtneJ6sBRXpitg4TC+/XkJnTFeYN
w6ajageShiDoOb+mMfKomut/IFbthhI2g2gvIXB4k6Pq20sxZqo2Pvo7/3NrG2Gr
7p3opn4tCo01bikrRX63K0U2c/x253fH5lr5fQW4R/qOdlrNbBXp9Ee/nr2Drmhp
0MaZ/Uzdtx5Ks6RaBwFUkjPPtpdMNd19UhRkFk0UHtVF6rCIN/TpbZbKg7oGZJXV
oOOXTsbX6lpZqi/6w2q7xQZMbmog9DAS3vS5iEBCVXC+9YlYVsbC79dzb/CS9vq1
QH/o9Qe81xSSKwrrSlPj7DsZkuneWphYofG3e9ZRsQs1qkFv4rB8NUab+8WpQJtF
bfR08OWDh+fgj9g5j+2nnoKIqWXQQ3nryJFmzK5lBkGHjtoVZx1HlKkkYwaurFrQ
l69cCPUDeVVSFfOOOdU+z2OGL+vuixd26MkPveV18+pTaOXcAOaCsT1cUF6JPzGy
FonRg2Cs5plsyj9ci6T+oAHuhmFJuimwZFnowhWXT0LQNrEjoqnu3w7e0RsNzFs8
peJTQF4EDupAscMI04wo
=whN1
-----END PGP SIGNATURE-----

--AqsLC8rIMeq19msA--
