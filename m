Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692AbaDGExJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 00:53:09 -0400
Received: from ozlabs.org ([203.10.76.45]:53760 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750743AbaDGExB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 00:53:01 -0400
Date: Mon, 7 Apr 2014 14:52:42 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>,
        Linus <torvalds@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>, Mark Fasheh <mfasheh@suse.com>,
        Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com
Subject: linux-next: build failure after merge of the final tree
Message-Id: <20140407145242.1958251349e0b6c6c8923f46@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__7_Apr_2014_14_52_42_+1000_9uJE8WZq.Odcv4Ek"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__7_Apr_2014_14_52_42_+1000_9uJE8WZq.Odcv4Ek
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

fs/ocfs2/suballoc.c: In function 'ocfs2_block_group_set_bits':
fs/ocfs2/suballoc.c:1357:2: error: implicit declaration of function 'trace_=
ocfs2_block_group_set_bits' [-Werror=3Dimplicit-function-declaration]
  trace_ocfs2_block_group_set_bits(bit_off, num_bits);
  ^

I have no idea how to track this down :-( The only patches affecting this
code are now in Linus' tree.  I can only assume that some implicitly
included header file is no longer included.  I have just left it broken
for now.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__7_Apr_2014_14_52_42_+1000_9uJE8WZq.Odcv4Ek
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTQi8oAAoJEMDTa8Ir7ZwV+uMP/1efjIs1f59v/GjZkFB+SMQG
/fR6opGkj3D2DsWnL1o3mKTyEFXk+buYsMmt/g6o2ctiiMyfsq545S0BUYCayKNi
bkdLPWtbuj2sSF7gZQgeFL9HkXcH3MFNu+TFLenvuVedo12MWwujWdrSb20EhvsF
gVN9GtG49zE49zpXxa5ptKPn1ix0C8vWn5mQWzk4SpZPoHu/Ot8aT74hyCM6c9WH
/pCOjGzhPjo8+jt+x4x+pDbjET2AbLGBt2Fs/3/FOvqn4iGdiI0fM6/jh5zR3FcQ
6wSjMrV/N195fJ47fgR3VCpszCr/6GVjRbwq9c+BcArgX50dK2fqR3GDcoFd/7re
fU8EbaS+So++TXSz+Qun6XNF6dW2L4I+751n+0xK8lvU+F6R3KWT3AZuEMFNjd4x
JLOG6LRNnbKzhtriF0aBOhlRHNxeiFio8Ehn49aUWxHmvlutQmPIo0ze6kzgrphV
vjUilABs8cTZoUFh90rfbmuqawCg/Kj0xqgbk3HiU8fwXkF36e1yGDeohDqj1rtd
ZOby0D6CLsBPYeUXBzWYzs8tElp9MGac1MKCVegoj6PnfMd535Sew0WoSdkjCMjn
IAiMLRnDozkfDKmZfEr9xyROVG8CNIVM+aFX1OIeBFphBluaCXig1FJttsvM6ZxL
7cEliweDOSW9PbwMtRjJ
=Ub8O
-----END PGP SIGNATURE-----

--Signature=_Mon__7_Apr_2014_14_52_42_+1000_9uJE8WZq.Odcv4Ek--
