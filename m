Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515Ab3ARDD4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 22:03:56 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:54813 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869Ab3ARDDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 22:03:54 -0500
Date: Fri, 18 Jan 2013 14:03:46 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shawn Guo <shawn.guo@linaro.org>
Subject: linux-next: build failure after merge of the gpio-lw tree
Message-Id: <20130118140346.3f9b182aa7daa175b4f136bf@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__18_Jan_2013_14_03_46_+1100_Nh1QDhiVvRKpvb/i"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__18_Jan_2013_14_03_46_+1100_Nh1QDhiVvRKpvb/i
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

After merging the gpio-lw tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

drivers/gpio/devres.c:51:5: error: redefinition of 'devm_gpio_request'
include/linux/gpio.h:97:19: note: previous definition of 'devm_gpio_request=
' was here
drivers/gpio/devres.c:80:5: error: redefinition of 'devm_gpio_request_one'
include/linux/gpio.h:109:19: note: previous definition of 'devm_gpio_reques=
t_one' was here
drivers/gpio/devres.c:113:6: error: redefinition of 'devm_gpio_free'
include/linux/gpio.h:128:20: note: previous definition of 'devm_gpio_free' =
was here

Presumably caused by commit d39cd0301255 ("gpio: devm_gpio_* support
should not depend on GPIOLIB").

I have used the version of the gpio-lw tree from next-20130117 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__18_Jan_2013_14_03_46_+1100_Nh1QDhiVvRKpvb/i
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ+LuSAAoJEECxmPOUX5FEtccP/iqqSHmwTbxmG6QLX+8NVawp
NEARdX/wZ8FaBkvO36Sv1Y6FSNsQYBn4sw5KxI5Rq2JbZP9DTTewsOFGAX3aATdm
gpvXCr3CWb13+CJ5N0b5nqnLYxtAi6RIrBjMgg3cQa8g7eQEeq9zQvMpy3+fjIrY
TlcYij2pjUTmMXK0+sQoQxAjtdNpLtn+XnD5ZKEmGSQLgwliD9p1XfjreIgMLOon
nJWXaNkgGlhcw2FRer1bfeKHAzHxyCictsuSwUwYnn0CeVBsSW+SM/w/2u4giWc0
d5kd4HR3DDZJy2z6AhDzGV1ixnXp5GZX/bCRO2KZiKCZyMebaob3JVCGTwjZz8Qw
5N4OTzTMQL5+ueHl6+CJkI13SctLyxi4HIJnr3a8ixzAljhQiMRM/D3ZQS57fprQ
YexMF4VVIpu7CCZ3BMeEu07rSHdM18fI3vrVWWWAx84RzMsu5Jsp2iCBk/bADebc
1l6xDvKeWxE5nbwy7LKYuxLOtthIosFmbvRp7nJabe+0wEcNjxHSPP1JGIiNhXr2
Sy/uQYiD+3noOVjHWllJn5S9EcgYX2ZFmjLlSCxhZbnvXksP7LodaUvBR+m8CJch
TXwYnL03WIvJG2ebOdSP72fUYWO4xSKjLoXERXzNY3qvE8cp18mwrFObzgo12FpE
lF8mJMg4HnIQo48q6YKm
=MeNP
-----END PGP SIGNATURE-----

--Signature=_Fri__18_Jan_2013_14_03_46_+1100_Nh1QDhiVvRKpvb/i--
