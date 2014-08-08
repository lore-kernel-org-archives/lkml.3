Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965AbaHHCVC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 22:21:02 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50106 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755238AbaHHCU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 22:20:58 -0400
Date: Thu, 7 Aug 2014 19:20:57 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.14.16
Message-ID: <20140808022057.GA797@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Kj7319i9nmIyA2yE"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Kj7319i9nmIyA2yE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.14.16 kernel.

All users of the 3.14 kernel series must upgrade.

The updated 3.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.14.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Documentation/x86/x86_64/mm.txt         |    2=20
 Makefile                                |    2=20
 arch/arm/boot/dts/dra7-evm.dts          |    1=20
 arch/arm/boot/dts/hi3620.dtsi           |    2=20
 arch/arm/crypto/aesbs-glue.c            |   10 -
 arch/arm/mm/idmap.c                     |    7 +
 arch/arm/mm/mmu.c                       |    6=20
 arch/x86/Kconfig                        |   25 +++
 arch/x86/include/asm/espfix.h           |   16 ++
 arch/x86/include/asm/irqflags.h         |    2=20
 arch/x86/include/asm/pgtable_64_types.h |    2=20
 arch/x86/include/asm/setup.h            |    2=20
 arch/x86/kernel/Makefile                |    1=20
 arch/x86/kernel/entry_32.S              |   12 +
 arch/x86/kernel/entry_64.S              |   77 ++++++++++-
 arch/x86/kernel/espfix_64.c             |  208 +++++++++++++++++++++++++++=
+++++
 arch/x86/kernel/ldt.c                   |   10 -
 arch/x86/kernel/paravirt_patch_64.c     |    2=20
 arch/x86/kernel/smpboot.c               |    7 +
 arch/x86/mm/dump_pagetables.c           |   31 +++-
 arch/x86/vdso/vdso32-setup.c            |    8 -
 arch/x86/xen/setup.c                    |    9 -
 arch/xtensa/kernel/vectors.S            |  158 ++++++++++++++++++++----
 arch/xtensa/kernel/vmlinux.lds.S        |    4=20
 crypto/af_alg.c                         |    2=20
 drivers/cpufreq/cpufreq.c               |    6=20
 drivers/iio/accel/bma180.c              |    8 -
 drivers/iio/industrialio-buffer.c       |    2=20
 drivers/md/dm-bufio.c                   |    2=20
 drivers/md/dm-cache-target.c            |   13 --
 drivers/net/wireless/ath/ath9k/xmit.c   |    9 +
 drivers/pnp/pnpacpi/core.c              |    3=20
 drivers/rapidio/devices/tsi721_dma.c    |    8 +
 drivers/scsi/scsi_lib.c                 |    8 +
 drivers/staging/vt6655/bssdb.c          |    2=20
 drivers/staging/vt6655/device_main.c    |    7 -
 include/dt-bindings/pinctrl/dra.h       |    7 -
 include/linux/printk.h                  |    6=20
 init/main.c                             |    4=20
 kernel/printk/printk.c                  |    2=20
 kernel/sched/core.c                     |    2=20
 kernel/sched/deadline.c                 |    2=20
 kernel/sched/rt.c                       |    2=20
 kernel/time/clockevents.c               |   10 -
 kernel/time/sched_clock.c               |    4=20
 lib/btree.c                             |    1=20
 mm/memcontrol.c                         |    4=20
 mm/page-writeback.c                     |    6=20
 mm/page_alloc.c                         |   16 +-
 net/l2tp/l2tp_ppp.c                     |    4=20
 net/mac80211/tx.c                       |   27 ++--
 net/wireless/trace.h                    |    3=20
 52 files changed, 628 insertions(+), 146 deletions(-)

Alexandre Bounine (1):
      rapidio/tsi721_dma: fix failure to obtain transaction descriptor

Andy Lutomirski (1):
      x86_64/entry/xen: Do not invoke espfix64 on Xen

Anssi Hannula (1):
      dm cache: fix race affecting dirty block count

Boris Ostrovsky (1):
      x86/espfix/xen: Fix allocation of pages for paravirt page tables

David Rientjes (1):
      mm, thp: do not allow thp faults to avoid cpuset restrictions

David Vrabel (1):
      x86/xen: no need to explicitly register an NMI callback

Eliad Peller (1):
      cfg80211: fix mic_failure tracing

Felix Fietkau (1):
      ath9k: fix aggregation session lockup

Greg Kroah-Hartman (1):
      Linux 3.14.16

