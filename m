Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355Ab3F2U6b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jun 2013 16:58:31 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:37718 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295Ab3F2U60 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jun 2013 16:58:26 -0400
MIME-Version: 1.0
In-Reply-To: <20130627175936.GA8732@kroah.com>
References: <20130627175936.GA8732@kroah.com>
From: Sergey Meirovich <rathamahata@gmail.com>
Date: Sat, 29 Jun 2013 23:58:04 +0300
Message-ID: <CA+QCeVTdiGNz05_L0MWVnY6W88tgt_gy4Duk5MoUR7Xi6KpRsg@mail.gmail.com>
Subject: Re: Linux 3.9.8
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, stable@vger.kernel.org,
        lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 27 June 2013 20:59, Greg KH <gregkh@linuxfoundation.org> wrote:
> I'm announcing the release of the 3.9.8 kernel.
>
> All users of the 3.9 kernel series must upgrade.

I've got issues with my radeon ("01:00.0 VGA compatible controller:
Advanced Micro Devices, Inc. [AMD/ATI] Thames [Radeon HD 7500M/7600M
Series]") APU on 3.9.8

...
[   20.944106] BUG: unable to handle kernel NULL pointer dereference
at 00000000000001f8
[   20.945753] IP: [<ffffffff812a11a3>] radeon_vm_bo_add+0xb3/0x110
[   20.946498] PGD 243c0a067 PUD 243cbb067 PMD 0
[   20.947236] Oops: 0000 [#1] PREEMPT SMP
[   20.947964] Modules linked in:
[   20.948675] CPU 3
[   20.948682] Pid: 2759, comm: X Not tainted 3.9.8 #1 SAMSUNG
ELECTRONICS CO., LTD.
355V4C/355V4X/355V5C/355V5X/356V4C/356V4X/356V5C/356V5X/3445VC/3445VX/3545VC/3545VX/NP355V5C-S0NRU
[   20.950160] RIP: 0010:[<ffffffff812a11a3>]  [<ffffffff812a11a3>]
radeon_vm_bo_add+0xb3/0x110
[   20.950961] RSP: 0018:ffff880244dd3c08  EFLAGS: 00010246
[   20.951745] RAX: ffff88024578a210 RBX: ffff880243f7c2a0 RCX: 0000000000000000
[   20.952534] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88024578a240
[   20.953331] RBP: ffff88024578a200 R08: 0000000000014400 R09: ffff880243f7c2a0
[   20.954131] R10: 0000000000000005 R11: ffffffffffffffff R12: 00000000000001f0
[   20.954941] R13: ffff880243f7c2d0 R14: ffff88024578a240 R15: ffff880245fa9000
[   20.955757] FS:  00007f5c2424e880(0000) GS:ffff88024ed80000(0000)
knlGS:0000000000000000
[   20.956590] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   20.957424] CR2: 00000000000001f8 CR3: 00000002451c3000 CR4: 00000000000407e0
[   20.958273] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   20.959124] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   20.959969] Process X (pid: 2759, threadinfo ffff880244dd2000, task
ffff880245e277f0)
[   20.960828] Stack:
[   20.961679]  ffff880245fba000 ffff88024578a200 ffff880244ea8800
ffff880244ea8800
[   20.962572]  ffff880244ea8820 ffffffff81289dab ffff880245fa9020
ffff880245fa9020
[   20.963463]  ffff8802450f25c8 ffff880243cbd400 ffffffff812650c1
0000000000000000
[   20.964362] Call Trace:
[   20.965250]  [<ffffffff81289dab>] ? radeon_driver_open_kms+0x6b/0xd0
[   20.966165]  [<ffffffff812650c1>] ? drm_open+0x281/0x6d0
[   20.967075]  [<ffffffff810d92e8>] ? exact_lock+0x8/0x20
[   20.967980]  [<ffffffff81265e63>] ? drm_stub_open+0x103/0x1a0
[   20.968886]  [<ffffffff810d9716>] ? chrdev_open+0x96/0x1c0
[   20.969787]  [<ffffffff810d9680>] ? cdev_put+0x20/0x20
[   20.970682]  [<ffffffff810d3a42>] ? do_dentry_open.isra.18+0x192/0x280
[   20.971588]  [<ffffffff810d3b45>] ? finish_open+0x15/0x20
[   20.972489]  [<ffffffff810e220b>] ? do_last.isra.59+0x29b/0xc90
[   20.973393]  [<ffffffff810b0000>] ? __do_fault+0x1e0/0x500
[   20.974294]  [<ffffffff810e2cb5>] ? path_openat.isra.60+0xb5/0x4b0
[   20.975199]  [<ffffffff810b2d3b>] ? handle_pte_fault+0x9b/0x7a0
[   20.976105]  [<ffffffff810e3e60>] ? do_filp_open+0x40/0x90
[   20.977010]  [<ffffffff810eff97>] ? __alloc_fd+0x97/0x120
[   20.977904]  [<ffffffff810d4bb3>] ? do_sys_open+0xf3/0x1d0
[   20.978797]  [<ffffffff81653f52>] ? system_call_fastpath+0x16/0x1b
[   20.979690] Code: 89 5b 08 4c 89 6b 30 4c 89 6b 38 e8 68 f8 3a 00
48 8b 45 10 4c 89 f7 4c 89 68 08 48 89 43 30 48 8d 45 10 48 89 43 38
4c 89 6d 10 <49> 8b 44 24 08 49 89 5c 24 08 4c 89 23 48 89 43 08 48 89
18 e8
[   20.981714] RIP  [<ffffffff812a11a3>] radeon_vm_bo_add+0xb3/0x110
[   20.982673]  RSP <ffff880244dd3c08>
[   20.983616] CR2: 00000000000001f8
[   20.984613] ---[ end trace 4c43aa9ba50a68eb ]---



