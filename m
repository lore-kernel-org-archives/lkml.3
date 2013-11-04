Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752591Ab3KDALX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 19:11:23 -0500
Received: from mail-ve0-f176.google.com ([209.85.128.176]:33513 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889Ab3KDALB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 19:11:01 -0500
MIME-Version: 1.0
Date: Sun, 3 Nov 2013 16:10:59 -0800
X-Google-Sender-Auth: p8Sci95ya4aPJ0vsaBymtJMnyck
Message-ID: <CA+55aFwLkvSkparyvekdmMyvr6Srw1KkzTBp=_w0oQRWnPpJug@mail.gmail.com>
Subject: Linux 3.12 released .. and no merge window yet .. and 4.0 plans?
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was vacillating whether to do an rc8 or just cut the final 3.12, but
since the biggest reason to *not* do a final release was not so much
the state of the code, as simply the fact that I'll be traveling with
very bad internet connection next week, I didn't really want to delay
the release. Sure, we had a number of driver reverts, and there was an
annoying auto-NUMA memory corruption fix series, but none of it was
really worth delaying 3.12 for.

But the fact that I'm going to be (effectively) off-line next week
means that I'm *not* opening the merge window for 3.13 yet - since I
won't have the bandwidth to really do merges anyway.

That doesn't mean that you can't send me pull request for the merge
window early, of course - maintainers can *always* send their pull
requests early rather than late, if they have everything lined up and
ready. But if you have some feature that still wants polishing, you
basically get a free week to do that.

So the two-week merge window for 3.13 will start a week from now. You
have an extra week. But that also means that I will be doubly
disappointed in anybody who then leaves their merge request until the
*end* of that two-week merge window.

Anyway..

Onto a totally different topic: we're getting to release numbers where
I have to take off my socks to count that high again. I'm ok with
3.<low teens>, but I don't want us to get to the kinds of crazy
numbers we had in the 2.x series, so at some point we're going to cut
over from 3.x to 4.x, just to keep the numbers small and easy to
remember. We're not there yet, but I would actually prefer to not go
into the twenties, so I can see it happening in a year or so, and
we'll have 4.0 follow 3.19 or something like that.

Now, it's just a number (since we've long since given up on
feature-related releases), and it's at least a year away, so why do I
even mention it at all?

The reason I mention it is because I've been mulling over something
Dirk Hohndel said during LinuxCon EU and the kernel summit. He asked
at the Q&A session whether we could do a release with just stability
and bug-fixes, and I pooh-poohed it because I didn't see most of us
having the attention span required for that
(cough*cough*moronic*woodland creature*cough*cough).

So I may be pessimistic, but I'd expect many developers would go
"Let's hunt bugs.. Wait. Oooh, shiny" and go off doing some new
feature after all instead. Or just take that release off.

But I do wonder.. Maybe it would be possible, and I'm just unfairly
projecting my own inner squirrel onto other kernel developers. If we
have enough heads-up that people *know* that for one release (and
companies/managers know that too) the only patches that get accepted
are the kind that fix bugs, maybe people really would have sufficient
attention span that it could work.

And the reason I mention "4.0" is that it would be a lovely time to do
that. Roughly a years heads-up that "ok, after 3.19 (or whatever),
we're doing a release with *just* fixes, and then that becomes 4.0".

Comments?

                    Linus

---

Alex Deucher (3):
      drm/radeon: use sw CTS/N values for audio on DCE4+
      drm/radeon: disable bapm on KB
      drm/radeon/dpm: fix incompatible casting on big endian

Andrey Moiseev (1):
      Input: i8042 - i8042_flush fix for a full 8042 buffer

Arnaldo Carvalho de Melo (1):
      perf tools: Fix up /proc/PID/maps parsing

Baruch Siach (1):
      xtensa: don't use alternate signal stack on threads

Bastien Nocera (1):
      Input: wacom - export battery scope

Chen LinX (1):
      mm/pagewalk.c: fix walk_page_range() access of wrong PTEs

Dan Carpenter (6):
      uml: check length in exitcode_proc_write()
      staging: ozwpan: prevent overflow in oz_cdev_write()
      aacraid: missing capable() check in compat ioctl
      staging: wlags49_h2: buffer overflow setting station name
      Staging: bcm: info leak in ioctl
      Staging: sb105x: info leak in mp_get_count()

Daniel Vetter (1):
      drm/i915: Fix the PPT fdi lane bifurcate state handling on ivb

David Herrmann (2):
      Input: move name/timer init to input_alloc_dev()
      drm: allow DRM_IOCTL_VERSION on render-nodes

Deng-Cheng Zhu (1):
      MIPS: Perf: Fix 74K cache map

Dinh Nguyen (1):
      clk: socfpga: Fix incorrect sdmmc clock name

Greg KH (1):
      USB: Maintainers change for usb serial drivers

Greg Kroah-Hartman (12):
      Revert "USB: pl2303: distinguish between original and cloned HX chips"
      Revert "pl2303: improve the chip type detection/distinction"
      Revert "pl2303: improve the chip type information output on startup"
      Revert "pl2303: simplify the else-if contruct for type_1 chips
in pl2303_startup()"
      Revert "usb: pl2303: add two comments concerning the supported
baud rates with HX chips"
      Revert "usb: pl2303: also use the divisor based baud rate
encoding method for baud rates < 115200 with HX chips"
      Revert "usb: pl2303: increase the allowed baud rate range for
