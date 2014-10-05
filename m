Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751950AbaJETuy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 15:50:54 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:38369 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474AbaJETuv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 15:50:51 -0400
MIME-Version: 1.0
Date: Sun, 5 Oct 2014 12:50:50 -0700
X-Google-Sender-Auth: iUKD64LnQNWbPEI6F8pZdPyvZiA
Message-ID: <CA+55aFw1jLgKZtUfDdnD4vW6V+-ts5zYxKVuB8QhxGkGzZ-i9w@mail.gmail.com>
Subject: Linux 3.17
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So the past week was fairly calm, and so I have no qualms about
releasing 3.17 on the normal schedule (as opposed to the optimistic
"maybe I can release it one week early" schedule that was not to be).

However, I now have travel coming up - something I hoped to avoid when
I was hoping for releasing early. Which means that while 3.17 is out,
I'm not going to be merging stuff very actively next week, and the
week after that is LinuxCon EU...

What that means is that depending on how you want to see it, the 3.18
merge window will either be three weeks, or alternatively just have a
rather slow start.  I don't mind getting pull requests starting now
(in fact, I have a couple already pending in my inbox), but I likely
won't start processing them for a week.

Anyway, back to 3.17. Nothing major happened during the last week, as
you can see from the appended shortlog. Mostly drivers (i915, nouveau,
ethernet, scsi, sound) and some networking fixes.  With some misc
noise all over.

Go out and test,

              Linus

---

Aaron Lu (1):
      ACPI / i915: Update the condition to ignore firmware backlight
change request

Alexandru M Stan (1):
      i2c: rk3x: fix 0 length write transfers

Anatolij Gustschin (1):
      MAINTAINERS: change git URL for mpc5xxx tree

Andy Gross (1):
      i2c: qup: Fix order of runtime pm initialization

Anish Bhatt (1):
      [SCSI] cxgb4i: avoid holding mutex in interrupt context

Arnd Bergmann (1):
      cpufreq: integrator: fix integrator_cpufreq_remove return type

Bard Liao (2):
      ASoC: rt286: Correct default value
      ASoC: rt286: Fix sync function

Ben Skeggs (4):
      drm/nv50/disp: fix dpms regression on certain boards
      drm/nouveau: fix regression on original nv50 board
      drm/nouveau: punt fbcon resume out to a workqueue
      drm/nouveau: make sure display hardware is reinitialised on runtime resume

Bo Shen (1):
      MAINTAINERS: add atmel audio alsa driver maintainer entry

Chris Wilson (1):
      drm/i915: Flush the PTEs after updating them before suspend

Christoph Hellwig (1):
      [SCSI] uas: disable use of blk-mq I/O path

Eric Dumazet (1):
      gro: fix aggregation for skb using frag_list

Hannes Frederic Sowa (1):
      ipv6: remove rt6i_genid

Helge Deller (1):
      parisc: Fix serial console for machines with serial port on superio chip

Ignacy Gawędzki (1):
      ematch: Fix matching of inverted containers.

J. Bruce Fields (1):
      nfsd4: fix corruption of NFSv4 read data

Johannes Weiner (2):
      mm: memcontrol: do not iterate uninitialized memcgs
      mm: page_alloc: fix zone allocation fairness on UP

Jon Medhurst (1):
      ARM: 8179/1: kprobes-test: Fix compile error "bad immediate
value for offset"

Josh Triplett (2):
      init/Kconfig: Hide printk log config if CONFIG_PRINTK=n
      init/Kconfig: Fix HAVE_FUTEX_CMPXCHG to not break up the EXPERT menu

KY Srinivasan (1):
      hyperv: Fix a bug in netvsc_start_xmit()

Krzysztof Kozlowski (1):
      ARM: 8177/1: cacheflush: Fix v7_exit_coherency_flush exynos
build breakage on ARMv6

Kweh, Hock Leong (1):
      net: stmmac: fix stmmac_pci_probe failed when CONFIG_HAVE_CLK is selected

