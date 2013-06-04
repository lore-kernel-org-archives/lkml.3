Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751616Ab3FDWke (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 18:40:34 -0400
Received: from 1wt.eu ([62.212.114.60]:35097 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750791Ab3FDWk3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:40:29 -0400
Message-Id: <20130604172130.280151953@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:21:30 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [ 000/184] 2.6.32.61-longterm review
Message-ID: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the longterm review cycle for the 2.6.32.61 release.
All patches will be posted as a response to this one. If anyone has any
issue with these being applied, please let me know. If anyone is a
maintainer of the proper subsystem, and wants to add a Signed-off-by: line
to the patch, please respond with it.

Responses should be made within 72 hours. Anything received after that time
might be too late.

This series contains backports for all important fixes from 3.0.y branch up
to and including 3.0.80, as well as a large number of security backports from
debian kindly provided by Moritz Muehlenhoff. Note that the changelog was quite
large, so after a full review, all driver-related fixes that were not related
to instability or security issues were postponed or dropped. Given the low
amount of feedback, I'm assuming that drivers do work well and do not need
some fixes I can't always test. If not, please report issues and indicate
the patches you want backported, I'll happily queue them for next release.

This kernel was successfully built on i386 and x86_64 with make allmodconfig,
and on arm with a hardware-specific config.

The following CVE IDs were fixed in 2.6.32.61 :

CVE-2011-2695 CVE-2011-2699 CVE-2012-2390 CVE-2012-3430 CVE-2012-3552
CVE-2012-4398 CVE-2012-4444 CVE-2012-4461 CVE-2012-4508 CVE-2012-4530
CVE-2012-4565 CVE-2012-6537 CVE-2012-6539 CVE-2012-6540 CVE-2012-6542
CVE-2012-6544 CVE-2012-6545 CVE-2012-6546 CVE-2012-6548 CVE-2012-6549
CVE-2013-0228 CVE-2013-0268 CVE-2013-0349 CVE-2013-0871 CVE-2013-0914
CVE-2013-1767 CVE-2013-1773 CVE-2013-1774 CVE-2013-1792 CVE-2013-1796
CVE-2013-1798 CVE-2013-1826 CVE-2013-1860 CVE-2013-1928 CVE-2013-2015
CVE-2013-2634 CVE-2013-3222 CVE-2013-3223 CVE-2013-3224 CVE-2013-3225
CVE-2013-3228 CVE-2013-3229 CVE-2013-3231 CVE-2013-3234 CVE-2013-3235

Please note that the whole -rc patch is not provided anymore, only individual
patches are provided so that their authors and subsystem maintainers can spot
issues. If this is a problem for you, please report it so that we try to find
a solution.

The diffstat is appended below.

 arch/alpha/kernel/sys_nautilus.c               |   5 +
 arch/arm/include/asm/signal.h                  |   1 +
 arch/avr32/include/asm/signal.h                |   1 +
 arch/cris/include/asm/signal.h                 |   1 +
 arch/h8300/include/asm/signal.h                |   1 +
 arch/m32r/include/asm/signal.h                 |   1 +
 arch/m68k/include/asm/signal.h                 |   1 +
 arch/mips/Makefile                             |   2 +-
 arch/mips/kernel/Makefile                      |   2 +-
 arch/mn10300/include/asm/signal.h              |   1 +
 arch/parisc/kernel/signal32.c                  |   6 +-
 arch/powerpc/include/asm/signal.h              |   1 +
 arch/s390/include/asm/signal.h                 |   1 +
 arch/sparc/include/asm/signal.h                |   1 +
 arch/x86/Kconfig                               |   2 +-
 arch/x86/include/asm/pgtable.h                 |   5 +
 arch/x86/include/asm/signal.h                  |   2 +
 arch/x86/kernel/apic/io_apic.c                 |   9 +-
 arch/x86/kernel/cpu/mcheck/mce.c               |   9 +-
 arch/x86/kernel/efi.c                          |   3 -
 arch/x86/kernel/msr.c                          |   3 +
 arch/x86/kvm/x86.c                             |   9 +
 arch/x86/mm/fault.c                            |   6 +-
 arch/x86/mm/init_64.c                          |   3 +
 arch/x86/xen/enlighten.c                       |  18 +-
 arch/x86/xen/xen-asm_32.S                      |  14 +-
 arch/xtensa/include/asm/signal.h               |   1 +
 block/blk-core.c                               |  14 +-
 block/blk-exec.c                               |   7 +
 block/scsi_ioctl.c                             |   5 +-
 crypto/cryptd.c                                |  11 +-
 drivers/acpi/processor_idle.c                  |   3 +
 drivers/ata/libata-scsi.c                      |   6 +-
 drivers/base/bus.c                             |   4 +-
 drivers/char/ipmi/ipmi_bt_sm.c                 |   4 +-
 drivers/firmware/pcdp.c                        |   4 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c      |   2 +-
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c |  19 +-
 drivers/isdn/isdnloop/isdnloop.c               |  12 -
 drivers/net/bonding/bonding.h                  |   4 +-
 drivers/net/r8169.c                            |  30 +--
 drivers/net/tg3.c                              |   4 +
 drivers/net/wireless/b43legacy/main.c          |   2 +
 drivers/pci/remove.c                           |   2 +
 drivers/scsi/bnx2i/bnx2i_hwi.c                 |   3 +
 drivers/scsi/scsi_lib.c                        |   2 +
 drivers/serial/8250.c                          |   2 +-
 drivers/staging/comedi/comedi_fops.c           |  13 +-
 drivers/staging/comedi/drivers/comedi_test.c   |   2 +-
 drivers/staging/comedi/drivers/das08.c         |   2 +-
 drivers/staging/comedi/drivers/jr3_pci.c       |   2 +-
 drivers/staging/comedi/drivers/ni_labpc.c      |  35 +--
 drivers/staging/comedi/drivers/s626.c          |   2 +-
 drivers/staging/vt6656/rf.c                    |   3 +
 drivers/telephony/ixj.c                        |  24 +-
 drivers/usb/class/cdc-wdm.c                    |  23 +-
 drivers/usb/host/ehci-hcd.c                    |   8 +-
 drivers/usb/host/ehci-q.c                      |  82 +++---
 drivers/usb/host/ehci.h                        |   3 +-
 drivers/usb/host/pci-quirks.c                  |  12 +-
 drivers/usb/serial/garmin_gps.c                |   7 +-
 drivers/usb/serial/io_ti.c                     |   3 +
 drivers/usb/serial/mos7840.c                   |   2 +-
 drivers/usb/serial/sierra.c                    |   1 +
 drivers/usb/serial/whiteheat.c                 |   1 +
 drivers/w1/w1.c                                |   3 +-
 fs/binfmt_elf.c                                |  19 +-
 fs/binfmt_em86.c                               |   1 -
 fs/binfmt_misc.c                               |  11 +-
 fs/binfmt_script.c                             |   8 +-
 fs/btrfs/volumes.c                             |   6 +
 fs/cifs/cifs_dfs_ref.c                         |   2 +
 fs/compat_ioctl.c                              |   3 +
 fs/eventpoll.c                                 |  22 +-
 fs/exec.c                                      |  25 +-
 fs/ext4/acl.c                                  |   6 +-
 fs/ext4/ext4_extents.h                         |   7 +-
 fs/ext4/extents.c                              | 106 ++++++--
 fs/ext4/inode.c                                |   8 +-
 fs/ext4/mballoc.c                              |  12 +-
 fs/ext4/move_extent.c                          |  17 +-
 fs/ext4/namei.c                                |  26 +-
 fs/ext4/super.c                                |  17 +-
 fs/fat/inode.c                                 |   2 +-
 fs/fat/namei_vfat.c                            |   9 +-
 fs/fscache/stats.c                             |   2 +-
 fs/hfsplus/extents.c                           |   2 +-
 fs/isofs/export.c                              |   1 +
 fs/jbd/commit.c                                |  43 +++-
 fs/jbd/transaction.c                           |  99 ++++++--
 fs/nfsd/nfs4xdr.c                              |  11 +-
 fs/nls/nls_base.c                              |  43 +++-
 fs/splice.c                                    |   7 +-
 fs/sysfs/dir.c                                 |  16 +-
 fs/udf/inode.c                                 |   4 +
 fs/udf/namei.c                                 |   1 +
 fs/udf/udf_sb.h                                |   2 +-
 include/asm-generic/signal.h                   |   4 +
 include/linux/binfmts.h                        |   3 +-
 include/linux/blkdev.h                         |   4 +-
 include/linux/kmod.h                           |   2 +
 include/linux/mempolicy.h                      |   2 +-
 include/linux/msdos_fs.h                       |   3 +-
 include/linux/nls.h                            |   5 +-
 include/linux/page-flags.h                     |   8 +-
 include/linux/sched.h                          |  11 +-
 include/linux/socket.h                         |   2 +-
 include/net/inet_sock.h                        |  14 +-
 include/net/ip.h                               |  11 +-
 include/net/ipv6.h                             |  12 +-
 include/net/transp_v6.h                        |   2 +
 include/scsi/scsi.h                            |   8 +-
 include/scsi/scsi_netlink.h                    |   4 +-
 include/trace/events/kmem.h                    |   4 +-
 kernel/async.c                                 |  13 +-
 kernel/cgroup.c                                |   2 -
 kernel/kmod.c                                  |  89 ++++++-
 kernel/posix-cpu-timers.c                      |  23 +-
 kernel/ptrace.c                                |  67 +++--
 kernel/resource.c                              |  50 +++-
 kernel/sched.c                                 |   3 +-
 kernel/signal.c                                |  21 +-
 kernel/softirq.c                               |  17 +-
 kernel/sys.c                                   |   1 +
 kernel/time/tick-broadcast.c                   |   3 +-
 kernel/time/tick-sched.c                       |   2 +-
 kernel/time/timekeeping.c                      |   3 +-
 kernel/timer.c                                 |   2 +-
 kernel/trace/ftrace.c                          |   1 -
 kernel/trace/ring_buffer.c                     |   2 +
 lib/genalloc.c                                 |   2 +-
 mm/hugetlb.c                                   |  29 ++-
 mm/mempolicy.c                                 |  37 ++-
 mm/shmem.c                                     |  10 +-
 mm/truncate.c                                  |   3 +-
 mm/vmscan.c                                    |   2 +
 net/atm/common.c                               |   3 +
 net/atm/pvc.c                                  |   1 +
 net/ax25/af_ax25.c                             |   1 +
 net/bluetooth/af_bluetooth.c                   |   4 +-
 net/bluetooth/hci_sock.c                       |   1 +
 net/bluetooth/hidp/core.c                      |   2 +-
 net/bluetooth/l2cap.c                          |   1 +
 net/bluetooth/rfcomm/sock.c                    |   2 +
 net/bridge/br_stp_bpdu.c                       |   2 +
 net/core/dev.c                                 |   9 +-
 net/core/sock.c                                |   3 +-
 net/dcb/dcbnl.c                                |   1 +
 net/dccp/ipv4.c                                |  15 +-
 net/dccp/ipv6.c                                |   2 +-
 net/ipv4/af_inet.c                             |  16 +-
 net/ipv4/cipso_ipv4.c                          | 113 +++++----
 net/ipv4/icmp.c                                |  23 +-
 net/ipv4/inet_connection_sock.c                |   8 +-
 net/ipv4/ip_options.c                          |  38 ++-
 net/ipv4/ip_output.c                           |  50 ++--
 net/ipv4/ip_sockglue.c                         |  35 ++-
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |   8 +
 net/ipv4/raw.c                                 |  19 +-
 net/ipv4/route.c                               |  17 +-
 net/ipv4/syncookies.c                          |   4 +-
 net/ipv4/tcp.c                                 |   2 +-
 net/ipv4/tcp_illinois.c                        |   8 +-
 net/ipv4/tcp_ipv4.c                            |  33 +--
 net/ipv4/tcp_output.c                          |   7 +-
 net/ipv4/udp.c                                 |  21 +-
 net/ipv6/af_inet6.c                            |   2 +
 net/ipv6/ip6_output.c                          |  40 ++-
 net/ipv6/reassembly.c                          |  74 ++----
 net/ipv6/tcp_ipv6.c                            |   2 +-
 net/ipv6/udp.c                                 |   2 +-
 net/irda/af_irda.c                             |   2 +
 net/iucv/af_iucv.c                             |   2 +
 net/llc/af_llc.c                               |   5 +-
 net/netfilter/ipvs/ip_vs_ctl.c                 |   1 +
 net/netfilter/ipvs/ip_vs_xmit.c                |  33 ++-
 net/packet/af_packet.c                         |   1 -
 net/rds/recv.c                                 |   3 +
 net/rose/af_rose.c                             |   1 +
 net/sched/act_gact.c                           |  14 +-
 net/sched/sch_htb.c                            |   2 +-
 net/sctp/auth.c                                |   2 +-
 net/sctp/chunk.c                               |   7 +-
 net/sctp/endpointola.c                         |   5 +
 net/sctp/socket.c                              |   2 +-
 net/socket.c                                   |   6 +-
 net/sunrpc/rpc_pipe.c                          |   2 +-
 net/tipc/socket.c                              |   7 +
 net/unix/af_unix.c                             |   7 +-
 net/xfrm/xfrm_user.c                           |  15 +-
 scripts/Kbuild.include                         |  12 +-
 scripts/gcc-version.sh                         |   6 +-
 scripts/gcc-x86_32-has-stack-protector.sh      |   2 +-
 scripts/gcc-x86_64-has-stack-protector.sh      |   2 +-
 scripts/kconfig/check.sh                       |   2 +-
 scripts/kconfig/lxdialog/check-lxdialog.sh     |   2 +-
 security/keys/process_keys.c                   |   2 +-
 sound/core/seq/seq_timer.c                     |   8 +-
 sound/pci/ac97/ac97_codec.c                    |   2 +
 sound/pci/hda/patch_realtek.c                  | 329 +++++++++++++++++++++++--
 sound/pci/ice1712/ice1712.c                    |   2 +
 usr/gen_init_cpio.c                            |  43 ++--
 virt/kvm/ioapic.c                              |   7 +-
 203 files changed, 1787 insertions(+), 814 deletions(-)




