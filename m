Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752973Ab3KDGxF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 01:53:05 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:46465 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752900Ab3KDGxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 01:53:03 -0500
Date: Mon, 4 Nov 2013 17:52:51 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@linaro.org>, Liam Girdwood <lgirdwood@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nicolin Chen <b42378@freescale.com>
Subject: linux-next: build failure after merge of the final tree
Message-Id: <20131104175251.817bdd5b55652625b2b6e0ed@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__4_Nov_2013_17_52_51_+1100_8tOFGPiURo_Wm4+u"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__4_Nov_2013_17_52_51_+1100_8tOFGPiURo_Wm4+u
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

sound/soc/soc-pcm.c: In function 'soc_pcm_open':
sound/soc/soc-pcm.c:186:2: error: implicit declaration of function 'pinctrl=
_pm_select_default_state' [-Werror=3Dimplicit-function-declaration]
  pinctrl_pm_select_default_state(cpu_dai->dev);
  ^
sound/soc/soc-pcm.c:323:3: error: implicit declaration of function 'pinctrl=
_pm_select_sleep_state' [-Werror=3Dimplicit-function-declaration]
   pinctrl_pm_select_sleep_state(codec_dai->dev);
   ^

Caused by commit fc1a38653793 ("ASoC: Add pinctrl PM to components of
active DAIs") from the sound-asoc tree.

I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__4_Nov_2013_17_52_51_+1100_8tOFGPiURo_Wm4+u
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSd0RIAAoJEMDTa8Ir7ZwVcZUP/220tpFTjMI4/l7kX0DvYBib
OURhZXSY+CsPBjrH7yrpH3JkO96eDyjAK0Q5HPEL6dP/IeN5Fwjon6bLhvwlw0pS
YFWU8xyynURyR2hALig6hM8tts9wJ/PzGcJoSEtRRA1JyGNgFkzMFqpUY9S2HrwW
mRZP+j6COm/qvORxx1e4XTSHTpPjcivVJAOLl7/bLPvd38cVXvb8JsKQ9UokNUsN
ClGn/+PhoaCaqrLtlKalFYTyyHpkLTHKQ0SsoTtoL5bN2M3EFPEYHV1JM0rqCHmD
kDFZTA9zU2udXBXbZi5JpuJUD+HOBs19UZsZcmlPMJeWuoKITmRoC5pr+vHRIOC2
U1Zs/yOuNw1O5w/TgP/ZL+/wv91ibMi6iHKV6kpqr0zC6in/FLcvVWfRmRCmvKUp
cmqLduEFQ3JyJ2/XCc5CQbVQ00EnX0BO4Fi8vNcPQqiWk60821DRaSCdpPiqk3tA
gMlD4kee0SHJrts/fc3ljhrMok1HYbXvqH5liB2WD565pWs6Q7Q9M6LSQUETdZKP
IuXeVpCYBwfftCcTblnTElypZBbqThii2/NtF4IpD9+pUifSJSa/KdusxY4GEUtz
z+Ri2mpE9fgzJN21yw+uZyiE8ixJo3VSwfQ4ifepzXCEYE8dl6hSpw2qoqsY4t8n
kZY/fcFXeAD4mfRMYU+I
=Kawf
-----END PGP SIGNATURE-----

--Signature=_Mon__4_Nov_2013_17_52_51_+1100_8tOFGPiURo_Wm4+u--
