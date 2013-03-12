Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155Ab3CLEmc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 00:42:32 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:45269 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714Ab3CLEma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 00:42:30 -0400
Date: Tue, 12 Mar 2013 15:42:15 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Li Zefan <lizefan@huawei.com>, "David S. Miller" <davem@davemloft.net>
Subject: linux-next: build warning after merge of the final tree (tip tree
 related)
Message-Id: <20130312154215.f9c3e957c2a2e510f27b826a@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__12_Mar_2013_15_42_15_+1100_K0V+qjiLHbzf9wyh"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__12_Mar_2013_15_42_15_+1100_K0V+qjiLHbzf9wyh
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (sparc defconfig)
produced this warning:

In file included from kernel/sched/core.c:85:0:
kernel/sched/sched.h:1043:39: warning: 'struct sched_domain' declared insid=
e parameter list [enabled by default]
kernel/sched/sched.h:1043:39: warning: its scope is only this definition or=
 declaration, which is probably not what you want [enabled by default]
In file included from kernel/sched/cputime.c:7:0:
kernel/sched/sched.h:1043:39: warning: 'struct sched_domain' declared insid=
e parameter list [enabled by default]
kernel/sched/sched.h:1043:39: warning: its scope is only this definition or=
 declaration, which is probably not what you want [enabled by default]
In file included from kernel/sched/idle_task.c:1:0:
kernel/sched/sched.h:1043:39: warning: 'struct sched_domain' declared insid=
e parameter list [enabled by default]
kernel/sched/sched.h:1043:39: warning: its scope is only this definition or=
 declaration, which is probably not what you want [enabled by default]
In file included from kernel/sched/fair.c:35:0:
kernel/sched/sched.h:1043:39: warning: 'struct sched_domain' declared insid=
e parameter list [enabled by default]
kernel/sched/sched.h:1043:39: warning: its scope is only this definition or=
 declaration, which is probably not what you want [enabled by default]
In file included from kernel/sched/stop_task.c:1:0:
kernel/sched/sched.h:1043:39: warning: 'struct sched_domain' declared insid=
e parameter list [enabled by default]
kernel/sched/sched.h:1043:39: warning: its scope is only this definition or=
 declaration, which is probably not what you want [enabled by default]
In file included from kernel/sched/rt.c:6:0:
kernel/sched/sched.h:1043:39: warning: 'struct sched_domain' declared insid=
e parameter list [enabled by default]
kernel/sched/sched.h:1043:39: warning: its scope is only this definition or=
 declaration, which is probably not what you want [enabled by default]

Probably caused by commit c82ba9fa7588 ("sched: Move struct sched_class
to kernel/sched/sched.h") from the tip tree which removed a forward
declaration of "struct sched_domain" from include/linux/sched.h - the
read declaration is protected by CONFIG_SMP (which is not set for this
build).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__12_Mar_2013_15_42_15_+1100_K0V+qjiLHbzf9wyh
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRPrInAAoJEECxmPOUX5FENaQP/iIoo5CqMVvdM8dV6RSS+R2i
l0T1RG+bd3HdXW2aoo5qUh4y5dz4OJUm7SHTv4QT//AXcvXPXr5CeRAPrXfGzE3A
0uTo33oK2PeJxizB1We7NeJM3xtp/619U3kAO2pEYoIjF7f6khandLwBkB57yfSj
5/RzqGn9mQiezMGtyz6J4IjPKCNa3HYuETZByRol8qSGGxDKcrg4HtIBjcoE0xyl
uPqnMz0d0n34uBH/knF8Aq7om3V5+kL09h/emqkJ2KbLrf0NKDgjVggVs6w5cX2b
suT7g7G4NSaGGkNwlISFiEqGFbLkmUBxVEIj+udAGqVikpTjkqhxGfHj8SbFGMoG
fLYHi35yswj+ZYM5yDw1sxgHHceAweSGzJI+dJJl4eA0rmqYA7t253ZJxihfwYEC
1cHyn8HLrob0ajALieLjvGp11McauDnb6t2rueOUj8xmRe3Q1m0kzGjMyrxl7KdR
bfGYQOXJ3UbwxbQ7mhpR7EHU+DBXYeqtFvFtFBVd0xaDV2WkArsNWKZmdlVhqNg9
iyFbU9Z/RoV4MHQwI98INoUKbjp1JRvKLSJPAUoxQ6cTB40OJKxWiYnKBu6konov
aO2KiIdrfkAunSdHDKTFdp+PnOqHtwLKZVey4qGFqFE4t9n5cItIts+ou/s5nhhR
d+bdwu2H+QowhWjSuQwl
=wV6b
-----END PGP SIGNATURE-----

--Signature=_Tue__12_Mar_2013_15_42_15_+1100_K0V+qjiLHbzf9wyh--
