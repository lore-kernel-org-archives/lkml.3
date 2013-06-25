Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751848Ab3FYSd3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 14:33:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40799 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101Ab3FYSdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 14:33:25 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [ 00/95] 3.9.8-stable review
Date: Tue, 25 Jun 2013 11:31:47 -0700
Message-Id: <20130625182153.605455184@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
User-Agent: quilt/0.60-5.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.9.8 release.
There are 95 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu Jun 27 18:18:29 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.9.8-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.9.8-rc1

Mika Westerberg <mika.westerberg@linux.intel.com>
    spi/pxa2xx: fix memory corruption due to wrong size used in devm_kzalloc()

Mika Westerberg <mika.westerberg@linux.intel.com>
    spi/pxa2xx: use GFP_ATOMIC in sg table allocation

Damian Hobson-Garcia <dhobsong@igel.co.jp>
    drivers: uio: Fix UIO device registration failure

Peter Zijlstra <peterz@infradead.org>
    perf: Fix mmap() accounting hole

Peter Zijlstra <peterz@infradead.org>
    perf: Fix perf mmap bugs

Josh Durgin <josh.durgin@inktank.com>
    rbd: use the correct length for format 2 object names

Joern Engel <joern@logfs.org>
    target/iscsi: don't corrupt bh_count in iscsit_stop_time2retain_timer()

Peter Hurley <peter@hurleysoftware.com>
    tty: Fix transient pty write() EIO

Roland Dreier <roland@purestorage.com>
    tcm_qla2xxx: Fix residual for underrun commands that fail

Ming Lei <ming.lei@canonical.com>
    firmware loader: fix use-after-free by double abort

Anders Hammarquist <iko@iko.pp.se>
    USB: serial: ti_usb_3410_5052: new device id for Abbot strip port cable

Shawn Joseph <jms.576@gmail.com>
    Input: xpad - fix for "Mad Catz Street Fighter IV FightPad" controllers

Ben Hutchings <ben@decadent.org.uk>
    Input: add missing dependencies on CONFIG_HAS_IOMEM

Ferruh Yigit <fery@cypress.com>
    Input: cyttsp - fix memcpy size param

Jason Wang <jasowang@redhat.com>
    net_sched: better precise estimation on packet length for untrusted packets

Jason Wang <jasowang@redhat.com>
    netback: set transport header before passing it to kernel

Jason Wang <jasowang@redhat.com>
    packet: set transport header before doing xmit

Jason Wang <jasowang@redhat.com>
    tuntap: set transport header before passing it to kernel

Jason Wang <jasowang@redhat.com>
    macvtap: set transport header before passing skb to lower device

Jason Wang <jasowang@redhat.com>
    tuntap: correct the return value in tun_set_iff()

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    net: sh_eth: fix incorrect RX length error if R8A7740

Neil Horman <nhorman@tuxdriver.com>
    sctp: fully initialize sctp_outq in sctp_outq_init

Guillaume Nault <g.nault@alphalink.fr>
    l2tp: Fix sendmsg() return value

Guillaume Nault <g.nault@alphalink.fr>
    l2tp: Fix PPP header erasure and memory leak

Daniel Borkmann <dborkman@redhat.com>
    packet: packet_getname_spkt: make sure string is always 0-terminated

Jiri Pirko <jiri@resnulli.us>
    team: move add to port list before port enablement

Jiri Pirko <jiri@resnulli.us>
    team: check return value of team_get_port_by_index_rcu() for NULL

Jason Wang <jasowang@redhat.com>
    tuntap: set SOCK_ZEROCOPY flag during open

Daniel Borkmann <dborkman@redhat.com>
    net: sctp: fix NULL pointer dereference in socket destruction

Jason Wang <jasowang@redhat.com>
    vhost_net: clear msg.control for non-zerocopy case during tx

Eric Dumazet <edumazet@google.com>
    net_sched: htb: do not mix 1ns and 64ns time units

Gao feng <gaofeng@cn.fujitsu.com>
    ipv6: assign rt6_info to inet6_ifaddr in init_loopback

Eric Dumazet <edumazet@google.com>
    net_sched: restore "overhead xxx" handling

Eric Dumazet <eric.dumazet@gmail.com>
    net: force a reload of first item in hlist_nulls_for_each_entry_rcu

Pravin B Shelar <pshelar@nicira.com>
    udp6: Fix udp fragmentation for tunnel traffic.

Jason Wang <jasowang@redhat.com>
    tuntap: forbid changing mq flag for persistent device

Federico Vaga <federico.vaga@gmail.com>
    net/core/sock.c: add missing VSOCK string in af_family_*_key_strings

