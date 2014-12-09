Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756648AbaLILml (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 06:42:41 -0500
Received: from ozlabs.org ([103.22.144.67]:37933 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755486AbaLILmk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 06:42:40 -0500
Date: Tue, 9 Dec 2014 22:42:30 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pranith Kumar <bobby.prani@gmail.com>
Subject: linux-next: build failure after merge of the rcu tree
Message-ID: <20141209224230.57f0aa34@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/FMxARFt1PBBC+2c.40kk5kp"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/FMxARFt1PBBC+2c.40kk5kp
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Paul,

After merging the rcu tree, today's linux-next build (powerpc
allnoconfig) failed like this:

include/linux/notifier.h:51:4: warning: its scope is only this definition o=
r declaration, which is probably not what you want
In file included from include/linux/memory_hotplug.h:6:0,
                 from include/linux/mmzone.h:790,
                 from include/linux/gfp.h:5,
                 from arch/powerpc/mm/pgtable.c:25:
include/linux/notifier.h:51:4: error: 'struct notifier_block' declared insi=
de parameter list [-Werror]
    unsigned long action, void *data);
    ^

And many more (most just warnings ...).

Presumably caused by commit 44dec3761b63 ("srcu: Isolate srcu sections
using CONFIG_SRCU") and reverting that commit makes the messages go
away, so I have done that for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/FMxARFt1PBBC+2c.40kk5kp
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUhuAtAAoJEMDTa8Ir7ZwVeFsP/08+3uFMUi+Q6vhnGt3BaWZR
cttpu1M96QgVwySW1o/TNzq0Vr6K8a198h7yTEy36uYJI3dJ2jRqLocHmh2Ci6oS
MZc6c3Ndt7G8Hg1UrmmHjNzkhiVi0E+CZoz89MJ809Cjzq3TTRdFMtfjGe0TCr2m
hMIatqDPQSts0wnZfYgumzXIzVa4BwPA1TyEHqwH1/R8oXZf3hai2z5b63lGUILF
bk4a9kTld6ey1DZDVn0T+OMCCxtQQ9E+6WBSfVT4Z6qDMQXDpBBYKQoNi9JBVupL
1GolB0rYM7Ncf8D3wiwWw8/7YC+BxL8ZH8/0S1Dxdla7e4rH8Z/B9N2FNj/WoJJu
NWzT0p9CVAa3Wj+odi2jCZKfKptlgsh3nxlhACyMKitZNXDQHq1tfWaBEpdINT0o
aX9/xnWXl497Dn8D+geO5qz4YV0Bms8t+SPlLAQu3kazU38r3d8PDd+UPTwH00Vb
9K/dZwm0fuZd8b4JffCMPvkWB8DWN9x3c6FCSCZxiplyR0xsp1vI+a85NxngpQhg
XiOgKCPOaB7iMK1mi5lf98iM7mYYN9U6N9uj04JrtsvfhSIlGtzvpuE2SGwMXvUm
r8P+ldBdS6AUeSchW89d1mnB+aRavee6g6dnRSzkTvkSvFBGgBDm55QZqJkWWzbq
pu3YMTlsZvnkKEYZEUUr
=NSIr
-----END PGP SIGNATURE-----

--Sig_/FMxARFt1PBBC+2c.40kk5kp--