Greg Thelen (1):
      dm bufio: fully initialize shrinker

H. Peter Anvin (6):
      Revert "x86-64, modify_ldt: Make support for 16-bit segments a runtim=
e option"
      x86-64, espfix: Don't leak bits 31:16 of %esp returning to 16-bit sta=
ck
      x86, espfix: Move espfix definitions into a separate header file
      x86, espfix: Fix broken header guard
      x86, espfix: Make espfix64 a Kconfig option, fix UML
      x86, espfix: Make it possible to disable 16-bit support

Haojian Zhuang (1):
      ARM: dts: fix L2 address in Hi3620

James Bottomley (1):
      scsi: handle flush errors properly

Jan Kara (1):
      timer: Fix lock inversion between hrtimer_bases.lock and scheduler lo=
cks

Johannes Berg (1):
      Revert "mac80211: move "bufferable MMPDU" check to fix AP mode scan"

John Stultz (1):
      printk: rename printk_sched to printk_deferred

Konstantin Khlebnikov (1):
      ARM: 8115/1: LPAE: reduce damage caused by idmap to virtual memory la=
yout

Lars-Peter Clausen (1):
      iio: buffer: Fix demux table creation

Malcolm Priestley (2):
      staging: vt6655: Fix disassociated messages every 10 seconds
      staging: vt6655: Fix Warning on boot handle_irq_event_percpu.

Max Filippov (1):
      xtensa: add fixup for double exception raised in window overflow

Maxim Patlasov (1):
      mm/page-writeback.c: fix divide by zero in bdi_dirty_limits()

Michal Hocko (1):
      memcg: oom_notify use-after-free fix

Mikulas Patocka (1):
      crypto: arm-aes - fix encryption of unaligned data

Milan Broz (1):
      crypto: af_alg - properly label AF_ALG socket

Minfei Huang (1):
      lib/btree.c: fix leak of whole btree nodes

Nishanth Menon (1):
      pinctrl: dra: dt-bindings: Fix pull enable/disable

Peter Meerwald (2):
      iio:bma180: Fix scale factors to report correct acceleration units
      iio:bma180: Missing check for frequency fractional part

Rafael J. Wysocki (1):
      ACPI / PNP: Fix acpi_pnp_match()

Roger Quadros (1):
      ARM: dts: dra7-evm: Make VDDA_1V8_PHY supply always on

Russell King (1):
      ARM: fix alignment of keystone page table fixup

Sasha Levin (1):
      net/l2tp: don't fall back on UDP [get|set]sockopt

Stephen Boyd (1):
      sched_clock: Avoid corrupting hrtimer tree during suspend

Viresh Kumar (1):
      cpufreq: move policy kobj to policy->cpu at resume


--Kj7319i9nmIyA2yE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT5DQJAAoJEDjbvchgkmk+e5cQAJagU9d3PvZQSa+qEewbaDGx
8ouzUWTNo0m4N0kCJGvOO62mDnIchEeHpKu8EFzusXOCF9UP2bEpwAmSNF+TCDlV
x0otc7t8NbgT8xuVKRTpL2XfNW6DtzpvQSzalu0YUNnYyKa2l34E9FaBbZGPqEGw
DR2HSDbUWD6Ig/fD8he94C4gCDTyQ1dyX5iQZKC56+okqR6nhug4kuozYhcm4j9f
nvwsaQnS07huJG/KfZnjUVUhMJrWN5bffMpZL7goP5HCoP88PTOvUaLDlTFFfveN
KaUhPZvg31RG+5aq379Oev09H7k/p320ZbXX+a0Pz/9z70h3hVCIxcGWYPC2RdsV
cNKxsYDh/t0gTvmmCOSXzr+15VqkCi9evpTx6CwjTWUX7G5oOeLUnu0vL+iMrW9x
NR431nUsRjhmtMpt7ueNj2emXSS6z3WfKzxApev4nZFhpkR+N4eGPmzK8oSROfmb
qt4+xYpDSYkTo8mLSOD72YcvGc03i9b3OLQBTEAFoyI9rynKN8NVhKPgg457MmAH
bRIjc8OZhBCHJi2BSz1sIX9dhN//IxSsTeXqEsijGuIve1DU+9sx+LsWD8zSrtsE
ZR+wYXPt8ywfiW8BodPh88u/p/S3fzQ7XUMwxDER1xrf7MX8He8yOKAMGt/yjIRC
tFwkJl3LkpkpuNM3VbiC
=EjtJ
-----END PGP SIGNATURE-----

--Kj7319i9nmIyA2yE--
