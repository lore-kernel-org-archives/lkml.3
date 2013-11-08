Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756779Ab3KHHiW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 02:38:22 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:60968 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755187Ab3KHHiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 02:38:18 -0500
Date: Fri, 8 Nov 2013 18:38:06 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Josh Triplett <josh@joshtriplett.org>
Subject: linux-next: manual merge of the akpm-current tree with the vfs tree
Message-Id: <20131108183806.809acb8b1608c42457d64e5a@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta6 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__8_Nov_2013_18_38_06_+1100_ZwT_OYA8B4OyjWau"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__8_Nov_2013_18_38_06_+1100_ZwT_OYA8B4OyjWau
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm-current tree got a conflict in
include/linux/lglock.h between commit 4314ff760e8b ("no need to keep
brlock macros anymore...") from the vfs tree and commit f5639052d567
("lglock: map to spinlock when !CONFIG_SMP") from the akpm-current tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/linux/lglock.h
index 96549abe8842,6561b1c0fa63..000000000000
--- a/include/linux/lglock.h
+++ b/include/linux/lglock.h
@@@ -25,6 -25,18 +25,8 @@@
  #include <linux/cpu.h>
  #include <linux/notifier.h>
 =20
 -/* can make br locks by using local lock for read side, global lock for w=
rite */
 -#define br_lock_init(name)	lg_lock_init(name, #name)
 -#define br_read_lock(name)	lg_local_lock(name)
 -#define br_read_unlock(name)	lg_local_unlock(name)
 -#define br_write_lock(name)	lg_global_lock(name)
 -#define br_write_unlock(name)	lg_global_unlock(name)
 -
 -#define DEFINE_BRLOCK(name)		DEFINE_LGLOCK(name)
 -#define DEFINE_STATIC_BRLOCK(name)	DEFINE_STATIC_LGLOCK(name)
 -
+ #ifdef CONFIG_SMP
+=20
  #ifdef CONFIG_DEBUG_LOCK_ALLOC
  #define LOCKDEP_INIT_MAP lockdep_init_map
  #else

--Signature=_Fri__8_Nov_2013_18_38_06_+1100_ZwT_OYA8B4OyjWau
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSfJTiAAoJEMDTa8Ir7ZwV3WgP+wQjRvPteL2aMAm47ahWgsR+
1MtoAOh+Js5JVaDy68HNYDv1N9eMyZ+dH5uejhy6XEaY5FXBRtCFbbnlV+54fqRa
SCF/mfANpBi9YIVeiUO+J4qRufw6AxPmsO5nOMg3pRh1GkuG5uJZADhQ7EfYImNz
q7Qdmat+rX8+zdQS9sOQEEWnhgEDtzctA2vjCLxsL7S1NZGnM0UNGDeC/M0bH/g4
c+7hlXf/zUhKihwSiOxjjxX08dcJhZBZk1yescr0B3ZlSkEwJtV8BXigLq8s9kqU
31A+SsCgz4oV43VO/5ejROzpAgJMpj9UTSI9Xpr+zHY1oiAnTE/ytNYeD02Msjxq
xF6UHEL3gQaYJFCLRu55blsKQZqXu4adYDDz25KU+Yyl6+uNZDQXlAkNdsVhoFAW
Mk5DOJ9XNcdWstg/MJ1syvws1rJCmrYQq/kJd0R4iyW+aY/qXo9OXnVTCoKJLOtF
roY/cl8f3ihc2XoTIW44NhefY9T5nuClamKLpII7sD8iqr3na7Mg0nyttYdRmWgO
FJw2IdCdbJWM1sq1gX5+T0a5Yv7QMs7F3tmFrUIkzTG0/ES11kSlZxJI3Zailqpz
xpEUxQY+1o0C//nNRehMM663arSnrKsf8KsKGOQbvZ9wDXd0sbyPD+wrcFrhbEGM
NchLWsiBREysJnyx0Mjc
=oPj+
-----END PGP SIGNATURE-----

--Signature=_Fri__8_Nov_2013_18_38_06_+1100_ZwT_OYA8B4OyjWau--
