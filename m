Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209Ab3DUWAr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 18:00:47 -0400
Received: from mail-vb0-f51.google.com ([209.85.212.51]:56676 "EHLO
	mail-vb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104Ab3DUWAo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 18:00:44 -0400
MIME-Version: 1.0
Date: Sun, 21 Apr 2013 15:00:43 -0700
X-Google-Sender-Auth: QScli9IxB-Fds5kW6vnFlpv8iIQ
Message-ID: <CA+55aFyiByzrqGQ-KQcPuOQS_k=PgRRsUcQ6mRS-tCiANB+N3A@mail.gmail.com>
Subject: Linux 3.9-rc8
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, I was really hoping (and originally planning) to release 3.9
final this weekend, but we had enough issues that I just didn't feel
comfy about it. It was borderline, and none of the issues were huge,
and maybe I could have called this just 3.9 and opened the merge
window, but hey, another week won't hurt.

The bulk of the changes here are networking (both core and drivers),
but there's arch fixes (sparc, x86, arm, powepc) and random other
stuff. A couple of reverts and some cleanups. The shortlog gives some
flavor of the details. Nothing here on its own would have delayed 3.9
for me, but I was hoping for a calmer week.

Please don't send me pull requests unless it's something really
critical, and let's aim for a nice calm 3.9 release next weekend, ok?

                  Linus

---
Aaro Koskinen (1):
      ARM: 7692/1: iop3xx: move IOP3XX_PERIPHERAL_VIRT_BASE

Abhijeet Dharmapurikar (1):
      irqchip: gic: fix irq_trigger return

Akinobu Mita (2):
      sparc/srmmu: clear trailing edge of bitmap properly
      sparc/iommu: fix typo s/265KB/256KB/

Alex Elder (1):
      rbd: do a safe list traversal in rbd_img_request_submit()

Alexander Duyck (1):
      igb: Revert support for build_skb in igb

Alistair Popple (1):
      powerpc: Fix audit crash due to save/restore PPR changes

Andreas Schwab (1):
      kbuild: generate generic headers before recursing into scripts

Andrei Epure (1):
      drivers/video/mmp/core.c: fix use-after-free bug

Andy Lutomirski (2):
      userns: Check uid_map's opener's fsuid, not the current fsuid
      userns: Changing any namespace id mappings should require privileges

Antonio Quartulli (1):
      batman-adv: make is_my_mac() check for the current mesh only

Arend van Spriel (2):
      brcmfmac: remove advertising P2P device support
      brcmsmac: request firmware in .start() callback

Ariel Elior (1):
      bnx2x: Fix status blocks configuration

Arnd Bergmann (1):
      net: ax88796: avoid 64 bit arithmetic

Bastian Hecht (1):
      ARM: 7697/1: hw_breakpoint: do not use __cpuinitdata for dbg_cpu_pm_nb

Ben Greear (1):
      net: rate-limit warn-bad-offload splats.

Bjørn Mork (4):
      net: cdc_mbim: remove bogus sizeof()
      net: qmi_wwan: fixup missing ethernet header (firmware bug workaround)
      net: qmi_wwan: fixup destination address (firmware bug workaround)
      net: qmi_wwan: prevent duplicate mac address on link (firmware
bug workaround)

Christian Ruppert (1):
      stmmac: prevent interrupt loop with MMC RX IPC Counter

Christoph Fritz (1):
      can: sja1000: fix handling on dt properties on little endian systems

Cong Wang (1):
      ipv6: statically link register_inet6addr_notifier()

Dan Carpenter (1):
      irda: small read past the end of array in debug code

David S. Miller (1):
      sparc64: Fix race in TLB batch processing.

David Ward (1):
      net/802/mrp: fix possible race condition when calling mrp_pdu_queue()

Dmitry Kravkov (1):
      bnx2x: Prevent UNDI FW illegal host access

Dmitry Popov (1):
      tcp: incoming connections might use wrong route under synflood

Emese Revfy (1):
      kernel/signal.c: stop info leak via the tkill and the tgkill syscalls

Eric Dumazet (3):
      net: drop dst before queueing fragments
      bonding: fix l23 and l34 load balancing in forwarding path
      tcp: call tcp_replace_ts_recent() from tcp_ack()

Eric W. Biederman (1):
      userns: Don't let unprivileged users trick privileged users into
setting the id_map

Felix Fietkau (2):
      ath9k_htc: accept 1.x firmware newer than 1.3
      ath9k_hw: change AR9580 initvals to fix a stability issue

Florian Westphal (2):
      netfilter: nf_nat: fix race when unloading protocol modules
      netfilter: xt_rpfilter: skip locally generated broadcast/multicast, too

Greg Rose (1):
      ixgbe: Fix a bug in setting VF VLAN via PF

H. Peter Anvin (1):
      x86, microcode: Verify the family before dispatching microcode patching

Himanshu Madhani (1):
      qlcnic: fix beaconing test for 82xx adapter

Hong Zhiguo (1):
      openvswitch: correct an invalid BUG_ON

Illia Ragozin (1):
      ARM: 7696/1: Fix kexec by setting outer_cache.inv_all for Feroceon

Ivan Vecera (1):
      be2net: take care of __vlan_put_tag return value

Jason Gerecke (2):
      Input: wacom - fix "can not retrieve extra class descriptor" for 24HDT
      Input: wacom - correct reported resolution for Intuos4 Wireless

Jesse Gross (1):
      openvswitch: Preallocate reply skb in ovs_vport_cmd_set().

Jitendra Kalsaria (3):
      qlcnic: Stop traffic before performing loopback test
      qlge: Fix ethtool autoneg advertising.
      qlge: Update version to 1.00.00.32.

Joe Perches (1):
      checkpatch: fix stringification macro defect

Johannes Berg (2):
      mac80211: fix LED in idle handling
      mac80211: fix cfg80211 interaction on auth/assoc request

Joonsoo Kim (1):
      ARM: 7694/1: ARM, TCM: initialize TCM in paging_init(), instead
of setup_arch()

Josh Wu (1):
      avr32: fix build error in atstk1006_defconfig

Jozsef Kadlecsik (3):
      netfilter: ipset: list:set: fix reference counter update
      netfilter: ipset: hash:*net*: nomatch flag not excluded on set resize
      netfilter: ipset: bitmap:ip,mac: fix listing with timeout

K. Y. Srinivasan (1):
      x86, hyperv: Handle Xen emulation of Hyper-V more gracefully

Kefeng Wang (2):
      sparc:remove unused declaration smp_boot_cpus()
      sparc:cleanup unused code in smp_32.h

Kevin Hao (1):
      powerpc: add a missing label in resume_kernel

Len Brown (2):
      intel_idle: additional Haswell CPU-id
      tools/power turbostat: additional Haswell CPU-id

Linus Torvalds (10):
      vm: add vm_iomap_memory() helper function
      s390: move dummy io_remap_pfn_range() to asm/pgtable.h
      Revert "block: add missing block_bio_complete() tracepoint"
      vm: convert HPET mmap to vm_iomap_memory() helper
      vm: convert mtdchar mmap to vm_iomap_memory() helper
      vm: convert fb_mmap to vm_iomap_memory() helper
      vm: convert snd_pcm_lib_mmap_iomem() to vm_iomap_memory() helper
      mtdchar: remove no-longer-used vma helpers
      net: fix incorrect credentials passing
      Linux 3.9-rc8

Lucas Stach (1):
      net: fec: fix regression in link change accounting

Ludovic Desroches (1):
      dmaengine: at_hdmac: fix race condition in atc_advance_work()

Marc Kleine-Budde (1):
      can: mcp251x: add missing IRQF_ONESHOT to request_threaded_irq

Marc Zyngier (3):
      ARM: KVM: fix KVM_CAP_ARM_SET_DEVICE_ADDR reporting
      ARM: KVM: fix L_PTE_S2_RDWR to actually be Read/Write
      ARM: KVM: fix unbalanced get_cpu() in access_dcsw

Masami Hiramatsu (1):
      kprobes: Fix a double lock bug of kprobe_mutex

Matt Fleming (1):
      x86, efivars: firmware bug workarounds should be in platform code

Matthew Garrett (4):
      Move utf16 functions to kernel core and rename
      efi: Pass boot services variable info to runtime code
      efi: Distinguish between "remaining space" and actually used space
      Revert "hp-wmi: Add support for SMBus hotkeys"

Michael Bohan (1):
      hrtimer: Don't reinitialize a cpu_base lock on CPU_UP

Michael Neuling (1):
      powerpc: fix compiling CONFIG_PPC_TRANSACTIONAL_MEM when CONFIG_ALTIVEC=n

Miklos Szeredi (1):
      fuse: fix type definitions in uapi header

Mugunthan V N (1):
      drivers: net: ethernet: cpsw: get slave VLAN id from slave node
instead of cpsw node

Naoya Horiguchi (3):
      hugetlbfs: stop setting VM_DONTDUMP in initializing vma(VM_HUGETLB)
      fs/binfmt_elf.c: fix hugetlb memory check in vma_dump_size()
      hugetlbfs: add swap entry check in follow_hugetlb_page()

Oleg Nesterov (1):
      thinkpad-acpi: kill hotkey_thread_mutex

Patrick McHardy (1):
      netfilter: nf_ct_sip: don't drop packets with offsets pointing
outside the packet

Ping Cheng (2):
      Input: wacom - DTH2242 Grip Pen id was off by one bit
      Input: wacom - fix "can not retrieve extra class descriptor" for DTH2242

Rafał Miłecki (1):
      ssb: implement spurious tone avoidance

Richard Weinberger (2):
      x86,efi: Check max_size only if it is non-zero.
      x86,efi: Implement efi_no_storage_paranoia parameter

Rob Herring (1):
      ARM: highbank: fix cache flush ordering for cpu hotplug

Russell King (1):
      ARM: Do 15e0d9e37c (ARM: pm: let platforms select cpu_suspend
support) properly

Sam Ravnborg (3):
      sparc: use generic headers
      bbc_i2c: fix section mismatch warning
      sparc: use asm-generic version of types.h

Scott Wood (4):
      kvm/powerpc/e500mc: fix tlb invalidation on cpu migration
      kvm/ppc/e500: h2g_tlb1_rmap: esel 0 is valid
      kvm/ppc/e500: g2h_tlb1_map: clear old bit before setting new bit
      kvm/ppc/e500: eliminate tlb_refs

Sergey Vlasov (2):
      x86/Kconfig: Make EFI select UCS2_STRING
      efi: Export efi_query_variable_store() for efivars.ko

Shahed Shaikh (1):
      qlcnic: Fix typo in logs

Sritej Velaga (2):
      qlcnic: fix TSO race condition
      qlge: Fix receive path to drop error frames

Stephane Eranian (1):
      perf/x86: Fix offcore_rsp valid mask for SNB/IVB

Stephen Boyd (1):
      ARM: 7699/1: sched_clock: Add more notrace to prevent recursion

Thomas Gleixner (1):
      kthread: Prevent unpark race which puts threads on the wrong cpu

Thomas Graf (1):
      tcp: Reallocate headroom if it would overflow csum_start

Thomas Petazzoni (1):
      net: mvmdio: add select PHYLIB

Tommi Rantala (1):
      perf: Treat attr.config as u64 in perf_swevent_init()

Vyacheslav Dubeyko (1):
      hfsplus: fix potential overflow in hfsplus_file_truncate()

Wei Yongjun (3):
      tuntap: fix error return code in tun_set_iff()
      esp4: fix error return code in esp_output()
      pkt_sched: fix error return code in fw_change_attrs()

Will Deacon (6):
      ARM: tlbflush: remove ARMv3 support
      ARM: cache: remove ARMv3 support code
      ARM: mm: fix numerous hideous errors in proc-arm740.S
      ARM: mm: remove broken condition check for v4 flushing
      ARM: modules: don't export cpu_set_pte_ext when !MMU
      ARM: 7698/1: perf: fix group validation when using enable_on_exec

Willy Tarreau (1):
      net: mvneta: fix improper tx queue usage in mvneta_tx()

Xishi Qiu (1):
      mm/vmscan: fix error return in kswapd_run()

Yinghai Lu (4):
      x86, kdump: Set crashkernel_low automatically
      x86, kdump: Retore crashkernel= to allocate under 896M
      x86, kdump: Change crashkernel_high/low= to crashkernel=,high/low
      kexec: use Crash kernel for Crash kernel low

Zefir Kurtisi (1):
      ath9k: fix DFS detector called in softirq context

nikolay@redhat.com (7):
      bonding: fix netdev event NULL pointer dereference
      bonding: IFF_BONDING is not stripped on enslave failure
      bonding: mc addresses don't get deleted on enslave failure
      bonding: vlans don't get deleted on enslave failure
      bonding: primary_slave & curr_active_slave are not cleaned on
enslave failure
      bonding: disable netpoll on enslave failure
      bonding: in bond_mc_swap() bond's mc addr list is walked without lock

stephen hemminger (1):
      bridge: make user modified path cost sticky