>
> The updated 3.9.y git tree can be found at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-3.9.y
> and can be browsed at the normal kernel.org git web browser:
>         http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary
>
> thanks,
>
> greg k-h
>
> ------------
>
>  Makefile                                              |    2
>  arch/arm/Kconfig                                      |   10
>  arch/arm/mm/cache-v7.S                                |    8
>  arch/arm/mm/proc-v7.S                                 |    4
>  arch/arm64/kernel/perf_event.c                        |    1
>  arch/parisc/Kconfig                                   |    8
>  arch/parisc/Kconfig.debug                             |   11
>  arch/parisc/Makefile                                  |    2
>  arch/parisc/include/asm/assembly.h                    |    1
>  arch/parisc/include/asm/hardirq.h                     |   38 ++
>  arch/parisc/include/asm/mmzone.h                      |    7
>  arch/parisc/include/asm/pci.h                         |    5
>  arch/parisc/include/asm/processor.h                   |    4
>  arch/parisc/include/asm/thread_info.h                 |    2
>  arch/parisc/include/asm/tlbflush.h                    |    2
>  arch/parisc/kernel/cache.c                            |    6
>  arch/parisc/kernel/drivers.c                          |    2
>  arch/parisc/kernel/entry.S                            |   60 +++-
>  arch/parisc/kernel/hardware.c                         |    2
>  arch/parisc/kernel/irq.c                              |  198 +++++++++++++++
>  arch/parisc/kernel/pci.c                              |   27 ++
>  arch/parisc/kernel/setup.c                            |    3
>  arch/parisc/kernel/smp.c                              |   14 -
>  arch/parisc/kernel/traps.c                            |    1
>  arch/parisc/kernel/unaligned.c                        |    3
>  arch/parisc/kernel/vmlinux.lds.S                      |    2
>  arch/parisc/mm/init.c                                 |    4
>  arch/tile/lib/exports.c                               |    2
>  arch/x86/Kconfig                                      |    1
>  arch/x86/include/asm/microcode.h                      |    4
>  arch/x86/kernel/cpu/mtrr/cleanup.c                    |    8
>  arch/x86/kernel/kvmclock.c                            |    1
>  arch/x86/kvm/x86.c                                    |    5
>  arch/x86/platform/efi/efi.c                           |    7
>  drivers/acpi/dock.c                                   |    2
>  drivers/acpi/power.c                                  |    1
>  drivers/acpi/resource.c                               |   16 -
>  drivers/base/firmware_class.c                         |   27 +-
>  drivers/block/rbd.c                                   |    6
>  drivers/clk/clk.c                                     |    1
>  drivers/gpu/drm/drm_prime.c                           |    3
>  drivers/gpu/drm/radeon/radeon_gart.c                  |    6
>  drivers/gpu/drm/radeon/radeon_ring.c                  |    7
>  drivers/input/joystick/xpad.c                         |    2
>  drivers/input/keyboard/Kconfig                        |    1
>  drivers/input/serio/Kconfig                           |    1
>  drivers/input/touchscreen/cyttsp_core.c               |    2
>  drivers/net/ethernet/freescale/fec.c                  |   44 ++-
>  drivers/net/ethernet/freescale/fec.h                  |   10
>  drivers/net/ethernet/freescale/gianfar_ptp.c          |    1
>  drivers/net/ethernet/realtek/8139cp.c                 |    1
>  drivers/net/ethernet/realtek/r8169.c                  |   41 ++-
>  drivers/net/ethernet/renesas/sh_eth.c                 |   15 -
>  drivers/net/macvtap.c                                 |    9
>  drivers/net/phy/phy.c                                 |    2
>  drivers/net/team/team.c                               |    2
>  drivers/net/team/team_mode_roundrobin.c               |    2
>  drivers/net/tun.c                                     |   24 +
>  drivers/net/vxlan.c                                   |   17 +
>  drivers/net/wireless/ath/carl9170/tx.c                |   69 ++---
>  drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c  |   18 -
>  drivers/net/wireless/brcm80211/brcmfmac/fwil_types.h  |    6
>  drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c |   40 +++
>  drivers/net/wireless/rtlwifi/rtl8192cu/hw.c           |  134 +++++++---
>  drivers/net/wireless/rtlwifi/rtl8192cu/hw.h           |    4
>  drivers/net/wireless/rtlwifi/rtl8192cu/mac.c          |   18 +
>  drivers/net/wireless/rtlwifi/rtl8192cu/sw.c           |    4
>  drivers/net/wireless/rtlwifi/rtl8192cu/sw.h           |    3
>  drivers/net/wireless/rtlwifi/usb.c                    |   13 +
>  drivers/net/wireless/rtlwifi/wifi.h                   |    4
>  drivers/net/xen-netback/netback.c                     |   12
>  drivers/parisc/iosapic.c                              |   66 +++++
>  drivers/parport/parport_gsc.c                         |    6
>  drivers/parport/parport_gsc.h                         |    2
>  drivers/scsi/qla2xxx/tcm_qla2xxx.c                    |    6
>  drivers/spi/spi-pxa2xx-dma.c                          |    2
>  drivers/spi/spi-pxa2xx.c                              |    2
>  drivers/target/iscsi/iscsi_target_erl0.c              |    4
>  drivers/tty/pty.c                                     |   13 -
>  drivers/tty/serial/8250/8250_gsc.c                    |   10
>  drivers/uio/uio.c                                     |    1
>  drivers/usb/serial/ti_usb_3410_5052.c                 |    3
>  drivers/usb/serial/ti_usb_3410_5052.h                 |    4
>  drivers/vhost/net.c                                   |    3
>  include/linux/perf_event.h                            |    3
>  include/linux/rculist_nulls.h                         |    7
>  include/linux/skbuff.h                                |   15 +
>  include/linux/socket.h                                |    3
>  include/net/sch_generic.h                             |   18 -
>  kernel/events/core.c                                  |  233 ++++++++++++------
>  kernel/events/internal.h                              |    4
>  kernel/range.c                                        |   21 -
>  net/802/mrp.c                                         |    4
>  net/compat.c                                          |   13 -
>  net/core/dev.c                                        |    8
>  net/core/sock.c                                       |    6
>  net/ipv4/ip_gre.c                                     |    2
>  net/ipv4/ipip.c                                       |    2
>  net/ipv4/route.c                                      |    7
>  net/ipv4/tcp.c                                        |    7
>  net/ipv4/tcp_input.c                                  |   23 +
>  net/ipv4/tcp_output.c                                 |   10
>  net/ipv6/addrconf.c                                   |    4
>  net/ipv6/ip6_output.c                                 |    2
>  net/ipv6/udp_offload.c                                |   20 -
>  net/l2tp/l2tp_ppp.c                                   |    6
>  net/netlabel/netlabel_domainhash.c                    |   69 +++++
>  net/packet/af_packet.c                                |   26 +-
>  net/sched/act_police.c                                |    8
>  net/sched/sch_generic.c                               |    8
>  net/sched/sch_htb.c                                   |   42 +--
>  net/sched/sch_tbf.c                                   |    8
>  net/sctp/outqueue.c                                   |    8
>  net/sctp/socket.c                                     |    6
>  net/socket.c                                          |   61 +++-
>  net/xfrm/xfrm_output.c                                |    1
>  sound/pci/hda/patch_cirrus.c                          |   23 +
>  sound/usb/card.c                                      |   22 +
>  sound/usb/mixer.c                                     |    1
>  119 files changed, 1412 insertions(+), 434 deletions(-)
>
> Anders Hammarquist (1):
>       USB: serial: ti_usb_3410_5052: new device id for Abbot strip port cable
>
> Andy Lutomirski (1):
>       net: Block MSG_CMSG_COMPAT in send(m)msg and recv(m)msg
>
> Ben Hutchings (2):
>       x86/efi: Fix dummy variable buffer allocation
>       Input: add missing dependencies on CONFIG_HAS_IOMEM
>
> Chen Gang (2):
>       parisc: memory overflow, 'name' length is too short for using
>       parisc: kernel: using strlcpy() instead of strcpy()
>
> Chris Metcalf (1):
>       tilepro: work around module link error with gcc 4.7
>
> Christian Lamparter (1):
>       carl9170: fix frame drop and WARN due to minstrel_ht change
>
> Clemens Ladisch (1):
>       ALSA: usb-audio: work around Android accessory firmware bug
>
> Damian Hobson-Garcia (1):
>       drivers: uio: Fix UIO device registration failure
>
> Daniel Borkmann (2):
>       net: sctp: fix NULL pointer dereference in socket destruction
>       packet: packet_getname_spkt: make sure string is always 0-terminated
>
> Eric Dumazet (8):
>       tcp: fix tcp_md5_hash_skb_data()
>       net/802/mrp: fix lockdep splat
>       ipv6: fix possible crashes in ip6_cork_release()
>       tcp: xps: fix reordering issues
>       ip_tunnel: fix kernel panic with icmp_dest_unreach
>       net: force a reload of first item in hlist_nulls_for_each_entry_rcu
>       net_sched: restore "overhead xxx" handling
>       net_sched: htb: do not mix 1ns and 64ns time units
>
> Federico Vaga (1):
>       net/core/sock.c: add missing VSOCK string in af_family_*_key_strings
>
> Ferruh Yigit (1):
>       Input: cyttsp - fix memcpy size param
>
> Francois Romieu (1):
>       r8169: fix offloaded tx checksum for small packets.
>
> Frank Li (1):
>       net: fec: fix kernel oops when plug/unplug cable many times
>
> Gao feng (1):
>       ipv6: assign rt6_info to inet6_ifaddr in init_loopback
>
> Giuseppe CAVALLARO (1):
>       net: phy: fix a bug when verify the EEE support
>
> Greg Kroah-Hartman (1):
>       Linux 3.9.8
>
> Gregory CLEMENT (1):
>       ARM: 7754/1: Fix the CPU ID and the mask associated to the PJ4B
>
> Guillaume Nault (2):
>       l2tp: Fix PPP header erasure and memory leak
>       l2tp: Fix sendmsg() return value
>
> Hante Meuleman (1):
>       brcmfmac: Turn off ARP offloading when configured for AP.
>
> Helge Deller (11):
>       parisc: add kernel stack overflow check
>       parisc: implement irq stacks
>       parisc: more irq statistics in /proc/interrupts
>       parisc: tlb flush counting fix for SMP and UP
>       parisc: implement irq stacks - part 2 (v2)
>       parisc: add rp5470 entry to machine database
>       parisc: show number of FPE and unaligned access handler calls in /proc/interrupts
>       parisc: fix irq stack on UP and SMP
>       parisc: fix kernel BUG at arch/parisc/include/asm/mmzone.h:50
>       parisc: parport0: fix this legacy no-device port driver!
>       parisc: fix kernel BUG at arch/parisc/include/asm/mmzone.h:50 (part 2)
>
> Igor Mammedov (1):
>       x86: kvmclock: zero initialize pvclock shared memory area
>
> Jason Wang (9):
>       tuntap: forbid changing mq flag for persistent device
>       vhost_net: clear msg.control for non-zerocopy case during tx
>       tuntap: set SOCK_ZEROCOPY flag during open
>       tuntap: correct the return value in tun_set_iff()
>       macvtap: set transport header before passing skb to lower device
>       tuntap: set transport header before passing it to kernel
>       packet: set transport header before doing xmit
>       netback: set transport header before passing it to kernel
>       net_sched: better precise estimation on packet length for untrusted packets
>
> Jed Davis (1):
>       perf: arm64: Record the user-mode PC in the call chain.
>
> Jerome Glisse (2):
>       drm/radeon: do not try to uselessly update virtual memory pagetable
>       drm/radeon: update lockup tracking when scheduling in empty ring
>
> Jiri Pirko (2):
>       team: check return value of team_get_port_by_index_rcu() for NULL
>       team: move add to port list before port enablement
>
> Joern Engel (1):
>       target/iscsi: don't corrupt bh_count in iscsit_stop_time2retain_timer()
>
> John David Anglin (1):
>       parisc: make interrupt and interruption stack allocation reentrant
>
> Jon Medhurst (1):
>       ARM: 7752/1: errata: LoUIS bit field in CLIDR register is incorrect
>
> Josh Durgin (1):
>       rbd: use the correct length for format 2 object names
>
> Lai Jiangshan (1):
>       clk: remove notifier from list before freeing it
>
> Larry Finger (1):
>       rtlwifi: rtl8192cu: Fix problem in connecting to WEP or WPA(1) networks
>
> Laurent Pinchart (1):
>       drm/prime: Honor requested file flags when exporting a buffer
>
> Michal Kubecek (1):
>       ipv4: fix redirect handling for TCP packets
>
> Mika Westerberg (3):
>       ACPI / resources: call acpi_get_override_irq() only for legacy IRQ resources
>       spi/pxa2xx: use GFP_ATOMIC in sg table allocation
>       spi/pxa2xx: fix memory corruption due to wrong size used in devm_kzalloc()
>
> Ming Lei (1):
>       firmware loader: fix use-after-free by double abort
>
> Nandita Dukkipati (1):
>       tcp: bug fix in proportional rate reduction.
>
> Neil Horman (1):
>       sctp: fully initialize sctp_outq in sctp_outq_init
>
> Paul Bolle (1):
>       parisc: rename "CONFIG_PA7100" to "CONFIG_PA7000"
>
> Paul Gortmaker (1):
>       x86: Fix section mismatch on load_ucode_ap
>
> Paul Moore (1):
>       netlabel: improve domain mapping validation
>
> Peter Hurley (1):
>       tty: Fix transient pty write() EIO
>
> Peter Zijlstra (2):
>       perf: Fix perf mmap bugs
>       perf: Fix mmap() accounting hole
>
> Pravin B Shelar (1):
>       udp6: Fix udp fragmentation for tunnel traffic.
>
> Rafael J. Wysocki (2):
>       ACPI / dock: Take ACPI scan lock in write_undock()
>       ACPI / PM: Fix error code path for power resources initialization
>
> Randy Dunlap (1):
>       x86: fix build error and kconfig for ia32_emulation and binfmt
>
> Roland Dreier (1):
>       tcm_qla2xxx: Fix residual for underrun commands that fail
>
> Shawn Joseph (1):
>       Input: xpad - fix for "Mad Catz Street Fighter IV FightPad" controllers
>
> Sridhar Samudrala (1):
>       vxlan: Update vxlan fdb 'used' field after each usage
>
> Takashi Iwai (2):
>       ALSA: usb-audio: Fix invalid volume resolution for Logitech HD Webcam c310
>       ALSA: hda - Fix pin configurations for MacBook Air 4,2
>
> Thomas Bogendoerfer (2):
>       parisc: fix serial ports on C8000 workstation
>       parisc: provide pci_mmap_page_range() for parisc
>
> Timo Teräs (1):
>       xfrm: properly handle invalid states as an error
>
> Wei Yongjun (1):
>       gianfar: add missing iounmap() on error in gianfar_ptp_probe()
>
> Yinghai Lu (2):
>       range: Do not add new blank slot with add_range_with_merge
>       x86, mtrr: Fix original mtrr range get for mtrr_cleanup
>
> Yoshihiro Shimoda (1):
>       net: sh_eth: fix incorrect RX length error if R8A7740
>
> Zhanghaoyu (A) (1):
>       KVM: x86: remove vcpu's CPL check in host-invoked XCR set
>
> Zhao Hongjiang (1):
>       parisc: remove the second argument of kmap_atomic()
>
> stephen hemminger (1):
>       8139cp: reset BQL when ring tx ring cleared
>
