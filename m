Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758948Ab3IBVK5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 17:10:57 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:57954 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752731Ab3IBVKz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 17:10:55 -0400
MIME-Version: 1.0
Date: Mon, 2 Sep 2013 14:10:54 -0700
X-Google-Sender-Auth: lzurldCMw4pJwyjny7ZPFqMAHrc
Message-ID: <CA+55aFyqCJakY1+RwKXTPiGJsUcXM1W2B5gyryuq65_RKkGs0w@mail.gmail.com>
Subject: Linux 3.11
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As some people noticed, I got distracted ("Ooh, look, a squirrel..")
and never wrote an announcement for -rc7. My bad. But it wasn't
actually all that interesting a release apart from the date, and it
had a silly compile error in ohci-pci if you hadn't enabled
CONFIG_PM_RUNTIME, so we'll just forget -rc7 ever happened, ok?
Instead, go and get the real 3.11 release, which is out there, all
shiny and ready to be compiled and loved.

Since rc7 (ok, I lied, it happened) there's been just small fixes.
Most of them came in from the networking tree, but there's some all
over: some random filesystem fixes, a couple of sound fixes, a
/proc/timer_list fix, things like that. Nothing really stands out
(unless you happened to use the new soft-dirty code, that had a buglet
that could really hurt), but let's hope we don't have some silly
configuration that doesn't even compile this time around.

Shortlog appended.

             Linus

---

Alan Stern (1):
      USB: OHCI: fix build error related to ohci_suspend/resume

Andrew Vagin (2):
      tcp: initialize rcv_tstamp for restored sockets
      tcp: don't apply tsoffset if rcv_tsecr is zero

Andrey Vagin (1):
      memcg: check that kmem_cache has memcg_params before accessing it

Andy Lutomirski (2):
      net: Check the correct namespace when spoofing pid over SCM_RIGHTS
      Rename nsproxy.pid_ns to nsproxy.pid_ns_for_children

Ariel Elior (4):
      bnx2x: vf mark stats started
      bnx2x: Fix functionality of configuring vlan list
      bnx2x: Fix VF memory leak unload
      bnx2x: Fix VF stats sync

Barry Song (2):
      irqchip: sirf: move from legacy mode to linear irqdomain
      arm: prima2: drop nr_irqs in mach as we moved to linear irqdomain

Benjamin Herrenschmidt (1):
      powerpc: Don't Oops when accessing /proc/powerpc/lparcfg without
hypervisor

Byungho An (1):
      net: stmmac: fixed the pbl setting with DT

Chris Clark (1):
      ipv4: sendto/hdrincl: don't use destination address found in header

Cyrill Gorcunov (1):
      mm: move_ptes -- Set soft dirty bit depending on pte type

Dan Carpenter (1):
      mISDN: return -EINVAL on error in dsp_control_req()

Daniel Borkmann (1):
      net: bridge: convert MLDv2 Query MRC into msecs_to_jiffies for max_delay

Dave Kleikamp (1):
      jfs: fix readdir cookie incompatibility with NFSv4

David Jander (1):
      regmap: rbtree: Fix overlapping rbnodes.

David S. Miller (1):
      Revert "ipv6: Don't depend on per socket memory for neighbour
discovery messages"

Eliezer Tamir (1):
      net: add cpu_relax to busy poll loop

Eric Dumazet (1):
      net: revert 8728c544a9c ("net: dev_pick_tx() fix")

Erik Hugne (1):
      tipc: set sk_err correctly when connection fails

Eugene Surovegin (1):
      powerpc/hvsi: Increase handshake timeout from 200ms to 400ms.

Felix Fietkau (1):
      mac80211: add a flag to indicate CCK support for HT clients

Goldwyn Rodrigues (1):
      fs/ocfs2/super.c: Use bigger nodestr to accomodate 32-bit node numbers

Guenter Roeck (1):
      dma/Kconfig: TI_EDMA needs to be boolean

