Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932267AbaCQCRC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 22:17:02 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:61950 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755791AbaCQCQ6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 22:16:58 -0400
MIME-Version: 1.0
Date: Sun, 16 Mar 2014 19:16:57 -0700
X-Google-Sender-Auth: ML1HO742GvdQDmxHS97wLImodrE
Message-ID: <CA+55aFx_Lf7FergrxN1s+CMMgL3LPQorQD=++HksSHE28129tg@mail.gmail.com>
Subject: Linux 3.14-rc7
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What a difference a week makes. In a good way. A week ago, cutting
rc6, I was not a happy person: the release had much too much noise in
it, and I felt that an rc8 and even an rc9 might well be a real
possibility.

Now it's a week later, and rc7 looks much better. Yeah, there's random
stuff all over (biggest contribution: networking, both core and
drivers), but it's a lot smaller than rc6, and none of it makes me
feel unhappy. Pretty much all the patches are tiny, and I think the
patch that removes the old useless x86 Centaur OOSTORE option is
probably the biggest in the lot of them. And the only other patch that
migth challenge it in size is also just removing code ("r8152: disable
the ECM mode").

Now, things might change, and maybe next week ends up being another
ugly week, but with some luck that won't happen and this is the last
rc.

Go out and test. It all looks good..

                       Linus

---

Aaro Koskinen (1):
      ASoC: n810: fix init with DT boot

Al Viro (3):
      ocfs2 syncs the wrong range...
      sockfd_lookup_light(): switch to fdget^W^Waway from fget_light
      get rid of fget_light()

Ales Novak (1):
      [SCSI] storvsc: NULL pointer dereference fix

Alex Deucher (4):
      drm/radeon: fix runpm disabling on non-PX harder
      drm/radeon/cik: properly set sdma ring status on disable
      drm/radeon/cik: stop the sdma engines in the enable() function
      drm/radeon/cik: properly set compute ring status on disable

Alexander Aring (1):
      at86rf230: fix lockdep splats

Alexei Starovoitov (1):
      x86: bpf_jit: support negative offsets

Amir Vadai (2):
      net/mlx4_core: Fix memory access error in mlx4_QUERY_DEV_CAP_wrapper()
      net/mlx4_core: mlx4_init_slave() shouldn't access comm channel
before PF is ready

Amitkumar Karwar (2):
      mwifiex: copy AP's HT capability info correctly
      mwifiex: save and copy AP's VHT capability info correctly

Andrew Lutomirski (1):
      net: Improve SO_TIMESTAMPING documentation and fix a minor code bug

Andrew Morton (1):
      revert "kallsyms: fix absolute addresses for kASLR"

Annie Li (1):
      Xen-netback: Fix issue caused by using gso_type wrongly

Anton Blanchard (2):
      net: unix socket code abuses csum_partial
      ibmveth: Fix endian issues with MAC addresses

Anton Nayshtut (1):
      ipv6: Fix exthdrs offload registration.

Arnd Bergmann (1):
      vmxnet3: fix building without CONFIG_PCI_MSI

Artem Fetishev (1):
      fs/proc/base.c: fix GPF in /proc/$PID/map_files

Ben Hutchings (3):
      perf trace: Decode architecture-specific signal numbers
      bna: Replace large udelay() with mdelay()
      mm/Kconfig: fix URL for zsmalloc benchmark

Bjorn Helgaas (3):
      phy: fix compiler array bounds warning on settings[]
      PCI: Enable INTx in pci_reenable_device() only when MSI/MSI-X not enabled
      PCI: Don't check resource_size() in pci_bus_alloc_resource()

Chad Dupuis (1):
      [SCSI] qla2xxx: Fix multiqueue MSI-X registration.

Colin Ian King (1):
      tools/testing/selftests/ipc/msgque.c: handle msgget failure
return correctly

Dan Williams (1):
      [SCSI] isci: fix reset timeout handling

Daniel Borkmann (2):
      net: sctp: fix skb leakage in COOKIE ECHO path of chunk->auth_chunk
      MAINTAINERS: add networking selftests to NETWORKING

Daniel J Blueman (1):
      x86/amd/numa: Fix northbridge quirk to assign correct NUMA node

Dave Jones (2):
      perf/x86: Fix leak in uncore_type_init failure paths
      x86: Remove CONFIG_X86_OOSTORE

Don Zickus (1):
      perf machine: Use map as success in ip__resolve_ams

Eliad Peller (1):
      mac80211: consider virtual mon when calculating min_def

Emmanuel Grumbach (1):
      iwlwifi: mvm: don't WARN when statistics are handled late

Eric Dumazet (3):
      pkt_sched: move the sanity test in qdisc_list_add()
      pkt_sched: fq: do not hold qdisc lock while allocating memory
      tcp: tcp_release_cb() should release socket ownership

Eric W. Biederman (3):
      audit: Use struct net not pid_t to remember the network namespce
to reply in
      audit: Send replies in the proper network namespace.
      audit: Update kdoc for audit_send_reply and audit_list_rules_send

Erik Hugne (3):
      tipc: drop subscriber connection id invalidation
      tipc: fix memory leak during module removal
      tipc: don't log disabled tasklet handler errors

Fernando Luis Vazquez Cao (1):
      sched/clock: Prevent tracing recursion in sched_clock_cpu()

Florian Westphal (1):
      inet: frag: make sure forced eviction removes all frags

Gavin Shan (1):
      net/mlx4: Support shutdown() interface

Geert Uytterhoeven (2):
      cris: convert ffs from an object-like macro to a function-like macro
      packet: doc: Spelling s/than/that/

Giridhar Malavali (1):
      [SCSI] qla2xxx: Poll during initialization for ISP25xx and ISP83xx

Giuseppe CAVALLARO (4):
      stmmac: disable at run-time the EEE if not supported
      stmmac: fix and better tune the default buffer sizes
      stmmac: fix chained mode
      stmmac: dwmac-sti: fix broken STiD127 compatibility

Guillaume Nault (2):
      l2tp: fix manual sequencing (de)activation in L2TPv2
      l2tp: fix userspace reception on plain L2TP sockets

Haiyang Zhang (1):
      hyperv: Move state setting for link query

Heiner Kallweit (1):
      ipv6: Avoid unnecessary temporary addresses being generated

Heinz Mauelshagen (2):
      dm cache: fix truncation bug when copying a block to/from >2TB fast device
      dm cache: fix access beyond end of origin device

Ivaylo Dimitrov (1):
      wl1251: use skb_trim to make skb shorter

Jeff Layton (2):
      cifs: sanity check length of data to send before sending
      cifs: mask off top byte in get_rfc1002_length()

Jiri Olsa (1):
      perf symbols: Fix crash in elf_section_by_name

Johannes Berg (2):
      cfg80211: remove racy beacon_interval assignment
      mac80211: clear sequence/fragment number in QoS-null frames

Johannes Weiner (1):
      mm: fix GFP_THISNODE callers and clarify

Juri Lelli (1):
      sched/deadline: Deny unprivileged users to set/change
SCHED_DEADLINE policy

Lars-Peter Clausen (2):
      ASoC: si476x: Fix IO setup
      ASoC: 88pm860: Fix IO setup

Laura Abbott (1):
      mm/compaction: break out of loop on !PageBuddy in isolate_freepages_block

Linus Lüssing (3):
      bridge: multicast: add sanity check for query source addresses
      bridge: multicast: add sanity check for general query destination
      bridge: multicast: enable snooping on general queries only

Linus Torvalds (2):
      vfs: atomic f_pos accesses as per POSIX
      Linux 3.14-rc7

Lukasz Dorau (1):
      [SCSI] isci: correct erroneous for_each_isci_host macro

Marc Zyngier (1):
      ARM: KVM: fix non-VGIC compilation

Markos Chandras (1):
      tools/net/Makefile: Define PACKAGE to fix build problems

Matthew Leach (1):
      net: socket: error on a negative msg_namelen

Michael Chan (1):
      bnx2: Fix shutdown sequence

Michael Kerrisk (1):
      ipc: Fix 2 bugs in msgrcv() MSG_COPY implementation

Michael Opdenacker (1):
      MAINTAINERS: blackfin: add git repository

Michael S. Tsirkin (5):
      skbuff: skb_segment: s/frag/nskb_frag/
      skbuff: skb_segment: s/skb_frag/frag/
      skbuff: skb_segment: s/skb/head_skb/
      skbuff: skb_segment: s/fskb/list_skb/
      skbuff: skb_segment: orphan frags before copying

Mike Christie (1):
      [SCSI] be2iscsi: fix bad if expression

Neil Horman (1):
      vmxnet3: fix netpoll race condition

Nikolay Aleksandrov (1):
      net: fix for a race condition in the inet frag code

Or Gerlitz (4):
      net/mlx4_core: Fix wrong dump of the vxlan offloads device capability
      net/mlx4_en: Handle vxlan steering rules for mac address changes
      net/mlx4_core: Load the IB driver when the device supports IBoE
      net/mlx4_en: Deregister multicast vxlan steering rules when going down

Oren Givon (1):
      iwlwifi: fix and add 7265 series HW IDs

Patrick Lai (1):
      ASoC: pcm: free path list before exiting from error conditions

Pavel Shilovsky (1):
      CIFS: Fix wrong pos argument of cifs_find_lock_conflict

Peter Boström (1):
      vlan: Set correct source MAC address with TX VLAN offload enabled

Peter Zijlstra (1):
      stop_machine: Fix^2 race between stop_two_cpus() and stop_cpus()

Radim Krčmář (1):
      KVM: SVM: fix cr8 intercept window

Rafael J. Wysocki (3):
      cpufreq: Skip current frequency initialization for ->setpolicy drivers
      ACPI / init: Invoke early ACPI initialization later
      ACPI / sleep: Add extra checks for HW Reduced ACPI mode sleep states

Richard Weinberger (1):
      i2c: Remove usage of orphaned symbol OF_I2C

Rob Clark (1):
      drm/ttm: don't oops if no invalidate_caches()

Sabrina Dubroca (1):
      ipv6: don't set DST_NOCOUNT for remotely added routes

Sasha Levin (1):
      bonding: correctly handle out of range parameters for lp_interval

Sergei Antonov (1):
      hfsplus: add HFSX subfolder count support

Soren Brinkmann (2):
      net: macb: Check DMA mappings for error
      net: macb: DMA-unmap full rx-buffer

Stefan Wahren (1):
      eth: fec: Fix lost promiscuous mode after reconnecting cable

Suresh Siddha (1):
      x86, fpu: Check tsk_used_math() in kernel_fpu_end() for eager FPU

Takashi Iwai (1):
      ALSA: hda - Fix loud click noise with IdeaPad 410Y

Tejun Heo (1):
      libata: use wider match for blacklisting Crucial M500

Thomas Hellstrom (2):
      drm/ttm: Work around performance regression with VM_PFNMAP
      drm/vmwgfx: Fix a surface reference corner-case in legacy emulation mode

Tobias Klauser (1):
      MAINTAINERS: Add tools/net to NETWORKING [GENERAL]

Wei Liu (1):
      xen-netback: use skb_is_gso in xenvif_start_xmit

Ying Xue (3):
      tipc: allow connection shutdown callback to be invoked in advance
      tipc: fix connection refcount leak
      tipc: avoid to unnecessary process switch under non-block mode

Zhang Rui (1):
      PNP / ACPI: proper handling of ACPI IO/Memory resource parsing failures

dingtianhong (1):
      bonding: set correct vlan id for alb xmit path

hayeswang (2):
      r8152: disable the ECM mode
      r8169: fix the incorrect tx descriptor version
