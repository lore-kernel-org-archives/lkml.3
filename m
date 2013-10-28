Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893Ab3J1KSa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 06:18:30 -0400
Received: from mail-bk0-f54.google.com ([209.85.214.54]:64854 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754529Ab3J1KS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 06:18:29 -0400
Date: Mon, 28 Oct 2013 11:18:24 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the tip tree
Message-ID: <20131028101823.GA3512@ulmo.nvidia.com>
References: <20131028202442.5033ddf42639863d5f1dcf67@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="h31gzZEtNLTqOjlF"
Content-Disposition: inline
In-Reply-To: <20131028202442.5033ddf42639863d5f1dcf67@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--h31gzZEtNLTqOjlF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 28, 2013 at 08:24:42PM +1100, Stephen Rothwell wrote:
> Hi all,
>=20
> After merging the tip tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
>=20
> In file included from /scratch/sfr/next/include/linux/mmzone.h:9:0,
>                  from /scratch/sfr/next/include/linux/gfp.h:4,
>                  from /scratch/sfr/next/include/linux/kmod.h:22,
>                  from /scratch/sfr/next/include/linux/module.h:13,
>                  from /scratch/sfr/next/block/blk-mq.c:2:
> /scratch/sfr/next/block/blk-mq.c: In function 'blk_mq_queue_enter':
> /scratch/sfr/next/include/linux/wait.h:772:2: error: expected ';' before =
'__ret'
>   __ret;        \
>   ^
> /scratch/sfr/next/block/blk-mq.c:108:8: note: in expansion of macro 'wait=
_event_interruptible_lock_irq'
>   ret =3D wait_event_interruptible_lock_irq(q->mq_freeze_wq,
>         ^
> /scratch/sfr/next/block/blk-mq.c:108:6: error: void value not ignored as =
it ought to be
>   ret =3D wait_event_interruptible_lock_irq(q->mq_freeze_wq,
>       ^
>=20
> Caused by commit 35a2af94c7ce ("sched/wait: Make the __wait_event*()
> interface more friendly").
>=20
> Since this was also in next-20131025, I applied the following merge fix
> commit for today, please fix this in the tip tree.

FWIW I got confirmation on Oct 23 that this had been committed to the
tip tree. So I guess it just wasn't pushed yet.

Thierry

--h31gzZEtNLTqOjlF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSbjnvAAoJEN0jrNd/PrOhxpIQAJzfnfOQm3Ju7xzeyWJTlYDD
IKUiAOM7Q8UJu3lt2R8MZSMu87QKGpUzC4q4f5qVn9U4n+KWAgbNT5qAN71riTnb
6C6FNrw2bg4kExXtRJZzmtJ9JslYWpX4Zoj5hkBCfJjIHYsC0BoipHeplfarBJGa
j4DgDBtsICEcNb5lXUjz9lJLtHj0FVJNyB014dGe97z+OyHPOMN9KWXoncK2liPs
OpEPmAwVabj3OfhFviK2l6x7F4yKsIEf9FJBgXSpf+re3ATjEMJXlq6Z8WZklkJE
ZyExwsHQtBHHiT5eZHVm/e34Nymon0Yj+sM/KjKkyJoCkJdXLQ8Yd9S7n2qB40BM
pTCjnavzNqy1JQy96+OzNf1sAfVgFAC9SJMHnAn3+gvmvpmJiN+uwokU6cnU4p+g
6nA5EhmVDVjcE2xQo/d0X8hYToYZXBD+Ys0AApVM2l/VrXXysFRDUDtiuy+s3umE
PQ1+Tv7hDYCjuoVvc2lYAHD9n5s0cQ3TyO0jqvNbdaofZO7aUB+DAEpzR6TPiIbG
cLprIb1d35EasSQFSo7nwDyWcEQOCQDUl+5pL9CU4ff9BMhS46Pe4lQzuBpaOVPK
PeaMtetE0eyHotB0Uql91CHJDk348rFNpn4ybR9QXQh56SpK3ONLxkKe8dr2+tAQ
wG1kfOCrTVi0al9+m2Ta
=wVXk
-----END PGP SIGNATURE-----

--h31gzZEtNLTqOjlF--
