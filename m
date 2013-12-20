Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753755Ab3LTEJc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 23:09:32 -0500
Received: from ozlabs.org ([203.10.76.45]:44018 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752000Ab3LTEJb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 23:09:31 -0500
Date: Fri, 20 Dec 2013 15:09:21 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thierry Reding <thierry.reding@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: linux-next: manual merge of the clockevents tree with Linus' tree
Message-Id: <20131220150921.1203c672e25cd6eafb8a4118@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__20_Dec_2013_15_09_21_+1100_BQxXCG9pzbHwYe6h"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__20_Dec_2013_15_09_21_+1100_BQxXCG9pzbHwYe6h
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Daniel,

Today's linux-next merge of the clockevents tree got a conflict in
drivers/clocksource/clksrc-of.c between commit 4c4b053235fa
("clocksource: clksrc-of: Do not drop unheld reference on device node")
from Linus' tree and commit fdca679d87bb ("clocksource: clksrc-of: Warn
if no clock sources are found") from the clockevents tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/clocksource/clksrc-of.c
index b9ddd9e3a2f5,a30b42c3ac3b..000000000000
--- a/drivers/clocksource/clksrc-of.c
+++ b/drivers/clocksource/clksrc-of.c
@@@ -35,5 -36,9 +36,8 @@@ void __init clocksource_of_init(void
 =20
  		init_func =3D match->data;
  		init_func(np);
 -		of_node_put(np);
+ 		clocksources++;
  	}
+ 	if (!clocksources)
+ 		pr_crit("%s: no matching clocksources found\n", __func__);
  }

--Signature=_Fri__20_Dec_2013_15_09_21_+1100_BQxXCG9pzbHwYe6h
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSs8L5AAoJEMDTa8Ir7ZwVK9oP/1EZD+zcDo9Ia8vxDOLw8u3R
Ydd1wRXBalMubChHOpoo+N8jPePshmY1L9Fli+UJA7PU5Ash7yUXmji1tSirzIBC
FBggQ6Mf2GD/JdPlDvjq51wwMOroAtMzDhCUP/L9DEKpnrxAaboa8Qs4l72lXwa6
WWYpIw/GHuFE+8KAVOwPn7xNEQpT98NgxUEZ26KXTrIYFpPcHGQqPPRBwvxr4OB1
XHup8ZFtreV8xyBxySy2P2qtKuG56kah+Cy1uTAny0WgR1qoyggjxhU3ryg/X8nY
Sz9YXoqUCYFteGiHDY5ps4LWVBj4SEkiD2fbI/jvREIyJCBNs1OVNhcG4J2k9UT3
6Ljg3QKqhTJjomINTV/o0Ca2gEdqXFGmD7Pn1qbxsz9srj7BJCjVOrn3W8Bdur/H
IHTAnG550jU5R7CuSkDtg0K47HRllClWIyKLthsCm6S/FgBVZPSYHa7n3Q617AVi
LilIInQgudrGRcVKzteeOQXaKi/opR16GHDAcJaEvLcZoHYdv6zBWF4ZN7hxqJl5
U+TQwk/8oqgqVnVWjhE0QfCMDpAbSbalPQgNWBZqZC6FI4f0/0lbNbLkwi/fSHYo
87RzZUJzSQq0QATncXbO5SKizs6QXg7ZRXM1AAAlk6L1JGWIpVX192CWlNfsWtZ/
v+sdEfBIKPnNxnX+B46R
=rith
-----END PGP SIGNATURE-----

--Signature=_Fri__20_Dec_2013_15_09_21_+1100_BQxXCG9pzbHwYe6h--
