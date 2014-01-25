Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628AbaAYRvc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 12:51:32 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:50430 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492AbaAYRv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 12:51:29 -0500
Date: Sat, 25 Jan 2014 09:52:28 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.12.9
Message-ID: <20140125175228.GA5336@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vtzGhvizbBRQ85DL"
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vtzGhvizbBRQ85DL
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.12.9 kernel.

All users of the 3.12 kernel series must upgrade.

The updated 3.12.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.12.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Makefile                                        |    2=20
 arch/arm/kernel/devtree.c                       |    2=20
 arch/arm/mach-highbank/highbank.c               |    1=20
 arch/arm/mach-omap2/omap4-common.c              |    1=20
 arch/x86/kernel/cpu/perf_event_amd_ibs.c        |   53 +++++++++++++++++++=
+----
 arch/x86/kernel/entry_32.S                      |    4 -
 arch/x86/kernel/entry_64.S                      |    2=20
 drivers/acpi/acpi_lpss.c                        |    1=20
 drivers/gpu/drm/i915/intel_ddi.c                |    8 +++
 drivers/gpu/drm/i915/intel_display.c            |    4 -
 drivers/hwmon/coretemp.c                        |    2=20
 drivers/md/md.c                                 |   18 ++++++--
 drivers/md/md.h                                 |    3 +
 drivers/md/raid10.c                             |   12 ++---
 drivers/md/raid5.c                              |    4 -
 drivers/pinctrl/pinctrl-baytrail.c              |    1=20
 drivers/staging/comedi/drivers/addi_apci_1032.c |    4 -
 drivers/staging/comedi/drivers/adl_pci9111.c    |    2=20
 drivers/tty/serial/amba-pl011.c                 |    6 ++
 fs/dcache.c                                     |    7 ++-
 fs/fs-writeback.c                               |   15 ++++--
 fs/gfs2/inode.c                                 |   16 ++++++-
 fs/namespace.c                                  |    2=20
 fs/nilfs2/segment.c                             |   10 ++--
 include/linux/crash_dump.h                      |    2=20
 include/linux/i2c.h                             |    2=20
 include/linux/mm.h                              |   13 +++--
 kernel/fork.c                                   |    2=20
 mm/huge_memory.c                                |    6 +-
 mm/util.c                                       |    5 +-
 security/selinux/hooks.c                        |   20 ++++++++-
 security/selinux/include/objsec.h               |    5 +-
 32 files changed, 175 insertions(+), 60 deletions(-)

Andreas Rohner (1):
      nilfs2: fix segctor bug that causes file system corruption

Bob Peterson (1):
      GFS2: Increase i_writecount during gfs2_setattr_chown

Eric W. Biederman (3):
      vfs: In d_path don't call d_dname on a mount point
      vfs: Fix a regression in mounting proc
      fork: Allow CLONE_PARENT after setns(CLONE_NEWPID)

Geert Uytterhoeven (1):
      mm: Make {,set}page_address() static inline if WANT_PAGE_VIRTUAL

Greg Kroah-Hartman (1):
      Linux 3.12.9

H Hartley Sweeten (2):
      staging: comedi: addi_apci_1032: fix subdevice type/flags bug
      staging: comedi: adl_pci9111: fix incorrect irq passed to request_irq=
()

Hugh Dickins (1):
      thp: fix copy_page_rep GPF by testing is_huge_zero_pmd once only

Jan Kara (1):
      writeback: Fix data corruption on NFS

Jean Delvare (1):
      hwmon: (coretemp) Fix truncated name of alarm attributes

Jon Medhurst (1):
      serial: amba-pl011: use port lock to guard control register access

Mikulas Patocka (1):
      mm: fix crash when using XFS on loopback

NeilBrown (4):
      md: fix problem when adding device to read-only array with bitmap.
      md/raid10: fix bug when raid10 recovery fails to recover a block.
      md/raid10: fix two bugs in handling of known-bad-blocks.
      md/raid5: Fix possible confusion when multiple write errors occur.

Paulo Zanoni (1):
      drm/i915: fix DDI PLLs HW state readout code

Qais Yousef (1):
      crash_dump: fix compilation error (on MIPS at least)

Rafael J. Wysocki (1):
      Revert "ACPI: Add BayTrail SoC GPIO and LPSS ACPI IDs"

Robert Richter (1):
      perf/x86/amd/ibs: Fix waking up from S3 for AMD family 10h

Stephen Warren (1):
      i2c: Re-instate body of i2c_parent_is_i2c_adapter()

Steven Rostedt (2):
      SELinux: Fix possible NULL pointer dereference in selinux_inode_permi=
ssion()
      ftrace/x86: Load ftrace_ops in parameter not the variable holding it

Sudeep Holla (1):
      ARM: 7934/1: DT/kernel: fix arch_match_cpu_phys_id to avoid erroneous=
 match

Taras Kondratiuk (1):
      ARM: 7938/1: OMAP4/highbank: Flush L2 cache before disabling

Ville Syrj=E4l=E4 (1):
      drm/i915: Don't grab crtc mutexes in intel_modeset_gem_init()


--vtzGhvizbBRQ85DL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS4/ncAAoJEDjbvchgkmk+RRgP/0rxiLxtWWxcp1kLkAspuzX+
wx7gVxSrm3Ysk8SKxgXUBZFyX1Hncj0ZGhNYIaPxBtyRt2qDK5XNcrXzMSluz3ZY
O4n00L/tHFcXz9U1q1Otg3k1xaCuJNX0lLPNRd/AaKExtF5JLb6kADwwFig8eXQ+
bbYkDBP+XwauuL4bYQGY8wM4DVvHfw9sD9BEqD3YqG0JtKh2+Od6yWHcbbaf9fMK
wZyt0ZozPuyOYyDB0Q2ZbolSOs8FjaF0v4DoHRMn9pH8kkBOywyKqRxJ7tgQbPxQ
Nwr43XuldfpgiMQIX9ImtLRem+JW4DrscgK/HF+fycJQHEcR2yRNsRRBnK8otzva
EQPt+iJIGsH3NCzu5SOztrw52fnNwQ6wtZs/e6iDsKQIprulKUJfXjqfrSpoV1Mc
6vcZ1pDJ43Uzy+apT+mdwS80jhOa5g2C/Ix8W+WBjOpugDEvGmfSWfV9JHcg/3m3
U9knWHvYNd0uzjmIrr0x2mF2qNYlsRTzhVOmfueSt4WpSXtwG8fvJx9uYrmH00zg
RYUDRUKlbn4nuHwTJHhJDwsxvNlKS7QnRYzgQV1I3JwGvKcIsFq5MZeOwoThPI5b
Jrsn3teIbQA6LKPTbPOy/9gHK3AoS/dkwQjDsL0Ef4l2jReuJMPdcVrGmYHfn1SE
0nVS1ypUKLi592UGqHck
=xKYg
-----END PGP SIGNATURE-----

--vtzGhvizbBRQ85DL--