Linus Torvalds (1):
      Linux 3.17

Manish Chopra (5):
      qlcnic: Fix memory corruption while reading stats using ethtool.
      qlcnic: Remove __QLCNIC_DEV_UP bit check to read TX queues statistics.
      qlcnic: Fix ordering of stats in stats buffer.
      netxen: Fix BUG "sleeping function called from invalid context"
      netxen: Fix bug in Tx completion path.

Matan Barak (1):
      net/mlx4_core: Allow not to specify probe_vf in SRIOV IB mode

Mauro Carvalho Chehab (1):
      Revert "[media] media: em28xx - remove reset_resume interface"

Mel Gorman (2):
      mm: migrate: Close race between migration completion and mprotect
      mm: numa: Do not mark PTEs pte_numa when splitting huge pages

Michael Trimarchi (1):
      ASoC: fsl_ssi: fix kernel panic in probe function

Nathan Lynch (1):
      ARM: 8178/1: fix set_tls for !CONFIG_KUSER_HELPERS

NeilBrown (1):
      md/raid5: disable 'DISCARD' by default due to safety concerns.

Nicolas Dichtel (1):
      ip6gre: add a rtnl link alias for ip6gretap

Pablo Neira Ayuso (5):
      netfilter: nft_hash: no need for rcu in the hash set destroy path
      netfilter: nft_rbtree: no need for spinlock from set destroy path
      rhashtable: fix lockdep splat in rhashtable_destroy()
      netfilter: nfnetlink: deliver netlink errors on batch completion
      netfilter: xt_TPROXY: undefined reference to `udp6_lib_lookup'

Pavel Shilovsky (1):
      CIFS: Fix readpages retrying on reconnects

Peter Zijlstra (1):
      perf: fix perf bug in fork()

Qiao Zhou (1):
      ASoC: soc-compress: fix double unlock of fe card mutex

Rafael J. Wysocki (1):
      cpufreq: pcc-cpufreq: Fix wait_event() under spinlock

Rasesh Mody (1):
      bna: Update Maintainer Email

Robin Murphy (1):
      ARM: 8165/1: alignment: don't break misaligned NEON load/store

Sony Chacko (1):
      qlcnic: Use qlcnic_83xx_flash_read32() API instead of lockless
version of the API.

Soren Brinkmann (1):
      Revert "net/macb: add pinctrl consumer support"

Stefan Kristiansson (1):
      ASoC: ssm2602: do not hardcode type to SSM2602

Steffen Klassert (4):
      ip_tunnel: Don't allow to add the same tunnel multiple times.
      ip6_tunnel: Return an error when adding an existing tunnel.
      ip6_vti: Return an error when adding an existing tunnel.
      ip6_gre: Return an error when adding an existing tunnel.

Steve French (1):
      Fix problem recognizing symlinks

Steven Rostedt (Red Hat) (1):
      ring-buffer: Fix infinite spin in reading buffer

Viresh Kumar (1):
      cpufreq: update 'cpufreq_suspended' after stopping governors

Vlad Yasevich (3):
      macvtap: Fix race between device delete and open.
      tg3: Allow for recieve of full-size 8021AD frames
      bnx2: Correctly receive full sized 802.1ad fragmes

WANG Cong (1):
      neigh: check error pointer instead of NULL for ipv4_neigh_lookup()

Will Deacon (1):
      ARM: 8164/1: mm: clear SCTLR.HA instead of setting it for LPAE

Xiubo Li (1):
      ASoC: core: fix possible ZERO_SIZE_PTR pointer dereferencing error.

alex chen (1):
      ocfs2/dlm: should put mle when goto kill in dlm_assert_master_handler

hayeswang (4):
      r8152: fix the carrier off when autoresuming
      r8152: fix setting RTL8152_UNPLUG
      r8152: remove clearing bp
      r8152: disable power cut for RTL8153