Hannes Frederic Sowa (7):
      xfrm: make local error reporting more robust
      xfrm: introduce helper for safe determination of mtu
      ipv6: wire up skb->encapsulation
      ipv6: xfrm: dereference inner ipv6 header if encapsulated
      xfrm: choose protocol family by skb protocol
      xfrm: revert ipv4 mtu determination to dst_mtu
      ipv6: set skb->protocol on tcp, raw and ip6_append_data genereated skbs

Hans Verkuil (1):
      [SCSI] pm80xx: fix Adaptec 71605H hang

Helmut Schaa (1):
      ath9k_htc: Restore skb headroom when returning skb to mac80211

Hugh Dickins (1):
      cgroup: fix rmdir EBUSY regression in 3.11

Ian Campbell (1):
      MAINTAINERS: change my DT related maintainer address

Imre Deak (1):
      drm/i915: ivb: fix edp voltage swing reg val

Jakob Bornecrantz (1):
      drm/vmwgfx: Split GMR2_REMAP commands if they are to large

Johannes Berg (1):
      mac80211: add missing channel context release

Kevin Hilman (1):
      regmap: Add another missing header for !CONFIG_REGMAP stubs

Li Hongjun (1):
      ipv4 tunnels: fix an oops when using ipip/sit with IPsec

Libo Chen (1):
      net: xilinx: fix memleak

Linus Lüssing (1):
      bridge: separate querier and query timer into IGMP/IPv4 and MLD/IPv6 ones

Linus Torvalds (2):
      Revert "fs: Allow unprivileged linkat(..., AT_EMPTY_PATH) aka flink"
      Linux 3.11

Mag (1):
      Input: xpad - add signature for Razer Onza Classic Edition

Matteo Delfino (1):
      Input: elantech - fix packet check for v3 and v4 hardware

Michal Schmidt (3):
      jme: lower NAPI weight
      netxen: lower NAPI weight
      ps3_gelic: lower NAPI weight

Mike Frysinger (1):
      Omnikey Cardman 4000: pull in ioctl.h in user header

Mischa Jonker (1):
      Input: i8042 - disable the driver on ARC platforms

Nathan Zimmer (1):
      timer_list: correct the iterator for timer_list

Paul Mackerras (1):
      powerpc: Work around gcc miscompilation of __pa() on 64-bit

Phil Oester (1):
      tcp: tcp_make_synack() should use sock_wmalloc

Ping Cheng (1):
      Input: wacom - add support for 0x300 and 0x301

Pravin B Shelar (2):
      genl: Fix genl dumpit() locking.
      genl: Hold reference on correct module while netlink-dump.

Richard Cochran (1):
      net: fec: fix time stamping logic after napi conversion

Rob Gardner (1):
      net: usb: Add HP hs2434 device to ZLP exception table

Russ Anderson (1):
      drivers/base/memory.c: fix show_mem_removable() to handle missing sections

Sarveshwar Bandi (1):
      be2net: Check for POST state in suspend-resume sequence

Simon Wunderlich (1):
      mac80211: ibss: fix ignored channel parameter

Stanislaw Gruszka (1):
      iwl4965: fix rfkill set state regression

Steffen Klassert (1):
      xfrm: Fix potential null pointer dereference in xdst_queue_output

Sujith Manoharan (1):
      ath9k: Enable PLL fix only for AR9340/AR9330

Svenning Sørensen (1):
      IPC: bugfix for msgrcv with msgtyp < 0

Takashi Iwai (3):
      ALSA: hda - Add inverted digital mic fixup for Acer Aspire One
      ALSA: hda - Fix NULL dereference with CONFIG_SND_DYNAMIC_MINORS=n
      ALSA: opti9xx: Fix conflicting driver object name

Tejun Heo (1):
      workqueue: cond_resched() after processing each work item

Thomas Graf (1):
      ipv6: Don't depend on per socket memory for neighbour discovery messages

Trond Myklebust (1):
      SUNRPC: Fix memory corruption issue on 32-bit highmem systems

Waiman Long (2):
      Add new lockref infrastructure reference implementation
      vfs: make the dentry cache use the lockref infrastructure

Yinghai Lu (1):
      x86/mm: Fix boot crash with DEBUG_PAGE_ALLOC=y and more than 512G RAM

Yuval Mintz (1):
      bnx2x: Fix move FP memory deallocations
