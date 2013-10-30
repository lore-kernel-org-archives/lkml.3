Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359Ab3J3HAz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 03:00:55 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:34356 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753103Ab3J3HAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 03:00:54 -0400
Date: Wed, 30 Oct 2013 18:00:42 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jason Baron <jbaron@akamai.com>
Subject: linux-next: build failure after merge of the akpm-current tree
Message-Id: <20131030180042.7db60252a0779f89483ef51b@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__30_Oct_2013_18_00_42_+1100_E1lX1/SEFeVt+cjR"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__30_Oct_2013_18_00_42_+1100_E1lX1/SEFeVt+cjR
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

After merging the akpm-current tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

In file included from include/linux/init.h:4:0,
                 from fs/eventpoll.c:14:
fs/eventpoll.c: In function 'eventpoll_init':
include/linux/compiler.h:321:20: error: call to '__compiletime_assert_2137'=
 declared with attribute error: BUILD_BUG_ON failed: sizeof(void *) <=3D 8 =
&& sizeof(struct epitem) > 128
    prefix ## suffix();    \
                    ^
include/linux/compiler.h:326:2: note: in expansion of macro '__compiletime_=
assert'
  __compiletime_assert(condition, msg, prefix, suffix)
  ^
include/linux/compiler.h:338:2: note: in expansion of macro '_compiletime_a=
ssert'
  _compiletime_assert(condition, msg, __compiletime_assert_, __LINE__)
  ^
include/linux/bug.h:50:37: note: in expansion of macro 'compiletime_assert'
 #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
                                     ^
include/linux/bug.h:74:2: note: in expansion of macro 'BUILD_BUG_ON_MSG'
  BUILD_BUG_ON_MSG(condition, "BUILD_BUG_ON failed: " #condition)
  ^
fs/eventpoll.c:2137:2: note: in expansion of macro 'BUILD_BUG_ON'
  BUILD_BUG_ON(sizeof(void *) <=3D 8 && sizeof(struct epitem) > 128);
  ^

Presumably caused by commit 83b5ec605b7e ("epoll: optimize EPOLL_CTL_DEL
using rcu").

I have reverted that commit and 2 follow up commits to that file ("epoll:
do not take global 'epmutex' for simple topologies" and
"epoll-do-not-take-global-epmutex-for-simple-topologies-fix") for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__30_Oct_2013_18_00_42_+1100_E1lX1/SEFeVt+cjR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJScK6fAAoJEMDTa8Ir7ZwVNi8P/AotNnrE2NnVKgqhCZvsW5pS
hmqxIQQ5nb6iHZP3pkJkez5CcmAIFyayKwEwEZFjbXD/MgNbj/FyUCJeSQ21xBtt
39Vlgw1uvD//n2CuOr6wMFoxlfqWmxJ45HIhwVBae6ZwB+dHlfjWAkDYlupWa0Xq
A2ZfX/JhIH6h1nAoR00YdWXAQUCzvOIfYQBK5V8eF1hjmUQygB+0swZGFF8AALa4
JxfXtdjBd/GhnNi6FYOYJ/lLLvN2XMoSjqsN1123K58NA7+3kyaz7RPOcpVJ0mRm
JeemNQpSrTwRxVf0A0fGdt/g+FgaNcxi8UJTC7xqGAEWN6Fp/pQV8Z6v/MXpcvLc
z5qGx2ymyMyi+5P7+QvBfPvDLBVy0WBGTh0Lz5ZN6zq6pTi+fJENFSJdR5YcLZ1u
rKA4tG/6+oFg8U28OprkXWUndjTdCdqg90YY4Jak+9BSSsRQYr76dOiqPLvuuyzW
T0rybfQQnxYCg1Qlplz+21mZ1ObD972JndC97WqkUdT4jpyppd4TMZzc7jmwCkbz
C3m6W04sofpZhoO2NwYs+VjuV6von2MjuPStndNJmdjzrcILW8XlcaB7ZiJIgpzh
h7IEnS6UxjG8qKE6T3q334yZzUAEzaYrEa56eXhUDx8Ui2Tvw/oOdqfxgr5uSTMt
B1hZusPqfr38xqWyEzhx
=wowh
-----END PGP SIGNATURE-----

--Signature=_Wed__30_Oct_2013_18_00_42_+1100_E1lX1/SEFeVt+cjR--
