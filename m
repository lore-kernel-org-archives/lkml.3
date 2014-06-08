Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753700AbaFHSwa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2014 14:52:30 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:37453 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753638AbaFHSw3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2014 14:52:29 -0400
MIME-Version: 1.0
Date: Sun, 8 Jun 2014 11:52:27 -0700
X-Google-Sender-Auth: JRNiRoLYnVDOdSnEJffbdrvMDrY
Message-ID: <CA+55aFw3A=ycq4kRpsDDoV4+rzg0z2kwfE9C9Bg1nSwiYfUpLw@mail.gmail.com>
Subject: Linux 3.15 .. and continuation of merge window
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So I ended up doing an rc8 because I was a bit worried about some
last-minute dcache fixes, but it turns out that nobody seemed to even
notice those. We did have other issues during the week, though, so it
was just as well. The futex fixes and cleanups may stand out, but as
usual there's various other random fixes since rc8 in there too:
mainly drivers (drm, networking, sound, usb etc), networking,
scheduling and perf tooling.

But it's all been fairly small and quiet, which *may* of course be due
to the fact that last week was also the first week of the merge window
for 3.16. That might have distracted some developers. I'm not entirely
convinced I liked the overlap, but it seemed to work ok, and unless
people scream really loudly ("Please don't _ever_ do that again") and
give good reasons for doing so, I might end up doing that overlapping
merge window in the future too if it ends up helping out with some
particular timing issue.

That said, I also don't think it was such a wonderful experience that
I'd want to necessarily do the overlap every time, without a good
specific reason for doing so. It was kind of nice being productive
during the last week or rc (which is usually quite boring and dead),
but I think it might be a distraction when people should be worrying
about the stability of the rc.

Of course, maybe the overlap ends up meaning that we get less noise
during the last week of stabilization, and it actually helps. It could
go either way. I'd be interested to hear what people thought, although
I _suspect_ most people don't feel strongly either way.

Anyway, with 3.15 released, my "master" branch has already merged the
work in my "next" branch on my local machine, and I'll be
decommissioning the "next" branch once I push that all out.  After
that, any future merge window work will happen on "master", and we'll
be back to the normal single-branch model for my tree.

                 Linus

---

Alan Stern (1):
      USB: Avoid runtime suspend loops for HCDs that can't handle suspend/resume

Aleksander Morgado (3):
      net: qmi_wwan: add Netgear AirCard 341U
      net: qmi_wwan: add additional Sierra Wireless QMI devices
      net: qmi_wwan: interface #11 in Sierra Wireless MC73xx is not QMI

Alex Deucher (1):
      drm/radeon/dpm: resume fixes for some systems

Alexej Starschenko (1):
      USB: serial: option: add support for Novatel E371 PCIe card

Andrey Ryabinin (1):
      mm: rmap: fix use-after-free in __put_anon_vma

Andy Lutomirski (1):
      x86, vdso: Fix an OOPS accessing the HPET mapping w/o an HPET

Bart De Schuymer (1):
      ebtables: Update MAINTAINERS entry.

Ben Hutchings (2):
      Staging: speakup: Move pasting into a work item
      Staging: speakup: Update __speakup_paste_selection() tty
(ab)usage to match vt

Bjørn Mork (1):
      usb: cdc-wdm: export cdc-wdm uapi header

Christian König (3):
      drm/radeon: fix vm buffer size estimation
      drm/radeon: sync page table updates
      drm/radeon: use the CP DMA on CIK

Dan Carpenter (1):
      qlcnic: info leak in qlcnic_dcb_peer_app_info()

Dave Young (2):
      x86/efi: earlyprintk=efi,keep fix
      x86/efi: Do not export efi runtime map in case old map

Dirk Brandewie (3):
      intel_pstate: Remove C0 tracking
      intel_pstate: Correct rounding in busy calculation
      intel_pstate: add sample time scaling

Doug Smythies (1):
      intel_pstate: Improve initial busy calculation

Emmanuel Grumbach (1):
      iwlwifi: mvm: disable beacon filtering

Eric Dumazet (1):
      net: fix inet_getid() and ipv6_select_ident() bugs

Eric W. Biederman (1):
      netlink: Only check file credentials for implicit destinations

Filipe Manana (1):
      Btrfs: send, fix corrupted path strings for long paths

George McCollister (1):
      USB: ftdi_sio: add NovaTech OrionLXm product ID

Greg Kroah-Hartman (1):
      USB: cdc-wdm: properly include types.h

Ian Abbott (1):
      staging: comedi: ni_daq_700: add mux settling delay

