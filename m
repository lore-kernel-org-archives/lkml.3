Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933062Ab3DDHKx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 03:10:53 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:59083 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933034Ab3DDHKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 03:10:52 -0400
Date: Thu, 4 Apr 2013 18:10:43 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: linux-next: build failure after merge of the final tree
 (wireless-next tree related)
Message-Id: <20130404181043.c191e7f4aa3057e6eda151cc@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__4_Apr_2013_18_10_43_+1100_dk0mYOib4873MBfI"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__4_Apr_2013_18_10_43_+1100_dk0mYOib4873MBfI
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

drivers/net/wireless/rtlwifi/rtl8188ee/built-in.o: In function `.rtl92c_phy=
_ap_calibrate':
(.text+0x21d14): multiple definition of `.rtl92c_phy_ap_calibrate'
drivers/net/wireless/rtlwifi/rtl8192c/built-in.o:(.text+0xb1e8): first defi=
ned here
drivers/net/wireless/rtlwifi/rtl8188ee/built-in.o: In function `rtl_hal_pwr=
seqcmdparsing':
(.opd+0xed0): multiple definition of `rtl_hal_pwrseqcmdparsing'
drivers/net/wireless/rtlwifi/rtl8723ae/built-in.o:(.opd+0x11a0): first defi=
ned here
drivers/net/wireless/rtlwifi/rtl8188ee/built-in.o: In function `rtl92c_phy_=
ap_calibrate':
(.opd+0xe58): multiple definition of `rtl92c_phy_ap_calibrate'
drivers/net/wireless/rtlwifi/rtl8192c/built-in.o:(.opd+0x570): first define=
d here
drivers/net/wireless/rtlwifi/rtl8188ee/built-in.o: In function `.rtl_hal_pw=
rseqcmdparsing':
(.text+0x22164): multiple definition of `.rtl_hal_pwrseqcmdparsing'
drivers/net/wireless/rtlwifi/rtl8723ae/built-in.o:(.text+0x297a8): first de=
fined here

Caused by commit f0eb856e0b6c ("rtlwifi: rtl8188ee: Add new driver").

I reverted commit 8b138d4898a0 ("rtlwifi: rtl8188ee: Enable build of new
driver") for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__4_Apr_2013_18_10_43_+1100_dk0mYOib4873MBfI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRXSdzAAoJEECxmPOUX5FEcrQQAI4QDwqAUYleseYaMGg6Ecb2
P4e4mPo5bTfbCWQvnoC1EmP+sjMWnfz8s/t/o5ZJC4BaqdMHbNtigjUic3R9zVh/
s7rriNc7KqsbwZO8cNYHXJq+ZSnvI6b6VCLxC6rcBteUyYxadz0F89FytngzUzaS
4IH2/66LAG2kqOe7GR9qlLvTLHQ6vc4vNLlZBVhEbUdoLFo4YtWzKyR6aImZfo9T
EZ0fsU+OylgQ2Ug6C8FLUKAqFmQeiB0I9Vehpr99a1+M1P2PZD4vCJHtg5mgBUS5
ua9ctmnePIh14cEVYY/uQWbXEeB3I/pi+EsYM76jaWll3NN0itp7CUNfIxGPSCDr
dydCQ6b6ms0Uf9iJjAh52Vzm17VDgSD1lrkuvWfWVEID65QgZ/L0tYBThjbkytAr
VnMwXqIVLmj9YIugt+FsPc6PASJop5tZgnuKxExMrr58unHUHLxAaub5397xC6cb
+ZeVZEBy6fr3c76EYKPC6Nn1yHia1kKON7G7xAAWu9FXCsXM2M4e3o24hmKIyvrw
10Oa/NfwC3cx1HiwlXyLAMWLm3LJs7FeEn5P44l4RqyFoTfrtGhwvQuldXJVfOg3
t+aaC0NJT7GcfBIr1t1jpCHYNnDs+ALvMOth6+5fVXQLOFqz6a+VWKHjwUu3yDPu
nbMbOcpWcluIMjgFNAre
=3qS5
-----END PGP SIGNATURE-----

--Signature=_Thu__4_Apr_2013_18_10_43_+1100_dk0mYOib4873MBfI--