Andy Lutomirski <luto@amacapital.net>
    net: Block MSG_CMSG_COMPAT in send(m)msg and recv(m)msg

Michal Kubecek <mkubecek@suse.cz>
    ipv4: fix redirect handling for TCP packets

Giuseppe CAVALLARO <peppe.cavallaro@st.com>
    net: phy: fix a bug when verify the EEE support

Eric Dumazet <edumazet@google.com>
    ip_tunnel: fix kernel panic with icmp_dest_unreach

Eric Dumazet <edumazet@google.com>
    tcp: xps: fix reordering issues

Timo Teräs <timo.teras@iki.fi>
    xfrm: properly handle invalid states as an error

Nandita Dukkipati <nanditad@google.com>
    tcp: bug fix in proportional rate reduction.

stephen hemminger <stephen@networkplumber.org>
    8139cp: reset BQL when ring tx ring cleared

Francois Romieu <romieu@fr.zoreil.com>
    r8169: fix offloaded tx checksum for small packets.

Paul Moore <pmoore@redhat.com>
    netlabel: improve domain mapping validation

Eric Dumazet <edumazet@google.com>
    ipv6: fix possible crashes in ip6_cork_release()

Sridhar Samudrala <sri@us.ibm.com>
    vxlan: Update vxlan fdb 'used' field after each usage

Wei Yongjun <yongjun_wei@trendmicro.com.cn>
    gianfar: add missing iounmap() on error in gianfar_ptp_probe()

Eric Dumazet <edumazet@google.com>
    net/802/mrp: fix lockdep splat

Eric Dumazet <edumazet@google.com>
    tcp: fix tcp_md5_hash_skb_data()

Frank Li <Frank.Li@freescale.com>
    net: fec: fix kernel oops when plug/unplug cable many times

Paul Gortmaker <paul.gortmaker@windriver.com>
    x86: Fix section mismatch on load_ucode_ap

Randy Dunlap <rdunlap@infradead.org>
    x86: fix build error and kconfig for ia32_emulation and binfmt

Yinghai Lu <yinghai@kernel.org>
    x86, mtrr: Fix original mtrr range get for mtrr_cleanup

Yinghai Lu <yinghai@kernel.org>
    range: Do not add new blank slot with add_range_with_merge

Jerome Glisse <jglisse@redhat.com>
    drm/radeon: update lockup tracking when scheduling in empty ring

Jerome Glisse <jglisse@redhat.com>
    drm/radeon: do not try to uselessly update virtual memory pagetable

Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
    drm/prime: Honor requested file flags when exporting a buffer

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI / PM: Fix error code path for power resources initialization

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI / dock: Take ACPI scan lock in write_undock()

Mika Westerberg <mika.westerberg@linux.intel.com>
    ACPI / resources: call acpi_get_override_irq() only for legacy IRQ resources

Zhanghaoyu (A) <haoyu.zhang@huawei.com>
    KVM: x86: remove vcpu's CPL check in host-invoked XCR set

Igor Mammedov <imammedo@redhat.com>
    x86: kvmclock: zero initialize pvclock shared memory area

Ben Hutchings <ben@decadent.org.uk>
    x86/efi: Fix dummy variable buffer allocation

Christian Lamparter <chunkeey@googlemail.com>
    carl9170: fix frame drop and WARN due to minstrel_ht change

Thomas Bogendoerfer <tsbogend@alpha.franken.de>
    parisc: provide pci_mmap_page_range() for parisc

Thomas Bogendoerfer <tsbogend@alpha.franken.de>
    parisc: fix serial ports on C8000 workstation

Helge Deller <deller@gmx.de>
    parisc: fix kernel BUG at arch/parisc/include/asm/mmzone.h:50 (part 2)

Helge Deller <deller@gmx.de>
    parisc: parport0: fix this legacy no-device port driver!

Chen Gang <gang.chen@asianux.com>
    parisc: kernel: using strlcpy() instead of strcpy()

Paul Bolle <pebolle@tiscali.nl>
    parisc: rename "CONFIG_PA7100" to "CONFIG_PA7000"

Helge Deller <deller@gmx.de>
    parisc: fix kernel BUG at arch/parisc/include/asm/mmzone.h:50

Chen Gang <gang.chen@asianux.com>
    parisc: memory overflow, 'name' length is too short for using

Helge Deller <deller@gmx.de>
    parisc: fix irq stack on UP and SMP

John David Anglin <dave.anglin@bell.net>
    parisc: make interrupt and interruption stack allocation reentrant

Helge Deller <deller@gmx.de>
    parisc: show number of FPE and unaligned access handler calls in /proc/interrupts

