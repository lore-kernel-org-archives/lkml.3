Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754444AbaHGBFH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 21:05:07 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36559 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754158AbaHGBFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 21:05:00 -0400
Message-ID: <1407373482.2416.1.camel@deadeye.wl.decadent.org.uk>
Subject: Linux 3.2.62
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, Jiri Slaby <jslaby@suse.cz>,
        stable@vger.kernel.org
Cc: lwn@lwn.net
Date: Thu, 07 Aug 2014 02:04:42 +0100
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-qYPgyrRhLFN9kiOoilNk"
X-Mailer: Evolution 3.12.2-1+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-qYPgyrRhLFN9kiOoilNk
Content-Type: multipart/mixed; boundary="=-nXWv+QdUu+vuaUfRk/E6"


--=-nXWv+QdUu+vuaUfRk/E6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.2.62 kernel.

All users of the 3.2 kernel series should upgrade.

The updated 3.2.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.2.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git

The diff from 3.2.61 is attached to this message.

Ben.

------------

 Makefile                                    |   2 +-
 arch/alpha/include/asm/io.h                 |   5 +
 arch/arm/Kconfig                            |   1 +
 arch/arm/lib/memset.S                       | 100 +++++++++----------
 arch/arm/mach-omap2/mux.c                   |   6 +-
 arch/powerpc/Kconfig                        |   1 +
 arch/s390/kernel/ptrace.c                   |   9 +-
 arch/score/Kconfig                          |   3 +
 arch/score/include/asm/io.h                 |   1 -
 arch/score/include/asm/pgalloc.h            |   2 +-
 arch/score/kernel/entry.S                   |   4 +-
 arch/score/kernel/init_task.c               |   1 +
 arch/score/kernel/vmlinux.lds.S             |   1 +
 arch/score/mm/init.c                        |   1 +
 arch/sparc/Kconfig                          |   1 +
 arch/unicore32/Kconfig                      |   1 +
 arch/unicore32/include/asm/io.h             |   1 +
 arch/x86/Kconfig                            |   1 +
 arch/x86/include/asm/kvm_host.h             |   4 +-
 arch/x86/kernel/cpu/perf_event_intel.c      |   9 ++
 arch/x86/kernel/entry_32.S                  |  14 +--
 arch/x86/mm/ioremap.c                       |  26 +++--
 crypto/testmgr.h                            |  38 +++----
 drivers/acpi/battery.c                      |  27 ++++-
 drivers/acpi/ec.c                           | 148 ++++++++++++++----------=
----
 drivers/ata/libata-core.c                   |  12 ++-
 drivers/char/applicom.c                     |   1 -
 drivers/gpu/drm/radeon/atombios_dp.c        |   2 +-
 drivers/gpu/drm/radeon/radeon_display.c     |   5 +
 drivers/gpu/drm/vmwgfx/vmwgfx_fb.c          |   1 -
 drivers/hwmon/adm1029.c                     |   3 +
 drivers/hwmon/adm1031.c                     |   8 +-
 drivers/hwmon/adt7470.c                     |   6 +-
 drivers/hwmon/amc6821.c                     |   2 +-
 drivers/hwmon/emc2103.c                     |  15 +--
 drivers/iommu/dmar.c                        |  11 ++-
 drivers/iommu/intel-iommu.c                 |  15 +++
 drivers/md/dm-io.c                          |  22 ++---
 drivers/md/md.c                             |  13 +++
 drivers/net/ethernet/intel/igb/igb_main.c   |   2 +
 drivers/net/ethernet/sun/sunvnet.c          |  20 +++-
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c |  13 ---
 drivers/net/wireless/mwifiex/main.c         |   1 +
 drivers/scsi/ibmvscsi/ibmvscsi.c            |   3 +-
 drivers/scsi/ibmvscsi/rpa_vscsi.c           |  10 ++
 drivers/scsi/sd.c                           |   5 +-
 drivers/scsi/sym53c8xx_2/sym_hipd.c         |   4 +
 drivers/usb/core/hub.c                      |  20 ++++
 drivers/usb/gadget/f_fs.c                   |  12 ++-
 drivers/usb/host/xhci-hub.c                 |   5 +-
 drivers/usb/host/xhci-ring.c                |   2 +-
 drivers/usb/host/xhci.c                     |  10 +-
 drivers/usb/serial/cp210x.c                 |   1 +
 drivers/usb/serial/ftdi_sio.c               |  10 +-
 drivers/usb/serial/ftdi_sio_ids.h           |   3 +-
 drivers/usb/serial/option.c                 |  24 +++--
 drivers/usb/storage/scsiglue.c              |   4 +
 drivers/usb/storage/unusual_devs.h          |   7 ++
 drivers/xen/manage.c                        |   5 +-
 fs/ceph/snap.c                              |   2 +-
 fs/ext4/super.c                             |   9 +-
 fs/fuse/dir.c                               |   6 +-
 fs/fuse/inode.c                             |  20 +++-
 fs/jbd2/transaction.c                       |   5 +-
 fs/nfsd/nfs4proc.c                          |   9 --
 fs/nfsd/nfs4xdr.c                           |  13 ++-
 fs/xfs/xfs_alloc.c                          |   3 +-
 include/drm/drm_mem_util.h                  |   4 +-
 include/linux/kernel.h                      |   1 +
 include/linux/libata.h                      |   1 +
 include/linux/math64.h                      |   6 +-
 include/linux/skbuff.h                      |  17 ----
 include/linux/slab.h                        |   2 +-
 include/linux/usb_usual.h                   |   4 +-
 include/scsi/scsi_device.h                  |   1 +
 kernel/Kconfig.locks                        |   6 +-
 kernel/cpuset.c                             |   8 +-
 kernel/sched_debug.c                        |   2 +-
 kernel/time/alarmtimer.c                    |  20 +++-
 kernel/time/tick-sched.c                    |   4 +-
 kernel/trace/trace.c                        |   2 -
 mm/hugetlb.c                                |   1 +
 mm/kmemleak.c                               |   4 +-
 mm/mempolicy.c                              |   2 -
 mm/shmem.c                                  | 139 ++++++++++++++++++++++++=
--
 mm/truncate.c                               |  25 -----
 mm/vmalloc.c                                |  14 ++-
 net/8021q/vlan_core.c                       |   5 +-
 net/appletalk/ddp.c                         |   3 -
 net/core/rtnetlink.c                        |  22 ++++-
 net/dns_resolver/dns_query.c                |   4 +-
 net/ipv4/igmp.c                             |  10 +-
 net/ipv4/ip_forward.c                       |  68 +------------
 net/ipv4/ip_options.c                       |   4 +
 net/ipv4/netfilter/ipt_ULOG.c               |   7 +-
 net/ipv4/tcp_input.c                        |   2 +-
 net/ipv6/ip6_output.c                       |  13 +--
 net/l2tp/l2tp_ppp.c                         |   4 +-
 net/netfilter/ipvs/ip_vs_ctl.c              |   2 +-
 net/sctp/ulpevent.c                         | 122 +++--------------------
 tools/usb/ffs-test.c                        |   4 +-
 101 files changed, 732 insertions(+), 552 deletions(-)

Alan Stern (1):
      usb-storage/SCSI: Add broken_fua blacklist flag

Alex Deucher (2):
      drm/radeon/dp: return -EIO for flags not zero case
      drm/radeon: avoid leaking edid data

Alex Shi (1):
      include/linux/math64.h: add div64_ul()

Amitkumar Karwar (1):
      mwifiex: fix Tx timeout issue

Andras Kovacs (1):
      USB: cp210x: add support for Corsair usb dongle

Andrey Utkin (1):
      appletalk: Fix socket referencing in skb

Axel Lin (2):
      hwmon: (amc6821) Fix permissions for temp2_input
      hwmon: (adm1029) Ensure the fan_div cache is updated in set_fan_div

Ben Hutchings (5):
      Revert "net: ipv4: ip_forward: fix inverted local_df test"
      Revert "net: ip, ipv6: handle gso skbs in forwarding path"
      dns_resolver: Null-terminate the right string
      score: Add missing #include <linux/export.h>
      Linux 3.2.62

Bernd Wachter (1):
      usb: option: Add ID for Telewell TW-LTE 4G v2

Bert Vermeulen (1):
      USB: ftdi_sio: Add extra PID.

Bj=C3=B8rn Mork (1):
      usb: option: add/modify Olivetti Olicard modems

Brian King (2):
      ibmvscsi: Abort init sequence during error recovery
      ibmvscsi: Add memory barriers for send / receive

Catalin Marinas (1):
      mm: kmemleak: avoid false negatives on vmalloc'ed objects

Dan Carpenter (1):
      applicom: dereferencing NULL on error path

Daniel Borkmann (1):
      net: sctp: fix information leaks in ulpevent layer

Dave Chinner (2):
      xfs: fix allocbt cursor leak in xfs_alloc_ag_vextent_near
      xfs: really fix the cursor leak in xfs_alloc_ag_vextent_near

David R. Piegdon (1):
      ARM: OMAP2+: Fix parser-bug in platform muxing code

David Vrabel (1):
      xen/manage: fix potential deadlock when resuming the console

Emmanuel Grumbach (1):
      iwlwifi: dvm: don't enable CTS to self

Eric Dumazet (1):
      ipv4: fix buffer overflow in ip_options_compile()

Eric Sandeen (1):
      ext4: disable synchronous transaction batching if max_batch_time=3D=
=3D0

Feng Tang (2):
      ACPI / EC: Add more debug info and trivial code cleanup
      ACPI / EC: Don't count a SCI interrupt as a false one

Fengguang Wu (1):
      unicore32: select generic atomic64_t support

Gavin Guo (1):
      usb: Check if port status is equal to RxDetect

Gu Zheng (1):
      cpuset,mempolicy: fix sleeping function called from invalid context

Guan Xuetao (1):
      unicore32: add ioremap_nocache definition

Guenter Roeck (3):
      hwmon: (adm1031) Fix writes to limit registers
      hwmon: (emc2103) Clamp limits instead of bailing out
      hwmon: (adt7470) Fix writes to temperature limit registers

H. Peter Anvin (1):
      x86-32, espfix: Remove filter for espfix32 due to race

HATAYAMA Daisuke (1):
      perf/x86/intel: ignore CondChgd bit to avoid false NMI handling

Hugh Dickins (3):
      shmem: fix faulting into a hole while it's punched
      shmem: fix faulting into a hole, not taking i_mutex
      shmem: fix splicing from a hole while it's punched

Ivan Djelic (1):
      ARM: 7668/1: fix memset-related crashes caused by recent GCC (4.7.2) =
optimizations

J. Bruce Fields (1):
      nfsd: fix rare symlink decoding bug

Jiang Liu (1):
      score: normalize global variables exported by vmlinux.lds

Joe Thornber (1):
      dm io: fix a race condition in the wake up code for sync_io

Johan Hovold (1):
      USB: ftdi_sio: fix null deref at port probe

John Stultz (1):
      alarmtimer: Fix bug where relative alarm timers were treated as absol=
ute

Julian Anastasov (1):
      ipvs: stop tot_stats estimator only under CONFIG_SYSCTL

Kevin Hao (1):
      libata: support the ata host which implements a queue depth less than=
 32

Lan Tianyu (1):
      ACPI / battery: Retry to get battery information if failed during pro=
bing

Lennox Wu (1):
      Score: The commit is for compiling successfully. The modifications in=
clude: 1. Kconfig of Score: we don't support ioremap 2. Missed headfile inc=
luding 3. There are some errors in other people's commit not checked by us,=
 we fix it now 3.1 arch/score/kernel/entry.S: wrong instructions 3.2 arch/s=
core/kernel/process.c : just some typos

Li RongQing (1):
      8021q: fix a potential memory leak

Lu Baolu (1):
      xhci: clear root port wake on bits if controller isn't wake-up capabl=
e

Lv Zheng (4):
      ACPI / EC: Avoid race condition related to advance_transaction()
      ACPI / EC: Add asynchronous command byte write support
      ACPI / EC: Remove duplicated ec_wait_ibf0() waiter
      ACPI / EC: Fix race condition in ec_transaction_completed()

Manuel Sch=C3=B6lling (1):
      dns_resolver: assure that dns_query() result is null-terminated

Markus F.X.J. Oberhumer (1):
      crypto: testmgr - update LZO compression test vectors

Martin Lau (1):
      ring-buffer: Fix polling on trace_pipe

Martin Schwidefsky (1):
      s390/ptrace: fix PSW mask check

Mateusz Guzik (1):
      sched: Fix possible divide by zero in avg_atom() calculation

Mathias Krause (1):
      netfilter: ipt_ULOG: fix info leaks

Mathias Nyman (1):
      xhci: correct burst count field for isoc transfers on 1.0 xhci hosts

Michael Cree (1):
      alpha: add io{read,write}{16,32}be functions

Michal Nazarewicz (2):
      usb: gadget: f_fs: fix NULL pointer dereference when there are no str=
ings
      tools: ffs-test: fix header values endianess

Michal Schmidt (1):
      rtnetlink: fix userspace API breakage for iproute2 < v3.9.0

Miklos Szeredi (2):
      fuse: timeout comparison fix
      fuse: handle large user and group ID

Mikulas Patocka (1):
      sym53c8xx_2: Set DID_REQUEUE return code when aborting squeue

Nadav Amit (1):
      KVM: x86: Increase the number of fixed MTRR regs to 10

Naoya Horiguchi (1):
      mm: hugetlb: fix copy_hugetlb_page_range()

Neal Cardwell (1):
      tcp: fix tcp_match_skb_to_sack() for unaligned SACK at end of an skb

NeilBrown (1):
      md: flush writes before starting a recovery.

Nicolas Pitre (1):
      ARM: 7670/1: fix the memset fix

Paolo Bonzini (1):
      KVM: x86: preserve the high 32-bits of the PAT register

Peter Zijlstra (1):
      locking/mutex: Disable optimistic spinning on some architectures

Puneet Kumar (1):
      ACPI / EC: Ensure lock is acquired before accessing ec struct members

Roland Dreier (1):
      x86, ioremap: Speed up check for RAM pages

Sasha Levin (1):
      net/l2tp: don't fall back on UDP [get|set]sockopt

Sowmini Varadhan (1):
      sunvnet: clean up objects created in vnet_new() on vnet_exit()

Stefan Assmann (1):
      igb: do a reset on SR-IOV re-init if device is down

Sven Wegener (1):
      x86_32, entry: Store badsys error code in %eax

Takao Indoh (1):
      iommu/vt-d: Disable translation if already enabled

Tejun Heo (1):
      libata: introduce ata_host->n_tags to avoid oops on SAS controllers

Theodore Ts'o (1):
      ext4: clarify error count warning messages

Thomas Gleixner (1):
      nohz: Fix another inconsistency between CONFIG_NO_HZ=3Dn and nohz=3Do=
ff

Thomas Hellstrom (1):
      drm/vmwgfx: Fix incorrect write to read-only register v2:

Wang, Yu (1):
      xhci: Fix runtime suspended xhci from blocking system suspend.

Xi Wang (2):
      ceph: fix overflow check in build_snap_context()
      introduce SIZE_MAX

dingtianhong (1):
      igmp: fix the problem when mc leave group


--=20
Ben Hutchings
To err is human; to really foul things up requires a computer.

--=-nXWv+QdUu+vuaUfRk/E6
Content-Type: text/x-diff; charset="UTF-8"; name="linux-3.2.62.patch"
Content-Disposition: attachment; filename="linux-3.2.62.patch"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL01ha2VmaWxlIGIvTWFrZWZpbGUNCmluZGV4IGY4YjY0MmQuLjMwYTVjNjUg
MTAwNjQ0DQotLS0gYS9NYWtlZmlsZQ0KKysrIGIvTWFrZWZpbGUNCkBAIC0xLDYgKzEsNiBAQA0K
IFZFUlNJT04gPSAzDQogUEFUQ0hMRVZFTCA9IDINCi1TVUJMRVZFTCA9IDYxDQorU1VCTEVWRUwg
PSA2Mg0KIEVYVFJBVkVSU0lPTiA9DQogTkFNRSA9IFNhYmVyLXRvb3RoZWQgU3F1aXJyZWwNCiAN
CmRpZmYgLS1naXQgYS9hcmNoL2FscGhhL2luY2x1ZGUvYXNtL2lvLmggYi9hcmNoL2FscGhhL2lu
Y2x1ZGUvYXNtL2lvLmgNCmluZGV4IDU2ZmY5NjUuLjYzNjVlZjIgMTAwNjQ0DQotLS0gYS9hcmNo
L2FscGhhL2luY2x1ZGUvYXNtL2lvLmgNCisrKyBiL2FyY2gvYWxwaGEvaW5jbHVkZS9hc20vaW8u
aA0KQEAgLTQ5MCw2ICs0OTAsMTEgQEAgZXh0ZXJuIGlubGluZSB2b2lkIHdyaXRlcSh1NjQgYiwg
dm9sYXRpbGUgdm9pZCBfX2lvbWVtICphZGRyKQ0KIH0NCiAjZW5kaWYNCiANCisjZGVmaW5lIGlv
cmVhZDE2YmUocCkgYmUxNl90b19jcHUoaW9yZWFkMTYocCkpDQorI2RlZmluZSBpb3JlYWQzMmJl
KHApIGJlMzJfdG9fY3B1KGlvcmVhZDMyKHApKQ0KKyNkZWZpbmUgaW93cml0ZTE2YmUodixwKSBp
b3dyaXRlMTYoY3B1X3RvX2JlMTYodiksIChwKSkNCisjZGVmaW5lIGlvd3JpdGUzMmJlKHYscCkg
aW93cml0ZTMyKGNwdV90b19iZTMyKHYpLCAocCkpDQorDQogI2RlZmluZSBpbmJfcAkJaW5iDQog
I2RlZmluZSBpbndfcAkJaW53DQogI2RlZmluZSBpbmxfcAkJaW5sDQpkaWZmIC0tZ2l0IGEvYXJj
aC9hcm0vS2NvbmZpZyBiL2FyY2gvYXJtL0tjb25maWcNCmluZGV4IDc5MGVhNjguLjA4MmJkMzYg
MTAwNjQ0DQotLS0gYS9hcmNoL2FybS9LY29uZmlnDQorKysgYi9hcmNoL2FybS9LY29uZmlnDQpA
QCAtMSw2ICsxLDcgQEANCiBjb25maWcgQVJNDQogCWJvb2wNCiAJZGVmYXVsdCB5DQorCXNlbGVj
dCBBUkNIX1NVUFBPUlRTX0FUT01JQ19STVcNCiAJc2VsZWN0IEhBVkVfRE1BX0FQSV9ERUJVRw0K
IAlzZWxlY3QgSEFWRV9JREUgaWYgUENJIHx8IElTQSB8fCBQQ01DSUENCiAJc2VsZWN0IEhBVkVf
TUVNQkxPQ0sNCmRpZmYgLS1naXQgYS9hcmNoL2FybS9saWIvbWVtc2V0LlMgYi9hcmNoL2FybS9s
aWIvbWVtc2V0LlMNCmluZGV4IDY1MGQ1OTIzLi45NGIwNjUwIDEwMDY0NA0KLS0tIGEvYXJjaC9h
cm0vbGliL21lbXNldC5TDQorKysgYi9hcmNoL2FybS9saWIvbWVtc2V0LlMNCkBAIC0xNCwyNyAr
MTQsMTUgQEANCiANCiAJLnRleHQNCiAJLmFsaWduCTUNCi0JLndvcmQJMA0KLQ0KLTE6CXN1YnMJ
cjIsIHIyLCAjNAkJQCAxIGRvIHdlIGhhdmUgZW5vdWdoDQotCWJsdAk1ZgkJCUAgMSBieXRlcyB0
byBhbGlnbiB3aXRoPw0KLQljbXAJcjMsICMyCQkJQCAxDQotCXN0cmx0YglyMSwgW3IwXSwgIzEJ
CUAgMQ0KLQlzdHJsZWIJcjEsIFtyMF0sICMxCQlAIDENCi0Jc3RyYglyMSwgW3IwXSwgIzEJCUAg
MQ0KLQlhZGQJcjIsIHIyLCByMwkJQCAxIChyMiA9IHIyIC0gKDQgLSByMykpDQotLyoNCi0gKiBU
aGUgcG9pbnRlciBpcyBub3cgYWxpZ25lZCBhbmQgdGhlIGxlbmd0aCBpcyBhZGp1c3RlZC4gIFRy
eSBkb2luZyB0aGUNCi0gKiBtZW1zZXQgYWdhaW4uDQotICovDQogDQogRU5UUlkobWVtc2V0KQ0K
IAlhbmRzCXIzLCByMCwgIzMJCUAgMSB1bmFsaWduZWQ/DQotCWJuZQkxYgkJCUAgMQ0KKwltb3YJ
aXAsIHIwCQkJQCBwcmVzZXJ2ZSByMCBhcyByZXR1cm4gdmFsdWUNCisJYm5lCTZmCQkJQCAxDQog
LyoNCi0gKiB3ZSBrbm93IHRoYXQgdGhlIHBvaW50ZXIgaW4gcjAgaXMgYWxpZ25lZCB0byBhIHdv
cmQgYm91bmRhcnkuDQorICogd2Uga25vdyB0aGF0IHRoZSBwb2ludGVyIGluIGlwIGlzIGFsaWdu
ZWQgdG8gYSB3b3JkIGJvdW5kYXJ5Lg0KICAqLw0KLQlvcnIJcjEsIHIxLCByMSwgbHNsICM4DQor
MToJb3JyCXIxLCByMSwgcjEsIGxzbCAjOA0KIAlvcnIJcjEsIHIxLCByMSwgbHNsICMxNg0KIAlt
b3YJcjMsIHIxDQogCWNtcAlyMiwgIzE2DQpAQCAtNDMsMjkgKzMxLDI4IEBAIEVOVFJZKG1lbXNl
dCkNCiAjaWYgISBDQUxHTigxKSswDQogDQogLyoNCi0gKiBXZSBuZWVkIGFuIGV4dHJhIHJlZ2lz
dGVyIGZvciB0aGlzIGxvb3AgLSBzYXZlIHRoZSByZXR1cm4gYWRkcmVzcyBhbmQNCi0gKiB1c2Ug
dGhlIExSDQorICogV2UgbmVlZCAyIGV4dHJhIHJlZ2lzdGVycyBmb3IgdGhpcyBsb29wIC0gdXNl
IHI4IGFuZCB0aGUgTFINCiAgKi8NCi0Jc3RyCWxyLCBbc3AsICMtNF0hDQotCW1vdglpcCwgcjEN
CisJc3RtZmQJc3AhLCB7cjgsIGxyfQ0KKwltb3YJcjgsIHIxDQogCW1vdglsciwgcjENCiANCiAy
OglzdWJzCXIyLCByMiwgIzY0DQotCXN0bWdlaWEJcjAhLCB7cjEsIHIzLCBpcCwgbHJ9CUAgNjQg
Ynl0ZXMgYXQgYSB0aW1lLg0KLQlzdG1nZWlhCXIwISwge3IxLCByMywgaXAsIGxyfQ0KLQlzdG1n
ZWlhCXIwISwge3IxLCByMywgaXAsIGxyfQ0KLQlzdG1nZWlhCXIwISwge3IxLCByMywgaXAsIGxy
fQ0KKwlzdG1nZWlhCWlwISwge3IxLCByMywgcjgsIGxyfQlAIDY0IGJ5dGVzIGF0IGEgdGltZS4N
CisJc3RtZ2VpYQlpcCEsIHtyMSwgcjMsIHI4LCBscn0NCisJc3RtZ2VpYQlpcCEsIHtyMSwgcjMs
IHI4LCBscn0NCisJc3RtZ2VpYQlpcCEsIHtyMSwgcjMsIHI4LCBscn0NCiAJYmd0CTJiDQotCWxk
bWVxZmQJc3AhLCB7cGN9CQlAIE5vdyA8NjQgYnl0ZXMgdG8gZ28uDQorCWxkbWVxZmQJc3AhLCB7
cjgsIHBjfQkJQCBOb3cgPDY0IGJ5dGVzIHRvIGdvLg0KIC8qDQogICogTm8gbmVlZCB0byBjb3Jy
ZWN0IHRoZSBjb3VudDsgd2UncmUgb25seSB0ZXN0aW5nIGJpdHMgZnJvbSBub3cgb24NCiAgKi8N
CiAJdHN0CXIyLCAjMzINCi0Jc3RtbmVpYQlyMCEsIHtyMSwgcjMsIGlwLCBscn0NCi0Jc3RtbmVp
YQlyMCEsIHtyMSwgcjMsIGlwLCBscn0NCisJc3RtbmVpYQlpcCEsIHtyMSwgcjMsIHI4LCBscn0N
CisJc3RtbmVpYQlpcCEsIHtyMSwgcjMsIHI4LCBscn0NCiAJdHN0CXIyLCAjMTYNCi0Jc3RtbmVp
YQlyMCEsIHtyMSwgcjMsIGlwLCBscn0NCi0JbGRyCWxyLCBbc3BdLCAjNA0KKwlzdG1uZWlhCWlw
ISwge3IxLCByMywgcjgsIGxyfQ0KKwlsZG1mZAlzcCEsIHtyOCwgbHJ9DQogDQogI2Vsc2UNCiAN
CkBAIC03NCw1NCArNjEsNjMgQEAgRU5UUlkobWVtc2V0KQ0KICAqIHdob2xlIGNhY2hlIGxpbmVz
IGF0IG9uY2UuDQogICovDQogDQotCXN0bWZkCXNwISwge3I0LXI3LCBscn0NCisJc3RtZmQJc3Ah
LCB7cjQtcjgsIGxyfQ0KIAltb3YJcjQsIHIxDQogCW1vdglyNSwgcjENCiAJbW92CXI2LCByMQ0K
IAltb3YJcjcsIHIxDQotCW1vdglpcCwgcjENCisJbW92CXI4LCByMQ0KIAltb3YJbHIsIHIxDQog
DQogCWNtcAlyMiwgIzk2DQotCXRzdGd0CXIwLCAjMzENCisJdHN0Z3QJaXAsICMzMQ0KIAlibGUJ
M2YNCiANCi0JYW5kCWlwLCByMCwgIzMxDQotCXJzYglpcCwgaXAsICMzMg0KLQlzdWIJcjIsIHIy
LCBpcA0KLQltb3ZzCWlwLCBpcCwgbHNsICMoMzIgLSA0KQ0KLQlzdG1jc2lhCXIwISwge3I0LCBy
NSwgcjYsIHI3fQ0KLQlzdG1taWlhCXIwISwge3I0LCByNX0NCi0JdHN0CWlwLCAjKDEgPDwgMzAp
DQotCW1vdglpcCwgcjENCi0Jc3RybmUJcjEsIFtyMF0sICM0DQorCWFuZAlyOCwgaXAsICMzMQ0K
Kwlyc2IJcjgsIHI4LCAjMzINCisJc3ViCXIyLCByMiwgcjgNCisJbW92cwlyOCwgcjgsIGxzbCAj
KDMyIC0gNCkNCisJc3RtY3NpYQlpcCEsIHtyNCwgcjUsIHI2LCByN30NCisJc3RtbWlpYQlpcCEs
IHtyNCwgcjV9DQorCXRzdAlyOCwgIygxIDw8IDMwKQ0KKwltb3YJcjgsIHIxDQorCXN0cm5lCXIx
LCBbaXBdLCAjNA0KIA0KIDM6CXN1YnMJcjIsIHIyLCAjNjQNCi0Jc3RtZ2VpYQlyMCEsIHtyMSwg
cjMtcjcsIGlwLCBscn0NCi0Jc3RtZ2VpYQlyMCEsIHtyMSwgcjMtcjcsIGlwLCBscn0NCisJc3Rt
Z2VpYQlpcCEsIHtyMSwgcjMtcjgsIGxyfQ0KKwlzdG1nZWlhCWlwISwge3IxLCByMy1yOCwgbHJ9
DQogCWJndAkzYg0KLQlsZG1lcWZkCXNwISwge3I0LXI3LCBwY30NCisJbGRtZXFmZAlzcCEsIHty
NC1yOCwgcGN9DQogDQogCXRzdAlyMiwgIzMyDQotCXN0bW5laWEJcjAhLCB7cjEsIHIzLXI3LCBp
cCwgbHJ9DQorCXN0bW5laWEJaXAhLCB7cjEsIHIzLXI4LCBscn0NCiAJdHN0CXIyLCAjMTYNCi0J
c3RtbmVpYQlyMCEsIHtyNC1yN30NCi0JbGRtZmQJc3AhLCB7cjQtcjcsIGxyfQ0KKwlzdG1uZWlh
CWlwISwge3I0LXI3fQ0KKwlsZG1mZAlzcCEsIHtyNC1yOCwgbHJ9DQogDQogI2VuZGlmDQogDQog
NDoJdHN0CXIyLCAjOA0KLQlzdG1uZWlhCXIwISwge3IxLCByM30NCisJc3RtbmVpYQlpcCEsIHty
MSwgcjN9DQogCXRzdAlyMiwgIzQNCi0Jc3RybmUJcjEsIFtyMF0sICM0DQorCXN0cm5lCXIxLCBb
aXBdLCAjNA0KIC8qDQogICogV2hlbiB3ZSBnZXQgaGVyZSwgd2UndmUgZ290IGxlc3MgdGhhbiA0
IGJ5dGVzIHRvIHplcm8uICBXZQ0KICAqIG1heSBoYXZlIGFuIHVuYWxpZ25lZCBwb2ludGVyIGFz
IHdlbGwuDQogICovDQogNToJdHN0CXIyLCAjMg0KLQlzdHJuZWIJcjEsIFtyMF0sICMxDQotCXN0
cm5lYglyMSwgW3IwXSwgIzENCisJc3RybmViCXIxLCBbaXBdLCAjMQ0KKwlzdHJuZWIJcjEsIFtp
cF0sICMxDQogCXRzdAlyMiwgIzENCi0Jc3RybmViCXIxLCBbcjBdLCAjMQ0KKwlzdHJuZWIJcjEs
IFtpcF0sICMxDQogCW1vdglwYywgbHINCisNCis2OglzdWJzCXIyLCByMiwgIzQJCUAgMSBkbyB3
ZSBoYXZlIGVub3VnaA0KKwlibHQJNWIJCQlAIDEgYnl0ZXMgdG8gYWxpZ24gd2l0aD8NCisJY21w
CXIzLCAjMgkJCUAgMQ0KKwlzdHJsdGIJcjEsIFtpcF0sICMxCQlAIDENCisJc3RybGViCXIxLCBb
aXBdLCAjMQkJQCAxDQorCXN0cmIJcjEsIFtpcF0sICMxCQlAIDENCisJYWRkCXIyLCByMiwgcjMJ
CUAgMSAocjIgPSByMiAtICg0IC0gcjMpKQ0KKwliCTFiDQogRU5EUFJPQyhtZW1zZXQpDQpkaWZm
IC0tZ2l0IGEvYXJjaC9hcm0vbWFjaC1vbWFwMi9tdXguYyBiL2FyY2gvYXJtL21hY2gtb21hcDIv
bXV4LmMNCmluZGV4IDY1NWU5NDguLjQ0OWY5NTUgMTAwNjQ0DQotLS0gYS9hcmNoL2FybS9tYWNo
LW9tYXAyL211eC5jDQorKysgYi9hcmNoL2FybS9tYWNoLW9tYXAyL211eC5jDQpAQCAtMTgyLDgg
KzE4MiwxMCBAQCBzdGF0aWMgaW50IF9faW5pdCBfb21hcF9tdXhfZ2V0X2J5X25hbWUoc3RydWN0
IG9tYXBfbXV4X3BhcnRpdGlvbiAqcGFydGl0aW9uLA0KIAkJbTBfZW50cnkgPSBtdXgtPm11eG5h
bWVzWzBdOw0KIA0KIAkJLyogRmlyc3QgY2hlY2sgZm9yIGZ1bGwgbmFtZSBpbiBtb2RlMC5tdXht
b2RlIGZvcm1hdCAqLw0KLQkJaWYgKG1vZGUwX2xlbiAmJiBzdHJuY21wKG11eG5hbWUsIG0wX2Vu
dHJ5LCBtb2RlMF9sZW4pKQ0KLQkJCWNvbnRpbnVlOw0KKwkJaWYgKG1vZGUwX2xlbikNCisJCQlp
ZiAoc3RybmNtcChtdXhuYW1lLCBtMF9lbnRyeSwgbW9kZTBfbGVuKSB8fA0KKwkJCSAgICAoc3Ry
bGVuKG0wX2VudHJ5KSAhPSBtb2RlMF9sZW4pKQ0KKwkJCQljb250aW51ZTsNCiANCiAJCS8qIFRo
ZW4gY2hlY2sgZm9yIG11eG1vZGUgb25seSAqLw0KIAkJZm9yIChpID0gMDsgaSA8IE9NQVBfTVVY
X05SX01PREVTOyBpKyspIHsNCmRpZmYgLS1naXQgYS9hcmNoL3Bvd2VycGMvS2NvbmZpZyBiL2Fy
Y2gvcG93ZXJwYy9LY29uZmlnDQppbmRleCAxNmVmODM4Li5iZWM5NTJkIDEwMDY0NA0KLS0tIGEv
YXJjaC9wb3dlcnBjL0tjb25maWcNCisrKyBiL2FyY2gvcG93ZXJwYy9LY29uZmlnDQpAQCAtMTM3
LDYgKzEzNyw3IEBAIGNvbmZpZyBQUEMNCiAJc2VsZWN0IEhBVkVfQlBGX0pJVCBpZiAoUFBDNjQg
JiYgTkVUKQ0KIAlzZWxlY3QgSEFWRV9BUkNIX0pVTVBfTEFCRUwNCiAJc2VsZWN0IEFSQ0hfSEFW
RV9OTUlfU0FGRV9DTVBYQ0hHDQorCXNlbGVjdCBBUkNIX1NVUFBPUlRTX0FUT01JQ19STVcNCiAN
CiBjb25maWcgRUFSTFlfUFJJTlRLDQogCWJvb2wNCmRpZmYgLS1naXQgYS9hcmNoL3MzOTAva2Vy
bmVsL3B0cmFjZS5jIGIvYXJjaC9zMzkwL2tlcm5lbC9wdHJhY2UuYw0KaW5kZXggYWZlODJiYy4u
Yjc2MjMwYiAxMDA2NDQNCi0tLSBhL2FyY2gvczM5MC9rZXJuZWwvcHRyYWNlLmMNCisrKyBiL2Fy
Y2gvczM5MC9rZXJuZWwvcHRyYWNlLmMNCkBAIC0yOTIsNyArMjkyLDkgQEAgc3RhdGljIGludCBf
X3Bva2VfdXNlcihzdHJ1Y3QgdGFza19zdHJ1Y3QgKmNoaWxkLCBhZGRyX3QgYWRkciwgYWRkcl90
IGRhdGEpDQogCQkgKiBwc3cgYW5kIGdwcnMgYXJlIHN0b3JlZCBvbiB0aGUgc3RhY2sNCiAJCSAq
Lw0KIAkJaWYgKGFkZHIgPT0gKGFkZHJfdCkgJmR1bW15LT5yZWdzLnBzdy5tYXNrICYmDQotCQkg
ICAgKChkYXRhICYgflBTV19NQVNLX1VTRVIpICE9IHBzd191c2VyX2JpdHMgfHwNCisJCSAgICAo
KChkYXRhXnBzd191c2VyX2JpdHMpICYgflBTV19NQVNLX1VTRVIpIHx8DQorCQkgICAgICgoKGRh
dGFecHN3X3VzZXJfYml0cykgJiBQU1dfTUFTS19BU0MpICYmDQorCQkgICAgICAoKGRhdGF8cHN3
X3VzZXJfYml0cykgJiBQU1dfTUFTS19BU0MpID09IFBTV19NQVNLX0FTQykgfHwNCiAJCSAgICAg
KChkYXRhICYgUFNXX01BU0tfRUEpICYmICEoZGF0YSAmIFBTV19NQVNLX0JBKSkpKQ0KIAkJCS8q
IEludmFsaWQgcHN3IG1hc2suICovDQogCQkJcmV0dXJuIC1FSU5WQUw7DQpAQCAtNTk1LDcgKzU5
NywxMCBAQCBzdGF0aWMgaW50IF9fcG9rZV91c2VyX2NvbXBhdChzdHJ1Y3QgdGFza19zdHJ1Y3Qg
KmNoaWxkLA0KIAkJICovDQogCQlpZiAoYWRkciA9PSAoYWRkcl90KSAmZHVtbXkzMi0+cmVncy5w
c3cubWFzaykgew0KIAkJCS8qIEJ1aWxkIGEgNjQgYml0IHBzdyBtYXNrIGZyb20gMzEgYml0IG1h
c2suICovDQotCQkJaWYgKCh0bXAgJiB+UFNXMzJfTUFTS19VU0VSKSAhPSBwc3czMl91c2VyX2Jp
dHMpDQorCQkJaWYgKCgodG1wXnBzdzMyX3VzZXJfYml0cykgJiB+UFNXMzJfTUFTS19VU0VSKSB8
fA0KKwkJCSAgICAoKCh0bXBecHN3MzJfdXNlcl9iaXRzKSAmIFBTVzMyX01BU0tfQVNDKSAmJg0K
KwkJCSAgICAgKCh0bXB8cHN3MzJfdXNlcl9iaXRzKSAmIFBTVzMyX01BU0tfQVNDKQ0KKwkJCSAg
ICAgPT0gUFNXMzJfTUFTS19BU0MpKQ0KIAkJCQkvKiBJbnZhbGlkIHBzdyBtYXNrLiAqLw0KIAkJ
CQlyZXR1cm4gLUVJTlZBTDsNCiAJCQlyZWdzLT5wc3cubWFzayA9IChyZWdzLT5wc3cubWFzayAm
IH5QU1dfTUFTS19VU0VSKSB8DQpkaWZmIC0tZ2l0IGEvYXJjaC9zY29yZS9LY29uZmlnIGIvYXJj
aC9zY29yZS9LY29uZmlnDQppbmRleCBkZjE2OWU4Li5iZWI5ZjIxIDEwMDY0NA0KLS0tIGEvYXJj
aC9zY29yZS9LY29uZmlnDQorKysgYi9hcmNoL3Njb3JlL0tjb25maWcNCkBAIC0xMDgsMyArMTA4
LDYgQEAgc291cmNlICJzZWN1cml0eS9LY29uZmlnIg0KIHNvdXJjZSAiY3J5cHRvL0tjb25maWci
DQogDQogc291cmNlICJsaWIvS2NvbmZpZyINCisNCitjb25maWcgTk9fSU9NRU0NCisgICAgICAg
ZGVmX2Jvb2wgeQ0KZGlmZiAtLWdpdCBhL2FyY2gvc2NvcmUvaW5jbHVkZS9hc20vaW8uaCBiL2Fy
Y2gvc2NvcmUvaW5jbHVkZS9hc20vaW8uaA0KaW5kZXggZmJiZmQ3MS4uNTc0Yzg4MjcgMTAwNjQ0
DQotLS0gYS9hcmNoL3Njb3JlL2luY2x1ZGUvYXNtL2lvLmgNCisrKyBiL2FyY2gvc2NvcmUvaW5j
bHVkZS9hc20vaW8uaA0KQEAgLTUsNSArNSw0IEBADQogDQogI2RlZmluZSB2aXJ0X3RvX2J1cwl2
aXJ0X3RvX3BoeXMNCiAjZGVmaW5lIGJ1c190b192aXJ0CXBoeXNfdG9fdmlydA0KLQ0KICNlbmRp
ZiAvKiBfQVNNX1NDT1JFX0lPX0ggKi8NCmRpZmYgLS1naXQgYS9hcmNoL3Njb3JlL2luY2x1ZGUv
YXNtL3BnYWxsb2MuaCBiL2FyY2gvc2NvcmUvaW5jbHVkZS9hc20vcGdhbGxvYy5oDQppbmRleCAw
NTlhNjFiLi43MTZiM2ZkIDEwMDY0NA0KLS0tIGEvYXJjaC9zY29yZS9pbmNsdWRlL2FzbS9wZ2Fs
bG9jLmgNCisrKyBiL2FyY2gvc2NvcmUvaW5jbHVkZS9hc20vcGdhbGxvYy5oDQpAQCAtMiw3ICsy
LDcgQEANCiAjZGVmaW5lIF9BU01fU0NPUkVfUEdBTExPQ19IDQogDQogI2luY2x1ZGUgPGxpbnV4
L21tLmg+DQotDQorI2luY2x1ZGUgPGxpbnV4L2hpZ2htZW0uaD4NCiBzdGF0aWMgaW5saW5lIHZv
aWQgcG1kX3BvcHVsYXRlX2tlcm5lbChzdHJ1Y3QgbW1fc3RydWN0ICptbSwgcG1kX3QgKnBtZCwN
CiAJcHRlX3QgKnB0ZSkNCiB7DQpkaWZmIC0tZ2l0IGEvYXJjaC9zY29yZS9rZXJuZWwvZW50cnku
UyBiL2FyY2gvc2NvcmUva2VybmVsL2VudHJ5LlMNCmluZGV4IDgzYmI5NjAuLjg5NzAyYWMgMTAw
NjQ0DQotLS0gYS9hcmNoL3Njb3JlL2tlcm5lbC9lbnRyeS5TDQorKysgYi9hcmNoL3Njb3JlL2tl
cm5lbC9lbnRyeS5TDQpAQCAtMjY0LDcgKzI2NCw3IEBAIHJlc3VtZV9rZXJuZWw6DQogCWRpc2Fi
bGVfaXJxDQogCWx3CXI4LCBbcjI4LCBUSV9QUkVfQ09VTlRdDQogCWNtcHouYwlyOA0KLQlibmUJ
cjgsIHJlc3RvcmVfYWxsDQorCWJuZQlyZXN0b3JlX2FsbA0KIG5lZWRfcmVzY2hlZDoNCiAJbHcJ
cjgsIFtyMjgsIFRJX0ZMQUdTXQ0KIAlhbmRyaS5jCXI5LCByOCwgX1RJRl9ORUVEX1JFU0NIRUQN
CkBAIC00MDgsNyArNDA4LDcgQEAgRU5UUlkoaGFuZGxlX3N5cykNCiAJc3cJcjksIFtyMCwgUFRf
RVBDXQ0KIA0KIAljbXBpLmMJcjI3LCBfX05SX3N5c2NhbGxzIAkjIGNoZWNrIHN5c2NhbGwgbnVt
YmVyDQotCWJnZXUJaWxsZWdhbF9zeXNjYWxsDQorCWJjcwlpbGxlZ2FsX3N5c2NhbGwNCiANCiAJ
c2xsaQlyOCwgcjI3LCAyCQkjIGdldCBzeXNjYWxsIHJvdXRpbmUNCiAJbGEJcjExLCBzeXNfY2Fs
bF90YWJsZQ0KZGlmZiAtLWdpdCBhL2FyY2gvc2NvcmUva2VybmVsL2luaXRfdGFzay5jIGIvYXJj
aC9zY29yZS9rZXJuZWwvaW5pdF90YXNrLmMNCmluZGV4IGJhYTAzZWUuLjc1M2E5ZjEgMTAwNjQ0
DQotLS0gYS9hcmNoL3Njb3JlL2tlcm5lbC9pbml0X3Rhc2suYw0KKysrIGIvYXJjaC9zY29yZS9r
ZXJuZWwvaW5pdF90YXNrLmMNCkBAIC0yMyw2ICsyMyw3IEBADQogDQogI2luY2x1ZGUgPGxpbnV4
L2luaXRfdGFzay5oPg0KICNpbmNsdWRlIDxsaW51eC9tcXVldWUuaD4NCisjaW5jbHVkZSA8bGlu
dXgvZXhwb3J0Lmg+DQogDQogc3RhdGljIHN0cnVjdCBzaWduYWxfc3RydWN0IGluaXRfc2lnbmFs
cyA9IElOSVRfU0lHTkFMUyhpbml0X3NpZ25hbHMpOw0KIHN0YXRpYyBzdHJ1Y3Qgc2lnaGFuZF9z
dHJ1Y3QgaW5pdF9zaWdoYW5kID0gSU5JVF9TSUdIQU5EKGluaXRfc2lnaGFuZCk7DQpkaWZmIC0t
Z2l0IGEvYXJjaC9zY29yZS9rZXJuZWwvdm1saW51eC5sZHMuUyBiL2FyY2gvc2NvcmUva2VybmVs
L3ZtbGludXgubGRzLlMNCmluZGV4IGVlYmNiYWEuLjcyNzRiNWMgMTAwNjQ0DQotLS0gYS9hcmNo
L3Njb3JlL2tlcm5lbC92bWxpbnV4Lmxkcy5TDQorKysgYi9hcmNoL3Njb3JlL2tlcm5lbC92bWxp
bnV4Lmxkcy5TDQpAQCAtNDksNiArNDksNyBAQCBTRUNUSU9OUw0KIAl9DQogDQogCS4gPSBBTElH
TigxNik7DQorCV9zZGF0YSA9ICAuOwkJCS8qIFN0YXJ0IG9mIGRhdGEgc2VjdGlvbiAqLw0KIAlS
T0RBVEENCiANCiAJRVhDRVBUSU9OX1RBQkxFKDE2KQ0KZGlmZiAtLWdpdCBhL2FyY2gvc2NvcmUv
bW0vaW5pdC5jIGIvYXJjaC9zY29yZS9tbS9pbml0LmMNCmluZGV4IGNlZTZiY2UuLjE1MGEzZTYg
MTAwNjQ0DQotLS0gYS9hcmNoL3Njb3JlL21tL2luaXQuYw0KKysrIGIvYXJjaC9zY29yZS9tbS9p
bml0LmMNCkBAIC0zNCw2ICszNCw3IEBADQogI2luY2x1ZGUgPGxpbnV4L3Byb2NfZnMuaD4NCiAj
aW5jbHVkZSA8bGludXgvc2NoZWQuaD4NCiAjaW5jbHVkZSA8bGludXgvaW5pdHJkLmg+DQorI2lu
Y2x1ZGUgPGxpbnV4L2V4cG9ydC5oPg0KIA0KICNpbmNsdWRlIDxhc20vc2VjdGlvbnMuaD4NCiAj
aW5jbHVkZSA8YXNtL3RsYi5oPg0KZGlmZiAtLWdpdCBhL2FyY2gvc3BhcmMvS2NvbmZpZyBiL2Fy
Y2gvc3BhcmMvS2NvbmZpZw0KaW5kZXggODhkNDQyZC4uZjJmMzU3NGQgMTAwNjQ0DQotLS0gYS9h
cmNoL3NwYXJjL0tjb25maWcNCisrKyBiL2FyY2gvc3BhcmMvS2NvbmZpZw0KQEAgLTU3LDYgKzU3
LDcgQEAgY29uZmlnIFNQQVJDNjQNCiAJc2VsZWN0IElSUV9QUkVGTE9XX0ZBU1RFT0kNCiAJc2Vs
ZWN0IEFSQ0hfSEFWRV9OTUlfU0FGRV9DTVBYQ0hHDQogCXNlbGVjdCBIQVZFX0NfUkVDT1JETUNP
VU5UDQorCXNlbGVjdCBBUkNIX1NVUFBPUlRTX0FUT01JQ19STVcNCiANCiBjb25maWcgQVJDSF9E
RUZDT05GSUcNCiAJc3RyaW5nDQpkaWZmIC0tZ2l0IGEvYXJjaC91bmljb3JlMzIvS2NvbmZpZyBi
L2FyY2gvdW5pY29yZTMyL0tjb25maWcNCmluZGV4IDk0MmVkNjEuLjM1ZThmZjEgMTAwNjQ0DQot
LS0gYS9hcmNoL3VuaWNvcmUzMi9LY29uZmlnDQorKysgYi9hcmNoL3VuaWNvcmUzMi9LY29uZmln
DQpAQCAtNiw2ICs2LDcgQEAgY29uZmlnIFVOSUNPUkUzMg0KIAlzZWxlY3QgSEFWRV9ETUFfQVRU
UlMNCiAJc2VsZWN0IEhBVkVfS0VSTkVMX0daSVANCiAJc2VsZWN0IEhBVkVfS0VSTkVMX0JaSVAy
DQorCXNlbGVjdCBHRU5FUklDX0FUT01JQzY0DQogCXNlbGVjdCBIQVZFX0tFUk5FTF9MWk8NCiAJ
c2VsZWN0IEhBVkVfS0VSTkVMX0xaTUENCiAJc2VsZWN0IEdFTkVSSUNfRklORF9GSVJTVF9CSVQN
CmRpZmYgLS1naXQgYS9hcmNoL3VuaWNvcmUzMi9pbmNsdWRlL2FzbS9pby5oIGIvYXJjaC91bmlj
b3JlMzIvaW5jbHVkZS9hc20vaW8uaA0KaW5kZXggMWE1YzVhNS4uNDk5NTk0ZiAxMDA2NDQNCi0t
LSBhL2FyY2gvdW5pY29yZTMyL2luY2x1ZGUvYXNtL2lvLmgNCisrKyBiL2FyY2gvdW5pY29yZTMy
L2luY2x1ZGUvYXNtL2lvLmgNCkBAIC0zNyw2ICszNyw3IEBAIGV4dGVybiB2b2lkIF9fdWMzMl9p
b3VubWFwKHZvbGF0aWxlIHZvaWQgX19pb21lbSAqYWRkcik7DQogICovDQogI2RlZmluZSBpb3Jl
bWFwKGNvb2tpZSwgc2l6ZSkJCV9fdWMzMl9pb3JlbWFwKGNvb2tpZSwgc2l6ZSkNCiAjZGVmaW5l
IGlvcmVtYXBfY2FjaGVkKGNvb2tpZSwgc2l6ZSkJX191YzMyX2lvcmVtYXBfY2FjaGVkKGNvb2tp
ZSwgc2l6ZSkNCisjZGVmaW5lIGlvcmVtYXBfbm9jYWNoZShjb29raWUsIHNpemUpCV9fdWMzMl9p
b3JlbWFwKGNvb2tpZSwgc2l6ZSkNCiAjZGVmaW5lIGlvdW5tYXAoY29va2llKQkJCV9fdWMzMl9p
b3VubWFwKGNvb2tpZSkNCiANCiAvKg0KZGlmZiAtLWdpdCBhL2FyY2gveDg2L0tjb25maWcgYi9h
cmNoL3g4Ni9LY29uZmlnDQppbmRleCBmYjJlNjlkLi45MDE0NDdlIDEwMDY0NA0KLS0tIGEvYXJj
aC94ODYvS2NvbmZpZw0KKysrIGIvYXJjaC94ODYvS2NvbmZpZw0KQEAgLTc1LDYgKzc1LDcgQEAg
Y29uZmlnIFg4Ng0KIAlzZWxlY3QgSEFWRV9CUEZfSklUIGlmIChYODZfNjQgJiYgTkVUKQ0KIAlz
ZWxlY3QgQ0xLRVZUX0k4MjUzDQogCXNlbGVjdCBBUkNIX0hBVkVfTk1JX1NBRkVfQ01QWENIRw0K
KwlzZWxlY3QgQVJDSF9TVVBQT1JUU19BVE9NSUNfUk1XDQogDQogY29uZmlnIElOU1RSVUNUSU9O
X0RFQ09ERVINCiAJZGVmX2Jvb2wgKEtQUk9CRVMgfHwgUEVSRl9FVkVOVFMpDQpkaWZmIC0tZ2l0
IGEvYXJjaC94ODYvaW5jbHVkZS9hc20va3ZtX2hvc3QuaCBiL2FyY2gveDg2L2luY2x1ZGUvYXNt
L2t2bV9ob3N0LmgNCmluZGV4IGNmYjVhNDAuLmIzZWI5YTcgMTAwNjQ0DQotLS0gYS9hcmNoL3g4
Ni9pbmNsdWRlL2FzbS9rdm1faG9zdC5oDQorKysgYi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9rdm1f
aG9zdC5oDQpAQCAtOTgsNyArOTgsNyBAQA0KICNkZWZpbmUgS1ZNX1JFRklMTF9QQUdFUyAyNQ0K
ICNkZWZpbmUgS1ZNX01BWF9DUFVJRF9FTlRSSUVTIDgwDQogI2RlZmluZSBLVk1fTlJfRklYRURf
TVRSUl9SRUdJT04gODgNCi0jZGVmaW5lIEtWTV9OUl9WQVJfTVRSUiA4DQorI2RlZmluZSBLVk1f
TlJfVkFSX01UUlIgMTANCiANCiAjZGVmaW5lIEFTWU5DX1BGX1BFUl9WQ1BVIDY0DQogDQpAQCAt
NDE4LDcgKzQxOCw3IEBAIHN0cnVjdCBrdm1fdmNwdV9hcmNoIHsNCiAJYm9vbCBubWlfaW5qZWN0
ZWQ7ICAgIC8qIFRyeWluZyB0byBpbmplY3QgYW4gTk1JIHRoaXMgZW50cnkgKi8NCiANCiAJc3Ry
dWN0IG10cnJfc3RhdGVfdHlwZSBtdHJyX3N0YXRlOw0KLQl1MzIgcGF0Ow0KKwl1NjQgcGF0Ow0K
IA0KIAlpbnQgc3dpdGNoX2RiX3JlZ3M7DQogCXVuc2lnbmVkIGxvbmcgZGJbS1ZNX05SX0RCX1JF
R1NdOw0KZGlmZiAtLWdpdCBhL2FyY2gveDg2L2tlcm5lbC9jcHUvcGVyZl9ldmVudF9pbnRlbC5j
IGIvYXJjaC94ODYva2VybmVsL2NwdS9wZXJmX2V2ZW50X2ludGVsLmMNCmluZGV4IDRiYjEyZjcu
LmNiYTE4ODMgMTAwNjQ0DQotLS0gYS9hcmNoL3g4Ni9rZXJuZWwvY3B1L3BlcmZfZXZlbnRfaW50
ZWwuYw0KKysrIGIvYXJjaC94ODYva2VybmVsL2NwdS9wZXJmX2V2ZW50X2ludGVsLmMNCkBAIC0x
MDQ4LDYgKzEwNDgsMTUgQEAgYWdhaW46DQogCWludGVsX3BtdV9sYnJfcmVhZCgpOw0KIA0KIAkv
Kg0KKwkgKiBDb25kQ2hnZCBiaXQgNjMgZG9lc24ndCBtZWFuIGFueSBvdmVyZmxvdyBzdGF0dXMu
IElnbm9yZQ0KKwkgKiBhbmQgY2xlYXIgdGhlIGJpdC4NCisJICovDQorCWlmIChfX3Rlc3RfYW5k
X2NsZWFyX2JpdCg2MywgKHVuc2lnbmVkIGxvbmcgKikmc3RhdHVzKSkgew0KKwkJaWYgKCFzdGF0
dXMpDQorCQkJZ290byBkb25lOw0KKwl9DQorDQorCS8qDQogCSAqIFBFQlMgb3ZlcmZsb3cgc2V0
cyBiaXQgNjIgaW4gdGhlIGdsb2JhbCBzdGF0dXMgcmVnaXN0ZXINCiAJICovDQogCWlmIChfX3Rl
c3RfYW5kX2NsZWFyX2JpdCg2MiwgKHVuc2lnbmVkIGxvbmcgKikmc3RhdHVzKSkgew0KZGlmZiAt
LWdpdCBhL2FyY2gveDg2L2tlcm5lbC9lbnRyeV8zMi5TIGIvYXJjaC94ODYva2VybmVsL2VudHJ5
XzMyLlMNCmluZGV4IGRiMDkwZjYuLmRkNTIzNTUgMTAwNjQ0DQotLS0gYS9hcmNoL3g4Ni9rZXJu
ZWwvZW50cnlfMzIuUw0KKysrIGIvYXJjaC94ODYva2VybmVsL2VudHJ5XzMyLlMNCkBAIC00Mjks
OCArNDI5LDggQEAgc3lzZW50ZXJfZG9fY2FsbDoNCiAJY21wbCAkKG5yX3N5c2NhbGxzKSwgJWVh
eA0KIAlqYWUgc3lzZW50ZXJfYmFkc3lzDQogCWNhbGwgKnN5c19jYWxsX3RhYmxlKCwlZWF4LDQp
DQotCW1vdmwgJWVheCxQVF9FQVgoJWVzcCkNCiBzeXNlbnRlcl9hZnRlcl9jYWxsOg0KKwltb3Zs
ICVlYXgsUFRfRUFYKCVlc3ApDQogCUxPQ0tERVBfU1lTX0VYSVQNCiAJRElTQUJMRV9JTlRFUlJV
UFRTKENMQlJfQU5ZKQ0KIAlUUkFDRV9JUlFTX09GRg0KQEAgLTUxMiw2ICs1MTIsNyBAQCBFTlRS
WShzeXN0ZW1fY2FsbCkNCiAJamFlIHN5c2NhbGxfYmFkc3lzDQogc3lzY2FsbF9jYWxsOg0KIAlj
YWxsICpzeXNfY2FsbF90YWJsZSgsJWVheCw0KQ0KK3N5c2NhbGxfYWZ0ZXJfY2FsbDoNCiAJbW92
bCAlZWF4LFBUX0VBWCglZXNwKQkJIyBzdG9yZSB0aGUgcmV0dXJuIHZhbHVlDQogc3lzY2FsbF9l
eGl0Og0KIAlMT0NLREVQX1NZU19FWElUDQpAQCAtNTUzLDExICs1NTQsNiBAQCBFTlRSWShpcmV0
X2V4YykNCiANCiAJQ0ZJX1JFU1RPUkVfU1RBVEUNCiBsZHRfc3M6DQotCWxhcmwgUFRfT0xEU1Mo
JWVzcCksICVlYXgNCi0Jam56IHJlc3RvcmVfbm9jaGVjaw0KLQl0ZXN0bCAkMHgwMDQwMDAwMCwg
JWVheAkJIyByZXR1cm5pbmcgdG8gMzJiaXQgc3RhY2s/DQotCWpueiByZXN0b3JlX25vY2hlY2sJ
CSMgYWxscmlnaHQsIG5vcm1hbCByZXR1cm4NCi0NCiAjaWZkZWYgQ09ORklHX1BBUkFWSVJUDQog
CS8qDQogCSAqIFRoZSBrZXJuZWwgY2FuJ3QgcnVuIG9uIGEgbm9uLWZsYXQgc3RhY2sgaWYgcGFy
YXZpcnQgbW9kZQ0KQEAgLTY4MSwxMiArNjc3LDEyIEBAIHN5c2NhbGxfZmF1bHQ6DQogRU5EKHN5
c2NhbGxfZmF1bHQpDQogDQogc3lzY2FsbF9iYWRzeXM6DQotCW1vdmwgJC1FTk9TWVMsUFRfRUFY
KCVlc3ApDQotCWptcCBzeXNjYWxsX2V4aXQNCisJbW92bCAkLUVOT1NZUywlZWF4DQorCWptcCBz
eXNjYWxsX2FmdGVyX2NhbGwNCiBFTkQoc3lzY2FsbF9iYWRzeXMpDQogDQogc3lzZW50ZXJfYmFk
c3lzOg0KLQltb3ZsICQtRU5PU1lTLFBUX0VBWCglZXNwKQ0KKwltb3ZsICQtRU5PU1lTLCVlYXgN
CiAJam1wIHN5c2VudGVyX2FmdGVyX2NhbGwNCiBFTkQoc3lzY2FsbF9iYWRzeXMpDQogCUNGSV9F
TkRQUk9DDQpkaWZmIC0tZ2l0IGEvYXJjaC94ODYvbW0vaW9yZW1hcC5jIGIvYXJjaC94ODYvbW0v
aW9yZW1hcC5jDQppbmRleCBiZTFlZjU3Li5kZWM0OWQzIDEwMDY0NA0KLS0tIGEvYXJjaC94ODYv
bW0vaW9yZW1hcC5jDQorKysgYi9hcmNoL3g4Ni9tbS9pb3JlbWFwLmMNCkBAIC01MCw2ICs1MCwy
MSBAQCBpbnQgaW9yZW1hcF9jaGFuZ2VfYXR0cih1bnNpZ25lZCBsb25nIHZhZGRyLCB1bnNpZ25l
ZCBsb25nIHNpemUsDQogCXJldHVybiBlcnI7DQogfQ0KIA0KK3N0YXRpYyBpbnQgX19pb3JlbWFw
X2NoZWNrX3JhbSh1bnNpZ25lZCBsb25nIHN0YXJ0X3BmbiwgdW5zaWduZWQgbG9uZyBucl9wYWdl
cywNCisJCQkgICAgICAgdm9pZCAqYXJnKQ0KK3sNCisJdW5zaWduZWQgbG9uZyBpOw0KKw0KKwlm
b3IgKGkgPSAwOyBpIDwgbnJfcGFnZXM7ICsraSkNCisJCWlmIChwZm5fdmFsaWQoc3RhcnRfcGZu
ICsgaSkgJiYNCisJCSAgICAhUGFnZVJlc2VydmVkKHBmbl90b19wYWdlKHN0YXJ0X3BmbiArIGkp
KSkNCisJCQlyZXR1cm4gMTsNCisNCisJV0FSTl9PTkNFKDEsICJpb3JlbWFwIG9uIFJBTSBwZm4g
MHglbHhcbiIsIHN0YXJ0X3Bmbik7DQorDQorCXJldHVybiAwOw0KK30NCisNCiAvKg0KICAqIFJl
bWFwIGFuIGFyYml0cmFyeSBwaHlzaWNhbCBhZGRyZXNzIHNwYWNlIGludG8gdGhlIGtlcm5lbCB2
aXJ0dWFsDQogICogYWRkcmVzcyBzcGFjZS4gTmVlZGVkIHdoZW4gdGhlIGtlcm5lbCB3YW50cyB0
byBhY2Nlc3MgaGlnaCBhZGRyZXNzZXMNCkBAIC05MywxNCArMTA4LDExIEBAIHN0YXRpYyB2b2lk
IF9faW9tZW0gKl9faW9yZW1hcF9jYWxsZXIocmVzb3VyY2Vfc2l6ZV90IHBoeXNfYWRkciwNCiAJ
LyoNCiAJICogRG9uJ3QgYWxsb3cgYW55Ym9keSB0byByZW1hcCBub3JtYWwgUkFNIHRoYXQgd2Un
cmUgdXNpbmcuLg0KIAkgKi8NCisJcGZuICAgICAgPSBwaHlzX2FkZHIgPj4gUEFHRV9TSElGVDsN
CiAJbGFzdF9wZm4gPSBsYXN0X2FkZHIgPj4gUEFHRV9TSElGVDsNCi0JZm9yIChwZm4gPSBwaHlz
X2FkZHIgPj4gUEFHRV9TSElGVDsgcGZuIDw9IGxhc3RfcGZuOyBwZm4rKykgew0KLQkJaW50IGlz
X3JhbSA9IHBhZ2VfaXNfcmFtKHBmbik7DQotDQotCQlpZiAoaXNfcmFtICYmIHBmbl92YWxpZChw
Zm4pICYmICFQYWdlUmVzZXJ2ZWQocGZuX3RvX3BhZ2UocGZuKSkpDQotCQkJcmV0dXJuIE5VTEw7
DQotCQlXQVJOX09OX09OQ0UoaXNfcmFtKTsNCi0JfQ0KKwlpZiAod2Fsa19zeXN0ZW1fcmFtX3Jh
bmdlKHBmbiwgbGFzdF9wZm4gLSBwZm4gKyAxLCBOVUxMLA0KKwkJCQkgIF9faW9yZW1hcF9jaGVj
a19yYW0pID09IDEpDQorCQlyZXR1cm4gTlVMTDsNCiANCiAJLyoNCiAJICogTWFwcGluZ3MgaGF2
ZSB0byBiZSBwYWdlLWFsaWduZWQNCmRpZmYgLS1naXQgYS9jcnlwdG8vdGVzdG1nci5oIGIvY3J5
cHRvL3Rlc3RtZ3IuaA0KaW5kZXggMzdiNGQ4Zi4uYTRkZTRhZSAxMDA2NDQNCi0tLSBhL2NyeXB0
by90ZXN0bWdyLmgNCisrKyBiL2NyeXB0by90ZXN0bWdyLmgNCkBAIC0xMDQyOCwzOCArMTA0Mjgs
NDAgQEAgc3RhdGljIHN0cnVjdCBwY29tcF90ZXN0dmVjIHpsaWJfZGVjb21wX3R2X3RlbXBsYXRl
W10gPSB7DQogc3RhdGljIHN0cnVjdCBjb21wX3Rlc3R2ZWMgbHpvX2NvbXBfdHZfdGVtcGxhdGVb
XSA9IHsNCiAJew0KIAkJLmlubGVuCT0gNzAsDQotCQkub3V0bGVuCT0gNDYsDQorCQkub3V0bGVu
CT0gNTcsDQogCQkuaW5wdXQJPSAiSm9pbiB1cyBub3cgYW5kIHNoYXJlIHRoZSBzb2Z0d2FyZSAi
DQogCQkJIkpvaW4gdXMgbm93IGFuZCBzaGFyZSB0aGUgc29mdHdhcmUgIiwNCiAJCS5vdXRwdXQJ
PSAiXHgwMFx4MGRceDRhXHg2Zlx4NjlceDZlXHgyMFx4NzUiDQotCQkJIlx4NzNceDIwXHg2ZVx4
NmZceDc3XHgyMFx4NjFceDZlIg0KLQkJCSJceDY0XHgyMFx4NzNceDY4XHg2MVx4NzJceDY1XHgy
MCINCi0JCQkiXHg3NFx4NjhceDY1XHgyMFx4NzNceDZmXHg2Nlx4NzQiDQotCQkJIlx4NzdceDcw
XHgwMVx4MDFceDRhXHg2Zlx4NjlceDZlIg0KLQkJCSJceDNkXHg4OFx4MDBceDExXHgwMFx4MDAi
LA0KKwkJCSAgIlx4NzNceDIwXHg2ZVx4NmZceDc3XHgyMFx4NjFceDZlIg0KKwkJCSAgIlx4NjRc
eDIwXHg3M1x4NjhceDYxXHg3Mlx4NjVceDIwIg0KKwkJCSAgIlx4NzRceDY4XHg2NVx4MjBceDcz
XHg2Zlx4NjZceDc0Ig0KKwkJCSAgIlx4NzdceDcwXHgwMVx4MzJceDg4XHgwMFx4MGNceDY1Ig0K
KwkJCSAgIlx4MjBceDc0XHg2OFx4NjVceDIwXHg3M1x4NmZceDY2Ig0KKwkJCSAgIlx4NzRceDc3
XHg2MVx4NzJceDY1XHgyMFx4MTFceDAwIg0KKwkJCSAgIlx4MDAiLA0KIAl9LCB7DQogCQkuaW5s
ZW4JPSAxNTksDQotCQkub3V0bGVuCT0gMTMzLA0KKwkJLm91dGxlbgk9IDEzMSwNCiAJCS5pbnB1
dAk9ICJUaGlzIGRvY3VtZW50IGRlc2NyaWJlcyBhIGNvbXByZXNzaW9uIG1ldGhvZCBiYXNlZCBv
biB0aGUgTFpPICINCiAJCQkiY29tcHJlc3Npb24gYWxnb3JpdGhtLiAgVGhpcyBkb2N1bWVudCBk
ZWZpbmVzIHRoZSBhcHBsaWNhdGlvbiBvZiAiDQogCQkJInRoZSBMWk8gYWxnb3JpdGhtIHVzZWQg
aW4gVUJJRlMuIiwNCi0JCS5vdXRwdXQJPSAiXHgwMFx4MmJceDU0XHg2OFx4NjlceDczXHgyMFx4
NjQiDQorCQkub3V0cHV0CT0gIlx4MDBceDJjXHg1NFx4NjhceDY5XHg3M1x4MjBceDY0Ig0KIAkJ
CSAgIlx4NmZceDYzXHg3NVx4NmRceDY1XHg2ZVx4NzRceDIwIg0KIAkJCSAgIlx4NjRceDY1XHg3
M1x4NjNceDcyXHg2OVx4NjJceDY1Ig0KIAkJCSAgIlx4NzNceDIwXHg2MVx4MjBceDYzXHg2Zlx4
NmRceDcwIg0KIAkJCSAgIlx4NzJceDY1XHg3M1x4NzNceDY5XHg2Zlx4NmVceDIwIg0KIAkJCSAg
Ilx4NmRceDY1XHg3NFx4NjhceDZmXHg2NFx4MjBceDYyIg0KIAkJCSAgIlx4NjFceDczXHg2NVx4
NjRceDIwXHg2Zlx4NmVceDIwIg0KLQkJCSAgIlx4NzRceDY4XHg2NVx4MjBceDRjXHg1YVx4NGZc
eDJiIg0KLQkJCSAgIlx4OGNceDAwXHgwZFx4NjFceDZjXHg2N1x4NmZceDcyIg0KLQkJCSAgIlx4
NjlceDc0XHg2OFx4NmRceDJlXHgyMFx4MjBceDU0Ig0KLQkJCSAgIlx4NjhceDY5XHg3M1x4MmFc
eDU0XHgwMVx4MDJceDY2Ig0KLQkJCSAgIlx4NjlceDZlXHg2NVx4NzNceDk0XHgwNlx4MDVceDYx
Ig0KLQkJCSAgIlx4NzBceDcwXHg2Y1x4NjlceDYzXHg2MVx4NzRceDc2Ig0KLQkJCSAgIlx4MGFc
eDZmXHg2Nlx4ODhceDAyXHg2MFx4MDlceDI3Ig0KLQkJCSAgIlx4ZjBceDAwXHgwY1x4MjBceDc1
XHg3M1x4NjVceDY0Ig0KLQkJCSAgIlx4MjBceDY5XHg2ZVx4MjBceDU1XHg0Mlx4NDlceDQ2Ig0K
LQkJCSAgIlx4NTNceDJlXHgxMVx4MDBceDAwIiwNCisJCQkgICJceDc0XHg2OFx4NjVceDIwXHg0
Y1x4NWFceDRmXHgyMCINCisJCQkgICJceDJhXHg4Y1x4MDBceDA5XHg2MVx4NmNceDY3XHg2ZiIN
CisJCQkgICJceDcyXHg2OVx4NzRceDY4XHg2ZFx4MmVceDIwXHgyMCINCisJCQkgICJceDJlXHg1
NFx4MDFceDAzXHg2Nlx4NjlceDZlXHg2NSINCisJCQkgICJceDczXHgyMFx4NzRceDA2XHgwNVx4
NjFceDcwXHg3MCINCisJCQkgICJceDZjXHg2OVx4NjNceDYxXHg3NFx4NzZceDBhXHg2ZiINCisJ
CQkgICJceDY2XHg4OFx4MDJceDYwXHgwOVx4MjdceGYwXHgwMCINCisJCQkgICJceDBjXHgyMFx4
NzVceDczXHg2NVx4NjRceDIwXHg2OSINCisJCQkgICJceDZlXHgyMFx4NTVceDQyXHg0OVx4NDZc
eDUzXHgyZSINCisJCQkgICJceDExXHgwMFx4MDAiLA0KIAl9LA0KIH07DQogDQpkaWZmIC0tZ2l0
IGEvZHJpdmVycy9hY3BpL2JhdHRlcnkuYyBiL2RyaXZlcnMvYWNwaS9iYXR0ZXJ5LmMNCmluZGV4
IGM3NDliOTMuLmE3OTMzMmEgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL2FjcGkvYmF0dGVyeS5jDQor
KysgYi9kcml2ZXJzL2FjcGkvYmF0dGVyeS5jDQpAQCAtMzQsNiArMzQsNyBAQA0KICNpbmNsdWRl
IDxsaW51eC9kbWkuaD4NCiAjaW5jbHVkZSA8bGludXgvc2xhYi5oPg0KICNpbmNsdWRlIDxsaW51
eC9zdXNwZW5kLmg+DQorI2luY2x1ZGUgPGxpbnV4L2RlbGF5Lmg+DQogI2luY2x1ZGUgPGFzbS91
bmFsaWduZWQuaD4NCiANCiAjaWZkZWYgQ09ORklHX0FDUElfUFJPQ0ZTX1BPV0VSDQpAQCAtMTA1
NSw2ICsxMDU2LDI4IEBAIHN0YXRpYyBpbnQgYmF0dGVyeV9ub3RpZnkoc3RydWN0IG5vdGlmaWVy
X2Jsb2NrICpuYiwNCiAJcmV0dXJuIDA7DQogfQ0KIA0KKy8qDQorICogU29tZSBtYWNoaW5lcyco
RSxHIExlbm92byBaNDgwKSBFQ3MgYXJlIG5vdCBzdGFibGUNCisgKiBkdXJpbmcgYm9vdCB1cCBh
bmQgdGhpcyBjYXVzZXMgYmF0dGVyeSBkcml2ZXIgZmFpbHMgdG8gYmUNCisgKiBwcm9iZWQgZHVl
IHRvIGZhaWx1cmUgb2YgZ2V0dGluZyBiYXR0ZXJ5IGluZm9ybWF0aW9uDQorICogZnJvbSBFQyBz
b21ldGltZXMuIEFmdGVyIHNldmVyYWwgcmV0cmllcywgdGhlIG9wZXJhdGlvbg0KKyAqIG1heSB3
b3JrLiBTbyBhZGQgcmV0cnkgY29kZSBoZXJlIGFuZCAyMG1zIHNsZWVwIGJldHdlZW4NCisgKiBl
dmVyeSByZXRyaWVzLg0KKyAqLw0KK3N0YXRpYyBpbnQgYWNwaV9iYXR0ZXJ5X3VwZGF0ZV9yZXRy
eShzdHJ1Y3QgYWNwaV9iYXR0ZXJ5ICpiYXR0ZXJ5KQ0KK3sNCisJaW50IHJldHJ5LCByZXQ7DQor
DQorCWZvciAocmV0cnkgPSA1OyByZXRyeTsgcmV0cnktLSkgew0KKwkJcmV0ID0gYWNwaV9iYXR0
ZXJ5X3VwZGF0ZShiYXR0ZXJ5KTsNCisJCWlmICghcmV0KQ0KKwkJCWJyZWFrOw0KKw0KKwkJbXNs
ZWVwKDIwKTsNCisJfQ0KKwlyZXR1cm4gcmV0Ow0KK30NCisNCiBzdGF0aWMgaW50IGFjcGlfYmF0
dGVyeV9hZGQoc3RydWN0IGFjcGlfZGV2aWNlICpkZXZpY2UpDQogew0KIAlpbnQgcmVzdWx0ID0g
MDsNCkBAIC0xMDc0LDkgKzEwOTcsMTEgQEAgc3RhdGljIGludCBhY3BpX2JhdHRlcnlfYWRkKHN0
cnVjdCBhY3BpX2RldmljZSAqZGV2aWNlKQ0KIAlpZiAoQUNQSV9TVUNDRVNTKGFjcGlfZ2V0X2hh
bmRsZShiYXR0ZXJ5LT5kZXZpY2UtPmhhbmRsZSwNCiAJCQkiX0JJWCIsICZoYW5kbGUpKSkNCiAJ
CXNldF9iaXQoQUNQSV9CQVRURVJZX1hJTkZPX1BSRVNFTlQsICZiYXR0ZXJ5LT5mbGFncyk7DQot
CXJlc3VsdCA9IGFjcGlfYmF0dGVyeV91cGRhdGUoYmF0dGVyeSk7DQorDQorCXJlc3VsdCA9IGFj
cGlfYmF0dGVyeV91cGRhdGVfcmV0cnkoYmF0dGVyeSk7DQogCWlmIChyZXN1bHQpDQogCQlnb3Rv
IGZhaWw7DQorDQogI2lmZGVmIENPTkZJR19BQ1BJX1BST0NGU19QT1dFUg0KIAlyZXN1bHQgPSBh
Y3BpX2JhdHRlcnlfYWRkX2ZzKGRldmljZSk7DQogI2VuZGlmDQpkaWZmIC0tZ2l0IGEvZHJpdmVy
cy9hY3BpL2VjLmMgYi9kcml2ZXJzL2FjcGkvZWMuYw0KaW5kZXggMzkyMzA2NC4uNDhmZDE1OCAx
MDA2NDQNCi0tLSBhL2RyaXZlcnMvYWNwaS9lYy5jDQorKysgYi9kcml2ZXJzL2FjcGkvZWMuYw0K
QEAgLTgxLDYgKzgxLDkgQEAgZW51bSB7DQogCUVDX0ZMQUdTX0JMT0NLRUQsCQkvKiBUcmFuc2Fj
dGlvbnMgYXJlIGJsb2NrZWQgKi8NCiB9Ow0KIA0KKyNkZWZpbmUgQUNQSV9FQ19DT01NQU5EX1BP
TEwJCTB4MDEgLyogQXZhaWxhYmxlIGZvciBjb21tYW5kIGJ5dGUgKi8NCisjZGVmaW5lIEFDUElf
RUNfQ09NTUFORF9DT01QTEVURQkweDAyIC8qIENvbXBsZXRlZCBsYXN0IGJ5dGUgKi8NCisNCiAv
KiBlYy5jIGlzIGNvbXBpbGVkIGluIGFjcGkgbmFtZXNwYWNlIHNvIHRoaXMgc2hvd3MgdXAgYXMg
YWNwaS5lY19kZWxheSBwYXJhbSAqLw0KIHN0YXRpYyB1bnNpZ25lZCBpbnQgZWNfZGVsYXkgX19y
ZWFkX21vc3RseSA9IEFDUElfRUNfREVMQVk7DQogbW9kdWxlX3BhcmFtKGVjX2RlbGF5LCB1aW50
LCAwNjQ0KTsNCkBAIC0xMTYsNyArMTE5LDcgQEAgc3RydWN0IHRyYW5zYWN0aW9uIHsNCiAJdTgg
cmk7DQogCXU4IHdsZW47DQogCXU4IHJsZW47DQotCWJvb2wgZG9uZTsNCisJdTggZmxhZ3M7DQog
fTsNCiANCiBzdHJ1Y3QgYWNwaV9lYyAqYm9vdF9lYywgKmZpcnN0X2VjOw0KQEAgLTE1Nyw1MyAr
MTYwLDc0IEBAIHN0YXRpYyBpbmxpbmUgdm9pZCBhY3BpX2VjX3dyaXRlX2RhdGEoc3RydWN0IGFj
cGlfZWMgKmVjLCB1OCBkYXRhKQ0KIAlvdXRiKGRhdGEsIGVjLT5kYXRhX2FkZHIpOw0KIH0NCiAN
Ci1zdGF0aWMgaW50IGVjX3RyYW5zYWN0aW9uX2RvbmUoc3RydWN0IGFjcGlfZWMgKmVjKQ0KK3N0
YXRpYyBpbnQgZWNfdHJhbnNhY3Rpb25fY29tcGxldGVkKHN0cnVjdCBhY3BpX2VjICplYykNCiB7
DQogCXVuc2lnbmVkIGxvbmcgZmxhZ3M7DQogCWludCByZXQgPSAwOw0KIAlzcGluX2xvY2tfaXJx
c2F2ZSgmZWMtPmN1cnJfbG9jaywgZmxhZ3MpOw0KLQlpZiAoIWVjLT5jdXJyIHx8IGVjLT5jdXJy
LT5kb25lKQ0KKwlpZiAoZWMtPmN1cnIgJiYgKGVjLT5jdXJyLT5mbGFncyAmIEFDUElfRUNfQ09N
TUFORF9DT01QTEVURSkpDQogCQlyZXQgPSAxOw0KIAlzcGluX3VubG9ja19pcnFyZXN0b3JlKCZl
Yy0+Y3Vycl9sb2NrLCBmbGFncyk7DQogCXJldHVybiByZXQ7DQogfQ0KIA0KLXN0YXRpYyB2b2lk
IHN0YXJ0X3RyYW5zYWN0aW9uKHN0cnVjdCBhY3BpX2VjICplYykNCitzdGF0aWMgYm9vbCBhZHZh
bmNlX3RyYW5zYWN0aW9uKHN0cnVjdCBhY3BpX2VjICplYykNCiB7DQotCWVjLT5jdXJyLT5pcnFf
Y291bnQgPSBlYy0+Y3Vyci0+d2kgPSBlYy0+Y3Vyci0+cmkgPSAwOw0KLQllYy0+Y3Vyci0+ZG9u
ZSA9IGZhbHNlOw0KLQlhY3BpX2VjX3dyaXRlX2NtZChlYywgZWMtPmN1cnItPmNvbW1hbmQpOw0K
LX0NCi0NCi1zdGF0aWMgdm9pZCBhZHZhbmNlX3RyYW5zYWN0aW9uKHN0cnVjdCBhY3BpX2VjICpl
YywgdTggc3RhdHVzKQ0KLXsNCi0JdW5zaWduZWQgbG9uZyBmbGFnczsNCi0Jc3Bpbl9sb2NrX2ly
cXNhdmUoJmVjLT5jdXJyX2xvY2ssIGZsYWdzKTsNCi0JaWYgKCFlYy0+Y3VycikNCi0JCWdvdG8g
dW5sb2NrOw0KLQlpZiAoZWMtPmN1cnItPndsZW4gPiBlYy0+Y3Vyci0+d2kpIHsNCi0JCWlmICgo
c3RhdHVzICYgQUNQSV9FQ19GTEFHX0lCRikgPT0gMCkNCi0JCQlhY3BpX2VjX3dyaXRlX2RhdGEo
ZWMsDQotCQkJCWVjLT5jdXJyLT53ZGF0YVtlYy0+Y3Vyci0+d2krK10pOw0KLQkJZWxzZQ0KLQkJ
CWdvdG8gZXJyOw0KLQl9IGVsc2UgaWYgKGVjLT5jdXJyLT5ybGVuID4gZWMtPmN1cnItPnJpKSB7
DQotCQlpZiAoKHN0YXR1cyAmIEFDUElfRUNfRkxBR19PQkYpID09IDEpIHsNCi0JCQllYy0+Y3Vy
ci0+cmRhdGFbZWMtPmN1cnItPnJpKytdID0gYWNwaV9lY19yZWFkX2RhdGEoZWMpOw0KLQkJCWlm
IChlYy0+Y3Vyci0+cmxlbiA9PSBlYy0+Y3Vyci0+cmkpDQotCQkJCWVjLT5jdXJyLT5kb25lID0g
dHJ1ZTsNCisJc3RydWN0IHRyYW5zYWN0aW9uICp0Ow0KKwl1OCBzdGF0dXM7DQorCWJvb2wgd2Fr
ZXVwID0gZmFsc2U7DQorDQorCXByX2RlYnVnKFBSRUZJWCAiPT09PT0gJXMgPT09PT1cbiIsIGlu
X2ludGVycnVwdCgpID8gIklSUSIgOiAiVEFTSyIpOw0KKwlzdGF0dXMgPSBhY3BpX2VjX3JlYWRf
c3RhdHVzKGVjKTsNCisJdCA9IGVjLT5jdXJyOw0KKwlpZiAoIXQpDQorCQlnb3RvIGVycjsNCisJ
aWYgKHQtPmZsYWdzICYgQUNQSV9FQ19DT01NQU5EX1BPTEwpIHsNCisJCWlmICh0LT53bGVuID4g
dC0+d2kpIHsNCisJCQlpZiAoKHN0YXR1cyAmIEFDUElfRUNfRkxBR19JQkYpID09IDApDQorCQkJ
CWFjcGlfZWNfd3JpdGVfZGF0YShlYywgdC0+d2RhdGFbdC0+d2krK10pOw0KKwkJCWVsc2UNCisJ
CQkJZ290byBlcnI7DQorCQl9IGVsc2UgaWYgKHQtPnJsZW4gPiB0LT5yaSkgew0KKwkJCWlmICgo
c3RhdHVzICYgQUNQSV9FQ19GTEFHX09CRikgPT0gMSkgew0KKwkJCQl0LT5yZGF0YVt0LT5yaSsr
XSA9IGFjcGlfZWNfcmVhZF9kYXRhKGVjKTsNCisJCQkJaWYgKHQtPnJsZW4gPT0gdC0+cmkpIHsN
CisJCQkJCXQtPmZsYWdzIHw9IEFDUElfRUNfQ09NTUFORF9DT01QTEVURTsNCisJCQkJCXdha2V1
cCA9IHRydWU7DQorCQkJCX0NCisJCQl9IGVsc2UNCisJCQkJZ290byBlcnI7DQorCQl9IGVsc2Ug
aWYgKHQtPndsZW4gPT0gdC0+d2kgJiYNCisJCQkgICAoc3RhdHVzICYgQUNQSV9FQ19GTEFHX0lC
RikgPT0gMCkgew0KKwkJCXQtPmZsYWdzIHw9IEFDUElfRUNfQ09NTUFORF9DT01QTEVURTsNCisJ
CQl3YWtldXAgPSB0cnVlOw0KKwkJfQ0KKwkJcmV0dXJuIHdha2V1cDsNCisJfSBlbHNlIHsNCisJ
CWlmICgoc3RhdHVzICYgQUNQSV9FQ19GTEFHX0lCRikgPT0gMCkgew0KKwkJCWFjcGlfZWNfd3Jp
dGVfY21kKGVjLCB0LT5jb21tYW5kKTsNCisJCQl0LT5mbGFncyB8PSBBQ1BJX0VDX0NPTU1BTkRf
UE9MTDsNCiAJCX0gZWxzZQ0KIAkJCWdvdG8gZXJyOw0KLQl9IGVsc2UgaWYgKGVjLT5jdXJyLT53
bGVuID09IGVjLT5jdXJyLT53aSAmJg0KLQkJICAgKHN0YXR1cyAmIEFDUElfRUNfRkxBR19JQkYp
ID09IDApDQotCQllYy0+Y3Vyci0+ZG9uZSA9IHRydWU7DQotCWdvdG8gdW5sb2NrOw0KKwkJcmV0
dXJuIHdha2V1cDsNCisJfQ0KIGVycjoNCi0JLyogZmFsc2UgaW50ZXJydXB0LCBzdGF0ZSBkaWRu
J3QgY2hhbmdlICovDQotCWlmIChpbl9pbnRlcnJ1cHQoKSkNCi0JCSsrZWMtPmN1cnItPmlycV9j
b3VudDsNCi11bmxvY2s6DQotCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJmVjLT5jdXJyX2xvY2ss
IGZsYWdzKTsNCisJLyoNCisJICogSWYgU0NJIGJpdCBpcyBzZXQsIHRoZW4gZG9uJ3QgdGhpbmsg
aXQncyBhIGZhbHNlIElSUQ0KKwkgKiBvdGhlcndpc2Ugd2lsbCB0YWtlIGEgbm90IGhhbmRsZWQg
SVJRIGFzIGEgZmFsc2Ugb25lLg0KKwkgKi8NCisJaWYgKCEoc3RhdHVzICYgQUNQSV9FQ19GTEFH
X1NDSSkpIHsNCisJCWlmIChpbl9pbnRlcnJ1cHQoKSAmJiB0KQ0KKwkJCSsrdC0+aXJxX2NvdW50
Ow0KKwl9DQorCXJldHVybiB3YWtldXA7DQorfQ0KKw0KK3N0YXRpYyB2b2lkIHN0YXJ0X3RyYW5z
YWN0aW9uKHN0cnVjdCBhY3BpX2VjICplYykNCit7DQorCWVjLT5jdXJyLT5pcnFfY291bnQgPSBl
Yy0+Y3Vyci0+d2kgPSBlYy0+Y3Vyci0+cmkgPSAwOw0KKwllYy0+Y3Vyci0+ZmxhZ3MgPSAwOw0K
Kwkodm9pZClhZHZhbmNlX3RyYW5zYWN0aW9uKGVjKTsNCiB9DQogDQogc3RhdGljIGludCBhY3Bp
X2VjX3N5bmNfcXVlcnkoc3RydWN0IGFjcGlfZWMgKmVjLCB1OCAqZGF0YSk7DQpAQCAtMjI4LDE1
ICsyNTIsMTcgQEAgc3RhdGljIGludCBlY19wb2xsKHN0cnVjdCBhY3BpX2VjICplYykNCiAJCQkv
KiBkb24ndCBzbGVlcCB3aXRoIGRpc2FibGVkIGludGVycnVwdHMgKi8NCiAJCQlpZiAoRUNfRkxB
R1NfTVNJIHx8IGlycXNfZGlzYWJsZWQoKSkgew0KIAkJCQl1ZGVsYXkoQUNQSV9FQ19NU0lfVURF
TEFZKTsNCi0JCQkJaWYgKGVjX3RyYW5zYWN0aW9uX2RvbmUoZWMpKQ0KKwkJCQlpZiAoZWNfdHJh
bnNhY3Rpb25fY29tcGxldGVkKGVjKSkNCiAJCQkJCXJldHVybiAwOw0KIAkJCX0gZWxzZSB7DQog
CQkJCWlmICh3YWl0X2V2ZW50X3RpbWVvdXQoZWMtPndhaXQsDQotCQkJCQkJZWNfdHJhbnNhY3Rp
b25fZG9uZShlYyksDQorCQkJCQkJZWNfdHJhbnNhY3Rpb25fY29tcGxldGVkKGVjKSwNCiAJCQkJ
CQltc2Vjc190b19qaWZmaWVzKDEpKSkNCiAJCQkJCXJldHVybiAwOw0KIAkJCX0NCi0JCQlhZHZh
bmNlX3RyYW5zYWN0aW9uKGVjLCBhY3BpX2VjX3JlYWRfc3RhdHVzKGVjKSk7DQorCQkJc3Bpbl9s
b2NrX2lycXNhdmUoJmVjLT5jdXJyX2xvY2ssIGZsYWdzKTsNCisJCQkodm9pZClhZHZhbmNlX3Ry
YW5zYWN0aW9uKGVjKTsNCisJCQlzcGluX3VubG9ja19pcnFyZXN0b3JlKCZlYy0+Y3Vycl9sb2Nr
LCBmbGFncyk7DQogCQl9IHdoaWxlICh0aW1lX2JlZm9yZShqaWZmaWVzLCBkZWxheSkpOw0KIAkJ
cHJfZGVidWcoUFJFRklYICJjb250cm9sbGVyIHJlc2V0LCByZXN0YXJ0IHRyYW5zYWN0aW9uXG4i
KTsNCiAJCXNwaW5fbG9ja19pcnFzYXZlKCZlYy0+Y3Vycl9sb2NrLCBmbGFncyk7DQpAQCAtMjY4
LDIzICsyOTQsNiBAQCBzdGF0aWMgaW50IGFjcGlfZWNfdHJhbnNhY3Rpb25fdW5sb2NrZWQoc3Ry
dWN0IGFjcGlfZWMgKmVjLA0KIAlyZXR1cm4gcmV0Ow0KIH0NCiANCi1zdGF0aWMgaW50IGVjX2No
ZWNrX2liZjAoc3RydWN0IGFjcGlfZWMgKmVjKQ0KLXsNCi0JdTggc3RhdHVzID0gYWNwaV9lY19y
ZWFkX3N0YXR1cyhlYyk7DQotCXJldHVybiAoc3RhdHVzICYgQUNQSV9FQ19GTEFHX0lCRikgPT0g
MDsNCi19DQotDQotc3RhdGljIGludCBlY193YWl0X2liZjAoc3RydWN0IGFjcGlfZWMgKmVjKQ0K
LXsNCi0JdW5zaWduZWQgbG9uZyBkZWxheSA9IGppZmZpZXMgKyBtc2Vjc190b19qaWZmaWVzKGVj
X2RlbGF5KTsNCi0JLyogaW50ZXJydXB0IHdhaXQgbWFudWFsbHkgaWYgR1BFIG1vZGUgaXMgbm90
IGFjdGl2ZSAqLw0KLQl3aGlsZSAodGltZV9iZWZvcmUoamlmZmllcywgZGVsYXkpKQ0KLQkJaWYg
KHdhaXRfZXZlbnRfdGltZW91dChlYy0+d2FpdCwgZWNfY2hlY2tfaWJmMChlYyksDQotCQkJCQlt
c2Vjc190b19qaWZmaWVzKDEpKSkNCi0JCQlyZXR1cm4gMDsNCi0JcmV0dXJuIC1FVElNRTsNCi19
DQotDQogc3RhdGljIGludCBhY3BpX2VjX3RyYW5zYWN0aW9uKHN0cnVjdCBhY3BpX2VjICplYywg
c3RydWN0IHRyYW5zYWN0aW9uICp0KQ0KIHsNCiAJaW50IHN0YXR1czsNCkBAIC0zMDUsMTMgKzMx
NCw4IEBAIHN0YXRpYyBpbnQgYWNwaV9lY190cmFuc2FjdGlvbihzdHJ1Y3QgYWNwaV9lYyAqZWMs
IHN0cnVjdCB0cmFuc2FjdGlvbiAqdCkNCiAJCQlnb3RvIHVubG9jazsNCiAJCX0NCiAJfQ0KLQlp
ZiAoZWNfd2FpdF9pYmYwKGVjKSkgew0KLQkJcHJfZXJyKFBSRUZJWCAiaW5wdXQgYnVmZmVyIGlz
IG5vdCBlbXB0eSwgIg0KLQkJCQkiYWJvcnRpbmcgdHJhbnNhY3Rpb25cbiIpOw0KLQkJc3RhdHVz
ID0gLUVUSU1FOw0KLQkJZ290byBlbmQ7DQotCX0NCi0JcHJfZGVidWcoUFJFRklYICJ0cmFuc2Fj
dGlvbiBzdGFydFxuIik7DQorCXByX2RlYnVnKFBSRUZJWCAidHJhbnNhY3Rpb24gc3RhcnQgKGNt
ZD0weCUwMngsIGFkZHI9MHglMDJ4KVxuIiwNCisJCQl0LT5jb21tYW5kLCB0LT53ZGF0YSA/IHQt
PndkYXRhWzBdIDogMCk7DQogCS8qIGRpc2FibGUgR1BFIGR1cmluZyB0cmFuc2FjdGlvbiBpZiBz
dG9ybSBpcyBkZXRlY3RlZCAqLw0KIAlpZiAodGVzdF9iaXQoRUNfRkxBR1NfR1BFX1NUT1JNLCAm
ZWMtPmZsYWdzKSkgew0KIAkJLyogSXQgaGFzIHRvIGJlIGRpc2FibGVkLCBzbyB0aGF0IGl0IGRv
ZXNuJ3QgdHJpZ2dlci4gKi8NCkBAIC0zMjcsMTIgKzMzMSwxMiBAQCBzdGF0aWMgaW50IGFjcGlf
ZWNfdHJhbnNhY3Rpb24oc3RydWN0IGFjcGlfZWMgKmVjLCBzdHJ1Y3QgdHJhbnNhY3Rpb24gKnQp
DQogCQkvKiBJdCBpcyBzYWZlIHRvIGVuYWJsZSB0aGUgR1BFIG91dHNpZGUgb2YgdGhlIHRyYW5z
YWN0aW9uLiAqLw0KIAkJYWNwaV9lbmFibGVfZ3BlKE5VTEwsIGVjLT5ncGUpOw0KIAl9IGVsc2Ug
aWYgKHQtPmlycV9jb3VudCA+IGVjX3N0b3JtX3RocmVzaG9sZCkgew0KLQkJcHJfaW5mbyhQUkVG
SVggIkdQRSBzdG9ybSBkZXRlY3RlZCwgIg0KLQkJCSJ0cmFuc2FjdGlvbnMgd2lsbCB1c2UgcG9s
bGluZyBtb2RlXG4iKTsNCisJCXByX2luZm8oUFJFRklYICJHUEUgc3Rvcm0gZGV0ZWN0ZWQoJWQg
R1BFcyksICINCisJCQkidHJhbnNhY3Rpb25zIHdpbGwgdXNlIHBvbGxpbmcgbW9kZVxuIiwNCisJ
CQl0LT5pcnFfY291bnQpOw0KIAkJc2V0X2JpdChFQ19GTEFHU19HUEVfU1RPUk0sICZlYy0+Zmxh
Z3MpOw0KIAl9DQogCXByX2RlYnVnKFBSRUZJWCAidHJhbnNhY3Rpb24gZW5kXG4iKTsNCi1lbmQ6
DQogCWlmIChlYy0+Z2xvYmFsX2xvY2spDQogCQlhY3BpX3JlbGVhc2VfZ2xvYmFsX2xvY2soZ2xr
KTsNCiB1bmxvY2s6DQpAQCAtNDA0LDcgKzQwOCw3IEBAIGludCBlY19idXJzdF9kaXNhYmxlKHZv
aWQpDQogDQogRVhQT1JUX1NZTUJPTChlY19idXJzdF9kaXNhYmxlKTsNCiANCi1pbnQgZWNfcmVh
ZCh1OCBhZGRyLCB1OCAqIHZhbCkNCitpbnQgZWNfcmVhZCh1OCBhZGRyLCB1OCAqdmFsKQ0KIHsN
CiAJaW50IGVycjsNCiAJdTggdGVtcF9kYXRhOw0KQEAgLTY0MiwxNiArNjQ2LDE0IEBAIHN0YXRp
YyBpbnQgZWNfY2hlY2tfc2NpKHN0cnVjdCBhY3BpX2VjICplYywgdTggc3RhdGUpDQogc3RhdGlj
IHUzMiBhY3BpX2VjX2dwZV9oYW5kbGVyKGFjcGlfaGFuZGxlIGdwZV9kZXZpY2UsDQogCXUzMiBn
cGVfbnVtYmVyLCB2b2lkICpkYXRhKQ0KIHsNCisJdW5zaWduZWQgbG9uZyBmbGFnczsNCiAJc3Ry
dWN0IGFjcGlfZWMgKmVjID0gZGF0YTsNCiANCi0JcHJfZGVidWcoUFJFRklYICJ+fn4+IGludGVy
cnVwdFxuIik7DQotDQotCWFkdmFuY2VfdHJhbnNhY3Rpb24oZWMsIGFjcGlfZWNfcmVhZF9zdGF0
dXMoZWMpKTsNCi0JaWYgKGVjX3RyYW5zYWN0aW9uX2RvbmUoZWMpICYmDQotCSAgICAoYWNwaV9l
Y19yZWFkX3N0YXR1cyhlYykgJiBBQ1BJX0VDX0ZMQUdfSUJGKSA9PSAwKSB7DQorCXNwaW5fbG9j
a19pcnFzYXZlKCZlYy0+Y3Vycl9sb2NrLCBmbGFncyk7DQorCWlmIChhZHZhbmNlX3RyYW5zYWN0
aW9uKGVjKSkNCiAJCXdha2VfdXAoJmVjLT53YWl0KTsNCi0JCWVjX2NoZWNrX3NjaShlYywgYWNw
aV9lY19yZWFkX3N0YXR1cyhlYykpOw0KLQl9DQorCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJmVj
LT5jdXJyX2xvY2ssIGZsYWdzKTsNCisJZWNfY2hlY2tfc2NpKGVjLCBhY3BpX2VjX3JlYWRfc3Rh
dHVzKGVjKSk7DQogCXJldHVybiBBQ1BJX0lOVEVSUlVQVF9IQU5ETEVEIHwgQUNQSV9SRUVOQUJM
RV9HUEU7DQogfQ0KIA0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvYXRhL2xpYmF0YS1jb3JlLmMgYi9k
cml2ZXJzL2F0YS9saWJhdGEtY29yZS5jDQppbmRleCAyYjY2MjcyNS4uMmRkZjczNiAxMDA2NDQN
Ci0tLSBhL2RyaXZlcnMvYXRhL2xpYmF0YS1jb3JlLmMNCisrKyBiL2RyaXZlcnMvYXRhL2xpYmF0
YS1jb3JlLmMNCkBAIC00NzExLDYgKzQ3MTEsMTAgQEAgdm9pZCBzd2FwX2J1Zl9sZTE2KHUxNiAq
YnVmLCB1bnNpZ25lZCBpbnQgYnVmX3dvcmRzKQ0KICAqCWF0YV9xY19uZXcgLSBSZXF1ZXN0IGFu
IGF2YWlsYWJsZSBBVEEgY29tbWFuZCwgZm9yIHF1ZXVlaW5nDQogICoJQGFwOiB0YXJnZXQgcG9y
dA0KICAqDQorICoJU29tZSBBVEEgaG9zdCBjb250cm9sbGVycyBtYXkgaW1wbGVtZW50IGEgcXVl
dWUgZGVwdGggd2hpY2ggaXMgbGVzcw0KKyAqCXRoYW4gQVRBX01BWF9RVUVVRS4gU28gd2Ugc2hv
dWxkbid0IGFsbG9jYXRlIGEgdGFnIHdoaWNoIGlzIGJleW9uZA0KKyAqCXRoZSBoYXJkd2FyZSBs
aW1pdGF0aW9uLg0KKyAqDQogICoJTE9DS0lORzoNCiAgKglOb25lLg0KICAqLw0KQEAgLTQ3MTgs
MTQgKzQ3MjIsMTUgQEAgdm9pZCBzd2FwX2J1Zl9sZTE2KHUxNiAqYnVmLCB1bnNpZ25lZCBpbnQg
YnVmX3dvcmRzKQ0KIHN0YXRpYyBzdHJ1Y3QgYXRhX3F1ZXVlZF9jbWQgKmF0YV9xY19uZXcoc3Ry
dWN0IGF0YV9wb3J0ICphcCkNCiB7DQogCXN0cnVjdCBhdGFfcXVldWVkX2NtZCAqcWMgPSBOVUxM
Ow0KKwl1bnNpZ25lZCBpbnQgbWF4X3F1ZXVlID0gYXAtPmhvc3QtPm5fdGFnczsNCiAJdW5zaWdu
ZWQgaW50IGksIHRhZzsNCiANCiAJLyogbm8gY29tbWFuZCB3aGlsZSBmcm96ZW4gKi8NCiAJaWYg
KHVubGlrZWx5KGFwLT5wZmxhZ3MgJiBBVEFfUEZMQUdfRlJPWkVOKSkNCiAJCXJldHVybiBOVUxM
Ow0KIA0KLQlmb3IgKGkgPSAwOyBpIDwgQVRBX01BWF9RVUVVRTsgaSsrKSB7DQotCQl0YWcgPSAo
aSArIGFwLT5sYXN0X3RhZyArIDEpICUgQVRBX01BWF9RVUVVRTsNCisJZm9yIChpID0gMCwgdGFn
ID0gYXAtPmxhc3RfdGFnICsgMTsgaSA8IG1heF9xdWV1ZTsgaSsrLCB0YWcrKykgew0KKwkJdGFn
ID0gdGFnIDwgbWF4X3F1ZXVlID8gdGFnIDogMDsNCiANCiAJCS8qIHRoZSBsYXN0IHRhZyBpcyBy
ZXNlcnZlZCBmb3IgaW50ZXJuYWwgY29tbWFuZC4gKi8NCiAJCWlmICh0YWcgPT0gQVRBX1RBR19J
TlRFUk5BTCkNCkBAIC01OTE4LDYgKzU5MjMsNyBAQCB2b2lkIGF0YV9ob3N0X2luaXQoc3RydWN0
IGF0YV9ob3N0ICpob3N0LCBzdHJ1Y3QgZGV2aWNlICpkZXYsDQogew0KIAlzcGluX2xvY2tfaW5p
dCgmaG9zdC0+bG9jayk7DQogCW11dGV4X2luaXQoJmhvc3QtPmVoX211dGV4KTsNCisJaG9zdC0+
bl90YWdzID0gQVRBX01BWF9RVUVVRSAtIDE7DQogCWhvc3QtPmRldiA9IGRldjsNCiAJaG9zdC0+
ZmxhZ3MgPSBmbGFnczsNCiAJaG9zdC0+b3BzID0gb3BzOw0KQEAgLTU5OTgsNiArNjAwNCw4IEBA
IGludCBhdGFfaG9zdF9yZWdpc3RlcihzdHJ1Y3QgYXRhX2hvc3QgKmhvc3QsIHN0cnVjdCBzY3Np
X2hvc3RfdGVtcGxhdGUgKnNodCkNCiB7DQogCWludCBpLCByYzsNCiANCisJaG9zdC0+bl90YWdz
ID0gY2xhbXAoc2h0LT5jYW5fcXVldWUsIDEsIEFUQV9NQVhfUVVFVUUgLSAxKTsNCisNCiAJLyog
aG9zdCBtdXN0IGhhdmUgYmVlbiBzdGFydGVkICovDQogCWlmICghKGhvc3QtPmZsYWdzICYgQVRB
X0hPU1RfU1RBUlRFRCkpIHsNCiAJCWRldl9lcnIoaG9zdC0+ZGV2LCAiQlVHOiB0cnlpbmcgdG8g
cmVnaXN0ZXIgdW5zdGFydGVkIGhvc3RcbiIpOw0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvY2hhci9h
cHBsaWNvbS5jIGIvZHJpdmVycy9jaGFyL2FwcGxpY29tLmMNCmluZGV4IDI1MzczZGYuLjVkMDY5
YzcgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL2NoYXIvYXBwbGljb20uYw0KKysrIGIvZHJpdmVycy9j
aGFyL2FwcGxpY29tLmMNCkBAIC0zNDUsNyArMzQ1LDYgQEAgb3V0Og0KIAkJCWZyZWVfaXJxKGFw
YnNbaV0uaXJxLCAmZHVtbXkpOw0KIAkJaW91bm1hcChhcGJzW2ldLlJhbUlPKTsNCiAJfQ0KLQlw
Y2lfZGlzYWJsZV9kZXZpY2UoZGV2KTsNCiAJcmV0dXJuIHJldDsNCiB9DQogDQpkaWZmIC0tZ2l0
IGEvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9hdG9tYmlvc19kcC5jIGIvZHJpdmVycy9ncHUvZHJt
L3JhZGVvbi9hdG9tYmlvc19kcC5jDQppbmRleCAzMjU0ZDUxZS4uZThhM2MzMSAxMDA2NDQNCi0t
LSBhL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vYXRvbWJpb3NfZHAuYw0KKysrIGIvZHJpdmVycy9n
cHUvZHJtL3JhZGVvbi9hdG9tYmlvc19kcC5jDQpAQCAtODksNyArODksNyBAQCBzdGF0aWMgaW50
IHJhZGVvbl9wcm9jZXNzX2F1eF9jaChzdHJ1Y3QgcmFkZW9uX2kyY19jaGFuICpjaGFuLA0KIAkv
KiBmbGFncyBub3QgemVybyAqLw0KIAlpZiAoYXJncy52MS51Y1JlcGx5U3RhdHVzID09IDIpIHsN
CiAJCURSTV9ERUJVR19LTVMoImRwX2F1eF9jaCBmbGFncyBub3QgemVyb1xuIik7DQotCQlyZXR1
cm4gLUVCVVNZOw0KKwkJcmV0dXJuIC1FSU87DQogCX0NCiANCiAJLyogZXJyb3IgKi8NCmRpZmYg
LS1naXQgYS9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL3JhZGVvbl9kaXNwbGF5LmMgYi9kcml2ZXJz
L2dwdS9kcm0vcmFkZW9uL3JhZGVvbl9kaXNwbGF5LmMNCmluZGV4IDMyOTFhYjguLmFkNWQ3NzQg
MTAwNjQ0DQotLS0gYS9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL3JhZGVvbl9kaXNwbGF5LmMNCisr
KyBiL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vcmFkZW9uX2Rpc3BsYXkuYw0KQEAgLTY5Nyw2ICs2
OTcsMTAgQEAgaW50IHJhZGVvbl9kZGNfZ2V0X21vZGVzKHN0cnVjdCByYWRlb25fY29ubmVjdG9y
ICpyYWRlb25fY29ubmVjdG9yKQ0KIAlzdHJ1Y3QgcmFkZW9uX2RldmljZSAqcmRldiA9IGRldi0+
ZGV2X3ByaXZhdGU7DQogCWludCByZXQgPSAwOw0KIA0KKwkvKiBkb24ndCBsZWFrIHRoZSBlZGlk
IGlmIHdlIGFscmVhZHkgZmV0Y2hlZCBpdCBpbiBkZXRlY3QoKSAqLw0KKwlpZiAocmFkZW9uX2Nv
bm5lY3Rvci0+ZWRpZCkNCisJCWdvdG8gZ290X2VkaWQ7DQorDQogCS8qIG9uIGh3IHdpdGggcm91
dGVycywgc2VsZWN0IHJpZ2h0IHBvcnQgKi8NCiAJaWYgKHJhZGVvbl9jb25uZWN0b3ItPnJvdXRl
ci5kZGNfdmFsaWQpDQogCQlyYWRlb25fcm91dGVyX3NlbGVjdF9kZGNfcG9ydChyYWRlb25fY29u
bmVjdG9yKTsNCkBAIC03MzYsNiArNzQwLDcgQEAgaW50IHJhZGVvbl9kZGNfZ2V0X21vZGVzKHN0
cnVjdCByYWRlb25fY29ubmVjdG9yICpyYWRlb25fY29ubmVjdG9yKQ0KIAkJCXJhZGVvbl9jb25u
ZWN0b3ItPmVkaWQgPSByYWRlb25fYmlvc19nZXRfaGFyZGNvZGVkX2VkaWQocmRldik7DQogCX0N
CiAJaWYgKHJhZGVvbl9jb25uZWN0b3ItPmVkaWQpIHsNCitnb3RfZWRpZDoNCiAJCWRybV9tb2Rl
X2Nvbm5lY3Rvcl91cGRhdGVfZWRpZF9wcm9wZXJ0eSgmcmFkZW9uX2Nvbm5lY3Rvci0+YmFzZSwg
cmFkZW9uX2Nvbm5lY3Rvci0+ZWRpZCk7DQogCQlyZXQgPSBkcm1fYWRkX2VkaWRfbW9kZXMoJnJh
ZGVvbl9jb25uZWN0b3ItPmJhc2UsIHJhZGVvbl9jb25uZWN0b3ItPmVkaWQpOw0KIAkJZHJtX2Vk
aWRfdG9fZWxkKCZyYWRlb25fY29ubmVjdG9yLT5iYXNlLCByYWRlb25fY29ubmVjdG9yLT5lZGlk
KTsNCmRpZmYgLS1naXQgYS9kcml2ZXJzL2dwdS9kcm0vdm13Z2Z4L3Ztd2dmeF9mYi5jIGIvZHJp
dmVycy9ncHUvZHJtL3Ztd2dmeC92bXdnZnhfZmIuYw0KaW5kZXggOTA3YzI2Zi4uN2YxNmZmMiAx
MDA2NDQNCi0tLSBhL2RyaXZlcnMvZ3B1L2RybS92bXdnZngvdm13Z2Z4X2ZiLmMNCisrKyBiL2Ry
aXZlcnMvZ3B1L2RybS92bXdnZngvdm13Z2Z4X2ZiLmMNCkBAIC0xNzksNyArMTc5LDYgQEAgc3Rh
dGljIGludCB2bXdfZmJfc2V0X3BhcihzdHJ1Y3QgZmJfaW5mbyAqaW5mbykNCiAJCXZtd193cml0
ZSh2bXdfcHJpdiwgU1ZHQV9SRUdfRElTUExBWV9QT1NJVElPTl9ZLCBpbmZvLT52YXIueW9mZnNl
dCk7DQogCQl2bXdfd3JpdGUodm13X3ByaXYsIFNWR0FfUkVHX0RJU1BMQVlfV0lEVEgsIGluZm8t
PnZhci54cmVzKTsNCiAJCXZtd193cml0ZSh2bXdfcHJpdiwgU1ZHQV9SRUdfRElTUExBWV9IRUlH
SFQsIGluZm8tPnZhci55cmVzKTsNCi0JCXZtd193cml0ZSh2bXdfcHJpdiwgU1ZHQV9SRUdfQllU
RVNfUEVSX0xJTkUsIGluZm8tPmZpeC5saW5lX2xlbmd0aCk7DQogCQl2bXdfd3JpdGUodm13X3By
aXYsIFNWR0FfUkVHX0RJU1BMQVlfSUQsIFNWR0FfSURfSU5WQUxJRCk7DQogCX0NCiANCmRpZmYg
LS1naXQgYS9kcml2ZXJzL2h3bW9uL2FkbTEwMjkuYyBiL2RyaXZlcnMvaHdtb24vYWRtMTAyOS5j
DQppbmRleCAwYjhhM2IxLi4zZGJmNDA1IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9od21vbi9hZG0x
MDI5LmMNCisrKyBiL2RyaXZlcnMvaHdtb24vYWRtMTAyOS5jDQpAQCAtMjI4LDYgKzIyOCw5IEBA
IHN0YXRpYyBzc2l6ZV90IHNldF9mYW5fZGl2KHN0cnVjdCBkZXZpY2UgKmRldiwNCiAJLyogVXBk
YXRlIHRoZSB2YWx1ZSAqLw0KIAlyZWcgPSAocmVnICYgMHgzRikgfCAodmFsIDw8IDYpOw0KIA0K
KwkvKiBVcGRhdGUgdGhlIGNhY2hlICovDQorCWRhdGEtPmZhbl9kaXZbYXR0ci0+aW5kZXhdID0g
cmVnOw0KKw0KIAkvKiBXcml0ZSB2YWx1ZSAqLw0KIAlpMmNfc21idXNfd3JpdGVfYnl0ZV9kYXRh
KGNsaWVudCwNCiAJCQkJICBBRE0xMDI5X1JFR19GQU5fRElWW2F0dHItPmluZGV4XSwgcmVnKTsN
CmRpZmYgLS1naXQgYS9kcml2ZXJzL2h3bW9uL2FkbTEwMzEuYyBiL2RyaXZlcnMvaHdtb24vYWRt
MTAzMS5jDQppbmRleCAwNjgzZTZiLi41ZjExZTIzIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9od21v
bi9hZG0xMDMxLmMNCisrKyBiL2RyaXZlcnMvaHdtb24vYWRtMTAzMS5jDQpAQCAtMzUyLDYgKzM1
Miw3IEBAIHNldF9hdXRvX3RlbXBfbWluKHN0cnVjdCBkZXZpY2UgKmRldiwgc3RydWN0IGRldmlj
ZV9hdHRyaWJ1dGUgKmF0dHIsDQogCWludCBuciA9IHRvX3NlbnNvcl9kZXZfYXR0cihhdHRyKS0+
aW5kZXg7DQogCWludCB2YWwgPSBzaW1wbGVfc3RydG9sKGJ1ZiwgTlVMTCwgMTApOw0KIA0KKwl2
YWwgPSBjbGFtcF92YWwodmFsLCAwLCAxMjcwMDApOw0KIAltdXRleF9sb2NrKCZkYXRhLT51cGRh
dGVfbG9jayk7DQogCWRhdGEtPmF1dG9fdGVtcFtucl0gPSBBVVRPX1RFTVBfTUlOX1RPX1JFRyh2
YWwsIGRhdGEtPmF1dG9fdGVtcFtucl0pOw0KIAlhZG0xMDMxX3dyaXRlX3ZhbHVlKGNsaWVudCwg
QURNMTAzMV9SRUdfQVVUT19URU1QKG5yKSwNCkBAIC0zNzYsNiArMzc3LDcgQEAgc2V0X2F1dG9f
dGVtcF9tYXgoc3RydWN0IGRldmljZSAqZGV2LCBzdHJ1Y3QgZGV2aWNlX2F0dHJpYnV0ZSAqYXR0
ciwNCiAJaW50IG5yID0gdG9fc2Vuc29yX2Rldl9hdHRyKGF0dHIpLT5pbmRleDsNCiAJaW50IHZh
bCA9IHNpbXBsZV9zdHJ0b2woYnVmLCBOVUxMLCAxMCk7DQogDQorCXZhbCA9IGNsYW1wX3ZhbCh2
YWwsIDAsIDEyNzAwMCk7DQogCW11dGV4X2xvY2soJmRhdGEtPnVwZGF0ZV9sb2NrKTsNCiAJZGF0
YS0+dGVtcF9tYXhbbnJdID0gQVVUT19URU1QX01BWF9UT19SRUcodmFsLCBkYXRhLT5hdXRvX3Rl
bXBbbnJdLCBkYXRhLT5wd21bbnJdKTsNCiAJYWRtMTAzMV93cml0ZV92YWx1ZShjbGllbnQsIEFE
TTEwMzFfUkVHX0FVVE9fVEVNUChuciksDQpAQCAtNjUxLDcgKzY1Myw3IEBAIHN0YXRpYyBzc2l6
ZV90IHNldF90ZW1wX21pbihzdHJ1Y3QgZGV2aWNlICpkZXYsIHN0cnVjdCBkZXZpY2VfYXR0cmli
dXRlICphdHRyLA0KIAlpbnQgdmFsOw0KIA0KIAl2YWwgPSBzaW1wbGVfc3RydG9sKGJ1ZiwgTlVM
TCwgMTApOw0KLQl2YWwgPSBTRU5TT1JTX0xJTUlUKHZhbCwgLTU1MDAwLCBuciA9PSAwID8gMTI3
NzUwIDogMTI3ODc1KTsNCisJdmFsID0gY2xhbXBfdmFsKHZhbCwgLTU1MDAwLCAxMjcwMDApOw0K
IAltdXRleF9sb2NrKCZkYXRhLT51cGRhdGVfbG9jayk7DQogCWRhdGEtPnRlbXBfbWluW25yXSA9
IFRFTVBfVE9fUkVHKHZhbCk7DQogCWFkbTEwMzFfd3JpdGVfdmFsdWUoY2xpZW50LCBBRE0xMDMx
X1JFR19URU1QX01JTihuciksDQpAQCAtNjY4LDcgKzY3MCw3IEBAIHN0YXRpYyBzc2l6ZV90IHNl
dF90ZW1wX21heChzdHJ1Y3QgZGV2aWNlICpkZXYsIHN0cnVjdCBkZXZpY2VfYXR0cmlidXRlICph
dHRyLA0KIAlpbnQgdmFsOw0KIA0KIAl2YWwgPSBzaW1wbGVfc3RydG9sKGJ1ZiwgTlVMTCwgMTAp
Ow0KLQl2YWwgPSBTRU5TT1JTX0xJTUlUKHZhbCwgLTU1MDAwLCBuciA9PSAwID8gMTI3NzUwIDog
MTI3ODc1KTsNCisJdmFsID0gY2xhbXBfdmFsKHZhbCwgLTU1MDAwLCAxMjcwMDApOw0KIAltdXRl
eF9sb2NrKCZkYXRhLT51cGRhdGVfbG9jayk7DQogCWRhdGEtPnRlbXBfbWF4W25yXSA9IFRFTVBf
VE9fUkVHKHZhbCk7DQogCWFkbTEwMzFfd3JpdGVfdmFsdWUoY2xpZW50LCBBRE0xMDMxX1JFR19U
RU1QX01BWChuciksDQpAQCAtNjg1LDcgKzY4Nyw3IEBAIHN0YXRpYyBzc2l6ZV90IHNldF90ZW1w
X2NyaXQoc3RydWN0IGRldmljZSAqZGV2LCBzdHJ1Y3QgZGV2aWNlX2F0dHJpYnV0ZSAqYXR0ciwN
CiAJaW50IHZhbDsNCiANCiAJdmFsID0gc2ltcGxlX3N0cnRvbChidWYsIE5VTEwsIDEwKTsNCi0J
dmFsID0gU0VOU09SU19MSU1JVCh2YWwsIC01NTAwMCwgbnIgPT0gMCA/IDEyNzc1MCA6IDEyNzg3
NSk7DQorCXZhbCA9IGNsYW1wX3ZhbCh2YWwsIC01NTAwMCwgMTI3MDAwKTsNCiAJbXV0ZXhfbG9j
aygmZGF0YS0+dXBkYXRlX2xvY2spOw0KIAlkYXRhLT50ZW1wX2NyaXRbbnJdID0gVEVNUF9UT19S
RUcodmFsKTsNCiAJYWRtMTAzMV93cml0ZV92YWx1ZShjbGllbnQsIEFETTEwMzFfUkVHX1RFTVBf
Q1JJVChuciksDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9od21vbi9hZHQ3NDcwLmMgYi9kcml2ZXJz
L2h3bW9uL2FkdDc0NzAuYw0KaW5kZXggYTk3MjZjMS4uM2ExNWZkNiAxMDA2NDQNCi0tLSBhL2Ry
aXZlcnMvaHdtb24vYWR0NzQ3MC5jDQorKysgYi9kcml2ZXJzL2h3bW9uL2FkdDc0NzAuYw0KQEAg
LTUxNSw3ICs1MTUsNyBAQCBzdGF0aWMgc3NpemVfdCBzZXRfdGVtcF9taW4oc3RydWN0IGRldmlj
ZSAqZGV2LA0KIAkJcmV0dXJuIC1FSU5WQUw7DQogDQogCXRlbXAgPSBESVZfUk9VTkRfQ0xPU0VT
VCh0ZW1wLCAxMDAwKTsNCi0JdGVtcCA9IFNFTlNPUlNfTElNSVQodGVtcCwgMCwgMjU1KTsNCisJ
dGVtcCA9IGNsYW1wX3ZhbCh0ZW1wLCAtMTI4LCAxMjcpOw0KIA0KIAltdXRleF9sb2NrKCZkYXRh
LT5sb2NrKTsNCiAJZGF0YS0+dGVtcF9taW5bYXR0ci0+aW5kZXhdID0gdGVtcDsNCkBAIC01NDks
NyArNTQ5LDcgQEAgc3RhdGljIHNzaXplX3Qgc2V0X3RlbXBfbWF4KHN0cnVjdCBkZXZpY2UgKmRl
diwNCiAJCXJldHVybiAtRUlOVkFMOw0KIA0KIAl0ZW1wID0gRElWX1JPVU5EX0NMT1NFU1QodGVt
cCwgMTAwMCk7DQotCXRlbXAgPSBTRU5TT1JTX0xJTUlUKHRlbXAsIDAsIDI1NSk7DQorCXRlbXAg
PSBjbGFtcF92YWwodGVtcCwgLTEyOCwgMTI3KTsNCiANCiAJbXV0ZXhfbG9jaygmZGF0YS0+bG9j
ayk7DQogCWRhdGEtPnRlbXBfbWF4W2F0dHItPmluZGV4XSA9IHRlbXA7DQpAQCAtODI2LDcgKzgy
Niw3IEBAIHN0YXRpYyBzc2l6ZV90IHNldF9wd21fdG1pbihzdHJ1Y3QgZGV2aWNlICpkZXYsDQog
CQlyZXR1cm4gLUVJTlZBTDsNCiANCiAJdGVtcCA9IERJVl9ST1VORF9DTE9TRVNUKHRlbXAsIDEw
MDApOw0KLQl0ZW1wID0gU0VOU09SU19MSU1JVCh0ZW1wLCAwLCAyNTUpOw0KKwl0ZW1wID0gY2xh
bXBfdmFsKHRlbXAsIC0xMjgsIDEyNyk7DQogDQogCW11dGV4X2xvY2soJmRhdGEtPmxvY2spOw0K
IAlkYXRhLT5wd21fdG1pblthdHRyLT5pbmRleF0gPSB0ZW1wOw0KZGlmZiAtLWdpdCBhL2RyaXZl
cnMvaHdtb24vYW1jNjgyMS5jIGIvZHJpdmVycy9od21vbi9hbWM2ODIxLmMNCmluZGV4IDQwMzM5
NzQuLjc1YmU2YzQgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL2h3bW9uL2FtYzY4MjEuYw0KKysrIGIv
ZHJpdmVycy9od21vbi9hbWM2ODIxLmMNCkBAIC03MTUsNyArNzE1LDcgQEAgc3RhdGljIFNFTlNP
Ul9ERVZJQ0VfQVRUUih0ZW1wMV9tYXhfYWxhcm0sIFNfSVJVR08sDQogCWdldF90ZW1wX2FsYXJt
LCBOVUxMLCBJRFhfVEVNUDFfTUFYKTsNCiBzdGF0aWMgU0VOU09SX0RFVklDRV9BVFRSKHRlbXAx
X2NyaXRfYWxhcm0sIFNfSVJVR08sDQogCWdldF90ZW1wX2FsYXJtLCBOVUxMLCBJRFhfVEVNUDFf
Q1JJVCk7DQotc3RhdGljIFNFTlNPUl9ERVZJQ0VfQVRUUih0ZW1wMl9pbnB1dCwgU19JUlVHTyB8
IFNfSVdVU1IsDQorc3RhdGljIFNFTlNPUl9ERVZJQ0VfQVRUUih0ZW1wMl9pbnB1dCwgU19JUlVH
TywNCiAJZ2V0X3RlbXAsIE5VTEwsIElEWF9URU1QMl9JTlBVVCk7DQogc3RhdGljIFNFTlNPUl9E
RVZJQ0VfQVRUUih0ZW1wMl9taW4sIFNfSVJVR08gfCBTX0lXVVNSLCBnZXRfdGVtcCwNCiAJc2V0
X3RlbXAsIElEWF9URU1QMl9NSU4pOw0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvaHdtb24vZW1jMjEw
My5jIGIvZHJpdmVycy9od21vbi9lbWMyMTAzLmMNCmluZGV4IGFmOTE0YWQuLmEwNzRkMjEgMTAw
NjQ0DQotLS0gYS9kcml2ZXJzL2h3bW9uL2VtYzIxMDMuYw0KKysrIGIvZHJpdmVycy9od21vbi9l
bWMyMTAzLmMNCkBAIC0yNDgsOSArMjQ4LDcgQEAgc3RhdGljIHNzaXplX3Qgc2V0X3RlbXBfbWlu
KHN0cnVjdCBkZXZpY2UgKmRldiwgc3RydWN0IGRldmljZV9hdHRyaWJ1dGUgKmRhLA0KIAlpZiAo
cmVzdWx0IDwgMCkNCiAJCXJldHVybiAtRUlOVkFMOw0KIA0KLQl2YWwgPSBESVZfUk9VTkRfQ0xP
U0VTVCh2YWwsIDEwMDApOw0KLQlpZiAoKHZhbCA8IC02MykgfHwgKHZhbCA+IDEyNykpDQotCQly
ZXR1cm4gLUVJTlZBTDsNCisJdmFsID0gY2xhbXBfdmFsKERJVl9ST1VORF9DTE9TRVNUKHZhbCwg
MTAwMCksIC02MywgMTI3KTsNCiANCiAJbXV0ZXhfbG9jaygmZGF0YS0+dXBkYXRlX2xvY2spOw0K
IAlkYXRhLT50ZW1wX21pbltucl0gPSB2YWw7DQpAQCAtMjcyLDkgKzI3MCw3IEBAIHN0YXRpYyBz
c2l6ZV90IHNldF90ZW1wX21heChzdHJ1Y3QgZGV2aWNlICpkZXYsIHN0cnVjdCBkZXZpY2VfYXR0
cmlidXRlICpkYSwNCiAJaWYgKHJlc3VsdCA8IDApDQogCQlyZXR1cm4gLUVJTlZBTDsNCiANCi0J
dmFsID0gRElWX1JPVU5EX0NMT1NFU1QodmFsLCAxMDAwKTsNCi0JaWYgKCh2YWwgPCAtNjMpIHx8
ICh2YWwgPiAxMjcpKQ0KLQkJcmV0dXJuIC1FSU5WQUw7DQorCXZhbCA9IGNsYW1wX3ZhbChESVZf
Uk9VTkRfQ0xPU0VTVCh2YWwsIDEwMDApLCAtNjMsIDEyNyk7DQogDQogCW11dGV4X2xvY2soJmRh
dGEtPnVwZGF0ZV9sb2NrKTsNCiAJZGF0YS0+dGVtcF9tYXhbbnJdID0gdmFsOw0KQEAgLTM4Niwx
NSArMzgyLDE0IEBAIHN0YXRpYyBzc2l6ZV90IHNldF9mYW5fdGFyZ2V0KHN0cnVjdCBkZXZpY2Ug
KmRldiwgc3RydWN0IGRldmljZV9hdHRyaWJ1dGUgKmRhLA0KIHsNCiAJc3RydWN0IGVtYzIxMDNf
ZGF0YSAqZGF0YSA9IGVtYzIxMDNfdXBkYXRlX2RldmljZShkZXYpOw0KIAlzdHJ1Y3QgaTJjX2Ns
aWVudCAqY2xpZW50ID0gdG9faTJjX2NsaWVudChkZXYpOw0KLQlsb25nIHJwbV90YXJnZXQ7DQor
CXVuc2lnbmVkIGxvbmcgcnBtX3RhcmdldDsNCiANCi0JaW50IHJlc3VsdCA9IHN0cmljdF9zdHJ0
b2woYnVmLCAxMCwgJnJwbV90YXJnZXQpOw0KKwlpbnQgcmVzdWx0ID0ga3N0cnRvdWwoYnVmLCAx
MCwgJnJwbV90YXJnZXQpOw0KIAlpZiAocmVzdWx0IDwgMCkNCiAJCXJldHVybiAtRUlOVkFMOw0K
IA0KIAkvKiBEYXRhc2hlZXQgc3RhdGVzIDE2Mzg0IGFzIG1heGltdW0gUlBNIHRhcmdldCAodGFi
bGUgMy4yKSAqLw0KLQlpZiAoKHJwbV90YXJnZXQgPCAwKSB8fCAocnBtX3RhcmdldCA+IDE2Mzg0
KSkNCi0JCXJldHVybiAtRUlOVkFMOw0KKwlycG1fdGFyZ2V0ID0gY2xhbXBfdmFsKHJwbV90YXJn
ZXQsIDAsIDE2Mzg0KTsNCiANCiAJbXV0ZXhfbG9jaygmZGF0YS0+dXBkYXRlX2xvY2spOw0KIA0K
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvaW9tbXUvZG1hci5jIGIvZHJpdmVycy9pb21tdS9kbWFyLmMN
CmluZGV4IDk3YjJlMjEuLmNmMDY1ZGYgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL2lvbW11L2RtYXIu
Yw0KKysrIGIvZHJpdmVycy9pb21tdS9kbWFyLmMNCkBAIC01ODIsNyArNTgyLDcgQEAgaW50IGFs
bG9jX2lvbW11KHN0cnVjdCBkbWFyX2RyaGRfdW5pdCAqZHJoZCkNCiB7DQogCXN0cnVjdCBpbnRl
bF9pb21tdSAqaW9tbXU7DQogCWludCBtYXBfc2l6ZTsNCi0JdTMyIHZlcjsNCisJdTMyIHZlciwg
c3RzOw0KIAlzdGF0aWMgaW50IGlvbW11X2FsbG9jYXRlZCA9IDA7DQogCWludCBhZ2F3ID0gMDsN
CiAJaW50IG1zYWdhdyA9IDA7DQpAQCAtNjUyLDYgKzY1MiwxNSBAQCBpbnQgYWxsb2NfaW9tbXUo
c3RydWN0IGRtYXJfZHJoZF91bml0ICpkcmhkKQ0KIAkJKHVuc2lnbmVkIGxvbmcgbG9uZylpb21t
dS0+Y2FwLA0KIAkJKHVuc2lnbmVkIGxvbmcgbG9uZylpb21tdS0+ZWNhcCk7DQogDQorCS8qIFJl
ZmxlY3Qgc3RhdHVzIGluIGdjbWQgKi8NCisJc3RzID0gcmVhZGwoaW9tbXUtPnJlZyArIERNQVJf
R1NUU19SRUcpOw0KKwlpZiAoc3RzICYgRE1BX0dTVFNfSVJFUykNCisJCWlvbW11LT5nY21kIHw9
IERNQV9HQ01EX0lSRTsNCisJaWYgKHN0cyAmIERNQV9HU1RTX1RFUykNCisJCWlvbW11LT5nY21k
IHw9IERNQV9HQ01EX1RFOw0KKwlpZiAoc3RzICYgRE1BX0dTVFNfUUlFUykNCisJCWlvbW11LT5n
Y21kIHw9IERNQV9HQ01EX1FJRTsNCisNCiAJcmF3X3NwaW5fbG9ja19pbml0KCZpb21tdS0+cmVn
aXN0ZXJfbG9jayk7DQogDQogCWRyaGQtPmlvbW11ID0gaW9tbXU7DQpkaWZmIC0tZ2l0IGEvZHJp
dmVycy9pb21tdS9pbnRlbC1pb21tdS5jIGIvZHJpdmVycy9pb21tdS9pbnRlbC1pb21tdS5jDQpp
bmRleCBiYjFlNTc5Li4yNzZlZjM4IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9pb21tdS9pbnRlbC1p
b21tdS5jDQorKysgYi9kcml2ZXJzL2lvbW11L2ludGVsLWlvbW11LmMNCkBAIC0zNjMwLDYgKzM2
MzAsNyBAQCBzdGF0aWMgc3RydWN0IG5vdGlmaWVyX2Jsb2NrIGRldmljZV9uYiA9IHsNCiBpbnQg
X19pbml0IGludGVsX2lvbW11X2luaXQodm9pZCkNCiB7DQogCWludCByZXQgPSAwOw0KKwlzdHJ1
Y3QgZG1hcl9kcmhkX3VuaXQgKmRyaGQ7DQogDQogCS8qIFZULWQgaXMgcmVxdWlyZWQgZm9yIGEg
VFhUL3Rib290IGxhdW5jaCwgc28gZW5mb3JjZSB0aGF0ICovDQogCWZvcmNlX29uID0gdGJvb3Rf
Zm9yY2VfaW9tbXUoKTsNCkBAIC0zNjQwLDYgKzM2NDEsMjAgQEAgaW50IF9faW5pdCBpbnRlbF9p
b21tdV9pbml0KHZvaWQpDQogCQlyZXR1cm4gCS1FTk9ERVY7DQogCX0NCiANCisJLyoNCisJICog
RGlzYWJsZSB0cmFuc2xhdGlvbiBpZiBhbHJlYWR5IGVuYWJsZWQgcHJpb3IgdG8gT1MgaGFuZG92
ZXIuDQorCSAqLw0KKwlmb3JfZWFjaF9kcmhkX3VuaXQoZHJoZCkgew0KKwkJc3RydWN0IGludGVs
X2lvbW11ICppb21tdTsNCisNCisJCWlmIChkcmhkLT5pZ25vcmVkKQ0KKwkJCWNvbnRpbnVlOw0K
Kw0KKwkJaW9tbXUgPSBkcmhkLT5pb21tdTsNCisJCWlmIChpb21tdS0+Z2NtZCAmIERNQV9HQ01E
X1RFKQ0KKwkJCWlvbW11X2Rpc2FibGVfdHJhbnNsYXRpb24oaW9tbXUpOw0KKwl9DQorDQogCWlm
IChkbWFyX2Rldl9zY29wZV9pbml0KCkgPCAwKSB7DQogCQlpZiAoZm9yY2Vfb24pDQogCQkJcGFu
aWMoInRib290OiBGYWlsZWQgdG8gaW5pdGlhbGl6ZSBETUFSIGRldmljZSBzY29wZVxuIik7DQpk
aWZmIC0tZ2l0IGEvZHJpdmVycy9tZC9kbS1pby5jIGIvZHJpdmVycy9tZC9kbS1pby5jDQppbmRl
eCBlYTVkZDI4Li4zOWEwOGJlIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9tZC9kbS1pby5jDQorKysg
Yi9kcml2ZXJzL21kL2RtLWlvLmMNCkBAIC0xMCw2ICsxMCw3IEBADQogI2luY2x1ZGUgPGxpbnV4
L2RldmljZS1tYXBwZXIuaD4NCiANCiAjaW5jbHVkZSA8bGludXgvYmlvLmg+DQorI2luY2x1ZGUg
PGxpbnV4L2NvbXBsZXRpb24uaD4NCiAjaW5jbHVkZSA8bGludXgvbWVtcG9vbC5oPg0KICNpbmNs
dWRlIDxsaW51eC9tb2R1bGUuaD4NCiAjaW5jbHVkZSA8bGludXgvc2NoZWQuaD4NCkBAIC0zNCw3
ICszNSw3IEBAIHN0cnVjdCBkbV9pb19jbGllbnQgew0KIHN0cnVjdCBpbyB7DQogCXVuc2lnbmVk
IGxvbmcgZXJyb3JfYml0czsNCiAJYXRvbWljX3QgY291bnQ7DQotCXN0cnVjdCB0YXNrX3N0cnVj
dCAqc2xlZXBlcjsNCisJc3RydWN0IGNvbXBsZXRpb24gKndhaXQ7DQogCXN0cnVjdCBkbV9pb19j
bGllbnQgKmNsaWVudDsNCiAJaW9fbm90aWZ5X2ZuIGNhbGxiYWNrOw0KIAl2b2lkICpjb250ZXh0
Ow0KQEAgLTEyMiw4ICsxMjMsOCBAQCBzdGF0aWMgdm9pZCBkZWNfY291bnQoc3RydWN0IGlvICpp
bywgdW5zaWduZWQgaW50IHJlZ2lvbiwgaW50IGVycm9yKQ0KIAkJCWludmFsaWRhdGVfa2VybmVs
X3ZtYXBfcmFuZ2UoaW8tPnZtYV9pbnZhbGlkYXRlX2FkZHJlc3MsDQogCQkJCQkJICAgICBpby0+
dm1hX2ludmFsaWRhdGVfc2l6ZSk7DQogDQotCQlpZiAoaW8tPnNsZWVwZXIpDQotCQkJd2FrZV91
cF9wcm9jZXNzKGlvLT5zbGVlcGVyKTsNCisJCWlmIChpby0+d2FpdCkNCisJCQljb21wbGV0ZShp
by0+d2FpdCk7DQogDQogCQllbHNlIHsNCiAJCQl1bnNpZ25lZCBsb25nIHIgPSBpby0+ZXJyb3Jf
Yml0czsNCkBAIC0zODQsNiArMzg1LDcgQEAgc3RhdGljIGludCBzeW5jX2lvKHN0cnVjdCBkbV9p
b19jbGllbnQgKmNsaWVudCwgdW5zaWduZWQgaW50IG51bV9yZWdpb25zLA0KIAkgKi8NCiAJdm9s
YXRpbGUgY2hhciBpb19bc2l6ZW9mKHN0cnVjdCBpbykgKyBfX2FsaWdub2ZfXyhzdHJ1Y3QgaW8p
IC0gMV07DQogCXN0cnVjdCBpbyAqaW8gPSAoc3RydWN0IGlvICopUFRSX0FMSUdOKCZpb18sIF9f
YWxpZ25vZl9fKHN0cnVjdCBpbykpOw0KKwlERUNMQVJFX0NPTVBMRVRJT05fT05TVEFDSyh3YWl0
KTsNCiANCiAJaWYgKG51bV9yZWdpb25zID4gMSAmJiAocncgJiBSV19NQVNLKSAhPSBXUklURSkg
ew0KIAkJV0FSTl9PTigxKTsNCkBAIC0zOTIsNyArMzk0LDcgQEAgc3RhdGljIGludCBzeW5jX2lv
KHN0cnVjdCBkbV9pb19jbGllbnQgKmNsaWVudCwgdW5zaWduZWQgaW50IG51bV9yZWdpb25zLA0K
IA0KIAlpby0+ZXJyb3JfYml0cyA9IDA7DQogCWF0b21pY19zZXQoJmlvLT5jb3VudCwgMSk7IC8q
IHNlZSBkaXNwYXRjaF9pbygpICovDQotCWlvLT5zbGVlcGVyID0gY3VycmVudDsNCisJaW8tPndh
aXQgPSAmd2FpdDsNCiAJaW8tPmNsaWVudCA9IGNsaWVudDsNCiANCiAJaW8tPnZtYV9pbnZhbGlk
YXRlX2FkZHJlc3MgPSBkcC0+dm1hX2ludmFsaWRhdGVfYWRkcmVzczsNCkBAIC00MDAsMTUgKzQw
Miw3IEBAIHN0YXRpYyBpbnQgc3luY19pbyhzdHJ1Y3QgZG1faW9fY2xpZW50ICpjbGllbnQsIHVu
c2lnbmVkIGludCBudW1fcmVnaW9ucywNCiANCiAJZGlzcGF0Y2hfaW8ocncsIG51bV9yZWdpb25z
LCB3aGVyZSwgZHAsIGlvLCAxKTsNCiANCi0Jd2hpbGUgKDEpIHsNCi0JCXNldF9jdXJyZW50X3N0
YXRlKFRBU0tfVU5JTlRFUlJVUFRJQkxFKTsNCi0NCi0JCWlmICghYXRvbWljX3JlYWQoJmlvLT5j
b3VudCkpDQotCQkJYnJlYWs7DQotDQotCQlpb19zY2hlZHVsZSgpOw0KLQl9DQotCXNldF9jdXJy
ZW50X3N0YXRlKFRBU0tfUlVOTklORyk7DQorCXdhaXRfZm9yX2NvbXBsZXRpb24oJndhaXQpOw0K
IA0KIAlpZiAoZXJyb3JfYml0cykNCiAJCSplcnJvcl9iaXRzID0gaW8tPmVycm9yX2JpdHM7DQpA
QCAtNDMxLDcgKzQyNSw3IEBAIHN0YXRpYyBpbnQgYXN5bmNfaW8oc3RydWN0IGRtX2lvX2NsaWVu
dCAqY2xpZW50LCB1bnNpZ25lZCBpbnQgbnVtX3JlZ2lvbnMsDQogCWlvID0gbWVtcG9vbF9hbGxv
YyhjbGllbnQtPnBvb2wsIEdGUF9OT0lPKTsNCiAJaW8tPmVycm9yX2JpdHMgPSAwOw0KIAlhdG9t
aWNfc2V0KCZpby0+Y291bnQsIDEpOyAvKiBzZWUgZGlzcGF0Y2hfaW8oKSAqLw0KLQlpby0+c2xl
ZXBlciA9IE5VTEw7DQorCWlvLT53YWl0ID0gTlVMTDsNCiAJaW8tPmNsaWVudCA9IGNsaWVudDsN
CiAJaW8tPmNhbGxiYWNrID0gZm47DQogCWlvLT5jb250ZXh0ID0gY29udGV4dDsNCmRpZmYgLS1n
aXQgYS9kcml2ZXJzL21kL21kLmMgYi9kcml2ZXJzL21kL21kLmMNCmluZGV4IDMwYTdiNTIuLmVh
OGExODEgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL21kL21kLmMNCisrKyBiL2RyaXZlcnMvbWQvbWQu
Yw0KQEAgLTcxNDQsNiArNzE0NCwxOSBAQCB2b2lkIG1kX2RvX3N5bmMoc3RydWN0IG1kZGV2ICpt
ZGRldikNCiAJCQkgICAgcmRldi0+cmVjb3Zlcnlfb2Zmc2V0IDwgaikNCiAJCQkJaiA9IHJkZXYt
PnJlY292ZXJ5X29mZnNldDsNCiAJCXJjdV9yZWFkX3VubG9jaygpOw0KKw0KKwkJLyogSWYgdGhl
cmUgaXMgYSBiaXRtYXAsIHdlIG5lZWQgdG8gbWFrZSBzdXJlIGFsbA0KKwkJICogd3JpdGVzIHRo
YXQgc3RhcnRlZCBiZWZvcmUgd2UgYWRkZWQgYSBzcGFyZQ0KKwkJICogY29tcGxldGUgYmVmb3Jl
IHdlIHN0YXJ0IGRvaW5nIGEgcmVjb3ZlcnkuDQorCQkgKiBPdGhlcndpc2UgdGhlIHdyaXRlIG1p
Z2h0IGNvbXBsZXRlIGFuZCAodmlhDQorCQkgKiBiaXRtYXBfZW5kd3JpdGUpIHNldCBhIGJpdCBp
biB0aGUgYml0bWFwIGFmdGVyIHRoZQ0KKwkJICogcmVjb3ZlcnkgaGFzIGNoZWNrZWQgdGhhdCBi
aXQgYW5kIHNraXBwZWQgdGhhdA0KKwkJICogcmVnaW9uLg0KKwkJICovDQorCQlpZiAobWRkZXYt
PmJpdG1hcCkgew0KKwkJCW1kZGV2LT5wZXJzLT5xdWllc2NlKG1kZGV2LCAxKTsNCisJCQltZGRl
di0+cGVycy0+cXVpZXNjZShtZGRldiwgMCk7DQorCQl9DQogCX0NCiANCiAJcHJpbnRrKEtFUk5f
SU5GTyAibWQ6ICVzIG9mIFJBSUQgYXJyYXkgJXNcbiIsIGRlc2MsIG1kbmFtZShtZGRldikpOw0K
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2lnYi9pZ2JfbWFpbi5jIGIv
ZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaWdiL2lnYl9tYWluLmMNCmluZGV4IGRmNWEwOWEu
LmI1NTViZTAgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pZ2IvaWdi
X21haW4uYw0KKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaWdiL2lnYl9tYWluLmMN
CkBAIC02NjEwLDYgKzY2MTAsOCBAQCBzdGF0aWMgaW50IF9faWdiX3NodXRkb3duKHN0cnVjdCBw
Y2lfZGV2ICpwZGV2LCBib29sICplbmFibGVfd2FrZSkNCiANCiAJaWYgKG5ldGlmX3J1bm5pbmco
bmV0ZGV2KSkNCiAJCWlnYl9jbG9zZShuZXRkZXYpOw0KKwllbHNlDQorCQlpZ2JfcmVzZXQoYWRh
cHRlcik7DQogDQogCWlnYl9jbGVhcl9pbnRlcnJ1cHRfc2NoZW1lKGFkYXB0ZXIpOw0KIA0KZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3N1bi9zdW52bmV0LmMgYi9kcml2ZXJzL25l
dC9ldGhlcm5ldC9zdW4vc3Vudm5ldC5jDQppbmRleCBiZDA4OTE5Li41MDkyMTQ4IDEwMDY0NA0K
LS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvc3VuL3N1bnZuZXQuYw0KKysrIGIvZHJpdmVycy9u
ZXQvZXRoZXJuZXQvc3VuL3N1bnZuZXQuYw0KQEAgLTEwODksNiArMTA4OSwyNCBAQCBzdGF0aWMg
c3RydWN0IHZuZXQgKiBfX2RldmluaXQgdm5ldF9maW5kX29yX2NyZWF0ZShjb25zdCB1NjQgKmxv
Y2FsX21hYykNCiAJcmV0dXJuIHZwOw0KIH0NCiANCitzdGF0aWMgdm9pZCB2bmV0X2NsZWFudXAo
dm9pZCkNCit7DQorCXN0cnVjdCB2bmV0ICp2cDsNCisJc3RydWN0IG5ldF9kZXZpY2UgKmRldjsN
CisNCisJbXV0ZXhfbG9jaygmdm5ldF9saXN0X211dGV4KTsNCisJd2hpbGUgKCFsaXN0X2VtcHR5
KCZ2bmV0X2xpc3QpKSB7DQorCQl2cCA9IGxpc3RfZmlyc3RfZW50cnkoJnZuZXRfbGlzdCwgc3Ry
dWN0IHZuZXQsIGxpc3QpOw0KKwkJbGlzdF9kZWwoJnZwLT5saXN0KTsNCisJCWRldiA9IHZwLT5k
ZXY7DQorCQkvKiB2aW9fdW5yZWdpc3Rlcl9kcml2ZXIoKSBzaG91bGQgaGF2ZSBjbGVhbmVkIHVw
IHBvcnRfbGlzdCAqLw0KKwkJQlVHX09OKCFsaXN0X2VtcHR5KCZ2cC0+cG9ydF9saXN0KSk7DQor
CQl1bnJlZ2lzdGVyX25ldGRldihkZXYpOw0KKwkJZnJlZV9uZXRkZXYoZGV2KTsNCisJfQ0KKwlt
dXRleF91bmxvY2soJnZuZXRfbGlzdF9tdXRleCk7DQorfQ0KKw0KIHN0YXRpYyBjb25zdCBjaGFy
ICpsb2NhbF9tYWNfcHJvcCA9ICJsb2NhbC1tYWMtYWRkcmVzcyI7DQogDQogc3RhdGljIHN0cnVj
dCB2bmV0ICogX19kZXZpbml0IHZuZXRfZmluZF9wYXJlbnQoc3RydWN0IG1kZXNjX2hhbmRsZSAq
aHAsDQpAQCAtMTI0OSw3ICsxMjY3LDYgQEAgc3RhdGljIGludCB2bmV0X3BvcnRfcmVtb3ZlKHN0
cnVjdCB2aW9fZGV2ICp2ZGV2KQ0KIA0KIAkJa2ZyZWUocG9ydCk7DQogDQotCQl1bnJlZ2lzdGVy
X25ldGRldih2cC0+ZGV2KTsNCiAJfQ0KIAlyZXR1cm4gMDsNCiB9DQpAQCAtMTI4MCw2ICsxMjk3
LDcgQEAgc3RhdGljIGludCBfX2luaXQgdm5ldF9pbml0KHZvaWQpDQogc3RhdGljIHZvaWQgX19l
eGl0IHZuZXRfZXhpdCh2b2lkKQ0KIHsNCiAJdmlvX3VucmVnaXN0ZXJfZHJpdmVyKCZ2bmV0X3Bv
cnRfZHJpdmVyKTsNCisJdm5ldF9jbGVhbnVwKCk7DQogfQ0KIA0KIG1vZHVsZV9pbml0KHZuZXRf
aW5pdCk7DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvaXdsd2lmaS9pd2wtYWdu
LXJ4b24uYyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2l3bHdpZmkvaXdsLWFnbi1yeG9uLmMNCmlu
ZGV4IGQ1NTJmYTMuLmQ2OTY1MzYgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9p
d2x3aWZpL2l3bC1hZ24tcnhvbi5jDQorKysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9pd2x3aWZp
L2l3bC1hZ24tcnhvbi5jDQpAQCAtNDQwLDE0ICs0NDAsNiBAQCBpbnQgaXdsYWduX2NvbW1pdF9y
eG9uKHN0cnVjdCBpd2xfcHJpdiAqcHJpdiwgc3RydWN0IGl3bF9yeG9uX2NvbnRleHQgKmN0eCkN
CiAJLyogYWx3YXlzIGdldCB0aW1lc3RhbXAgd2l0aCBSeCBmcmFtZSAqLw0KIAljdHgtPnN0YWdp
bmcuZmxhZ3MgfD0gUlhPTl9GTEdfVFNGMkhPU1RfTVNLOw0KIA0KLQkvKg0KLQkgKiBmb3JjZSBD
VFMtdG8tc2VsZiBmcmFtZXMgcHJvdGVjdGlvbiBpZiBSVFMtQ1RTIGlzIG5vdCBwcmVmZXJyZWQN
Ci0JICogb25lIGFnZ3JlZ2F0aW9uIHByb3RlY3Rpb24gbWV0aG9kDQotCSAqLw0KLQlpZiAoIShw
cml2LT5jZmctPmh0X3BhcmFtcyAmJg0KLQkgICAgICBwcml2LT5jZmctPmh0X3BhcmFtcy0+dXNl
X3J0c19mb3JfYWdncmVnYXRpb24pKQ0KLQkJY3R4LT5zdGFnaW5nLmZsYWdzIHw9IFJYT05fRkxH
X1NFTEZfQ1RTX0VOOw0KLQ0KIAlpZiAoKGN0eC0+dmlmICYmIGN0eC0+dmlmLT5ic3NfY29uZi51
c2Vfc2hvcnRfc2xvdCkgfHwNCiAJICAgICEoY3R4LT5zdGFnaW5nLmZsYWdzICYgUlhPTl9GTEdf
QkFORF8yNEdfTVNLKSkNCiAJCWN0eC0+c3RhZ2luZy5mbGFncyB8PSBSWE9OX0ZMR19TSE9SVF9T
TE9UX01TSzsNCkBAIC04ODAsMTEgKzg3Miw2IEBAIHZvaWQgaXdsYWduX2Jzc19pbmZvX2NoYW5n
ZWQoc3RydWN0IGllZWU4MDIxMV9odyAqaHcsDQogCWVsc2UNCiAJCWN0eC0+c3RhZ2luZy5mbGFn
cyAmPSB+UlhPTl9GTEdfVEdHX1BST1RFQ1RfTVNLOw0KIA0KLQlpZiAoYnNzX2NvbmYtPnVzZV9j
dHNfcHJvdCkNCi0JCWN0eC0+c3RhZ2luZy5mbGFncyB8PSBSWE9OX0ZMR19TRUxGX0NUU19FTjsN
Ci0JZWxzZQ0KLQkJY3R4LT5zdGFnaW5nLmZsYWdzICY9IH5SWE9OX0ZMR19TRUxGX0NUU19FTjsN
Ci0NCiAJbWVtY3B5KGN0eC0+c3RhZ2luZy5ic3NpZF9hZGRyLCBic3NfY29uZi0+YnNzaWQsIEVU
SF9BTEVOKTsNCiANCiAJaWYgKHZpZi0+dHlwZSA9PSBOTDgwMjExX0lGVFlQRV9BUCB8fA0KZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL213aWZpZXgvbWFpbi5jIGIvZHJpdmVycy9u
ZXQvd2lyZWxlc3MvbXdpZmlleC9tYWluLmMNCmluZGV4IDViYWExMmEuLjAxODI3NmYgMTAwNjQ0
DQotLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9td2lmaWV4L21haW4uYw0KKysrIGIvZHJpdmVy
cy9uZXQvd2lyZWxlc3MvbXdpZmlleC9tYWluLmMNCkBAIC00NTgsNiArNDU4LDcgQEAgbXdpZmll
eF9oYXJkX3N0YXJ0X3htaXQoc3RydWN0IHNrX2J1ZmYgKnNrYiwgc3RydWN0IG5ldF9kZXZpY2Ug
KmRldikNCiAJfQ0KIA0KIAl0eF9pbmZvID0gTVdJRklFWF9TS0JfVFhDQihza2IpOw0KKwltZW1z
ZXQodHhfaW5mbywgMCwgc2l6ZW9mKCp0eF9pbmZvKSk7DQogCXR4X2luZm8tPmJzc19pbmRleCA9
IHByaXYtPmJzc19pbmRleDsNCiAJbXdpZmlleF9maWxsX2J1ZmZlcihza2IpOw0KIA0KZGlmZiAt
LWdpdCBhL2RyaXZlcnMvc2NzaS9pYm12c2NzaS9pYm12c2NzaS5jIGIvZHJpdmVycy9zY3NpL2li
bXZzY3NpL2libXZzY3NpLmMNCmluZGV4IDM2YWNhNGIuLjRhYWJiZGMgMTAwNjQ0DQotLS0gYS9k
cml2ZXJzL3Njc2kvaWJtdnNjc2kvaWJtdnNjc2kuYw0KKysrIGIvZHJpdmVycy9zY3NpL2libXZz
Y3NpL2libXZzY3NpLmMNCkBAIC00OTAsNyArNDkwLDggQEAgc3RhdGljIHZvaWQgcHVyZ2VfcmVx
dWVzdHMoc3RydWN0IGlibXZzY3NpX2hvc3RfZGF0YSAqaG9zdGRhdGEsIGludCBlcnJvcl9jb2Rl
KQ0KIAkJCQkgICAgICAgZXZ0LT5ob3N0ZGF0YS0+ZGV2KTsNCiAJCQlpZiAoZXZ0LT5jbW5kX2Rv
bmUpDQogCQkJCWV2dC0+Y21uZF9kb25lKGV2dC0+Y21uZCk7DQotCQl9IGVsc2UgaWYgKGV2dC0+
ZG9uZSkNCisJCX0gZWxzZSBpZiAoZXZ0LT5kb25lICYmIGV2dC0+Y3JxLmZvcm1hdCAhPSBWSU9T
UlBfTUFEX0ZPUk1BVCAmJg0KKwkJCSAgIGV2dC0+aXUuc3JwLmxvZ2luX3JlcS5vcGNvZGUgIT0g
U1JQX0xPR0lOX1JFUSkNCiAJCQlldnQtPmRvbmUoZXZ0KTsNCiAJCWZyZWVfZXZlbnRfc3RydWN0
KCZldnQtPmhvc3RkYXRhLT5wb29sLCBldnQpOw0KIAkJc3Bpbl9sb2NrX2lycXNhdmUoaG9zdGRh
dGEtPmhvc3QtPmhvc3RfbG9jaywgZmxhZ3MpOw0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS9p
Ym12c2NzaS9ycGFfdnNjc2kuYyBiL2RyaXZlcnMvc2NzaS9pYm12c2NzaS9ycGFfdnNjc2kuYw0K
aW5kZXggZjQ4YWUwMS4uOTIwYzAyZSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvc2NzaS9pYm12c2Nz
aS9ycGFfdnNjc2kuYw0KKysrIGIvZHJpdmVycy9zY3NpL2libXZzY3NpL3JwYV92c2NzaS5jDQpA
QCAtMTA0LDYgKzEwNCwxMSBAQCBzdGF0aWMgc3RydWN0IHZpb3NycF9jcnEgKmNycV9xdWV1ZV9u
ZXh0X2NycShzdHJ1Y3QgY3JxX3F1ZXVlICpxdWV1ZSkNCiAJaWYgKGNycS0+dmFsaWQgJiAweDgw
KSB7DQogCQlpZiAoKytxdWV1ZS0+Y3VyID09IHF1ZXVlLT5zaXplKQ0KIAkJCXF1ZXVlLT5jdXIg
PSAwOw0KKw0KKwkJLyogRW5zdXJlIHRoZSByZWFkIG9mIHRoZSB2YWxpZCBiaXQgb2NjdXJzIGJl
Zm9yZSByZWFkaW5nIGFueQ0KKwkJICogb3RoZXIgYml0cyBvZiB0aGUgQ1JRIGVudHJ5DQorCQkg
Ki8NCisJCXJtYigpOw0KIAl9IGVsc2UNCiAJCWNycSA9IE5VTEw7DQogCXNwaW5fdW5sb2NrX2ly
cXJlc3RvcmUoJnF1ZXVlLT5sb2NrLCBmbGFncyk7DQpAQCAtMTIyLDYgKzEyNywxMSBAQCBzdGF0
aWMgaW50IHJwYXZzY3NpX3NlbmRfY3JxKHN0cnVjdCBpYm12c2NzaV9ob3N0X2RhdGEgKmhvc3Rk
YXRhLA0KIHsNCiAJc3RydWN0IHZpb19kZXYgKnZkZXYgPSB0b192aW9fZGV2KGhvc3RkYXRhLT5k
ZXYpOw0KIA0KKwkvKg0KKwkgKiBFbnN1cmUgdGhlIGNvbW1hbmQgYnVmZmVyIGlzIGZsdXNoZWQg
dG8gbWVtb3J5IGJlZm9yZSBoYW5kaW5nIGl0DQorCSAqIG92ZXIgdG8gdGhlIFZJT1MgdG8gcHJl
dmVudCBpdCBmcm9tIGZldGNoaW5nIGFueSBzdGFsZSBkYXRhLg0KKwkgKi8NCisJbWIoKTsNCiAJ
cmV0dXJuIHBscGFyX2hjYWxsX25vcmV0cyhIX1NFTkRfQ1JRLCB2ZGV2LT51bml0X2FkZHJlc3Ms
IHdvcmQxLCB3b3JkMik7DQogfQ0KIA0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS9zZC5jIGIv
ZHJpdmVycy9zY3NpL3NkLmMNCmluZGV4IGY2ZDJiNjIuLjVjNmI1ZjUgMTAwNjQ0DQotLS0gYS9k
cml2ZXJzL3Njc2kvc2QuYw0KKysrIGIvZHJpdmVycy9zY3NpL3NkLmMNCkBAIC0yMTQ5LDcgKzIx
NDksMTAgQEAgc2RfcmVhZF9jYWNoZV90eXBlKHN0cnVjdCBzY3NpX2Rpc2sgKnNka3AsIHVuc2ln
bmVkIGNoYXIgKmJ1ZmZlcikNCiAJCX0NCiANCiAJCXNka3AtPkRQT0ZVQSA9IChkYXRhLmRldmlj
ZV9zcGVjaWZpYyAmIDB4MTApICE9IDA7DQotCQlpZiAoc2RrcC0+RFBPRlVBICYmICFzZGtwLT5k
ZXZpY2UtPnVzZV8xMF9mb3JfcncpIHsNCisJCWlmIChzZHAtPmJyb2tlbl9mdWEpIHsNCisJCQlz
ZF9wcmludGsoS0VSTl9OT1RJQ0UsIHNka3AsICJEaXNhYmxpbmcgRlVBXG4iKTsNCisJCQlzZGtw
LT5EUE9GVUEgPSAwOw0KKwkJfSBlbHNlIGlmIChzZGtwLT5EUE9GVUEgJiYgIXNka3AtPmRldmlj
ZS0+dXNlXzEwX2Zvcl9ydykgew0KIAkJCXNkX3ByaW50ayhLRVJOX05PVElDRSwgc2RrcCwNCiAJ
CQkJICAiVXNlcyBSRUFEL1dSSVRFKDYpLCBkaXNhYmxpbmcgRlVBXG4iKTsNCiAJCQlzZGtwLT5E
UE9GVUEgPSAwOw0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS9zeW01M2M4eHhfMi9zeW1faGlw
ZC5jIGIvZHJpdmVycy9zY3NpL3N5bTUzYzh4eF8yL3N5bV9oaXBkLmMNCmluZGV4IGQ5MmZlNDAu
LjZiMzQ5ZTMgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3Njc2kvc3ltNTNjOHh4XzIvc3ltX2hpcGQu
Yw0KKysrIGIvZHJpdmVycy9zY3NpL3N5bTUzYzh4eF8yL3N5bV9oaXBkLmMNCkBAIC0zMDAwLDcg
KzMwMDAsMTEgQEAgc3ltX2RlcXVldWVfZnJvbV9zcXVldWUoc3RydWN0IHN5bV9oY2IgKm5wLCBp
bnQgaSwgaW50IHRhcmdldCwgaW50IGx1biwgaW50IHRhc2sNCiAJCWlmICgodGFyZ2V0ID09IC0x
IHx8IGNwLT50YXJnZXQgPT0gdGFyZ2V0KSAmJg0KIAkJICAgIChsdW4gICAgPT0gLTEgfHwgY3At
Pmx1biAgICA9PSBsdW4pICAgICYmDQogCQkgICAgKHRhc2sgICA9PSAtMSB8fCBjcC0+dGFnICAg
ID09IHRhc2spKSB7DQorI2lmZGVmIFNZTV9PUFRfSEFORExFX0RFVklDRV9RVUVVRUlORw0KIAkJ
CXN5bV9zZXRfY2FtX3N0YXR1cyhjcC0+Y21kLCBESURfU09GVF9FUlJPUik7DQorI2Vsc2UNCisJ
CQlzeW1fc2V0X2NhbV9zdGF0dXMoY3AtPmNtZCwgRElEX1JFUVVFVUUpOw0KKyNlbmRpZg0KIAkJ
CXN5bV9yZW1xdWUoJmNwLT5saW5rX2NjYnEpOw0KIAkJCXN5bV9pbnNxdWVfdGFpbCgmY3AtPmxp
bmtfY2NicSwgJm5wLT5jb21wX2NjYnEpOw0KIAkJfQ0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvdXNi
L2NvcmUvaHViLmMgYi9kcml2ZXJzL3VzYi9jb3JlL2h1Yi5jDQppbmRleCAxMmYzYTM3Li4zODA3
Mjk0IDEwMDY0NA0KLS0tIGEvZHJpdmVycy91c2IvY29yZS9odWIuYw0KKysrIGIvZHJpdmVycy91
c2IvY29yZS9odWIuYw0KQEAgLTY1NSw2ICs2NTUsMjYgQEAgc3RhdGljIGludCBodWJfdXNiM19w
b3J0X2Rpc2FibGUoc3RydWN0IHVzYl9odWIgKmh1YiwgaW50IHBvcnQxKQ0KIAlpZiAoIWh1Yl9p
c19zdXBlcnNwZWVkKGh1Yi0+aGRldikpDQogCQlyZXR1cm4gLUVJTlZBTDsNCiANCisJcmV0ID0g
aHViX3BvcnRfc3RhdHVzKGh1YiwgcG9ydDEsICZwb3J0c3RhdHVzLCAmcG9ydGNoYW5nZSk7DQor
CWlmIChyZXQgPCAwKQ0KKwkJcmV0dXJuIHJldDsNCisNCisJLyoNCisJICogVVNCIGNvbnRyb2xs
ZXIgQWR2YW5jZWQgTWljcm8gRGV2aWNlcywgSW5jLiBbQU1EXSBGQ0ggVVNCIFhIQ0kNCisJICog
Q29udHJvbGxlciBbMTAyMjo3ODE0XSB3aWxsIGhhdmUgc3B1cmlvdXMgcmVzdWx0IG1ha2luZyB0
aGUgZm9sbG93aW5nDQorCSAqIHVzYiAzLjAgZGV2aWNlIGhvdHBsdWdnaW5nIHJvdXRlIHRvIHRo
ZSAyLjAgcm9vdCBodWIgYW5kIHJlY29nbml6ZWQNCisJICogYXMgaGlnaC1zcGVlZCBkZXZpY2Ug
aWYgd2Ugc2V0IHRoZSB1c2IgMy4wIHBvcnQgbGluayBzdGF0ZSB0bw0KKwkgKiBEaXNhYmxlZC4g
U2luY2UgaXQncyBhbHJlYWR5IGluIFVTQl9TU19QT1JUX0xTX1JYX0RFVEVDVCBzdGF0ZSwgd2UN
CisJICogY2hlY2sgdGhlIHN0YXRlIGhlcmUgdG8gYXZvaWQgdGhlIGJ1Zy4NCisJICovDQorCWlm
ICgocG9ydHN0YXR1cyAmIFVTQl9QT1JUX1NUQVRfTElOS19TVEFURSkgPT0NCisJCQkJVVNCX1NT
X1BPUlRfTFNfUlhfREVURUNUKSB7DQorCQlkZXZfZGJnKGh1Yi0+aW50ZmRldiwNCisJCQkiTm90
IGRpc2FibGluZyBwb3J0ICVkOyBsaW5rIHN0YXRlIGlzIFJ4RGV0ZWN0XG4iLA0KKwkJCXBvcnQx
KTsNCisJCXJldHVybiByZXQ7DQorCX0NCisNCiAJcmV0ID0gaHViX3NldF9wb3J0X2xpbmtfc3Rh
dGUoaHViLCBwb3J0MSwgVVNCX1NTX1BPUlRfTFNfU1NfRElTQUJMRUQpOw0KIAlpZiAocmV0KSB7
DQogCQlkZXZfZXJyKGh1Yi0+aW50ZmRldiwgImNhbm5vdCBkaXNhYmxlIHBvcnQgJWQgKGVyciA9
ICVkKVxuIiwNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3VzYi9nYWRnZXQvZl9mcy5jIGIvZHJpdmVy
cy91c2IvZ2FkZ2V0L2ZfZnMuYw0KaW5kZXggMGU2NDFhMS4uYzYzNWM0YyAxMDA2NDQNCi0tLSBh
L2RyaXZlcnMvdXNiL2dhZGdldC9mX2ZzLmMNCisrKyBiL2RyaXZlcnMvdXNiL2dhZGdldC9mX2Zz
LmMNCkBAIC0xMzc2LDExICsxMzc2LDEzIEBAIHN0YXRpYyBpbnQgZnVuY3Rpb25mc19iaW5kKHN0
cnVjdCBmZnNfZGF0YSAqZmZzLCBzdHJ1Y3QgdXNiX2NvbXBvc2l0ZV9kZXYgKmNkZXYpDQogCWZm
cy0+ZXAwcmVxLT5jb250ZXh0ID0gZmZzOw0KIA0KIAlsYW5nID0gZmZzLT5zdHJpbmd0YWJzOw0K
LQlmb3IgKGxhbmcgPSBmZnMtPnN0cmluZ3RhYnM7ICpsYW5nOyArK2xhbmcpIHsNCi0JCXN0cnVj
dCB1c2Jfc3RyaW5nICpzdHIgPSAoKmxhbmcpLT5zdHJpbmdzOw0KLQkJaW50IGlkID0gZmlyc3Rf
aWQ7DQotCQlmb3IgKDsgc3RyLT5zOyArK2lkLCArK3N0cikNCi0JCQlzdHItPmlkID0gaWQ7DQor
CWlmIChsYW5nKSB7DQorCQlmb3IgKDsgKmxhbmc7ICsrbGFuZykgew0KKwkJCXN0cnVjdCB1c2Jf
c3RyaW5nICpzdHIgPSAoKmxhbmcpLT5zdHJpbmdzOw0KKwkJCWludCBpZCA9IGZpcnN0X2lkOw0K
KwkJCWZvciAoOyBzdHItPnM7ICsraWQsICsrc3RyKQ0KKwkJCQlzdHItPmlkID0gaWQ7DQorCQl9
DQogCX0NCiANCiAJZmZzLT5nYWRnZXQgPSBjZGV2LT5nYWRnZXQ7DQpkaWZmIC0tZ2l0IGEvZHJp
dmVycy91c2IvaG9zdC94aGNpLWh1Yi5jIGIvZHJpdmVycy91c2IvaG9zdC94aGNpLWh1Yi5jDQpp
bmRleCAxMDdlNmI0Li41MTdjYWRiIDEwMDY0NA0KLS0tIGEvZHJpdmVycy91c2IvaG9zdC94aGNp
LWh1Yi5jDQorKysgYi9kcml2ZXJzL3VzYi9ob3N0L3hoY2ktaHViLmMNCkBAIC0yMSw2ICsyMSw3
IEBADQogICovDQogDQogI2luY2x1ZGUgPGxpbnV4L2dmcC5oPg0KKyNpbmNsdWRlIDxsaW51eC9k
ZXZpY2UuaD4NCiAjaW5jbHVkZSA8YXNtL3VuYWxpZ25lZC5oPg0KIA0KICNpbmNsdWRlICJ4aGNp
LmgiDQpAQCAtOTkzLDcgKzk5NCw5IEBAIGludCB4aGNpX2J1c19zdXNwZW5kKHN0cnVjdCB1c2Jf
aGNkICpoY2QpDQogCQkJdDIgfD0gUE9SVF9MSU5LX1NUUk9CRSB8IFhERVZfVTM7DQogCQkJc2V0
X2JpdChwb3J0X2luZGV4LCAmYnVzX3N0YXRlLT5idXNfc3VzcGVuZGVkKTsNCiAJCX0NCi0JCWlm
IChoY2QtPnNlbGYucm9vdF9odWItPmRvX3JlbW90ZV93YWtldXApIHsNCisJCWlmIChoY2QtPnNl
bGYucm9vdF9odWItPmRvX3JlbW90ZV93YWtldXANCisJCQkJJiYgZGV2aWNlX21heV93YWtldXAo
aGNkLT5zZWxmLmNvbnRyb2xsZXIpKSB7DQorDQogCQkJaWYgKHQxICYgUE9SVF9DT05ORUNUKSB7
DQogCQkJCXQyIHw9IFBPUlRfV0tPQ19FIHwgUE9SVF9XS0RJU0NfRTsNCiAJCQkJdDIgJj0gflBP
UlRfV0tDT05OX0U7DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy91c2IvaG9zdC94aGNpLXJpbmcuYyBi
L2RyaXZlcnMvdXNiL2hvc3QveGhjaS1yaW5nLmMNCmluZGV4IDE4ODY1NDQuLmJjNWVlODQgMTAw
NjQ0DQotLS0gYS9kcml2ZXJzL3VzYi9ob3N0L3hoY2ktcmluZy5jDQorKysgYi9kcml2ZXJzL3Vz
Yi9ob3N0L3hoY2ktcmluZy5jDQpAQCAtMzUyMSw3ICszNTIxLDcgQEAgc3RhdGljIHVuc2lnbmVk
IGludCB4aGNpX2dldF9idXJzdF9jb3VudChzdHJ1Y3QgeGhjaV9oY2QgKnhoY2ksDQogCQlyZXR1
cm4gMDsNCiANCiAJbWF4X2J1cnN0ID0gdXJiLT5lcC0+c3NfZXBfY29tcC5iTWF4QnVyc3Q7DQot
CXJldHVybiByb3VuZHVwKHRvdGFsX3BhY2tldF9jb3VudCwgbWF4X2J1cnN0ICsgMSkgLSAxOw0K
KwlyZXR1cm4gRElWX1JPVU5EX1VQKHRvdGFsX3BhY2tldF9jb3VudCwgbWF4X2J1cnN0ICsgMSkg
LSAxOw0KIH0NCiANCiAvKg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvdXNiL2hvc3QveGhjaS5jIGIv
ZHJpdmVycy91c2IvaG9zdC94aGNpLmMNCmluZGV4IGIyZWFjOGQuLjQ1N2E3YWMgMTAwNjQ0DQot
LS0gYS9kcml2ZXJzL3VzYi9ob3N0L3hoY2kuYw0KKysrIGIvZHJpdmVycy91c2IvaG9zdC94aGNp
LmMNCkBAIC05NDYsNyArOTQ2LDcgQEAgaW50IHhoY2lfc3VzcGVuZChzdHJ1Y3QgeGhjaV9oY2Qg
KnhoY2kpDQogICovDQogaW50IHhoY2lfcmVzdW1lKHN0cnVjdCB4aGNpX2hjZCAqeGhjaSwgYm9v
bCBoaWJlcm5hdGVkKQ0KIHsNCi0JdTMyCQkJY29tbWFuZCwgdGVtcCA9IDA7DQorCXUzMgkJCWNv
bW1hbmQsIHRlbXAgPSAwLCBzdGF0dXM7DQogCXN0cnVjdCB1c2JfaGNkCQkqaGNkID0geGhjaV90
b19oY2QoeGhjaSk7DQogCXN0cnVjdCB1c2JfaGNkCQkqc2Vjb25kYXJ5X2hjZDsNCiAJaW50CQkJ
cmV0dmFsID0gMDsNCkBAIC0xMDcwLDggKzEwNzAsMTIgQEAgaW50IHhoY2lfcmVzdW1lKHN0cnVj
dCB4aGNpX2hjZCAqeGhjaSwgYm9vbCBoaWJlcm5hdGVkKQ0KIA0KICBkb25lOg0KIAlpZiAocmV0
dmFsID09IDApIHsNCi0JCXVzYl9oY2RfcmVzdW1lX3Jvb3RfaHViKGhjZCk7DQotCQl1c2JfaGNk
X3Jlc3VtZV9yb290X2h1Yih4aGNpLT5zaGFyZWRfaGNkKTsNCisJCS8qIFJlc3VtZSByb290IGh1
YnMgb25seSB3aGVuIGhhdmUgcGVuZGluZyBldmVudHMuICovDQorCQlzdGF0dXMgPSByZWFkbCgm
eGhjaS0+b3BfcmVncy0+c3RhdHVzKTsNCisJCWlmIChzdGF0dXMgJiBTVFNfRUlOVCkgew0KKwkJ
CXVzYl9oY2RfcmVzdW1lX3Jvb3RfaHViKGhjZCk7DQorCQkJdXNiX2hjZF9yZXN1bWVfcm9vdF9o
dWIoeGhjaS0+c2hhcmVkX2hjZCk7DQorCQl9DQogCX0NCiANCiAJLyoNCmRpZmYgLS1naXQgYS9k
cml2ZXJzL3VzYi9zZXJpYWwvY3AyMTB4LmMgYi9kcml2ZXJzL3VzYi9zZXJpYWwvY3AyMTB4LmMN
CmluZGV4IDAxZmQ2NGEuLjNkZTYzZjUgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3VzYi9zZXJpYWwv
Y3AyMTB4LmMNCisrKyBiL2RyaXZlcnMvdXNiL3NlcmlhbC9jcDIxMHguYw0KQEAgLTE1OSw2ICsx
NTksNyBAQCBzdGF0aWMgY29uc3Qgc3RydWN0IHVzYl9kZXZpY2VfaWQgaWRfdGFibGVbXSA9IHsN
CiAJeyBVU0JfREVWSUNFKDB4MTg0MywgMHgwMjAwKSB9LCAvKiBWYWlzYWxhIFVTQiBJbnN0cnVt
ZW50IENhYmxlICovDQogCXsgVVNCX0RFVklDRSgweDE4RUYsIDB4RTAwRikgfSwgLyogRUxWIFVT
Qi1JMkMtSW50ZXJmYWNlICovDQogCXsgVVNCX0RFVklDRSgweDFBREIsIDB4MDAwMSkgfSwgLyog
U2Nod2VpdHplciBFbmdpbmVlcmluZyBDNjYyIENhYmxlICovDQorCXsgVVNCX0RFVklDRSgweDFC
MUMsIDB4MUMwMCkgfSwgLyogQ29yc2FpciBVU0IgRG9uZ2xlICovDQogCXsgVVNCX0RFVklDRSgw
eDFCRTMsIDB4MDdBNikgfSwgLyogV0FHTyA3NTAtOTIzIFVTQiBTZXJ2aWNlIENhYmxlICovDQog
CXsgVVNCX0RFVklDRSgweDFFMjksIDB4MDEwMikgfSwgLyogRmVzdG8gQ1BYLVVTQiAqLw0KIAl7
IFVTQl9ERVZJQ0UoMHgxRTI5LCAweDA1MDEpIH0sIC8qIEZlc3RvIENNU1AgKi8NCmRpZmYgLS1n
aXQgYS9kcml2ZXJzL3VzYi9zZXJpYWwvZnRkaV9zaW8uYyBiL2RyaXZlcnMvdXNiL3NlcmlhbC9m
dGRpX3Npby5jDQppbmRleCA2ZTA4NjM5Li5kNmU2MjA1IDEwMDY0NA0KLS0tIGEvZHJpdmVycy91
c2Ivc2VyaWFsL2Z0ZGlfc2lvLmMNCisrKyBiL2RyaXZlcnMvdXNiL3NlcmlhbC9mdGRpX3Npby5j
DQpAQCAtNzMxLDcgKzczMSw4IEBAIHN0YXRpYyBzdHJ1Y3QgdXNiX2RldmljZV9pZCBpZF90YWJs
ZV9jb21iaW5lZCBbXSA9IHsNCiAJeyBVU0JfREVWSUNFKEZURElfVklELCBGVERJX0FDR19IRkRV
QUxfUElEKSB9LA0KIAl7IFVTQl9ERVZJQ0UoRlRESV9WSUQsIEZURElfWUVJX1NFUlZPQ0VOVEVS
MzFfUElEKSB9LA0KIAl7IFVTQl9ERVZJQ0UoRlRESV9WSUQsIEZURElfVEhPUkxBQlNfUElEKSB9
LA0KLQl7IFVTQl9ERVZJQ0UoVEVTVE9fVklELCBURVNUT19VU0JfSU5URVJGQUNFX1BJRCkgfSwN
CisJeyBVU0JfREVWSUNFKFRFU1RPX1ZJRCwgVEVTVE9fMV9QSUQpIH0sDQorCXsgVVNCX0RFVklD
RShURVNUT19WSUQsIFRFU1RPXzNfUElEKSB9LA0KIAl7IFVTQl9ERVZJQ0UoRlRESV9WSUQsIEZU
RElfR0FNTUFfU0NPVVRfUElEKSB9LA0KIAl7IFVTQl9ERVZJQ0UoRlRESV9WSUQsIEZURElfVEFD
VFJJWF9PUEVOUE9SVF8xM01fUElEKSB9LA0KIAl7IFVTQl9ERVZJQ0UoRlRESV9WSUQsIEZURElf
VEFDVFJJWF9PUEVOUE9SVF8xM1NfUElEKSB9LA0KQEAgLTE1OTEsMTQgKzE1OTIsMTcgQEAgc3Rh
dGljIHZvaWQgZnRkaV9zZXRfbWF4X3BhY2tldF9zaXplKHN0cnVjdCB1c2Jfc2VyaWFsX3BvcnQg
KnBvcnQpDQogCXN0cnVjdCB1c2JfZGV2aWNlICp1ZGV2ID0gc2VyaWFsLT5kZXY7DQogDQogCXN0
cnVjdCB1c2JfaW50ZXJmYWNlICppbnRlcmZhY2UgPSBzZXJpYWwtPmludGVyZmFjZTsNCi0Jc3Ry
dWN0IHVzYl9lbmRwb2ludF9kZXNjcmlwdG9yICplcF9kZXNjID0gJmludGVyZmFjZS0+Y3VyX2Fs
dHNldHRpbmctPmVuZHBvaW50WzFdLmRlc2M7DQorCXN0cnVjdCB1c2JfZW5kcG9pbnRfZGVzY3Jp
cHRvciAqZXBfZGVzYzsNCiANCiAJdW5zaWduZWQgbnVtX2VuZHBvaW50czsNCi0JaW50IGk7DQor
CXVuc2lnbmVkIGk7DQogDQogCW51bV9lbmRwb2ludHMgPSBpbnRlcmZhY2UtPmN1cl9hbHRzZXR0
aW5nLT5kZXNjLmJOdW1FbmRwb2ludHM7DQogCWRldl9pbmZvKCZ1ZGV2LT5kZXYsICJOdW1iZXIg
b2YgZW5kcG9pbnRzICVkXG4iLCBudW1fZW5kcG9pbnRzKTsNCiANCisJaWYgKCFudW1fZW5kcG9p
bnRzKQ0KKwkJcmV0dXJuOw0KKw0KIAkvKiBOT1RFOiBzb21lIGN1c3RvbWVycyBoYXZlIHByb2dy
YW1tZWQgRlQyMzJSL0ZUMjQ1UiBkZXZpY2VzDQogCSAqIHdpdGggYW4gZW5kcG9pbnQgc2l6ZSBv
ZiAwIC0gbm90IGdvb2QuICBJbiB0aGlzIGNhc2UsIHdlDQogCSAqIHdhbnQgdG8gb3ZlcnJpZGUg
dGhlIGVuZHBvaW50IGRlc2NyaXB0b3Igc2V0dGluZyBhbmQgdXNlIGENCmRpZmYgLS1naXQgYS9k
cml2ZXJzL3VzYi9zZXJpYWwvZnRkaV9zaW9faWRzLmggYi9kcml2ZXJzL3VzYi9zZXJpYWwvZnRk
aV9zaW9faWRzLmgNCmluZGV4IDY3N2NmNDkuLjU1YWY5MTUgMTAwNjQ0DQotLS0gYS9kcml2ZXJz
L3VzYi9zZXJpYWwvZnRkaV9zaW9faWRzLmgNCisrKyBiL2RyaXZlcnMvdXNiL3NlcmlhbC9mdGRp
X3Npb19pZHMuaA0KQEAgLTc5OCw3ICs3OTgsOCBAQA0KICAqIFN1Ym1pdHRlZCBieSBDb2xpbiBM
ZXJveQ0KICAqLw0KICNkZWZpbmUgVEVTVE9fVklECQkJMHgxMjhEDQotI2RlZmluZSBURVNUT19V
U0JfSU5URVJGQUNFX1BJRAkJMHgwMDAxDQorI2RlZmluZSBURVNUT18xX1BJRAkJCTB4MDAwMQ0K
KyNkZWZpbmUgVEVTVE9fM19QSUQJCQkweDAwMDMNCiANCiAvKg0KICAqIE1vYmlsaXR5IEVsZWN0
cm9uaWNzIHByb2R1Y3RzLg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvdXNiL3NlcmlhbC9vcHRpb24u
YyBiL2RyaXZlcnMvdXNiL3NlcmlhbC9vcHRpb24uYw0KaW5kZXggYTBmNDdkNS4uN2ExYzkxZSAx
MDA2NDQNCi0tLSBhL2RyaXZlcnMvdXNiL3NlcmlhbC9vcHRpb24uYw0KKysrIGIvZHJpdmVycy91
c2Ivc2VyaWFsL29wdGlvbi5jDQpAQCAtMzc3LDggKzM3NywxMiBAQCBzdGF0aWMgdm9pZCBvcHRp
b25faW5zdGF0X2NhbGxiYWNrKHN0cnVjdCB1cmIgKnVyYik7DQogLyogT2xpdmV0dGkgcHJvZHVj
dHMgKi8NCiAjZGVmaW5lIE9MSVZFVFRJX1ZFTkRPUl9JRAkJCTB4MGIzYw0KICNkZWZpbmUgT0xJ
VkVUVElfUFJPRFVDVF9PTElDQVJEMTAwCQkweGMwMDANCisjZGVmaW5lIE9MSVZFVFRJX1BST0RV
Q1RfT0xJQ0FSRDEyMAkJMHhjMDAxDQorI2RlZmluZSBPTElWRVRUSV9QUk9EVUNUX09MSUNBUkQx
NDAJCTB4YzAwMg0KICNkZWZpbmUgT0xJVkVUVElfUFJPRFVDVF9PTElDQVJEMTQ1CQkweGMwMDMN
CisjZGVmaW5lIE9MSVZFVFRJX1BST0RVQ1RfT0xJQ0FSRDE1NQkJMHhjMDA0DQogI2RlZmluZSBP
TElWRVRUSV9QUk9EVUNUX09MSUNBUkQyMDAJCTB4YzAwNQ0KKyNkZWZpbmUgT0xJVkVUVElfUFJP
RFVDVF9PTElDQVJEMTYwCQkweGMwMGENCiAjZGVmaW5lIE9MSVZFVFRJX1BST0RVQ1RfT0xJQ0FS
RDUwMAkJMHhjMDBiDQogDQogLyogQ2Vsb3QgcHJvZHVjdHMgKi8NCkBAIC0xNDk0LDYgKzE0OTgs
OCBAQCBzdGF0aWMgY29uc3Qgc3RydWN0IHVzYl9kZXZpY2VfaWQgb3B0aW9uX2lkc1tdID0gew0K
IAkJLmRyaXZlcl9pbmZvID0gKGtlcm5lbF91bG9uZ190KSZuZXRfaW50ZjJfYmxhY2tsaXN0IH0s
DQogCXsgVVNCX0RFVklDRV9BTkRfSU5URVJGQUNFX0lORk8oWlRFX1ZFTkRPUl9JRCwgMHgxNDI2
LCAweGZmLCAweGZmLCAweGZmKSwgIC8qIFpURSBNRjkxICovDQogCQkuZHJpdmVyX2luZm8gPSAo
a2VybmVsX3Vsb25nX3QpJm5ldF9pbnRmMl9ibGFja2xpc3QgfSwNCisJeyBVU0JfREVWSUNFX0FO
RF9JTlRFUkZBQ0VfSU5GTyhaVEVfVkVORE9SX0lELCAweDE0MjgsIDB4ZmYsIDB4ZmYsIDB4ZmYp
LCAgLyogVGVsZXdlbGwgVFctTFRFIDRHIHYyICovDQorCQkuZHJpdmVyX2luZm8gPSAoa2VybmVs
X3Vsb25nX3QpJm5ldF9pbnRmMl9ibGFja2xpc3QgfSwNCiAJeyBVU0JfREVWSUNFX0FORF9JTlRF
UkZBQ0VfSU5GTyhaVEVfVkVORE9SX0lELCAweDE1MzMsIDB4ZmYsIDB4ZmYsIDB4ZmYpIH0sDQog
CXsgVVNCX0RFVklDRV9BTkRfSU5URVJGQUNFX0lORk8oWlRFX1ZFTkRPUl9JRCwgMHgxNTM0LCAw
eGZmLCAweGZmLCAweGZmKSB9LA0KIAl7IFVTQl9ERVZJQ0VfQU5EX0lOVEVSRkFDRV9JTkZPKFpU
RV9WRU5ET1JfSUQsIDB4MTUzNSwgMHhmZiwgMHhmZiwgMHhmZikgfSwNCkBAIC0xNjMxLDE1ICsx
NjM3LDIxIEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgdXNiX2RldmljZV9pZCBvcHRpb25faWRzW10g
PSB7DQogCXsgVVNCX0RFVklDRShTSUVNRU5TX1ZFTkRPUl9JRCwgQ0lOVEVSSU9OX1BST0RVQ1Rf
SEMyNV9NRE1ORVQpIH0sDQogCXsgVVNCX0RFVklDRShTSUVNRU5TX1ZFTkRPUl9JRCwgQ0lOVEVS
SU9OX1BST0RVQ1RfSEMyOF9NRE0pIH0sIC8qIEhDMjggZW51bWVyYXRlcyB3aXRoIFNpZW1lbnMg
b3IgQ2ludGVyaW9uIFZJRCBkZXBlbmRpbmcgb24gRlcgcmV2aXNpb24gKi8NCiAJeyBVU0JfREVW
SUNFKFNJRU1FTlNfVkVORE9SX0lELCBDSU5URVJJT05fUFJPRFVDVF9IQzI4X01ETU5FVCkgfSwN
Ci0NCi0JeyBVU0JfREVWSUNFKE9MSVZFVFRJX1ZFTkRPUl9JRCwgT0xJVkVUVElfUFJPRFVDVF9P
TElDQVJEMTAwKSB9LA0KKwl7IFVTQl9ERVZJQ0UoT0xJVkVUVElfVkVORE9SX0lELCBPTElWRVRU
SV9QUk9EVUNUX09MSUNBUkQxMDApLA0KKwkJLmRyaXZlcl9pbmZvID0gKGtlcm5lbF91bG9uZ190
KSZuZXRfaW50ZjRfYmxhY2tsaXN0IH0sDQorCXsgVVNCX0RFVklDRShPTElWRVRUSV9WRU5ET1Jf
SUQsIE9MSVZFVFRJX1BST0RVQ1RfT0xJQ0FSRDEyMCksDQorCQkuZHJpdmVyX2luZm8gPSAoa2Vy
bmVsX3Vsb25nX3QpJm5ldF9pbnRmNF9ibGFja2xpc3QgfSwNCisJeyBVU0JfREVWSUNFKE9MSVZF
VFRJX1ZFTkRPUl9JRCwgT0xJVkVUVElfUFJPRFVDVF9PTElDQVJEMTQwKSwNCisJCS5kcml2ZXJf
aW5mbyA9IChrZXJuZWxfdWxvbmdfdCkmbmV0X2ludGY0X2JsYWNrbGlzdCB9LA0KIAl7IFVTQl9E
RVZJQ0UoT0xJVkVUVElfVkVORE9SX0lELCBPTElWRVRUSV9QUk9EVUNUX09MSUNBUkQxNDUpIH0s
DQorCXsgVVNCX0RFVklDRShPTElWRVRUSV9WRU5ET1JfSUQsIE9MSVZFVFRJX1BST0RVQ1RfT0xJ
Q0FSRDE1NSksDQorCQkuZHJpdmVyX2luZm8gPSAoa2VybmVsX3Vsb25nX3QpJm5ldF9pbnRmNl9i
bGFja2xpc3QgfSwNCiAJeyBVU0JfREVWSUNFKE9MSVZFVFRJX1ZFTkRPUl9JRCwgT0xJVkVUVElf
UFJPRFVDVF9PTElDQVJEMjAwKSwNCi0JCS5kcml2ZXJfaW5mbyA9IChrZXJuZWxfdWxvbmdfdCkm
bmV0X2ludGY2X2JsYWNrbGlzdA0KLQl9LA0KKwkJLmRyaXZlcl9pbmZvID0gKGtlcm5lbF91bG9u
Z190KSZuZXRfaW50ZjZfYmxhY2tsaXN0IH0sDQorCXsgVVNCX0RFVklDRShPTElWRVRUSV9WRU5E
T1JfSUQsIE9MSVZFVFRJX1BST0RVQ1RfT0xJQ0FSRDE2MCksDQorCQkuZHJpdmVyX2luZm8gPSAo
a2VybmVsX3Vsb25nX3QpJm5ldF9pbnRmNl9ibGFja2xpc3QgfSwNCiAJeyBVU0JfREVWSUNFKE9M
SVZFVFRJX1ZFTkRPUl9JRCwgT0xJVkVUVElfUFJPRFVDVF9PTElDQVJENTAwKSwNCi0JCS5kcml2
ZXJfaW5mbyA9IChrZXJuZWxfdWxvbmdfdCkmbmV0X2ludGY0X2JsYWNrbGlzdA0KLQl9LA0KKwkJ
LmRyaXZlcl9pbmZvID0gKGtlcm5lbF91bG9uZ190KSZuZXRfaW50ZjRfYmxhY2tsaXN0IH0sDQog
CXsgVVNCX0RFVklDRShDRUxPVF9WRU5ET1JfSUQsIENFTE9UX1BST0RVQ1RfQ1Q2ODBNKSB9LCAv
KiBDVC02NTAgQ0RNQSA0NTAgMXhFVkRPIG1vZGVtICovDQogCXsgVVNCX0RFVklDRV9BTkRfSU5U
RVJGQUNFX0lORk8oU0FNU1VOR19WRU5ET1JfSUQsIFNBTVNVTkdfUFJPRFVDVF9HVF9CMzczMCwg
VVNCX0NMQVNTX0NEQ19EQVRBLCAweDAwLCAweDAwKSB9LCAvKiBTYW1zdW5nIEdULUIzNzMwIExU
RSBVU0IgbW9kZW0uKi8NCiAJeyBVU0JfREVWSUNFKFlVR0FfVkVORE9SX0lELCBZVUdBX1BST0RV
Q1RfQ0VNNjAwKSB9LA0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvdXNiL3N0b3JhZ2Uvc2NzaWdsdWUu
YyBiL2RyaXZlcnMvdXNiL3N0b3JhZ2Uvc2NzaWdsdWUuYw0KaW5kZXggZWI2NjBiYi4uYjhkYzBj
NSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvdXNiL3N0b3JhZ2Uvc2NzaWdsdWUuYw0KKysrIGIvZHJp
dmVycy91c2Ivc3RvcmFnZS9zY3NpZ2x1ZS5jDQpAQCAtMjU1LDYgKzI1NSwxMCBAQCBzdGF0aWMg
aW50IHNsYXZlX2NvbmZpZ3VyZShzdHJ1Y3Qgc2NzaV9kZXZpY2UgKnNkZXYpDQogCQkJCQlVU19G
TF9TQ01fTVVMVF9UQVJHKSkgJiYNCiAJCQkJdXMtPnByb3RvY29sID09IFVTQl9QUl9CVUxLKQ0K
IAkJCXVzLT51c2VfbGFzdF9zZWN0b3JfaGFja3MgPSAxOw0KKw0KKwkJLyogQSBmZXcgYnVnZ3kg
VVNCLUFUQSBicmlkZ2VzIGRvbid0IHVuZGVyc3RhbmQgRlVBICovDQorCQlpZiAodXMtPmZmbGFn
cyAmIFVTX0ZMX0JST0tFTl9GVUEpDQorCQkJc2Rldi0+YnJva2VuX2Z1YSA9IDE7DQogCX0gZWxz
ZSB7DQogDQogCQkvKiBOb24tZGlzay10eXBlIGRldmljZXMgZG9uJ3QgbmVlZCB0byBibGFja2xp
c3QgYW55IHBhZ2VzDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy91c2Ivc3RvcmFnZS91bnVzdWFsX2Rl
dnMuaCBiL2RyaXZlcnMvdXNiL3N0b3JhZ2UvdW51c3VhbF9kZXZzLmgNCmluZGV4IDQ5ZDIyMmQu
LmU1ODhhMTEgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3VzYi9zdG9yYWdlL3VudXN1YWxfZGV2cy5o
DQorKysgYi9kcml2ZXJzL3VzYi9zdG9yYWdlL3VudXN1YWxfZGV2cy5oDQpAQCAtMTkxNiw2ICsx
OTE2LDEzIEBAIFVOVVNVQUxfREVWKCAgMHgxNGNkLCAweDY2MDAsIDB4MDIwMSwgMHgwMjAxLA0K
IAkJVVNCX1NDX0RFVklDRSwgVVNCX1BSX0RFVklDRSwgTlVMTCwNCiAJCVVTX0ZMX0lHTk9SRV9S
RVNJRFVFICksDQogDQorLyogUmVwb3J0ZWQgYnkgTWljaGFlbCBCw7xzY2ggPG1AYnVlcy5jaD4g
Ki8NCitVTlVTVUFMX0RFViggIDB4MTUyZCwgMHgwNTY3LCAweDAxMTQsIDB4MDExNCwNCisJCSJK
TWljcm9uIiwNCisJCSJVU0IgdG8gQVRBL0FUQVBJIEJyaWRnZSIsDQorCQlVU0JfU0NfREVWSUNF
LCBVU0JfUFJfREVWSUNFLCBOVUxMLA0KKwkJVVNfRkxfQlJPS0VOX0ZVQSApLA0KKw0KIC8qIFJl
cG9ydGVkIGJ5IEFsZXhhbmRyZSBPbGl2YSA8b2xpdmFAbHNkLmljLnVuaWNhbXAuYnI+DQogICog
Sk1pY3JvbiByZXNwb25kcyB0byBVU04gYW5kIHNldmVyYWwgb3RoZXIgU0NTSSBpb2N0bHMgd2l0
aCBhDQogICogcmVzaWR1ZSB0aGF0IGNhdXNlcyBzdWJzZXF1ZW50IEkvTyByZXF1ZXN0cyB0byBm
YWlsLiAgKi8NCmRpZmYgLS1naXQgYS9kcml2ZXJzL3hlbi9tYW5hZ2UuYyBiL2RyaXZlcnMveGVu
L21hbmFnZS5jDQppbmRleCBjZTRmYTA4Li5jOGFmN2U1IDEwMDY0NA0KLS0tIGEvZHJpdmVycy94
ZW4vbWFuYWdlLmMNCisrKyBiL2RyaXZlcnMveGVuL21hbmFnZS5jDQpAQCAtOTMsNyArOTMsNiBA
QCBzdGF0aWMgaW50IHhlbl9zdXNwZW5kKHZvaWQgKmRhdGEpDQogDQogCWlmICghc2ktPmNhbmNl
bGxlZCkgew0KIAkJeGVuX2lycV9yZXN1bWUoKTsNCi0JCXhlbl9jb25zb2xlX3Jlc3VtZSgpOw0K
IAkJeGVuX3RpbWVyX3Jlc3VtZSgpOw0KIAl9DQogDQpAQCAtMTQ5LDYgKzE0OCwxMCBAQCBzdGF0
aWMgdm9pZCBkb19zdXNwZW5kKHZvaWQpDQogDQogCWVyciA9IHN0b3BfbWFjaGluZSh4ZW5fc3Vz
cGVuZCwgJnNpLCBjcHVtYXNrX29mKDApKTsNCiANCisJLyogUmVzdW1lIGNvbnNvbGUgYXMgZWFy
bHkgYXMgcG9zc2libGUuICovDQorCWlmICghc2kuY2FuY2VsbGVkKQ0KKwkJeGVuX2NvbnNvbGVf
cmVzdW1lKCk7DQorDQogCWRwbV9yZXN1bWVfbm9pcnEoc2kuY2FuY2VsbGVkID8gUE1TR19USEFX
IDogUE1TR19SRVNUT1JFKTsNCiANCiAJaWYgKGVycikgew0KZGlmZiAtLWdpdCBhL2ZzL2NlcGgv
c25hcC5jIGIvZnMvY2VwaC9zbmFwLmMNCmluZGV4IGE1NTljODAuLmU1MjA2ZmMgMTAwNjQ0DQot
LS0gYS9mcy9jZXBoL3NuYXAuYw0KKysrIGIvZnMvY2VwaC9zbmFwLmMNCkBAIC0zMzEsNyArMzMx
LDcgQEAgc3RhdGljIGludCBidWlsZF9zbmFwX2NvbnRleHQoc3RydWN0IGNlcGhfc25hcF9yZWFs
bSAqcmVhbG0pDQogDQogCS8qIGFsbG9jIG5ldyBzbmFwIGNvbnRleHQgKi8NCiAJZXJyID0gLUVO
T01FTTsNCi0JaWYgKG51bSA+IFVMT05HX01BWCAvIHNpemVvZih1NjQpIC0gc2l6ZW9mKCpzbmFw
YykpDQorCWlmIChudW0gPiAoU0laRV9NQVggLSBzaXplb2YoKnNuYXBjKSkgLyBzaXplb2YodTY0
KSkNCiAJCWdvdG8gZmFpbDsNCiAJc25hcGMgPSBremFsbG9jKHNpemVvZigqc25hcGMpICsgbnVt
KnNpemVvZih1NjQpLCBHRlBfTk9GUyk7DQogCWlmICghc25hcGMpDQpkaWZmIC0tZ2l0IGEvZnMv
ZXh0NC9zdXBlci5jIGIvZnMvZXh0NC9zdXBlci5jDQppbmRleCBhY2YyYmFmLi42NTgxZWU3IDEw
MDY0NA0KLS0tIGEvZnMvZXh0NC9zdXBlci5jDQorKysgYi9mcy9leHQ0L3N1cGVyLmMNCkBAIC0x
NjYzLDggKzE2NjMsNiBAQCBzdGF0aWMgaW50IHBhcnNlX29wdGlvbnMoY2hhciAqb3B0aW9ucywg
c3RydWN0IHN1cGVyX2Jsb2NrICpzYiwNCiAJCQkJcmV0dXJuIDA7DQogCQkJaWYgKG9wdGlvbiA8
IDApDQogCQkJCXJldHVybiAwOw0KLQkJCWlmIChvcHRpb24gPT0gMCkNCi0JCQkJb3B0aW9uID0g
RVhUNF9ERUZfTUFYX0JBVENIX1RJTUU7DQogCQkJc2JpLT5zX21heF9iYXRjaF90aW1lID0gb3B0
aW9uOw0KIAkJCWJyZWFrOw0KIAkJY2FzZSBPcHRfbWluX2JhdGNoX3RpbWU6DQpAQCAtMjcyNiwx
MCArMjcyNCwxMSBAQCBzdGF0aWMgdm9pZCBwcmludF9kYWlseV9lcnJvcl9pbmZvKHVuc2lnbmVk
IGxvbmcgYXJnKQ0KIAllcyA9IHNiaS0+c19lczsNCiANCiAJaWYgKGVzLT5zX2Vycm9yX2NvdW50
KQ0KLQkJZXh0NF9tc2coc2IsIEtFUk5fTk9USUNFLCAiZXJyb3IgY291bnQ6ICV1IiwNCisJCS8q
IGZzY2sgbmV3ZXIgdGhhbiB2MS40MS4xMyBpcyBuZWVkZWQgdG8gY2xlYW4gdGhpcyBjb25kaXRp
b24uICovDQorCQlleHQ0X21zZyhzYiwgS0VSTl9OT1RJQ0UsICJlcnJvciBjb3VudCBzaW5jZSBs
YXN0IGZzY2s6ICV1IiwNCiAJCQkgbGUzMl90b19jcHUoZXMtPnNfZXJyb3JfY291bnQpKTsNCiAJ
aWYgKGVzLT5zX2ZpcnN0X2Vycm9yX3RpbWUpIHsNCi0JCXByaW50ayhLRVJOX05PVElDRSAiRVhU
NC1mcyAoJXMpOiBpbml0aWFsIGVycm9yIGF0ICV1OiAlLipzOiVkIiwNCisJCXByaW50ayhLRVJO
X05PVElDRSAiRVhUNC1mcyAoJXMpOiBpbml0aWFsIGVycm9yIGF0IHRpbWUgJXU6ICUuKnM6JWQi
LA0KIAkJICAgICAgIHNiLT5zX2lkLCBsZTMyX3RvX2NwdShlcy0+c19maXJzdF9lcnJvcl90aW1l
KSwNCiAJCSAgICAgICAoaW50KSBzaXplb2YoZXMtPnNfZmlyc3RfZXJyb3JfZnVuYyksDQogCQkg
ICAgICAgZXMtPnNfZmlyc3RfZXJyb3JfZnVuYywNCkBAIC0yNzQzLDcgKzI3NDIsNyBAQCBzdGF0
aWMgdm9pZCBwcmludF9kYWlseV9lcnJvcl9pbmZvKHVuc2lnbmVkIGxvbmcgYXJnKQ0KIAkJcHJp
bnRrKCJcbiIpOw0KIAl9DQogCWlmIChlcy0+c19sYXN0X2Vycm9yX3RpbWUpIHsNCi0JCXByaW50
ayhLRVJOX05PVElDRSAiRVhUNC1mcyAoJXMpOiBsYXN0IGVycm9yIGF0ICV1OiAlLipzOiVkIiwN
CisJCXByaW50ayhLRVJOX05PVElDRSAiRVhUNC1mcyAoJXMpOiBsYXN0IGVycm9yIGF0IHRpbWUg
JXU6ICUuKnM6JWQiLA0KIAkJICAgICAgIHNiLT5zX2lkLCBsZTMyX3RvX2NwdShlcy0+c19sYXN0
X2Vycm9yX3RpbWUpLA0KIAkJICAgICAgIChpbnQpIHNpemVvZihlcy0+c19sYXN0X2Vycm9yX2Z1
bmMpLA0KIAkJICAgICAgIGVzLT5zX2xhc3RfZXJyb3JfZnVuYywNCmRpZmYgLS1naXQgYS9mcy9m
dXNlL2Rpci5jIGIvZnMvZnVzZS9kaXIuYw0KaW5kZXggMDZlMmY3My4uZTEzNTU4YyAxMDA2NDQN
Ci0tLSBhL2ZzL2Z1c2UvZGlyLmMNCisrKyBiL2ZzL2Z1c2UvZGlyLmMNCkBAIC0xNjEsNyArMTYx
LDcgQEAgc3RhdGljIGludCBmdXNlX2RlbnRyeV9yZXZhbGlkYXRlKHN0cnVjdCBkZW50cnkgKmVu
dHJ5LCBzdHJ1Y3QgbmFtZWlkYXRhICpuZCkNCiAJaW5vZGUgPSBBQ0NFU1NfT05DRShlbnRyeS0+
ZF9pbm9kZSk7DQogCWlmIChpbm9kZSAmJiBpc19iYWRfaW5vZGUoaW5vZGUpKQ0KIAkJcmV0dXJu
IDA7DQotCWVsc2UgaWYgKGZ1c2VfZGVudHJ5X3RpbWUoZW50cnkpIDwgZ2V0X2ppZmZpZXNfNjQo
KSkgew0KKwllbHNlIGlmICh0aW1lX2JlZm9yZTY0KGZ1c2VfZGVudHJ5X3RpbWUoZW50cnkpLCBn
ZXRfamlmZmllc182NCgpKSkgew0KIAkJaW50IGVycjsNCiAJCXN0cnVjdCBmdXNlX2VudHJ5X291
dCBvdXRhcmc7DQogCQlzdHJ1Y3QgZnVzZV9jb25uICpmYzsNCkBAIC04NDksNyArODQ5LDcgQEAg
aW50IGZ1c2VfdXBkYXRlX2F0dHJpYnV0ZXMoc3RydWN0IGlub2RlICppbm9kZSwgc3RydWN0IGtz
dGF0ICpzdGF0LA0KIAlpbnQgZXJyOw0KIAlib29sIHI7DQogDQotCWlmIChmaS0+aV90aW1lIDwg
Z2V0X2ppZmZpZXNfNjQoKSkgew0KKwlpZiAodGltZV9iZWZvcmU2NChmaS0+aV90aW1lLCBnZXRf
amlmZmllc182NCgpKSkgew0KIAkJciA9IHRydWU7DQogCQllcnIgPSBmdXNlX2RvX2dldGF0dHIo
aW5vZGUsIHN0YXQsIGZpbGUpOw0KIAl9IGVsc2Ugew0KQEAgLTEwMDksNyArMTAwOSw3IEBAIHN0
YXRpYyBpbnQgZnVzZV9wZXJtaXNzaW9uKHN0cnVjdCBpbm9kZSAqaW5vZGUsIGludCBtYXNrKQ0K
IAkgICAgKChtYXNrICYgTUFZX0VYRUMpICYmIFNfSVNSRUcoaW5vZGUtPmlfbW9kZSkpKSB7DQog
CQlzdHJ1Y3QgZnVzZV9pbm9kZSAqZmkgPSBnZXRfZnVzZV9pbm9kZShpbm9kZSk7DQogDQotCQlp
ZiAoZmktPmlfdGltZSA8IGdldF9qaWZmaWVzXzY0KCkpIHsNCisJCWlmICh0aW1lX2JlZm9yZTY0
KGZpLT5pX3RpbWUsIGdldF9qaWZmaWVzXzY0KCkpKSB7DQogCQkJcmVmcmVzaGVkID0gdHJ1ZTsN
CiANCiAJCQllcnIgPSBmdXNlX3Blcm1fZ2V0YXR0cihpbm9kZSwgbWFzayk7DQpkaWZmIC0tZ2l0
IGEvZnMvZnVzZS9pbm9kZS5jIGIvZnMvZnVzZS9pbm9kZS5jDQppbmRleCA5MTJjMjUwLi5hZmMw
ZjcwNiAxMDA2NDQNCi0tLSBhL2ZzL2Z1c2UvaW5vZGUuYw0KKysrIGIvZnMvZnVzZS9pbm9kZS5j
DQpAQCAtNDM3LDYgKzQzNywxNyBAQCBzdGF0aWMgY29uc3QgbWF0Y2hfdGFibGVfdCB0b2tlbnMg
PSB7DQogCXtPUFRfRVJSLAkJCU5VTEx9DQogfTsNCiANCitzdGF0aWMgaW50IGZ1c2VfbWF0Y2hf
dWludChzdWJzdHJpbmdfdCAqcywgdW5zaWduZWQgaW50ICpyZXMpDQorew0KKwlpbnQgZXJyID0g
LUVOT01FTTsNCisJY2hhciAqYnVmID0gbWF0Y2hfc3RyZHVwKHMpOw0KKwlpZiAoYnVmKSB7DQor
CQllcnIgPSBrc3RydG91aW50KGJ1ZiwgMTAsIHJlcyk7DQorCQlrZnJlZShidWYpOw0KKwl9DQor
CXJldHVybiBlcnI7DQorfQ0KKw0KIHN0YXRpYyBpbnQgcGFyc2VfZnVzZV9vcHQoY2hhciAqb3B0
LCBzdHJ1Y3QgZnVzZV9tb3VudF9kYXRhICpkLCBpbnQgaXNfYmRldikNCiB7DQogCWNoYXIgKnA7
DQpAQCAtNDQ3LDYgKzQ1OCw3IEBAIHN0YXRpYyBpbnQgcGFyc2VfZnVzZV9vcHQoY2hhciAqb3B0
LCBzdHJ1Y3QgZnVzZV9tb3VudF9kYXRhICpkLCBpbnQgaXNfYmRldikNCiAJd2hpbGUgKChwID0g
c3Ryc2VwKCZvcHQsICIsIikpICE9IE5VTEwpIHsNCiAJCWludCB0b2tlbjsNCiAJCWludCB2YWx1
ZTsNCisJCXVuc2lnbmVkIHV2Ow0KIAkJc3Vic3RyaW5nX3QgYXJnc1tNQVhfT1BUX0FSR1NdOw0K
IAkJaWYgKCEqcCkNCiAJCQljb250aW51ZTsNCkBAIC00NzAsMTYgKzQ4MiwxNiBAQCBzdGF0aWMg
aW50IHBhcnNlX2Z1c2Vfb3B0KGNoYXIgKm9wdCwgc3RydWN0IGZ1c2VfbW91bnRfZGF0YSAqZCwg
aW50IGlzX2JkZXYpDQogCQkJYnJlYWs7DQogDQogCQljYXNlIE9QVF9VU0VSX0lEOg0KLQkJCWlm
IChtYXRjaF9pbnQoJmFyZ3NbMF0sICZ2YWx1ZSkpDQorCQkJaWYgKGZ1c2VfbWF0Y2hfdWludCgm
YXJnc1swXSwgJnV2KSkNCiAJCQkJcmV0dXJuIDA7DQotCQkJZC0+dXNlcl9pZCA9IHZhbHVlOw0K
KwkJCWQtPnVzZXJfaWQgPSB1djsNCiAJCQlkLT51c2VyX2lkX3ByZXNlbnQgPSAxOw0KIAkJCWJy
ZWFrOw0KIA0KIAkJY2FzZSBPUFRfR1JPVVBfSUQ6DQotCQkJaWYgKG1hdGNoX2ludCgmYXJnc1sw
XSwgJnZhbHVlKSkNCisJCQlpZiAoZnVzZV9tYXRjaF91aW50KCZhcmdzWzBdLCAmdXYpKQ0KIAkJ
CQlyZXR1cm4gMDsNCi0JCQlkLT5ncm91cF9pZCA9IHZhbHVlOw0KKwkJCWQtPmdyb3VwX2lkID0g
dXY7DQogCQkJZC0+Z3JvdXBfaWRfcHJlc2VudCA9IDE7DQogCQkJYnJlYWs7DQogDQpkaWZmIC0t
Z2l0IGEvZnMvamJkMi90cmFuc2FjdGlvbi5jIGIvZnMvamJkMi90cmFuc2FjdGlvbi5jDQppbmRl
eCAxOGVhNGQ5Li44NmRjNjhhIDEwMDY0NA0KLS0tIGEvZnMvamJkMi90cmFuc2FjdGlvbi5jDQor
KysgYi9mcy9qYmQyL3RyYW5zYWN0aW9uLmMNCkBAIC0xMzg4LDkgKzEzODgsMTIgQEAgaW50IGpi
ZDJfam91cm5hbF9zdG9wKGhhbmRsZV90ICpoYW5kbGUpDQogCSAqIHRvIHBlcmZvcm0gYSBzeW5j
aHJvbm91cyB3cml0ZS4gIFdlIGRvIHRoaXMgdG8gZGV0ZWN0IHRoZQ0KIAkgKiBjYXNlIHdoZXJl
IGEgc2luZ2xlIHByb2Nlc3MgaXMgZG9pbmcgYSBzdHJlYW0gb2Ygc3luYw0KIAkgKiB3cml0ZXMu
ICBObyBwb2ludCBpbiB3YWl0aW5nIGZvciBqb2luZXJzIGluIHRoYXQgY2FzZS4NCisJICoNCisJ
ICogU2V0dGluZyBtYXhfYmF0Y2hfdGltZSB0byAwIGRpc2FibGVzIHRoaXMgY29tcGxldGVseS4N
CiAJICovDQogCXBpZCA9IGN1cnJlbnQtPnBpZDsNCi0JaWYgKGhhbmRsZS0+aF9zeW5jICYmIGpv
dXJuYWwtPmpfbGFzdF9zeW5jX3dyaXRlciAhPSBwaWQpIHsNCisJaWYgKGhhbmRsZS0+aF9zeW5j
ICYmIGpvdXJuYWwtPmpfbGFzdF9zeW5jX3dyaXRlciAhPSBwaWQgJiYNCisJICAgIGpvdXJuYWwt
PmpfbWF4X2JhdGNoX3RpbWUpIHsNCiAJCXU2NCBjb21taXRfdGltZSwgdHJhbnNfdGltZTsNCiAN
CiAJCWpvdXJuYWwtPmpfbGFzdF9zeW5jX3dyaXRlciA9IHBpZDsNCmRpZmYgLS1naXQgYS9mcy9u
ZnNkL25mczRwcm9jLmMgYi9mcy9uZnNkL25mczRwcm9jLmMNCmluZGV4IDMxNWExYmEuLmVlYmNj
ZmUgMTAwNjQ0DQotLS0gYS9mcy9uZnNkL25mczRwcm9jLmMNCisrKyBiL2ZzL25mc2QvbmZzNHBy
b2MuYw0KQEAgLTUyOSwxNSArNTI5LDYgQEAgbmZzZDRfY3JlYXRlKHN0cnVjdCBzdmNfcnFzdCAq
cnFzdHAsIHN0cnVjdCBuZnNkNF9jb21wb3VuZF9zdGF0ZSAqY3N0YXRlLA0KIA0KIAlzd2l0Y2gg
KGNyZWF0ZS0+Y3JfdHlwZSkgew0KIAljYXNlIE5GNExOSzoNCi0JCS8qIHVnaCEgd2UgaGF2ZSB0
byBudWxsLXRlcm1pbmF0ZSB0aGUgbGlua3RleHQsIG9yDQotCQkgKiB2ZnNfc3ltbGluaygpIHdp
bGwgY2hva2UuICBpdCBpcyBhbHdheXMgc2FmZSB0bw0KLQkJICogbnVsbC10ZXJtaW5hdGUgYnkg
YnJ1dGUgZm9yY2UsIHNpbmNlIGF0IHdvcnN0IHdlDQotCQkgKiB3aWxsIG92ZXJ3cml0ZSB0aGUg
Zmlyc3QgYnl0ZSBvZiB0aGUgY3JlYXRlIG5hbWVsZW4NCi0JCSAqIGluIHRoZSBYRFIgYnVmZmVy
LCB3aGljaCBoYXMgYWxyZWFkeSBiZWVuIGV4dHJhY3RlZA0KLQkJICogZHVyaW5nIFhEUiBkZWNv
ZGUuDQotCQkgKi8NCi0JCWNyZWF0ZS0+Y3JfbGlua25hbWVbY3JlYXRlLT5jcl9saW5rbGVuXSA9
IDA7DQotDQogCQlzdGF0dXMgPSBuZnNkX3N5bWxpbmsocnFzdHAsICZjc3RhdGUtPmN1cnJlbnRf
ZmgsDQogCQkJCSAgICAgIGNyZWF0ZS0+Y3JfbmFtZSwgY3JlYXRlLT5jcl9uYW1lbGVuLA0KIAkJ
CQkgICAgICBjcmVhdGUtPmNyX2xpbmtuYW1lLCBjcmVhdGUtPmNyX2xpbmtsZW4sDQpkaWZmIC0t
Z2l0IGEvZnMvbmZzZC9uZnM0eGRyLmMgYi9mcy9uZnNkL25mczR4ZHIuYw0KaW5kZXggYTc5MzNk
ZC4uOWQyYzUyYiAxMDA2NDQNCi0tLSBhL2ZzL25mc2QvbmZzNHhkci5jDQorKysgYi9mcy9uZnNk
L25mczR4ZHIuYw0KQEAgLTQ4Miw3ICs0ODIsMTggQEAgbmZzZDRfZGVjb2RlX2NyZWF0ZShzdHJ1
Y3QgbmZzZDRfY29tcG91bmRhcmdzICphcmdwLCBzdHJ1Y3QgbmZzZDRfY3JlYXRlICpjcmVhdGUN
CiAJCVJFQURfQlVGKDQpOw0KIAkJUkVBRDMyKGNyZWF0ZS0+Y3JfbGlua2xlbik7DQogCQlSRUFE
X0JVRihjcmVhdGUtPmNyX2xpbmtsZW4pOw0KLQkJU0FWRU1FTShjcmVhdGUtPmNyX2xpbmtuYW1l
LCBjcmVhdGUtPmNyX2xpbmtsZW4pOw0KKwkJLyoNCisJCSAqIFRoZSBWRlMgd2lsbCB3YW50IGEg
bnVsbC10ZXJtaW5hdGVkIHN0cmluZywgYW5kDQorCQkgKiBudWxsLXRlcm1pbmF0aW5nIGluIHBs
YWNlIGlzbid0IHNhZmUgc2luY2UgdGhpcyBtaWdodA0KKwkJICogZW5kIG9uIGEgcGFnZSBib3Vu
ZGFyeToNCisJCSAqLw0KKwkJY3JlYXRlLT5jcl9saW5rbmFtZSA9DQorCQkJCWttYWxsb2MoY3Jl
YXRlLT5jcl9saW5rbGVuICsgMSwgR0ZQX0tFUk5FTCk7DQorCQlpZiAoIWNyZWF0ZS0+Y3JfbGlu
a25hbWUpDQorCQkJcmV0dXJuIG5mc2Vycl9qdWtlYm94Ow0KKwkJbWVtY3B5KGNyZWF0ZS0+Y3Jf
bGlua25hbWUsIHAsIGNyZWF0ZS0+Y3JfbGlua2xlbik7DQorCQljcmVhdGUtPmNyX2xpbmtuYW1l
W2NyZWF0ZS0+Y3JfbGlua2xlbl0gPSAnXDAnOw0KKwkJZGVmZXJfZnJlZShhcmdwLCBrZnJlZSwg
Y3JlYXRlLT5jcl9saW5rbmFtZSk7DQogCQlicmVhazsNCiAJY2FzZSBORjRCTEs6DQogCWNhc2Ug
TkY0Q0hSOg0KZGlmZiAtLWdpdCBhL2ZzL3hmcy94ZnNfYWxsb2MuYyBiL2ZzL3hmcy94ZnNfYWxs
b2MuYw0KaW5kZXggY2U4NGZmZC4uODk2ZjFkOSAxMDA2NDQNCi0tLSBhL2ZzL3hmcy94ZnNfYWxs
b2MuYw0KKysrIGIvZnMveGZzL3hmc19hbGxvYy5jDQpAQCAtMTA3NSwxMiArMTA3NSwxMyBAQCBy
ZXN0YXJ0Og0KIAkgKiBJZiB3ZSBjb3VsZG4ndCBnZXQgYW55dGhpbmcsIGdpdmUgdXAuDQogCSAq
Lw0KIAlpZiAoYm5vX2N1cl9sdCA9PSBOVUxMICYmIGJub19jdXJfZ3QgPT0gTlVMTCkgew0KKwkJ
eGZzX2J0cmVlX2RlbF9jdXJzb3IoY250X2N1ciwgWEZTX0JUUkVFX05PRVJST1IpOw0KKw0KIAkJ
aWYgKCFmb3JjZWQrKykgew0KIAkJCXRyYWNlX3hmc19hbGxvY19uZWFyX2J1c3koYXJncyk7DQog
CQkJeGZzX2xvZ19mb3JjZShhcmdzLT5tcCwgWEZTX0xPR19TWU5DKTsNCiAJCQlnb3RvIHJlc3Rh
cnQ7DQogCQl9DQotDQogCQl0cmFjZV94ZnNfYWxsb2Nfc2l6ZV9uZWl0aGVyKGFyZ3MpOw0KIAkJ
YXJncy0+YWdibm8gPSBOVUxMQUdCTE9DSzsNCiAJCXJldHVybiAwOw0KZGlmZiAtLWdpdCBhL2lu
Y2x1ZGUvZHJtL2RybV9tZW1fdXRpbC5oIGIvaW5jbHVkZS9kcm0vZHJtX21lbV91dGlsLmgNCmlu
ZGV4IDZiZDMyNWYuLjE5YTI0MDQgMTAwNjQ0DQotLS0gYS9pbmNsdWRlL2RybS9kcm1fbWVtX3V0
aWwuaA0KKysrIGIvaW5jbHVkZS9kcm0vZHJtX21lbV91dGlsLmgNCkBAIC0zMSw3ICszMSw3IEBA
DQogDQogc3RhdGljIF9faW5saW5lX18gdm9pZCAqZHJtX2NhbGxvY19sYXJnZShzaXplX3Qgbm1l
bWIsIHNpemVfdCBzaXplKQ0KIHsNCi0JaWYgKHNpemUgIT0gMCAmJiBubWVtYiA+IFVMT05HX01B
WCAvIHNpemUpDQorCWlmIChzaXplICE9IDAgJiYgbm1lbWIgPiBTSVpFX01BWCAvIHNpemUpDQog
CQlyZXR1cm4gTlVMTDsNCiANCiAJaWYgKHNpemUgKiBubWVtYiA8PSBQQUdFX1NJWkUpDQpAQCAt
NDQsNyArNDQsNyBAQCBzdGF0aWMgX19pbmxpbmVfXyB2b2lkICpkcm1fY2FsbG9jX2xhcmdlKHNp
emVfdCBubWVtYiwgc2l6ZV90IHNpemUpDQogLyogTW9kZWxlZCBhZnRlciBjYWlybydzIG1hbGxv
Y19hYiwgaXQncyBsaWtlIGNhbGxvYyBidXQgd2l0aG91dCB0aGUgemVyb2luZy4gKi8NCiBzdGF0
aWMgX19pbmxpbmVfXyB2b2lkICpkcm1fbWFsbG9jX2FiKHNpemVfdCBubWVtYiwgc2l6ZV90IHNp
emUpDQogew0KLQlpZiAoc2l6ZSAhPSAwICYmIG5tZW1iID4gVUxPTkdfTUFYIC8gc2l6ZSkNCisJ
aWYgKHNpemUgIT0gMCAmJiBubWVtYiA+IFNJWkVfTUFYIC8gc2l6ZSkNCiAJCXJldHVybiBOVUxM
Ow0KIA0KIAlpZiAoc2l6ZSAqIG5tZW1iIDw9IFBBR0VfU0laRSkNCmRpZmYgLS1naXQgYS9pbmNs
dWRlL2xpbnV4L2tlcm5lbC5oIGIvaW5jbHVkZS9saW51eC9rZXJuZWwuaA0KaW5kZXggYTcwNzgz
ZC4uMGI4Y2EzNSAxMDA2NDQNCi0tLSBhL2luY2x1ZGUvbGludXgva2VybmVsLmgNCisrKyBiL2lu
Y2x1ZGUvbGludXgva2VybmVsLmgNCkBAIC0zNCw2ICszNCw3IEBADQogI2RlZmluZSBMTE9OR19N
QVgJKChsb25nIGxvbmcpKH4wVUxMPj4xKSkNCiAjZGVmaW5lIExMT05HX01JTgkoLUxMT05HX01B
WCAtIDEpDQogI2RlZmluZSBVTExPTkdfTUFYCSh+MFVMTCkNCisjZGVmaW5lIFNJWkVfTUFYCSh+
KHNpemVfdCkwKQ0KIA0KICNkZWZpbmUgU1RBQ0tfTUFHSUMJMHhkZWFkYmVlZg0KIA0KZGlmZiAt
LWdpdCBhL2luY2x1ZGUvbGludXgvbGliYXRhLmggYi9pbmNsdWRlL2xpbnV4L2xpYmF0YS5oDQpp
bmRleCAzNzVkZmRmLi5kNzczYjIxIDEwMDY0NA0KLS0tIGEvaW5jbHVkZS9saW51eC9saWJhdGEu
aA0KKysrIGIvaW5jbHVkZS9saW51eC9saWJhdGEuaA0KQEAgLTU0MCw2ICs1NDAsNyBAQCBzdHJ1
Y3QgYXRhX2hvc3Qgew0KIAlzdHJ1Y3QgZGV2aWNlIAkJKmRldjsNCiAJdm9pZCBfX2lvbWVtICog
Y29uc3QJKmlvbWFwOw0KIAl1bnNpZ25lZCBpbnQJCW5fcG9ydHM7DQorCXVuc2lnbmVkIGludAkJ
bl90YWdzOwkJCS8qIG5yIG9mIE5DUSB0YWdzICovDQogCXZvaWQJCQkqcHJpdmF0ZV9kYXRhOw0K
IAlzdHJ1Y3QgYXRhX3BvcnRfb3BlcmF0aW9ucyAqb3BzOw0KIAl1bnNpZ25lZCBsb25nCQlmbGFn
czsNCmRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L21hdGg2NC5oIGIvaW5jbHVkZS9saW51eC9t
YXRoNjQuaA0KaW5kZXggYjhiYTg1NS4uMjkxM2I4NiAxMDA2NDQNCi0tLSBhL2luY2x1ZGUvbGlu
dXgvbWF0aDY0LmgNCisrKyBiL2luY2x1ZGUvbGludXgvbWF0aDY0LmgNCkBAIC02LDcgKzYsOCBA
QA0KIA0KICNpZiBCSVRTX1BFUl9MT05HID09IDY0DQogDQotI2RlZmluZSBkaXY2NF9sb25nKHgs
eSkgZGl2NjRfczY0KCh4KSwoeSkpDQorI2RlZmluZSBkaXY2NF9sb25nKHgsIHkpIGRpdjY0X3M2
NCgoeCksICh5KSkNCisjZGVmaW5lIGRpdjY0X3VsKHgsIHkpICAgZGl2NjRfdTY0KCh4KSwgKHkp
KQ0KIA0KIC8qKg0KICAqIGRpdl91NjRfcmVtIC0gdW5zaWduZWQgNjRiaXQgZGl2aWRlIHdpdGgg
MzJiaXQgZGl2aXNvciB3aXRoIHJlbWFpbmRlcg0KQEAgLTQ3LDcgKzQ4LDggQEAgc3RhdGljIGlu
bGluZSBzNjQgZGl2NjRfczY0KHM2NCBkaXZpZGVuZCwgczY0IGRpdmlzb3IpDQogDQogI2VsaWYg
QklUU19QRVJfTE9ORyA9PSAzMg0KIA0KLSNkZWZpbmUgZGl2NjRfbG9uZyh4LHkpIGRpdl9zNjQo
KHgpLCh5KSkNCisjZGVmaW5lIGRpdjY0X2xvbmcoeCwgeSkgZGl2X3M2NCgoeCksICh5KSkNCisj
ZGVmaW5lIGRpdjY0X3VsKHgsIHkpICAgZGl2X3U2NCgoeCksICh5KSkNCiANCiAjaWZuZGVmIGRp
dl91NjRfcmVtDQogc3RhdGljIGlubGluZSB1NjQgZGl2X3U2NF9yZW0odTY0IGRpdmlkZW5kLCB1
MzIgZGl2aXNvciwgdTMyICpyZW1haW5kZXIpDQpkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9z
a2J1ZmYuaCBiL2luY2x1ZGUvbGludXgvc2tidWZmLmgNCmluZGV4IDQwYzI3MjYuLjFiNGVhMjkg
MTAwNjQ0DQotLS0gYS9pbmNsdWRlL2xpbnV4L3NrYnVmZi5oDQorKysgYi9pbmNsdWRlL2xpbnV4
L3NrYnVmZi5oDQpAQCAtMjU4MywyMiArMjU4Myw1IEBAIHN0YXRpYyBpbmxpbmUgYm9vbCBza2Jf
aXNfcmVjeWNsZWFibGUoY29uc3Qgc3RydWN0IHNrX2J1ZmYgKnNrYiwgaW50IHNrYl9zaXplKQ0K
IA0KIAlyZXR1cm4gdHJ1ZTsNCiB9DQotDQotLyoqDQotICogc2tiX2dzb19uZXR3b3JrX3NlZ2xl
biAtIFJldHVybiBsZW5ndGggb2YgaW5kaXZpZHVhbCBzZWdtZW50cyBvZiBhIGdzbyBwYWNrZXQN
Ci0gKg0KLSAqIEBza2I6IEdTTyBza2INCi0gKg0KLSAqIHNrYl9nc29fbmV0d29ya19zZWdsZW4g
aXMgdXNlZCB0byBkZXRlcm1pbmUgdGhlIHJlYWwgc2l6ZSBvZiB0aGUNCi0gKiBpbmRpdmlkdWFs
IHNlZ21lbnRzLCBpbmNsdWRpbmcgTGF5ZXIzIChJUCwgSVB2NikgYW5kIEw0IGhlYWRlcnMgKFRD
UC9VRFApLg0KLSAqDQotICogVGhlIE1BQy9MMiBoZWFkZXIgaXMgbm90IGFjY291bnRlZCBmb3Iu
DQotICovDQotc3RhdGljIGlubGluZSB1bnNpZ25lZCBpbnQgc2tiX2dzb19uZXR3b3JrX3NlZ2xl
bihjb25zdCBzdHJ1Y3Qgc2tfYnVmZiAqc2tiKQ0KLXsNCi0JdW5zaWduZWQgaW50IGhkcl9sZW4g
PSBza2JfdHJhbnNwb3J0X2hlYWRlcihza2IpIC0NCi0JCQkgICAgICAgc2tiX25ldHdvcmtfaGVh
ZGVyKHNrYik7DQotCXJldHVybiBoZHJfbGVuICsgc2tiX2dzb190cmFuc3BvcnRfc2VnbGVuKHNr
Yik7DQotfQ0KICNlbmRpZgkvKiBfX0tFUk5FTF9fICovDQogI2VuZGlmCS8qIF9MSU5VWF9TS0JV
RkZfSCAqLw0KZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvc2xhYi5oIGIvaW5jbHVkZS9saW51
eC9zbGFiLmgNCmluZGV4IGE1OTVkY2UuLjY3ZDVkOTQgMTAwNjQ0DQotLS0gYS9pbmNsdWRlL2xp
bnV4L3NsYWIuaA0KKysrIGIvaW5jbHVkZS9saW51eC9zbGFiLmgNCkBAIC0yNDIsNyArMjQyLDcg
QEAgc2l6ZV90IGtzaXplKGNvbnN0IHZvaWQgKik7DQogICovDQogc3RhdGljIGlubGluZSB2b2lk
ICprbWFsbG9jX2FycmF5KHNpemVfdCBuLCBzaXplX3Qgc2l6ZSwgZ2ZwX3QgZmxhZ3MpDQogew0K
LQlpZiAoc2l6ZSAhPSAwICYmIG4gPiBVTE9OR19NQVggLyBzaXplKQ0KKwlpZiAoc2l6ZSAhPSAw
ICYmIG4gPiBTSVpFX01BWCAvIHNpemUpDQogCQlyZXR1cm4gTlVMTDsNCiAJcmV0dXJuIF9fa21h
bGxvYyhuICogc2l6ZSwgZmxhZ3MpOw0KIH0NCmRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L3Vz
Yl91c3VhbC5oIGIvaW5jbHVkZS9saW51eC91c2JfdXN1YWwuaA0KaW5kZXggMTdkZjM2MC4uODg0
MTNlOSAxMDA2NDQNCi0tLSBhL2luY2x1ZGUvbGludXgvdXNiX3VzdWFsLmgNCisrKyBiL2luY2x1
ZGUvbGludXgvdXNiX3VzdWFsLmgNCkBAIC02NCw3ICs2NCw5IEBADQogCVVTX0ZMQUcoTk9fUkVB
RF9DQVBBQ0lUWV8xNiwJMHgwMDA4MDAwMCkJCVwNCiAJCS8qIGNhbm5vdCBoYW5kbGUgUkVBRF9D
QVBBQ0lUWV8xNiAqLwkJXA0KIAlVU19GTEFHKElOSVRJQUxfUkVBRDEwLAkweDAwMTAwMDAwKQkJ
CVwNCi0JCS8qIEluaXRpYWwgUkVBRCgxMCkgKGFuZCBvdGhlcnMpIG11c3QgYmUgcmV0cmllZCAq
Lw0KKwkJLyogSW5pdGlhbCBSRUFEKDEwKSAoYW5kIG90aGVycykgbXVzdCBiZSByZXRyaWVkICov
IFwNCisJVVNfRkxBRyhCUk9LRU5fRlVBLAkweDAxMDAwMDAwKQkJCVwNCisJCS8qIENhbm5vdCBo
YW5kbGUgRlVBIGluIFdSSVRFIG9yIFJFQUQgQ0RCcyAqLwlcDQogDQogI2RlZmluZSBVU19GTEFH
KG5hbWUsIHZhbHVlKQlVU19GTF8jI25hbWUgPSB2YWx1ZSAsDQogZW51bSB7IFVTX0RPX0FMTF9G
TEFHUyB9Ow0KZGlmZiAtLWdpdCBhL2luY2x1ZGUvc2NzaS9zY3NpX2RldmljZS5oIGIvaW5jbHVk
ZS9zY3NpL3Njc2lfZGV2aWNlLmgNCmluZGV4IDMxNTJjYzMuLjM3N2JhNjEgMTAwNjQ0DQotLS0g
YS9pbmNsdWRlL3Njc2kvc2NzaV9kZXZpY2UuaA0KKysrIGIvaW5jbHVkZS9zY3NpL3Njc2lfZGV2
aWNlLmgNCkBAIC0xNTEsNiArMTUxLDcgQEAgc3RydWN0IHNjc2lfZGV2aWNlIHsNCiAJdW5zaWdu
ZWQgbm9fcmVhZF9kaXNjX2luZm86MTsJLyogQXZvaWQgUkVBRF9ESVNDX0lORk8gY21kcyAqLw0K
IAl1bnNpZ25lZCBub19yZWFkX2NhcGFjaXR5XzE2OjE7IC8qIEF2b2lkIFJFQURfQ0FQQUNJVFlf
MTYgY21kcyAqLw0KIAl1bnNpZ25lZCBpc192aXNpYmxlOjE7CS8qIGlzIHRoZSBkZXZpY2Ugdmlz
aWJsZSBpbiBzeXNmcyAqLw0KKwl1bnNpZ25lZCBicm9rZW5fZnVhOjE7CQkvKiBEb24ndCBzZXQg
RlVBIGJpdCAqLw0KIA0KIAlERUNMQVJFX0JJVE1BUChzdXBwb3J0ZWRfZXZlbnRzLCBTREVWX0VW
VF9NQVhCSVRTKTsgLyogc3VwcG9ydGVkIGV2ZW50cyAqLw0KIAlzdHJ1Y3QgbGlzdF9oZWFkIGV2
ZW50X2xpc3Q7CS8qIGFzc2VydGVkIGV2ZW50cyAqLw0KZGlmZiAtLWdpdCBhL2tlcm5lbC9LY29u
ZmlnLmxvY2tzIGIva2VybmVsL0tjb25maWcubG9ja3MNCmluZGV4IDUwNjhlMmEuLjYxZWJiNDkg
MTAwNjQ0DQotLS0gYS9rZXJuZWwvS2NvbmZpZy5sb2Nrcw0KKysrIGIva2VybmVsL0tjb25maWcu
bG9ja3MNCkBAIC0xOTgsNSArMTk4LDkgQEAgY29uZmlnIElOTElORV9XUklURV9VTkxPQ0tfSVJR
DQogY29uZmlnIElOTElORV9XUklURV9VTkxPQ0tfSVJRUkVTVE9SRQ0KIAlkZWZfYm9vbCAhREVC
VUdfU1BJTkxPQ0sgJiYgQVJDSF9JTkxJTkVfV1JJVEVfVU5MT0NLX0lSUVJFU1RPUkUNCiANCitj
b25maWcgQVJDSF9TVVBQT1JUU19BVE9NSUNfUk1XDQorCWJvb2wNCisNCiBjb25maWcgTVVURVhf
U1BJTl9PTl9PV05FUg0KLQlkZWZfYm9vbCBTTVAgJiYgIURFQlVHX01VVEVYRVMNCisJZGVmX2Jv
b2wgeQ0KKwlkZXBlbmRzIG9uIFNNUCAmJiAhREVCVUdfTVVURVhFUyAmJiBBUkNIX1NVUFBPUlRT
X0FUT01JQ19STVcNCmRpZmYgLS1naXQgYS9rZXJuZWwvY3B1c2V0LmMgYi9rZXJuZWwvY3B1c2V0
LmMNCmluZGV4IDFlMmM1ZjAuLjQzNDZmOWEgMTAwNjQ0DQotLS0gYS9rZXJuZWwvY3B1c2V0LmMN
CisrKyBiL2tlcm5lbC9jcHVzZXQuYw0KQEAgLTExNTIsNyArMTE1MiwxMyBAQCBkb25lOg0KIA0K
IGludCBjdXJyZW50X2NwdXNldF9pc19iZWluZ19yZWJvdW5kKHZvaWQpDQogew0KLQlyZXR1cm4g
dGFza19jcyhjdXJyZW50KSA9PSBjcHVzZXRfYmVpbmdfcmVib3VuZDsNCisJaW50IHJldDsNCisN
CisJcmN1X3JlYWRfbG9jaygpOw0KKwlyZXQgPSB0YXNrX2NzKGN1cnJlbnQpID09IGNwdXNldF9i
ZWluZ19yZWJvdW5kOw0KKwlyY3VfcmVhZF91bmxvY2soKTsNCisNCisJcmV0dXJuIHJldDsNCiB9
DQogDQogc3RhdGljIGludCB1cGRhdGVfcmVsYXhfZG9tYWluX2xldmVsKHN0cnVjdCBjcHVzZXQg
KmNzLCBzNjQgdmFsKQ0KZGlmZiAtLWdpdCBhL2tlcm5lbC9zY2hlZF9kZWJ1Zy5jIGIva2VybmVs
L3NjaGVkX2RlYnVnLmMNCmluZGV4IGY0MDEwZTIuLjcwNGZmZTMgMTAwNjQ0DQotLS0gYS9rZXJu
ZWwvc2NoZWRfZGVidWcuYw0KKysrIGIva2VybmVsL3NjaGVkX2RlYnVnLmMNCkBAIC00NjcsNyAr
NDY3LDcgQEAgdm9pZCBwcm9jX3NjaGVkX3Nob3dfdGFzayhzdHJ1Y3QgdGFza19zdHJ1Y3QgKnAs
IHN0cnVjdCBzZXFfZmlsZSAqbSkNCiANCiAJCWF2Z19hdG9tID0gcC0+c2Uuc3VtX2V4ZWNfcnVu
dGltZTsNCiAJCWlmIChucl9zd2l0Y2hlcykNCi0JCQlkb19kaXYoYXZnX2F0b20sIG5yX3N3aXRj
aGVzKTsNCisJCQlhdmdfYXRvbSA9IGRpdjY0X3VsKGF2Z19hdG9tLCBucl9zd2l0Y2hlcyk7DQog
CQllbHNlDQogCQkJYXZnX2F0b20gPSAtMUxMOw0KIA0KZGlmZiAtLWdpdCBhL2tlcm5lbC90aW1l
L2FsYXJtdGltZXIuYyBiL2tlcm5lbC90aW1lL2FsYXJtdGltZXIuYw0KaW5kZXggMDkwN2U0My4u
ZWIxOThhMyAxMDA2NDQNCi0tLSBhL2tlcm5lbC90aW1lL2FsYXJtdGltZXIuYw0KKysrIGIva2Vy
bmVsL3RpbWUvYWxhcm10aW1lci5jDQpAQCAtNTYzLDkgKzU2MywxNCBAQCBzdGF0aWMgaW50IGFs
YXJtX3RpbWVyX3NldChzdHJ1Y3Qga19pdGltZXIgKnRpbXIsIGludCBmbGFncywNCiAJCQkJc3Ry
dWN0IGl0aW1lcnNwZWMgKm5ld19zZXR0aW5nLA0KIAkJCQlzdHJ1Y3QgaXRpbWVyc3BlYyAqb2xk
X3NldHRpbmcpDQogew0KKwlrdGltZV90IGV4cDsNCisNCiAJaWYgKCFydGNkZXYpDQogCQlyZXR1
cm4gLUVOT1RTVVBQOw0KIA0KKwlpZiAoZmxhZ3MgJiB+VElNRVJfQUJTVElNRSkNCisJCXJldHVy
biAtRUlOVkFMOw0KKw0KIAlpZiAob2xkX3NldHRpbmcpDQogCQlhbGFybV90aW1lcl9nZXQodGlt
ciwgb2xkX3NldHRpbmcpOw0KIA0KQEAgLTU3NSw4ICs1ODAsMTYgQEAgc3RhdGljIGludCBhbGFy
bV90aW1lcl9zZXQoc3RydWN0IGtfaXRpbWVyICp0aW1yLCBpbnQgZmxhZ3MsDQogDQogCS8qIHN0
YXJ0IHRoZSB0aW1lciAqLw0KIAl0aW1yLT5pdC5hbGFybS5pbnRlcnZhbCA9IHRpbWVzcGVjX3Rv
X2t0aW1lKG5ld19zZXR0aW5nLT5pdF9pbnRlcnZhbCk7DQotCWFsYXJtX3N0YXJ0KCZ0aW1yLT5p
dC5hbGFybS5hbGFybXRpbWVyLA0KLQkJCXRpbWVzcGVjX3RvX2t0aW1lKG5ld19zZXR0aW5nLT5p
dF92YWx1ZSkpOw0KKwlleHAgPSB0aW1lc3BlY190b19rdGltZShuZXdfc2V0dGluZy0+aXRfdmFs
dWUpOw0KKwkvKiBDb252ZXJ0IChpZiBuZWNlc3NhcnkpIHRvIGFic29sdXRlIHRpbWUgKi8NCisJ
aWYgKGZsYWdzICE9IFRJTUVSX0FCU1RJTUUpIHsNCisJCWt0aW1lX3Qgbm93Ow0KKw0KKwkJbm93
ID0gYWxhcm1fYmFzZXNbdGltci0+aXQuYWxhcm0uYWxhcm10aW1lci50eXBlXS5nZXR0aW1lKCk7
DQorCQlleHAgPSBrdGltZV9hZGQobm93LCBleHApOw0KKwl9DQorDQorCWFsYXJtX3N0YXJ0KCZ0
aW1yLT5pdC5hbGFybS5hbGFybXRpbWVyLCBleHApOw0KIAlyZXR1cm4gMDsNCiB9DQogDQpAQCAt
NzA4LDYgKzcyMSw5IEBAIHN0YXRpYyBpbnQgYWxhcm1fdGltZXJfbnNsZWVwKGNvbnN0IGNsb2Nr
aWRfdCB3aGljaF9jbG9jaywgaW50IGZsYWdzLA0KIAlpZiAoIWFsYXJtdGltZXJfZ2V0X3J0Y2Rl
digpKQ0KIAkJcmV0dXJuIC1FTk9UU1VQUDsNCiANCisJaWYgKGZsYWdzICYgflRJTUVSX0FCU1RJ
TUUpDQorCQlyZXR1cm4gLUVJTlZBTDsNCisNCiAJaWYgKCFjYXBhYmxlKENBUF9XQUtFX0FMQVJN
KSkNCiAJCXJldHVybiAtRVBFUk07DQogDQpkaWZmIC0tZ2l0IGEva2VybmVsL3RpbWUvdGljay1z
Y2hlZC5jIGIva2VybmVsL3RpbWUvdGljay1zY2hlZC5jDQppbmRleCBlOWE0NWYxLi4yNjk1ZDcy
IDEwMDY0NA0KLS0tIGEva2VybmVsL3RpbWUvdGljay1zY2hlZC5jDQorKysgYi9rZXJuZWwvdGlt
ZS90aWNrLXNjaGVkLmMNCkBAIC0zMjUsOCArMzI1LDEwIEBAIHZvaWQgdGlja19ub2h6X3N0b3Bf
c2NoZWRfdGljayhpbnQgaW5pZGxlKQ0KIAkJCXRpY2tfZG9fdGltZXJfY3B1ID0gVElDS19ET19U
SU1FUl9OT05FOw0KIAl9DQogDQotCWlmICh1bmxpa2VseSh0cy0+bm9oel9tb2RlID09IE5PSFpf
TU9ERV9JTkFDVElWRSkpDQorCWlmICh1bmxpa2VseSh0cy0+bm9oel9tb2RlID09IE5PSFpfTU9E
RV9JTkFDVElWRSkpIHsNCisJCXRzLT5zbGVlcF9sZW5ndGggPSAoa3RpbWVfdCkgeyAudHY2NCA9
IE5TRUNfUEVSX1NFQy9IWiB9Ow0KIAkJZ290byBlbmQ7DQorCX0NCiANCiAJaWYgKG5lZWRfcmVz
Y2hlZCgpKQ0KIAkJZ290byBlbmQ7DQpkaWZmIC0tZ2l0IGEva2VybmVsL3RyYWNlL3RyYWNlLmMg
Yi9rZXJuZWwvdHJhY2UvdHJhY2UuYw0KaW5kZXggYzVhMTJhNy4uMGMzNDhhNiAxMDA2NDQNCi0t
LSBhL2tlcm5lbC90cmFjZS90cmFjZS5jDQorKysgYi9rZXJuZWwvdHJhY2UvdHJhY2UuYw0KQEAg
LTMyNDQsOCArMzI0NCw2IEBAIHRyYWNpbmdfcG9sbF9waXBlKHN0cnVjdCBmaWxlICpmaWxwLCBw
b2xsX3RhYmxlICpwb2xsX3RhYmxlKQ0KIAkJICovDQogCQlyZXR1cm4gUE9MTElOIHwgUE9MTFJE
Tk9STTsNCiAJfSBlbHNlIHsNCi0JCWlmICghdHJhY2VfZW1wdHkoaXRlcikpDQotCQkJcmV0dXJu
IFBPTExJTiB8IFBPTExSRE5PUk07DQogCQlwb2xsX3dhaXQoZmlscCwgJnRyYWNlX3dhaXQsIHBv
bGxfdGFibGUpOw0KIAkJaWYgKCF0cmFjZV9lbXB0eShpdGVyKSkNCiAJCQlyZXR1cm4gUE9MTElO
IHwgUE9MTFJETk9STTsNCmRpZmYgLS1naXQgYS9tbS9odWdldGxiLmMgYi9tbS9odWdldGxiLmMN
CmluZGV4IDZmODg2ZDkuLmQyYzQzYTIgMTAwNjQ0DQotLS0gYS9tbS9odWdldGxiLmMNCisrKyBi
L21tL2h1Z2V0bGIuYw0KQEAgLTIzNDQsNiArMjM0NCw3IEBAIGludCBjb3B5X2h1Z2V0bGJfcGFn
ZV9yYW5nZShzdHJ1Y3QgbW1fc3RydWN0ICpkc3QsIHN0cnVjdCBtbV9zdHJ1Y3QgKnNyYywNCiAJ
CX0gZWxzZSB7DQogCQkJaWYgKGNvdykNCiAJCQkJaHVnZV9wdGVwX3NldF93cnByb3RlY3Qoc3Jj
LCBhZGRyLCBzcmNfcHRlKTsNCisJCQllbnRyeSA9IGh1Z2VfcHRlcF9nZXQoc3JjX3B0ZSk7DQog
CQkJcHRlcGFnZSA9IHB0ZV9wYWdlKGVudHJ5KTsNCiAJCQlnZXRfcGFnZShwdGVwYWdlKTsNCiAJ
CQlwYWdlX2R1cF9ybWFwKHB0ZXBhZ2UpOw0KZGlmZiAtLWdpdCBhL21tL2ttZW1sZWFrLmMgYi9t
bS9rbWVtbGVhay5jDQppbmRleCBmM2IyYTAwLi5jYzhjZjFkIDEwMDY0NA0KLS0tIGEvbW0va21l
bWxlYWsuYw0KKysrIGIvbW0va21lbWxlYWsuYw0KQEAgLTc0NCw3ICs3NDQsOSBAQCBzdGF0aWMg
dm9pZCBhZGRfc2Nhbl9hcmVhKHVuc2lnbmVkIGxvbmcgcHRyLCBzaXplX3Qgc2l6ZSwgZ2ZwX3Qg
Z2ZwKQ0KIAl9DQogDQogCXNwaW5fbG9ja19pcnFzYXZlKCZvYmplY3QtPmxvY2ssIGZsYWdzKTsN
Ci0JaWYgKHB0ciArIHNpemUgPiBvYmplY3QtPnBvaW50ZXIgKyBvYmplY3QtPnNpemUpIHsNCisJ
aWYgKHNpemUgPT0gU0laRV9NQVgpIHsNCisJCXNpemUgPSBvYmplY3QtPnBvaW50ZXIgKyBvYmpl
Y3QtPnNpemUgLSBwdHI7DQorCX0gZWxzZSBpZiAocHRyICsgc2l6ZSA+IG9iamVjdC0+cG9pbnRl
ciArIG9iamVjdC0+c2l6ZSkgew0KIAkJa21lbWxlYWtfd2FybigiU2NhbiBhcmVhIGxhcmdlciB0
aGFuIG9iamVjdCAweCUwOGx4XG4iLCBwdHIpOw0KIAkJZHVtcF9vYmplY3RfaW5mbyhvYmplY3Qp
Ow0KIAkJa21lbV9jYWNoZV9mcmVlKHNjYW5fYXJlYV9jYWNoZSwgYXJlYSk7DQpkaWZmIC0tZ2l0
IGEvbW0vbWVtcG9saWN5LmMgYi9tbS9tZW1wb2xpY3kuYw0KaW5kZXggMmI1YmNjOS4uYzlmN2U2
ZiAxMDA2NDQNCi0tLSBhL21tL21lbXBvbGljeS5jDQorKysgYi9tbS9tZW1wb2xpY3kuYw0KQEAg
LTE5ODMsNyArMTk4Myw2IEBAIHN0cnVjdCBtZW1wb2xpY3kgKl9fbXBvbF9kdXAoc3RydWN0IG1l
bXBvbGljeSAqb2xkKQ0KIAl9IGVsc2UNCiAJCSpuZXcgPSAqb2xkOw0KIA0KLQlyY3VfcmVhZF9s
b2NrKCk7DQogCWlmIChjdXJyZW50X2NwdXNldF9pc19iZWluZ19yZWJvdW5kKCkpIHsNCiAJCW5v
ZGVtYXNrX3QgbWVtcyA9IGNwdXNldF9tZW1zX2FsbG93ZWQoY3VycmVudCk7DQogCQlpZiAobmV3
LT5mbGFncyAmIE1QT0xfRl9SRUJJTkRJTkcpDQpAQCAtMTk5MSw3ICsxOTkwLDYgQEAgc3RydWN0
IG1lbXBvbGljeSAqX19tcG9sX2R1cChzdHJ1Y3QgbWVtcG9saWN5ICpvbGQpDQogCQllbHNlDQog
CQkJbXBvbF9yZWJpbmRfcG9saWN5KG5ldywgJm1lbXMsIE1QT0xfUkVCSU5EX09OQ0UpOw0KIAl9
DQotCXJjdV9yZWFkX3VubG9jaygpOw0KIAlhdG9taWNfc2V0KCZuZXctPnJlZmNudCwgMSk7DQog
CXJldHVybiBuZXc7DQogfQ0KZGlmZiAtLWdpdCBhL21tL3NobWVtLmMgYi9tbS9zaG1lbS5jDQpp
bmRleCBhNzhhY2YwLi4xMzcxMDIxIDEwMDY0NA0KLS0tIGEvbW0vc2htZW0uYw0KKysrIGIvbW0v
c2htZW0uYw0KQEAgLTc2LDYgKzc2LDE3IEBAIHN0YXRpYyBzdHJ1Y3QgdmZzbW91bnQgKnNobV9t
bnQ7DQogLyogU3ltbGluayB1cCB0byB0aGlzIHNpemUgaXMga21hbGxvYydlZCBpbnN0ZWFkIG9m
IHVzaW5nIGEgc3dhcHBhYmxlIHBhZ2UgKi8NCiAjZGVmaW5lIFNIT1JUX1NZTUxJTktfTEVOIDEy
OA0KIA0KKy8qDQorICogdm10cnVuY2F0ZV9yYW5nZSgpIGNvbW11bmljYXRlcyB3aXRoIHNobWVt
X2ZhdWx0IHZpYQ0KKyAqIGlub2RlLT5pX3ByaXZhdGUgKHdpdGggaV9tdXRleCBtYWtpbmcgc3Vy
ZSB0aGF0IGl0IGhhcyBvbmx5IG9uZSB1c2VyIGF0DQorICogYSB0aW1lKTogd2Ugd291bGQgcHJl
ZmVyIG5vdCB0byBlbmxhcmdlIHRoZSBzaG1lbSBpbm9kZSBqdXN0IGZvciB0aGF0Lg0KKyAqLw0K
K3N0cnVjdCBzaG1lbV9mYWxsb2Mgew0KKwl3YWl0X3F1ZXVlX2hlYWRfdCAqd2FpdHE7IC8qIGZh
dWx0cyBpbnRvIGhvbGUgd2FpdCBmb3IgcHVuY2ggdG8gZW5kICovDQorCXBnb2ZmX3Qgc3RhcnQ7
CQkvKiBzdGFydCBvZiByYW5nZSBjdXJyZW50bHkgYmVpbmcgZmFsbG9jYXRlZCAqLw0KKwlwZ29m
Zl90IG5leHQ7CQkvKiB0aGUgbmV4dCBwYWdlIG9mZnNldCB0byBiZSBmYWxsb2NhdGVkICovDQor
fTsNCisNCiBzdHJ1Y3Qgc2htZW1feGF0dHIgew0KIAlzdHJ1Y3QgbGlzdF9oZWFkIGxpc3Q7CS8q
IGFuY2hvcmVkIGJ5IHNobWVtX2lub2RlX2luZm8tPnhhdHRyX2xpc3QgKi8NCiAJY2hhciAqbmFt
ZTsJCS8qIHhhdHRyIG5hbWUgKi8NCkBAIC00ODgsMjIgKzQ5OSwxOSBAQCB2b2lkIHNobWVtX3Ry
dW5jYXRlX3JhbmdlKHN0cnVjdCBpbm9kZSAqaW5vZGUsIGxvZmZfdCBsc3RhcnQsIGxvZmZfdCBs
ZW5kKQ0KIAl9DQogDQogCWluZGV4ID0gc3RhcnQ7DQotCWZvciAoIDsgOyApIHsNCisJd2hpbGUg
KGluZGV4IDw9IGVuZCkgew0KIAkJY29uZF9yZXNjaGVkKCk7DQogCQlwdmVjLm5yID0gc2htZW1f
ZmluZF9nZXRfcGFnZXNfYW5kX3N3YXAobWFwcGluZywgaW5kZXgsDQogCQkJbWluKGVuZCAtIGlu
ZGV4LCAocGdvZmZfdClQQUdFVkVDX1NJWkUgLSAxKSArIDEsDQogCQkJCQkJCXB2ZWMucGFnZXMs
IGluZGljZXMpOw0KIAkJaWYgKCFwdmVjLm5yKSB7DQotCQkJaWYgKGluZGV4ID09IHN0YXJ0KQ0K
KwkJCS8qIElmIGFsbCBnb25lIG9yIGhvbGUtcHVuY2gsIHdlJ3JlIGRvbmUgKi8NCisJCQlpZiAo
aW5kZXggPT0gc3RhcnQgfHwgZW5kICE9IC0xKQ0KIAkJCQlicmVhazsNCisJCQkvKiBCdXQgaWYg
dHJ1bmNhdGluZywgcmVzdGFydCB0byBtYWtlIHN1cmUgYWxsIGdvbmUgKi8NCiAJCQlpbmRleCA9
IHN0YXJ0Ow0KIAkJCWNvbnRpbnVlOw0KIAkJfQ0KLQkJaWYgKGluZGV4ID09IHN0YXJ0ICYmIGlu
ZGljZXNbMF0gPiBlbmQpIHsNCi0JCQlzaG1lbV9kZXN3YXBfcGFnZXZlYygmcHZlYyk7DQotCQkJ
cGFnZXZlY19yZWxlYXNlKCZwdmVjKTsNCi0JCQlicmVhazsNCi0JCX0NCiAJCW1lbV9jZ3JvdXBf
dW5jaGFyZ2Vfc3RhcnQoKTsNCiAJCWZvciAoaSA9IDA7IGkgPCBwYWdldmVjX2NvdW50KCZwdmVj
KTsgaSsrKSB7DQogCQkJc3RydWN0IHBhZ2UgKnBhZ2UgPSBwdmVjLnBhZ2VzW2ldOw0KQEAgLTUx
Myw4ICs1MjEsMTIgQEAgdm9pZCBzaG1lbV90cnVuY2F0ZV9yYW5nZShzdHJ1Y3QgaW5vZGUgKmlu
b2RlLCBsb2ZmX3QgbHN0YXJ0LCBsb2ZmX3QgbGVuZCkNCiAJCQkJYnJlYWs7DQogDQogCQkJaWYg
KHJhZGl4X3RyZWVfZXhjZXB0aW9uYWxfZW50cnkocGFnZSkpIHsNCi0JCQkJbnJfc3dhcHNfZnJl
ZWQgKz0gIXNobWVtX2ZyZWVfc3dhcChtYXBwaW5nLA0KLQkJCQkJCQkJaW5kZXgsIHBhZ2UpOw0K
KwkJCQlpZiAoc2htZW1fZnJlZV9zd2FwKG1hcHBpbmcsIGluZGV4LCBwYWdlKSkgew0KKwkJCQkJ
LyogU3dhcCB3YXMgcmVwbGFjZWQgYnkgcGFnZTogcmV0cnkgKi8NCisJCQkJCWluZGV4LS07DQor
CQkJCQlicmVhazsNCisJCQkJfQ0KKwkJCQlucl9zd2Fwc19mcmVlZCsrOw0KIAkJCQljb250aW51
ZTsNCiAJCQl9DQogDQpAQCAtNTIyLDYgKzUzNCwxMSBAQCB2b2lkIHNobWVtX3RydW5jYXRlX3Jh
bmdlKHN0cnVjdCBpbm9kZSAqaW5vZGUsIGxvZmZfdCBsc3RhcnQsIGxvZmZfdCBsZW5kKQ0KIAkJ
CWlmIChwYWdlLT5tYXBwaW5nID09IG1hcHBpbmcpIHsNCiAJCQkJVk1fQlVHX09OKFBhZ2VXcml0
ZWJhY2socGFnZSkpOw0KIAkJCQl0cnVuY2F0ZV9pbm9kZV9wYWdlKG1hcHBpbmcsIHBhZ2UpOw0K
KwkJCX0gZWxzZSB7DQorCQkJCS8qIFBhZ2Ugd2FzIHJlcGxhY2VkIGJ5IHN3YXA6IHJldHJ5ICov
DQorCQkJCXVubG9ja19wYWdlKHBhZ2UpOw0KKwkJCQlpbmRleC0tOw0KKwkJCQlicmVhazsNCiAJ
CQl9DQogCQkJdW5sb2NrX3BhZ2UocGFnZSk7DQogCQl9DQpAQCAtMTA2MCw2ICsxMDc3LDYzIEBA
IHN0YXRpYyBpbnQgc2htZW1fZmF1bHQoc3RydWN0IHZtX2FyZWFfc3RydWN0ICp2bWEsIHN0cnVj
dCB2bV9mYXVsdCAqdm1mKQ0KIAlpbnQgZXJyb3I7DQogCWludCByZXQgPSBWTV9GQVVMVF9MT0NL
RUQ7DQogDQorCS8qDQorCSAqIFRyaW5pdHkgZmluZHMgdGhhdCBwcm9iaW5nIGEgaG9sZSB3aGlj
aCB0bXBmcyBpcyBwdW5jaGluZyBjYW4NCisJICogcHJldmVudCB0aGUgaG9sZS1wdW5jaCBmcm9t
IGV2ZXIgY29tcGxldGluZzogd2hpY2ggaW4gdHVybg0KKwkgKiBsb2NrcyB3cml0ZXJzIG91dCB3
aXRoIGl0cyBob2xkIG9uIGlfbXV0ZXguICBTbyByZWZyYWluIGZyb20NCisJICogZmF1bHRpbmcg
cGFnZXMgaW50byB0aGUgaG9sZSB3aGlsZSBpdCdzIGJlaW5nIHB1bmNoZWQuICBBbHRob3VnaA0K
KwkgKiBzaG1lbV90cnVuY2F0ZV9yYW5nZSgpIGRvZXMgcmVtb3ZlIHRoZSBhZGRpdGlvbnMsIGl0
IG1heSBiZSB1bmFibGUgdG8NCisJICoga2VlcCB1cCwgYXMgZWFjaCBuZXcgcGFnZSBuZWVkcyBp
dHMgb3duIHVubWFwX21hcHBpbmdfcmFuZ2UoKSBjYWxsLA0KKwkgKiBhbmQgdGhlIGlfbW1hcCB0
cmVlIGdyb3dzIGV2ZXIgc2xvd2VyIHRvIHNjYW4gaWYgbmV3IHZtYXMgYXJlIGFkZGVkLg0KKwkg
Kg0KKwkgKiBJdCBkb2VzIG5vdCBtYXR0ZXIgaWYgd2Ugc29tZXRpbWVzIHJlYWNoIHRoaXMgY2hl
Y2sganVzdCBiZWZvcmUgdGhlDQorCSAqIGhvbGUtcHVuY2ggYmVnaW5zLCBzbyB0aGF0IG9uZSBm
YXVsdCB0aGVuIHJhY2VzIHdpdGggdGhlIHB1bmNoOg0KKwkgKiB3ZSBqdXN0IG5lZWQgdG8gbWFr
ZSByYWNpbmcgZmF1bHRzIGEgcmFyZSBjYXNlLg0KKwkgKg0KKwkgKiBUaGUgaW1wbGVtZW50YXRp
b24gYmVsb3cgd291bGQgYmUgbXVjaCBzaW1wbGVyIGlmIHdlIGp1c3QgdXNlZCBhDQorCSAqIHN0
YW5kYXJkIG11dGV4IG9yIGNvbXBsZXRpb246IGJ1dCB3ZSBjYW5ub3QgdGFrZSBpX211dGV4IGlu
IGZhdWx0LA0KKwkgKiBhbmQgYmxvYXRpbmcgZXZlcnkgc2htZW0gaW5vZGUgZm9yIHRoaXMgdW5s
aWtlbHkgY2FzZSB3b3VsZCBiZSBzYWQuDQorCSAqLw0KKwlpZiAodW5saWtlbHkoaW5vZGUtPmlf
cHJpdmF0ZSkpIHsNCisJCXN0cnVjdCBzaG1lbV9mYWxsb2MgKnNobWVtX2ZhbGxvYzsNCisNCisJ
CXNwaW5fbG9jaygmaW5vZGUtPmlfbG9jayk7DQorCQlzaG1lbV9mYWxsb2MgPSBpbm9kZS0+aV9w
cml2YXRlOw0KKwkJaWYgKHNobWVtX2ZhbGxvYyAmJg0KKwkJICAgIHZtZi0+cGdvZmYgPj0gc2ht
ZW1fZmFsbG9jLT5zdGFydCAmJg0KKwkJICAgIHZtZi0+cGdvZmYgPCBzaG1lbV9mYWxsb2MtPm5l
eHQpIHsNCisJCQl3YWl0X3F1ZXVlX2hlYWRfdCAqc2htZW1fZmFsbG9jX3dhaXRxOw0KKwkJCURF
RklORV9XQUlUKHNobWVtX2ZhdWx0X3dhaXQpOw0KKw0KKwkJCXJldCA9IFZNX0ZBVUxUX05PUEFH
RTsNCisJCQlpZiAoKHZtZi0+ZmxhZ3MgJiBGQVVMVF9GTEFHX0FMTE9XX1JFVFJZKSAmJg0KKwkJ
CSAgICEodm1mLT5mbGFncyAmIEZBVUxUX0ZMQUdfUkVUUllfTk9XQUlUKSkgew0KKwkJCQkvKiBJ
dCdzIHBvbGl0ZSB0byB1cCBtbWFwX3NlbSBpZiB3ZSBjYW4gKi8NCisJCQkJdXBfcmVhZCgmdm1h
LT52bV9tbS0+bW1hcF9zZW0pOw0KKwkJCQlyZXQgPSBWTV9GQVVMVF9SRVRSWTsNCisJCQl9DQor
DQorCQkJc2htZW1fZmFsbG9jX3dhaXRxID0gc2htZW1fZmFsbG9jLT53YWl0cTsNCisJCQlwcmVw
YXJlX3RvX3dhaXQoc2htZW1fZmFsbG9jX3dhaXRxLCAmc2htZW1fZmF1bHRfd2FpdCwNCisJCQkJ
CVRBU0tfVU5JTlRFUlJVUFRJQkxFKTsNCisJCQlzcGluX3VubG9jaygmaW5vZGUtPmlfbG9jayk7
DQorCQkJc2NoZWR1bGUoKTsNCisNCisJCQkvKg0KKwkJCSAqIHNobWVtX2ZhbGxvY193YWl0cSBw
b2ludHMgaW50byB0aGUgdm10cnVuY2F0ZV9yYW5nZSgpDQorCQkJICogc3RhY2sgb2YgdGhlIGhv
bGUtcHVuY2hpbmcgdGFzazogc2htZW1fZmFsbG9jX3dhaXRxDQorCQkJICogaXMgdXN1YWxseSBp
bnZhbGlkIGJ5IHRoZSB0aW1lIHdlIHJlYWNoIGhlcmUsIGJ1dA0KKwkJCSAqIGZpbmlzaF93YWl0
KCkgZG9lcyBub3QgZGVyZWZlcmVuY2UgaXQgaW4gdGhhdCBjYXNlOw0KKwkJCSAqIHRob3VnaCBp
X2xvY2sgbmVlZGVkIGxlc3QgcmFjaW5nIHdpdGggd2FrZV91cF9hbGwoKS4NCisJCQkgKi8NCisJ
CQlzcGluX2xvY2soJmlub2RlLT5pX2xvY2spOw0KKwkJCWZpbmlzaF93YWl0KHNobWVtX2ZhbGxv
Y193YWl0cSwgJnNobWVtX2ZhdWx0X3dhaXQpOw0KKwkJCXNwaW5fdW5sb2NrKCZpbm9kZS0+aV9s
b2NrKTsNCisJCQlyZXR1cm4gcmV0Ow0KKwkJfQ0KKwkJc3Bpbl91bmxvY2soJmlub2RlLT5pX2xv
Y2spOw0KKwl9DQorDQogCWVycm9yID0gc2htZW1fZ2V0cGFnZShpbm9kZSwgdm1mLT5wZ29mZiwg
JnZtZi0+cGFnZSwgU0dQX0NBQ0hFLCAmcmV0KTsNCiAJaWYgKGVycm9yKQ0KIAkJcmV0dXJuICgo
ZXJyb3IgPT0gLUVOT01FTSkgPyBWTV9GQVVMVF9PT00gOiBWTV9GQVVMVF9TSUdCVVMpOw0KQEAg
LTEwNzEsNiArMTE0NSw0NyBAQCBzdGF0aWMgaW50IHNobWVtX2ZhdWx0KHN0cnVjdCB2bV9hcmVh
X3N0cnVjdCAqdm1hLCBzdHJ1Y3Qgdm1fZmF1bHQgKnZtZikNCiAJcmV0dXJuIHJldDsNCiB9DQog
DQoraW50IHZtdHJ1bmNhdGVfcmFuZ2Uoc3RydWN0IGlub2RlICppbm9kZSwgbG9mZl90IGxzdGFy
dCwgbG9mZl90IGxlbmQpDQorew0KKwkvKg0KKwkgKiBJZiB0aGUgdW5kZXJseWluZyBmaWxlc3lz
dGVtIGlzIG5vdCBnb2luZyB0byBwcm92aWRlDQorCSAqIGEgd2F5IHRvIHRydW5jYXRlIGEgcmFu
Z2Ugb2YgYmxvY2tzIChwdW5jaCBhIGhvbGUpIC0NCisJICogd2Ugc2hvdWxkIHJldHVybiBmYWls
dXJlIHJpZ2h0IG5vdy4NCisJICogT25seSBDT05GSUdfU0hNRU0gc2htZW0uYyBldmVyIHN1cHBv
cnRlZCBpX29wLT50cnVuY2F0ZV9yYW5nZSgpLg0KKwkgKi8NCisJaWYgKGlub2RlLT5pX29wLT50
cnVuY2F0ZV9yYW5nZSAhPSBzaG1lbV90cnVuY2F0ZV9yYW5nZSkNCisJCXJldHVybiAtRU5PU1lT
Ow0KKw0KKwltdXRleF9sb2NrKCZpbm9kZS0+aV9tdXRleCk7DQorCXsNCisJCXN0cnVjdCBzaG1l
bV9mYWxsb2Mgc2htZW1fZmFsbG9jOw0KKwkJc3RydWN0IGFkZHJlc3Nfc3BhY2UgKm1hcHBpbmcg
PSBpbm9kZS0+aV9tYXBwaW5nOw0KKwkJbG9mZl90IHVubWFwX3N0YXJ0ID0gcm91bmRfdXAobHN0
YXJ0LCBQQUdFX1NJWkUpOw0KKwkJbG9mZl90IHVubWFwX2VuZCA9IHJvdW5kX2Rvd24oMSArIGxl
bmQsIFBBR0VfU0laRSkgLSAxOw0KKwkJREVDTEFSRV9XQUlUX1FVRVVFX0hFQURfT05TVEFDSyhz
aG1lbV9mYWxsb2Nfd2FpdHEpOw0KKw0KKwkJc2htZW1fZmFsbG9jLndhaXRxID0gJnNobWVtX2Zh
bGxvY193YWl0cTsNCisJCXNobWVtX2ZhbGxvYy5zdGFydCA9IHVubWFwX3N0YXJ0ID4+IFBBR0Vf
U0hJRlQ7DQorCQlzaG1lbV9mYWxsb2MubmV4dCA9ICh1bm1hcF9lbmQgKyAxKSA+PiBQQUdFX1NI
SUZUOw0KKwkJc3Bpbl9sb2NrKCZpbm9kZS0+aV9sb2NrKTsNCisJCWlub2RlLT5pX3ByaXZhdGUg
PSAmc2htZW1fZmFsbG9jOw0KKwkJc3Bpbl91bmxvY2soJmlub2RlLT5pX2xvY2spOw0KKw0KKwkJ
aWYgKCh1NjQpdW5tYXBfZW5kID4gKHU2NCl1bm1hcF9zdGFydCkNCisJCQl1bm1hcF9tYXBwaW5n
X3JhbmdlKG1hcHBpbmcsIHVubWFwX3N0YXJ0LA0KKwkJCQkJICAgIDEgKyB1bm1hcF9lbmQgLSB1
bm1hcF9zdGFydCwgMCk7DQorCQlzaG1lbV90cnVuY2F0ZV9yYW5nZShpbm9kZSwgbHN0YXJ0LCBs
ZW5kKTsNCisJCS8qIE5vIG5lZWQgdG8gdW5tYXAgYWdhaW46IGhvbGUtcHVuY2hpbmcgbGVhdmVz
IENPV2VkIHBhZ2VzICovDQorDQorCQlzcGluX2xvY2soJmlub2RlLT5pX2xvY2spOw0KKwkJaW5v
ZGUtPmlfcHJpdmF0ZSA9IE5VTEw7DQorCQl3YWtlX3VwX2FsbCgmc2htZW1fZmFsbG9jX3dhaXRx
KTsNCisJCXNwaW5fdW5sb2NrKCZpbm9kZS0+aV9sb2NrKTsNCisJfQ0KKwltdXRleF91bmxvY2so
Jmlub2RlLT5pX211dGV4KTsNCisJcmV0dXJuIDA7DQorfQ0KKw0KICNpZmRlZiBDT05GSUdfTlVN
QQ0KIHN0YXRpYyBpbnQgc2htZW1fc2V0X3BvbGljeShzdHJ1Y3Qgdm1fYXJlYV9zdHJ1Y3QgKnZt
YSwgc3RydWN0IG1lbXBvbGljeSAqbXBvbCkNCiB7DQpAQCAtMjQ5Niw2ICsyNjExLDEyIEBAIHZv
aWQgc2htZW1fdHJ1bmNhdGVfcmFuZ2Uoc3RydWN0IGlub2RlICppbm9kZSwgbG9mZl90IGxzdGFy
dCwgbG9mZl90IGxlbmQpDQogfQ0KIEVYUE9SVF9TWU1CT0xfR1BMKHNobWVtX3RydW5jYXRlX3Jh
bmdlKTsNCiANCitpbnQgdm10cnVuY2F0ZV9yYW5nZShzdHJ1Y3QgaW5vZGUgKmlub2RlLCBsb2Zm
X3QgbHN0YXJ0LCBsb2ZmX3QgbGVuZCkNCit7DQorCS8qIE9ubHkgQ09ORklHX1NITUVNIHNobWVt
LmMgZXZlciBzdXBwb3J0ZWQgaV9vcC0+dHJ1bmNhdGVfcmFuZ2UoKS4gKi8NCisJcmV0dXJuIC1F
Tk9TWVM7DQorfQ0KKw0KICNkZWZpbmUgc2htZW1fdm1fb3BzCQkJCWdlbmVyaWNfZmlsZV92bV9v
cHMNCiAjZGVmaW5lIHNobWVtX2ZpbGVfb3BlcmF0aW9ucwkJCXJhbWZzX2ZpbGVfb3BlcmF0aW9u
cw0KICNkZWZpbmUgc2htZW1fZ2V0X2lub2RlKHNiLCBkaXIsIG1vZGUsIGRldiwgZmxhZ3MpCXJh
bWZzX2dldF9pbm9kZShzYiwgZGlyLCBtb2RlLCBkZXYpDQpkaWZmIC0tZ2l0IGEvbW0vdHJ1bmNh
dGUuYyBiL21tL3RydW5jYXRlLmMNCmluZGV4IDAwZmI1OGEuLjQwZDE4NmYgMTAwNjQ0DQotLS0g
YS9tbS90cnVuY2F0ZS5jDQorKysgYi9tbS90cnVuY2F0ZS5jDQpAQCAtNjAyLDI4ICs2MDIsMyBA
QCBpbnQgdm10cnVuY2F0ZShzdHJ1Y3QgaW5vZGUgKmlub2RlLCBsb2ZmX3QgbmV3c2l6ZSkNCiAJ
cmV0dXJuIDA7DQogfQ0KIEVYUE9SVF9TWU1CT0wodm10cnVuY2F0ZSk7DQotDQotaW50IHZtdHJ1
bmNhdGVfcmFuZ2Uoc3RydWN0IGlub2RlICppbm9kZSwgbG9mZl90IGxzdGFydCwgbG9mZl90IGxl
bmQpDQotew0KLQlzdHJ1Y3QgYWRkcmVzc19zcGFjZSAqbWFwcGluZyA9IGlub2RlLT5pX21hcHBp
bmc7DQotCWxvZmZfdCBob2xlYmVnaW4gPSByb3VuZF91cChsc3RhcnQsIFBBR0VfU0laRSk7DQot
CWxvZmZfdCBob2xlbGVuID0gMSArIGxlbmQgLSBob2xlYmVnaW47DQotDQotCS8qDQotCSAqIElm
IHRoZSB1bmRlcmx5aW5nIGZpbGVzeXN0ZW0gaXMgbm90IGdvaW5nIHRvIHByb3ZpZGUNCi0JICog
YSB3YXkgdG8gdHJ1bmNhdGUgYSByYW5nZSBvZiBibG9ja3MgKHB1bmNoIGEgaG9sZSkgLQ0KLQkg
KiB3ZSBzaG91bGQgcmV0dXJuIGZhaWx1cmUgcmlnaHQgbm93Lg0KLQkgKi8NCi0JaWYgKCFpbm9k
ZS0+aV9vcC0+dHJ1bmNhdGVfcmFuZ2UpDQotCQlyZXR1cm4gLUVOT1NZUzsNCi0NCi0JbXV0ZXhf
bG9jaygmaW5vZGUtPmlfbXV0ZXgpOw0KLQlpbm9kZV9kaW9fd2FpdChpbm9kZSk7DQotCXVubWFw
X21hcHBpbmdfcmFuZ2UobWFwcGluZywgaG9sZWJlZ2luLCBob2xlbGVuLCAxKTsNCi0JaW5vZGUt
Pmlfb3AtPnRydW5jYXRlX3JhbmdlKGlub2RlLCBsc3RhcnQsIGxlbmQpOw0KLQkvKiB1bm1hcCBh
Z2FpbiB0byByZW1vdmUgcmFjaWx5IENPV2VkIHByaXZhdGUgcGFnZXMgKi8NCi0JdW5tYXBfbWFw
cGluZ19yYW5nZShtYXBwaW5nLCBob2xlYmVnaW4sIGhvbGVsZW4sIDEpOw0KLQltdXRleF91bmxv
Y2soJmlub2RlLT5pX211dGV4KTsNCi0NCi0JcmV0dXJuIDA7DQotfQ0KZGlmZiAtLWdpdCBhL21t
L3ZtYWxsb2MuYyBiL21tL3ZtYWxsb2MuYw0KaW5kZXggZWViYTNiYi4uMTQzMTQ1OCAxMDA2NDQN
Ci0tLSBhL21tL3ZtYWxsb2MuYw0KKysrIGIvbW0vdm1hbGxvYy5jDQpAQCAtMzQ5LDYgKzM0OSwx
MiBAQCBzdGF0aWMgc3RydWN0IHZtYXBfYXJlYSAqYWxsb2Nfdm1hcF9hcmVhKHVuc2lnbmVkIGxv
bmcgc2l6ZSwNCiAJaWYgKHVubGlrZWx5KCF2YSkpDQogCQlyZXR1cm4gRVJSX1BUUigtRU5PTUVN
KTsNCiANCisJLyoNCisJICogT25seSBzY2FuIHRoZSByZWxldmFudCBwYXJ0cyBjb250YWluaW5n
IHBvaW50ZXJzIHRvIG90aGVyIG9iamVjdHMNCisJICogdG8gYXZvaWQgZmFsc2UgbmVnYXRpdmVz
Lg0KKwkgKi8NCisJa21lbWxlYWtfc2Nhbl9hcmVhKCZ2YS0+cmJfbm9kZSwgU0laRV9NQVgsIGdm
cF9tYXNrICYgR0ZQX1JFQ0xBSU1fTUFTSyk7DQorDQogcmV0cnk6DQogCXNwaW5fbG9jaygmdm1h
cF9hcmVhX2xvY2spOw0KIAkvKg0KQEAgLTE2NDQsMTEgKzE2NTAsMTEgQEAgdm9pZCAqX192bWFs
bG9jX25vZGVfcmFuZ2UodW5zaWduZWQgbG9uZyBzaXplLCB1bnNpZ25lZCBsb25nIGFsaWduLA0K
IAlpbnNlcnRfdm1hbGxvY192bWxpc3QoYXJlYSk7DQogDQogCS8qDQotCSAqIEEgcmVmX2NvdW50
ID0gMyBpcyBuZWVkZWQgYmVjYXVzZSB0aGUgdm1fc3RydWN0IGFuZCB2bWFwX2FyZWENCi0JICog
c3RydWN0dXJlcyBhbGxvY2F0ZWQgaW4gdGhlIF9fZ2V0X3ZtX2FyZWFfbm9kZSgpIGZ1bmN0aW9u
IGNvbnRhaW4NCi0JICogcmVmZXJlbmNlcyB0byB0aGUgdmlydHVhbCBhZGRyZXNzIG9mIHRoZSB2
bWFsbG9jJ2VkIGJsb2NrLg0KKwkgKiBBIHJlZl9jb3VudCA9IDIgaXMgbmVlZGVkIGJlY2F1c2Ug
dm1fc3RydWN0IGFsbG9jYXRlZCBpbg0KKwkgKiBfX2dldF92bV9hcmVhX25vZGUoKSBjb250YWlu
cyBhIHJlZmVyZW5jZSB0byB0aGUgdmlydHVhbCBhZGRyZXNzIG9mDQorCSAqIHRoZSB2bWFsbG9j
J2VkIGJsb2NrLg0KIAkgKi8NCi0Ja21lbWxlYWtfYWxsb2MoYWRkciwgcmVhbF9zaXplLCAzLCBn
ZnBfbWFzayk7DQorCWttZW1sZWFrX2FsbG9jKGFkZHIsIHJlYWxfc2l6ZSwgMiwgZ2ZwX21hc2sp
Ow0KIA0KIAlyZXR1cm4gYWRkcjsNCiANCmRpZmYgLS1naXQgYS9uZXQvODAyMXEvdmxhbl9jb3Jl
LmMgYi9uZXQvODAyMXEvdmxhbl9jb3JlLmMNCmluZGV4IGU4NjBhNGYuLjc3ZDM1MzIgMTAwNjQ0
DQotLS0gYS9uZXQvODAyMXEvdmxhbl9jb3JlLmMNCisrKyBiL25ldC84MDIxcS92bGFuX2NvcmUu
Yw0KQEAgLTk2LDggKzk2LDExIEBAIEVYUE9SVF9TWU1CT0wodmxhbl9kZXZfdmxhbl9pZCk7DQog
DQogc3RhdGljIHN0cnVjdCBza19idWZmICp2bGFuX3Jlb3JkZXJfaGVhZGVyKHN0cnVjdCBza19i
dWZmICpza2IpDQogew0KLQlpZiAoc2tiX2Nvdyhza2IsIHNrYl9oZWFkcm9vbShza2IpKSA8IDAp
DQorCWlmIChza2JfY293KHNrYiwgc2tiX2hlYWRyb29tKHNrYikpIDwgMCkgew0KKwkJa2ZyZWVf
c2tiKHNrYik7DQogCQlyZXR1cm4gTlVMTDsNCisJfQ0KKw0KIAltZW1tb3ZlKHNrYi0+ZGF0YSAt
IEVUSF9ITEVOLCBza2ItPmRhdGEgLSBWTEFOX0VUSF9ITEVOLCAyICogRVRIX0FMRU4pOw0KIAlz
a2ItPm1hY19oZWFkZXIgKz0gVkxBTl9ITEVOOw0KIAlyZXR1cm4gc2tiOw0KZGlmZiAtLWdpdCBh
L25ldC9hcHBsZXRhbGsvZGRwLmMgYi9uZXQvYXBwbGV0YWxrL2RkcC5jDQppbmRleCAzMzRkNGNk
Li43OWFhYWMyIDEwMDY0NA0KLS0tIGEvbmV0L2FwcGxldGFsay9kZHAuYw0KKysrIGIvbmV0L2Fw
cGxldGFsay9kZHAuYw0KQEAgLTE0OTQsOCArMTQ5NCw2IEBAIHN0YXRpYyBpbnQgYXRhbGtfcmN2
KHN0cnVjdCBza19idWZmICpza2IsIHN0cnVjdCBuZXRfZGV2aWNlICpkZXYsDQogCQlnb3RvIGRy
b3A7DQogDQogCS8qIFF1ZXVlIHBhY2tldCAoc3RhbmRhcmQpICovDQotCXNrYi0+c2sgPSBzb2Nr
Ow0KLQ0KIAlpZiAoc29ja19xdWV1ZV9yY3Zfc2tiKHNvY2ssIHNrYikgPCAwKQ0KIAkJZ290byBk
cm9wOw0KIA0KQEAgLTE2NDksNyArMTY0Nyw2IEBAIHN0YXRpYyBpbnQgYXRhbGtfc2VuZG1zZyhz
dHJ1Y3Qga2lvY2IgKmlvY2IsIHN0cnVjdCBzb2NrZXQgKnNvY2ssIHN0cnVjdCBtc2doZHINCiAJ
aWYgKCFza2IpDQogCQlnb3RvIG91dDsNCiANCi0Jc2tiLT5zayA9IHNrOw0KIAlza2JfcmVzZXJ2
ZShza2IsIGRkcF9kbC0+aGVhZGVyX2xlbmd0aCk7DQogCXNrYl9yZXNlcnZlKHNrYiwgZGV2LT5o
YXJkX2hlYWRlcl9sZW4pOw0KIAlza2ItPmRldiA9IGRldjsNCmRpZmYgLS1naXQgYS9uZXQvY29y
ZS9ydG5ldGxpbmsuYyBiL25ldC9jb3JlL3J0bmV0bGluay5jDQppbmRleCA3YmVhZjEwLi4wOTAw
YTE3IDEwMDY0NA0KLS0tIGEvbmV0L2NvcmUvcnRuZXRsaW5rLmMNCisrKyBiL25ldC9jb3JlL3J0
bmV0bGluay5jDQpAQCAtMTA2Miw2ICsxMDYyLDcgQEAgc3RhdGljIGludCBydG5sX2R1bXBfaWZp
bmZvKHN0cnVjdCBza19idWZmICpza2IsIHN0cnVjdCBuZXRsaW5rX2NhbGxiYWNrICpjYikNCiAJ
c3RydWN0IG5sYXR0ciAqdGJbSUZMQV9NQVgrMV07DQogCXUzMiBleHRfZmlsdGVyX21hc2sgPSAw
Ow0KIAlpbnQgZXJyOw0KKwlpbnQgaGRybGVuOw0KIA0KIAlzX2ggPSBjYi0+YXJnc1swXTsNCiAJ
c19pZHggPSBjYi0+YXJnc1sxXTsNCkBAIC0xMDY5LDggKzEwNzAsMTcgQEAgc3RhdGljIGludCBy
dG5sX2R1bXBfaWZpbmZvKHN0cnVjdCBza19idWZmICpza2IsIHN0cnVjdCBuZXRsaW5rX2NhbGxi
YWNrICpjYikNCiAJcmN1X3JlYWRfbG9jaygpOw0KIAljYi0+c2VxID0gbmV0LT5kZXZfYmFzZV9z
ZXE7DQogDQotCWlmIChubG1zZ19wYXJzZShjYi0+bmxoLCBzaXplb2Yoc3RydWN0IGlmaW5mb21z
ZyksIHRiLCBJRkxBX01BWCwNCi0JCQlpZmxhX3BvbGljeSkgPj0gMCkgew0KKwkvKiBBIGhhY2sg
dG8gcHJlc2VydmUga2VybmVsPC0+dXNlcnNwYWNlIGludGVyZmFjZS4NCisJICogVGhlIGNvcnJl
Y3QgaGVhZGVyIGlzIGlmaW5mb21zZy4gSXQgaXMgY29uc2lzdGVudCB3aXRoIHJ0bmxfZ2V0bGlu
ay4NCisJICogSG93ZXZlciwgYmVmb3JlIExpbnV4IHYzLjkgdGhlIGNvZGUgaGVyZSBhc3N1bWVk
IHJ0Z2VubXNnIGFuZCB0aGF0J3MNCisJICogd2hhdCBpcHJvdXRlMiA8IHYzLjkuMCB1c2VkLg0K
KwkgKiBXZSBjYW4gZGV0ZWN0IHRoZSBvbGQgaXByb3V0ZTIuIEV2ZW4gaW5jbHVkaW5nIHRoZSBJ
RkxBX0VYVF9NQVNLDQorCSAqIGF0dHJpYnV0ZSwgaXRzIG5ldGxpbmsgbWVzc2FnZSBpcyBzaG9y
dGVyIHRoYW4gc3RydWN0IGlmaW5mb21zZy4NCisJICovDQorCWhkcmxlbiA9IG5sbXNnX2xlbihj
Yi0+bmxoKSA8IHNpemVvZihzdHJ1Y3QgaWZpbmZvbXNnKSA/DQorCQkgc2l6ZW9mKHN0cnVjdCBy
dGdlbm1zZykgOiBzaXplb2Yoc3RydWN0IGlmaW5mb21zZyk7DQorDQorCWlmIChubG1zZ19wYXJz
ZShjYi0+bmxoLCBoZHJsZW4sIHRiLCBJRkxBX01BWCwgaWZsYV9wb2xpY3kpID49IDApIHsNCiAN
CiAJCWlmICh0YltJRkxBX0VYVF9NQVNLXSkNCiAJCQlleHRfZmlsdGVyX21hc2sgPSBubGFfZ2V0
X3UzMih0YltJRkxBX0VYVF9NQVNLXSk7DQpAQCAtMTkxNyw5ICsxOTI3LDEzIEBAIHN0YXRpYyB1
MTYgcnRubF9jYWxjaXQoc3RydWN0IHNrX2J1ZmYgKnNrYiwgc3RydWN0IG5sbXNnaGRyICpubGgp
DQogCXN0cnVjdCBubGF0dHIgKnRiW0lGTEFfTUFYKzFdOw0KIAl1MzIgZXh0X2ZpbHRlcl9tYXNr
ID0gMDsNCiAJdTE2IG1pbl9pZmluZm9fZHVtcF9zaXplID0gMDsNCisJaW50IGhkcmxlbjsNCisN
CisJLyogU2FtZSBrZXJuZWw8LT51c2Vyc3BhY2UgaW50ZXJmYWNlIGhhY2sgYXMgaW4gcnRubF9k
dW1wX2lmaW5mby4gKi8NCisJaGRybGVuID0gbmxtc2dfbGVuKG5saCkgPCBzaXplb2Yoc3RydWN0
IGlmaW5mb21zZykgPw0KKwkJIHNpemVvZihzdHJ1Y3QgcnRnZW5tc2cpIDogc2l6ZW9mKHN0cnVj
dCBpZmluZm9tc2cpOw0KIA0KLQlpZiAobmxtc2dfcGFyc2UobmxoLCBzaXplb2Yoc3RydWN0IGlm
aW5mb21zZyksIHRiLCBJRkxBX01BWCwNCi0JCQlpZmxhX3BvbGljeSkgPj0gMCkgew0KKwlpZiAo
bmxtc2dfcGFyc2UobmxoLCBoZHJsZW4sIHRiLCBJRkxBX01BWCwgaWZsYV9wb2xpY3kpID49IDAp
IHsNCiAJCWlmICh0YltJRkxBX0VYVF9NQVNLXSkNCiAJCQlleHRfZmlsdGVyX21hc2sgPSBubGFf
Z2V0X3UzMih0YltJRkxBX0VYVF9NQVNLXSk7DQogCX0NCmRpZmYgLS1naXQgYS9uZXQvZG5zX3Jl
c29sdmVyL2Ruc19xdWVyeS5jIGIvbmV0L2Ruc19yZXNvbHZlci9kbnNfcXVlcnkuYw0KaW5kZXgg
YzMyYmUyOS4uMjAyMmI0NiAxMDA2NDQNCi0tLSBhL25ldC9kbnNfcmVzb2x2ZXIvZG5zX3F1ZXJ5
LmMNCisrKyBiL25ldC9kbnNfcmVzb2x2ZXIvZG5zX3F1ZXJ5LmMNCkBAIC0xNTAsNyArMTUwLDkg
QEAgaW50IGRuc19xdWVyeShjb25zdCBjaGFyICp0eXBlLCBjb25zdCBjaGFyICpuYW1lLCBzaXpl
X3QgbmFtZWxlbiwNCiAJaWYgKCEqX3Jlc3VsdCkNCiAJCWdvdG8gcHV0Ow0KIA0KLQltZW1jcHko
Kl9yZXN1bHQsIHVwYXlsb2FkLT5kYXRhLCBsZW4gKyAxKTsNCisJbWVtY3B5KCpfcmVzdWx0LCB1
cGF5bG9hZC0+ZGF0YSwgbGVuKTsNCisJKCpfcmVzdWx0KVtsZW5dID0gJ1wwJzsNCisNCiAJaWYg
KF9leHBpcnkpDQogCQkqX2V4cGlyeSA9IHJrZXktPmV4cGlyeTsNCiANCmRpZmYgLS1naXQgYS9u
ZXQvaXB2NC9pZ21wLmMgYi9uZXQvaXB2NC9pZ21wLmMNCmluZGV4IDc1YjA4NjAuLjdmN2U2NzAg
MTAwNjQ0DQotLS0gYS9uZXQvaXB2NC9pZ21wLmMNCisrKyBiL25ldC9pcHY0L2lnbXAuYw0KQEAg
LTE4NjIsNiArMTg2MiwxMCBAQCBpbnQgaXBfbWNfbGVhdmVfZ3JvdXAoc3RydWN0IHNvY2sgKnNr
LCBzdHJ1Y3QgaXBfbXJlcW4gKmltcikNCiANCiAJcnRubF9sb2NrKCk7DQogCWluX2RldiA9IGlw
X21jX2ZpbmRfZGV2KG5ldCwgaW1yKTsNCisJaWYgKCFpbl9kZXYpIHsNCisJCXJldCA9IC1FTk9E
RVY7DQorCQlnb3RvIG91dDsNCisJfQ0KIAlpZmluZGV4ID0gaW1yLT5pbXJfaWZpbmRleDsNCiAJ
Zm9yIChpbWxwID0gJmluZXQtPm1jX2xpc3Q7DQogCSAgICAgKGltbCA9IHJ0bmxfZGVyZWZlcmVu
Y2UoKmltbHApKSAhPSBOVUxMOw0KQEAgLTE4NzksMTYgKzE4ODMsMTQgQEAgaW50IGlwX21jX2xl
YXZlX2dyb3VwKHN0cnVjdCBzb2NrICpzaywgc3RydWN0IGlwX21yZXFuICppbXIpDQogDQogCQkq
aW1scCA9IGltbC0+bmV4dF9yY3U7DQogDQotCQlpZiAoaW5fZGV2KQ0KLQkJCWlwX21jX2RlY19n
cm91cChpbl9kZXYsIGdyb3VwKTsNCisJCWlwX21jX2RlY19ncm91cChpbl9kZXYsIGdyb3VwKTsN
CiAJCXJ0bmxfdW5sb2NrKCk7DQogCQkvKiBkZWNyZWFzZSBtZW0gbm93IHRvIGF2b2lkIHRoZSBt
ZW1sZWFrIHdhcm5pbmcgKi8NCiAJCWF0b21pY19zdWIoc2l6ZW9mKCppbWwpLCAmc2stPnNrX29t
ZW1fYWxsb2MpOw0KIAkJa2ZyZWVfcmN1KGltbCwgcmN1KTsNCiAJCXJldHVybiAwOw0KIAl9DQot
CWlmICghaW5fZGV2KQ0KLQkJcmV0ID0gLUVOT0RFVjsNCitvdXQ6DQogCXJ0bmxfdW5sb2NrKCk7
DQogCXJldHVybiByZXQ7DQogfQ0KZGlmZiAtLWdpdCBhL25ldC9pcHY0L2lwX2ZvcndhcmQuYyBi
L25ldC9pcHY0L2lwX2ZvcndhcmQuYw0KaW5kZXggNzU5M2YzYS4uMjlhMDdiNiAxMDA2NDQNCi0t
LSBhL25ldC9pcHY0L2lwX2ZvcndhcmQuYw0KKysrIGIvbmV0L2lwdjQvaXBfZm9yd2FyZC5jDQpA
QCAtMzksNjggKzM5LDYgQEANCiAjaW5jbHVkZSA8bmV0L3JvdXRlLmg+DQogI2luY2x1ZGUgPG5l
dC94ZnJtLmg+DQogDQotc3RhdGljIGJvb2wgaXBfbWF5X2ZyYWdtZW50KGNvbnN0IHN0cnVjdCBz
a19idWZmICpza2IpDQotew0KLQlyZXR1cm4gdW5saWtlbHkoKGlwX2hkcihza2IpLT5mcmFnX29m
ZiAmIGh0b25zKElQX0RGKSkgPT0gMCkgfHwNCi0JCXNrYi0+bG9jYWxfZGY7DQotfQ0KLQ0KLXN0
YXRpYyBib29sIGlwX2V4Y2VlZHNfbXR1KGNvbnN0IHN0cnVjdCBza19idWZmICpza2IsIHVuc2ln
bmVkIGludCBtdHUpDQotew0KLQlpZiAoc2tiLT5sZW4gPD0gbXR1KQ0KLQkJcmV0dXJuIGZhbHNl
Ow0KLQ0KLQlpZiAoc2tiX2lzX2dzbyhza2IpICYmIHNrYl9nc29fbmV0d29ya19zZWdsZW4oc2ti
KSA8PSBtdHUpDQotCQlyZXR1cm4gZmFsc2U7DQotDQotCXJldHVybiB0cnVlOw0KLX0NCi0NCi1z
dGF0aWMgYm9vbCBpcF9nc29fZXhjZWVkc19kc3RfbXR1KGNvbnN0IHN0cnVjdCBza19idWZmICpz
a2IpDQotew0KLQl1bnNpZ25lZCBpbnQgbXR1Ow0KLQ0KLQlpZiAoc2tiLT5sb2NhbF9kZiB8fCAh
c2tiX2lzX2dzbyhza2IpKQ0KLQkJcmV0dXJuIGZhbHNlOw0KLQ0KLQltdHUgPSBkc3RfbXR1KHNr
Yl9kc3Qoc2tiKSk7DQotDQotCS8qIGlmIHNlZ2xlbiA+IG10dSwgZG8gc29mdHdhcmUgc2VnbWVu
dGF0aW9uIGZvciBJUCBmcmFnbWVudGF0aW9uIG9uDQotCSAqIG91dHB1dC4gIERGIGJpdCBjYW5u
b3QgYmUgc2V0IHNpbmNlIGlwX2ZvcndhcmQgd291bGQgaGF2ZSBzZW50DQotCSAqIGljbXAgZXJy
b3IuDQotCSAqLw0KLQlyZXR1cm4gc2tiX2dzb19uZXR3b3JrX3NlZ2xlbihza2IpID4gbXR1Ow0K
LX0NCi0NCi0vKiBjYWxsZWQgaWYgR1NPIHNrYiBuZWVkcyB0byBiZSBmcmFnbWVudGVkIG9uIGZv
cndhcmQgKi8NCi1zdGF0aWMgaW50IGlwX2ZvcndhcmRfZmluaXNoX2dzbyhzdHJ1Y3Qgc2tfYnVm
ZiAqc2tiKQ0KLXsNCi0Jc3RydWN0IHNrX2J1ZmYgKnNlZ3M7DQotCWludCByZXQgPSAwOw0KLQ0K
LQlzZWdzID0gc2tiX2dzb19zZWdtZW50KHNrYiwgMCk7DQotCWlmIChJU19FUlIoc2VncykpIHsN
Ci0JCWtmcmVlX3NrYihza2IpOw0KLQkJcmV0dXJuIC1FTk9NRU07DQotCX0NCi0NCi0JY29uc3Vt
ZV9za2Ioc2tiKTsNCi0NCi0JZG8gew0KLQkJc3RydWN0IHNrX2J1ZmYgKm5za2IgPSBzZWdzLT5u
ZXh0Ow0KLQkJaW50IGVycjsNCi0NCi0JCXNlZ3MtPm5leHQgPSBOVUxMOw0KLQkJZXJyID0gZHN0
X291dHB1dChzZWdzKTsNCi0NCi0JCWlmIChlcnIgJiYgcmV0ID09IDApDQotCQkJcmV0ID0gZXJy
Ow0KLQkJc2VncyA9IG5za2I7DQotCX0gd2hpbGUgKHNlZ3MpOw0KLQ0KLQlyZXR1cm4gcmV0Ow0K
LX0NCi0NCiBzdGF0aWMgaW50IGlwX2ZvcndhcmRfZmluaXNoKHN0cnVjdCBza19idWZmICpza2Ip
DQogew0KIAlzdHJ1Y3QgaXBfb3B0aW9ucyAqIG9wdAk9ICYoSVBDQihza2IpLT5vcHQpOw0KQEAg
LTExMCw5ICs0OCw2IEBAIHN0YXRpYyBpbnQgaXBfZm9yd2FyZF9maW5pc2goc3RydWN0IHNrX2J1
ZmYgKnNrYikNCiAJaWYgKHVubGlrZWx5KG9wdC0+b3B0bGVuKSkNCiAJCWlwX2ZvcndhcmRfb3B0
aW9ucyhza2IpOw0KIA0KLQlpZiAoaXBfZ3NvX2V4Y2VlZHNfZHN0X210dShza2IpKQ0KLQkJcmV0
dXJuIGlwX2ZvcndhcmRfZmluaXNoX2dzbyhza2IpOw0KLQ0KIAlyZXR1cm4gZHN0X291dHB1dChz
a2IpOw0KIH0NCiANCkBAIC0xNTIsNyArODcsOCBAQCBpbnQgaXBfZm9yd2FyZChzdHJ1Y3Qgc2tf
YnVmZiAqc2tiKQ0KIAlpZiAob3B0LT5pc19zdHJpY3Ryb3V0ZSAmJiBvcHQtPm5leHRob3AgIT0g
cnQtPnJ0X2dhdGV3YXkpDQogCQlnb3RvIHNyX2ZhaWxlZDsNCiANCi0JaWYgKCFpcF9tYXlfZnJh
Z21lbnQoc2tiKSAmJiBpcF9leGNlZWRzX210dShza2IsIGRzdF9tdHUoJnJ0LT5kc3QpKSkgew0K
KwlpZiAodW5saWtlbHkoc2tiLT5sZW4gPiBkc3RfbXR1KCZydC0+ZHN0KSAmJiAhc2tiX2lzX2dz
byhza2IpICYmDQorCQkgICAgIChpcF9oZHIoc2tiKS0+ZnJhZ19vZmYgJiBodG9ucyhJUF9ERikp
KSAmJiAhc2tiLT5sb2NhbF9kZikgew0KIAkJSVBfSU5DX1NUQVRTKGRldl9uZXQocnQtPmRzdC5k
ZXYpLCBJUFNUQVRTX01JQl9GUkFHRkFJTFMpOw0KIAkJaWNtcF9zZW5kKHNrYiwgSUNNUF9ERVNU
X1VOUkVBQ0gsIElDTVBfRlJBR19ORUVERUQsDQogCQkJICBodG9ubChkc3RfbXR1KCZydC0+ZHN0
KSkpOw0KZGlmZiAtLWdpdCBhL25ldC9pcHY0L2lwX29wdGlvbnMuYyBiL25ldC9pcHY0L2lwX29w
dGlvbnMuYw0KaW5kZXggNDBlYjRmYy4uMDg2MjNlMiAxMDA2NDQNCi0tLSBhL25ldC9pcHY0L2lw
X29wdGlvbnMuYw0KKysrIGIvbmV0L2lwdjQvaXBfb3B0aW9ucy5jDQpAQCAtMjc3LDYgKzI3Nywx
MCBAQCBpbnQgaXBfb3B0aW9uc19jb21waWxlKHN0cnVjdCBuZXQgKm5ldCwNCiAJCQlvcHRwdHIr
KzsNCiAJCQljb250aW51ZTsNCiAJCX0NCisJCWlmICh1bmxpa2VseShsIDwgMikpIHsNCisJCQlw
cF9wdHIgPSBvcHRwdHI7DQorCQkJZ290byBlcnJvcjsNCisJCX0NCiAJCW9wdGxlbiA9IG9wdHB0
clsxXTsNCiAJCWlmIChvcHRsZW48MiB8fCBvcHRsZW4+bCkgew0KIAkJCXBwX3B0ciA9IG9wdHB0
cjsNCmRpZmYgLS1naXQgYS9uZXQvaXB2NC9uZXRmaWx0ZXIvaXB0X1VMT0cuYyBiL25ldC9pcHY0
L25ldGZpbHRlci9pcHRfVUxPRy5jDQppbmRleCBiNTUwODE1Li5jM2I0NGQ1IDEwMDY0NA0KLS0t
IGEvbmV0L2lwdjQvbmV0ZmlsdGVyL2lwdF9VTE9HLmMNCisrKyBiL25ldC9pcHY0L25ldGZpbHRl
ci9pcHRfVUxPRy5jDQpAQCAtMjAyLDYgKzIwMiw3IEBAIHN0YXRpYyB2b2lkIGlwdF91bG9nX3Bh
Y2tldCh1bnNpZ25lZCBpbnQgaG9va251bSwNCiAJdWItPnFsZW4rKzsNCiANCiAJcG0gPSBOTE1T
R19EQVRBKG5saCk7DQorCW1lbXNldChwbSwgMCwgc2l6ZW9mKCpwbSkpOw0KIA0KIAkvKiBXZSBt
aWdodCBub3QgaGF2ZSBhIHRpbWVzdGFtcCwgZ2V0IG9uZSAqLw0KIAlpZiAoc2tiLT50c3RhbXAu
dHY2NCA9PSAwKQ0KQEAgLTIxOCw4ICsyMTksNiBAQCBzdGF0aWMgdm9pZCBpcHRfdWxvZ19wYWNr
ZXQodW5zaWduZWQgaW50IGhvb2tudW0sDQogCQlzdHJuY3B5KHBtLT5wcmVmaXgsIHByZWZpeCwg
c2l6ZW9mKHBtLT5wcmVmaXgpKTsNCiAJZWxzZSBpZiAobG9naW5mby0+cHJlZml4WzBdICE9ICdc
MCcpDQogCQlzdHJuY3B5KHBtLT5wcmVmaXgsIGxvZ2luZm8tPnByZWZpeCwgc2l6ZW9mKHBtLT5w
cmVmaXgpKTsNCi0JZWxzZQ0KLQkJKihwbS0+cHJlZml4KSA9ICdcMCc7DQogDQogCWlmIChpbiAm
JiBpbi0+aGFyZF9oZWFkZXJfbGVuID4gMCAmJg0KIAkgICAgc2tiLT5tYWNfaGVhZGVyICE9IHNr
Yi0+bmV0d29ya19oZWFkZXIgJiYNCkBAIC0yMzEsMTMgKzIzMCw5IEBAIHN0YXRpYyB2b2lkIGlw
dF91bG9nX3BhY2tldCh1bnNpZ25lZCBpbnQgaG9va251bSwNCiANCiAJaWYgKGluKQ0KIAkJc3Ry
bmNweShwbS0+aW5kZXZfbmFtZSwgaW4tPm5hbWUsIHNpemVvZihwbS0+aW5kZXZfbmFtZSkpOw0K
LQllbHNlDQotCQlwbS0+aW5kZXZfbmFtZVswXSA9ICdcMCc7DQogDQogCWlmIChvdXQpDQogCQlz
dHJuY3B5KHBtLT5vdXRkZXZfbmFtZSwgb3V0LT5uYW1lLCBzaXplb2YocG0tPm91dGRldl9uYW1l
KSk7DQotCWVsc2UNCi0JCXBtLT5vdXRkZXZfbmFtZVswXSA9ICdcMCc7DQogDQogCS8qIGNvcHlf
bGVuIDw9IHNrYi0+bGVuLCBzbyBjYW4ndCBmYWlsLiAqLw0KIAlpZiAoc2tiX2NvcHlfYml0cyhz
a2IsIDAsIHBtLT5wYXlsb2FkLCBjb3B5X2xlbikgPCAwKQ0KZGlmZiAtLWdpdCBhL25ldC9pcHY0
L3RjcF9pbnB1dC5jIGIvbmV0L2lwdjQvdGNwX2lucHV0LmMNCmluZGV4IGMxZWQwMWUuLmFmZTY4
ODYgMTAwNjQ0DQotLS0gYS9uZXQvaXB2NC90Y3BfaW5wdXQuYw0KKysrIGIvbmV0L2lwdjQvdGNw
X2lucHV0LmMNCkBAIC0xMzA1LDcgKzEzMDUsNyBAQCBzdGF0aWMgaW50IHRjcF9tYXRjaF9za2Jf
dG9fc2FjayhzdHJ1Y3Qgc29jayAqc2ssIHN0cnVjdCBza19idWZmICpza2IsDQogCQkJdW5zaWdu
ZWQgaW50IG5ld19sZW4gPSAocGt0X2xlbiAvIG1zcykgKiBtc3M7DQogCQkJaWYgKCFpbl9zYWNr
ICYmIG5ld19sZW4gPCBwa3RfbGVuKSB7DQogCQkJCW5ld19sZW4gKz0gbXNzOw0KLQkJCQlpZiAo
bmV3X2xlbiA+IHNrYi0+bGVuKQ0KKwkJCQlpZiAobmV3X2xlbiA+PSBza2ItPmxlbikNCiAJCQkJ
CXJldHVybiAwOw0KIAkJCX0NCiAJCQlwa3RfbGVuID0gbmV3X2xlbjsNCmRpZmYgLS1naXQgYS9u
ZXQvaXB2Ni9pcDZfb3V0cHV0LmMgYi9uZXQvaXB2Ni9pcDZfb3V0cHV0LmMNCmluZGV4IDE0NzUz
ZDMuLjA2NGI1YzkgMTAwNjQ0DQotLS0gYS9uZXQvaXB2Ni9pcDZfb3V0cHV0LmMNCisrKyBiL25l
dC9pcHY2L2lwNl9vdXRwdXQuYw0KQEAgLTM4MSwxNyArMzgxLDYgQEAgc3RhdGljIGlubGluZSBp
bnQgaXA2X2ZvcndhcmRfZmluaXNoKHN0cnVjdCBza19idWZmICpza2IpDQogCXJldHVybiBkc3Rf
b3V0cHV0KHNrYik7DQogfQ0KIA0KLXN0YXRpYyBib29sIGlwNl9wa3RfdG9vX2JpZyhjb25zdCBz
dHJ1Y3Qgc2tfYnVmZiAqc2tiLCB1bnNpZ25lZCBpbnQgbXR1KQ0KLXsNCi0JaWYgKHNrYi0+bGVu
IDw9IG10dSB8fCBza2ItPmxvY2FsX2RmKQ0KLQkJcmV0dXJuIGZhbHNlOw0KLQ0KLQlpZiAoc2ti
X2lzX2dzbyhza2IpICYmIHNrYl9nc29fbmV0d29ya19zZWdsZW4oc2tiKSA8PSBtdHUpDQotCQly
ZXR1cm4gZmFsc2U7DQotDQotCXJldHVybiB0cnVlOw0KLX0NCi0NCiBpbnQgaXA2X2ZvcndhcmQo
c3RydWN0IHNrX2J1ZmYgKnNrYikNCiB7DQogCXN0cnVjdCBkc3RfZW50cnkgKmRzdCA9IHNrYl9k
c3Qoc2tiKTsNCkBAIC01MTUsNyArNTA0LDcgQEAgaW50IGlwNl9mb3J3YXJkKHN0cnVjdCBza19i
dWZmICpza2IpDQogCWlmIChtdHUgPCBJUFY2X01JTl9NVFUpDQogCQltdHUgPSBJUFY2X01JTl9N
VFU7DQogDQotCWlmIChpcDZfcGt0X3Rvb19iaWcoc2tiLCBtdHUpKSB7DQorCWlmIChza2ItPmxl
biA+IG10dSAmJiAhc2tiX2lzX2dzbyhza2IpKSB7DQogCQkvKiBBZ2FpbiwgZm9yY2UgT1VUUFVU
IGRldmljZSB1c2VkIGFzIHNvdXJjZSBhZGRyZXNzICovDQogCQlza2ItPmRldiA9IGRzdC0+ZGV2
Ow0KIAkJaWNtcHY2X3NlbmQoc2tiLCBJQ01QVjZfUEtUX1RPT0JJRywgMCwgbXR1KTsNCmRpZmYg
LS1naXQgYS9uZXQvbDJ0cC9sMnRwX3BwcC5jIGIvbmV0L2wydHAvbDJ0cF9wcHAuYw0KaW5kZXgg
ZTBmMDkzNC4uNDM3ZmI1OSAxMDA2NDQNCi0tLSBhL25ldC9sMnRwL2wydHBfcHBwLmMNCisrKyBi
L25ldC9sMnRwL2wydHBfcHBwLmMNCkBAIC0xMzUxLDcgKzEzNTEsNyBAQCBzdGF0aWMgaW50IHBw
cG9sMnRwX3NldHNvY2tvcHQoc3RydWN0IHNvY2tldCAqc29jaywgaW50IGxldmVsLCBpbnQgb3B0
bmFtZSwNCiAJaW50IGVycjsNCiANCiAJaWYgKGxldmVsICE9IFNPTF9QUFBPTDJUUCkNCi0JCXJl
dHVybiB1ZHBfcHJvdC5zZXRzb2Nrb3B0KHNrLCBsZXZlbCwgb3B0bmFtZSwgb3B0dmFsLCBvcHRs
ZW4pOw0KKwkJcmV0dXJuIC1FSU5WQUw7DQogDQogCWlmIChvcHRsZW4gPCBzaXplb2YoaW50KSkN
CiAJCXJldHVybiAtRUlOVkFMOw0KQEAgLTE0NzcsNyArMTQ3Nyw3IEBAIHN0YXRpYyBpbnQgcHBw
b2wydHBfZ2V0c29ja29wdChzdHJ1Y3Qgc29ja2V0ICpzb2NrLCBpbnQgbGV2ZWwsDQogCXN0cnVj
dCBwcHBvbDJ0cF9zZXNzaW9uICpwczsNCiANCiAJaWYgKGxldmVsICE9IFNPTF9QUFBPTDJUUCkN
Ci0JCXJldHVybiB1ZHBfcHJvdC5nZXRzb2Nrb3B0KHNrLCBsZXZlbCwgb3B0bmFtZSwgb3B0dmFs
LCBvcHRsZW4pOw0KKwkJcmV0dXJuIC1FSU5WQUw7DQogDQogCWlmIChnZXRfdXNlcihsZW4sIChp
bnQgX191c2VyICopIG9wdGxlbikpDQogCQlyZXR1cm4gLUVGQVVMVDsNCmRpZmYgLS1naXQgYS9u
ZXQvbmV0ZmlsdGVyL2lwdnMvaXBfdnNfY3RsLmMgYi9uZXQvbmV0ZmlsdGVyL2lwdnMvaXBfdnNf
Y3RsLmMNCmluZGV4IDcyZjQyNTMuLjkzYWNmYTEgMTAwNjQ0DQotLS0gYS9uZXQvbmV0ZmlsdGVy
L2lwdnMvaXBfdnNfY3RsLmMNCisrKyBiL25ldC9uZXRmaWx0ZXIvaXB2cy9pcF92c19jdGwuYw0K
QEAgLTM2ODgsNiArMzY4OCw3IEBAIHZvaWQgX19uZXRfaW5pdCBpcF92c19jb250cm9sX25ldF9j
bGVhbnVwX3N5c2N0bChzdHJ1Y3QgbmV0ICpuZXQpDQogCWNhbmNlbF9kZWxheWVkX3dvcmtfc3lu
YygmaXB2cy0+ZGVmZW5zZV93b3JrKTsNCiAJY2FuY2VsX3dvcmtfc3luYygmaXB2cy0+ZGVmZW5z
ZV93b3JrLndvcmspOw0KIAl1bnJlZ2lzdGVyX25ldF9zeXNjdGxfdGFibGUoaXB2cy0+c3lzY3Rs
X2hkcik7DQorCWlwX3ZzX3N0b3BfZXN0aW1hdG9yKG5ldCwgJmlwdnMtPnRvdF9zdGF0cyk7DQog
fQ0KIA0KICNlbHNlDQpAQCAtMzc0Myw3ICszNzQ0LDYgQEAgdm9pZCBfX25ldF9leGl0IGlwX3Zz
X2NvbnRyb2xfbmV0X2NsZWFudXAoc3RydWN0IG5ldCAqbmV0KQ0KIAlzdHJ1Y3QgbmV0bnNfaXB2
cyAqaXB2cyA9IG5ldF9pcHZzKG5ldCk7DQogDQogCWlwX3ZzX3RyYXNoX2NsZWFudXAobmV0KTsN
Ci0JaXBfdnNfc3RvcF9lc3RpbWF0b3IobmV0LCAmaXB2cy0+dG90X3N0YXRzKTsNCiAJaXBfdnNf
Y29udHJvbF9uZXRfY2xlYW51cF9zeXNjdGwobmV0KTsNCiAJcHJvY19uZXRfcmVtb3ZlKG5ldCwg
ImlwX3ZzX3N0YXRzX3BlcmNwdSIpOw0KIAlwcm9jX25ldF9yZW1vdmUobmV0LCAiaXBfdnNfc3Rh
dHMiKTsNCmRpZmYgLS1naXQgYS9uZXQvc2N0cC91bHBldmVudC5jIGIvbmV0L3NjdHAvdWxwZXZl
bnQuYw0KaW5kZXggOGE4NDAxNy4uNTdkYTQ0NyAxMDA2NDQNCi0tLSBhL25ldC9zY3RwL3VscGV2
ZW50LmMNCisrKyBiL25ldC9zY3RwL3VscGV2ZW50LmMNCkBAIC0zNzMsOSArMzczLDEwIEBAIGZh
aWw6DQogICogc3BlY2lmaWNhdGlvbiBbU0NUUF0gYW5kIGFueSBleHRlbnNpb25zIGZvciBhIGxp
c3Qgb2YgcG9zc2libGUNCiAgKiBlcnJvciBmb3JtYXRzLg0KICAqLw0KLXN0cnVjdCBzY3RwX3Vs
cGV2ZW50ICpzY3RwX3VscGV2ZW50X21ha2VfcmVtb3RlX2Vycm9yKA0KLQljb25zdCBzdHJ1Y3Qg
c2N0cF9hc3NvY2lhdGlvbiAqYXNvYywgc3RydWN0IHNjdHBfY2h1bmsgKmNodW5rLA0KLQlfX3Ux
NiBmbGFncywgZ2ZwX3QgZ2ZwKQ0KK3N0cnVjdCBzY3RwX3VscGV2ZW50ICoNCitzY3RwX3VscGV2
ZW50X21ha2VfcmVtb3RlX2Vycm9yKGNvbnN0IHN0cnVjdCBzY3RwX2Fzc29jaWF0aW9uICphc29j
LA0KKwkJCQlzdHJ1Y3Qgc2N0cF9jaHVuayAqY2h1bmssIF9fdTE2IGZsYWdzLA0KKwkJCQlnZnBf
dCBnZnApDQogew0KIAlzdHJ1Y3Qgc2N0cF91bHBldmVudCAqZXZlbnQ7DQogCXN0cnVjdCBzY3Rw
X3JlbW90ZV9lcnJvciAqc3JlOw0KQEAgLTM5NCw4ICszOTUsNyBAQCBzdHJ1Y3Qgc2N0cF91bHBl
dmVudCAqc2N0cF91bHBldmVudF9tYWtlX3JlbW90ZV9lcnJvcigNCiAJLyogQ29weSB0aGUgc2ti
IHRvIGEgbmV3IHNrYiB3aXRoIHJvb20gZm9yIHVzIHRvIHByZXBlbmQNCiAJICogbm90aWZpY2F0
aW9uIHdpdGguDQogCSAqLw0KLQlza2IgPSBza2JfY29weV9leHBhbmQoY2h1bmstPnNrYiwgc2l6
ZW9mKHN0cnVjdCBzY3RwX3JlbW90ZV9lcnJvciksDQotCQkJICAgICAgMCwgZ2ZwKTsNCisJc2ti
ID0gc2tiX2NvcHlfZXhwYW5kKGNodW5rLT5za2IsIHNpemVvZigqc3JlKSwgMCwgZ2ZwKTsNCiAN
CiAJLyogUHVsbCBvZmYgdGhlIHJlc3Qgb2YgdGhlIGNhdXNlIFRMViBmcm9tIHRoZSBjaHVuay4g
ICovDQogCXNrYl9wdWxsKGNodW5rLT5za2IsIGVsZW4pOw0KQEAgLTQwNiw2MiArNDA2LDIxIEBA
IHN0cnVjdCBzY3RwX3VscGV2ZW50ICpzY3RwX3VscGV2ZW50X21ha2VfcmVtb3RlX2Vycm9yKA0K
IAlldmVudCA9IHNjdHBfc2tiMmV2ZW50KHNrYik7DQogCXNjdHBfdWxwZXZlbnRfaW5pdChldmVu
dCwgTVNHX05PVElGSUNBVElPTiwgc2tiLT50cnVlc2l6ZSk7DQogDQotCXNyZSA9IChzdHJ1Y3Qg
c2N0cF9yZW1vdGVfZXJyb3IgKikNCi0JCXNrYl9wdXNoKHNrYiwgc2l6ZW9mKHN0cnVjdCBzY3Rw
X3JlbW90ZV9lcnJvcikpOw0KKwlzcmUgPSAoc3RydWN0IHNjdHBfcmVtb3RlX2Vycm9yICopIHNr
Yl9wdXNoKHNrYiwgc2l6ZW9mKCpzcmUpKTsNCiANCiAJLyogVHJpbSB0aGUgYnVmZmVyIHRvIHRo
ZSByaWdodCBsZW5ndGguICAqLw0KLQlza2JfdHJpbShza2IsIHNpemVvZihzdHJ1Y3Qgc2N0cF9y
ZW1vdGVfZXJyb3IpICsgZWxlbik7DQorCXNrYl90cmltKHNrYiwgc2l6ZW9mKCpzcmUpICsgZWxl
bik7DQogDQotCS8qIFNvY2tldCBFeHRlbnNpb25zIGZvciBTQ1RQDQotCSAqIDUuMy4xLjMgU0NU
UF9SRU1PVEVfRVJST1INCi0JICoNCi0JICogc3JlX3R5cGU6DQotCSAqICAgSXQgc2hvdWxkIGJl
IFNDVFBfUkVNT1RFX0VSUk9SLg0KLQkgKi8NCisJLyogUkZDNjQ1OCwgU2VjdGlvbiA2LjEuMy4g
U0NUUF9SRU1PVEVfRVJST1IgKi8NCisJbWVtc2V0KHNyZSwgMCwgc2l6ZW9mKCpzcmUpKTsNCiAJ
c3JlLT5zcmVfdHlwZSA9IFNDVFBfUkVNT1RFX0VSUk9SOw0KLQ0KLQkvKg0KLQkgKiBTb2NrZXQg
RXh0ZW5zaW9ucyBmb3IgU0NUUA0KLQkgKiA1LjMuMS4zIFNDVFBfUkVNT1RFX0VSUk9SDQotCSAq
DQotCSAqIHNyZV9mbGFnczogMTYgYml0cyAodW5zaWduZWQgaW50ZWdlcikNCi0JICogICBDdXJy
ZW50bHkgdW51c2VkLg0KLQkgKi8NCiAJc3JlLT5zcmVfZmxhZ3MgPSAwOw0KLQ0KLQkvKiBTb2Nr
ZXQgRXh0ZW5zaW9ucyBmb3IgU0NUUA0KLQkgKiA1LjMuMS4zIFNDVFBfUkVNT1RFX0VSUk9SDQot
CSAqDQotCSAqIHNyZV9sZW5ndGg6IHNpemVvZiAoX191MzIpDQotCSAqDQotCSAqIFRoaXMgZmll
bGQgaXMgdGhlIHRvdGFsIGxlbmd0aCBvZiB0aGUgbm90aWZpY2F0aW9uIGRhdGEsDQotCSAqIGlu
Y2x1ZGluZyB0aGUgbm90aWZpY2F0aW9uIGhlYWRlci4NCi0JICovDQogCXNyZS0+c3JlX2xlbmd0
aCA9IHNrYi0+bGVuOw0KLQ0KLQkvKiBTb2NrZXQgRXh0ZW5zaW9ucyBmb3IgU0NUUA0KLQkgKiA1
LjMuMS4zIFNDVFBfUkVNT1RFX0VSUk9SDQotCSAqDQotCSAqIHNyZV9lcnJvcjogMTYgYml0cyAo
dW5zaWduZWQgaW50ZWdlcikNCi0JICogVGhpcyB2YWx1ZSByZXByZXNlbnRzIG9uZSBvZiB0aGUg
T3BlcmF0aW9uYWwgRXJyb3IgY2F1c2VzIGRlZmluZWQgaW4NCi0JICogdGhlIFNDVFAgc3BlY2lm
aWNhdGlvbiwgaW4gbmV0d29yayBieXRlIG9yZGVyLg0KLQkgKi8NCiAJc3JlLT5zcmVfZXJyb3Ig
PSBjYXVzZTsNCi0NCi0JLyogU29ja2V0IEV4dGVuc2lvbnMgZm9yIFNDVFANCi0JICogNS4zLjEu
MyBTQ1RQX1JFTU9URV9FUlJPUg0KLQkgKg0KLQkgKiBzcmVfYXNzb2NfaWQ6IHNpemVvZiAoc2N0
cF9hc3NvY190KQ0KLQkgKg0KLQkgKiBUaGUgYXNzb2NpYXRpb24gaWQgZmllbGQsIGhvbGRzIHRo
ZSBpZGVudGlmaWVyIGZvciB0aGUgYXNzb2NpYXRpb24uDQotCSAqIEFsbCBub3RpZmljYXRpb25z
IGZvciBhIGdpdmVuIGFzc29jaWF0aW9uIGhhdmUgdGhlIHNhbWUgYXNzb2NpYXRpb24NCi0JICog
aWRlbnRpZmllci4gIEZvciBUQ1Agc3R5bGUgc29ja2V0LCB0aGlzIGZpZWxkIGlzIGlnbm9yZWQu
DQotCSAqLw0KIAlzY3RwX3VscGV2ZW50X3NldF9vd25lcihldmVudCwgYXNvYyk7DQogCXNyZS0+
c3JlX2Fzc29jX2lkID0gc2N0cF9hc3NvYzJpZChhc29jKTsNCiANCiAJcmV0dXJuIGV2ZW50Ow0K
LQ0KIGZhaWw6DQogCXJldHVybiBOVUxMOw0KIH0NCkBAIC05MDQsNyArODYzLDkgQEAgX191MTYg
c2N0cF91bHBldmVudF9nZXRfbm90aWZpY2F0aW9uX3R5cGUoY29uc3Qgc3RydWN0IHNjdHBfdWxw
ZXZlbnQgKmV2ZW50KQ0KIAlyZXR1cm4gbm90aWZpY2F0aW9uLT5zbl9oZWFkZXIuc25fdHlwZTsN
CiB9DQogDQotLyogQ29weSBvdXQgdGhlIHNuZHJjdmluZm8gaW50byBhIG1zZ2hkci4gICovDQor
LyogUkZDNjQ1OCwgU2VjdGlvbiA1LjMuMi4gU0NUUCBIZWFkZXIgSW5mb3JtYXRpb24gU3RydWN0
dXJlDQorICogKFNDVFBfU05EUkNWLCBERVBSRUNBVEVEKQ0KKyAqLw0KIHZvaWQgc2N0cF91bHBl
dmVudF9yZWFkX3NuZHJjdmluZm8oY29uc3Qgc3RydWN0IHNjdHBfdWxwZXZlbnQgKmV2ZW50LA0K
IAkJCQkgICBzdHJ1Y3QgbXNnaGRyICptc2doZHIpDQogew0KQEAgLTkxMyw3NCArODc0LDIxIEBA
IHZvaWQgc2N0cF91bHBldmVudF9yZWFkX3NuZHJjdmluZm8oY29uc3Qgc3RydWN0IHNjdHBfdWxw
ZXZlbnQgKmV2ZW50LA0KIAlpZiAoc2N0cF91bHBldmVudF9pc19ub3RpZmljYXRpb24oZXZlbnQp
KQ0KIAkJcmV0dXJuOw0KIA0KLQkvKiBTb2NrZXRzIEFQSSBFeHRlbnNpb25zIGZvciBTQ1RQDQot
CSAqIFNlY3Rpb24gNS4yLjIgU0NUUCBIZWFkZXIgSW5mb3JtYXRpb24gU3RydWN0dXJlIChTQ1RQ
X1NORFJDVikNCi0JICoNCi0JICogc2luZm9fc3RyZWFtOiAxNiBiaXRzICh1bnNpZ25lZCBpbnRl
Z2VyKQ0KLQkgKg0KLQkgKiBGb3IgcmVjdm1zZygpIHRoZSBTQ1RQIHN0YWNrIHBsYWNlcyB0aGUg
bWVzc2FnZSdzIHN0cmVhbSBudW1iZXIgaW4NCi0JICogdGhpcyB2YWx1ZS4NCi0JKi8NCisJbWVt
c2V0KCZzaW5mbywgMCwgc2l6ZW9mKHNpbmZvKSk7DQogCXNpbmZvLnNpbmZvX3N0cmVhbSA9IGV2
ZW50LT5zdHJlYW07DQotCS8qIHNpbmZvX3NzbjogMTYgYml0cyAodW5zaWduZWQgaW50ZWdlcikN
Ci0JICoNCi0JICogRm9yIHJlY3Ztc2coKSB0aGlzIHZhbHVlIGNvbnRhaW5zIHRoZSBzdHJlYW0g
c2VxdWVuY2UgbnVtYmVyIHRoYXQNCi0JICogdGhlIHJlbW90ZSBlbmRwb2ludCBwbGFjZWQgaW4g
dGhlIERBVEEgY2h1bmsuICBGb3IgZnJhZ21lbnRlZA0KLQkgKiBtZXNzYWdlcyB0aGlzIGlzIHRo
ZSBzYW1lIG51bWJlciBmb3IgYWxsIGRlbGl2ZXJpZXMgb2YgdGhlIG1lc3NhZ2UNCi0JICogKGlm
IG1vcmUgdGhhbiBvbmUgcmVjdm1zZygpIGlzIG5lZWRlZCB0byByZWFkIHRoZSBtZXNzYWdlKS4N
Ci0JICovDQogCXNpbmZvLnNpbmZvX3NzbiA9IGV2ZW50LT5zc247DQotCS8qIHNpbmZvX3BwaWQ6
IDMyIGJpdHMgKHVuc2lnbmVkIGludGVnZXIpDQotCSAqDQotCSAqIEluIHJlY3Ztc2coKSB0aGlz
IHZhbHVlIGlzDQotCSAqIHRoZSBzYW1lIGluZm9ybWF0aW9uIHRoYXQgd2FzIHBhc3NlZCBieSB0
aGUgdXBwZXIgbGF5ZXIgaW4gdGhlIHBlZXINCi0JICogYXBwbGljYXRpb24uICBQbGVhc2Ugbm90
ZSB0aGF0IGJ5dGUgb3JkZXIgaXNzdWVzIGFyZSBOT1QgYWNjb3VudGVkDQotCSAqIGZvciBhbmQg
dGhpcyBpbmZvcm1hdGlvbiBpcyBwYXNzZWQgb3BhcXVlbHkgYnkgdGhlIFNDVFAgc3RhY2sgZnJv
bQ0KLQkgKiBvbmUgZW5kIHRvIHRoZSBvdGhlci4NCi0JICovDQogCXNpbmZvLnNpbmZvX3BwaWQg
PSBldmVudC0+cHBpZDsNCi0JLyogc2luZm9fZmxhZ3M6IDE2IGJpdHMgKHVuc2lnbmVkIGludGVn
ZXIpDQotCSAqDQotCSAqIFRoaXMgZmllbGQgbWF5IGNvbnRhaW4gYW55IG9mIHRoZSBmb2xsb3dp
bmcgZmxhZ3MgYW5kIGlzIGNvbXBvc2VkIG9mDQotCSAqIGEgYml0d2lzZSBPUiBvZiB0aGVzZSB2
YWx1ZXMuDQotCSAqDQotCSAqIHJlY3Ztc2coKSBmbGFnczoNCi0JICoNCi0JICogU0NUUF9VTk9S
REVSRUQgLSBUaGlzIGZsYWcgaXMgcHJlc2VudCB3aGVuIHRoZSBtZXNzYWdlIHdhcyBzZW50DQot
CSAqICAgICAgICAgICAgICAgICBub24tb3JkZXJlZC4NCi0JICovDQogCXNpbmZvLnNpbmZvX2Zs
YWdzID0gZXZlbnQtPmZsYWdzOw0KLQkvKiBzaW5mb190c246IDMyIGJpdCAodW5zaWduZWQgaW50
ZWdlcikNCi0JICoNCi0JICogRm9yIHRoZSByZWNlaXZpbmcgc2lkZSwgdGhpcyBmaWVsZCBob2xk
cyBhIFRTTiB0aGF0IHdhcw0KLQkgKiBhc3NpZ25lZCB0byBvbmUgb2YgdGhlIFNDVFAgRGF0YSBD
aHVua3MuDQotCSAqLw0KIAlzaW5mby5zaW5mb190c24gPSBldmVudC0+dHNuOw0KLQkvKiBzaW5m
b19jdW10c246IDMyIGJpdCAodW5zaWduZWQgaW50ZWdlcikNCi0JICoNCi0JICogVGhpcyBmaWVs
ZCB3aWxsIGhvbGQgdGhlIGN1cnJlbnQgY3VtdWxhdGl2ZSBUU04gYXMNCi0JICoga25vd24gYnkg
dGhlIHVuZGVybHlpbmcgU0NUUCBsYXllci4gIE5vdGUgdGhpcyBmaWVsZCBpcw0KLQkgKiBpZ25v
cmVkIHdoZW4gc2VuZGluZyBhbmQgb25seSB2YWxpZCBmb3IgYSByZWNlaXZlDQotCSAqIG9wZXJh
dGlvbiB3aGVuIHNpbmZvX2ZsYWdzIGFyZSBzZXQgdG8gU0NUUF9VTk9SREVSRUQuDQotCSAqLw0K
IAlzaW5mby5zaW5mb19jdW10c24gPSBldmVudC0+Y3VtdHNuOw0KLQkvKiBzaW5mb19hc3NvY19p
ZDogc2l6ZW9mIChzY3RwX2Fzc29jX3QpDQotCSAqDQotCSAqIFRoZSBhc3NvY2lhdGlvbiBoYW5k
bGUgZmllbGQsIHNpbmZvX2Fzc29jX2lkLCBob2xkcyB0aGUgaWRlbnRpZmllcg0KLQkgKiBmb3Ig
dGhlIGFzc29jaWF0aW9uIGFubm91bmNlZCBpbiB0aGUgQ09NTVVOSUNBVElPTl9VUCBub3RpZmlj
YXRpb24uDQotCSAqIEFsbCBub3RpZmljYXRpb25zIGZvciBhIGdpdmVuIGFzc29jaWF0aW9uIGhh
dmUgdGhlIHNhbWUgaWRlbnRpZmllci4NCi0JICogSWdub3JlZCBmb3Igb25lLXRvLW9uZSBzdHls
ZSBzb2NrZXRzLg0KLQkgKi8NCiAJc2luZm8uc2luZm9fYXNzb2NfaWQgPSBzY3RwX2Fzc29jMmlk
KGV2ZW50LT5hc29jKTsNCi0NCi0JLyogY29udGV4dCB2YWx1ZSB0aGF0IGlzIHNldCB2aWEgU0NU
UF9DT05URVhUIHNvY2tldCBvcHRpb24uICovDQorCS8qIENvbnRleHQgdmFsdWUgdGhhdCBpcyBz
ZXQgdmlhIFNDVFBfQ09OVEVYVCBzb2NrZXQgb3B0aW9uLiAqLw0KIAlzaW5mby5zaW5mb19jb250
ZXh0ID0gZXZlbnQtPmFzb2MtPmRlZmF1bHRfcmN2X2NvbnRleHQ7DQotDQogCS8qIFRoZXNlIGZp
ZWxkcyBhcmUgbm90IHVzZWQgd2hpbGUgcmVjZWl2aW5nLiAqLw0KIAlzaW5mby5zaW5mb190aW1l
dG9saXZlID0gMDsNCiANCiAJcHV0X2Ntc2cobXNnaGRyLCBJUFBST1RPX1NDVFAsIFNDVFBfU05E
UkNWLA0KLQkJIHNpemVvZihzdHJ1Y3Qgc2N0cF9zbmRyY3ZpbmZvKSwgKHZvaWQgKikmc2luZm8p
Ow0KKwkJIHNpemVvZihzaW5mbyksICZzaW5mbyk7DQogfQ0KIA0KIC8qIERvIGFjY291bnRpbmcg
Zm9yIGJ5dGVzIHJlY2VpdmVkIGFuZCBob2xkIGEgcmVmZXJlbmNlIHRvIHRoZSBhc3NvY2lhdGlv
bg0KZGlmZiAtLWdpdCBhL3Rvb2xzL3VzYi9mZnMtdGVzdC5jIGIvdG9vbHMvdXNiL2Zmcy10ZXN0
LmMNCmluZGV4IGYxN2RmZWUuLjcyNmFmMjcgMTAwNjQ0DQotLS0gYS90b29scy91c2IvZmZzLXRl
c3QuYw0KKysrIGIvdG9vbHMvdXNiL2Zmcy10ZXN0LmMNCkBAIC0xNDMsOCArMTQzLDggQEAgc3Rh
dGljIGNvbnN0IHN0cnVjdCB7DQogCS5oZWFkZXIgPSB7DQogCQkubWFnaWMgPSBjcHVfdG9fbGUz
MihGVU5DVElPTkZTX0RFU0NSSVBUT1JTX01BR0lDKSwNCiAJCS5sZW5ndGggPSBjcHVfdG9fbGUz
MihzaXplb2YgZGVzY3JpcHRvcnMpLA0KLQkJLmZzX2NvdW50ID0gMywNCi0JCS5oc19jb3VudCA9
IDMsDQorCQkuZnNfY291bnQgPSBjcHVfdG9fbGUzMigzKSwNCisJCS5oc19jb3VudCA9IGNwdV90
b19sZTMyKDMpLA0KIAl9LA0KIAkuZnNfZGVzY3MgPSB7DQogCQkuaW50ZiA9IHsNCn==


--=-nXWv+QdUu+vuaUfRk/E6--

--=-qYPgyrRhLFN9kiOoilNk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUAU+LQsee/yOyVhhEJAQpfiA//Vi/BZKLoFQlYKACWJLun2TJ4HPOKmBg8
fFSBnH1DEGjkl3FajPmdOSt7fPRCmAyrHewxjlpxE3h4AcutFL8wf0yi4aRIWiuf
aI2FegAdGV++lXyEUj9eNkQRrX2Uy6mhKMTr4VffJatRIlhy9c+rOSiat+8LXmbC
MJ/nxkIvkyUlhFnqTqHYSmOOesemBjY0XGLpQ9VAPN+9DywD+Olvk5pGP4IiMeoz
F/OeicDBjZVxHymhQ/vfKfOt85fDJDWrEa16AFz6euQkXlX5aFI9cF6q5+m+JSTK
YP1drdskH5EUUjWgH+t7w+Q3638jqtintMaZgmRlj7JqSLZV2CwYP8Y6jaAl8XW3
yGsTzBmeUF3zHp82KjHOVSLzdIC4Y9GTQkq1N3lPMTBafxSLpNS+3H+0k18oiel6
xWPVLPJsjqvrv1IqGTVazh8YrKrRLd78dfye6PkHW/PoQmgzylQjgdsEprxaYTkn
FkxZhVRCsXh26S1ZP7kkGkRJRjr2tfESw9qzxa5AThf96/LCOizqZWITfHv8LljB
yRQIG2rcPcDNMf93Yv0Q3dLTEOLOCtmNVO6ibuSuQrbgSPuadYZ7vS7l3PkCcsMg
JPnCW7hLISJFEzhX+KeEU27gLIRlSZICMCIJF4BFmHV0yr195HXonfA7wBioQ+xs
2cKaBVwyXbM=
=XD8v
-----END PGP SIGNATURE-----

--=-qYPgyrRhLFN9kiOoilNk--