Igor Mammedov (3):
      x86: Fix list/memory corruption on CPU hotplug
      x86/smpboot: Log error on secondary CPU wakeup failure at ERR level
      x86/smpboot: Initialize secondary CPU only if master CPU will wait for it

Ivan Mikhaylov (2):
      emac: add missing support of 10mbit in emac/rgmii
      emac: aggregation of v1-2 PLB errors for IER register

Jack Morgenstein (1):
      net/mlx4_core: Reset RoCE VF gids when guest driver goes down

Jean Delvare (1):
      net: ec_bhf: Add runtime dependencies

Jianyu Zhan (1):
      kernfs: move the last knowledge of sysfs out from kernfs

Jiri Pirko (1):
      team: fix mtu setting

Johan Hovold (1):
      USB: io_ti: fix firmware download on big-endian machines (part 2)

Jon Maxwell (1):
      bridge: notify user space after fdb update

Kirill Tkhai (1):
      sched/dl: Fix race in dl_task_timer()

Kristian Evensen (1):
      ipheth: Add support for iPad 2 and iPad 3

Leon Yu (1):
      net: filter: fix possible memory leak in __sk_prepare_filter()

Linus Torvalds (2):
      Revert "x86/smpboot: Initialize secondary CPU only if master CPU
will wait for it"
      Linux 3.15

Marek Lindner (1):
      batman-adv: fix NULL pointer dereferences

Martin K. Petersen (1):
      libata: Blacklist queued trim for Crucial M500

Masami Hiramatsu (2):
      perf probe: Fix a segfault if asked for variable it doesn't find
      perf probe: Fix perf probe to find correct variable DIE

Mathias Nyman (2):
      usb: pci-quirks: Prevent Sony VAIO t-series from switching usb ports
      xhci: delete endpoints from bandwidth list before freeing whole device

Matt Fleming (1):
      x86/boot: EFI_MIXED should not prohibit loading above 4G

Michal Schmidt (1):
      netlink: rate-limit leftover bytes warning and print process name

Naoya Horiguchi (1):
      mm: add !pte_present() check on existing hugetlb_entry callbacks

NeilBrown (2):
      md: always set MD_RECOVERY_INTR when aborting a reshape or other "resync".
      md: always set MD_RECOVERY_INTR when interrupting a reshape thread.

Nicholas Bellinger (4):
      iser-target: Add missing target_put_sess_cmd for ImmedateData failure
      iser-target: Fix multi network portal shutdown regression
      target: Allow READ_CAPACITY opcode in ALUA Standby access state
      target: Fix alua_access_state attribute OOPs for un-configured devices

Nikolay Aleksandrov (1):
      net: fix wrong mac_len calculation for vlans

Oliver Hartkopp (1):
      can: only rename enabled led triggers when changing the netdev name

Peter Christensen (1):
      ipvs: Fix panic due to non-linear skb

Richard Weinberger (1):
      sched: Fix sched_policy < 0 comparison

Roland Dreier (1):
      iscsi-target: Fix wrong buffer / buffer overrun in
iscsi_change_param_value()

Roman Gushchin (1):
      sched/fair: Fix tg_set_cfs_bandwidth() deadlock on rq->lock

Ronan Marquet (1):
      ALSA: hda/realtek - Correction of fixup codes for PB V7900 laptop

Rusty Russell (1):
      speakup: fix incorrect perms on speakup_acntsa.c

Samuel Ortiz (1):
      Bluetooth: Fix L2CAP LE debugfs entries permissions

Sean MacLennan (1):
      staging: r8192e_pci: fix htons error

Sebastian Ott (1):
      percpu-refcount: fix usage of this_cpu_ops

Sergei Antonov (1):
      drm/crtc-helper: skip locking checks in panicking path

Steven Rostedt (1):
      sched/numa: Fix use of spin_{un}lock_irq() when interrupts are disabled

Takashi Iwai (2):
      ALSA: hda/analog - Fix silent output on ASUS A8JN
      ALSA: hda/realtek - Fix COEF widget NID for ALC260 replacer fixup

Thomas Gleixner (4):
      futex-prevent-requeue-pi-on-same-futex.patch futex: Forbid uaddr
== uaddr2 in futex_requeue(..., requeue_pi=1)
      futex: Validate atomic acquisition in futex_lock_pi_atomic()
      futex: Always cleanup owner tid in unlock_pi
      futex: Make lookup_pi_state more robust

Toshiaki Makita (1):
      bridge: Prevent insertion of FDB entry with disallowed vlan

Yinghai Lu (1):
      x86: irq: Get correct available vectors for cpu disable

Yuchung Cheng (1):
      tcp: fix cwnd undo on DSACK in F-RTO
