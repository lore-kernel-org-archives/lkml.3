Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756644Ab3KGGiQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 01:38:16 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:39158 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756562Ab3KGGiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 01:38:05 -0500
Date: Thu, 7 Nov 2013 17:37:49 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, Michal Marek <mmarek@suse.cz>,
        Josh Triplett <josh@joshtriplett.org>
Subject: linux-next: manual merge of the akpm-current tree with the kbuild
 tree
Message-Id: <20131107173749.020fb3e03248c6b3227fe642@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta6 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__7_Nov_2013_17_37_49_+1100_9QJrpe6Fu+tfypGu"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__7_Nov_2013_17_37_49_+1100_9QJrpe6Fu+tfypGu
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm-current tree got a conflict in
scripts/bloat-o-meter between commit 21cf6e584ce3 ("kbuild,
bloat-o-meter: fix static detection") from the kbuild tree and commit
372dd3b27736 ("scripts/bloat-o-meter: ignore changes in the size of
linux_banner") from the akpm-current tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc scripts/bloat-o-meter
index 855198c9dedb,31c953195b52..000000000000
--- a/scripts/bloat-o-meter
+++ b/scripts/bloat-o-meter
@@@ -19,9 -19,10 +19,10 @@@ def getsizes(file)
          size, type, name =3D l[:-1].split()
          if type in "tTdDbBrR":
              # strip generated symbols
-             if name[:6] =3D=3D "__mod_": continue
+             if name.startswith("__mod_"): continue
+             if name =3D=3D "linux_banner": continue
 -            # function names begin with '.' on 64-bit powerpc
 -            if "." in name[1:]: name =3D "static." + name.split(".")[0]
 +            # statics and some other optimizations adds random .NUMBER
 +            name =3D re.sub(r'\.[0-9]+', '', name)
              sym[name] =3D sym.get(name, 0) + int(size, 16)
      return sym
 =20

--Signature=_Thu__7_Nov_2013_17_37_49_+1100_9QJrpe6Fu+tfypGu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIbBAEBCAAGBQJSezVBAAoJEMDTa8Ir7ZwVhksP+KaKynS/clEI8GY33lzrI6WV
qN4UtCzFWv2Gcib2/LkJEatTf9k+AZQ27ZTBe3QHYPqkZ0i/0I1ks9Y2GwwP0BjF
Bv7YGEbVJg4NK9h/DWF21+LvOsojR1csRKLztJqmhyY5AxT+EwGme6Qa8VPGwUGU
r4NzOC27T9oGjAXFJAFA00s39ZAcN6Q4rqD4Ub3XBxKZ2Sti/bvLavZ5lFeTlOKT
o6G/XZOpynwisWpz0T+ilbAi9jYwbzk/LE65mwrWvSBlEmMxocI5mFQPP09I/3JV
iMLCcy4qwpk5sYCSxPtKZsG2nlcoH2mR98g/hcZyzqjqeTMCb10W/xXdKa4aZq4+
PsFxm9ZVWghBoGUxI0p6wrACg1UEBAP+n6LgQd4cklx/iS6IAqE5yJ+TmYsTSVuA
dJ6hPrLeP/8K2NpTxKMKhvEte8g8d03nbZA5bCJfT7yQfBGgDUWDgH9srGjE6HwZ
u6lGAJIBIcawuPi6l587nxd/y3rMYrWwKO7PU8CfT4YU4U5jl5WuyBnPOWTvUVhW
3RvPwHbcayP7xdn525ZJgzo94Z/ANhwsJEU9FCdu3EqLMdhBVtndsT+wHQdiR8fi
zQ/EMxpthR4JQFNcWOZyWsBYExyCuYyfalOIp7LRxJbqc3QCiZ0emYdM2tvfCtNm
8IaT18pLtIqEgN3ecMw=
=IYTK
-----END PGP SIGNATURE-----

--Signature=_Thu__7_Nov_2013_17_37_49_+1100_9QJrpe6Fu+tfypGu--
