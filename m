Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752617AbaATDNw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jan 2014 22:13:52 -0500
Received: from mail-ve0-f176.google.com ([209.85.128.176]:40524 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389AbaATDNb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jan 2014 22:13:31 -0500
MIME-Version: 1.0
Date: Sun, 19 Jan 2014 19:13:30 -0800
X-Google-Sender-Auth: tSNvoNvDS3vEF1bdW4gyqOQ-nsc
Message-ID: <CA+55aFy1bG918OpEaydy+f8GetF267Ykz_3-H_sBjTVWsMe1Fg@mail.gmail.com>
Subject: Linux 3.13
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The release got delayed by a week due to travels, but I suspect that's
just as well. We had a few fixes come in, and while it wasn't a lot, I
think we're better off for it. At least I hope so - I'll be very
disappointed if any of them cause more problems than they fix..

Anyway, the patch from rc8 is fairly small, with mainly some small
arch updates (arm, mips, powerpc, s390, sparc, x86 all had some minor
changes, some of them due to a networking fix for the bpf jit). And
drivers (mainly gpu and networking). And some generic networking
fixes. The appended shortlog gives more details.

Anyway, with this, the merge window for 3.14 is obviously open.

                Linus

---

Aaro Koskinen (1):
      MIPS: fix blast_icache32 on loongson2

Andreas Rohner (1):
      nilfs2: fix segctor bug that causes file system corruption

Andrew Jones (1):
      kvm: x86: fix apic_base enable check

Ben Skeggs (1):
      drm/nouveau: fix null ptr dereferences on some boards

Benjamin Herrenschmidt (1):
      powerpc: Check return value of instance-to-package OF call

Bjørn Mork (1):
      net: usbnet: fix SG initialisation

Catalin Marinas (1):
      Revert "arm64: Fix memory shareability attribute for ioremap_wc/cache"

Christian Engelmayer (1):
      ieee802154: Fix memory leak in ieee802154_add_iface()

Christoph Paasch (1):
      tcp: metrics: Avoid duplicate entries with the same destination-IP

Dan Carpenter (1):
      cxgb4: silence shift wrapping static checker warning

Dave Airlie (1):
      Revert "drm: copy mode type in drm_mode_connector_list_update()"

Eric Dumazet (2):
      bpf: do not use reciprocal divide
      parisc: fix SO_MAX_PACING_RATE typo

Eric W. Biederman (3):
      vfs: In d_path don't call d_dname on a mount point
      fork:  Allow CLONE_PARENT after setns(CLONE_NEWPID)
      vfs: Fix a regression in mounting proc

Gerald Schaefer (1):
      net: rds: fix per-cpu helper usage

Hannes Frederic Sowa (2):
      net: avoid reference counter overflows on fib_rules in multicast
forwarding
      ipv6: simplify detection of first operational link-local address
on interface

Heiko Carstens (1):
      s390/bpf,jit: fix 32 bit divisions, use unsigned divide instructions

Huacai Chen (1):
      MIPS: fix case mismatch in local_r4k_flush_icache_range()

Hugh Dickins (1):
      percpu_counter: unbreak __percpu_counter_add()

Ilia Mirkin (1):
      drm/nouveau/mxm: fix null deref on load

Ivan Vecera (1):
      be2net: add dma_mapping_error() check for dma_map_page()

Jan Kara (1):
      writeback: Fix data corruption on NFS

Jean Delvare (1):
      hwmon: (coretemp) Fix truncated name of alarm attributes

Jesse Barnes (1):
      drm/i915/bdw: make sure south port interrupts are enabled properly v2

Jitendra Kalsaria (1):
      qlge: Fix vlan netdev features.

John Stultz (2):
      seqlock: Use raw_ prefix instead of _no_lockdep
      sched_clock: Disable seqlock lockdep usage in sched_clock()

Linus Torvalds (2):
      x86, fpu, amd: Clear exceptions in AMD FXSAVE workaround
      Linux 3.13

Marek Lindner (1):
      batman-adv: fix batman-adv header overhead calculation

Michael S. Tsirkin (1):
      MAINTAINERS: add virtio-dev ML for virtio

Mika Westerberg (1):
      e1000e: Fix compilation warning when !CONFIG_PM_SLEEP

Mikulas Patocka (1):
      mm: fix crash when using XFS on loopback

Ming Lei (1):
      lib/percpu_counter.c: fix __percpu_counter_add()

Neal Cardwell (1):
      inet_diag: fix inet_diag_dump_icsk() to use correct state for
timewait sockets

NeilBrown (6):
      md/raid5: Fix possible confusion when multiple write errors occur.
      md/raid10: fix two bugs in handling of known-bad-blocks.
      md/raid1: fix request counting bug in new 'barrier' code.
      md/raid5: fix a recently broken BUG_ON().
      md/raid10: fix bug when raid10 recovery fails to recover a block.
      md: fix problem when adding device to read-only array with bitmap.

Paulo Zanoni (1):
      drm/i915: fix DDI PLLs HW state readout code

Peter Korsgaard (1):
      dm9601: add USB IDs for new dm96xx variants

Peter Zijlstra (1):
      x86, mm, perf: Allow recursive faults from interrupts

Qais Yousef (1):
      crash_dump: fix compilation error (on MIPS at least)

Rafael J. Wysocki (1):
      Revert "ACPI: Add BayTrail SoC GPIO and LPSS ACPI IDs"

Richard Weinberger (1):
      net,via-rhine: Fix tx_timeout handling

Rik van Riel (1):
      sched: Calculate effective load even if local weight is 0

Robert Richter (1):
      perf/x86/amd/ibs: Fix waking up from S3 for AMD family 10h

Russell King (1):
      Revert "ARM: 7908/1: mm: Fix the arm_dma_limit calculation"

Soren Brinkmann (1):
      clocksource: cadence_ttc: Fix mutex taken inside interrupt context

Stephen Boyd (1):
      ARM: 7937/1: perf_event: Silence sparse warning

Stephen Warren (1):
      i2c: Re-instate body of i2c_parent_is_i2c_adapter()

Steven Rostedt (1):
      ftrace/x86: Load ftrace_ops in parameter not the variable holding it

Sudeep Holla (1):
      ARM: 7934/1: DT/kernel: fix arch_match_cpu_phys_id to avoid
erroneous match

Taras Kondratiuk (2):
      ARM: 7939/1: traps: fix opcode endianness when read from user memory
      ARM: 7938/1: OMAP4/highbank: Flush L2 cache before disabling

Ville Syrjälä (1):
      drm/i915: Don't grab crtc mutexes in intel_modeset_gem_init()

Yuval Mintz (1):
      bnx2x: Don't release PCI bars on shutdown
