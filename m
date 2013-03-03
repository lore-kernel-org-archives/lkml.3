Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786Ab3CCXqT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 18:46:19 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:36912 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753217Ab3CCXqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 18:46:18 -0500
Date: Mon, 4 Mar 2013 10:46:05 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: consider tidying up the xen-two tree
Message-Id: <20130304104605.7878c0c7f3d0ba795c9e7384@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__4_Mar_2013_10_46_05_+1100_sxBH5ZEj5KTpQKVz"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__4_Mar_2013_10_46_05_+1100_sxBH5ZEj5KTpQKVz
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Konrad,

We are at the end of the merge window and the xen-two tree still looks
like this:

 arch/x86/include/asm/xen/interface.h |  11 ++-
 arch/x86/include/asm/xen/page.h      |   3 +
 arch/x86/pci/xen.c                   |   9 ++
 arch/x86/xen/Kconfig                 |   8 ++
 arch/x86/xen/enlighten.c             |  76 ++++++++++++-----
 arch/x86/xen/irq.c                   |   5 +-
 arch/x86/xen/mmu.c                   | 159 +++++++++++++++++++++++++++++++=
+---
 arch/x86/xen/mmu.h                   |   2 +
 arch/x86/xen/p2m.c                   |   2 +-
 arch/x86/xen/setup.c                 |  59 ++++++++++---
 arch/x86/xen/smp.c                   |  39 ++++++---
 arch/x86/xen/xen-head.S              |  10 ++-
 drivers/net/xen-netback/netback.c    |  11 ++-
 drivers/xen/balloon.c                |  14 +--
 drivers/xen/cpu_hotplug.c            |   4 +-
 drivers/xen/events.c                 |   9 +-
 drivers/xen/gntdev.c                 |   3 +-
 drivers/xen/grant-table.c            | 115 +++++++++++++------------
 drivers/xen/privcmd.c                |   2 +-
 drivers/xen/xenbus/xenbus_client.c   |   9 +-
 include/xen/grant_table.h            |  12 ---
 21 files changed, 422 insertions(+), 140 deletions(-)

Some of this is from commits going back to December 2011.  And there
are several duplicate commits (with reversions of old versions) as well
as many merges.

I assume that what is left in there is now v3.10 material (or
bug/regression fixes), so maybe you should take the opportunity and
rebase the whole lot onto v3.9-rc1 when that is released.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__4_Mar_2013_10_46_05_+1100_sxBH5ZEj5KTpQKVz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRM+C9AAoJEECxmPOUX5FEM9wP/ixtFpH7GksLiNmwd0SmEoym
rlL8fmqLf4HgFHzjuspJRrvwUQbaGA1/h8MnaEBRfgbM2feDuh9m5m4Lbl2bvAz4
5aDrtYNeolk7ejWXWkHV+opsXYJutY9NWmPACTZITf/RaGQNwNE7wO/p9QdQnXoH
MTy+bNPI9WofBEkKlQIPxW8vztkzdZBGPnSrgOiXeScSUx1gC6JhpByzqmJLqIIx
JZOcsjs2hS1C9g+eKIltE57+SOL3QoINmyL7o7NAkReUpoi98ybWvA0wBhDvEPjG
PH/ag9BMJgs8r0YJXsimwRT7TGSh+c9JaD3PtV2HYXbL74XqXfL12YfKwD9J5I1u
Cvgxen24gJeh84ffEpI8dLW3ifUnvuFRl/YHN0mrNg4UuYGjmmefOHvlBfaAN09G
Zx9wpMedL5o5hQ46woZ0yatnCGka8Wc4vorxIcG4lCnmlXu3QyN/wsWqDdLGYYdt
qpGpTiQqBEwC6KaNB/DDmrLHqkyeqRPokBNslccnKr5i/GK8yollS5SZVfWrDMlv
QdgkZuKxk2tR6fyPiJwBN84icNlogqXau6PGd6llV+6cgorpCIPJO7L5GTL+pcYV
H4edkfpl7CBiFWKeM4rwYefeycBPky/S3QwcQxKY4+8qutKk8SVdSrmwDqxQa+dI
PI0zAMa4ChUJ2VCWemT/
=a5et
-----END PGP SIGNATURE-----

--Signature=_Mon__4_Mar_2013_10_46_05_+1100_sxBH5ZEj5KTpQKVz--
