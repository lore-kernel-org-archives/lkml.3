Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705Ab3DKEI3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 00:08:29 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:59066 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475Ab3DKEI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 00:08:28 -0400
Date: Thu, 11 Apr 2013 14:08:23 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: linux-next: manual merge of the tip tree with the pm tree
Message-Id: <20130411140823.8a41393bb865c73d398ceb24@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__11_Apr_2013_14_08_23_+1000_a5.hHuh/jFyco5HY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__11_Apr_2013_14_08_23_+1000_a5.hHuh/jFyco5HY
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tip tree got a conflict in
include/linux/clockchips.h between commit 4dbad816febb ("timer: move enum
definition out of ifdef section") from the pm tree and commit
19919226c3f2 ("clockevents: Add missing tick_check_broadcast_expired()
for CLOCKEVENTS=3Dn") from the tip tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/linux/clockchips.h
index f9fd937,464e229..0000000
--- a/include/linux/clockchips.h
+++ b/include/linux/clockchips.h
@@@ -181,7 -192,8 +192,8 @@@ static inline void clockevents_notify(u
  static inline void clockevents_suspend(void) {}
  static inline void clockevents_resume(void) {}
 =20
 -#define clockevents_notify(reason, arg) do { } while (0)
 +static inline void clockevents_notify(unsigned long reason, void *arg) {}
+ static inline int tick_check_broadcast_expired(void) { return 0; }
 =20
  #endif
 =20

--Signature=_Thu__11_Apr_2013_14_08_23_+1000_a5.hHuh/jFyco5HY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRZjc3AAoJEECxmPOUX5FE8L8QAIUHEfZ/NJ1gCbDKGOsJuCsx
hryG7ZG2AOyYlhCc2QUKwc2vfw4UEpl7AOeyqTwTiE5/lqy7Qww0KoP7ifututUI
qsGjI7GGIjIR1ZXWWSAZQ7R8zHQYaHw8wTpRnyKUhusynWdCh/WVefptIh6ulC3L
oDSqUnmYAf84VQetguWKYlvYTAgIsbDhMhvatlt0cWqcUW9KK6TLEmYrbe6s0FOB
+m0ROVfqocBMfMgek2QrEAdg3xlnohfiM4drbP6CkUTA3Zejb/kDIo0rov6k1/o+
J16jUni/gAM3sSpWW3JYsvWUmhfiol+/0QYsu4Y20VrlqZiJHhI5hDDQXhnbgBcj
vC6TyE6LMHejG5wAoOqzglZrEHLTOjbaTSiXp9zn+ETneEOuzfKwJOlCHj2XbVnu
axEg22dNePBGWwvgnfO+vCjQIDHFPRBH17o4G2VcyMiXAuOILOtjqxKXqN/Jufjh
2qtA67arhDA+BCobYL8qZyn3o9dPdZaWmgBRGtkt6Zn4wZQGApzkuPJp/yHLbhvy
J81rDEVKdavZYvJ70xIOdSukKnFMQofN7cGoT9n70n0QuEJjzNpmPh3G9DJaT26f
JrygF4hT5dJLxscndqlPCuIGpeOgZ7Wly2bI7dUkDd8593l7PBuVXEsgMeBDO/34
gxSdqpFtECLtb1df45wC
=NM2t
-----END PGP SIGNATURE-----

--Signature=_Thu__11_Apr_2013_14_08_23_+1000_a5.hHuh/jFyco5HY--
