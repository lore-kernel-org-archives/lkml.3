Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758805AbaCSBKJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 21:10:09 -0400
Received: from ozlabs.org ([203.10.76.45]:55365 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758552AbaCSBKG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 21:10:06 -0400
Date: Wed, 19 Mar 2014 12:10:00 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nicolin Chen <Guangyu.Chen@freescale.com>,
        "Jean-Francois Moine" <moinejf@free.fr>
Subject: linux-next: build failure after merge of the sound-asoc tree
Message-Id: <20140319121000.ccea7c0440649976ae722abd@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__19_Mar_2014_12_10_00_+1100_pmTAvu+dtHT+U2AM"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__19_Mar_2014_12_10_00_+1100_pmTAvu+dtHT+U2AM
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the sound-asoc tree, today's linux-next build (x86_64
allmodconfig) failed like this:

sound/soc/generic/simple-card.c: In function 'asoc_simple_card_parse_of':
sound/soc/generic/simple-card.c:188:47: error: 'struct simple_card_data' ha=
s no member named 'daifmt'
   ret =3D asoc_simple_card_sub_parse_of(np, priv->daifmt,
                                               ^
sound/soc/generic/simple-card.c:201:47: error: 'struct simple_card_data' ha=
s no member named 'daifmt'
   ret =3D asoc_simple_card_sub_parse_of(np, priv->daifmt,
                                               ^

Caused by commit 56556f333ae3 ("ASoC: simple-card: overwrite cpu_dai->fmt
with codec_dai->fmt"). daifmt was removed from struct simple_card_data in
commit c56c4d74c6f9 ("ASoC: simple-card: Simplify code").

I have used the sound-asoc tree from next-20140318 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__19_Mar_2014_12_10_00_+1100_pmTAvu+dtHT+U2AM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTKO5sAAoJEMDTa8Ir7ZwVcn0P/3wBmaLWB6DNN6wrpc5rc1SI
wDRBAPccWyr8wwGxgfbgiNmZw2l+b66D0ccHugU/8Hnvy8mliFv5kYvN+3NhP/lK
I6XHsFKRtiktaIhQ+4ECvlqWCm4QSbMIUIwC+aXQujAyjGBMs2p2hVjKjv64vOH/
p9QSvYvqlVJ1iJq2qrCtQuWgu8zYJXFyCEvkgJROhUmbKXaR8GrnXk03YpZlV7Cc
cmobPbztuCwjR9gQgERGNwdGrAa4vo9U1GLhtjRrNHPX0j0fOIR/OiRMPyXt3Rad
9ZcZseoYc/iDCEIPovunX9bCGp/UtjkqFGvwB7yoSQSQQLtud7CP6n4Fzcbog2Yf
hSaBWC8ArtxOaJm3FVFkXRV8VFCuz4WP+45LLOgN8kqFWB7DeQNvjTZiTCFsh7O2
lRSrmBG5xoknRtUcYLYF0hOZSlVJuU8h9OXsbUeVaPtb+gNJYWVxxPVGhroi9HHp
4wdfyxoc/euSTM6ZJ+m4HwPphiDVE2qe74q+HeTgjl/lAHyUml/xbS9+wyttWNi/
IjuIG5Xn98ZhpM3voDSPQra51ZUQRe6/H/86i/1z8CQuQGPpqfyA7MGtF9hXGDUE
epCvpzq+thrzfmIk4RxCdH5n1EvPmb6MVyEZhIzUuqH9ACeymyZYq6Up6ZaCfqJv
0Mbd4y+iN7R915al3nNM
=L2li
-----END PGP SIGNATURE-----

--Signature=_Wed__19_Mar_2014_12_10_00_+1100_pmTAvu+dtHT+U2AM--
