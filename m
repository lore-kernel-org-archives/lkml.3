Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755788Ab3HRWNB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 18:13:01 -0400
Received: from mail-ve0-f180.google.com ([209.85.128.180]:34964 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755215Ab3HRWM7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 18:12:59 -0400
MIME-Version: 1.0
Date: Sun, 18 Aug 2013 15:12:58 -0700
X-Google-Sender-Auth: mS85iNxtW3b0oc_OmxEWp-1CboM
Message-ID: <CA+55aFzMBHGJOh8ATYgqa-kzterjbq+ty5TkR4yUFQYx+ZO2rw@mail.gmail.com>
Subject: Linux 3.11-rc6
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's been a fairly quiet week, and the rc's are definitely shrinking.
Which makes me happy.

Sure, we had an interesting rang handling bug in the TLB invalidation
code,  but that was an older bug and apparently really hard to hit in
practice. That said, it could explain a couple of random SIGSEGV's
etc, so if you've seen odd behavior maybe you've been hit by it, and
3.11-rc6 will fix it. Knock wood.

Other than that, it's more random changes: network drivers, usb,
sound, and a few filesystem fixes. With x86, ARM and a few small m68k
updates. But it's really been pretty quiet. The appended shortlog
gives the details for those who care.

.. and since the statistics on this rc were pretty boring, I started
looking at bigger numbers. We've now used git for over eight years,
and we have almost 400k commits in that time. That's interesting (to
me), because back in the BK days we were approaching the (back then)
limit of 65k commits in BK in the three years we used it. So we've
long since blown through that limit.

And those almost 400 thousand commits? They all fit in a 575MB
pack-file (plus a 85MB index file). Now, that's with more aggressive
packing than most people probably do, but I think it's interesting how
the last eight years of very active history ends up having almost
exactly the same size as the whole unpacked source tree. In fact, I
think that you need more free space for the object files of doing a
build than you need for remembering all that history.

I'll try to remember to do some more interesting/relevant statistics
for the rc7 release, because that should coincide with the 22nd
anniversary of the original Linux announcement on comp.os.minix.

How time flies when you're having fun..

                  Linus

---

Alan Stern (1):
      USB: EHCI: accept very late isochronous URBs

Alexey Brodkin (1):
      ethernet/arc/arc_emac - fix NAPI "work > weight" warning

Alexey Kardashevskiy (1):
      Revert "cxgb3: Check and handle the dma mapping errors"

Andi Kleen (1):
      perf/x86: Add Haswell ULT model number used in Macbook Air and
other systems

Andi Shyti (1):
      cifs: file: initialize oparms.reconnect before using it

Andreas Schwab (1):
      m68k: Truncate base in do_div()

Andrey Vagin (1):
      memcg: don't initialize kmem-cache destroying work for root caches

Ariel Elior (1):
      bnx2x: fix memory leak in VF

Asbjoern Sloth Toennesen (1):
      rtnetlink: rtnl_bridge_getlink: Call nlmsg_find_attr() with
ifinfomsg header

Barak Witkowsky (1):
      bnx2x: fix PTE write access error

Bartlomiej Zolnierkiewicz (1):
      stmmac: fix init_dma_desc_rings() to handle errors

Brian Austin (2):
      ASoC: cs42l52: Reorder Min/Max and update to SX_TLV for Beep Volume
      ASoC: cs42l52: Add new TLV for Beep Volume

Byungho An (1):
      net: stmmac: Fixed the condition of extend_desc for jumbo frame

Chen Gang (2):
      cifs: extend the buffer length enought for sprintf() using
      arch: *: Kconfig: add "kernel/Kconfig.freezer" to "arch/*/Kconfig"

Chris Wright (1):
      mac80211: fix infinite loop in ieee80211_determine_chantype

Clemens Ladisch (1):
      ALSA: usb-audio: fix automatic Roland/Yamaha MIDI detection

Cong Wang (2):
      vxlan: fix a regression of igmp join
      vxlan: fix a soft lockup in vxlan module removal

Cyrill Gorcunov (2):
      mm: save soft-dirty bits on swapped pages
      mm: save soft-dirty bits on file pages

Dan Carpenter (2):
      netfilter: nfnetlink_{log,queue}: fix information leaks in netlink message
      tun: signedness bug in tun_get_user()

Daniel Borkmann (4):
      net: esp{4,6}: fix potential MTU calculation overflows
      net: sctp: sctp_assoc_control_transport: fix MTU size in SCTP_PF state
      net: sctp: sctp_transport_destroy{, _rcu}: fix potential pointer
corruption
      net: tg3: fix NULL pointer dereference in tg3_io_error_detected
and tg3_io_slot_reset

