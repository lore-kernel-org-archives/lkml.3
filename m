Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687Ab3J1Odn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 10:33:43 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:55354 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756656Ab3J1Odm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 10:33:42 -0400
Date: Tue, 29 Oct 2013 01:33:39 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Alasdair G Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Heinz Mauelshagen <heinzm@redhat.com>
Subject: linux-next: build failure after merge of the final tree
 (device-mapper tree related)
Message-Id: <20131029013339.e13fe6dda17949fd32bb88b3@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.21; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__29_Oct_2013_01_33_39_+1100_wSP/mWwQMoV4Cr1M"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__29_Oct_2013_01_33_39_+1100_wSP/mWwQMoV4Cr1M
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

drivers/md/dm-cache-policy-hints.c: In function 'alloc_hash':
drivers/md/dm-cache-policy-hints.c:94:2: error: implicit declaration of fun=
ction 'vzalloc' [-Werror=3Dimplicit-function-declaration]
  hash->table =3D vzalloc(sizeof(*hash->table) * hash->nr_buckets);
  ^
drivers/md/dm-cache-policy-hints.c:94:14: warning: assignment makes pointer=
 from integer without a cast [enabled by default]
  hash->table =3D vzalloc(sizeof(*hash->table) * hash->nr_buckets);
              ^
drivers/md/dm-cache-policy-hints.c: In function 'free_hash':
drivers/md/dm-cache-policy-hints.c:101:2: error: implicit declaration of fu=
nction 'vfree' [-Werror=3Dimplicit-function-declaration]
  vfree(hash->table);
  ^
drivers/md/dm-cache-policy-hints.c: In function 'alloc_bitset':
drivers/md/dm-cache-policy-hints.c:184:2: warning: return makes pointer fro=
m integer without a cast [enabled by default]
  return vzalloc(sizeof(unsigned long) * bit_set_nr_words(nr_cblocks));
  ^

Caused by commit ce567d11e819 ("dm cache: add hints policy") from the
device-mapper tree.

I have just left this broken for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__29_Oct_2013_01_33_39_+1100_wSP/mWwQMoV4Cr1M
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBCAAGBQJSbnXDAAoJEMDTa8Ir7ZwVEzsP/ibp9Fy/xCmz8CleRkpOaLN+
c+EdjXSt4XoO5clpj+LG1r8hp6CsG/qLeV6M77EdJlnBlDdz04UC6oX1wbhEcOxB
biIqRzzyZOyoh1/s07NiRetd1xtFVVBitkB/LY8MylWh6BikLLPtUBLcgDi7ohpi
jbQP6SATn7CF6SfvyHUfyuP1EsCq488ehFcCX/PGzdHxxPK4xQA/agshGfcYNX2K
T0XJXkdmb18CzoENXAVfjCA2L7fsC1EjehkasrXnlG5HaGmJ6/F2p0YHc+7Aef9l
L+3tZziIQJv2T4E5seMhuGl9OguhH1NDY1lKIymu8YC3fBxYnjfpaTqKei2TLlty
f4vuhSjcoNO7u+Eb6i6pKm+YsQgaKhHNc+zH2/FC3i/Tlcx7t2A0bkTaCrVZgpq0
PAQqVIAceGkbUuuDiCDgqESGaJ8CSi8lBfh7Bg9k2Jt4uZtXAfbXiEsTJXiVpO5k
h3Q/RTJwXayZ4UJ8MIDJ2A+Sr63QhoLVfLpsLpJwhMqeDdrvfNoFKw19lnOlWdJZ
A9KmDZVR6wSf6ptSeqC0TpZarRxszgGfOB8Nxta1JmLuvaxkMp6THP0GS4mUQ2Vd
w218ok9e4mVdafuD6+Z+K0lhxxpo+vfpJyEfX5Jur/JblPqzGBQGKQrxm0w2Z6st
S8Amjs5shocx8GoTk2cf
=DwCs
-----END PGP SIGNATURE-----

--Signature=_Tue__29_Oct_2013_01_33_39_+1100_wSP/mWwQMoV4Cr1M--
