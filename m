Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752246Ab3CTEni (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 00:43:38 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:38864 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476Ab3CTEnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 00:43:37 -0400
Date: Wed, 20 Mar 2013 15:43:28 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the final tree (cgroup
 tree related)
Message-Id: <20130320154328.4b164061f7a58af5fb3f62e4@canb.auug.org.au>
In-Reply-To: <51401DAB.1070602@huawei.com>
References: <20130313161236.760c25633a4e8ea8d4847ccb@canb.auug.org.au>
	<51401DAB.1070602@huawei.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__20_Mar_2013_15_43_28_+1100_+68QKYI28BeP_5Io"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__20_Mar_2013_15_43_28_+1100_+68QKYI28BeP_5Io
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

On Wed, 13 Mar 2013 14:33:15 +0800 Li Zefan <lizefan@huawei.com> wrote:
>
> On 2013/3/13 13:12, Stephen Rothwell wrote:
> >=20
> > After merging the final tree, today's linux-next build (powerpc
> > allnoconfig) failed like this:
> >=20
> > In file included from include/linux/memcontrol.h:22:0,
> >                  from include/linux/swap.h:8,
> >                  from include/linux/suspend.h:4,
> >                  from arch/powerpc/kernel/asm-offsets.c:24:
> > include/linux/cgroup.h:748:13: warning: 'struct cgroupstats' declared i=
nside parameter list [enabled by default]
> > include/linux/cgroup.h:748:13: warning: its scope is only this definiti=
on or declaration, which is probably not what you want [enabled by default]
> > cc1: all warnings being treated as errors
> >=20
> > and many more similar.
> >=20
> > Caused by commit c2c9ad164fa3 ("cgroup: remove unneeded includes from
> > cgroup.h").
> >=20
>=20
> Tejun has dropped this patch.

It has returned today.  Please be more careful.

In file included from include/linux/memcontrol.h:22:0,
                 from include/linux/swap.h:8,
                 from include/linux/suspend.h:4,
                 from arch/powerpc/kernel/asm-offsets.c:24:
include/linux/cgroup.h:742:13: warning: 'struct cgroupstats' declared insid=
e parameter list [enabled by default]
include/linux/cgroup.h:742:13: warning: its scope is only this definition o=
r declaration, which is probably not what you want [enabled by default]

I have reverted commit c2c9ad164fa3 ("cgroup: remove unneeded includes
from cgroup.h") for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__20_Mar_2013_15_43_28_+1100_+68QKYI28BeP_5Io
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRST5wAAoJEECxmPOUX5FEV4EP/j6pg3IX5WVPhUthkuuepFNV
HyEHyJMM/mKAyNhgHV7w3UeWsIa/H/XTWEuF7lPtERZWBM6AFHVR5i4xLDtYLYKk
rZ9nVLDoOM1sMBrIpUE8nr32mzSyBNHlnjetmyhbJ/2FDMozqxiCH1vIPccB+U5F
uQiP1ydVCAP9AbK00pp8NTRJj+9oKBPk3G0mTP5TYcvBWnEJwFpzFy4hVwoC76Nq
Y+qhFr3hoMDcgz1Xe9D8GNtdNZrcJc1DvsNhvBIYebzP3vkCtzJ+zrRpnSpSXUGq
heceyT0c4g9OFH97/7lZIF0QAmBza7Xp4BLs4IaZasMrIaXOAJ5ZQQhEKXHQJAqm
7F7awLxr0YzpNYZUjKGnLK3okj96gh1s5aIxFKUAAxhY9e9Y/f5By3bMconablye
8StxfNAmd0lgbXg4zUWd5I/AQ2MBTEyQ0sFNyLsFrEIUE/nPa+nRQKVfcTQpufYY
6Yaz0Ym7c2noP5OFbZ8iCj4SURy5YnePKVzbaWf1/TJeMEgZjzHyZw68Zj2uMK8B
Y3nCuCutOrAfomrQXXhbgbrv5030ZGyWawM8Sx52CNdzVyNa/ViDAeine/mfE5Xy
Q7i707l43X+jTDbrgFDv9JGNAhAaC3mGt2yuPGfLyGZuGQZvrbmiIZ1/0eO43J6c
98JxeNRycEv/anzgadxC
=T/6z
-----END PGP SIGNATURE-----

--Signature=_Wed__20_Mar_2013_15_43_28_+1100_+68QKYI28BeP_5Io--