Dave Jones (1):
      8139cp: Fix skb leak in rx_status_loop failure path.

Dmitry Kravkov (2):
      bnx2x: protect different statistics flows
      bnx2x: update fairness parameters following DCB negotiation

Ed L. Cashin (1):
      aoe: adjust ref of head for compound page tails

Eli Cohen (1):
      mlx5: remove health handler plugin

Eliezer Tamir (2):
      busy_poll: cleanup do-nothing placeholders
      net: rename busy poll MIB counter

Eric Dumazet (5):
      fib_trie: remove potential out of bound access
      tcp: cubic: fix overflow error in bictcp_update()
      tcp: cubic: fix bug in bictcp_acked()
      net: flow_dissector: add 802.1ad support
      macvtap: fix two races

Geert Uytterhoeven (1):
      m68k/atari: ARAnyM - Fix NatFeat module support

Guenter Roeck (1):
      s390: Fix broken build

Hannes Frederic Sowa (1):
      ipv6: don't stop backtracking in fib6_lookup_1 if subtree does not match

Himanshu Madhani (1):
      qlcnic: Fix set driver version command

Hyong-Youb Kim (1):
      myri10ge: Update MAINTAINERS

Jan Kara (2):
      jbd2: Fix use after free after error in jbd2_journal_dirty_metadata()
      jbd2: Fix oops in jbd2_journal_file_inode()

Jeff Layton (3):
      cifs: fix bad error handling in crypto code
      cifs: set sb->s_d_op before calling d_make_root()
      cifs: don't instantiate new dentries in readdir for inodes that
need to be revalidated immediately

Jeff Liu (1):
      ocfs2: fix null pointer dereference in ocfs2_dir_foreach_blk_id()

Jesper Dangaard Brouer (1):
      net_sched: restore "linklayer atm" handling

Jesse Gross (2):
      openvswitch: Fix bad merge resolution.
      openvswitch: Reset tunnel key between input and output.

Jie Liu (1):
      ocfs2: Revert 40bd62e to avoid regression in extended allocation

Johan Hovold (6):
      USB: mos7840: fix big-endian probe
      USB: usbtmc: fix big-endian probe of Rigol devices
      USB: adutux: fix big-endian device-type reporting
      USB: ti_usb_3410_5052: fix big-endian firmware handling
      USB: mos7720: fix broken control requests
      USB: keyspan: fix null-deref at disconnect and release

Johannes Berg (6):
      nl80211: fix another nl80211_fam.attrbuf race
      mac80211: don't wait for TX status forever
      mac80211: ignore HT primary channel while connected
      cfg80211: fix P2P GO interface teardown
      mac80211: continue using disabled channels while connected
      genetlink: fix family dump race

Julia Lawall (2):
      net/vmw_vsock/af_vsock.c: drop unneeded semicolon
      drivers/net/ethernet/via/via-velocity.c: update napi implementation

Lars-Peter Clausen (1):
      ASoC: dapm: Fix empty list check in dapm_new_mux()

Li Zefan (1):
      cpuset: fix the return value of cpuset_write_u64()

Linus Lüssing (2):
      bridge: don't try to update timers in case of broken MLD queries
      batman-adv: fix potential kernel paging errors for unicast transmissions

Linus Torvalds (2):
      Fix TLB gather virtual address range invalidation corner cases
      Linux 3.11-rc6

Lothar Waßmann (3):
      ASoC: sgtl5000: prevent playback to be muted when terminating
concurrent capture
      ASoC: sgtl5000: fix buggy 'Capture Attenuate Switch' control
      drivers/rtc/rtc-stmp3xxx.c: provide timeout for potentially
endless loop polling a HW bit

Maarten Lankhorst (1):
      mutex: Fix w/w mutex deadlock injection

Maksim A. Boyko (1):
      ALSA: usb-audio: Fix invalid volume resolution for Logitech HD Webcam C525

Manish Chopra (1):
      qlcnic: Fix diagnostic interrupt test for 83xx adapters

Matt Burtch (1):
      USB-Serial: Fix error handling of usb_wwan

Michael S. Tsirkin (1):
      macvlan: validate flags

Michal Hocko (1):
      hugetlb: fix lockdep splat caused by pmd sharing

Michal Simek (1):
      microblaze: fix clone syscall

Moshe Lazer (1):
      net/mlx5_core: Support MANAGE_PAGES and QUERY_PAGES firmware
command changes

Oleg Nesterov (1):
      sched: fix the theoretical signal_wake_up() vs schedule() race

Oliver Neukum (1):
      usb: add two quirky touchscreen

Pablo Neira Ayuso (2):
      netfilter: xt_TCPMSS: fix handling of malformed TCP header and options
      netfilter: xt_TCPOPTSTRIP: fix possible off by one access