Helge Deller <deller@gmx.de>
    parisc: add rp5470 entry to machine database

Helge Deller <deller@gmx.de>
    parisc: implement irq stacks - part 2 (v2)

Zhao Hongjiang <zhaohongjiang@huawei.com>
    parisc: remove the second argument of kmap_atomic()

Helge Deller <deller@gmx.de>
    parisc: tlb flush counting fix for SMP and UP

Helge Deller <deller@gmx.de>
    parisc: more irq statistics in /proc/interrupts

Helge Deller <deller@gmx.de>
    parisc: implement irq stacks

Helge Deller <deller@gmx.de>
    parisc: add kernel stack overflow check

Hante Meuleman <meuleman@broadcom.com>
    brcmfmac: Turn off ARP offloading when configured for AP.

Larry Finger <Larry.Finger@lwfinger.net>
    rtlwifi: rtl8192cu: Fix problem in connecting to WEP or WPA(1) networks

Chris Metcalf <cmetcalf@tilera.com>
    tilepro: work around module link error with gcc 4.7

Lai Jiangshan <laijs@cn.fujitsu.com>
    clk: remove notifier from list before freeing it

Clemens Ladisch <clemens@ladisch.de>
    ALSA: usb-audio: work around Android accessory firmware bug

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Fix pin configurations for MacBook Air 4,2

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Fix invalid volume resolution for Logitech HD Webcam c310

Jed Davis <jld@mozilla.com>
    perf: arm64: Record the user-mode PC in the call chain.

Gregory CLEMENT <gregory.clement@free-electrons.com>
    ARM: 7754/1: Fix the CPU ID and the mask associated to the PJ4B

