Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751624AbaKEVxS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 16:53:18 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55305 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751369AbaKEVxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 16:53:13 -0500
Message-ID: <1415224382.3398.29.camel@decadent.org.uk>
Subject: Linux 3.2.64
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, Jiri Slaby <jslaby@suse.cz>,
        stable@vger.kernel.org
Cc: lwn@lwn.net
Date: Wed, 05 Nov 2014 21:53:02 +0000
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-M+t7YeB7YcE5JKsyaoKS"
X-Mailer: Evolution 3.12.7-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-M+t7YeB7YcE5JKsyaoKS
Content-Type: multipart/mixed; boundary="=-LDxpUjsUTQ+DLiwPZQa0"


--=-LDxpUjsUTQ+DLiwPZQa0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.2.64 kernel.

All users of the 3.2 kernel series should upgrade.

The updated 3.2.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.2.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git

The diff from 3.2.63 is attached to this message.

Ben.

------------

 Makefile                                       |   2 +-
 arch/arm/mm/alignment.c                        |   3 +
 arch/mips/boot/compressed/decompress.c         |   1 +
 arch/mips/kernel/mcount.S                      |  12 ++
 arch/mips/mm/c-r4k.c                           |   2 +
 arch/parisc/Makefile                           |   7 +-
 arch/s390/kvm/kvm-s390.c                       |  10 -
 arch/x86/include/asm/kvm_host.h                |  14 ++
 arch/x86/include/asm/vmx.h                     |   2 +
 arch/x86/kernel/smpboot.c                      |   3 +
 arch/x86/kvm/emulate.c                         | 253 +++++++++++++++++----=
---
 arch/x86/kvm/i8254.c                           |   2 +
 arch/x86/kvm/svm.c                             |   2 +-
 arch/x86/kvm/vmx.c                             |  38 +++-
 arch/x86/kvm/x86.c                             |  27 ++-
 block/genhd.c                                  |  20 +-
 drivers/acpi/processor_idle.c                  |   4 +-
 drivers/ata/ahci.c                             |  10 +
 drivers/ata/ata_piix.c                         |   8 +
 drivers/base/regmap/regmap.c                   |   7 +-
 drivers/gpu/drm/i915/intel_bios.c              |   2 +-
 drivers/gpu/drm/i915/intel_lvds.c              |   2 +-
 drivers/gpu/drm/radeon/radeon_atombios.c       |   7 +
 drivers/gpu/drm/vmwgfx/vmwgfx_fifo.c           |   3 +-
 drivers/input/mouse/elantech.c                 |   7 +
 drivers/input/mouse/synaptics.c                |  68 +++++--
 drivers/input/mouse/synaptics.h                |  11 ++
 drivers/input/serio/i8042-x86ia64io.h          |  15 ++
 drivers/input/serio/serport.c                  |  45 ++++-
 drivers/md/dm-crypt.c                          |  20 +-
 drivers/net/can/at91_can.c                     |   8 +-
 drivers/net/can/flexcan.c                      |  41 +++-
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c    |  13 ++
 drivers/net/wireless/rtlwifi/rtl8192cu/sw.c    |   1 +
 drivers/scsi/libiscsi.c                        |  10 +
 drivers/target/iscsi/iscsi_target.c            |   4 +-
 drivers/target/iscsi/iscsi_target_parameters.c |   2 +-
 drivers/usb/core/hub.c                         |   4 +-
 drivers/usb/dwc3/core.c                        |   6 +-
 drivers/usb/host/xhci-hub.c                    |   8 +-
 drivers/usb/host/xhci-mem.c                    |   2 +-
 drivers/usb/serial/ftdi_sio.c                  |   3 +
 drivers/usb/serial/ftdi_sio_ids.h              |  12 ++
 drivers/usb/serial/sierra.c                    |   9 +-
 drivers/usb/storage/unusual_devs.h             |  38 ++++
 drivers/uwb/lc-dev.c                           |  13 +-
 drivers/xen/manage.c                           |   7 -
 fs/aio.c                                       |   7 +
 fs/buffer.c                                    |   6 +-
 fs/ext2/inode.c                                |   2 +
 fs/ext2/xip.c                                  |   1 +
 fs/ext4/mballoc.c                              |   5 +
 fs/namei.c                                     |  71 +++----
 fs/nfs/nfs4proc.c                              |  30 +--
 fs/nfsd/vfs.c                                  |   3 +
 fs/nilfs2/inode.c                              |   7 +-
 fs/ocfs2/dlm/dlmmaster.c                       |  18 +-
 fs/partitions/check.c                          |   2 +-
 include/linux/alarmtimer.h                     |   1 +
 include/linux/ceph/messenger.h                 |   2 +-
 include/linux/jiffies.h                        |  12 --
 include/net/regulatory.h                       |   2 +-
 include/net/sctp/sctp.h                        |   5 +
 include/net/sctp/sm.h                          |   6 +-
 init/Kconfig                                   |   1 +
 kernel/cgroup.c                                |   5 +
 kernel/events/core.c                           |  14 +-
 kernel/fork.c                                  |   5 +-
 kernel/futex.c                                 |   1 +
 kernel/time.c                                  |  54 +++---
 kernel/time/alarmtimer.c                       |  40 ++--
 kernel/trace/ring_buffer.c                     |   2 +-
 mm/migrate.c                                   |   5 +-
 mm/percpu-vm.c                                 |  22 ++-
 mm/percpu.c                                    |   2 +
 mm/shmem.c                                     |   4 +-
 net/ceph/auth_x.c                              | 256 +++++++++++++--------=
----
 net/ceph/messenger.c                           |   6 +-
 net/ceph/mon_client.c                          |  16 +-
 net/ipv4/route.c                               |  58 ++++--
 net/ipv6/addrconf.c                            |  14 +-
 net/ipv6/udp.c                                 |   2 +-
 net/l2tp/l2tp_ppp.c                            |   3 +-
 net/netfilter/ipvs/ip_vs_conn.c                |   1 -
 net/sctp/associola.c                           |   2 +
 net/sctp/inqueue.c                             |  33 +---
 net/sctp/sm_make_chunk.c                       |  99 +++++-----
 net/sctp/sm_statefuns.c                        |  21 +-
 net/wireless/nl80211.c                         |   6 +
 sound/core/pcm_lib.c                           |   8 +-
 sound/pci/hda/patch_realtek.c                  |   2 +
 91 files changed, 1130 insertions(+), 520 deletions(-)

Al Viro (2):
      don't bugger nd->seq on set_root_rcu() from follow_dotdot_rcu()
      be careful with nd->inode in path_init() and follow_dotdot_rcu()

Alban Crequy (1):
      cgroup: reject cgroup names with '     '

Alex Deucher (1):
      drm/radeon: add connector quirk for fujitsu board

Andreas Rohner (1):
      nilfs2: fix data loss with mmap()

Andrew Hunter (1):
      jiffies: Fix timeval conversion to jiffies

Andy Honig (1):
      KVM: x86: Improve thread safety in pit

Andy Lutomirski (1):
      x86,kvm,vmx: Preserve CR4 across VM entry

Anton Altaparmakov (1):
      Fix nasty 32-bit overflow bug in buffer i/o code.

Aurelien Jarno (1):
      MIPS: ZBOOT: add missing <linux/string.h> include

Ben Hutchings (2):
      vfs: Fold follow_mount_rcu() into follow_dotdot_rcu()
      Linux 3.2.64

Bj=C3=B8rn Mork (2):
      USB: sierra: avoid CDC class functions on "68A3" devices
      USB: sierra: add 1199:68AA device ID

Christian Borntraeger (1):
      KVM: s390: Fix user triggerable bug in dead code

Clemens Ladisch (1):
      ALSA: pcm: fix fifo_size frame calculation

Cong Wang (1):
      perf: Fix a race condition in perf_remove_from_context()

Daniel Borkmann (3):
      net: sctp: fix skb_over_panic when receiving malformed ASCONF chunks
      net: sctp: fix panic on duplicate ASCONF chunks
      net: sctp: fix remote memory pressure from excessive queueing

David Dueck (1):
      can: at91_can: add missing prepare and unprepare of the clock

David Jander (2):
      can: flexcan: correctly initialize mailboxes
      can: flexcan: implement workaround for errata ERR005829

Dmitry Torokhov (1):
      Input: synaptics - add support for ForcePads

Eliad Peller (1):
      regulatory: add NUL to alpha2

Emmanuel Grumbach (1):
      Revert "iwlwifi: dvm: don't enable CTS to self"

Felipe Balbi (3):
      usb: dwc3: core: use pm_runtime_put_sync() on remove
      usb: dwc3: core: fix order of PM runtime calls
      usb: host: xhci: fix compliance mode workaround

Guillaume Nault (1):
      l2tp: fix race while getting PMTU on PPP pseudo-wire

Hannes Frederic Sowa (1):
      ipv6: reuse ip6_frag_id from ip6_ufo_append_data

Hans de Goede (3):
      Input: elantech - fix detection of touchpad on ASUS s301l
      Input: i8042 - add Fujitsu U574 to no_timeout dmi table
      Input: i8042 - add nomux quirk for Avatar AVIU-145A6

Honggang Li (1):
      percpu: free percpu allocation info for uniprocessor system

Ilya Dryomov (3):
      libceph: rename ceph_msg::front_max to front_alloc_len
      libceph: add process_one_ticket() helper
      libceph: do not hard code max auth ticket len

James Ralston (2):
      ahci: Add Device IDs for Intel 9 Series PCH
      ata_piix: Add Device IDs for Intel 9 Series PCH

Jan Kara (1):
      ext2: Fix fs corruption in ext2_get_xip_mem()

Jeff Moyer (1):
      aio: add missing smp_rmb() in read_events_ring

Jens Axboe (1):
      genhd: fix leftover might_sleep() in blk_free_devt()

Jiri Kosina (1):
      ACPI / cpuidle: fix deadlock between cpuidle_lock and cpu_hotplug.loc=
k

Joe Lawrence (1):
      usb: hub: take hub->hdev reference when processing from eventlist

Joern Engel (1):
      iscsi-target: avoid NULL pointer in iscsi_copy_param_list failure

Johan Hovold (1):
      USB: ftdi_sio: add support for NOVITUS Bono E thermal printer

Johannes Berg (1):
      nl80211: clear skb cb before passing to netlink

John David Anglin (1):
      parisc: Only use -mfast-indirect-calls option for 32-bit kernel build=
s

John Sung (1):
      Input: serport - add compat handling for SPIOCSTYPE ioctl

Joseph Qi (1):
      ocfs2/dlm: do not get resource spinlock if lockres is new

Josh Triplett (1):
      init/Kconfig: Hide printk log config if CONFIG_PRINTK=3Dn

Julian Anastasov (1):
      ipvs: avoid netns exit crash on ip_vs_conn_drop_conntrack

Keith Busch (1):
      block: Fix dev_t minor allocation lifetime

Larry Finger (1):
      rtlwifi: rtl8192cu: Add new ID

Marc Kleine-Budde (2):
      can: flexcan: mark TX mailbox as TX_INACTIVE
      can: flexcan: put TX mailbox into TX_INACTIVE mode after tx-complete

Marcelo Ricardo Leitner (3):
      ipv4: move route garbage collector to work queue
      ipv4: avoid parallel route cache gc executions
      ipv4: disable bh while doing route gc

Mark (4):
      storage: Add single-LUN quirk for Jaz USB Adapter
      USB: storage: Add quirk for Adaptec USBConnect 2000 USB-to-SCSI Adapt=
er
      USB: storage: Add quirk for Ariston Technologies iConnect USB to SCSI=
 adapter
      USB: storage: Add quirks for Entrega/Xircom USB to SCSI converters

Mark Brown (1):
      regmap: Fix handling of volatile registers for format_write() chips

Markos Chandras (1):
      MIPS: mcount: Adjust stack pointer for static trace in MIPS32

Mathias Krause (1):
      drm/i915: Remove bogus __init annotation from DMI callbacks

Mathias Nyman (1):
      xhci: Fix null pointer dereference if xhci initialization fails

Mel Gorman (1):
      mm: migrate: Close race between migration completion and mprotect

Mike Christie (1):
      libiscsi: fix potential buffer overrun in __iscsi_conn_send_pdu

Miklos Szeredi (1):
      shmem: fix nlink for rename overwrite directory

Mikulas Patocka (1):
      dm crypt: fix access beyond the end of allocated space

Murali Karicheri (1):
      ahci: add pcid for Marvel 0x9182 controller

Nadav Amit (5):
      KVM: x86: Check non-canonical addresses upon WRMSR
      KVM: x86: Fix wrong masking on relative jump/call
      KVM: x86: Emulator fixes for eip canonical checks on near branches
      KVM: x86: Handle errors when RIP is set during far jumps
      KVM: x86: Fix far-jump to non-canonical check

Nadav Har'El (1):
      nEPT: Nested INVEPT

Nicholas Bellinger (1):
      iscsi-target: Fix memory corruption in iscsit_logout_post_handler_dif=
fcid

Paolo Bonzini (1):
      KVM: x86: use new CS.RPL as CPL during task switch

Peter Zijlstra (1):
      perf: fix perf bug in fork()

Petr Matousek (1):
      kvm: vmx: handle invvpid vm exit gracefully

Richard Larocque (3):
      alarmtimer: Return relative times in timer_gettime
      alarmtimer: Do not signal SIGEV_NONE timers
      alarmtimer: Lock k_itimer during timer callback

Robin Murphy (1):
      ARM: 8165/1: alignment: don't break misaligned NEON load/store

Ross Lagerwall (1):
      xen/manage: Always freeze/thaw processes when suspend/resuming

Sage Weil (1):
      libceph: gracefully handle large reply messages from the mon

Sergio Gelato (1):
      nfsd: Fix ACL null pointer deref

Steven Rostedt (Red Hat) (1):
      ring-buffer: Fix infinite spin in reading buffer

Takashi Iwai (1):
      ALSA: hda - Fix COEF setups for ALC1150 codec

Takuya Yoshikawa (1):
      KVM: x86 emulator: Use opcode::execute for CALL

Taylor Braun-Jones (1):
      USB: ftdi_sio: Add support for GE Healthcare Nemo Tracker device

Tejun Heo (2):
      percpu: fix pcpu_alloc_pages() failure path
      percpu: perform tlb flush after pcpu_map_pages() failure

Theodore Ts'o (1):
      ext4: fix BUG_ON in mb_free_blocks()

Thomas Gleixner (1):
      futex: Unlock hb->lock in futex_wait_requeue_pi() error path

Thomas Hellstrom (1):
      drm/vmwgfx: Fix a potential infinite spin waiting for fifo idle

Thomas Pugliese (1):
      uwb: init beacon cache entry before registering uwb device

Trond Myklebust (1):
      NFSv4: Fix another bug in the close/open_downgrade code

Wanpeng Li (1):
      sched: Fix unreleased llc_shared_mask bit during CPU hotplug

Wolfram Sang (1):
      regmap: if format_write is used, declare all registers as "unreadable=
"

Yoichi Yuasa (1):
      MIPS: Fix forgotten preempt_enable() when CPU has inclusive pcaches

chenweilong (1):
      ipv6: reallocate addrconf router for ipv6 address when lo device up


--=20
Ben Hutchings
The program is absolutely right; therefore, the computer must be wrong.

--=-LDxpUjsUTQ+DLiwPZQa0
Content-Type: text/x-diff; charset="UTF-8"; name="linux-3.2.64.patch"
Content-Disposition: attachment; filename="linux-3.2.64.patch"
Content-Transfer-Encoding: quoted-printable

diff --git a/Makefile b/Makefile
index 6d3f2d4..2b58ffc 100644
--- a/Makefile
+++ b/Makefile
@@ -1,6 +1,6 @@
 VERSION =3D 3
 PATCHLEVEL =3D 2
-SUBLEVEL =3D 63
+SUBLEVEL =3D 64
 EXTRAVERSION =3D
 NAME =3D Saber-toothed Squirrel
=20
diff --git a/arch/arm/mm/alignment.c b/arch/arm/mm/alignment.c
index a125c4b..6e39bf1 100644
--- a/arch/arm/mm/alignment.c
+++ b/arch/arm/mm/alignment.c
@@ -38,6 +38,7 @@
  * This code is not portable to processors with late data abort handling.
  */
 #define CODING_BITS(i)	(i & 0x0e000000)
+#define COND_BITS(i)	(i & 0xf0000000)
=20
 #define LDST_I_BIT(i)	(i & (1 << 26))		/* Immediate constant	*/
 #define LDST_P_BIT(i)	(i & (1 << 24))		/* Preindex		*/
@@ -812,6 +813,8 @@ do_alignment(unsigned long addr, unsigned int fsr, stru=
ct pt_regs *regs)
 		break;
=20
 	case 0x04000000:	/* ldr or str immediate */
+		if (COND_BITS(instr) =3D=3D 0xf0000000) /* NEON VLDn, VSTn */
+			goto bad;
 		offset.un =3D OFFSET_BITS(instr);
 		handler =3D do_alignment_ldrstr;
 		break;
diff --git a/arch/mips/boot/compressed/decompress.c b/arch/mips/boot/compre=
ssed/decompress.c
index 5cad0fa..ca51d69 100644
--- a/arch/mips/boot/compressed/decompress.c
+++ b/arch/mips/boot/compressed/decompress.c
@@ -13,6 +13,7 @@
=20
 #include <linux/types.h>
 #include <linux/kernel.h>
+#include <linux/string.h>
=20
 #include <asm/addrspace.h>
=20
diff --git a/arch/mips/kernel/mcount.S b/arch/mips/kernel/mcount.S
index 4c968e7..55eca41 100644
--- a/arch/mips/kernel/mcount.S
+++ b/arch/mips/kernel/mcount.S
@@ -119,7 +119,11 @@ NESTED(_mcount, PT_SIZE, ra)
 	 nop
 #endif
 	b	ftrace_stub
+#ifdef CONFIG_32BIT
+	 addiu sp, sp, 8
+#else
 	 nop
+#endif
=20
 static_trace:
 	MCOUNT_SAVE_REGS
@@ -129,6 +133,9 @@ static_trace:
 	 move	a1, AT		/* arg2: parent's return address */
=20
 	MCOUNT_RESTORE_REGS
+#ifdef CONFIG_32BIT
+	addiu sp, sp, 8
+#endif
 	.globl ftrace_stub
 ftrace_stub:
 	RETURN_BACK
@@ -177,6 +184,11 @@ NESTED(ftrace_graph_caller, PT_SIZE, ra)
 	jal	prepare_ftrace_return
 	 nop
 	MCOUNT_RESTORE_REGS
+#ifndef CONFIG_DYNAMIC_FTRACE
+#ifdef CONFIG_32BIT
+	addiu sp, sp, 8
+#endif
+#endif
 	RETURN_BACK
 	END(ftrace_graph_caller)
=20
diff --git a/arch/mips/mm/c-r4k.c b/arch/mips/mm/c-r4k.c
index fe425bb..228a205 100644
--- a/arch/mips/mm/c-r4k.c
+++ b/arch/mips/mm/c-r4k.c
@@ -606,6 +606,7 @@ static void r4k_dma_cache_wback_inv(unsigned long addr,=
 unsigned long size)
 			r4k_blast_scache();
 		else
 			blast_scache_range(addr, addr + size);
+		preempt_enable();
 		__sync();
 		return;
 	}
@@ -647,6 +648,7 @@ static void r4k_dma_cache_inv(unsigned long addr, unsig=
ned long size)
 			 */
 			blast_inv_scache_range(addr, addr + size);
 		}
+		preempt_enable();
 		__sync();
 		return;
 	}
diff --git a/arch/parisc/Makefile b/arch/parisc/Makefile
index 55cca1d..75947e0 100644
--- a/arch/parisc/Makefile
+++ b/arch/parisc/Makefile
@@ -47,7 +47,12 @@ cflags-y	:=3D -pipe
=20
 # These flags should be implied by an hppa-linux configuration, but they
 # are not in gcc 3.2.
-cflags-y	+=3D -mno-space-regs -mfast-indirect-calls
+cflags-y	+=3D -mno-space-regs
+
+# -mfast-indirect-calls is only relevant for 32-bit kernels.
+ifndef CONFIG_64BIT
+cflags-y	+=3D -mfast-indirect-calls
+endif
=20
 # Currently we save and restore fpregs on all kernel entry/interruption pa=
ths.
 # If that gets optimized, we might need to disable the use of fpregs in th=
e
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index dd072b1..f6f41dd 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -516,16 +516,6 @@ rerun_vcpu:
=20
 	BUG_ON(vcpu->kvm->arch.float_int.local_int[vcpu->vcpu_id] =3D=3D NULL);
=20
-	switch (kvm_run->exit_reason) {
-	case KVM_EXIT_S390_SIEIC:
-	case KVM_EXIT_UNKNOWN:
-	case KVM_EXIT_INTR:
-	case KVM_EXIT_S390_RESET:
-		break;
-	default:
-		BUG();
-	}
-
 	vcpu->arch.sie_block->gpsw.mask =3D kvm_run->psw_mask;
 	vcpu->arch.sie_block->gpsw.addr =3D kvm_run->psw_addr;
=20
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_hos=
t.h
index b3eb9a7..15d24cb 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -821,6 +821,20 @@ static inline void kvm_inject_gp(struct kvm_vcpu *vcpu=
, u32 error_code)
 	kvm_queue_exception_e(vcpu, GP_VECTOR, error_code);
 }
=20
+static inline u64 get_canonical(u64 la)
+{
+	return ((int64_t)la << 16) >> 16;
+}
+
+static inline bool is_noncanonical_address(u64 la)
+{
+#ifdef CONFIG_X86_64
+	return get_canonical(la) !=3D la;
+#else
+	return false;
+#endif
+}
+
 #define TSS_IOPB_BASE_OFFSET 0x66
 #define TSS_BASE_SIZE 0x68
 #define TSS_IOPB_SIZE (65536 / 8)
diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 31f180c..36cbe2a 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -279,6 +279,8 @@ enum vmcs_field {
 #define EXIT_REASON_APIC_ACCESS         44
 #define EXIT_REASON_EPT_VIOLATION       48
 #define EXIT_REASON_EPT_MISCONFIG       49
+#define EXIT_REASON_INVEPT              50
+#define EXIT_REASON_INVVPID             53
 #define EXIT_REASON_WBINVD		54
 #define EXIT_REASON_XSETBV		55
=20
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 6e68bd9..bb28f2ca 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1252,6 +1252,9 @@ static void remove_siblinginfo(int cpu)
=20
 	for_each_cpu(sibling, cpu_sibling_mask(cpu))
 		cpumask_clear_cpu(cpu, cpu_sibling_mask(sibling));
+	for_each_cpu(sibling, cpu_llc_shared_mask(cpu))
+		cpumask_clear_cpu(cpu, cpu_llc_shared_mask(sibling));
+	cpumask_clear(cpu_llc_shared_mask(cpu));
 	cpumask_clear(cpu_sibling_mask(cpu));
 	cpumask_clear(cpu_core_mask(cpu));
 	c->phys_proc_id =3D 0;
diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 638cab5..f0ac042 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -456,11 +456,6 @@ register_address_increment(struct x86_emulate_ctxt *ct=
xt, unsigned long *reg, in
 		*reg =3D (*reg & ~ad_mask(ctxt)) | ((*reg + inc) & ad_mask(ctxt));
 }
=20
-static inline void jmp_rel(struct x86_emulate_ctxt *ctxt, int rel)
-{
-	register_address_increment(ctxt, &ctxt->_eip, rel);
-}
-
 static u32 desc_limit_scaled(struct desc_struct *desc)
 {
 	u32 limit =3D get_desc_limit(desc);
@@ -534,6 +529,40 @@ static int emulate_nm(struct x86_emulate_ctxt *ctxt)
 	return emulate_exception(ctxt, NM_VECTOR, 0, false);
 }
=20
+static inline int assign_eip_far(struct x86_emulate_ctxt *ctxt, ulong dst,
+			       int cs_l)
+{
+	switch (ctxt->op_bytes) {
+	case 2:
+		ctxt->_eip =3D (u16)dst;
+		break;
+	case 4:
+		ctxt->_eip =3D (u32)dst;
+		break;
+#ifdef CONFIG_X86_64
+	case 8:
+		if ((cs_l && is_noncanonical_address(dst)) ||
+		    (!cs_l && (dst >> 32) !=3D 0))
+			return emulate_gp(ctxt, 0);
+		ctxt->_eip =3D dst;
+		break;
+#endif
+	default:
+		WARN(1, "unsupported eip assignment size\n");
+	}
+	return X86EMUL_CONTINUE;
+}
+
+static inline int assign_eip_near(struct x86_emulate_ctxt *ctxt, ulong dst=
)
+{
+	return assign_eip_far(ctxt, dst, ctxt->mode =3D=3D X86EMUL_MODE_PROT64);
+}
+
+static inline int jmp_rel(struct x86_emulate_ctxt *ctxt, int rel)
+{
+	return assign_eip_near(ctxt, ctxt->_eip + rel);
+}
+
 static u16 get_segment_selector(struct x86_emulate_ctxt *ctxt, unsigned se=
g)
 {
 	u16 selector;
@@ -1206,11 +1235,12 @@ static int write_segment_descriptor(struct x86_emul=
ate_ctxt *ctxt,
 }
=20
 /* Does not support long mode */
-static int load_segment_descriptor(struct x86_emulate_ctxt *ctxt,
-				   u16 selector, int seg)
+static int __load_segment_descriptor(struct x86_emulate_ctxt *ctxt,
+				     u16 selector, int seg, u8 cpl,
+				     struct desc_struct *desc)
 {
 	struct desc_struct seg_desc;
-	u8 dpl, rpl, cpl;
+	u8 dpl, rpl;
 	unsigned err_vec =3D GP_VECTOR;
 	u32 err_code =3D 0;
 	bool null_selector =3D !(selector & ~0x3); /* 0000-0003 are null */
@@ -1259,7 +1289,6 @@ static int load_segment_descriptor(struct x86_emulate=
_ctxt *ctxt,
=20
 	rpl =3D selector & 3;
 	dpl =3D seg_desc.dpl;
-	cpl =3D ctxt->ops->cpl(ctxt);
=20
 	switch (seg) {
 	case VCPU_SREG_SS:
@@ -1316,12 +1345,21 @@ static int load_segment_descriptor(struct x86_emula=
te_ctxt *ctxt,
 	}
 load:
 	ctxt->ops->set_segment(ctxt, selector, &seg_desc, 0, seg);
+	if (desc)
+		*desc =3D seg_desc;
 	return X86EMUL_CONTINUE;
 exception:
 	emulate_exception(ctxt, err_vec, err_code, true);
 	return X86EMUL_PROPAGATE_FAULT;
 }
=20
+static int load_segment_descriptor(struct x86_emulate_ctxt *ctxt,
+				   u16 selector, int seg)
+{
+	u8 cpl =3D ctxt->ops->cpl(ctxt);
+	return __load_segment_descriptor(ctxt, selector, seg, cpl, NULL);
+}
+
 static void write_register_operand(struct operand *op)
 {
 	/* The 4-byte case *is* correct: in 64-bit mode we zero-extend. */
@@ -1661,17 +1699,31 @@ static int em_iret(struct x86_emulate_ctxt *ctxt)
 static int em_jmp_far(struct x86_emulate_ctxt *ctxt)
 {
 	int rc;
-	unsigned short sel;
+	unsigned short sel, old_sel;
+	struct desc_struct old_desc, new_desc;
+	const struct x86_emulate_ops *ops =3D ctxt->ops;
+	u8 cpl =3D ctxt->ops->cpl(ctxt);
+
+	/* Assignment of RIP may only fail in 64-bit mode */
+	if (ctxt->mode =3D=3D X86EMUL_MODE_PROT64)
+		ops->get_segment(ctxt, &old_sel, &old_desc, NULL,
+				 VCPU_SREG_CS);
=20
 	memcpy(&sel, ctxt->src.valptr + ctxt->op_bytes, 2);
=20
-	rc =3D load_segment_descriptor(ctxt, sel, VCPU_SREG_CS);
+	rc =3D __load_segment_descriptor(ctxt, sel, VCPU_SREG_CS, cpl,
+				       &new_desc);
 	if (rc !=3D X86EMUL_CONTINUE)
 		return rc;
=20
-	ctxt->_eip =3D 0;
-	memcpy(&ctxt->_eip, ctxt->src.valptr, ctxt->op_bytes);
-	return X86EMUL_CONTINUE;
+	rc =3D assign_eip_far(ctxt, ctxt->src.val, new_desc.l);
+	if (rc !=3D X86EMUL_CONTINUE) {
+		WARN_ON(ctxt->mode !=3D X86EMUL_MODE_PROT64);
+		/* assigning eip failed; restore the old cs */
+		ops->set_segment(ctxt, old_sel, &old_desc, 0, VCPU_SREG_CS);
+		return rc;
+	}
+	return rc;
 }
=20
 static int em_grp1a(struct x86_emulate_ctxt *ctxt)
@@ -1770,13 +1822,15 @@ static int em_grp45(struct x86_emulate_ctxt *ctxt)
 	case 2: /* call near abs */ {
 		long int old_eip;
 		old_eip =3D ctxt->_eip;
-		ctxt->_eip =3D ctxt->src.val;
+		rc =3D assign_eip_near(ctxt, ctxt->src.val);
+		if (rc !=3D X86EMUL_CONTINUE)
+			break;
 		ctxt->src.val =3D old_eip;
 		rc =3D em_push(ctxt);
 		break;
 	}
 	case 4: /* jmp abs */
-		ctxt->_eip =3D ctxt->src.val;
+		rc =3D assign_eip_near(ctxt, ctxt->src.val);
 		break;
 	case 5: /* jmp far */
 		rc =3D em_jmp_far(ctxt);
@@ -1808,30 +1862,47 @@ static int em_grp9(struct x86_emulate_ctxt *ctxt)
=20
 static int em_ret(struct x86_emulate_ctxt *ctxt)
 {
-	ctxt->dst.type =3D OP_REG;
-	ctxt->dst.addr.reg =3D &ctxt->_eip;
-	ctxt->dst.bytes =3D ctxt->op_bytes;
-	return em_pop(ctxt);
+	int rc;
+	unsigned long eip;
+
+	rc =3D emulate_pop(ctxt, &eip, ctxt->op_bytes);
+	if (rc !=3D X86EMUL_CONTINUE)
+		return rc;
+
+	return assign_eip_near(ctxt, eip);
 }
=20
 static int em_ret_far(struct x86_emulate_ctxt *ctxt)
 {
 	int rc;
-	unsigned long cs;
+	unsigned long eip, cs;
+	u16 old_cs;
 	int cpl =3D ctxt->ops->cpl(ctxt);
+	struct desc_struct old_desc, new_desc;
+	const struct x86_emulate_ops *ops =3D ctxt->ops;
=20
-	rc =3D emulate_pop(ctxt, &ctxt->_eip, ctxt->op_bytes);
+	if (ctxt->mode =3D=3D X86EMUL_MODE_PROT64)
+		ops->get_segment(ctxt, &old_cs, &old_desc, NULL,
+				 VCPU_SREG_CS);
+
+	rc =3D emulate_pop(ctxt, &eip, ctxt->op_bytes);
 	if (rc !=3D X86EMUL_CONTINUE)
 		return rc;
-	if (ctxt->op_bytes =3D=3D 4)
-		ctxt->_eip =3D (u32)ctxt->_eip;
 	rc =3D emulate_pop(ctxt, &cs, ctxt->op_bytes);
 	if (rc !=3D X86EMUL_CONTINUE)
 		return rc;
 	/* Outer-privilege level return is not implemented */
 	if (ctxt->mode >=3D X86EMUL_MODE_PROT16 && (cs & 3) > cpl)
 		return X86EMUL_UNHANDLEABLE;
-	rc =3D load_segment_descriptor(ctxt, (u16)cs, VCPU_SREG_CS);
+	rc =3D __load_segment_descriptor(ctxt, (u16)cs, VCPU_SREG_CS, 0,
+				       &new_desc);
+	if (rc !=3D X86EMUL_CONTINUE)
+		return rc;
+	rc =3D assign_eip_far(ctxt, eip, new_desc.l);
+	if (rc !=3D X86EMUL_CONTINUE) {
+		WARN_ON(ctxt->mode !=3D X86EMUL_MODE_PROT64);
+		ops->set_segment(ctxt, old_cs, &old_desc, 0, VCPU_SREG_CS);
+	}
 	return rc;
 }
=20
@@ -2043,7 +2114,7 @@ static int em_sysexit(struct x86_emulate_ctxt *ctxt)
 {
 	struct x86_emulate_ops *ops =3D ctxt->ops;
 	struct desc_struct cs, ss;
-	u64 msr_data;
+	u64 msr_data, rcx, rdx;
 	int usermode;
 	u16 cs_sel =3D 0, ss_sel =3D 0;
=20
@@ -2059,6 +2130,9 @@ static int em_sysexit(struct x86_emulate_ctxt *ctxt)
 	else
 		usermode =3D X86EMUL_MODE_PROT32;
=20
+	rcx =3D ctxt->regs[VCPU_REGS_RCX];
+	rdx =3D ctxt->regs[VCPU_REGS_RDX];
+
 	cs.dpl =3D 3;
 	ss.dpl =3D 3;
 	ops->get_msr(ctxt, MSR_IA32_SYSENTER_CS, &msr_data);
@@ -2076,6 +2150,9 @@ static int em_sysexit(struct x86_emulate_ctxt *ctxt)
 		ss_sel =3D cs_sel + 8;
 		cs.d =3D 0;
 		cs.l =3D 1;
+		if (is_noncanonical_address(rcx) ||
+		    is_noncanonical_address(rdx))
+			return emulate_gp(ctxt, 0);
 		break;
 	}
 	cs_sel |=3D SELECTOR_RPL_MASK;
@@ -2084,8 +2161,8 @@ static int em_sysexit(struct x86_emulate_ctxt *ctxt)
 	ops->set_segment(ctxt, cs_sel, &cs, 0, VCPU_SREG_CS);
 	ops->set_segment(ctxt, ss_sel, &ss, 0, VCPU_SREG_SS);
=20
-	ctxt->_eip =3D ctxt->regs[VCPU_REGS_RDX];
-	ctxt->regs[VCPU_REGS_RSP] =3D ctxt->regs[VCPU_REGS_RCX];
+	ctxt->_eip =3D rdx;
+	ctxt->regs[VCPU_REGS_RSP] =3D rcx;
=20
 	return X86EMUL_CONTINUE;
 }
@@ -2174,6 +2251,7 @@ static int load_state_from_tss16(struct x86_emulate_c=
txt *ctxt,
 				 struct tss_segment_16 *tss)
 {
 	int ret;
+	u8 cpl;
=20
 	ctxt->_eip =3D tss->ip;
 	ctxt->eflags =3D tss->flag | 2;
@@ -2196,23 +2274,30 @@ static int load_state_from_tss16(struct x86_emulate=
_ctxt *ctxt,
 	set_segment_selector(ctxt, tss->ss, VCPU_SREG_SS);
 	set_segment_selector(ctxt, tss->ds, VCPU_SREG_DS);
=20
+	cpl =3D tss->cs & 3;
+
 	/*
 	 * Now load segment descriptors. If fault happenes at this stage
 	 * it is handled in a context of new task
 	 */
-	ret =3D load_segment_descriptor(ctxt, tss->ldt, VCPU_SREG_LDTR);
+	ret =3D __load_segment_descriptor(ctxt, tss->ldt, VCPU_SREG_LDTR, cpl,
+					NULL);
 	if (ret !=3D X86EMUL_CONTINUE)
 		return ret;
-	ret =3D load_segment_descriptor(ctxt, tss->es, VCPU_SREG_ES);
+	ret =3D __load_segment_descriptor(ctxt, tss->es, VCPU_SREG_ES, cpl,
+					NULL);
 	if (ret !=3D X86EMUL_CONTINUE)
 		return ret;
-	ret =3D load_segment_descriptor(ctxt, tss->cs, VCPU_SREG_CS);
+	ret =3D __load_segment_descriptor(ctxt, tss->cs, VCPU_SREG_CS, cpl,
+					NULL);
 	if (ret !=3D X86EMUL_CONTINUE)
 		return ret;
-	ret =3D load_segment_descriptor(ctxt, tss->ss, VCPU_SREG_SS);
+	ret =3D __load_segment_descriptor(ctxt, tss->ss, VCPU_SREG_SS, cpl,
+					NULL);
 	if (ret !=3D X86EMUL_CONTINUE)
 		return ret;
-	ret =3D load_segment_descriptor(ctxt, tss->ds, VCPU_SREG_DS);
+	ret =3D __load_segment_descriptor(ctxt, tss->ds, VCPU_SREG_DS, cpl,
+					NULL);
 	if (ret !=3D X86EMUL_CONTINUE)
 		return ret;
=20
@@ -2291,6 +2376,7 @@ static int load_state_from_tss32(struct x86_emulate_c=
txt *ctxt,
 				 struct tss_segment_32 *tss)
 {
 	int ret;
+	u8 cpl;
=20
 	if (ctxt->ops->set_cr(ctxt, 3, tss->cr3))
 		return emulate_gp(ctxt, 0);
@@ -2307,7 +2393,8 @@ static int load_state_from_tss32(struct x86_emulate_c=
txt *ctxt,
=20
 	/*
 	 * SDM says that segment selectors are loaded before segment
-	 * descriptors
+	 * descriptors.  This is important because CPL checks will
+	 * use CS.RPL.
 	 */
 	set_segment_selector(ctxt, tss->ldt_selector, VCPU_SREG_LDTR);
 	set_segment_selector(ctxt, tss->es, VCPU_SREG_ES);
@@ -2317,29 +2404,38 @@ static int load_state_from_tss32(struct x86_emulate=
_ctxt *ctxt,
 	set_segment_selector(ctxt, tss->fs, VCPU_SREG_FS);
 	set_segment_selector(ctxt, tss->gs, VCPU_SREG_GS);
=20
+	cpl =3D tss->cs & 3;
+
 	/*
 	 * Now load segment descriptors. If fault happenes at this stage
 	 * it is handled in a context of new task
 	 */
-	ret =3D load_segment_descriptor(ctxt, tss->ldt_selector, VCPU_SREG_LDTR);
+	ret =3D __load_segment_descriptor(ctxt, tss->ldt_selector, VCPU_SREG_LDTR=
,
+					cpl, NULL);
 	if (ret !=3D X86EMUL_CONTINUE)
 		return ret;
-	ret =3D load_segment_descriptor(ctxt, tss->es, VCPU_SREG_ES);
+	ret =3D __load_segment_descriptor(ctxt, tss->es, VCPU_SREG_ES, cpl,
+					NULL);
 	if (ret !=3D X86EMUL_CONTINUE)
 		return ret;
-	ret =3D load_segment_descriptor(ctxt, tss->cs, VCPU_SREG_CS);
+	ret =3D __load_segment_descriptor(ctxt, tss->cs, VCPU_SREG_CS, cpl,
+					NULL);
 	if (ret !=3D X86EMUL_CONTINUE)
 		return ret;
-	ret =3D load_segment_descriptor(ctxt, tss->ss, VCPU_SREG_SS);
+	ret =3D __load_segment_descriptor(ctxt, tss->ss, VCPU_SREG_SS, cpl,
+					NULL);
 	if (ret !=3D X86EMUL_CONTINUE)
 		return ret;
-	ret =3D load_segment_descriptor(ctxt, tss->ds, VCPU_SREG_DS);
+	ret =3D __load_segment_descriptor(ctxt, tss->ds, VCPU_SREG_DS, cpl,
+					NULL);
 	if (ret !=3D X86EMUL_CONTINUE)
 		return ret;
-	ret =3D load_segment_descriptor(ctxt, tss->fs, VCPU_SREG_FS);
+	ret =3D __load_segment_descriptor(ctxt, tss->fs, VCPU_SREG_FS, cpl,
+					NULL);
 	if (ret !=3D X86EMUL_CONTINUE)
 		return ret;
-	ret =3D load_segment_descriptor(ctxt, tss->gs, VCPU_SREG_GS);
+	ret =3D __load_segment_descriptor(ctxt, tss->gs, VCPU_SREG_GS, cpl,
+					NULL);
 	if (ret !=3D X86EMUL_CONTINUE)
 		return ret;
=20
@@ -2536,39 +2632,67 @@ static int em_das(struct x86_emulate_ctxt *ctxt)
 	return X86EMUL_CONTINUE;
 }
=20
+static int em_call(struct x86_emulate_ctxt *ctxt)
+{
+	int rc;
+	long rel =3D ctxt->src.val;
+
+	ctxt->src.val =3D (unsigned long)ctxt->_eip;
+	rc =3D jmp_rel(ctxt, rel);
+	if (rc !=3D X86EMUL_CONTINUE)
+		return rc;
+	return em_push(ctxt);
+}
+
 static int em_call_far(struct x86_emulate_ctxt *ctxt)
 {
 	u16 sel, old_cs;
 	ulong old_eip;
 	int rc;
+	struct desc_struct old_desc, new_desc;
+	const struct x86_emulate_ops *ops =3D ctxt->ops;
+	int cpl =3D ctxt->ops->cpl(ctxt);
=20
-	old_cs =3D get_segment_selector(ctxt, VCPU_SREG_CS);
 	old_eip =3D ctxt->_eip;
+	ops->get_segment(ctxt, &old_cs, &old_desc, NULL, VCPU_SREG_CS);
=20
 	memcpy(&sel, ctxt->src.valptr + ctxt->op_bytes, 2);
-	if (load_segment_descriptor(ctxt, sel, VCPU_SREG_CS))
+	rc =3D __load_segment_descriptor(ctxt, sel, VCPU_SREG_CS, cpl,
+				       &new_desc);
+	if (rc !=3D X86EMUL_CONTINUE)
 		return X86EMUL_CONTINUE;
=20
-	ctxt->_eip =3D 0;
-	memcpy(&ctxt->_eip, ctxt->src.valptr, ctxt->op_bytes);
+	rc =3D assign_eip_far(ctxt, ctxt->src.val, new_desc.l);
+	if (rc !=3D X86EMUL_CONTINUE)
+		goto fail;
=20
 	ctxt->src.val =3D old_cs;
 	rc =3D em_push(ctxt);
 	if (rc !=3D X86EMUL_CONTINUE)
-		return rc;
+		goto fail;
=20
 	ctxt->src.val =3D old_eip;
-	return em_push(ctxt);
+	rc =3D em_push(ctxt);
+	/* If we failed, we tainted the memory, but the very least we should
+	   restore cs */
+	if (rc !=3D X86EMUL_CONTINUE)
+		goto fail;
+	return rc;
+fail:
+	ops->set_segment(ctxt, old_cs, &old_desc, 0, VCPU_SREG_CS);
+	return rc;
+
 }
=20
 static int em_ret_near_imm(struct x86_emulate_ctxt *ctxt)
 {
 	int rc;
+	unsigned long eip;
=20
-	ctxt->dst.type =3D OP_REG;
-	ctxt->dst.addr.reg =3D &ctxt->_eip;
-	ctxt->dst.bytes =3D ctxt->op_bytes;
-	rc =3D emulate_pop(ctxt, &ctxt->dst.val, ctxt->op_bytes);
+	rc =3D emulate_pop(ctxt, &eip, ctxt->op_bytes);
+	if (rc !=3D X86EMUL_CONTINUE)
+		return rc;
+	rc =3D assign_eip_near(ctxt, eip);
 	if (rc !=3D X86EMUL_CONTINUE)
 		return rc;
 	register_address_increment(ctxt, &ctxt->regs[VCPU_REGS_RSP], ctxt->src.va=
l);
@@ -2814,20 +2938,24 @@ static int em_lmsw(struct x86_emulate_ctxt *ctxt)
=20
 static int em_loop(struct x86_emulate_ctxt *ctxt)
 {
+	int rc =3D X86EMUL_CONTINUE;
+
 	register_address_increment(ctxt, &ctxt->regs[VCPU_REGS_RCX], -1);
 	if ((address_mask(ctxt, ctxt->regs[VCPU_REGS_RCX]) !=3D 0) &&
 	    (ctxt->b =3D=3D 0xe2 || test_cc(ctxt->b ^ 0x5, ctxt->eflags)))
-		jmp_rel(ctxt, ctxt->src.val);
+		rc =3D jmp_rel(ctxt, ctxt->src.val);
=20
-	return X86EMUL_CONTINUE;
+	return rc;
 }
=20
 static int em_jcxz(struct x86_emulate_ctxt *ctxt)
 {
+	int rc =3D X86EMUL_CONTINUE;
+
 	if (address_mask(ctxt, ctxt->regs[VCPU_REGS_RCX]) =3D=3D 0)
-		jmp_rel(ctxt, ctxt->src.val);
+		rc =3D jmp_rel(ctxt, ctxt->src.val);
=20
-	return X86EMUL_CONTINUE;
+	return rc;
 }
=20
 static int em_cli(struct x86_emulate_ctxt *ctxt)
@@ -3271,7 +3399,7 @@ static struct opcode opcode_table[256] =3D {
 	D2bvIP(SrcImmUByte | DstAcc, in,  check_perm_in),
 	D2bvIP(SrcAcc | DstImmUByte, out, check_perm_out),
 	/* 0xE8 - 0xEF */
-	D(SrcImm | Stack), D(SrcImm | ImplicitOps),
+	I(SrcImm | Stack, em_call), D(SrcImm | ImplicitOps),
 	I(SrcImmFAddr | No64, em_jmp_far), D(SrcImmByte | ImplicitOps),
 	D2bvIP(SrcDX | DstAcc, in,  check_perm_in),
 	D2bvIP(SrcAcc | DstDX, out, check_perm_out),
@@ -3920,7 +4048,7 @@ special_insn:
 		break;
 	case 0x70 ... 0x7f: /* jcc (short) */
 		if (test_cc(ctxt->b, ctxt->eflags))
-			jmp_rel(ctxt, ctxt->src.val);
+			rc =3D jmp_rel(ctxt, ctxt->src.val);
 		break;
 	case 0x8d: /* lea r16/r32, m */
 		ctxt->dst.val =3D ctxt->src.addr.mem.ea;
@@ -3966,16 +4094,9 @@ special_insn:
 	case 0xe6: /* outb */
 	case 0xe7: /* out */
 		goto do_io_out;
-	case 0xe8: /* call (near) */ {
-		long int rel =3D ctxt->src.val;
-		ctxt->src.val =3D (unsigned long) ctxt->_eip;
-		jmp_rel(ctxt, rel);
-		rc =3D em_push(ctxt);
-		break;
-	}
 	case 0xe9: /* jmp rel */
 	case 0xeb: /* jmp rel short */
-		jmp_rel(ctxt, ctxt->src.val);
+		rc =3D jmp_rel(ctxt, ctxt->src.val);
 		ctxt->dst.type =3D OP_NONE; /* Disable writeback. */
 		break;
 	case 0xec: /* in al,dx */
@@ -4141,7 +4262,7 @@ twobyte_insn:
 		break;
 	case 0x80 ... 0x8f: /* jnz rel, etc*/
 		if (test_cc(ctxt->b, ctxt->eflags))
-			jmp_rel(ctxt, ctxt->src.val);
+			rc =3D jmp_rel(ctxt, ctxt->src.val);
 		break;
 	case 0x90 ... 0x9f:     /* setcc r/m8 */
 		ctxt->dst.val =3D test_cc(ctxt->b, ctxt->eflags);
diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
index 139415e..cced57f 100644
--- a/arch/x86/kvm/i8254.c
+++ b/arch/x86/kvm/i8254.c
@@ -264,8 +264,10 @@ void __kvm_migrate_pit_timer(struct kvm_vcpu *vcpu)
 		return;
=20
 	timer =3D &pit->pit_state.pit_timer.timer;
+	mutex_lock(&pit->pit_state.lock);
 	if (hrtimer_cancel(timer))
 		hrtimer_start_expires(timer, HRTIMER_MODE_ABS);
+	mutex_unlock(&pit->pit_state.lock);
 }
=20
 static void destroy_pit_timer(struct kvm_pit *pit)
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 2102a17..82f97a5 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -3109,7 +3109,7 @@ static int wrmsr_interception(struct vcpu_svm *svm)
=20
=20
 	svm->next_rip =3D kvm_rip_read(&svm->vcpu) + 2;
-	if (svm_set_msr(&svm->vcpu, ecx, data)) {
+	if (kvm_set_msr(&svm->vcpu, ecx, data)) {
 		trace_kvm_msr_write_ex(ecx, data);
 		kvm_inject_gp(&svm->vcpu, 0);
 	} else {
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index a4f6bda..578b1c6 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -390,6 +390,7 @@ struct vcpu_vmx {
 		u16           fs_sel, gs_sel, ldt_sel;
 		int           gs_ldt_reload_needed;
 		int           fs_reload_needed;
+		unsigned long vmcs_host_cr4;	/* May not match real cr4 */
 	} host_state;
 	struct {
 		int vm86_active;
@@ -3629,16 +3630,21 @@ static void vmx_disable_intercept_for_msr(u32 msr, =
bool longmode_only)
  * Note that host-state that does change is set elsewhere. E.g., host-stat=
e
  * that is set differently for each CPU is set in vmx_vcpu_load(), not her=
e.
  */
-static void vmx_set_constant_host_state(void)
+static void vmx_set_constant_host_state(struct vcpu_vmx *vmx)
 {
 	u32 low32, high32;
 	unsigned long tmpl;
 	struct desc_ptr dt;
+	unsigned long cr4;
=20
 	vmcs_writel(HOST_CR0, read_cr0() | X86_CR0_TS);  /* 22.2.3 */
-	vmcs_writel(HOST_CR4, read_cr4());  /* 22.2.3, 22.2.5 */
 	vmcs_writel(HOST_CR3, read_cr3());  /* 22.2.3  FIXME: shadow tables */
=20
+	/* Save the most likely value for this task's CR4 in the VMCS. */
+	cr4 =3D read_cr4();
+	vmcs_writel(HOST_CR4, cr4);			/* 22.2.3, 22.2.5 */
+	vmx->host_state.vmcs_host_cr4 =3D cr4;
+
 	vmcs_write16(HOST_CS_SELECTOR, __KERNEL_CS);  /* 22.2.4 */
 	vmcs_write16(HOST_DS_SELECTOR, __KERNEL_DS);  /* 22.2.4 */
 	vmcs_write16(HOST_ES_SELECTOR, __KERNEL_DS);  /* 22.2.4 */
@@ -3760,7 +3766,7 @@ static int vmx_vcpu_setup(struct vcpu_vmx *vmx)
=20
 	vmcs_write16(HOST_FS_SELECTOR, 0);            /* 22.2.4 */
 	vmcs_write16(HOST_GS_SELECTOR, 0);            /* 22.2.4 */
-	vmx_set_constant_host_state();
+	vmx_set_constant_host_state(vmx);
 #ifdef CONFIG_X86_64
 	rdmsrl(MSR_FS_BASE, a);
 	vmcs_writel(HOST_FS_BASE, a); /* 22.2.4 */
@@ -4544,7 +4550,7 @@ static int handle_wrmsr(struct kvm_vcpu *vcpu)
 	u64 data =3D (vcpu->arch.regs[VCPU_REGS_RAX] & -1u)
 		| ((u64)(vcpu->arch.regs[VCPU_REGS_RDX] & -1u) << 32);
=20
-	if (vmx_set_msr(vcpu, ecx, data) !=3D 0) {
+	if (kvm_set_msr(vcpu, ecx, data) !=3D 0) {
 		trace_kvm_msr_write_ex(ecx, data);
 		kvm_inject_gp(vcpu, 0);
 		return 1;
@@ -5550,6 +5556,18 @@ static int handle_vmptrst(struct kvm_vcpu *vcpu)
 	return 1;
 }
=20
+static int handle_invept(struct kvm_vcpu *vcpu)
+{
+	kvm_queue_exception(vcpu, UD_VECTOR);
+	return 1;
+}
+
+static int handle_invvpid(struct kvm_vcpu *vcpu)
+{
+	kvm_queue_exception(vcpu, UD_VECTOR);
+	return 1;
+}
+
 /*
  * The exit handlers return 1 if the exit was handled fully and guest exec=
ution
  * may resume.  Otherwise they set the kvm_run parameter to indicate what =
needs
@@ -5591,6 +5609,8 @@ static int (*kvm_vmx_exit_handlers[])(struct kvm_vcpu=
 *vcpu) =3D {
 	[EXIT_REASON_PAUSE_INSTRUCTION]       =3D handle_pause,
 	[EXIT_REASON_MWAIT_INSTRUCTION]	      =3D handle_invalid_op,
 	[EXIT_REASON_MONITOR_INSTRUCTION]     =3D handle_invalid_op,
+	[EXIT_REASON_INVEPT]                  =3D handle_invept,
+	[EXIT_REASON_INVVPID]                 =3D handle_invvpid,
 };
=20
 static const int kvm_vmx_max_exit_handlers =3D
@@ -5775,6 +5795,7 @@ static bool nested_vmx_exit_handled(struct kvm_vcpu *=
vcpu)
 	case EXIT_REASON_VMPTRST: case EXIT_REASON_VMREAD:
 	case EXIT_REASON_VMRESUME: case EXIT_REASON_VMWRITE:
 	case EXIT_REASON_VMOFF: case EXIT_REASON_VMON:
+	case EXIT_REASON_INVEPT: case EXIT_REASON_INVVPID:
 		/*
 		 * VMX instructions trap unconditionally. This allows L1 to
 		 * emulate them for its L2 guest, i.e., allows 3-level nesting!
@@ -6093,6 +6114,7 @@ static void atomic_switch_perf_msrs(struct vcpu_vmx *=
vmx)
 static void __noclone vmx_vcpu_run(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx =3D to_vmx(vcpu);
+	unsigned long cr4;
=20
 	if (is_guest_mode(vcpu) && !vmx->nested.nested_run_pending) {
 		struct vmcs12 *vmcs12 =3D get_vmcs12(vcpu);
@@ -6123,6 +6145,12 @@ static void __noclone vmx_vcpu_run(struct kvm_vcpu *=
vcpu)
 	if (test_bit(VCPU_REGS_RIP, (unsigned long *)&vcpu->arch.regs_dirty))
 		vmcs_writel(GUEST_RIP, vcpu->arch.regs[VCPU_REGS_RIP]);
=20
+	cr4 =3D read_cr4();
+	if (unlikely(cr4 !=3D vmx->host_state.vmcs_host_cr4)) {
+		vmcs_writel(HOST_CR4, cr4);
+		vmx->host_state.vmcs_host_cr4 =3D cr4;
+	}
+
 	/* When single-stepping over STI and MOV SS, we must clear the
 	 * corresponding interruptibility bits in the guest state. Otherwise
 	 * vmentry fails as it then expects bit 14 (BS) in pending debug
@@ -6581,7 +6609,7 @@ static void prepare_vmcs02(struct kvm_vcpu *vcpu, str=
uct vmcs12 *vmcs12)
 	 * Other fields are different per CPU, and will be set later when
 	 * vmx_vcpu_load() is called, and when vmx_save_host_state() is called.
 	 */
-	vmx_set_constant_host_state();
+	vmx_set_constant_host_state(vmx);
=20
 	/*
 	 * HOST_RSP is normally set correctly in vmx_vcpu_run() just before
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b9fefaf..2d7d0df 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -893,7 +893,6 @@ void kvm_enable_efer_bits(u64 mask)
 }
 EXPORT_SYMBOL_GPL(kvm_enable_efer_bits);
=20
-
 /*
  * Writes msr value into into the appropriate "register".
  * Returns 0 on success, non-0 otherwise.
@@ -901,8 +900,34 @@ EXPORT_SYMBOL_GPL(kvm_enable_efer_bits);
  */
 int kvm_set_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 data)
 {
+	switch (msr_index) {
+	case MSR_FS_BASE:
+	case MSR_GS_BASE:
+	case MSR_KERNEL_GS_BASE:
+	case MSR_CSTAR:
+	case MSR_LSTAR:
+		if (is_noncanonical_address(data))
+			return 1;
+		break;
+	case MSR_IA32_SYSENTER_EIP:
+	case MSR_IA32_SYSENTER_ESP:
+		/*
+		 * IA32_SYSENTER_ESP and IA32_SYSENTER_EIP cause #GP if
+		 * non-canonical address is written on Intel but not on
+		 * AMD (which ignores the top 32-bits, because it does
+		 * not implement 64-bit SYSENTER).
+		 *
+		 * 64-bit code should hence be able to write a non-canonical
+		 * value on AMD.  Making the address canonical ensures that
+		 * vmentry does not fail on Intel after writing a non-canonical
+		 * value, and that something deterministic happens if the guest
+		 * invokes 64-bit SYSENTER.
+		 */
+		data =3D get_canonical(data);
+	}
 	return kvm_x86_ops->set_msr(vcpu, msr_index, data);
 }
+EXPORT_SYMBOL_GPL(kvm_set_msr);
=20
 /*
  * Adapt set_msr() to msr_io()'s calling convention
diff --git a/block/genhd.c b/block/genhd.c
index 8bd4ef2..41b0435 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -28,10 +28,10 @@ struct kobject *block_depr;
 /* for extended dynamic devt allocation, currently only one major is used =
*/
 #define NR_EXT_DEVT		(1 << MINORBITS)
=20
-/* For extended devt allocation.  ext_devt_mutex prevents look up
+/* For extended devt allocation.  ext_devt_lock prevents look up
  * results from going away underneath its user.
  */
-static DEFINE_MUTEX(ext_devt_mutex);
+static DEFINE_SPINLOCK(ext_devt_lock);
 static DEFINE_IDR(ext_devt_idr);
=20
 static struct device_type disk_type;
@@ -421,13 +421,13 @@ int blk_alloc_devt(struct hd_struct *part, dev_t *dev=
t)
 	do {
 		if (!idr_pre_get(&ext_devt_idr, GFP_KERNEL))
 			return -ENOMEM;
-		mutex_lock(&ext_devt_mutex);
+		spin_lock(&ext_devt_lock);
 		rc =3D idr_get_new(&ext_devt_idr, part, &idx);
 		if (!rc && idx >=3D NR_EXT_DEVT) {
 			idr_remove(&ext_devt_idr, idx);
 			rc =3D -EBUSY;
 		}
-		mutex_unlock(&ext_devt_mutex);
+		spin_unlock(&ext_devt_lock);
 	} while (rc =3D=3D -EAGAIN);
=20
 	if (rc)
@@ -448,15 +448,13 @@ int blk_alloc_devt(struct hd_struct *part, dev_t *dev=
t)
  */
 void blk_free_devt(dev_t devt)
 {
-	might_sleep();
-
 	if (devt =3D=3D MKDEV(0, 0))
 		return;
=20
 	if (MAJOR(devt) =3D=3D BLOCK_EXT_MAJOR) {
-		mutex_lock(&ext_devt_mutex);
+		spin_lock(&ext_devt_lock);
 		idr_remove(&ext_devt_idr, blk_mangle_minor(MINOR(devt)));
-		mutex_unlock(&ext_devt_mutex);
+		spin_unlock(&ext_devt_lock);
 	}
 }
=20
@@ -663,7 +661,6 @@ void del_gendisk(struct gendisk *disk)
 	if (!sysfs_deprecated)
 		sysfs_remove_link(block_depr, dev_name(disk_to_dev(disk)));
 	device_del(disk_to_dev(disk));
-	blk_free_devt(disk_to_dev(disk)->devt);
 }
 EXPORT_SYMBOL(del_gendisk);
=20
@@ -688,13 +685,13 @@ struct gendisk *get_gendisk(dev_t devt, int *partno)
 	} else {
 		struct hd_struct *part;
=20
-		mutex_lock(&ext_devt_mutex);
+		spin_lock(&ext_devt_lock);
 		part =3D idr_find(&ext_devt_idr, blk_mangle_minor(MINOR(devt)));
 		if (part && get_disk(part_to_disk(part))) {
 			*partno =3D part->partno;
 			disk =3D part_to_disk(part);
 		}
-		mutex_unlock(&ext_devt_mutex);
+		spin_unlock(&ext_devt_lock);
 	}
=20
 	return disk;
@@ -1102,6 +1099,7 @@ static void disk_release(struct device *dev)
 {
 	struct gendisk *disk =3D dev_to_disk(dev);
=20
+	blk_free_devt(dev->devt);
 	disk_release_events(disk);
 	kfree(disk->random);
 	disk_replace_part_tbl(disk, NULL);
diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index de0791c..388ba10 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -1165,9 +1165,9 @@ int acpi_processor_cst_has_changed(struct acpi_proces=
sor *pr)
 	if (smp_processor_id() =3D=3D 0 &&
 			cpuidle_get_driver() =3D=3D &acpi_idle_driver) {
=20
-		cpuidle_pause_and_lock();
 		/* Protect against cpu-hotplug */
 		get_online_cpus();
+		cpuidle_pause_and_lock();
=20
 		/* Disable all cpuidle devices */
 		for_each_online_cpu(cpu) {
@@ -1192,8 +1192,8 @@ int acpi_processor_cst_has_changed(struct acpi_proces=
sor *pr)
 				cpuidle_enable_device(&_pr->power.dev);
 			}
 		}
-		put_online_cpus();
 		cpuidle_resume_and_unlock();
+		put_online_cpus();
 	}
=20
 	return 0;
diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 43b0acf..4007f62 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -315,6 +315,14 @@ static const struct pci_device_id ahci_pci_tbl[] =3D {
 	{ PCI_VDEVICE(INTEL, 0x9c85), board_ahci }, /* Wildcat Point-LP RAID */
 	{ PCI_VDEVICE(INTEL, 0x9c87), board_ahci }, /* Wildcat Point-LP RAID */
 	{ PCI_VDEVICE(INTEL, 0x9c8f), board_ahci }, /* Wildcat Point-LP RAID */
+	{ PCI_VDEVICE(INTEL, 0x8c82), board_ahci }, /* 9 Series AHCI */
+	{ PCI_VDEVICE(INTEL, 0x8c83), board_ahci }, /* 9 Series AHCI */
+	{ PCI_VDEVICE(INTEL, 0x8c84), board_ahci }, /* 9 Series RAID */
+	{ PCI_VDEVICE(INTEL, 0x8c85), board_ahci }, /* 9 Series RAID */
+	{ PCI_VDEVICE(INTEL, 0x8c86), board_ahci }, /* 9 Series RAID */
+	{ PCI_VDEVICE(INTEL, 0x8c87), board_ahci }, /* 9 Series RAID */
+	{ PCI_VDEVICE(INTEL, 0x8c8e), board_ahci }, /* 9 Series RAID */
+	{ PCI_VDEVICE(INTEL, 0x8c8f), board_ahci }, /* 9 Series RAID */
=20
 	/* JMicron 360/1/3/5/6, match class to avoid IDE function */
 	{ PCI_VENDOR_ID_JMICRON, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
@@ -449,6 +457,8 @@ static const struct pci_device_id ahci_pci_tbl[] =3D {
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL_EXT, 0x917a),
 	  .driver_data =3D board_ahci_yes_fbs },			/* 88se9172 */
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL_EXT, 0x9172),
+	  .driver_data =3D board_ahci_yes_fbs },			/* 88se9182 */
+	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL_EXT, 0x9182),
 	  .driver_data =3D board_ahci_yes_fbs },			/* 88se9172 */
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL_EXT, 0x9192),
 	  .driver_data =3D board_ahci_yes_fbs },			/* 88se9172 on some Gigabyte *=
/
diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index 5b0b5f7..b1e8e11 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -362,6 +362,14 @@ static const struct pci_device_id piix_pci_tbl[] =3D {
 	{ 0x8086, 0x0F21, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata_byt },
 	/* SATA Controller IDE (Coleto Creek) */
 	{ 0x8086, 0x23a6, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
+	/* SATA Controller IDE (9 Series) */
+	{ 0x8086, 0x8c88, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata_snb },
+	/* SATA Controller IDE (9 Series) */
+	{ 0x8086, 0x8c89, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata_snb },
+	/* SATA Controller IDE (9 Series) */
+	{ 0x8086, 0x8c80, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata_snb },
+	/* SATA Controller IDE (9 Series) */
+	{ 0x8086, 0x8c81, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata_snb },
=20
 	{ }	/* terminate list */
 };
diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index bf441db..ea78bc46 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -36,6 +36,9 @@ bool regmap_readable(struct regmap *map, unsigned int reg=
)
 	if (map->max_register && reg > map->max_register)
 		return false;
=20
+	if (map->format.format_write)
+		return false;
+
 	if (map->readable_reg)
 		return map->readable_reg(map->dev, reg);
=20
@@ -44,7 +47,7 @@ bool regmap_readable(struct regmap *map, unsigned int reg=
)
=20
 bool regmap_volatile(struct regmap *map, unsigned int reg)
 {
-	if (map->max_register && reg > map->max_register)
+	if (!map->format.format_write && !regmap_readable(map, reg))
 		return false;
=20
 	if (map->volatile_reg)
@@ -55,7 +58,7 @@ bool regmap_volatile(struct regmap *map, unsigned int reg=
)
=20
 bool regmap_precious(struct regmap *map, unsigned int reg)
 {
-	if (map->max_register && reg > map->max_register)
+	if (!regmap_readable(map, reg))
 		return false;
=20
 	if (map->precious_reg)
diff --git a/drivers/gpu/drm/i915/intel_bios.c b/drivers/gpu/drm/i915/intel=
_bios.c
index 0016fee..96d5cfc 100644
--- a/drivers/gpu/drm/i915/intel_bios.c
+++ b/drivers/gpu/drm/i915/intel_bios.c
@@ -651,7 +651,7 @@ init_vbt_defaults(struct drm_i915_private *dev_priv)
 	DRM_DEBUG_KMS("Set default to SSC at %dMHz\n", dev_priv->lvds_ssc_freq);
 }
=20
-static int __init intel_no_opregion_vbt_callback(const struct dmi_system_i=
d *id)
+static int intel_no_opregion_vbt_callback(const struct dmi_system_id *id)
 {
 	DRM_DEBUG_KMS("Falling back to manually reading VBT from "
 		      "VBIOS ROM for %s\n",
diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel=
_lvds.c
index 74d312f..fadd021 100644
--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -613,7 +613,7 @@ static const struct drm_encoder_funcs intel_lvds_enc_fu=
ncs =3D {
 	.destroy =3D intel_encoder_destroy,
 };
=20
-static int __init intel_no_lvds_dmi_callback(const struct dmi_system_id *i=
d)
+static int intel_no_lvds_dmi_callback(const struct dmi_system_id *id)
 {
 	DRM_DEBUG_KMS("Skipping LVDS initialization for %s\n", id->ident);
 	return 1;
diff --git a/drivers/gpu/drm/radeon/radeon_atombios.c b/drivers/gpu/drm/rad=
eon/radeon_atombios.c
index 6d9c32b..24e9756 100644
--- a/drivers/gpu/drm/radeon/radeon_atombios.c
+++ b/drivers/gpu/drm/radeon/radeon_atombios.c
@@ -457,6 +457,13 @@ static bool radeon_atom_apply_quirks(struct drm_device=
 *dev,
 		}
 	}
=20
+	/* Fujitsu D3003-S2 board lists DVI-I as DVI-I and VGA */
+	if ((dev->pdev->device =3D=3D 0x9805) &&
+	    (dev->pdev->subsystem_vendor =3D=3D 0x1734) &&
+	    (dev->pdev->subsystem_device =3D=3D 0x11bd)) {
+		if (*connector_type =3D=3D DRM_MODE_CONNECTOR_VGA)
+			return false;
+	}
=20
 	return true;
 }
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_fifo.c b/drivers/gpu/drm/vmwgfx/=
vmwgfx_fifo.c
index a0c2f12..decca82 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_fifo.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_fifo.c
@@ -163,8 +163,9 @@ void vmw_fifo_release(struct vmw_private *dev_priv, str=
uct vmw_fifo_state *fifo)
=20
 	mutex_lock(&dev_priv->hw_mutex);
=20
+	vmw_write(dev_priv, SVGA_REG_SYNC, SVGA_SYNC_GENERIC);
 	while (vmw_read(dev_priv, SVGA_REG_BUSY) !=3D 0)
-		vmw_write(dev_priv, SVGA_REG_SYNC, SVGA_SYNC_GENERIC);
+		;
=20
 	dev_priv->last_read_seqno =3D ioread32(fifo_mem + SVGA_FIFO_FENCE);
=20
diff --git a/drivers/input/mouse/elantech.c b/drivers/input/mouse/elantech.=
c
index 70423dc..2d5bb5b 100644
--- a/drivers/input/mouse/elantech.c
+++ b/drivers/input/mouse/elantech.c
@@ -1130,6 +1130,13 @@ static bool elantech_is_signature_valid(const unsign=
ed char *param)
 	if (param[1] =3D=3D 0)
 		return true;
=20
+	/*
+	 * Some models have a revision higher then 20. Meaning param[2] may
+	 * be 10 or 20, skip the rates check for these.
+	 */
+	if (param[0] =3D=3D 0x46 && (param[1] & 0xef) =3D=3D 0x0f && param[2] < 4=
0)
+		return true;
+
 	for (i =3D 0; i < ARRAY_SIZE(rates); i++)
 		if (param[2] =3D=3D rates[i])
 			return false;
diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptic=
s.c
index df8b72b..a50e121 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -506,10 +506,61 @@ static int synaptics_parse_hw_state(const unsigned ch=
ar buf[],
 			 ((buf[0] & 0x04) >> 1) |
 			 ((buf[3] & 0x04) >> 2));
=20
+		if ((SYN_CAP_ADV_GESTURE(priv->ext_cap_0c) ||
+			SYN_CAP_IMAGE_SENSOR(priv->ext_cap_0c)) &&
+		    hw->w =3D=3D 2) {
+			synaptics_parse_agm(buf, priv, hw);
+			return 1;
+		}
+
+		hw->x =3D (((buf[3] & 0x10) << 8) |
+			 ((buf[1] & 0x0f) << 8) |
+			 buf[4]);
+		hw->y =3D (((buf[3] & 0x20) << 7) |
+			 ((buf[1] & 0xf0) << 4) |
+			 buf[5]);
+		hw->z =3D buf[2];
+
 		hw->left  =3D (buf[0] & 0x01) ? 1 : 0;
 		hw->right =3D (buf[0] & 0x02) ? 1 : 0;
=20
-		if (SYN_CAP_CLICKPAD(priv->ext_cap_0c)) {
+		if (SYN_CAP_FORCEPAD(priv->ext_cap_0c)) {
+			/*
+			 * ForcePads, like Clickpads, use middle button
+			 * bits to report primary button clicks.
+			 * Unfortunately they report primary button not
+			 * only when user presses on the pad above certain
+			 * threshold, but also when there are more than one
+			 * finger on the touchpad, which interferes with
+			 * out multi-finger gestures.
+			 */
+			if (hw->z =3D=3D 0) {
+				/* No contacts */
+				priv->press =3D priv->report_press =3D false;
+			} else if (hw->w >=3D 4 && ((buf[0] ^ buf[3]) & 0x01)) {
+				/*
+				 * Single-finger touch with pressure above
+				 * the threshold. If pressure stays long
+				 * enough, we'll start reporting primary
+				 * button. We rely on the device continuing
+				 * sending data even if finger does not
+				 * move.
+				 */
+				if  (!priv->press) {
+					priv->press_start =3D jiffies;
+					priv->press =3D true;
+				} else if (time_after(jiffies,
+						priv->press_start +
+							msecs_to_jiffies(50))) {
+					priv->report_press =3D true;
+				}
+			} else {
+				priv->press =3D false;
+			}
+
+			hw->left =3D priv->report_press;
+
+		} else if (SYN_CAP_CLICKPAD(priv->ext_cap_0c)) {
 			/*
 			 * Clickpad's button is transmitted as middle button,
 			 * however, since it is primary button, we will report
@@ -528,21 +579,6 @@ static int synaptics_parse_hw_state(const unsigned cha=
r buf[],
 			hw->down =3D ((buf[0] ^ buf[3]) & 0x02) ? 1 : 0;
 		}
=20
-		if ((SYN_CAP_ADV_GESTURE(priv->ext_cap_0c) ||
-			SYN_CAP_IMAGE_SENSOR(priv->ext_cap_0c)) &&
-		    hw->w =3D=3D 2) {
-			synaptics_parse_agm(buf, priv, hw);
-			return 1;
-		}
-
-		hw->x =3D (((buf[3] & 0x10) << 8) |
-			 ((buf[1] & 0x0f) << 8) |
-			 buf[4]);
-		hw->y =3D (((buf[3] & 0x20) << 7) |
-			 ((buf[1] & 0xf0) << 4) |
-			 buf[5]);
-		hw->z =3D buf[2];
-
 		if (SYN_CAP_MULTI_BUTTON_NO(priv->ext_cap) &&
 		    ((buf[0] ^ buf[3]) & 0x02)) {
 			switch (SYN_CAP_MULTI_BUTTON_NO(priv->ext_cap) & ~0x01) {
diff --git a/drivers/input/mouse/synaptics.h b/drivers/input/mouse/synaptic=
s.h
index 622aea8..908d167 100644
--- a/drivers/input/mouse/synaptics.h
+++ b/drivers/input/mouse/synaptics.h
@@ -77,6 +77,11 @@
  * 2	0x08	image sensor		image sensor tracks 5 fingers, but only
  *					reports 2.
  * 2	0x20	report min		query 0x0f gives min coord reported
+ * 2	0x80	forcepad		forcepad is a variant of clickpad that
+ *					does not have physical buttons but rather
+ *					uses pressure above certain threshold to
+ *					report primary clicks. Forcepads also have
+ *					clickpad bit set.
  */
 #define SYN_CAP_CLICKPAD(ex0c)		((ex0c) & 0x100000) /* 1-button ClickPad *=
/
 #define SYN_CAP_CLICKPAD2BTN(ex0c)	((ex0c) & 0x000100) /* 2-button ClickPa=
d */
@@ -85,6 +90,7 @@
 #define SYN_CAP_ADV_GESTURE(ex0c)	((ex0c) & 0x080000)
 #define SYN_CAP_REDUCED_FILTERING(ex0c)	((ex0c) & 0x000400)
 #define SYN_CAP_IMAGE_SENSOR(ex0c)	((ex0c) & 0x000800)
+#define SYN_CAP_FORCEPAD(ex0c)		((ex0c) & 0x008000)
=20
 /* synaptics modes query bits */
 #define SYN_MODE_ABSOLUTE(m)		((m) & (1 << 7))
@@ -170,6 +176,11 @@ struct synaptics_data {
 	 */
 	struct synaptics_hw_state agm;
 	bool agm_pending;			/* new AGM packet received */
+
+	/* ForcePad handling */
+	unsigned long				press_start;
+	bool					press;
+	bool					report_press;
 };
=20
 void synaptics_module_init(void);
diff --git a/drivers/input/serio/i8042-x86ia64io.h b/drivers/input/serio/i8=
042-x86ia64io.h
index 031270c..bab8238 100644
--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -458,6 +458,13 @@ static const struct dmi_system_id __initconst i8042_dm=
i_nomux_table[] =3D {
 			DMI_MATCH(DMI_PRODUCT_NAME, "HP Pavilion dv4 Notebook PC"),
 		},
 	},
+	{
+		/* Avatar AVIU-145A6 */
+		.matches =3D {
+			DMI_MATCH(DMI_SYS_VENDOR, "Intel"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "IC4I"),
+		},
+	},
 	{ }
 };
=20
@@ -594,6 +601,14 @@ static const struct dmi_system_id __initconst i8042_dm=
i_notimeout_table[] =3D {
 			DMI_MATCH(DMI_PRODUCT_NAME, "HP Pavilion dv4 Notebook PC"),
 		},
 	},
+	{
+		/* Fujitsu U574 laptop */
+		/* https://bugzilla.kernel.org/show_bug.cgi?id=3D69731 */
+		.matches =3D {
+			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "LIFEBOOK U574"),
+		},
+	},
 	{ }
 };
=20
diff --git a/drivers/input/serio/serport.c b/drivers/input/serio/serport.c
index 8755f5f..e4ecf3b 100644
--- a/drivers/input/serio/serport.c
+++ b/drivers/input/serio/serport.c
@@ -21,6 +21,7 @@
 #include <linux/init.h>
 #include <linux/serio.h>
 #include <linux/tty.h>
+#include <linux/compat.h>
=20
 MODULE_AUTHOR("Vojtech Pavlik <vojtech@ucw.cz>");
 MODULE_DESCRIPTION("Input device TTY line discipline");
@@ -196,28 +197,55 @@ static ssize_t serport_ldisc_read(struct tty_struct *=
 tty, struct file * file, u
 	return 0;
 }
=20
+static void serport_set_type(struct tty_struct *tty, unsigned long type)
+{
+	struct serport *serport =3D tty->disc_data;
+
+	serport->id.proto =3D type & 0x000000ff;
+	serport->id.id    =3D (type & 0x0000ff00) >> 8;
+	serport->id.extra =3D (type & 0x00ff0000) >> 16;
+}
+
 /*
  * serport_ldisc_ioctl() allows to set the port protocol, and device ID
  */
=20
-static int serport_ldisc_ioctl(struct tty_struct * tty, struct file * file=
, unsigned int cmd, unsigned long arg)
+static int serport_ldisc_ioctl(struct tty_struct *tty, struct file *file,
+			       unsigned int cmd, unsigned long arg)
 {
-	struct serport *serport =3D (struct serport*) tty->disc_data;
-	unsigned long type;
-
 	if (cmd =3D=3D SPIOCSTYPE) {
+		unsigned long type;
+
 		if (get_user(type, (unsigned long __user *) arg))
 			return -EFAULT;
=20
-		serport->id.proto =3D type & 0x000000ff;
-		serport->id.id	  =3D (type & 0x0000ff00) >> 8;
-		serport->id.extra =3D (type & 0x00ff0000) >> 16;
+		serport_set_type(tty, type);
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
+#ifdef CONFIG_COMPAT
+#define COMPAT_SPIOCSTYPE	_IOW('q', 0x01, compat_ulong_t)
+static long serport_ldisc_compat_ioctl(struct tty_struct *tty,
+				       struct file *file,
+				       unsigned int cmd, unsigned long arg)
+{
+	if (cmd =3D=3D COMPAT_SPIOCSTYPE) {
+		void __user *uarg =3D compat_ptr(arg);
+		compat_ulong_t compat_type;
+
+		if (get_user(compat_type, (compat_ulong_t __user *)uarg))
+			return -EFAULT;
=20
+		serport_set_type(tty, compat_type);
 		return 0;
 	}
=20
 	return -EINVAL;
 }
+#endif
=20
 static void serport_ldisc_write_wakeup(struct tty_struct * tty)
 {
@@ -241,6 +269,9 @@ static struct tty_ldisc_ops serport_ldisc =3D {
 	.close =3D	serport_ldisc_close,
 	.read =3D		serport_ldisc_read,
 	.ioctl =3D	serport_ldisc_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl =3D	serport_ldisc_compat_ioctl,
+#endif
 	.receive_buf =3D	serport_ldisc_receive,
 	.write_wakeup =3D	serport_ldisc_write_wakeup
 };
diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index aa142f9..4878d91 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1565,6 +1565,7 @@ static int crypt_ctr(struct dm_target *ti, unsigned i=
nt argc, char **argv)
 	unsigned int key_size, opt_params;
 	unsigned long long tmpll;
 	int ret;
+	size_t iv_size_padding;
 	struct dm_arg_set as;
 	const char *opt_string;
=20
@@ -1600,12 +1601,23 @@ static int crypt_ctr(struct dm_target *ti, unsigned=
 int argc, char **argv)
=20
 	cc->dmreq_start =3D sizeof(struct ablkcipher_request);
 	cc->dmreq_start +=3D crypto_ablkcipher_reqsize(any_tfm(cc));
-	cc->dmreq_start =3D ALIGN(cc->dmreq_start, crypto_tfm_ctx_alignment());
-	cc->dmreq_start +=3D crypto_ablkcipher_alignmask(any_tfm(cc)) &
-			   ~(crypto_tfm_ctx_alignment() - 1);
+	cc->dmreq_start =3D ALIGN(cc->dmreq_start, __alignof__(struct dm_crypt_re=
quest));
+
+	if (crypto_ablkcipher_alignmask(any_tfm(cc)) < CRYPTO_MINALIGN) {
+		/* Allocate the padding exactly */
+		iv_size_padding =3D -(cc->dmreq_start + sizeof(struct dm_crypt_request))
+				& crypto_ablkcipher_alignmask(any_tfm(cc));
+	} else {
+		/*
+		 * If the cipher requires greater alignment than kmalloc
+		 * alignment, we don't know the exact position of the
+		 * initialization vector. We must assume worst case.
+		 */
+		iv_size_padding =3D crypto_ablkcipher_alignmask(any_tfm(cc));
+	}
=20
 	cc->req_pool =3D mempool_create_kmalloc_pool(MIN_IOS, cc->dmreq_start +
-			sizeof(struct dm_crypt_request) + cc->iv_size);
+			sizeof(struct dm_crypt_request) + iv_size_padding + cc->iv_size);
 	if (!cc->req_pool) {
 		ti->error =3D "Cannot allocate crypt request mempool";
 		goto bad;
diff --git a/drivers/net/can/at91_can.c b/drivers/net/can/at91_can.c
index 044ea06..ab411c3 100644
--- a/drivers/net/can/at91_can.c
+++ b/drivers/net/can/at91_can.c
@@ -1115,7 +1115,9 @@ static int at91_open(struct net_device *dev)
 	struct at91_priv *priv =3D netdev_priv(dev);
 	int err;
=20
-	clk_enable(priv->clk);
+	err =3D clk_prepare_enable(priv->clk);
+	if (err)
+		return err;
=20
 	/* check or determine and set bittime */
 	err =3D open_candev(dev);
@@ -1139,7 +1141,7 @@ static int at91_open(struct net_device *dev)
  out_close:
 	close_candev(dev);
  out:
-	clk_disable(priv->clk);
+	clk_disable_unprepare(priv->clk);
=20
 	return err;
 }
@@ -1156,7 +1158,7 @@ static int at91_close(struct net_device *dev)
 	at91_chip_stop(dev, CAN_STATE_STOPPED);
=20
 	free_irq(dev->irq, dev);
-	clk_disable(priv->clk);
+	clk_disable_unprepare(priv->clk);
=20
 	close_candev(dev);
=20
diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 7c6bb5a..b1f354f 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -120,7 +120,9 @@
 	(FLEXCAN_ESR_ERR_BUS | FLEXCAN_ESR_ERR_STATE)
=20
 /* FLEXCAN interrupt flag register (IFLAG) bits */
-#define FLEXCAN_TX_BUF_ID		8
+/* Errata ERR005829 step7: Reserve first valid MB */
+#define FLEXCAN_TX_BUF_RESERVED		8
+#define FLEXCAN_TX_BUF_ID		9
 #define FLEXCAN_IFLAG_BUF(x)		BIT(x)
 #define FLEXCAN_IFLAG_RX_FIFO_OVERFLOW	BIT(7)
 #define FLEXCAN_IFLAG_RX_FIFO_WARN	BIT(6)
@@ -131,6 +133,17 @@
=20
 /* FLEXCAN message buffers */
 #define FLEXCAN_MB_CNT_CODE(x)		(((x) & 0xf) << 24)
+#define FLEXCAN_MB_CODE_RX_INACTIVE	(0x0 << 24)
+#define FLEXCAN_MB_CODE_RX_EMPTY	(0x4 << 24)
+#define FLEXCAN_MB_CODE_RX_FULL		(0x2 << 24)
+#define FLEXCAN_MB_CODE_RX_OVERRRUN	(0x6 << 24)
+#define FLEXCAN_MB_CODE_RX_RANSWER	(0xa << 24)
+
+#define FLEXCAN_MB_CODE_TX_INACTIVE	(0x8 << 24)
+#define FLEXCAN_MB_CODE_TX_ABORT	(0x9 << 24)
+#define FLEXCAN_MB_CODE_TX_DATA		(0xc << 24)
+#define FLEXCAN_MB_CODE_TX_TANSWER	(0xe << 24)
+
 #define FLEXCAN_MB_CNT_SRR		BIT(22)
 #define FLEXCAN_MB_CNT_IDE		BIT(21)
 #define FLEXCAN_MB_CNT_RTR		BIT(20)
@@ -302,6 +315,14 @@ static int flexcan_start_xmit(struct sk_buff *skb, str=
uct net_device *dev)
 	flexcan_write(can_id, &regs->cantxfg[FLEXCAN_TX_BUF_ID].can_id);
 	flexcan_write(ctrl, &regs->cantxfg[FLEXCAN_TX_BUF_ID].can_ctrl);
=20
+	/* Errata ERR005829 step8:
+	 * Write twice INACTIVE(0x8) code to first MB.
+	 */
+	flexcan_write(FLEXCAN_MB_CODE_TX_INACTIVE,
+		      &regs->cantxfg[FLEXCAN_TX_BUF_RESERVED].can_ctrl);
+	flexcan_write(FLEXCAN_MB_CODE_TX_INACTIVE,
+		      &regs->cantxfg[FLEXCAN_TX_BUF_RESERVED].can_ctrl);
+
 	kfree_skb(skb);
=20
 	/* tx_packets is incremented in flexcan_irq */
@@ -611,6 +632,9 @@ static irqreturn_t flexcan_irq(int irq, void *dev_id)
 	if (reg_iflag1 & (1 << FLEXCAN_TX_BUF_ID)) {
 		/* tx_bytes is incremented in flexcan_start_xmit */
 		stats->tx_packets++;
+		/* after sending a RTR frame mailbox is in RX mode */
+		flexcan_write(FLEXCAN_MB_CODE_TX_INACTIVE,
+			      &regs->cantxfg[FLEXCAN_TX_BUF_ID].can_ctrl);
 		flexcan_write((1 << FLEXCAN_TX_BUF_ID), &regs->iflag1);
 		netif_wake_queue(dev);
 	}
@@ -668,6 +692,7 @@ static int flexcan_chip_start(struct net_device *dev)
 	struct flexcan_regs __iomem *regs =3D priv->base;
 	int err;
 	u32 reg_mcr, reg_ctrl;
+	int i;
=20
 	/* enable module */
 	flexcan_chip_enable(priv);
@@ -733,8 +758,18 @@ static int flexcan_chip_start(struct net_device *dev)
 	dev_dbg(dev->dev.parent, "%s: writing ctrl=3D0x%08x", __func__, reg_ctrl)=
;
 	flexcan_write(reg_ctrl, &regs->ctrl);
=20
-	/* Abort any pending TX, mark Mailbox as INACTIVE */
-	flexcan_write(FLEXCAN_MB_CNT_CODE(0x4),
+	/* clear and invalidate all mailboxes first */
+	for (i =3D FLEXCAN_TX_BUF_ID; i < ARRAY_SIZE(regs->cantxfg); i++) {
+		flexcan_write(FLEXCAN_MB_CODE_RX_INACTIVE,
+			      &regs->cantxfg[i].can_ctrl);
+	}
+
+	/* Errata ERR005829: mark first TX mailbox as INACTIVE */
+	flexcan_write(FLEXCAN_MB_CODE_TX_INACTIVE,
+		      &regs->cantxfg[FLEXCAN_TX_BUF_RESERVED].can_ctrl);
+
+	/* mark TX mailbox as INACTIVE */
+	flexcan_write(FLEXCAN_MB_CODE_TX_INACTIVE,
 		      &regs->cantxfg[FLEXCAN_TX_BUF_ID].can_ctrl);
=20
 	/* acceptance mask/acceptance code (accept everything) */
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wire=
less/iwlwifi/iwl-agn-rxon.c
index d696536..d552fa3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -440,6 +440,14 @@ int iwlagn_commit_rxon(struct iwl_priv *priv, struct i=
wl_rxon_context *ctx)
 	/* always get timestamp with Rx frame */
 	ctx->staging.flags |=3D RXON_FLG_TSF2HOST_MSK;
=20
+	/*
+	 * force CTS-to-self frames protection if RTS-CTS is not preferred
+	 * one aggregation protection method
+	 */
+	if (!(priv->cfg->ht_params &&
+	      priv->cfg->ht_params->use_rts_for_aggregation))
+		ctx->staging.flags |=3D RXON_FLG_SELF_CTS_EN;
+
 	if ((ctx->vif && ctx->vif->bss_conf.use_short_slot) ||
 	    !(ctx->staging.flags & RXON_FLG_BAND_24G_MSK))
 		ctx->staging.flags |=3D RXON_FLG_SHORT_SLOT_MSK;
@@ -872,6 +880,11 @@ void iwlagn_bss_info_changed(struct ieee80211_hw *hw,
 	else
 		ctx->staging.flags &=3D ~RXON_FLG_TGG_PROTECT_MSK;
=20
+	if (bss_conf->use_cts_prot)
+		ctx->staging.flags |=3D RXON_FLG_SELF_CTS_EN;
+	else
+		ctx->staging.flags &=3D ~RXON_FLG_SELF_CTS_EN;
+
 	memcpy(ctx->staging.bssid_addr, bss_conf->bssid, ETH_ALEN);
=20
 	if (vif->type =3D=3D NL80211_IFTYPE_AP ||
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c b/drivers/net/wire=
less/rtlwifi/rtl8192cu/sw.c
index c184253..1644b1f 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
@@ -316,6 +316,7 @@ static struct usb_device_id rtl8192c_usb_ids[] =3D {
 	{RTL_USB_DEVICE(0x0bda, 0x5088, rtl92cu_hal_cfg)}, /*Thinkware-CC&C*/
 	{RTL_USB_DEVICE(0x0df6, 0x0052, rtl92cu_hal_cfg)}, /*Sitecom - Edimax*/
 	{RTL_USB_DEVICE(0x0df6, 0x005c, rtl92cu_hal_cfg)}, /*Sitecom - Edimax*/
+	{RTL_USB_DEVICE(0x0df6, 0x0070, rtl92cu_hal_cfg)}, /*Sitecom - 150N */
 	{RTL_USB_DEVICE(0x0df6, 0x0077, rtl92cu_hal_cfg)}, /*Sitecom-WLA2100V2*/
 	{RTL_USB_DEVICE(0x0eb0, 0x9071, rtl92cu_hal_cfg)}, /*NO Brand - Etop*/
 	{RTL_USB_DEVICE(0x4856, 0x0091, rtl92cu_hal_cfg)}, /*NetweeN - Feixun*/
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 143bbe4..2794a30 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -718,11 +718,21 @@ __iscsi_conn_send_pdu(struct iscsi_conn *conn, struct=
 iscsi_hdr *hdr,
 			return NULL;
 		}
=20
+		if (data_size > ISCSI_DEF_MAX_RECV_SEG_LEN) {
+			iscsi_conn_printk(KERN_ERR, conn, "Invalid buffer len of %u for login t=
ask. Max len is %u\n", data_size, ISCSI_DEF_MAX_RECV_SEG_LEN);
+			return NULL;
+		}
+
 		task =3D conn->login_task;
 	} else {
 		if (session->state !=3D ISCSI_STATE_LOGGED_IN)
 			return NULL;
=20
+		if (data_size !=3D 0) {
+			iscsi_conn_printk(KERN_ERR, conn, "Can not send data buffer of len %u f=
or op 0x%x\n", data_size, opcode);
+			return NULL;
+		}
+
 		BUG_ON(conn->c_stage =3D=3D ISCSI_CONN_INITIAL_STAGE);
 		BUG_ON(conn->c_stage =3D=3D ISCSI_CONN_STOPPED);
=20
diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/isc=
si_target.c
index ab5dd16..ae4e7da 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -4306,6 +4306,7 @@ static void iscsit_logout_post_handler_diffcid(
 {
 	struct iscsi_conn *l_conn;
 	struct iscsi_session *sess =3D conn->sess;
+	bool conn_found =3D false;
=20
 	if (!sess)
 		return;
@@ -4314,12 +4315,13 @@ static void iscsit_logout_post_handler_diffcid(
 	list_for_each_entry(l_conn, &sess->sess_conn_list, conn_list) {
 		if (l_conn->cid =3D=3D cid) {
 			iscsit_inc_conn_usage_count(l_conn);
+			conn_found =3D true;
 			break;
 		}
 	}
 	spin_unlock_bh(&sess->conn_lock);
=20
-	if (!l_conn)
+	if (!conn_found)
 		return;
=20
 	if (l_conn->sock)
diff --git a/drivers/target/iscsi/iscsi_target_parameters.c b/drivers/targe=
t/iscsi/iscsi_target_parameters.c
index db313ba..e5f5bff 100644
--- a/drivers/target/iscsi/iscsi_target_parameters.c
+++ b/drivers/target/iscsi/iscsi_target_parameters.c
@@ -552,7 +552,7 @@ int iscsi_copy_param_list(
 	param_list =3D kzalloc(sizeof(struct iscsi_param_list), GFP_KERNEL);
 	if (!param_list) {
 		pr_err("Unable to allocate memory for struct iscsi_param_list.\n");
-		goto err_out;
+		return -1;
 	}
 	INIT_LIST_HEAD(&param_list->param_list);
 	INIT_LIST_HEAD(&param_list->extra_response_list);
diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index f08732b..10aec1a 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -3651,9 +3651,10 @@ static void hub_events(void)
=20
 		hub =3D list_entry(tmp, struct usb_hub, event_list);
 		kref_get(&hub->kref);
+		hdev =3D hub->hdev;
+		usb_get_dev(hdev);
 		spin_unlock_irq(&hub_event_lock);
=20
-		hdev =3D hub->hdev;
 		hub_dev =3D hub->intfdev;
 		intf =3D to_usb_interface(hub_dev);
 		dev_dbg(hub_dev, "state %d ports %d chg %04x evt %04x\n",
@@ -3888,6 +3889,7 @@ static void hub_events(void)
 		usb_autopm_put_interface(intf);
  loop_disconnected:
 		usb_unlock_device(hdev);
+		usb_put_dev(hdev);
 		kref_put(&hub->kref, hub_release);
=20
         } /* end while (1) */
diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index 600d823..3d9b57e 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -427,9 +427,6 @@ static int __devexit dwc3_remove(struct platform_device=
 *pdev)
=20
 	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
=20
-	pm_runtime_put(&pdev->dev);
-	pm_runtime_disable(&pdev->dev);
-
 	dwc3_debugfs_exit(dwc);
=20
 	if (features & DWC3_HAS_PERIPHERAL)
@@ -440,6 +437,9 @@ static int __devexit dwc3_remove(struct platform_device=
 *pdev)
 	iounmap(dwc->regs);
 	kfree(dwc->mem);
=20
+	pm_runtime_put_sync(&pdev->dev);
+	pm_runtime_disable(&pdev->dev);
+
 	return 0;
 }
=20
diff --git a/drivers/usb/host/xhci-hub.c b/drivers/usb/host/xhci-hub.c
index 517cadb..a3b569f 100644
--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -440,7 +440,8 @@ void xhci_test_and_clear_bit(struct xhci_hcd *xhci, __l=
e32 __iomem **port_array,
 }
=20
 /* Updates Link Status for super Speed port */
-static void xhci_hub_report_link_state(u32 *status, u32 status_reg)
+static void xhci_hub_report_link_state(struct xhci_hcd *xhci,
+		u32 *status, u32 status_reg)
 {
 	u32 pls =3D status_reg & PORT_PLS_MASK;
=20
@@ -479,7 +480,8 @@ static void xhci_hub_report_link_state(u32 *status, u32=
 status_reg)
 		 * in which sometimes the port enters compliance mode
 		 * caused by a delay on the host-device negotiation.
 		 */
-		if (pls =3D=3D USB_SS_PORT_LS_COMP_MOD)
+		if ((xhci->quirks & XHCI_COMP_MODE_QUIRK) &&
+				(pls =3D=3D USB_SS_PORT_LS_COMP_MOD))
 			pls |=3D USB_PORT_STAT_CONNECTION;
 	}
=20
@@ -655,7 +657,7 @@ int xhci_hub_control(struct usb_hcd *hcd, u16 typeReq, =
u16 wValue,
 		}
 		/* Update Port Link State for super speed ports*/
 		if (hcd->speed =3D=3D HCD_USB3) {
-			xhci_hub_report_link_state(&status, temp);
+			xhci_hub_report_link_state(xhci, &status, temp);
 			/*
 			 * Verify if all USB3 Ports Have entered U0 already.
 			 * Delete Compliance Mode Timer if so.
diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
index 74922b9..0f4a41d 100644
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -1723,7 +1723,7 @@ void xhci_mem_cleanup(struct xhci_hcd *xhci)
 	}
=20
 	num_ports =3D HCS_MAX_PORTS(xhci->hcs_params1);
-	for (i =3D 0; i < num_ports; i++) {
+	for (i =3D 0; i < num_ports && xhci->rh_bw; i++) {
 		struct xhci_interval_bw_table *bwt =3D &xhci->rh_bw[i].bw_table;
 		for (j =3D 0; j < XHCI_MAX_INTERVAL; j++) {
 			struct list_head *ep =3D &bwt->interval_bw[j].endpoints;
diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 0d34f85..8fe5c13 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -752,6 +752,7 @@ static struct usb_device_id id_table_combined [] =3D {
 	{ USB_DEVICE(FTDI_VID, FTDI_NDI_AURORA_SCU_PID),
 		.driver_info =3D (kernel_ulong_t)&ftdi_NDI_device_quirk },
 	{ USB_DEVICE(TELLDUS_VID, TELLDUS_TELLSTICK_PID) },
+	{ USB_DEVICE(NOVITUS_VID, NOVITUS_BONO_E_PID) },
 	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_USB_S03_PID) },
 	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_USB_59_PID) },
 	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_USB_57A_PID) },
@@ -961,6 +962,8 @@ static struct usb_device_id id_table_combined [] =3D {
 	{ USB_DEVICE(BRAINBOXES_VID, BRAINBOXES_US_842_4_PID) },
 	/* ekey Devices */
 	{ USB_DEVICE(FTDI_VID, FTDI_EKEY_CONV_USB_PID) },
+	/* GE Healthcare devices */
+	{ USB_DEVICE(GE_HEALTHCARE_VID, GE_HEALTHCARE_NEMO_TRACKER_PID) },
 	{ },					/* Optional parameter entry */
 	{ }					/* Terminating entry */
 };
diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_si=
o_ids.h
index cbcb1e6..bd509de 100644
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -831,6 +831,12 @@
 #define TELLDUS_TELLSTICK_PID		0x0C30	/* RF control dongle 433 MHz using F=
T232RL */
=20
 /*
+ * NOVITUS printers
+ */
+#define NOVITUS_VID			0x1a28
+#define NOVITUS_BONO_E_PID		0x6010
+
+/*
  * RT Systems programming cables for various ham radios
  */
 #define RTSYSTEMS_VID		0x2100	/* Vendor ID */
@@ -1379,3 +1385,9 @@
  * ekey biometric systems GmbH (http://ekey.net/)
  */
 #define FTDI_EKEY_CONV_USB_PID		0xCB08	/* Converter USB */
+
+/*
+ * GE Healthcare devices
+ */
+#define GE_HEALTHCARE_VID		0x1901
+#define GE_HEALTHCARE_NEMO_TRACKER_PID	0x0015
diff --git a/drivers/usb/serial/sierra.c b/drivers/usb/serial/sierra.c
index 0d26ab6..db9e54a 100644
--- a/drivers/usb/serial/sierra.c
+++ b/drivers/usb/serial/sierra.c
@@ -296,14 +296,19 @@ static const struct usb_device_id id_table[] =3D {
 	{ USB_DEVICE(0x1199, 0x68A2),   /* Sierra Wireless MC77xx in QMI mode */
 	  .driver_info =3D (kernel_ulong_t)&direct_ip_interface_blacklist
 	},
-	{ USB_DEVICE(0x1199, 0x68A3), 	/* Sierra Wireless Direct IP modems */
+	/* Sierra Wireless Direct IP modems */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x1199, 0x68A3, 0xFF, 0xFF, 0xFF),
+	  .driver_info =3D (kernel_ulong_t)&direct_ip_interface_blacklist
+	},
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x1199, 0x68AA, 0xFF, 0xFF, 0xFF),
 	  .driver_info =3D (kernel_ulong_t)&direct_ip_interface_blacklist
 	},
 	/* AT&T Direct IP LTE modems */
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x0F3D, 0x68AA, 0xFF, 0xFF, 0xFF),
 	  .driver_info =3D (kernel_ulong_t)&direct_ip_interface_blacklist
 	},
-	{ USB_DEVICE(0x0f3d, 0x68A3), 	/* Airprime/Sierra Wireless Direct IP mode=
ms */
+	/* Airprime/Sierra Wireless Direct IP modems */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x0F3D, 0x68A3, 0xFF, 0xFF, 0xFF),
 	  .driver_info =3D (kernel_ulong_t)&direct_ip_interface_blacklist
 	},
=20
diff --git a/drivers/usb/storage/unusual_devs.h b/drivers/usb/storage/unusu=
al_devs.h
index e588a11..a6c4c7d 100644
--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -93,6 +93,12 @@ UNUSUAL_DEV(  0x03f0, 0x4002, 0x0001, 0x0001,
 		"PhotoSmart R707",
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL, US_FL_FIX_CAPACITY),
=20
+UNUSUAL_DEV(  0x03f3, 0x0001, 0x0000, 0x9999,
+		"Adaptec",
+		"USBConnect 2000",
+		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_euscsi_init,
+		US_FL_SCM_MULT_TARG ),
+
 /* Reported by Sebastian Kapfer <sebastian_kapfer@gmx.net>
  * and Olaf Hering <olh@suse.de> (different bcd's, same vendor/product)
  * for USB floppies that need the SINGLE_LUN enforcement.
@@ -733,6 +739,12 @@ UNUSUAL_DEV(  0x059b, 0x0001, 0x0100, 0x0100,
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_SINGLE_LUN ),
=20
+UNUSUAL_DEV(  0x059b, 0x0040, 0x0100, 0x0100,
+		"Iomega",
+		"Jaz USB Adapter",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_SINGLE_LUN ),
+
 /* Reported by <Hendryk.Pfeiffer@gmx.de> */
 UNUSUAL_DEV(  0x059f, 0x0643, 0x0000, 0x0000,
 		"LaCie",
@@ -1105,6 +1117,18 @@ UNUSUAL_DEV(  0x0851, 0x1543, 0x0200, 0x0200,
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_NOT_LOCKABLE),
=20
+UNUSUAL_DEV(  0x085a, 0x0026, 0x0100, 0x0133,
+		"Xircom",
+		"PortGear USB-SCSI (Mac USB Dock)",
+		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_euscsi_init,
+		US_FL_SCM_MULT_TARG ),
+
+UNUSUAL_DEV(  0x085a, 0x0028, 0x0100, 0x0133,
+		"Xircom",
+		"PortGear USB to SCSI Converter",
+		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_euscsi_init,
+		US_FL_SCM_MULT_TARG ),
+
 /* Submitted by Jan De Luyck <lkml@kcore.org> */
 UNUSUAL_DEV(  0x08bd, 0x1100, 0x0000, 0x0000,
 		"CITIZEN",
@@ -1932,6 +1956,14 @@ UNUSUAL_DEV(  0x152d, 0x2329, 0x0100, 0x0100,
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_IGNORE_RESIDUE | US_FL_SANE_SENSE ),
=20
+/* Entrega Technologies U1-SC25 (later Xircom PortGear PGSCSI)
+ * and Mac USB Dock USB-SCSI */
+UNUSUAL_DEV(  0x1645, 0x0007, 0x0100, 0x0133,
+		"Entrega Technologies",
+		"USB to SCSI Converter",
+		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_euscsi_init,
+		US_FL_SCM_MULT_TARG ),
+
 /* Reported by Robert Schedel <r.schedel@yahoo.de>
  * Note: this is a 'super top' device like the above 14cd/6600 device */
 UNUSUAL_DEV(  0x1652, 0x6600, 0x0201, 0x0201,
@@ -1947,6 +1979,12 @@ UNUSUAL_DEV(  0x177f, 0x0400, 0x0000, 0x0000,
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_BULK_IGNORE_TAG | US_FL_MAX_SECTORS_64 ),
=20
+UNUSUAL_DEV(  0x1822, 0x0001, 0x0000, 0x9999,
+		"Ariston Technologies",
+		"iConnect USB to SCSI adapter",
+		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_euscsi_init,
+		US_FL_SCM_MULT_TARG ),
+
 /* Reported by Hans de Goede <hdegoede@redhat.com>
  * These Appotech controllers are found in Picture Frames, they provide a
  * (buggy) emulation of a cdrom drive which contains the windows software
diff --git a/drivers/uwb/lc-dev.c b/drivers/uwb/lc-dev.c
index 5241f1d..3c9e929 100644
--- a/drivers/uwb/lc-dev.c
+++ b/drivers/uwb/lc-dev.c
@@ -441,16 +441,19 @@ void uwbd_dev_onair(struct uwb_rc *rc, struct uwb_bec=
a_e *bce)
 	uwb_dev->mac_addr =3D *bce->mac_addr;
 	uwb_dev->dev_addr =3D bce->dev_addr;
 	dev_set_name(&uwb_dev->dev, macbuf);
+
+	/* plug the beacon cache */
+	bce->uwb_dev =3D uwb_dev;
+	uwb_dev->bce =3D bce;
+	uwb_bce_get(bce);		/* released in uwb_dev_sys_release() */
+
 	result =3D uwb_dev_add(uwb_dev, &rc->uwb_dev.dev, rc);
 	if (result < 0) {
 		dev_err(dev, "new device %s: cannot instantiate device\n",
 			macbuf);
 		goto error_dev_add;
 	}
-	/* plug the beacon cache */
-	bce->uwb_dev =3D uwb_dev;
-	uwb_dev->bce =3D bce;
-	uwb_bce_get(bce);		/* released in uwb_dev_sys_release() */
+
 	dev_info(dev, "uwb device (mac %s dev %s) connected to %s %s\n",
 		 macbuf, devbuf, rc->uwb_dev.dev.parent->bus->name,
 		 dev_name(rc->uwb_dev.dev.parent));
@@ -458,6 +461,8 @@ void uwbd_dev_onair(struct uwb_rc *rc, struct uwb_beca_=
e *bce)
 	return;
=20
 error_dev_add:
+	bce->uwb_dev =3D NULL;
+	uwb_bce_put(bce);
 	kfree(uwb_dev);
 	return;
 }
diff --git a/drivers/xen/manage.c b/drivers/xen/manage.c
index c8af7e5..6548417 100644
--- a/drivers/xen/manage.c
+++ b/drivers/xen/manage.c
@@ -108,16 +108,11 @@ static void do_suspend(void)
=20
 	shutting_down =3D SHUTDOWN_SUSPEND;
=20
-#ifdef CONFIG_PREEMPT
-	/* If the kernel is preemptible, we need to freeze all the processes
-	   to prevent them from being in the middle of a pagetable update
-	   during suspend. */
 	err =3D freeze_processes();
 	if (err) {
 		printk(KERN_ERR "xen suspend: freeze failed %d\n", err);
 		goto out;
 	}
-#endif
=20
 	err =3D dpm_suspend_start(PMSG_FREEZE);
 	if (err) {
@@ -172,10 +167,8 @@ out_resume:
 	clock_was_set();
=20
 out_thaw:
-#ifdef CONFIG_PREEMPT
 	thaw_processes();
 out:
-#endif
 	shutting_down =3D SHUTDOWN_INVALID;
 }
 #endif	/* CONFIG_HIBERNATE_CALLBACKS */
diff --git a/fs/aio.c b/fs/aio.c
index 8cdd8ea..9acfd07 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1102,6 +1102,13 @@ static int aio_read_evt(struct kioctx *ioctx, struct=
 io_event *ent)
 	head =3D ring->head % info->nr;
 	if (head !=3D ring->tail) {
 		struct io_event *evp =3D aio_ring_event(info, head, KM_USER1);
+
+		/*
+		 * Ensure that once we've read the current tail pointer, that
+		 * we also see the events that were stored up to the tail.
+		 */
+		smp_rmb();
+
 		*ent =3D *evp;
 		head =3D (head + 1) % info->nr;
 		smp_mb(); /* finish reading the event before updatng the head */
diff --git a/fs/buffer.c b/fs/buffer.c
index 5f4bde2..59496e7 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -1021,7 +1021,8 @@ grow_dev_page(struct block_device *bdev, sector_t blo=
ck,
 		bh =3D page_buffers(page);
 		if (bh->b_size =3D=3D size) {
 			end_block =3D init_page_buffers(page, bdev,
-						index << sizebits, size);
+						(sector_t)index << sizebits,
+						size);
 			goto done;
 		}
 		if (!try_to_free_buffers(page))
@@ -1042,7 +1043,8 @@ grow_dev_page(struct block_device *bdev, sector_t blo=
ck,
 	 */
 	spin_lock(&inode->i_mapping->private_lock);
 	link_dev_buffers(page, bh);
-	end_block =3D init_page_buffers(page, bdev, index << sizebits, size);
+	end_block =3D init_page_buffers(page, bdev, (sector_t)index << sizebits,
+			size);
 	spin_unlock(&inode->i_mapping->private_lock);
 done:
 	ret =3D (block < end_block) ? 1 : -ENXIO;
diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 91a6945..5a45b8f 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -619,6 +619,8 @@ static int ext2_get_blocks(struct inode *inode,
 	int count =3D 0;
 	ext2_fsblk_t first_block =3D 0;
=20
+	BUG_ON(maxblocks =3D=3D 0);
+
 	depth =3D ext2_block_to_path(inode,iblock,offsets,&blocks_to_boundary);
=20
 	if (depth =3D=3D 0)
diff --git a/fs/ext2/xip.c b/fs/ext2/xip.c
index 322a56b..af014bb 100644
--- a/fs/ext2/xip.c
+++ b/fs/ext2/xip.c
@@ -37,6 +37,7 @@ __ext2_get_block(struct inode *inode, pgoff_t pgoff, int =
create,
 	int rc;
=20
 	memset(&tmp, 0, sizeof(struct buffer_head));
+	tmp.b_size =3D 1 << inode->i_blkbits;
 	rc =3D ext2_get_block(inode, pgoff, &tmp, create);
 	*result =3D tmp.b_blocknr;
=20
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 818b43e..5baa7ba 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1312,6 +1312,8 @@ static void mb_free_blocks(struct inode *inode, struc=
t ext4_buddy *e4b,
 	void *buddy2;
 	struct super_block *sb =3D e4b->bd_sb;
=20
+	if (WARN_ON(count =3D=3D 0))
+		return;
 	BUG_ON(first + count > (sb->s_blocksize << 3));
 	assert_spin_locked(ext4_group_lock_ptr(sb, e4b->bd_group));
 	mb_check_buddy(e4b);
@@ -3132,6 +3134,8 @@ static void ext4_discard_allocated_blocks(struct ext4=
_allocation_context *ac)
 	int err;
=20
 	if (pa =3D=3D NULL) {
+		if (ac->ac_f_ex.fe_len =3D=3D 0)
+			return;
 		err =3D ext4_mb_load_buddy(ac->ac_sb, ac->ac_f_ex.fe_group, &e4b);
 		if (err) {
 			/*
@@ -3146,6 +3150,7 @@ static void ext4_discard_allocated_blocks(struct ext4=
_allocation_context *ac)
 		mb_free_blocks(ac->ac_inode, &e4b, ac->ac_f_ex.fe_start,
 			       ac->ac_f_ex.fe_len);
 		ext4_unlock_group(ac->ac_sb, ac->ac_f_ex.fe_group);
+		ext4_mb_unload_buddy(&e4b);
 		return;
 	}
 	if (pa->pa_type =3D=3D MB_INODE_PA)
diff --git a/fs/namei.c b/fs/namei.c
index 9680cef..dea2dab 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -554,24 +554,22 @@ static int complete_walk(struct nameidata *nd)
=20
 static __always_inline void set_root(struct nameidata *nd)
 {
-	if (!nd->root.mnt)
-		get_fs_root(current->fs, &nd->root);
+	get_fs_root(current->fs, &nd->root);
 }
=20
 static int link_path_walk(const char *, struct nameidata *);
=20
-static __always_inline void set_root_rcu(struct nameidata *nd)
+static __always_inline unsigned set_root_rcu(struct nameidata *nd)
 {
-	if (!nd->root.mnt) {
-		struct fs_struct *fs =3D current->fs;
-		unsigned seq;
+	struct fs_struct *fs =3D current->fs;
+	unsigned seq, res;
=20
-		do {
-			seq =3D read_seqcount_begin(&fs->seq);
-			nd->root =3D fs->root;
-			nd->seq =3D __read_seqcount_begin(&nd->root.dentry->d_seq);
-		} while (read_seqcount_retry(&fs->seq, seq));
-	}
+	do {
+		seq =3D read_seqcount_begin(&fs->seq);
+		nd->root =3D fs->root;
+		res =3D __read_seqcount_begin(&nd->root.dentry->d_seq);
+	} while (read_seqcount_retry(&fs->seq, seq));
+	return res;
 }
=20
 static __always_inline int __vfs_follow_link(struct nameidata *nd, const c=
har *link)
@@ -582,7 +580,8 @@ static __always_inline int __vfs_follow_link(struct nam=
eidata *nd, const char *l
 		goto fail;
=20
 	if (*link =3D=3D '/') {
-		set_root(nd);
+		if (!nd->root.mnt)
+			set_root(nd);
 		path_put(&nd->path);
 		nd->path =3D nd->root;
 		path_get(&nd->root);
@@ -912,22 +911,11 @@ static bool __follow_mount_rcu(struct nameidata *nd, =
struct path *path,
 	return true;
 }
=20
-static void follow_mount_rcu(struct nameidata *nd)
-{
-	while (d_mountpoint(nd->path.dentry)) {
-		struct vfsmount *mounted;
-		mounted =3D __lookup_mnt(nd->path.mnt, nd->path.dentry, 1);
-		if (!mounted)
-			break;
-		nd->path.mnt =3D mounted;
-		nd->path.dentry =3D mounted->mnt_root;
-		nd->seq =3D read_seqcount_begin(&nd->path.dentry->d_seq);
-	}
-}
-
 static int follow_dotdot_rcu(struct nameidata *nd)
 {
-	set_root_rcu(nd);
+	struct inode *inode =3D nd->inode;
+	if (!nd->root.mnt)
+		set_root_rcu(nd);
=20
 	while (1) {
 		if (nd->path.dentry =3D=3D nd->root.dentry &&
@@ -939,6 +927,7 @@ static int follow_dotdot_rcu(struct nameidata *nd)
 			struct dentry *parent =3D old->d_parent;
 			unsigned seq;
=20
+			inode =3D parent->d_inode;
 			seq =3D read_seqcount_begin(&parent->d_seq);
 			if (read_seqcount_retry(&old->d_seq, nd->seq))
 				goto failed;
@@ -948,10 +937,20 @@ static int follow_dotdot_rcu(struct nameidata *nd)
 		}
 		if (!follow_up_rcu(&nd->path))
 			break;
+		inode =3D nd->path.dentry->d_inode;
 		nd->seq =3D read_seqcount_begin(&nd->path.dentry->d_seq);
 	}
-	follow_mount_rcu(nd);
-	nd->inode =3D nd->path.dentry->d_inode;
+	while (d_mountpoint(nd->path.dentry)) {
+		struct vfsmount *mounted;
+		mounted =3D __lookup_mnt(nd->path.mnt, nd->path.dentry, 1);
+		if (!mounted)
+			break;
+		nd->path.mnt =3D mounted;
+		nd->path.dentry =3D mounted->mnt_root;
+		inode =3D nd->path.dentry->d_inode;
+		nd->seq =3D read_seqcount_begin(&nd->path.dentry->d_seq);
+	}
+	nd->inode =3D inode;
 	return 0;
=20
 failed:
@@ -1030,7 +1029,8 @@ static void follow_mount(struct path *path)
=20
 static void follow_dotdot(struct nameidata *nd)
 {
-	set_root(nd);
+	if (!nd->root.mnt)
+		set_root(nd);
=20
 	while(1) {
 		struct dentry *old =3D nd->path.dentry;
@@ -1504,7 +1504,7 @@ static int path_init(int dfd, const char *name, unsig=
ned int flags,
 		if (flags & LOOKUP_RCU) {
 			br_read_lock(vfsmount_lock);
 			rcu_read_lock();
-			set_root_rcu(nd);
+			nd->seq =3D set_root_rcu(nd);
 		} else {
 			set_root(nd);
 			path_get(&nd->root);
@@ -1560,7 +1560,14 @@ static int path_init(int dfd, const char *name, unsi=
gned int flags,
 	}
=20
 	nd->inode =3D nd->path.dentry->d_inode;
-	return 0;
+	if (!(flags & LOOKUP_RCU))
+		return 0;
+	if (likely(!read_seqcount_retry(&nd->path.dentry->d_seq, nd->seq)))
+		return 0;
+	if (!(nd->flags & LOOKUP_ROOT))
+		nd->root.mnt =3D NULL;
+	rcu_read_unlock();
+	return -ECHILD;
=20
 fput_fail:
 	fput_light(file, fput_needed);
diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index c4a2a68..61a1303 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -2015,23 +2015,23 @@ static void nfs4_close_prepare(struct rpc_task *tas=
k, void *data)
 	is_rdwr =3D test_bit(NFS_O_RDWR_STATE, &state->flags);
 	is_rdonly =3D test_bit(NFS_O_RDONLY_STATE, &state->flags);
 	is_wronly =3D test_bit(NFS_O_WRONLY_STATE, &state->flags);
-	/* Calculate the current open share mode */
-	calldata->arg.fmode =3D 0;
-	if (is_rdonly || is_rdwr)
-		calldata->arg.fmode |=3D FMODE_READ;
-	if (is_wronly || is_rdwr)
-		calldata->arg.fmode |=3D FMODE_WRITE;
 	/* Calculate the change in open mode */
+	calldata->arg.fmode =3D 0;
 	if (state->n_rdwr =3D=3D 0) {
-		if (state->n_rdonly =3D=3D 0) {
-			call_close |=3D is_rdonly || is_rdwr;
-			calldata->arg.fmode &=3D ~FMODE_READ;
-		}
-		if (state->n_wronly =3D=3D 0) {
-			call_close |=3D is_wronly || is_rdwr;
-			calldata->arg.fmode &=3D ~FMODE_WRITE;
-		}
-	}
+		if (state->n_rdonly =3D=3D 0)
+			call_close |=3D is_rdonly;
+		else if (is_rdonly)
+			calldata->arg.fmode |=3D FMODE_READ;
+		if (state->n_wronly =3D=3D 0)
+			call_close |=3D is_wronly;
+		else if (is_wronly)
+			calldata->arg.fmode |=3D FMODE_WRITE;
+	} else if (is_rdwr)
+		calldata->arg.fmode |=3D FMODE_READ|FMODE_WRITE;
+
+	if (calldata->arg.fmode =3D=3D 0)
+		call_close |=3D is_rdwr;
+
 	spin_unlock(&state->owner->so_lock);
=20
 	if (!call_close) {
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 11e1888..e2e7914 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -508,6 +508,9 @@ set_nfsv4_acl_one(struct dentry *dentry, struct posix_a=
cl *pacl, char *key)
 	char *buf =3D NULL;
 	int error =3D 0;
=20
+	if (!pacl)
+		return vfs_setxattr(dentry, key, NULL, 0, 0);
+
 	buflen =3D posix_acl_xattr_size(pacl->a_count);
 	buf =3D kmalloc(buflen, GFP_KERNEL);
 	error =3D -ENOMEM;
diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index edeb239..b2d8a96 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -24,6 +24,7 @@
 #include <linux/buffer_head.h>
 #include <linux/gfp.h>
 #include <linux/mpage.h>
+#include <linux/pagemap.h>
 #include <linux/writeback.h>
 #include <linux/uio.h>
 #include "nilfs.h"
@@ -195,10 +196,10 @@ static int nilfs_writepage(struct page *page, struct =
writeback_control *wbc)
=20
 static int nilfs_set_page_dirty(struct page *page)
 {
+	struct inode *inode =3D page->mapping->host;
 	int ret =3D __set_page_dirty_nobuffers(page);
=20
 	if (page_has_buffers(page)) {
-		struct inode *inode =3D page->mapping->host;
 		unsigned nr_dirty =3D 0;
 		struct buffer_head *bh, *head;
=20
@@ -221,6 +222,10 @@ static int nilfs_set_page_dirty(struct page *page)
=20
 		if (nr_dirty)
 			nilfs_set_file_dirty(inode, nr_dirty);
+	} else if (ret) {
+		unsigned nr_dirty =3D 1 << (PAGE_CACHE_SHIFT - inode->i_blkbits);
+
+		nilfs_set_file_dirty(inode, nr_dirty);
 	}
 	return ret;
 }
diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index 005261c..dbc372e 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -653,12 +653,9 @@ void dlm_lockres_clear_refmap_bit(struct dlm_ctxt *dlm=
,
 	clear_bit(bit, res->refmap);
 }
=20
-
-void dlm_lockres_grab_inflight_ref(struct dlm_ctxt *dlm,
+static void __dlm_lockres_grab_inflight_ref(struct dlm_ctxt *dlm,
 				   struct dlm_lock_resource *res)
 {
-	assert_spin_locked(&res->spinlock);
-
 	res->inflight_locks++;
=20
 	mlog(0, "%s: res %.*s, inflight++: now %u, %ps()\n", dlm->name,
@@ -666,6 +663,13 @@ void dlm_lockres_grab_inflight_ref(struct dlm_ctxt *dl=
m,
 	     __builtin_return_address(0));
 }
=20
+void dlm_lockres_grab_inflight_ref(struct dlm_ctxt *dlm,
+				   struct dlm_lock_resource *res)
+{
+	assert_spin_locked(&res->spinlock);
+	__dlm_lockres_grab_inflight_ref(dlm, res);
+}
+
 void dlm_lockres_drop_inflight_ref(struct dlm_ctxt *dlm,
 				   struct dlm_lock_resource *res)
 {
@@ -855,10 +859,8 @@ lookup:
 	/* finally add the lockres to its hash bucket */
 	__dlm_insert_lockres(dlm, res);
=20
-	/* Grab inflight ref to pin the resource */
-	spin_lock(&res->spinlock);
-	dlm_lockres_grab_inflight_ref(dlm, res);
-	spin_unlock(&res->spinlock);
+	/* since this lockres is new it doesn't not require the spinlock */
+	__dlm_lockres_grab_inflight_ref(dlm, res);
=20
 	/* get an extra ref on the mle in case this is a BLOCK
 	 * if so, the creator of the BLOCK may try to put the last
diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index 1ef15cc..18c58e5 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -361,6 +361,7 @@ static const struct attribute_group *part_attr_groups[]=
 =3D {
 static void part_release(struct device *dev)
 {
 	struct hd_struct *p =3D dev_to_part(dev);
+	blk_free_devt(dev->devt);
 	free_part_stats(p);
 	free_part_info(p);
 	kfree(p);
@@ -403,7 +404,6 @@ void delete_partition(struct gendisk *disk, int partno)
 	rcu_assign_pointer(ptbl->last_lookup, NULL);
 	kobject_put(part->holder_dir);
 	device_del(part_to_dev(part));
-	blk_free_devt(part_devt(part));
=20
 	hd_struct_put(part);
 }
diff --git a/include/linux/alarmtimer.h b/include/linux/alarmtimer.h
index 975009e..9a9838a 100644
--- a/include/linux/alarmtimer.h
+++ b/include/linux/alarmtimer.h
@@ -48,6 +48,7 @@ int alarm_try_to_cancel(struct alarm *alarm);
 int alarm_cancel(struct alarm *alarm);
=20
 u64 alarm_forward(struct alarm *alarm, ktime_t now, ktime_t interval);
+ktime_t alarm_expires_remaining(const struct alarm *alarm);
=20
 /*
  * A alarmtimer is active, when it is enqueued into timerqueue or the
diff --git a/include/linux/ceph/messenger.h b/include/linux/ceph/messenger.=
h
index ffbeb2c..5b6efef 100644
--- a/include/linux/ceph/messenger.h
+++ b/include/linux/ceph/messenger.h
@@ -92,7 +92,7 @@ struct ceph_msg {
 	bool front_is_vmalloc;
 	bool more_to_follow;
 	bool needs_out_seq;
-	int front_max;
+	int front_alloc_len;
 	unsigned long ack_stamp;        /* tx: when we were acked */
=20
 	struct ceph_msgpool *pool;
diff --git a/include/linux/jiffies.h b/include/linux/jiffies.h
index f5df3dc..f4e8578 100644
--- a/include/linux/jiffies.h
+++ b/include/linux/jiffies.h
@@ -259,23 +259,11 @@ extern unsigned long preset_lpj;
 #define SEC_JIFFIE_SC (32 - SHIFT_HZ)
 #endif
 #define NSEC_JIFFIE_SC (SEC_JIFFIE_SC + 29)
-#define USEC_JIFFIE_SC (SEC_JIFFIE_SC + 19)
 #define SEC_CONVERSION ((unsigned long)((((u64)NSEC_PER_SEC << SEC_JIFFIE_=
SC) +\
                                 TICK_NSEC -1) / (u64)TICK_NSEC))
=20
 #define NSEC_CONVERSION ((unsigned long)((((u64)1 << NSEC_JIFFIE_SC) +\
                                         TICK_NSEC -1) / (u64)TICK_NSEC))
-#define USEC_CONVERSION  \
-                    ((unsigned long)((((u64)NSEC_PER_USEC << USEC_JIFFIE_S=
C) +\
-                                        TICK_NSEC -1) / (u64)TICK_NSEC))
-/*
- * USEC_ROUND is used in the timeval to jiffie conversion.  See there
- * for more details.  It is the scaled resolution rounding value.  Note
- * that it is a 64-bit value.  Since, when it is applied, we are already
- * in jiffies (albit scaled), it is nothing but the bits we will shift
- * off.
- */
-#define USEC_ROUND (u64)(((u64)1 << USEC_JIFFIE_SC) - 1)
 /*
  * The maximum jiffie value is (MAX_INT >> 1).  Here we translate that
  * into seconds.  The 64-bit case will overflow if we are not careful,
diff --git a/include/net/regulatory.h b/include/net/regulatory.h
index eb7d3c2..c3c22e0 100644
--- a/include/net/regulatory.h
+++ b/include/net/regulatory.h
@@ -92,7 +92,7 @@ struct ieee80211_reg_rule {
=20
 struct ieee80211_regdomain {
 	u32 n_reg_rules;
-	char alpha2[2];
+	char alpha2[3];
 	struct ieee80211_reg_rule reg_rules[];
 };
=20
diff --git a/include/net/sctp/sctp.h b/include/net/sctp/sctp.h
index ad03988..e0f1c91 100644
--- a/include/net/sctp/sctp.h
+++ b/include/net/sctp/sctp.h
@@ -523,6 +523,11 @@ static inline void sctp_assoc_pending_pmtu(struct sctp=
_association *asoc)
 	asoc->pmtu_pending =3D 0;
 }
=20
+static inline bool sctp_chunk_pending(const struct sctp_chunk *chunk)
+{
+	return !list_empty(&chunk->list);
+}
+
 /* Walk through a list of TLV parameters.  Don't trust the
  * individual parameter lengths and instead depend on
  * the chunk length to indicate when to stop.  Make sure
diff --git a/include/net/sctp/sm.h b/include/net/sctp/sm.h
index 9148632..4d1be75 100644
--- a/include/net/sctp/sm.h
+++ b/include/net/sctp/sm.h
@@ -251,9 +251,9 @@ struct sctp_chunk *sctp_make_asconf_update_ip(struct sc=
tp_association *,
 					      int, __be16);
 struct sctp_chunk *sctp_make_asconf_set_prim(struct sctp_association *asoc=
,
 					     union sctp_addr *addr);
-int sctp_verify_asconf(const struct sctp_association *asoc,
-		       struct sctp_paramhdr *param_hdr, void *chunk_end,
-		       struct sctp_paramhdr **errp);
+bool sctp_verify_asconf(const struct sctp_association *asoc,
+			struct sctp_chunk *chunk, bool addr_param_needed,
+			struct sctp_paramhdr **errp);
 struct sctp_chunk *sctp_process_asconf(struct sctp_association *asoc,
 				       struct sctp_chunk *asconf);
 int sctp_process_asconf_ack(struct sctp_association *asoc,
diff --git a/init/Kconfig b/init/Kconfig
index 43298f9..b8dc1de 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -555,6 +555,7 @@ config LOG_BUF_SHIFT
 	int "Kernel log buffer size (16 =3D> 64KB, 17 =3D> 128KB)"
 	range 12 21
 	default 17
+	depends on PRINTK
 	help
 	  Select kernel log buffer size as a power of 2.
 	  Examples:
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 93fc15e..ffcf896 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -3871,6 +3871,11 @@ static int cgroup_mkdir(struct inode *dir, struct de=
ntry *dentry, int mode)
 {
 	struct cgroup *c_parent =3D dentry->d_parent->d_fsdata;
=20
+	/* Do not accept '\n' to prevent making /proc/<pid>/cgroup unparsable.
+	 */
+	if (strchr(dentry->d_name.name, '\n'))
+		return -EINVAL;
+
 	/* the vfs holds inode->i_mutex already */
 	return cgroup_create(c_parent, dentry, mode | S_IFDIR);
 }
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 14c111c..4a14895 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -1683,6 +1683,16 @@ retry:
 	 */
 	if (ctx->is_active) {
 		raw_spin_unlock_irq(&ctx->lock);
+		/*
+		 * Reload the task pointer, it might have been changed by
+		 * a concurrent perf_event_context_sched_out().
+		 */
+		task =3D ctx->task;
+		/*
+		 * Reload the task pointer, it might have been changed by
+		 * a concurrent perf_event_context_sched_out().
+		 */
+		task =3D ctx->task;
 		goto retry;
 	}
=20
@@ -7071,8 +7081,10 @@ int perf_event_init_task(struct task_struct *child)
=20
 	for_each_task_context_nr(ctxn) {
 		ret =3D perf_event_init_context(child, ctxn);
-		if (ret)
+		if (ret) {
+			perf_event_free_task(child);
 			return ret;
+		}
 	}
=20
 	return 0;
diff --git a/kernel/fork.c b/kernel/fork.c
index 13bba30..29b4604 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1221,7 +1221,7 @@ static struct task_struct *copy_process(unsigned long=
 clone_flags,
 		goto bad_fork_cleanup_policy;
 	retval =3D audit_alloc(p);
 	if (retval)
-		goto bad_fork_cleanup_policy;
+		goto bad_fork_cleanup_perf;
 	/* copy all the process information */
 	retval =3D copy_semundo(clone_flags, p);
 	if (retval)
@@ -1406,8 +1406,9 @@ bad_fork_cleanup_semundo:
 	exit_sem(p);
 bad_fork_cleanup_audit:
 	audit_free(p);
-bad_fork_cleanup_policy:
+bad_fork_cleanup_perf:
 	perf_event_free_task(p);
+bad_fork_cleanup_policy:
 #ifdef CONFIG_NUMA
 	mpol_put(p->mempolicy);
 bad_fork_cleanup_cgroup:
diff --git a/kernel/futex.c b/kernel/futex.c
index 1bb37d0..f31f190 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -2460,6 +2460,7 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, u=
nsigned int flags,
 	 * shared futexes. We need to compare the keys:
 	 */
 	if (match_futex(&q.key, &key2)) {
+		queue_unlock(&q, hb);
 		ret =3D -EINVAL;
 		goto out_put_keys;
 	}
diff --git a/kernel/time.c b/kernel/time.c
index 73e416d..060f961 100644
--- a/kernel/time.c
+++ b/kernel/time.c
@@ -493,17 +493,20 @@ EXPORT_SYMBOL(usecs_to_jiffies);
  * that a remainder subtract here would not do the right thing as the
  * resolution values don't fall on second boundries.  I.e. the line:
  * nsec -=3D nsec % TICK_NSEC; is NOT a correct resolution rounding.
+ * Note that due to the small error in the multiplier here, this
+ * rounding is incorrect for sufficiently large values of tv_nsec, but
+ * well formed timespecs should have tv_nsec < NSEC_PER_SEC, so we're
+ * OK.
  *
  * Rather, we just shift the bits off the right.
  *
  * The >> (NSEC_JIFFIE_SC - SEC_JIFFIE_SC) converts the scaled nsec
  * value to a scaled second value.
  */
-unsigned long
-timespec_to_jiffies(const struct timespec *value)
+static unsigned long
+__timespec_to_jiffies(unsigned long sec, long nsec)
 {
-	unsigned long sec =3D value->tv_sec;
-	long nsec =3D value->tv_nsec + TICK_NSEC - 1;
+	nsec =3D nsec + TICK_NSEC - 1;
=20
 	if (sec >=3D MAX_SEC_IN_JIFFIES){
 		sec =3D MAX_SEC_IN_JIFFIES;
@@ -514,6 +517,13 @@ timespec_to_jiffies(const struct timespec *value)
 		 (NSEC_JIFFIE_SC - SEC_JIFFIE_SC))) >> SEC_JIFFIE_SC;
=20
 }
+
+unsigned long
+timespec_to_jiffies(const struct timespec *value)
+{
+	return __timespec_to_jiffies(value->tv_sec, value->tv_nsec);
+}
+
 EXPORT_SYMBOL(timespec_to_jiffies);
=20
 void
@@ -530,31 +540,27 @@ jiffies_to_timespec(const unsigned long jiffies, stru=
ct timespec *value)
 }
 EXPORT_SYMBOL(jiffies_to_timespec);
=20
-/* Same for "timeval"
+/*
+ * We could use a similar algorithm to timespec_to_jiffies (with a
+ * different multiplier for usec instead of nsec). But this has a
+ * problem with rounding: we can't exactly add TICK_NSEC - 1 to the
+ * usec value, since it's not necessarily integral.
  *
- * Well, almost.  The problem here is that the real system resolution is
- * in nanoseconds and the value being converted is in micro seconds.
- * Also for some machines (those that use HZ =3D 1024, in-particular),
- * there is a LARGE error in the tick size in microseconds.
-
- * The solution we use is to do the rounding AFTER we convert the
- * microsecond part.  Thus the USEC_ROUND, the bits to be shifted off.
- * Instruction wise, this should cost only an additional add with carry
- * instruction above the way it was done above.
+ * We could instead round in the intermediate scaled representation
+ * (i.e. in units of 1/2^(large scale) jiffies) but that's also
+ * perilous: the scaling introduces a small positive error, which
+ * combined with a division-rounding-upward (i.e. adding 2^(scale) - 1
+ * units to the intermediate before shifting) leads to accidental
+ * overflow and overestimates.
+ *
+ * At the cost of one additional multiplication by a constant, just
+ * use the timespec implementation.
  */
 unsigned long
 timeval_to_jiffies(const struct timeval *value)
 {
-	unsigned long sec =3D value->tv_sec;
-	long usec =3D value->tv_usec;
-
-	if (sec >=3D MAX_SEC_IN_JIFFIES){
-		sec =3D MAX_SEC_IN_JIFFIES;
-		usec =3D 0;
-	}
-	return (((u64)sec * SEC_CONVERSION) +
-		(((u64)usec * USEC_CONVERSION + USEC_ROUND) >>
-		 (USEC_JIFFIE_SC - SEC_JIFFIE_SC))) >> SEC_JIFFIE_SC;
+	return __timespec_to_jiffies(value->tv_sec,
+				     value->tv_usec * NSEC_PER_USEC);
 }
 EXPORT_SYMBOL(timeval_to_jiffies);
=20
diff --git a/kernel/time/alarmtimer.c b/kernel/time/alarmtimer.c
index eb198a3..7eaf162 100644
--- a/kernel/time/alarmtimer.c
+++ b/kernel/time/alarmtimer.c
@@ -226,6 +226,12 @@ static enum hrtimer_restart alarmtimer_fired(struct hr=
timer *timer)
=20
 }
=20
+ktime_t alarm_expires_remaining(const struct alarm *alarm)
+{
+	struct alarm_base *base =3D &alarm_bases[alarm->type];
+	return ktime_sub(alarm->node.expires, base->gettime());
+}
+
 #ifdef CONFIG_RTC_CLASS
 /**
  * alarmtimer_suspend - Suspend time callback
@@ -442,18 +448,26 @@ static enum alarmtimer_type clock2alarm(clockid_t clo=
ckid)
 static enum alarmtimer_restart alarm_handle_timer(struct alarm *alarm,
 							ktime_t now)
 {
+	unsigned long flags;
 	struct k_itimer *ptr =3D container_of(alarm, struct k_itimer,
 						it.alarm.alarmtimer);
-	if (posix_timer_event(ptr, 0) !=3D 0)
-		ptr->it_overrun++;
+	enum alarmtimer_restart result =3D ALARMTIMER_NORESTART;
+
+	spin_lock_irqsave(&ptr->it_lock, flags);
+	if ((ptr->it_sigev_notify & ~SIGEV_THREAD_ID) !=3D SIGEV_NONE) {
+		if (posix_timer_event(ptr, 0) !=3D 0)
+			ptr->it_overrun++;
+	}
=20
 	/* Re-add periodic timers */
 	if (ptr->it.alarm.interval.tv64) {
 		ptr->it_overrun +=3D alarm_forward(alarm, now,
 						ptr->it.alarm.interval);
-		return ALARMTIMER_RESTART;
+		result =3D ALARMTIMER_RESTART;
 	}
-	return ALARMTIMER_NORESTART;
+	spin_unlock_irqrestore(&ptr->it_lock, flags);
+
+	return result;
 }
=20
 /**
@@ -519,18 +533,22 @@ static int alarm_timer_create(struct k_itimer *new_ti=
mer)
  * @new_timer: k_itimer pointer
  * @cur_setting: itimerspec data to fill
  *
- * Copies the itimerspec data out from the k_itimer
+ * Copies out the current itimerspec data
  */
 static void alarm_timer_get(struct k_itimer *timr,
 				struct itimerspec *cur_setting)
 {
-	memset(cur_setting, 0, sizeof(struct itimerspec));
+	ktime_t relative_expiry_time =3D
+		alarm_expires_remaining(&(timr->it.alarm.alarmtimer));
+
+	if (ktime_to_ns(relative_expiry_time) > 0) {
+		cur_setting->it_value =3D ktime_to_timespec(relative_expiry_time);
+	} else {
+		cur_setting->it_value.tv_sec =3D 0;
+		cur_setting->it_value.tv_nsec =3D 0;
+	}
=20
-	cur_setting->it_interval =3D
-			ktime_to_timespec(timr->it.alarm.interval);
-	cur_setting->it_value =3D
-		ktime_to_timespec(timr->it.alarm.alarmtimer.node.expires);
-	return;
+	cur_setting->it_interval =3D ktime_to_timespec(timr->it.alarm.interval);
 }
=20
 /**
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 4babd77..b252661 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2847,7 +2847,7 @@ static void rb_iter_reset(struct ring_buffer_iter *it=
er)
 	iter->head =3D cpu_buffer->reader_page->read;
=20
 	iter->cache_reader_page =3D iter->head_page;
-	iter->cache_read =3D iter->head;
+	iter->cache_read =3D cpu_buffer->read;
=20
 	if (iter->head)
 		iter->read_stamp =3D cpu_buffer->read_stamp;
diff --git a/mm/migrate.c b/mm/migrate.c
index 09d6a9d..7d26ea5 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -141,8 +141,11 @@ static int remove_migration_pte(struct page *new, stru=
ct vm_area_struct *vma,
=20
 	get_page(new);
 	pte =3D pte_mkold(mk_pte(new, vma->vm_page_prot));
+
+	/* Recheck VMA as permissions can change since migration started  */
 	if (is_write_migration_entry(entry))
-		pte =3D pte_mkwrite(pte);
+		pte =3D maybe_mkwrite(pte, vma);
+
 #ifdef CONFIG_HUGETLB_PAGE
 	if (PageHuge(new))
 		pte =3D pte_mkhuge(pte);
diff --git a/mm/percpu-vm.c b/mm/percpu-vm.c
index 12a48a88..0539f6a 100644
--- a/mm/percpu-vm.c
+++ b/mm/percpu-vm.c
@@ -108,7 +108,7 @@ static int pcpu_alloc_pages(struct pcpu_chunk *chunk,
 			    int page_start, int page_end)
 {
 	const gfp_t gfp =3D GFP_KERNEL | __GFP_HIGHMEM | __GFP_COLD;
-	unsigned int cpu;
+	unsigned int cpu, tcpu;
 	int i;
=20
 	for_each_possible_cpu(cpu) {
@@ -116,14 +116,23 @@ static int pcpu_alloc_pages(struct pcpu_chunk *chunk,
 			struct page **pagep =3D &pages[pcpu_page_idx(cpu, i)];
=20
 			*pagep =3D alloc_pages_node(cpu_to_node(cpu), gfp, 0);
-			if (!*pagep) {
-				pcpu_free_pages(chunk, pages, populated,
-						page_start, page_end);
-				return -ENOMEM;
-			}
+			if (!*pagep)
+				goto err;
 		}
 	}
 	return 0;
+
+err:
+	while (--i >=3D page_start)
+		__free_page(pages[pcpu_page_idx(cpu, i)]);
+
+	for_each_possible_cpu(tcpu) {
+		if (tcpu =3D=3D cpu)
+			break;
+		for (i =3D page_start; i < page_end; i++)
+			__free_page(pages[pcpu_page_idx(tcpu, i)]);
+	}
+	return -ENOMEM;
 }
=20
 /**
@@ -264,6 +273,7 @@ err:
 		__pcpu_unmap_pages(pcpu_chunk_addr(chunk, tcpu, page_start),
 				   page_end - page_start);
 	}
+	pcpu_post_unmap_tlb_flush(chunk, page_start, page_end);
 	return err;
 }
=20
diff --git a/mm/percpu.c b/mm/percpu.c
index 5c29750..e29a1c4 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1895,6 +1895,8 @@ void __init setup_per_cpu_areas(void)
=20
 	if (pcpu_setup_first_chunk(ai, fc) < 0)
 		panic("Failed to initialize percpu areas.");
+
+	pcpu_free_alloc_info(ai);
 }
=20
 #endif	/* CONFIG_SMP */
diff --git a/mm/shmem.c b/mm/shmem.c
index 1371021..83efac6 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1719,8 +1719,10 @@ static int shmem_rename(struct inode *old_dir, struc=
t dentry *old_dentry, struct
=20
 	if (new_dentry->d_inode) {
 		(void) shmem_unlink(new_dir, new_dentry);
-		if (they_are_dirs)
+		if (they_are_dirs) {
+			drop_nlink(new_dentry->d_inode);
 			drop_nlink(old_dir);
+		}
 	} else if (they_are_dirs) {
 		drop_nlink(old_dir);
 		inc_nlink(new_dir);
diff --git a/net/ceph/auth_x.c b/net/ceph/auth_x.c
index 1587dc6..9898d1f 100644
--- a/net/ceph/auth_x.c
+++ b/net/ceph/auth_x.c
@@ -13,8 +13,6 @@
 #include "auth_x.h"
 #include "auth_x_protocol.h"
=20
-#define TEMP_TICKET_BUF_LEN	256
-
 static void ceph_x_validate_tickets(struct ceph_auth_client *ac, int *pnee=
d);
=20
 static int ceph_x_is_authenticated(struct ceph_auth_client *ac)
@@ -64,7 +62,7 @@ static int ceph_x_encrypt(struct ceph_crypto_key *secret,
 }
=20
 static int ceph_x_decrypt(struct ceph_crypto_key *secret,
-			  void **p, void *end, void *obuf, size_t olen)
+			  void **p, void *end, void **obuf, size_t olen)
 {
 	struct ceph_x_encrypt_header head;
 	size_t head_len =3D sizeof(head);
@@ -75,8 +73,14 @@ static int ceph_x_decrypt(struct ceph_crypto_key *secret=
,
 		return -EINVAL;
=20
 	dout("ceph_x_decrypt len %d\n", len);
-	ret =3D ceph_decrypt2(secret, &head, &head_len, obuf, &olen,
-			    *p, len);
+	if (*obuf =3D=3D NULL) {
+		*obuf =3D kmalloc(len, GFP_NOFS);
+		if (!*obuf)
+			return -ENOMEM;
+		olen =3D len;
+	}
+
+	ret =3D ceph_decrypt2(secret, &head, &head_len, *obuf, &olen, *p, len);
 	if (ret)
 		return ret;
 	if (head.struct_v !=3D 1 || le64_to_cpu(head.magic) !=3D CEPHX_ENC_MAGIC)
@@ -129,139 +133,120 @@ static void remove_ticket_handler(struct ceph_auth_=
client *ac,
 	kfree(th);
 }
=20
-static int ceph_x_proc_ticket_reply(struct ceph_auth_client *ac,
-				    struct ceph_crypto_key *secret,
-				    void *buf, void *end)
+static int process_one_ticket(struct ceph_auth_client *ac,
+			      struct ceph_crypto_key *secret,
+			      void **p, void *end)
 {
 	struct ceph_x_info *xi =3D ac->private;
-	int num;
-	void *p =3D buf;
+	int type;
+	u8 tkt_struct_v, blob_struct_v;
+	struct ceph_x_ticket_handler *th;
+	void *dbuf =3D NULL;
+	void *dp, *dend;
+	int dlen;
+	char is_enc;
+	struct timespec validity;
+	struct ceph_crypto_key old_key;
+	void *ticket_buf =3D NULL;
+	void *tp, *tpend;
+	struct ceph_timespec new_validity;
+	struct ceph_crypto_key new_session_key;
+	struct ceph_buffer *new_ticket_blob;
+	unsigned long new_expires, new_renew_after;
+	u64 new_secret_id;
 	int ret;
-	char *dbuf;
-	char *ticket_buf;
-	u8 reply_struct_v;
=20
-	dbuf =3D kmalloc(TEMP_TICKET_BUF_LEN, GFP_NOFS);
-	if (!dbuf)
-		return -ENOMEM;
+	ceph_decode_need(p, end, sizeof(u32) + 1, bad);
=20
-	ret =3D -ENOMEM;
-	ticket_buf =3D kmalloc(TEMP_TICKET_BUF_LEN, GFP_NOFS);
-	if (!ticket_buf)
-		goto out_dbuf;
+	type =3D ceph_decode_32(p);
+	dout(" ticket type %d %s\n", type, ceph_entity_type_name(type));
=20
-	ceph_decode_need(&p, end, 1 + sizeof(u32), bad);
-	reply_struct_v =3D ceph_decode_8(&p);
-	if (reply_struct_v !=3D 1)
+	tkt_struct_v =3D ceph_decode_8(p);
+	if (tkt_struct_v !=3D 1)
 		goto bad;
-	num =3D ceph_decode_32(&p);
-	dout("%d tickets\n", num);
-	while (num--) {
-		int type;
-		u8 tkt_struct_v, blob_struct_v;
-		struct ceph_x_ticket_handler *th;
-		void *dp, *dend;
-		int dlen;
-		char is_enc;
-		struct timespec validity;
-		struct ceph_crypto_key old_key;
-		void *tp, *tpend;
-		struct ceph_timespec new_validity;
-		struct ceph_crypto_key new_session_key;
-		struct ceph_buffer *new_ticket_blob;
-		unsigned long new_expires, new_renew_after;
-		u64 new_secret_id;
-
-		ceph_decode_need(&p, end, sizeof(u32) + 1, bad);
-
-		type =3D ceph_decode_32(&p);
-		dout(" ticket type %d %s\n", type, ceph_entity_type_name(type));
-
-		tkt_struct_v =3D ceph_decode_8(&p);
-		if (tkt_struct_v !=3D 1)
-			goto bad;
-
-		th =3D get_ticket_handler(ac, type);
-		if (IS_ERR(th)) {
-			ret =3D PTR_ERR(th);
-			goto out;
-		}
=20
-		/* blob for me */
-		dlen =3D ceph_x_decrypt(secret, &p, end, dbuf,
-				      TEMP_TICKET_BUF_LEN);
-		if (dlen <=3D 0) {
-			ret =3D dlen;
-			goto out;
-		}
-		dout(" decrypted %d bytes\n", dlen);
-		dend =3D dbuf + dlen;
-		dp =3D dbuf;
+	th =3D get_ticket_handler(ac, type);
+	if (IS_ERR(th)) {
+		ret =3D PTR_ERR(th);
+		goto out;
+	}
=20
-		tkt_struct_v =3D ceph_decode_8(&dp);
-		if (tkt_struct_v !=3D 1)
-			goto bad;
+	/* blob for me */
+	dlen =3D ceph_x_decrypt(secret, p, end, &dbuf, 0);
+	if (dlen <=3D 0) {
+		ret =3D dlen;
+		goto out;
+	}
+	dout(" decrypted %d bytes\n", dlen);
+	dp =3D dbuf;
+	dend =3D dp + dlen;
=20
-		memcpy(&old_key, &th->session_key, sizeof(old_key));
-		ret =3D ceph_crypto_key_decode(&new_session_key, &dp, dend);
-		if (ret)
-			goto out;
+	tkt_struct_v =3D ceph_decode_8(&dp);
+	if (tkt_struct_v !=3D 1)
+		goto bad;
=20
-		ceph_decode_copy(&dp, &new_validity, sizeof(new_validity));
-		ceph_decode_timespec(&validity, &new_validity);
-		new_expires =3D get_seconds() + validity.tv_sec;
-		new_renew_after =3D new_expires - (validity.tv_sec / 4);
-		dout(" expires=3D%lu renew_after=3D%lu\n", new_expires,
-		     new_renew_after);
+	memcpy(&old_key, &th->session_key, sizeof(old_key));
+	ret =3D ceph_crypto_key_decode(&new_session_key, &dp, dend);
+	if (ret)
+		goto out;
=20
-		/* ticket blob for service */
-		ceph_decode_8_safe(&p, end, is_enc, bad);
-		tp =3D ticket_buf;
-		if (is_enc) {
-			/* encrypted */
-			dout(" encrypted ticket\n");
-			dlen =3D ceph_x_decrypt(&old_key, &p, end, ticket_buf,
-					      TEMP_TICKET_BUF_LEN);
-			if (dlen < 0) {
-				ret =3D dlen;
-				goto out;
-			}
-			dlen =3D ceph_decode_32(&tp);
-		} else {
-			/* unencrypted */
-			ceph_decode_32_safe(&p, end, dlen, bad);
-			ceph_decode_need(&p, end, dlen, bad);
-			ceph_decode_copy(&p, ticket_buf, dlen);
+	ceph_decode_copy(&dp, &new_validity, sizeof(new_validity));
+	ceph_decode_timespec(&validity, &new_validity);
+	new_expires =3D get_seconds() + validity.tv_sec;
+	new_renew_after =3D new_expires - (validity.tv_sec / 4);
+	dout(" expires=3D%lu renew_after=3D%lu\n", new_expires,
+	     new_renew_after);
+
+	/* ticket blob for service */
+	ceph_decode_8_safe(p, end, is_enc, bad);
+	if (is_enc) {
+		/* encrypted */
+		dout(" encrypted ticket\n");
+		dlen =3D ceph_x_decrypt(&old_key, p, end, &ticket_buf, 0);
+		if (dlen < 0) {
+			ret =3D dlen;
+			goto out;
 		}
-		tpend =3D tp + dlen;
-		dout(" ticket blob is %d bytes\n", dlen);
-		ceph_decode_need(&tp, tpend, 1 + sizeof(u64), bad);
-		blob_struct_v =3D ceph_decode_8(&tp);
-		new_secret_id =3D ceph_decode_64(&tp);
-		ret =3D ceph_decode_buffer(&new_ticket_blob, &tp, tpend);
-		if (ret)
+		tp =3D ticket_buf;
+		dlen =3D ceph_decode_32(&tp);
+	} else {
+		/* unencrypted */
+		ceph_decode_32_safe(p, end, dlen, bad);
+		ticket_buf =3D kmalloc(dlen, GFP_NOFS);
+		if (!ticket_buf) {
+			ret =3D -ENOMEM;
 			goto out;
-
-		/* all is well, update our ticket */
-		ceph_crypto_key_destroy(&th->session_key);
-		if (th->ticket_blob)
-			ceph_buffer_put(th->ticket_blob);
-		th->session_key =3D new_session_key;
-		th->ticket_blob =3D new_ticket_blob;
-		th->validity =3D new_validity;
-		th->secret_id =3D new_secret_id;
-		th->expires =3D new_expires;
-		th->renew_after =3D new_renew_after;
-		dout(" got ticket service %d (%s) secret_id %lld len %d\n",
-		     type, ceph_entity_type_name(type), th->secret_id,
-		     (int)th->ticket_blob->vec.iov_len);
-		xi->have_keys |=3D th->service;
+		}
+		tp =3D ticket_buf;
+		ceph_decode_need(p, end, dlen, bad);
+		ceph_decode_copy(p, ticket_buf, dlen);
 	}
+	tpend =3D tp + dlen;
+	dout(" ticket blob is %d bytes\n", dlen);
+	ceph_decode_need(&tp, tpend, 1 + sizeof(u64), bad);
+	blob_struct_v =3D ceph_decode_8(&tp);
+	new_secret_id =3D ceph_decode_64(&tp);
+	ret =3D ceph_decode_buffer(&new_ticket_blob, &tp, tpend);
+	if (ret)
+		goto out;
+
+	/* all is well, update our ticket */
+	ceph_crypto_key_destroy(&th->session_key);
+	if (th->ticket_blob)
+		ceph_buffer_put(th->ticket_blob);
+	th->session_key =3D new_session_key;
+	th->ticket_blob =3D new_ticket_blob;
+	th->validity =3D new_validity;
+	th->secret_id =3D new_secret_id;
+	th->expires =3D new_expires;
+	th->renew_after =3D new_renew_after;
+	dout(" got ticket service %d (%s) secret_id %lld len %d\n",
+	     type, ceph_entity_type_name(type), th->secret_id,
+	     (int)th->ticket_blob->vec.iov_len);
+	xi->have_keys |=3D th->service;
=20
-	ret =3D 0;
 out:
 	kfree(ticket_buf);
-out_dbuf:
 	kfree(dbuf);
 	return ret;
=20
@@ -270,6 +255,34 @@ bad:
 	goto out;
 }
=20
+static int ceph_x_proc_ticket_reply(struct ceph_auth_client *ac,
+				    struct ceph_crypto_key *secret,
+				    void *buf, void *end)
+{
+	void *p =3D buf;
+	u8 reply_struct_v;
+	u32 num;
+	int ret;
+
+	ceph_decode_8_safe(&p, end, reply_struct_v, bad);
+	if (reply_struct_v !=3D 1)
+		return -EINVAL;
+
+	ceph_decode_32_safe(&p, end, num, bad);
+	dout("%d tickets\n", num);
+
+	while (num--) {
+		ret =3D process_one_ticket(ac, secret, &p, end);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+
+bad:
+	return -EINVAL;
+}
+
 static int ceph_x_build_authorizer(struct ceph_auth_client *ac,
 				   struct ceph_x_ticket_handler *th,
 				   struct ceph_x_authorizer *au)
@@ -563,13 +576,14 @@ static int ceph_x_verify_authorizer_reply(struct ceph=
_auth_client *ac,
 	struct ceph_x_ticket_handler *th;
 	int ret =3D 0;
 	struct ceph_x_authorize_reply reply;
+	void *preply =3D &reply;
 	void *p =3D au->reply_buf;
 	void *end =3D p + sizeof(au->reply_buf);
=20
 	th =3D get_ticket_handler(ac, au->service);
 	if (IS_ERR(th))
 		return PTR_ERR(th);
-	ret =3D ceph_x_decrypt(&th->session_key, &p, end, &reply, sizeof(reply));
+	ret =3D ceph_x_decrypt(&th->session_key, &p, end, &preply, sizeof(reply))=
;
 	if (ret < 0)
 		return ret;
 	if (ret !=3D sizeof(reply))
diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index 20ba2d5..7a239f0 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -2423,7 +2423,7 @@ struct ceph_msg *ceph_msg_new(int type, int front_len=
, gfp_t flags,
 	m->footer.middle_crc =3D 0;
 	m->footer.data_crc =3D 0;
 	m->footer.flags =3D 0;
-	m->front_max =3D front_len;
+	m->front_alloc_len =3D front_len;
 	m->front_is_vmalloc =3D false;
 	m->more_to_follow =3D false;
 	m->ack_stamp =3D 0;
@@ -2594,8 +2594,8 @@ EXPORT_SYMBOL(ceph_msg_last_put);
=20
 void ceph_msg_dump(struct ceph_msg *msg)
 {
-	pr_debug("msg_dump %p (front_max %d nr_pages %d)\n", msg,
-		 msg->front_max, msg->nr_pages);
+	pr_debug("msg_dump %p (front_alloc_len %d nr_pages %d)\n", msg,
+		 msg->front_alloc_len, msg->nr_pages);
 	print_hex_dump(KERN_DEBUG, "header: ",
 		       DUMP_PREFIX_OFFSET, 16, 1,
 		       &msg->hdr, sizeof(msg->hdr), true);
diff --git a/net/ceph/mon_client.c b/net/ceph/mon_client.c
index 0b62dea..0c0859b 100644
--- a/net/ceph/mon_client.c
+++ b/net/ceph/mon_client.c
@@ -150,7 +150,7 @@ static int __open_session(struct ceph_mon_client *monc)
 		/* initiatiate authentication handshake */
 		ret =3D ceph_auth_build_hello(monc->auth,
 					    monc->m_auth->front.iov_base,
-					    monc->m_auth->front_max);
+					    monc->m_auth->front_alloc_len);
 		__send_prepared_auth_request(monc, ret);
 	} else {
 		dout("open_session mon%d already open\n", monc->cur_mon);
@@ -194,7 +194,7 @@ static void __send_subscribe(struct ceph_mon_client *mo=
nc)
 		int num;
=20
 		p =3D msg->front.iov_base;
-		end =3D p + msg->front_max;
+		end =3D p + msg->front_alloc_len;
=20
 		num =3D 1 + !!monc->want_next_osdmap + !!monc->want_mdsmap;
 		ceph_encode_32(&p, num);
@@ -860,7 +860,7 @@ static void handle_auth_reply(struct ceph_mon_client *m=
onc,
 	ret =3D ceph_handle_auth_reply(monc->auth, msg->front.iov_base,
 				     msg->front.iov_len,
 				     monc->m_auth->front.iov_base,
-				     monc->m_auth->front_max);
+				     monc->m_auth->front_alloc_len);
 	if (ret < 0) {
 		monc->client->auth_err =3D ret;
 		wake_up_all(&monc->client->auth_wq);
@@ -887,7 +887,7 @@ static int __validate_auth(struct ceph_mon_client *monc=
)
 		return 0;
=20
 	ret =3D ceph_build_auth(monc->auth, monc->m_auth->front.iov_base,
-			      monc->m_auth->front_max);
+			      monc->m_auth->front_alloc_len);
 	if (ret <=3D 0)
 		return ret; /* either an error, or no need to authenticate */
 	__send_prepared_auth_request(monc, ret);
@@ -987,7 +987,15 @@ static struct ceph_msg *mon_alloc_msg(struct ceph_conn=
ection *con,
 	if (!m) {
 		pr_info("alloc_msg unknown type %d\n", type);
 		*skip =3D 1;
+	} else if (front_len > m->front_alloc_len) {
+		pr_warning("mon_alloc_msg front %d > prealloc %d (%u#%llu)\n",
+			   front_len, m->front_alloc_len,
+			   (unsigned int)con->peer_name.type,
+			   le64_to_cpu(con->peer_name.num));
+		ceph_msg_put(m);
+		m =3D ceph_msg_new(type, front_len, GFP_NOFS, false);
 	}
+
 	return m;
 }
=20
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index d361dc0..8e79a9e 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -151,6 +151,9 @@ static void		 ipv4_link_failure(struct sk_buff *skb);
 static void		 ip_rt_update_pmtu(struct dst_entry *dst, u32 mtu);
 static int rt_garbage_collect(struct dst_ops *ops);
=20
+static void __rt_garbage_collect(struct work_struct *w);
+static DECLARE_WORK(rt_gc_worker, __rt_garbage_collect);
+
 static void ipv4_dst_ifdown(struct dst_entry *dst, struct net_device *dev,
 			    int how)
 {
@@ -979,12 +982,13 @@ static void rt_emergency_hash_rebuild(struct net *net=
)
    and when load increases it reduces to limit cache size.
  */
=20
-static int rt_garbage_collect(struct dst_ops *ops)
+static void __do_rt_garbage_collect(int elasticity, int min_interval)
 {
 	static unsigned long expire =3D RT_GC_TIMEOUT;
 	static unsigned long last_gc;
 	static int rover;
 	static int equilibrium;
+	static DEFINE_SPINLOCK(rt_gc_lock);
 	struct rtable *rth;
 	struct rtable __rcu **rthp;
 	unsigned long now =3D jiffies;
@@ -996,9 +1000,11 @@ static int rt_garbage_collect(struct dst_ops *ops)
 	 * do not make it too frequently.
 	 */
=20
+	spin_lock_bh(&rt_gc_lock);
+
 	RT_CACHE_STAT_INC(gc_total);
=20
-	if (now - last_gc < ip_rt_gc_min_interval &&
+	if (now - last_gc < min_interval &&
 	    entries < ip_rt_max_size) {
 		RT_CACHE_STAT_INC(gc_ignored);
 		goto out;
@@ -1006,7 +1012,7 @@ static int rt_garbage_collect(struct dst_ops *ops)
=20
 	entries =3D dst_entries_get_slow(&ipv4_dst_ops);
 	/* Calculate number of entries, which we want to expire now. */
-	goal =3D entries - (ip_rt_gc_elasticity << rt_hash_log);
+	goal =3D entries - (elasticity << rt_hash_log);
 	if (goal <=3D 0) {
 		if (equilibrium < ipv4_dst_ops.gc_thresh)
 			equilibrium =3D ipv4_dst_ops.gc_thresh;
@@ -1023,7 +1029,7 @@ static int rt_garbage_collect(struct dst_ops *ops)
 		equilibrium =3D entries - goal;
 	}
=20
-	if (now - last_gc >=3D ip_rt_gc_min_interval)
+	if (now - last_gc >=3D min_interval)
 		last_gc =3D now;
=20
 	if (goal <=3D 0) {
@@ -1088,15 +1094,34 @@ static int rt_garbage_collect(struct dst_ops *ops)
 	if (net_ratelimit())
 		printk(KERN_WARNING "dst cache overflow\n");
 	RT_CACHE_STAT_INC(gc_dst_overflow);
-	return 1;
+	goto out;
=20
 work_done:
-	expire +=3D ip_rt_gc_min_interval;
+	expire +=3D min_interval;
 	if (expire > ip_rt_gc_timeout ||
 	    dst_entries_get_fast(&ipv4_dst_ops) < ipv4_dst_ops.gc_thresh ||
 	    dst_entries_get_slow(&ipv4_dst_ops) < ipv4_dst_ops.gc_thresh)
 		expire =3D ip_rt_gc_timeout;
-out:	return 0;
+out:
+	spin_unlock_bh(&rt_gc_lock);
+}
+
+static void __rt_garbage_collect(struct work_struct *w)
+{
+	__do_rt_garbage_collect(ip_rt_gc_elasticity, ip_rt_gc_min_interval);
+}
+
+static int rt_garbage_collect(struct dst_ops *ops)
+{
+	if (!work_pending(&rt_gc_worker))
+		schedule_work(&rt_gc_worker);
+
+	if (dst_entries_get_fast(&ipv4_dst_ops) >=3D ip_rt_max_size ||
+	    dst_entries_get_slow(&ipv4_dst_ops) >=3D ip_rt_max_size) {
+		RT_CACHE_STAT_INC(gc_dst_overflow);
+		return 1;
+	}
+	return 0;
 }
=20
 /*
@@ -1153,7 +1178,7 @@ static struct rtable *rt_intern_hash(unsigned hash, s=
truct rtable *rt,
 	unsigned long	now;
 	u32 		min_score;
 	int		chain_length;
-	int attempts =3D !in_softirq();
+	int attempts =3D 1;
=20
 restart:
 	chain_length =3D 0;
@@ -1290,14 +1315,15 @@ restart:
 			   can be released. Try to shrink route cache,
 			   it is most likely it holds some neighbour records.
 			 */
-			if (attempts-- > 0) {
-				int saved_elasticity =3D ip_rt_gc_elasticity;
-				int saved_int =3D ip_rt_gc_min_interval;
-				ip_rt_gc_elasticity	=3D 1;
-				ip_rt_gc_min_interval	=3D 0;
-				rt_garbage_collect(&ipv4_dst_ops);
-				ip_rt_gc_min_interval	=3D saved_int;
-				ip_rt_gc_elasticity	=3D saved_elasticity;
+			if (!in_softirq() && attempts-- > 0) {
+				static DEFINE_SPINLOCK(lock);
+
+				if (spin_trylock(&lock)) {
+					__do_rt_garbage_collect(1, 0);
+					spin_unlock(&lock);
+				} else {
+					spin_unlock_wait(&lock);
+				}
 				goto restart;
 			}
=20
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index b9edff0..3afdd78 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -2443,8 +2443,18 @@ static void init_loopback(struct net_device *dev)
 			if (sp_ifa->flags & (IFA_F_DADFAILED | IFA_F_TENTATIVE))
 				continue;
=20
-			if (sp_ifa->rt)
-				continue;
+			if (sp_ifa->rt) {
+				/* This dst has been added to garbage list when
+				 * lo device down, release this obsolete dst and
+				 * reallocate a new router for ifa.
+				 */
+				if (sp_ifa->rt->dst.obsolete > 0) {
+					dst_release(&sp_ifa->rt->dst);
+					sp_ifa->rt =3D NULL;
+				} else {
+					continue;
+				}
+			}
=20
 			sp_rt =3D addrconf_dst_alloc(idev, &sp_ifa->addr, 0);
=20
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index f8bec1e..d131a95 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1362,7 +1362,7 @@ static struct sk_buff *udp6_ufo_fragment(struct sk_bu=
ff *skb, u32 features)
 	fptr =3D (struct frag_hdr *)(skb_network_header(skb) + unfrag_ip6hlen);
 	fptr->nexthdr =3D nexthdr;
 	fptr->reserved =3D 0;
-	ipv6_select_ident(fptr, (struct rt6_info *)skb_dst(skb));
+	fptr->identification =3D skb_shinfo(skb)->ip6_frag_id;
=20
 	/* Fragment the skb. ipv6 header and the remaining fields of the
 	 * fragment header are updated in ipv6_gso_segment()
diff --git a/net/l2tp/l2tp_ppp.c b/net/l2tp/l2tp_ppp.c
index 437fb59..767bf4a 100644
--- a/net/l2tp/l2tp_ppp.c
+++ b/net/l2tp/l2tp_ppp.c
@@ -774,7 +774,8 @@ static int pppol2tp_connect(struct socket *sock, struct=
 sockaddr *uservaddr,
 	/* If PMTU discovery was enabled, use the MTU that was discovered */
 	dst =3D sk_dst_get(tunnel->sock);
 	if (dst !=3D NULL) {
-		u32 pmtu =3D dst_mtu(__sk_dst_get(tunnel->sock));
+		u32 pmtu =3D dst_mtu(dst);
+
 		if (pmtu !=3D 0)
 			session->mtu =3D session->mru =3D pmtu -
 				PPPOL2TP_HEADER_OVERHEAD;
diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs_con=
n.c
index 29fa5ba..6422845 100644
--- a/net/netfilter/ipvs/ip_vs_conn.c
+++ b/net/netfilter/ipvs/ip_vs_conn.c
@@ -777,7 +777,6 @@ static void ip_vs_conn_expire(unsigned long data)
 			ip_vs_control_del(cp);
=20
 		if (cp->flags & IP_VS_CONN_F_NFCT) {
-			ip_vs_conn_drop_conntrack(cp);
 			/* Do not access conntracks during subsys cleanup
 			 * because nf_conntrack_find_get can not be used after
 			 * conntrack cleanup for the net.
diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index da54d29..5b2d8e6 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -1638,6 +1638,8 @@ struct sctp_chunk *sctp_assoc_lookup_asconf_ack(
 	 * ack chunk whose serial number matches that of the request.
 	 */
 	list_for_each_entry(ack, &asoc->asconf_ack_list, transmitted_list) {
+		if (sctp_chunk_pending(ack))
+			continue;
 		if (ack->subh.addip_hdr->serial =3D=3D serial) {
 			sctp_chunk_hold(ack);
 			return ack;
diff --git a/net/sctp/inqueue.c b/net/sctp/inqueue.c
index 397296f..32421ae 100644
--- a/net/sctp/inqueue.c
+++ b/net/sctp/inqueue.c
@@ -152,18 +152,9 @@ struct sctp_chunk *sctp_inq_pop(struct sctp_inq *queue=
)
 		} else {
 			/* Nothing to do. Next chunk in the packet, please. */
 			ch =3D (sctp_chunkhdr_t *) chunk->chunk_end;
-
 			/* Force chunk->skb->data to chunk->chunk_end.  */
-			skb_pull(chunk->skb,
-				 chunk->chunk_end - chunk->skb->data);
-
-			/* Verify that we have at least chunk headers
-			 * worth of buffer left.
-			 */
-			if (skb_headlen(chunk->skb) < sizeof(sctp_chunkhdr_t)) {
-				sctp_chunk_free(chunk);
-				chunk =3D queue->in_progress =3D NULL;
-			}
+			skb_pull(chunk->skb, chunk->chunk_end - chunk->skb->data);
+			/* We are guaranteed to pull a SCTP header. */
 		}
 	}
=20
@@ -199,24 +190,14 @@ struct sctp_chunk *sctp_inq_pop(struct sctp_inq *queu=
e)
 	skb_pull(chunk->skb, sizeof(sctp_chunkhdr_t));
 	chunk->subh.v =3D NULL; /* Subheader is no longer valid.  */
=20
-	if (chunk->chunk_end < skb_tail_pointer(chunk->skb)) {
+	if (chunk->chunk_end + sizeof(sctp_chunkhdr_t) <
+	    skb_tail_pointer(chunk->skb)) {
 		/* This is not a singleton */
 		chunk->singleton =3D 0;
 	} else if (chunk->chunk_end > skb_tail_pointer(chunk->skb)) {
-		/* RFC 2960, Section 6.10  Bundling
-		 *
-		 * Partial chunks MUST NOT be placed in an SCTP packet.
-		 * If the receiver detects a partial chunk, it MUST drop
-		 * the chunk.
-		 *
-		 * Since the end of the chunk is past the end of our buffer
-		 * (which contains the whole packet, we can freely discard
-		 * the whole packet.
-		 */
-		sctp_chunk_free(chunk);
-		chunk =3D queue->in_progress =3D NULL;
-
-		return NULL;
+		/* Discard inside state machine. */
+		chunk->pdiscard =3D 1;
+		chunk->chunk_end =3D skb_tail_pointer(chunk->skb);
 	} else {
 		/* We are at the end of the packet, so mark the chunk
 		 * in case we need to send a SACK.
diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index c95a3f2..d8d4704 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -3068,50 +3068,63 @@ static __be16 sctp_process_asconf_param(struct sctp=
_association *asoc,
 	return SCTP_ERROR_NO_ERROR;
 }
=20
-/* Verify the ASCONF packet before we process it.  */
-int sctp_verify_asconf(const struct sctp_association *asoc,
-		       struct sctp_paramhdr *param_hdr, void *chunk_end,
-		       struct sctp_paramhdr **errp) {
-	sctp_addip_param_t *asconf_param;
+/* Verify the ASCONF packet before we process it. */
+bool sctp_verify_asconf(const struct sctp_association *asoc,
+			struct sctp_chunk *chunk, bool addr_param_needed,
+			struct sctp_paramhdr **errp)
+{
+	sctp_addip_chunk_t *addip =3D (sctp_addip_chunk_t *) chunk->chunk_hdr;
 	union sctp_params param;
-	int length, plen;
-
-	param.v =3D (sctp_paramhdr_t *) param_hdr;
-	while (param.v <=3D chunk_end - sizeof(sctp_paramhdr_t)) {
-		length =3D ntohs(param.p->length);
-		*errp =3D param.p;
+	bool addr_param_seen =3D false;
=20
-		if (param.v > chunk_end - length ||
-		    length < sizeof(sctp_paramhdr_t))
-			return 0;
+	sctp_walk_params(param, addip, addip_hdr.params) {
+		size_t length =3D ntohs(param.p->length);
=20
+		*errp =3D param.p;
 		switch (param.p->type) {
+		case SCTP_PARAM_ERR_CAUSE:
+			break;
+		case SCTP_PARAM_IPV4_ADDRESS:
+			if (length !=3D sizeof(sctp_ipv4addr_param_t))
+				return false;
+			addr_param_seen =3D true;
+			break;
+		case SCTP_PARAM_IPV6_ADDRESS:
+			if (length !=3D sizeof(sctp_ipv6addr_param_t))
+				return false;
+			addr_param_seen =3D true;
+			break;
 		case SCTP_PARAM_ADD_IP:
 		case SCTP_PARAM_DEL_IP:
 		case SCTP_PARAM_SET_PRIMARY:
-			asconf_param =3D (sctp_addip_param_t *)param.v;
-			plen =3D ntohs(asconf_param->param_hdr.length);
-			if (plen < sizeof(sctp_addip_param_t) +
-			    sizeof(sctp_paramhdr_t))
-				return 0;
+			/* In ASCONF chunks, these need to be first. */
+			if (addr_param_needed && !addr_param_seen)
+				return false;
+			length =3D ntohs(param.addip->param_hdr.length);
+			if (length < sizeof(sctp_addip_param_t) +
+				     sizeof(sctp_paramhdr_t))
+				return false;
 			break;
 		case SCTP_PARAM_SUCCESS_REPORT:
 		case SCTP_PARAM_ADAPTATION_LAYER_IND:
 			if (length !=3D sizeof(sctp_addip_param_t))
-				return 0;
-
+				return false;
 			break;
 		default:
-			break;
+			/* This is unkown to us, reject! */
+			return false;
 		}
-
-		param.v +=3D WORD_ROUND(length);
 	}
=20
-	if (param.v !=3D chunk_end)
-		return 0;
+	/* Remaining sanity checks. */
+	if (addr_param_needed && !addr_param_seen)
+		return false;
+	if (!addr_param_needed && addr_param_seen)
+		return false;
+	if (param.v !=3D chunk->chunk_end)
+		return false;
=20
-	return 1;
+	return true;
 }
=20
 /* Process an incoming ASCONF chunk with the next expected serial no. and
@@ -3120,16 +3133,17 @@ int sctp_verify_asconf(const struct sctp_associatio=
n *asoc,
 struct sctp_chunk *sctp_process_asconf(struct sctp_association *asoc,
 				       struct sctp_chunk *asconf)
 {
+	sctp_addip_chunk_t *addip =3D (sctp_addip_chunk_t *) asconf->chunk_hdr;
+	bool all_param_pass =3D true;
+	union sctp_params param;
 	sctp_addiphdr_t		*hdr;
 	union sctp_addr_param	*addr_param;
 	sctp_addip_param_t	*asconf_param;
 	struct sctp_chunk	*asconf_ack;
-
 	__be16	err_code;
 	int	length =3D 0;
 	int	chunk_len;
 	__u32	serial;
-	int	all_param_pass =3D 1;
=20
 	chunk_len =3D ntohs(asconf->chunk_hdr->length) - sizeof(sctp_chunkhdr_t);
 	hdr =3D (sctp_addiphdr_t *)asconf->skb->data;
@@ -3157,9 +3171,14 @@ struct sctp_chunk *sctp_process_asconf(struct sctp_a=
ssociation *asoc,
 		goto done;
=20
 	/* Process the TLVs contained within the ASCONF chunk. */
-	while (chunk_len > 0) {
+	sctp_walk_params(param, addip, addip_hdr.params) {
+		/* Skip preceeding address parameters. */
+		if (param.p->type =3D=3D SCTP_PARAM_IPV4_ADDRESS ||
+		    param.p->type =3D=3D SCTP_PARAM_IPV6_ADDRESS)
+			continue;
+
 		err_code =3D sctp_process_asconf_param(asoc, asconf,
-						     asconf_param);
+						     param.addip);
 		/* ADDIP 4.1 A7)
 		 * If an error response is received for a TLV parameter,
 		 * all TLVs with no response before the failed TLV are
@@ -3167,28 +3186,20 @@ struct sctp_chunk *sctp_process_asconf(struct sctp_=
association *asoc,
 		 * the failed response are considered unsuccessful unless
 		 * a specific success indication is present for the parameter.
 		 */
-		if (SCTP_ERROR_NO_ERROR !=3D err_code)
-			all_param_pass =3D 0;
-
+		if (err_code !=3D SCTP_ERROR_NO_ERROR)
+			all_param_pass =3D false;
 		if (!all_param_pass)
-			sctp_add_asconf_response(asconf_ack,
-						 asconf_param->crr_id, err_code,
-						 asconf_param);
+			sctp_add_asconf_response(asconf_ack, param.addip->crr_id,
+						 err_code, param.addip);
=20
 		/* ADDIP 4.3 D11) When an endpoint receiving an ASCONF to add
 		 * an IP address sends an 'Out of Resource' in its response, it
 		 * MUST also fail any subsequent add or delete requests bundled
 		 * in the ASCONF.
 		 */
-		if (SCTP_ERROR_RSRC_LOW =3D=3D err_code)
+		if (err_code =3D=3D SCTP_ERROR_RSRC_LOW)
 			goto done;
-
-		/* Move to the next ASCONF param. */
-		length =3D ntohs(asconf_param->param_hdr.length);
-		asconf_param =3D (void *)asconf_param + length;
-		chunk_len -=3D length;
 	}
-
 done:
 	asoc->peer.addip_serial++;
=20
diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 5ac33b6..d02dd3c 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -163,6 +163,9 @@ sctp_chunk_length_valid(struct sctp_chunk *chunk,
 {
 	__u16 chunk_length =3D ntohs(chunk->chunk_hdr->length);
=20
+	/* Previously already marked? */
+	if (unlikely(chunk->pdiscard))
+		return 0;
 	if (unlikely(chunk_length < required_length))
 		return 0;
=20
@@ -3516,9 +3519,7 @@ sctp_disposition_t sctp_sf_do_asconf(const struct sct=
p_endpoint *ep,
 	struct sctp_chunk	*asconf_ack =3D NULL;
 	struct sctp_paramhdr	*err_param =3D NULL;
 	sctp_addiphdr_t		*hdr;
-	union sctp_addr_param	*addr_param;
 	__u32			serial;
-	int			length;
=20
 	if (!sctp_vtag_verify(chunk, asoc)) {
 		sctp_add_cmd_sf(commands, SCTP_CMD_REPORT_BAD_TAG,
@@ -3543,17 +3544,8 @@ sctp_disposition_t sctp_sf_do_asconf(const struct sc=
tp_endpoint *ep,
 	hdr =3D (sctp_addiphdr_t *)chunk->skb->data;
 	serial =3D ntohl(hdr->serial);
=20
-	addr_param =3D (union sctp_addr_param *)hdr->params;
-	length =3D ntohs(addr_param->p.length);
-	if (length < sizeof(sctp_paramhdr_t))
-		return sctp_sf_violation_paramlen(ep, asoc, type, arg,
-			   (void *)addr_param, commands);
-
 	/* Verify the ASCONF chunk before processing it. */
-	if (!sctp_verify_asconf(asoc,
-			    (sctp_paramhdr_t *)((void *)addr_param + length),
-			    (void *)chunk->chunk_end,
-			    &err_param))
+	if (!sctp_verify_asconf(asoc, chunk, true, &err_param))
 		return sctp_sf_violation_paramlen(ep, asoc, type, arg,
 						  (void *)err_param, commands);
=20
@@ -3670,10 +3662,7 @@ sctp_disposition_t sctp_sf_do_asconf_ack(const struc=
t sctp_endpoint *ep,
 	rcvd_serial =3D ntohl(addip_hdr->serial);
=20
 	/* Verify the ASCONF-ACK chunk before processing it. */
-	if (!sctp_verify_asconf(asoc,
-	    (sctp_paramhdr_t *)addip_hdr->params,
-	    (void *)asconf_ack->chunk_end,
-	    &err_param))
+	if (!sctp_verify_asconf(asoc, asconf_ack, false, &err_param))
 		return sctp_sf_violation_paramlen(ep, asoc, type, arg,
 			   (void *)err_param, commands);
=20
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 6d4d263..cdf77a2 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4804,6 +4804,9 @@ int cfg80211_testmode_reply(struct sk_buff *skb)
 	void *hdr =3D ((void **)skb->cb)[1];
 	struct nlattr *data =3D ((void **)skb->cb)[2];
=20
+	/* clear CB data for netlink core to own from now on */
+	memset(skb->cb, 0, sizeof(skb->cb));
+
 	if (WARN_ON(!rdev->testmode_info)) {
 		kfree_skb(skb);
 		return -EINVAL;
@@ -4830,6 +4833,9 @@ void cfg80211_testmode_event(struct sk_buff *skb, gfp=
_t gfp)
 	void *hdr =3D ((void **)skb->cb)[1];
 	struct nlattr *data =3D ((void **)skb->cb)[2];
=20
+	/* clear CB data for netlink core to own from now on */
+	memset(skb->cb, 0, sizeof(skb->cb));
+
 	nla_nest_end(skb, data);
 	genlmsg_end(skb, hdr);
 	genlmsg_multicast_netns(wiphy_net(&rdev->wiphy), skb, 0,
diff --git a/sound/core/pcm_lib.c b/sound/core/pcm_lib.c
index cf0d46e..7f00d34 100644
--- a/sound/core/pcm_lib.c
+++ b/sound/core/pcm_lib.c
@@ -1692,14 +1692,16 @@ static int snd_pcm_lib_ioctl_fifo_size(struct snd_p=
cm_substream *substream,
 {
 	struct snd_pcm_hw_params *params =3D arg;
 	snd_pcm_format_t format;
-	int channels, width;
+	int channels;
+	ssize_t frame_size;
=20
 	params->fifo_size =3D substream->runtime->hw.fifo_size;
 	if (!(substream->runtime->hw.info & SNDRV_PCM_INFO_FIFO_IN_FRAMES)) {
 		format =3D params_format(params);
 		channels =3D params_channels(params);
-		width =3D snd_pcm_format_physical_width(format);
-		params->fifo_size /=3D width * channels;
+		frame_size =3D snd_pcm_format_size(format, channels);
+		if (frame_size > 0)
+			params->fifo_size /=3D (unsigned)frame_size;
 	}
 	return 0;
 }
diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 491cdf0..d10a6ef 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -789,6 +789,7 @@ static void alc_auto_init_amp(struct hda_codec *codec, =
int type)
 		case 0x10ec0885:
 		case 0x10ec0887:
 		/*case 0x10ec0889:*/ /* this causes an SPDIF problem */
+		case 0x10ec0900:
 			alc889_coef_init(codec);
 			break;
 		case 0x10ec0888:
@@ -4343,6 +4344,7 @@ static int patch_alc882(struct hda_codec *codec)
 	switch (codec->vendor_id) {
 	case 0x10ec0882:
 	case 0x10ec0885:
+	case 0x10ec0900:
 		break;
 	default:
 		/* ALC883 and variants */
=0D
--=-LDxpUjsUTQ+DLiwPZQa0--

--=-M+t7YeB7YcE5JKsyaoKS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUAVFqcPue/yOyVhhEJAQrd7RAAxQ0PQhT0WICgG8NTUX6IkKzuJc/Zxb92
WpTQ6zfNEydvQVpwBiJp7QquPzS6QBiY6fsPvDpOvGwWHfpTcZcniEu9oTsHSDLd
zVwzbo8+TQrjufxzhV8YgCZbVSHK4tQg/Lt8Zdxgc7/xiJ6yq1oQwBUcQP0QtUl8
sKs9vw6QVp2hYjafDQd+0/ITfLPCLB75vylIRVOWxFvNlqepYrJvXbNlCjc0vG3O
7kDhFeki9Lq6Et868xlJH2HX3PkvmpzfCFkGUqUrLGp7/NmYEa16T7SJbQDEonVK
Uxe82jgyUkLyY9tzFNLf3HCsTyelCD6JMVRYgIq6FYzoR1haJL7II9Re1US+Kq1u
2GpT/G4LOdywQ+6+ClbjfLGrLFlVju519wJuXaJYC1isX8f0H7/7DiNlsa2lP5C9
eZ9NNq1NF3ca2y3AUUmhSg8SOSfBgTAraBU/DA/ob5z//xMh6R5sOnnfCXwyE9Io
WOfnEBZ/ORDAPBZU7K3rM5sIY2XzvRZ1bKeOQeY9mxWoYIi0T54t47jOiJqzpyqT
jFXaUU7bYjen3dsLElhvljZj00MhRmUWoVpDKFE2nO5GDPnnOn/Ytql+3B/FcE8r
fQ8aKCupNMvmfB6zTkIzAfddShARSy8tXf/C717CatP/HbrjTuF0fOXA5t7cSHcl
iwPDZDIeC88=
=Pr94
-----END PGP SIGNATURE-----

--=-M+t7YeB7YcE5JKsyaoKS--
