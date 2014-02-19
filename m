Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751606AbaBSFay (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 00:30:54 -0500
Received: from ozlabs.org ([203.10.76.45]:52358 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751318AbaBSFaj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 00:30:39 -0500
Date: Wed, 19 Feb 2014 16:30:30 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the final tree (sound-asoc
 tree related)
Message-Id: <20140219163030.049eecb85a2a540995f2ba54@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__19_Feb_2014_16_30_30_+1100_RP1UpiDuWLF2X5h0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__19_Feb_2014_16_30_30_+1100_RP1UpiDuWLF2X5h0
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

sound/soc/intel/sst-dsp.c: In function 'sst_dsp_outbox_write':
sound/soc/intel/sst-dsp.c:218:2: error: implicit declaration of function 'm=
emcpy_toio' [-Werror=3Dimplicit-function-declaration]
  memcpy_toio(sst->mailbox.out_base, message, bytes);
  ^
sound/soc/intel/sst-dsp.c: In function 'sst_dsp_outbox_read':
sound/soc/intel/sst-dsp.c:231:2: error: implicit declaration of function 'm=
emcpy_fromio' [-Werror=3Dimplicit-function-declaration]
  memcpy_fromio(message, sst->mailbox.out_base, bytes);
  ^

Caused by commit 790aff62291e ("ASoC: Intel: Add Intel SST audio DSP low
level shim driver") from the sound-asoc tree.

I have disabled this new driver by reverting commit ddfa40b1586f ("ASoC:
Intel: Add build support for Intel SST DSP core") for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__19_Feb_2014_16_30_30_+1100_RP1UpiDuWLF2X5h0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTBEF9AAoJEMDTa8Ir7ZwVA6oP/2n9V1XXzHVVYjP0N3RT1Vl5
dnlrN+7mkQjwPw+7XbaiyKryKZkIn7qqNGFYGKwvcg/KWm4QvVY0i70bpBGgGH43
pbLIHc38xx6QJ/YChlFNVamItMekmksJ8AihXjmL8jhzHpWIfHs8wLqbrCFBfX0S
8+V6MZCemNu7Nn6ekTqED4yqHwXw3ffgf4v+PyfOyHSB6uJBPBszJQmtOAW4kxvz
BAr/CBAAsyq7dy43y12JQVop5h9/zmr1b3aInQkisMXqlxHGiMMhnsmRCMrhD8sL
Nc8FXhuGkU0u5Asn9iKr8kK3xj4aBnJM/9wrjjVAKyNQCGBONAZNgq1GfHco05gh
ZDWIyKxYZ7E/d7Yc+sLWAShTWR86p5s0B483gLax8TVy26iU3+BKhpeW6DEJ2gSo
Tbxg5IOQHw7GxymA7wpZRut7V7ClfufcCrCrUpySBxCuNYnKxiKiGrH52ofQ6IKj
zV2Pnpp9twAknz2Q4i7LdptljSQKqTg5e5Dmw9qC5ezFYYra5K8Fgpi4aQBkcwxl
Ai4tqtYwo3mMtWRsQhWsSAvZi5gEJUAlxe+xpUDg42unTHVLMPmODYDvQQ+jegEK
bOQuJ6LvSXw2vAiEVZ0WDTZlgMl6oETh/WiZ0LFJipnh6QVREu9Q9ZARfe7y+oO1
O0OEzZ9KwKbVcgzNwZ2l
=2bo+
-----END PGP SIGNATURE-----

--Signature=_Wed__19_Feb_2014_16_30_30_+1100_RP1UpiDuWLF2X5h0--