Jon Medhurst <tixy@linaro.org>
    ARM: 7752/1: errata: LoUIS bit field in CLIDR register is incorrect


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm/Kconfig                                   |  10 +
 arch/arm/mm/cache-v7.S                             |   8 +
 arch/arm/mm/proc-v7.S                              |   4 +-
 arch/arm64/kernel/perf_event.c                     |   1 +
 arch/parisc/Kconfig                                |   8 +
 arch/parisc/Kconfig.debug                          |  11 +
 arch/parisc/Makefile                               |   2 +-
 arch/parisc/include/asm/assembly.h                 |   1 -
 arch/parisc/include/asm/hardirq.h                  |  38 +++-
 arch/parisc/include/asm/mmzone.h                   |   7 +-
 arch/parisc/include/asm/pci.h                      |   5 +
 arch/parisc/include/asm/processor.h                |   4 -
 arch/parisc/include/asm/thread_info.h              |   2 +-
 arch/parisc/include/asm/tlbflush.h                 |   2 +
 arch/parisc/kernel/cache.c                         |   6 +-
 arch/parisc/kernel/drivers.c                       |   2 +-
 arch/parisc/kernel/entry.S                         |  60 +++++-
 arch/parisc/kernel/hardware.c                      |   2 +
 arch/parisc/kernel/irq.c                           | 198 ++++++++++++++++-
 arch/parisc/kernel/pci.c                           |  27 +++
 arch/parisc/kernel/setup.c                         |   3 +-
 arch/parisc/kernel/smp.c                           |  14 +-
 arch/parisc/kernel/traps.c                         |   1 +
 arch/parisc/kernel/unaligned.c                     |   3 +
 arch/parisc/kernel/vmlinux.lds.S                   |   2 +-
 arch/parisc/mm/init.c                              |   4 +-
 arch/tile/lib/exports.c                            |   2 +
 arch/x86/Kconfig                                   |   1 +
 arch/x86/include/asm/microcode.h                   |   4 +-
 arch/x86/kernel/cpu/mtrr/cleanup.c                 |   8 +-
 arch/x86/kernel/kvmclock.c                         |   1 +
 arch/x86/kvm/x86.c                                 |   5 +-
 arch/x86/platform/efi/efi.c                        |   7 +-
 drivers/acpi/dock.c                                |   2 +
 drivers/acpi/power.c                               |   1 +
 drivers/acpi/resource.c                            |  16 +-
 drivers/base/firmware_class.c                      |  27 ++-
 drivers/block/rbd.c                                |   6 +-
 drivers/clk/clk.c                                  |   1 +
 drivers/gpu/drm/drm_prime.c                        |   3 +-
 drivers/gpu/drm/radeon/radeon_gart.c               |   6 +-
 drivers/gpu/drm/radeon/radeon_ring.c               |   7 +
 drivers/input/joystick/xpad.c                      |   2 +-
 drivers/input/keyboard/Kconfig                     |   1 +
 drivers/input/serio/Kconfig                        |   1 +
 drivers/input/touchscreen/cyttsp_core.c            |   2 +-
 drivers/net/ethernet/freescale/fec.c               |  44 +++-
 drivers/net/ethernet/freescale/fec.h               |  10 +-
 drivers/net/ethernet/freescale/gianfar_ptp.c       |   1 +
 drivers/net/ethernet/realtek/8139cp.c              |   1 +
 drivers/net/ethernet/realtek/r8169.c               |  41 ++--
 drivers/net/ethernet/renesas/sh_eth.c              |  15 +-
 drivers/net/macvtap.c                              |   9 +
 drivers/net/phy/phy.c                              |   2 +-
 drivers/net/team/team.c                            |   2 +-
 drivers/net/team/team_mode_roundrobin.c            |   2 +
 drivers/net/tun.c                                  |  24 ++-
 drivers/net/vxlan.c                                |  17 +-
 drivers/net/wireless/ath/carl9170/tx.c             |  69 +++---
 .../net/wireless/brcm80211/brcmfmac/dhd_common.c   |  18 --
 .../net/wireless/brcm80211/brcmfmac/fwil_types.h   |   6 +
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |  40 +++-
 drivers/net/wireless/rtlwifi/rtl8192cu/hw.c        | 134 +++++++++---
 drivers/net/wireless/rtlwifi/rtl8192cu/hw.h        |   4 -
 drivers/net/wireless/rtlwifi/rtl8192cu/mac.c       |  18 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/sw.c        |   4 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/sw.h        |   3 +
 drivers/net/wireless/rtlwifi/usb.c                 |  13 ++
 drivers/net/wireless/rtlwifi/wifi.h                |   4 +
 drivers/net/xen-netback/netback.c                  |  12 ++
 drivers/parisc/iosapic.c                           |  66 ++++++
 drivers/parport/parport_gsc.c                      |   6 +-
 drivers/parport/parport_gsc.h                      |   2 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c                 |   6 +-
 drivers/spi/spi-pxa2xx-dma.c                       |   2 +-
 drivers/spi/spi-pxa2xx.c                           |   2 +-
 drivers/target/iscsi/iscsi_target_erl0.c           |   4 +-
 drivers/tty/pty.c                                  |  13 +-
 drivers/tty/serial/8250/8250_gsc.c                 |  10 +-
 drivers/uio/uio.c                                  |   1 +
 drivers/usb/serial/ti_usb_3410_5052.c              |   3 +-
 drivers/usb/serial/ti_usb_3410_5052.h              |   4 +-
 drivers/vhost/net.c                                |   3 +-
 include/linux/perf_event.h                         |   3 +-
 include/linux/rculist_nulls.h                      |   7 +-
 include/linux/skbuff.h                             |  15 ++
 include/linux/socket.h                             |   3 +
 include/net/sch_generic.h                          |  18 +-
 kernel/events/core.c                               | 233 ++++++++++++++-------
 kernel/events/internal.h                           |   4 +
 kernel/range.c                                     |  21 +-
 net/802/mrp.c                                      |   4 +-
 net/compat.c                                       |  13 +-
 net/core/dev.c                                     |   8 +-
 net/core/sock.c                                    |   6 +-
 net/ipv4/ip_gre.c                                  |   2 +-
 net/ipv4/ipip.c                                    |   2 +-
 net/ipv4/route.c                                   |   7 +-
 net/ipv4/tcp.c                                     |   7 +-
 net/ipv4/tcp_input.c                               |  23 +-
 net/ipv4/tcp_output.c                              |  10 +-
 net/ipv6/addrconf.c                                |   4 +-
 net/ipv6/ip6_output.c                              |   2 +-
 net/ipv6/udp_offload.c                             |  20 +-
 net/l2tp/l2tp_ppp.c                                |   6 +-
 net/netlabel/netlabel_domainhash.c                 |  69 ++++++
 net/packet/af_packet.c                             |  26 ++-
 net/sched/act_police.c                             |   8 +-
 net/sched/sch_generic.c                            |   8 +-
 net/sched/sch_htb.c                                |  42 ++--
 net/sched/sch_tbf.c                                |   8 +-
 net/sctp/outqueue.c                                |   8 +-
 net/sctp/socket.c                                  |   6 +
 net/socket.c                                       |  61 ++++--
 net/xfrm/xfrm_output.c                             |   1 +
 sound/pci/hda/patch_cirrus.c                       |  23 ++
 sound/usb/card.c                                   |  22 +-
 sound/usb/mixer.c                                  |   1 +
 119 files changed, 1413 insertions(+), 435 deletions(-)


