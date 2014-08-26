Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757327AbaHZHWU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 03:22:20 -0400
Received: from ozlabs.org ([103.22.144.67]:46778 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755535AbaHZHWT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 03:22:19 -0400
Date: Tue, 26 Aug 2014 17:22:08 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xishi Qiu <qiuxishi@huawei.com>
Subject: linux-next: build warnings after merge of the akpm-current tree
Message-ID: <20140826172208.1dbc37db@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/ITFg8dzlG6xLYXX=P+6RpQO"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/ITFg8dzlG6xLYXX=P+6RpQO
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

After merging the akpm-current tree, today's linux-next build (arm
defconfig) produced these warnings:

In file included from /scratch/sfr/next/include/asm-generic/bug.h:13:0,
                 from /scratch/sfr/next/arch/arm/include/asm/bug.h:61,
                 from /scratch/sfr/next/include/linux/bug.h:4,
                 from /scratch/sfr/next/include/linux/thread_info.h:11,
                 from /scratch/sfr/next/include/asm-generic/preempt.h:4,
                 from arch/arm/include/generated/asm/preempt.h:1,
                 from /scratch/sfr/next/include/linux/preempt.h:18,
                 from /scratch/sfr/next/include/linux/spinlock.h:50,
                 from /scratch/sfr/next/include/linux/mmzone.h:7,
                 from /scratch/sfr/next/include/linux/gfp.h:5,
                 from /scratch/sfr/next/include/linux/slab.h:14,
                 from /scratch/sfr/next/mm/nobootmem.c:13:
/scratch/sfr/next/mm/nobootmem.c: In function 'free_low_memory_core_early':
/scratch/sfr/next/include/linux/kernel.h:29:20: warning: large integer impl=
icitly truncated to unsigned type [-Woverflow]
 #define ULLONG_MAX (~0ULL)
                    ^
/scratch/sfr/next/mm/nobootmem.c:122:28: note: in expansion of macro 'ULLON=
G_MAX'
  memblock_clear_hotplug(0, ULLONG_MAX);
                            ^

Introduced by commit 6e162b4c49f7 ("mem-hotplug: let memblock skip the
hotpluggable memory regions in __next_mem_range()").  The second
argument to memblock_clear_hotplug() is a phys_addr_t, which varies in
size between architectures/platforms.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/ITFg8dzlG6xLYXX=P+6RpQO
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT/DWoAAoJEMDTa8Ir7ZwVX20P/3+oUj3I3jL4TPUoiX2YEZnM
79sC0OHhsjD33KQusspYcCA1htjNhehK6tyT5czZ4HVhJjR5IYdW1gFMELtlgkMt
F60J/WR94HJo9Z474XhRIfWBLrH5cjgIcXI3UcMPCZaRRRsxUyeAEbMuyuQGX+tO
ONKHnVREEiSpEnRFGqdynUAHZK/vK69MFN4jyxP29oZJ0ZfZ0epBDNHTK69GRBSM
ddzODw23/4JwAYIK3NYlPhrAb8EEPx6opNmNI0U5jPKPTyaKJcABWjqvQPgUJrX/
VTAF3KT4o4ZL6ARHtTPz/qmfDPBGdoh1RrenrMDy5FQ3qCSNJvznS8RLWryu8gP4
uWOqOl7eQljQxWZBh9vyw922Pbk/1H8f0NLshsPMNGwp9o357UTylPzKOzmjWo3l
RCaSBhoNnm9tv81+EyENtjjEzjvNVzNKuVlT4DAI9Nd8o2VjTAzuQhvs64i4fX8k
WjhJC37vDlTEKiKjH9KjgofY+axQ8ZN6T7eLt3uxPo3qnl1ksDmSNOx8B198yuBt
kfIdBC7FK0FoJCLl5K/bKP8jWm125fzz8fkWkMabPMguUUq2ET3GuGB08zlLfDSw
Mt377AGN2tm3Q0Eg0yCHpOXpCBKr7CFcpdZBWGvd7FieeNuQPRnoeZFLZMpFUj2F
hgoCoDaQGyZk7LE3Byw3
=TtnT
-----END PGP SIGNATURE-----

--Sig_/ITFg8dzlG6xLYXX=P+6RpQO--
