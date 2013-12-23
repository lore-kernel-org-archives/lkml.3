Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756960Ab3LWEyY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Dec 2013 23:54:24 -0500
Received: from ozlabs.org ([203.10.76.45]:51806 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756649Ab3LWEyX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Dec 2013 23:54:23 -0500
Date: Mon, 23 Dec 2013 15:54:17 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bruno Randolf <br1@einfach.org>
Subject: linux-next: build failure after merge of the final tree (gpio tree
 related)
Message-Id: <20131223155417.99a66c575143e25d36232a77@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__23_Dec_2013_15_54_17_+1100_.OMQ90Lhb40WQ59d"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__23_Dec_2013_15_54_17_+1100_.OMQ90Lhb40WQ59d
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

drivers/gpio/gpio-sch311x.c: In function 'sch311x_sio_enter':
drivers/gpio/gpio-sch311x.c:115:2: error: implicit declaration of function =
'outb' [-Werror=3Dimplicit-function-declaration]
  outb(SIO_CONFIG_KEY_ENTER, sio_config_port);
  ^
drivers/gpio/gpio-sch311x.c: In function 'sch311x_sio_inb':
drivers/gpio/gpio-sch311x.c:128:2: error: implicit declaration of function =
'inb' [-Werror=3Dimplicit-function-declaration]
  return inb(sio_config_port + 1);
  ^

Caused by commit 12262bef8f46 ("gpio: add GPIO support for SMSC SCH311x")
from the gpio tree.

I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__23_Dec_2013_15_54_17_+1100_.OMQ90Lhb40WQ59d
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSt8H+AAoJEMDTa8Ir7ZwVBb0QAIwUX2ZCqn+fM6VXLVoaaOZS
6Cyd28eZO62c2e8ATWkjY7g9IVIa6K/8wGks7CSnSGZB+Lhb2SWkFAQhWFh/PlLp
ROwMEj5tV4IQs4hKUYvVv9PpkrmxLvRJ8wJfraa7WcYQlCnwLONF7VlvBztSgfUl
H5/apvaiVDoqnPiSV7i8z5iaI/moPwdO/Fp/9OWy6Wee32Eou8MiLRy7Is4efdJe
V2Sp8d1NbLgL58yk9jd+JYu3OlKAmMHbeK9JLDny9UnnzmiHy0XoLJBq1T/SqVWW
72/wgNA1264HWBBHI++RbKH1bUuhv7SN7hKqzjhPljSxxttESADRwPG7n8Baj7Ur
OpVT6Qe38KbaVbmJqOlNI4Q5lqCZ+i6ny22lJM37IHdzEYINLl3l9tfnyiuQWWQY
hwObyd2y6MkRIwfZ2TTjT0WpYK9Y2dnx4iNrxa6yuKHG5vuYiqm/WjF6mvCvi3Bz
8aEbZiI+WfoGh7s6UMIyig6E/RmdSS4dHADWPKREjvmoV54IzrH3bAjFQkSbh7Xq
fXP2EVJyBEnZJUFnXSJ1q+l89Epk3BCGbV1RdkbzTjSoauoK03evvc5uib+qOlgk
KakP/p9qOsO03r4OFqj8Op8rkiU3vKoDXJ/eqBXxzMDmWPyB5JHnqJCLS6Nga17j
ryaJtTfxdQ50BXEqNO0D
=A5Mv
-----END PGP SIGNATURE-----

--Signature=_Mon__23_Dec_2013_15_54_17_+1100_.OMQ90Lhb40WQ59d--
