Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154AbaDCWpT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 18:45:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33375 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753809AbaDCWpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 18:45:13 -0400
Date: Thu, 3 Apr 2014 15:47:35 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.13.9
Message-ID: <20140403224735.GA13987@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DocE+STaALJfprDB"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DocE+STaALJfprDB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.13.9 kernel.

All users of the 3.13 kernel series must upgrade.

The updated 3.13.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.13.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Makefile                                |    2=20
 arch/x86/include/asm/pgtable.h          |   14 --
 arch/x86/include/asm/topology.h         |    3=20
 arch/x86/xen/mmu.c                      |    4=20
 drivers/block/aoe/aoecmd.c              |    4=20
 drivers/gpu/drm/i915/i915_gem_gtt.c     |    2=20
 drivers/i2c/busses/i2c-cpm.c            |    2=20
 drivers/input/mouse/cypress_ps2.c       |    1=20
 drivers/input/mouse/synaptics.c         |   55 +++++++++
 drivers/input/mousedev.c                |   73 +++++++------
 drivers/net/ethernet/marvell/mvneta.c   |   43 +------
 drivers/vfio/vfio_iommu_type1.c         |    4=20
 drivers/xen/balloon.c                   |   24 +++-
 fs/dcache.c                             |    4=20
 fs/ext4/inode.c                         |   15 +-
 fs/mount.h                              |    4=20
 fs/namei.c                              |   29 ++---
 fs/namespace.c                          |  177 ++++++++++++++++++++-------=
-----
 fs/pnode.c                              |   26 ++--
 fs/pnode.h                              |    4=20
 fs/proc/page.c                          |    2=20
 include/linux/bitops.h                  |   15 ++
 include/linux/cgroup.h                  |    2=20
 include/linux/huge_mm.h                 |   18 ---
 include/linux/mm.h                      |   14 ++
 kernel/cgroup.c                         |   26 ++--
 lib/random32.c                          |   13 ++
 mm/ksm.c                                |    2=20
 mm/memory-failure.c                     |    2=20
 mm/page_alloc.c                         |    4=20
 mm/swap.c                               |    4=20
 net/netfilter/nf_conntrack_proto_dccp.c |    6 -
 32 files changed, 361 insertions(+), 237 deletions(-)

Al Viro (6):
      rcuwalk: recheck mount_lock after mountpoint crossing attempts
      make prepend_name() work correctly when called with negative *buflen
      resizable namespace.c hashes
      keep shadowed vfsmounts together
      don't bother with propagate_mnt() unless the target is shared
      switch mnt_hash to hlist

Artem Fetishev (1):
      x86: fix boot on uniprocessor systems

Benjamin Tissoires (1):
      Input: synaptics - add manual min/max quirk

Daniel Borkmann (1):
      netfilter: nf_conntrack_dccp: fix skb_header_pointer API usages

Daniel Vetter (1):
      drm/i915: Undo gtt scratch pte unmapping again

David Rientjes (1):
      mm: close PageTail race

David Vrabel (1):
      Revert "xen: properly account for _PAGE_NUMA during xen pte translati=
ons"

Dmitry Torokhov (1):
      Input: mousedev - fix race when creating mixed device

Greg Kroah-Hartman (1):
      Linux 3.13.9

Hans de Goede (2):
      Input: synaptics - add manual min/max quirk for ThinkPad X240
      Input: cypress_ps2 - don't report as a button pads

Li Zefan (1):
      cgroup: protect modifications to cgroup_idr with cgroup_mutex

Sasha Levin (1):
      random32: avoid attempt to late reseed if in the middle of seeding

Scott Wood (1):
      i2c: cpm: Fix build by adding of_address.h and of_irq.h

Theodore Ts'o (1):
      ext4: atomically set inode->i_flags in ext4_set_inode_flags()

Thomas Petazzoni (2):
      net: mvneta: rename MVNETA_GMAC2_PSC_ENABLE to MVNETA_GMAC2_PCS_ENABLE
      net: mvneta: fix usage as a module on RGMII configurations

Wei Liu (1):
      xen/balloon: flush persistent kmaps in correct position


--DocE+STaALJfprDB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTPeUHAAoJEDjbvchgkmk+5ycQALDILL0VmGJECqLNgA6Dq/0z
YVNGgvWO9+VjB4MO2FlBavhmfMY3vQ0ed8U2fpSZDf4IUmyqUKluhsHI+yu534Oa
YkUjo9Mm5XbP0y6zCmLVFga2OhBy+XUYL8r2QlqV7tCb2RSB5VwcCuqRfdqG/1lv
drV5pNYGupBONWz6+EYmMe8D0bwJ0Uv3+AbzQZ6QFfwYImClOC27xSfoBLExJXQ2
INYGdHjElXYBOGpynOE3NY2xP+qEFr/x4yerf88DL/EE8P19fAKbUPcWCP3IRIjo
JcIbzVSb61jXRLOrJ3fxZyyyis01LDobr5RHT7AKAICFVXeC4p4l23FNg/5feKFm
piob/pY+77KzA6dDiZs+Tcxsuu50aeBYF5CVm397FzsmEnph0JOpkDbaKsbub801
ZDMufb1zdSjkFI8r4QpJXRUZzpPKARVbNfj7kH40td38gnUePT6xqwokfUefO+wv
gZw7nn/pz/cfelkAZ/sycWqUvDPVjEru+bcroacY+8Grotu61TSesM5ga55un8yC
aHqb5+bxSXDCXTwJVWtiG/5WAtXSbak0UBneOED5VYnpK0i9B3QatRNfqVw0pV7+
+dC2nCQUJwuyyUBXsGnYXC/fb9NS1glgzaTb3fONMvDx949IfbHt96oBr5MAcs6e
ATPey5M+KJ7J0d659RQ7
=rYM/
-----END PGP SIGNATURE-----

--DocE+STaALJfprDB--
