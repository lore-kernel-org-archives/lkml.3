Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755210AbaADXfN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jan 2014 18:35:13 -0500
Received: from mail-ea0-f182.google.com ([209.85.215.182]:61051 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754939AbaADXfK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jan 2014 18:35:10 -0500
MIME-Version: 1.0
Date: Sat, 4 Jan 2014 15:35:08 -0800
X-Google-Sender-Auth: clrJMJIafxUq1jYdcXePd9gjd5E
Message-ID: <CA+55aFxZ_-HHK=fu5O83ViYSxkZwUKqnv8s1pv5ZosFX4e7kYw@mail.gmail.com>
Subject: Linux 3.13-rc7
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I normally do these things from the airport when I fly out, but since
I had re-installed on my laptop I chickened out and decided to do it
before leaving, just to make sure I had everything set up on the
laptop. Wouldn't you guess, the one time I decide to be prudent, it
all worked without a hitch..

Anyway, things have been nice and quiet, and if I wasn't travelling,
this would probably be the last -rc: there isn't really anything
holding up a release, even if there are a couple of patches still
going through discussions and percolating through maintainers. But
rather than do a real 3.13 next weekend, I'll be on the road and
decidedly *not* opening the merge window, so I'll do an rc8 next week
instead, needed or not.

And who knows, maybe something critical comes up now that people are
slowly emerging out of their food comas after the holidays, but at
least so far I get the feeling that 3.13 is doing fine.

In this rc, about half of the updates are networking (both drivers and
core), and the rest is a mix of other drivers (gpu, input, pci core,
some random of patch as well) and arch updates (s390 and powerpc, some
arm noise). And with some random stuff thrown in (cifs/gfs2, some mm
stuff from Andrew, etc).

But it's all pretty small.

Shortlog appended. Go forth and test,

                    Linus

---
Alex Deucher (2):
      drm/radeon: 0x9649 is SUMO2 not SUMO
      drm/radeon: Bump version for CIK DCE tiling fix

Andre Przywara (1):
      ARM/cpuidle: remove __init tag from Calxeda cpuidle probe function

Anton Blanchard (1):
      powerpc: Align p_end

Antonio Quartulli (4):
      batman-adv: fix size of batadv_icmp_header
      batman-adv: fix alignment for batadv_tvlv_tt_change
      batman-adv: clean nf state when removing protocol header
      batman-adv: fix vlan header access

Austin Boyle (1):
      max17042_battery: Fix build errors caused by missing REGMAP_I2C config

Betty Dall (1):
      atl1c: Check return from pci_find_ext_capability() in atl1c_reset_pcie()

Bob Peterson (2):
      GFS2: Fix use-after-free race when calling gfs2_remove_from_ail
      GFS2: Fix slab memory leak in gfs2_bufdata

Brian W Hart (2):
      powernv/eeh: Fix possible buffer overrun in ioda_eeh_phb_diag()
      powernv/eeh: Add buffer for P7IOC hub error data

Christian König (1):
      drm/radeon: fix UVD 256MB check

Cédric Le Goater (1):
      of/irq: Fix device_node refcount in of_irq_parse_raw()

Daniel Borkmann (2):
      net: inet_diag: zero out uninitialized idiag_{src,dst} fields
      netfilter: nft_exthdr: call ipv6_find_hdr() with explicitly
initialized offset

David Ertman (3):
      e1000e: fix compiler warnings
      e1000e: fix compiler warning (maybe-unitialized variable)
      e1000e: Fix a compile flag mis-match for suspend/resume

David Gibson (1):
      netxen: Correct off-by-one errors in bounds checks

David S. Miller (1):
      net: Add some clarification to skb_tx_timestamp() comment.

Dmitry Torokhov (1):
      Input: allocate absinfo data when setting ABS capability

Don Skidmore (1):
      ixgbe: fix for unused variable warning with certain config

Eric Dumazet (3):
      ipv6: sit: update mtu check to take care of gso packets
      net: fec: fix potential use after free
      arc_emac: fix potential use after free

Fabio Estevam (1):
      fec: Do not assume that PHY reset is active low

Florian Westphal (2):
      macvlan: fix netdev feature propagation from lower device
      net: rose: restore old recvmsg behavior

Gao feng (1):
      netfilter: nfnetlink_log: unset nf_loggers for netns when unloading module

Geert Uytterhoeven (1):
      of/Kconfig: Spelling s/one/once/

Gerhard Sittig (1):
      powerpc/512x: dts: remove misplaced IRQ spec from 'soc' node (5125)

Haiyang Zhang (1):
      hyperv: Fix race between probe and open calls

Hannes Frederic Sowa (2):
      ipv6: pmtudisc setting not respected with UFO/CORK
      ipv4: consistent reporting of pmtu data in case of corking

Heiko Carstens (1):
      s390/smp: improve setup of possible cpu mask

Heiko Stübner (1):
      Input: zforce - fix possible driver hang during suspend

Helmut Schaa (1):
      netfilter: nf_ct_timestamp: Fix BUG_ON after netns deletion

Jamal Hadi Salim (1):
      net_sched: act: Dont increment refcnt on replace

James Hogan (1):
      of: Fix NULL dereference in unflatten_and_copy()

Jan Kiszka (2):
      KVM: x86: Fix APIC map calculation after re-enabling
      KVM: nVMX: Unconditionally uninit the MMU on nested vmexit

Jason Baron (1):
      epoll: do not take the nested ep->mtx on EPOLL_CTL_DEL

Jesper Dangaard Brouer (2):
      netfilter: WARN about wrong usage of sequence number adjustments
      ipvs: correct usage/allocation of seqadj ext in ipvs

Jiang Liu (1):
      drivers/dma/ioat/dma.c: check DMA mapping error in ioat_dma_self_test()

Johannes Berg (1):
      radiotap: fix bitmap-end-finding buffer overrun

John Fastabend (1):
      net: allow netdev_all_upper_get_next_dev_rcu with rtnl lock held

Krzysztof Hałasa (1):
      crypto: ixp4xx - Fix kernel compile error

Kumar Sanghvi (8):
      cxgb4: Reserve stid 0 for T4/T5 adapters
      cxgb4: Include TCP as protocol when creating server filters
      cxgb4: Assign filter server TIDs properly
      cxgb4: Account for stid entries properly in case of IPv6
      cxgb4: Add API to correctly calculate tuple fields
      RDMA/cxgb4: Calculate the filter server TID properly
      RDMA/cxgb4: Server filters are supported only for IPv4
      RDMA/cxgb4: Use cxgb4_select_ntuple to correctly calculate ntuple fields

Larry Finger (1):
      rtlwifi: pci: Fix oops on driver unload

Leigh Brown (1):
      net: mvmdio: fix interrupt timeout handling

Li RongQing (2):
      ipv6: always set the new created dst's from in ip6_rt_copy
      ipv6: release dst properly in ipip6_tunnel_xmit

Linus Torvalds (1):
      Linux 3.13-rc7

Marcel Holtmann (1):
      Bluetooth: Fix HCI User Channel permission check in hci_sock_sendmsg

Marco Piazza (1):
      Bluetooth: Add support for Toshiba Bluetooth device [0930:0220]

Marek Olšák (4):
      drm/radeon: fix render backend setup for SI and CIK
      drm/radeon: expose render backend mask to the userspace
      drm/radeon: set correct pipe config for Hawaii in DCE
      drm/radeon: set correct number of banks for CIK chips in DCE

Martin Schwidefsky (1):
      s390/3270: fix allocation of tty3270_screen structure

Mathy Vanhoef (1):
      ath9k_htc: properly set MAC address and BSSID mask

Matteo Facchinetti (1):
      powerpc/512x: dts: disable MPC5125 usb module

Mel Gorman (1):
      mm: remove bogus warning in copy_huge_pmd()

Michael Neuling (1):
      powerpc: Fix bad stack check in exception entry

Michal Schmidt (1):
      bnx2x: downgrade "valid ME register value" message level

Michal Simek (1):
      MAINTAINERS: set up proper record for Xilinx Zynq

Mugunthan V N (2):
      drivers: net cpsw: Enable In Band mode in cpsw for 10 mbps
      drivers: net : cpsw: pass proper device name while requesting irq

Naoya Horiguchi (1):
      mm/memory-failure.c: transfer page count from head page to tail
page after split thp

Nithin Sujir (1):
      tg3: Expand 4g_overflow_test workaround to skb fragments of any size.

Nobuhiro Iwamatsu (1):
      sh: add EXPORT_SYMBOL(min_low_pfn) and
EXPORT_SYMBOL(max_low_pfn) to sh_ksyms_32.c

Olof Johansson (1):
      powerpc: Fix alignment of secondary cpu spin vars

Pablo Neira Ayuso (3):
      netfilter: nf_tables: fix dumping with large number of sets
      netfilter: nf_tables: fix oops when updating table with user chains
      netfilter: nf_tables: fix wrong datatype in nft_validate_data_load()

Paul Durrant (1):
      xen-netback: fix guest-receive-side array sizes

Paul E. McKenney (1):
      powerpc: Make 64-bit non-VMX __copy_tofrom_user bi-endian

Peter Korsgaard (4):
      dm9601: add support for dm9621a based dongle
      dm9601: fix reception of full size ethernet frames on dm9620/dm9621a
      dm9601: make it clear that dm9620/dm9621a are also supported
      dm9601: work around tx fifo sync issue on dm962x

Rafael J. Wysocki (4):
      cpufreq: Clean up after a failing light-weight initialization
      PCI / ACPI: Install wakeup notify handlers for all PCI devs with ACPI
      intel_pstate: Fail initialization if P-state information is missing
      ACPIPHP / radeon / nouveau: Fix VGA switcheroo problem related to hotplug

Rafał Miłecki (1):
      Input: define KEY_WWAN for Wireless WAN

Rajesh B Prathipati (1):
      powerpc: Make unaligned accesses endian-safe for powerpc

Rik van Riel (1):
      mm: fix use-after-free in sys_remap_file_pages

Rob Herring (2):
      Revert "of/address: Handle #address-cells > 2 specially"
      MAINTAINERS: Update Rob Herring's email address

Sachin Prabhu (1):
      cifs: We do not drop reference to tlink in CIFSCheckMFSymlink()

Salva Peiró (1):
      hamradio/yam: fix info leak in ioctl

Sasha Levin (1):
      rds: prevent dereference of a NULL device

Sebastian Ott (1):
      s390/pci: obtain function handle in hotplug notifier

Sergei Shtylyov (1):
      phy: IRQ cannot be shared

Shirish Pargaonkar (1):
      cifs: set FILE_CREATED

Shuah Khan (1):
      power_supply: Fix Oops from NULL pointer dereference from
wakeup_source_activate

Simon Wunderlich (3):
      batman-adv: fix alignment for batadv_coded_packet
      batman-adv: fix header alignment by unrolling batadv_header
      batman-adv: fix size of batadv_bla_claim_dst

Steve French (1):
      Add missing end of line termination to some cifs messages

Steven Whitehouse (3):
      GFS2: don't hold s_umount over blkdev_put
      GFS2: Fix incorrect invalidation for DIO/buffered I/O
      GFS2: Wait for async DIO in glock state changes

Sujith Manoharan (1):
      ath9k: Fix interrupt handling for the AR9002 family

Tetsuo Handa (1):
      GFS2: Fix unsafe dereference in dump_holder()

Timo Teräs (1):
      ip_gre: fix msg_name parsing for recvfrom/recvmsg

Toshi Kani (1):
      ACPI / PCI / hotplug: Avoid warning when _ADR not present

Ujjal Roy (1):
      cfg80211: fix WARN_ON for re-association to the expired BSS

Vince Bridgers (1):
      stmmac: Fix incorrect spinlock release and PTP cap detection.

Viresh Kumar (1):
      cpufreq: preserve user_policy across suspend/resume

Vladimir Davydov (1):
      memcg: fix memcg_size() calculation

Vlastimil Babka (2):
      mm: munlock: fix a bug where THP tail page is encountered
      mm: munlock: fix deadlock in __munlock_pagevec()

Wang Weidong (1):
      dccp: catch failed request_module call in dccp_probe init

Wei Yongjun (1):
      xen-netback: fix some error return code

Wenliang Fan (1):
      drivers/net/hamradio: Integer overflow in hdlcdrv_ioctl()

Ying Xue (1):
      tipc: fix deadlock during socket release

dingtianhong (3):
      bonding: protect port for bond_3ad_adapter_speed_changed()
      bonding: protect port for bond_3ad_adapter_duplex_changed()
      bonding: protect port for bond_3ad_handle_link_change()