the divisor based encoding method"
      Revert "usb: pl2303: move the two baud rate encoding methods to
separate functions"
      Revert "usb: pl2303: remove 500000 baud from the list of
standard baud rates"
      Revert "usb: pl2303: do not round to the next nearest standard
baud rate for the divisor based baud rate encoding method"
      Revert "usb: pl2303: fix+improve the divsor based baud rate
encoding method"
      Revert "USB: pl2303: restrict the divisor based baud rate
encoding method to the "HX" chip type"

Greg Thelen (3):
      percpu: fix this_cpu_sub() subtrahend casting for unsigneds
      memcg: use __this_cpu_sub() to dec stats to avoid incorrect
subtrahend casting
      memcg: remove incorrect underflow check

James Bottomley (4):
      [SCSI] Revert "sg: push file descriptor list locking down to
per-device locking"
      [SCSI] Revert "sg: checking sdp->detached isn't protected when open"
      [SCSI] Revert "sg: no need sg_open_exclusive_lock"
      [SCSI] Revert "sg: use rwsem to solve race during exclusive open"

Jani Nikula (1):
      drm/i915/dp: workaround BIOS eDP bpp clamping issue

Jason Gerecke (2):
      Input: wacom - add support for ISDv4 0x10F sensor
      Input: wacom - add support for ISDv4 0x10E sensor

Jiri Olsa (3):
      perf hists: Add color overhead for stdio output buffer
      perf record: Split -g and --call-graph
      perf top: Split -G and --call-graph

Johannes Weiner (3):
      mm: memcg: use proper memcg in limit bypass
      mm: memcg: lockdep annotation for memcg OOM lock
      mm: memcg: fix test for child groups

Jonathan Austin (1):
      clk: fixup argument order when setting VCO parameters

Joseph Schuchart (1):
      perf script python: Fix mem leak due to missing Py_DECREFs on dict entries

Linus Torvalds (5):
      Kconfig: make KOBJECT_RELEASE debugging require timer debugging
      Fix a few incorrectly checked [io_]remap_pfn_range() calls
      i915: fix compiler warning
      vfs: decrapify dput(), fix cache behavior under normal load
      Linux 3.12

Linus Walleij (1):
      clk: nomadik: set all timers to use 2.4 MHz TIMCLK

Markos Chandras (1):
      MIPS: malta: Fix GIC interrupt offsets

Mathias Krause (1):
      ipc, msg: forbid negative values for "msg{max,mnb,mni}"

Max Filippov (1):
      xtensa: fix fast_syscall_spill_registers_fixup

Mel Gorman (6):
      mm: numa: Do not account for a hinting fault if we raced
      mm: Wait for THP migrations to complete during NUMA hinting faults
      mm: Prevent parallel splits during THP migration
      mm: numa: Sanitize task_numa_fault() callsites
      mm: Close races between THP migration and PMD numa clearing
      mm: Account for a THP NUMA hinting update as one PTE update

Mika Westerberg (1):
      Revert "ACPI / hotplug / PCI: Avoid doing too much for spurious notifies"

Mike Dunn (1):
      Input: pxa27x_keypad - fix NULL pointer dereference

Ming Lei (2):
      lib/scatterlist.c: don't flush_kernel_dcache_page on slab page
      scripts/kallsyms: filter symbols not in kernel address space

Nicolas Ferre (1):
      tty/serial: at91: fix uart/usart selection for older products

Paolo Bonzini (1):
      KVM: use a more sensible error number when debugfs directory
creation fails

Peter Zijlstra (2):
      perf: Fix perf ring buffer memory ordering
      perf/x86: Fix NMI measurements

Rafael J. Wysocki (2):
      Revert "epoll: use freezable blocking call"
      Revert "select: use freezable blocking call"

Rob Pearce (1):
      drm/i915: No LVDS hardware on Intel D410PT and D425KT

Russell King (2):
      mm: list_lru: fix almost infinite loop causing effective livelock
      ALSA: fix oops in snd_pcm_info() caused by ASoC DPCM

Simon Guinot (1):
      clk: armada-370: fix tclk frequencies

Takashi Iwai (7):
      ALSA: hda - Fix unbalanced runtime PM refcount after S3/S4
      ALSA: hda - Add missing initial vmaster hook at build_controls callback
      ALSA: hda - Fix silent headphone on Thinkpads with AD1984A codec
      ASoC: dapm: Fix source list debugfs outputs
      ASoC: dapm: Return -ENOMEM in snd_soc_dapm_new_dai_widgets()
      ALSA: hda - Add a fixup for ASUS N76VZ
      ASoC: wm_hubs: Add missing break in hp_supply_event()

Thomas Meyer (1):
      xtensa: Cocci spatch "noderef"

Tim Gardner (2):
      Input: cm109 - convert high volume dev_err() to dev_err_ratelimited()
      KVM: Fix modprobe failure for kvm_intel/kvm_amd

Ville Syrjälä (2):
      drm/i915: Add support for pipe_bpp readout
      drm/i915: Add HSW CRT output readout support

Vineet Gupta (1):
      ARC: Incorrect mm reference used in vmalloc fault handler

Wei Yongjun (1):
      MIPS: ralink: fix return value check in rt_timer_probe()

Yunkang Tang (1):
      Input: ALPS - add support for model found on Dell XT2

Zhouyi Zhou (1):
      perf tools: Fixup mmap event consumption

Алексей Крамаренко (1):
      USB: serial: ftdi_sio: add id for Z3X Box device