Peter Zijlstra (1):
      sched: Ensure update_cfs_shares() is called for parents of
continuously-running tasks

Piotr Sarna (1):
      ext4: fix mount/remount error messages for incompatible mount options

Pravin B Shelar (2):
      ip_tunnel: Do not use inner ip-header-id for tunnel ip-header-id.
      openvswitch: Use correct type while allocating flex array.

Radu Caragea (1):
      x86 get_unmapped_area(): use proper mmap base for bottom-up direction

Robin Holt (1):
      MAINTAINERS: Change ownership for SGI specific modules.

Russell King (3):
      ARM: Fix the world famous typo with is_gate_vma()
      ARM: Fix !kuser helpers case
      ARM: Fix FIQ code on VIVT CPUs

Sarveshwar Bandi (1):
      be2net: Clear any capability flags that driver is not interested in.

Solomon Peachy (1):
      cw1200: Fix spurious BUG_ON() trigger when starting AP mode.

Soren Brinkmann (2):
      clk/zynq/clkc: Add dedicated spinlock for the SWDT
      clk/zynq/clkc: Add CLK_SET_RATE_PARENT flag to ethernet muxes

Sridhar Samudrala (1):
      rtnetlink: Fix inverted check in ndo_dflt_fdb_del()

Stanislaw Gruszka (2):
      iwl4965: set power mode early
      iwl4965: reset firmware after rfkill off

Stephane Grosjean (1):
      can: pcan_usb: fix wrong memcpy() bytes length

Stephen Boyd (3):
      ARM: 7810/1: perf: Fix array out of bounds access in armpmu_map_hw_event()
      PM / QoS: Fix workqueue deadlock when using
pm_qos_update_request_timeout()
      perf/arm: Fix armpmu_map_hw_event()

Stephen Hemminger (1):
      skge: fix build on 32 bit

Stephen Warren (2):
      ARM: 7807/1: kexec: validate CPU hotplug support
      ASoC: tegra: fix Tegra30 I2S capture parameter setup

Steve French (1):
      Do not attempt to do cifs operations reading symlinks with SMB2

Sucheta Chakraborty (1):
      qlcnic: Fix beacon state return status handling

Sylwester Nawrocki (1):
      clk: exynos4: Add CLK_GET_RATE_NOCACHE flag for the Exynos4x12 ISP clocks

Takashi Iwai (3):
      ALSA: hda - Add pinfix for LG LW25 laptop
      ALSA: hda - Fix missing mute controls for CX5051
      ALSA: hda - Add a fixup for Gateway LT27

Theodore Ts'o (2):
      ext4: allow the mount options nodelalloc and data=journal
      ext4: flush the extent status cache during EXT4_IOC_SWAP_BOOT

Thomas Pugliese (1):
      wusbcore: fix kernel panic when disconnecting a wireless
USB->serial device

Tiger Yang (1):
      ocfs2: fix NULL pointer dereference in ocfs2_duplicate_clusters_by_page

Timo Teräs (1):
      ip_gre: fix ipgre_header to return correct offset

Torsten Schenk (2):
      ALSA: 6fire: make buffers DMA-able (pcm)
      ALSA: 6fire: make buffers DMA-able (midi)

Veaceslav Falico (2):
      neighbour: populate neigh_parms on alloc before calling ndo_neigh_setup
      bonding: modify only neigh_parms owned by us

Vince Weaver (1):
      perf/x86: Fix intel QPI uncore event definitions

Wang Sheng-Hui (1):
      bridge: correct the comment for file br_sysfs_br.c

Weiping Pan (1):
      tun: compare with 0 instead of total_len

Will Deacon (3):
      ARM: 7809/1: perf: fix event validation for software group leaders
      ARM: 7811/1: locks: use early clobber in arch_spin_trylock
      ARM: 7812/1: rwlocks: retry trylock operation if strex fails on free lock

Yacine Belkadi (1):
      sched: Fix some kernel-doc warnings

Yuchung Cheng (1):
      netfilter: nf_conntrack: fix tcp_in_window for Fast Open

Yuval Mintz (1):
      bnx2x: prevent crash in shutdown flow with CNIC

dingtianhong (1):
      tipc: avoid possible deadlock while enable and disable bearer

nikolay@redhat.com (2):
      vlan: make vlan_dev_real_dev work over stacked vlans
      net_sched: make dev_trans_start return vlan's real dev trans_start

stephen hemminger (2):
      skge: add dma_mapping check
      skge: dma_sync the whole receive buffer

yonghua zheng (1):
      fs/proc/task_mmu.c: fix buffer overflow in add_page_map()
