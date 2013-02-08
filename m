Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947241Ab3BHVvk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 16:51:40 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:41998 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753754Ab3BHVvj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 16:51:39 -0500
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 9 Feb 2013 08:51:15 +1100
X-Google-Sender-Auth: XKnzw1vsaeBVtXjZn6cXpgBeWr8
Message-ID: <CA+55aFz50VvnMjoDCbg01N+rMu5vscu88kr0SV3tWLjaiL0TeA@mail.gmail.com>
Subject: Linux v3.8-rc7
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Another rc from Australia, just before heading back home. It still
hasn't been as quiet as I'd have preferred (and with the absolutely
horrendous internet access the last week, any pull at all was pretty
painful - git is good about network bandwidth use, but it still wants
a network that stays up and doesn't lose packets left and right).

Anyway, here it is. Mostly driver updates (usb, networking, radeon,
regulator, sound) with a random smattering of other stuff (btrfs,
networking, so on. And most everything is pretty small.

                 Linus

---
Alan Stern (9):
      USB: XHCI: fix memory leak of URB-private data
      USB: EHCI: remove ASS/PSS polling timeout
      USB: EHCI: unlink one async QH at a time
      USB: add usb_hcd_{start,end}_port_resume
      USB: EHCI: notify usbcore about port resumes
      USB: UHCI: notify usbcore about port resumes
      USB: EHCI: fix timer bug affecting port resume
      USB: EHCI: fix for leaking isochronous data
      USB: EHCI: fix bug in scheduling periodic split transfers

Alex Deucher (7):
      drm/radeon: add WAIT_UNTIL to the non-VM safe regs list for cayman/TN
      drm/radeon: add quirk for RV100 board
      drm/radeon: fix backend map setup on 1 RB sumo boards
      drm/radeon/evergreen+: wait for the MC to settle after MC blackout
      drm/radeon/r5xx-r7xx: wait for the MC to settle after MC blackout
      drm/radeon: prevent crash in the ring space allocation
      drm/radeon: switch back to the CP ring for VM PT updates

Alexander Stein (1):
      can: c_can: Set reserved bit in IFx_MASK2 to 1 on write

Alim Akhtar (1):
      regulator: s2mps11: fix incorrect register for buck10

Andre Guedes (1):
      Bluetooth: Fix hci_conn timeout routine

Andrew Morton (1):
      arch/x86/tools/insn_sanity.c: Identify source of messages

Aneesh Kumar K.V (1):
      powerpc/mm: Fix hash computation function

Arend van Spriel (2):
      brcmsmac: fix tx status processing
      brcmsmac: rework of mac80211 .flush() callback operation

Arnd Bergmann (3):
      sched: Fix warning in kernel/sched/fair.c
      sched/debug: Fix format string for 32-bit platforms
      samples/seccomp: be less stupid about cross compiling

Asai Thambi S P (2):
      mtip32xx: fix for driver hang after a command timeout
      mtip32xx: fix for crash when the device surprise removed during rebuild

Axel Lin (5):
      regulator: tps65217: Fix using wrong dev argument for calling
of_regulator_match
      regulator: tps65910: Fix using wrong dev argument for calling
of_regulator_match
      regulator: max8907: Fix using wrong dev argument for calling
of_regulator_match
      regulator: max77686: Fix using wrong dev argument at various places
      regulator: max8997: Fix using wrong dev argument at various places

Barry Song (1):
      pinctrl: sirf: replace of_gpio_simple_xlate by sirf specific of_xlate

Baruch Siach (1):
      mtd: physmap_of: fix cmdline partition method w/o linux, mtd-name

Bing Zhao (1):
      mwifiex: fix incomplete scan in case of IE parsing error

Bjørn Mork (5):
      net: usbnet: prevent buggy devices from killing us
      USB: option: add Changhong CH690
      net: usbnet: fix tx_dropped statistics
      net: cdc_ncm: add another Huawei vendor specific device
      net: qmi_wwan: add more Huawei devices, including E320

Borislav Petkov (1):
      x86/intel/cacheinfo: Shut up annoying warning

Bruce Allan (1):
      e1000e: enable ECC on I217/I218 to catch packet buffer memory errors

Chris Mason (1):
      Btrfs: move d_instantiate outside the transaction during mksubvol

Christopher Staite (1):
      drm/radeon: fix MC blackout on evergreen+

Cong Wang (1):
      pktgen: correctly handle failures when adding a device

Dan Carpenter (1):
      cfg80211: off by one in ieee80211_bss()

Daniel Borkmann (3):
      net: sctp: sctp_auth_key_put: use kzfree instead of kfree
      net: sctp: sctp_setsockopt_auth_key: use kzfree instead of kfree
      net: sctp: sctp_endpoint_free: zero out secret key data

Daniel Vetter (1):
      drm/ttm: fix fence locking in ttm_buffer_object_transfer, 2nd try

Daniele Palmas (3):
      USB: qcserial: add Telit Gobi QDL device
      USB: option: add support for Telit LE920
      NET: qmi_wwan: add Telit LE920 support

David Moore (1):
      usb: Prevent dead ports when xhci is not enabled

David S. Miller (1):
      via-rhine: Fix bugs in NAPI support.

David Teigland (1):
      dlm: check the write size from user

Derek Basehore (2):
      block: remove deadlock in disk_clear_events
      block: prevent race/cleanup

Emmanuel Grumbach (1):
      Revert "iwlwifi: fix the reclaimed packet tracking upon flush queue"

Eric Dumazet (3):
      tcp: fix an infinite loop in tcp_slow_start()
      tcp: frto should not set snd_cwnd to 0
      l2tp: dont play with skb->truesize

Eric Sandeen (1):
      btrfs: don't try to notify udev about missing devices

Geert Uytterhoeven (9):
      avr32: Provide dma_mmap_coherent() and dma_get_sgtable()
      blackfin: Provide dma_mmap_coherent() and dma_get_sgtable()
      c6x: Provide dummy dma_mmap_coherent() and dma_get_sgtable()
      cris: Provide dma_mmap_coherent() and dma_get_sgtable()
      frv: Provide dummy dma_mmap_coherent() and dma_get_sgtable()
      m68k: Provide dma_mmap_coherent() and dma_get_sgtable()
      mn10300: Provide dummy dma_mmap_coherent() and dma_get_sgtable()
      parisc: Provide dummy dma_mmap_coherent() and dma_get_sgtable()
      xtensa: Provide dummy dma_mmap_coherent() and dma_get_sgtable()

Glauber Costa (1):
      memcg: fix typo in kmemcg cache walk macro

H. Peter Anvin (1):
      x86, doc: Boot protocol 2.12 is in 3.8

Hans Verkuil (1):
      [media] radio: set vfl_dir correctly to fix modulator regression

Haojian Zhuang (1):
      drivers/rtc/rtc-pl031.c: fix the missing operation on enable

Hauke Mehrtens (2):
      bcma: unregister gpios before unloading bcma
      ssb: unregister gpios before unloading ssb

Heiko Carstens (1):
      atm/iphase: rename fregt_t -> ffreg_t

Ian Campbell (3):
      xen/netback: shutdown the ring if it contains garbage.
      xen/netback: free already allocated memory on failure in
xen_netbk_get_requests
      netback: correct netbk_tx_err to handle wrap around.

Ilpo Järvinen (1):
      tcp: fix for zero packets_in_flight was too broad

Jan Beulich (2):
      x86-64: Replace left over sti/cli in ia32 audit exit code
      xen-pciback: rate limit error messages from xen_pcibk_enable_msi{,x}()

Jan Luebbe (1):
      drivers/rtc/rtc-isl1208.c: call rtc_update_irq() from the alarm
irq handler

Jan Schmidt (1):
      Btrfs: fix EDQUOT handling in btrfs_delalloc_reserve_metadata

Jason Wang (3):
      vhost_net: correct error handling in vhost_net_set_backend()
      vhost_net: handle polling errors when setting backend
      tuntap: allow polling/writing/reading when detached

Jesse Gross (1):
      openvswitch: Move LRO check from transmit to receive.

Jiri Olsa (1):
      perf: Fix event group context move

Joe Perches (1):
      checkpatch: fix $Float creation of match variables

Johan Hedberg (1):
      Bluetooth: Fix handling of unexpected SMP PDUs

Johannes Naab (1):
      netem: fix delay calculation in rate extension

Joonsoo Kim (1):
      tools/vm: add .gitignore to ignore built binaries

Josef Bacik (3):
      Btrfs: do not merge logged extents if we've removed them from the tree
      Btrfs: fix missing i_size update
      Btrfs: fix possible stale data exposure

Kirill A. Shutemov (1):
      thp: avoid dumping huge zero page

Kukjin Kim (1):
      pinctrl: exynos: change PINCTRL_EXYNOS option

Lan Tianyu (1):
      usb: Using correct way to clear usb3.0 device's remote wakeup feature.

Larry Finger (2):
      rtlwifi: Fix the usage of the wrong variable in usb.c
      rtlwifi: Fix scheduling while atomic bug

Lars Ellenberg (1):
      drbd: fix potential protocol error and resulting disconnect/reconnect

Linus Torvalds (1):
      Linux 3.8-rc7

Liu Bo (1):
      Btrfs: fix race between snapshot deletion and getting inode

Lucas Stach (1):
      net: usb: fix regression from FLAG_NOARP code

Luis Llorente Campo (1):
      USB: add OWL CM-160 support to cp210x driver

Marcelo Ricardo Leitner (1):
      ipv6: do not create neighbor entries for local delivery

Marek Szyprowski (1):
      regulator: max8998: fix incorrect min_uV value for ldo10

Matthew Daley (1):
      xen/netback: don't leak pages on failure in xen_netbk_tx_check_gop.

Matthias Brugger (1):
      MAINTAINERS: update avr32 web ressources

Matthieu CASTET (1):
      mtd: nand: onfi don't WARN if we are in 16 bits mode

Miao Xie (2):
      Btrfs: fix wrong sync_writers decrement in btrfs_file_aio_write()
      Btrfs: fix missing release of the space/qgroup reservation in
start_transaction()

Michael S. Tsirkin (2):
      tun: fix carrier on/off status
      tcm_vhost: fix pr_err on early kick

Mike Marciniszyn (1):
      IB/qib: Fix for broken sparse warning fix

Mikko Tiihonen (1):
      drm/radeon: protect against div by 0 in backend setup

Milos Vyletel (1):
      bonding: unset primary slave via sysfs

Neil Horman (1):
      vmxnet3: set carrier state properly on probe

Nicholas Bellinger (5):
      target: Fix zero-length INQUIRY additional sense code regression
      target: Fix zero-length MODE_SENSE regression
      target: Fix zero-length READ_CAPACITY_16 regression
      target: Fix regression allowing unconfigured devices to fabric port link
      target: Fix divide by zero bug in fabric_max_sectors for
unconfigured devices

Nickolai Zeldovich (1):
      drivers: xhci: fix incorrect bit test

Nivedita Singhvi (1):
      tcp: Increment LISTENOVERFLOW and LISTENDROPS in tcp_v4_conn_request()

Or Gerlitz (1):
      mlx4_core: Fix advertisement of wrong PF context behaviour

Paul Gortmaker (2):
      rcu: Prevent soft-lockup complaints about no-CBs CPUs
      rcu: Make rcu_nocb_poll an early_param instead of module_param

Petr Kubánek (1):
      USB: ftdi_sio: add Zolix FTDI PID

Phil Sutter (1):
      packet: fix leakage of tx_ring memory

Pravin B Shelar (1):
      net: Fix inner_network_header assignment in skb-copy.

Rafał Miłecki (2):
      mtd: bcm47xxnflash: increase NFLASH_READY_RETRIES
      bcma: fix NAND flash validation

Robert Jarzmik (1):
      mtd: docg3 fix missing bitreverse lib

Roger Pau Monne (3):
      xen-blkback: implement safe iterator for the list of persistent grants
      llist/xen-blkfront: implement safe version of llist_for_each_entry
      xen-blkfront: handle bvecs with partial data

Russell King (3):
      ARM: GIC: fix GIC cpumask initialization
      ARM: realview: ensure that we have sufficient IRQs available
      ARM: DMA mapping: fix bad atomic test

Sarah Sharp (2):
      xhci: Fix isoc TD encoding.
      xhci: Fix TD size for isochronous URBs.

Sarveshwar Bandi (1):
      be2net: Updating Module Author string and log message string to
"Emulex Corporation"

Sergei Shtylyov (1):
      mtd: davinci_nand: fix modular build with CONFIG_OF=y

Shawn Bohrer (1):
      sched/rt: Use root_domain of rt_rq not current processor

Shawn Guo (2):
      Revert "ASoC: fsl: fix multiple definition of init_module"
      ASoC: fsl: fix snd-soc-imx-pcm module build

Shlomo Pongratz (1):
      IPoIB: Fix crash due to skb double destruct

ShuoX Liu (1):
      perf/x86: Enable Intel Lincroft/Penwell/Cloverview Atom support

Sjur Brændeland (1):
      virtio_console: Don't access uninitialized data.

Stephen Warren (1):
      regulator: clear state each invocation of of_regulator_match

Sven Killig (1):
      USB: ftdi_sio: add PID/VID entries for ELV WS 300 PC II

Tom Parkin (4):
      l2tp: prevent l2tp_tunnel_delete racing with userspace close
      ipv6: rename datagram_send_ctl and datagram_recv_ctl
      ipv6: export ip6_datagram_recv_ctl
      l2tp: correctly handle ancillary data in the ip6 recv path

Tommi Rantala (1):
      ipv6/ip6_gre: fix error case handling in ip6gre_tunnel_xmit()

Tony Lu (1):
      mm/hugetlb: set PTE as huge in hugetlb_change_protection and
remove_migration_pte

Tony Prisk (1):
      drivers/rtc/rtc-vt8500.c: fix year field in vt8500_rtc_set_time()

Vijay Subramanian (2):
      tcp: Update MIB counters for drops
      tcp: ipv6: Update MIB counters for drops

Vyacheslav Dubeyko (1):
      nilfs2: fix fix very long mount time issue

Wei Liu (1):
      xen: fix error handling path if xen_allocate_irq_dynamic fails

Will Deacon (1):
      ARM: 7641/1: memory: fix broken mmap by ensuring
TASK_UNMAPPED_BASE is aligned

YOSHIFUJI Hideaki (1):
      digsig: Fix memory leakage in digsig_verify_rsa()

YOSHIFUJI Hideaki / 吉藤英明 (1):
      ipv6 addrconf: Fix interface identifiers of 802.15.4 devices.

Youquan Song (1):
      x86/perf: Add IvyBridge EP support

Yuanhan Liu (1):
      mm: fix wrong comments about anon_vma lock

Yuchung Cheng (1):
      tcp: detect SYN/data drop when F-RTO is disabled

fangxiaozhi (2):
      USB: storage: Define a new macro for USB storage match rules
      USB: storage: optimize to match the Huawei USB storage devices
and support new switch command

liu chuansheng (1):
      drm/radeon: Calling object_unrefer() when creating fb failure

yangyongqiang (1):
      perf/x86: Fix P6 driver section warning
