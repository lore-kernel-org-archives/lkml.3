Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932550AbaJGXoN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 19:44:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39504 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755395AbaJGXTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 19:19:45 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: [PATCH 3.16 00/26] 3.16.5-stable review
Date: Tue,  7 Oct 2014 16:19:16 -0700
Message-Id: <20141007231848.487609292@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.16.5 release.
There are 26 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu Oct  9 23:18:40 UTC 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.16.5-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.16.5-rc1

Andrew Hunter <ahh@google.com>
    jiffies: Fix timeval conversion to jiffies

Hans Verkuil <hans.verkuil@cisco.com>
    media: vb2: fix VBI/poll regression

Mel Gorman <mgorman@suse.de>
    mm: numa: Do not mark PTEs pte_numa when splitting huge pages

Waiman Long <Waiman.Long@hp.com>
    mm, thp: move invariant bug check out of loop in __split_huge_page_map

Bruno Prémont <bonbons@linux-vserver.org>
    vgaarb: Don't default exclusively to first video device with mem+io

Bruno Prémont <bonbons@linux-vserver.org>
    x86, ia64: Move EFI_FB vga_default_device() initialization to pci_vga_fixup()

Hans de Goede <hdegoede@redhat.com>
    uas: Add missing le16_to_cpu calls to asm1051 / asm1053 usb-id check

Hans de Goede <hdegoede@redhat.com>
    uas: Disable uas on ASM1051 devices

Hans de Goede <hdegoede@redhat.com>
    uas: Log a warning when we cannot use uas because the hcd lacks streams

Hans de Goede <hdegoede@redhat.com>
    uas: Only complain about missing sg if all other checks succeed

Steven Rostedt (Red Hat) <rostedt@goodmis.org>
    ring-buffer: Fix infinite spin in reading buffer

Josh Triplett <josh@joshtriplett.org>
    init/Kconfig: Fix HAVE_FUTEX_CMPXCHG to not break up the EXPERT menu

Steve French <smfrench@gmail.com>
    Fix problem recognizing symlinks

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915: Flush the PTEs after updating them before suspend

NeilBrown <neilb@suse.de>
    md/raid5: disable 'DISCARD' by default due to safety concerns.

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpufreq: pcc-cpufreq: Fix wait_event() under spinlock

Arnd Bergmann <arnd@arndb.de>
    cpufreq: integrator: fix integrator_cpufreq_remove return type

Aaron Lu <aaron.lu@intel.com>
    ACPI / i915: Update the condition to ignore firmware backlight change request

Alexandru M Stan <amstan@chromium.org>
    i2c: rk3x: fix 0 length write transfers

Andy Gross <agross@codeaurora.org>
    i2c: qup: Fix order of runtime pm initialization

Mel Gorman <mgorman@suse.de>
    mm: migrate: Close race between migration completion and mprotect

Johannes Weiner <hannes@cmpxchg.org>
    mm: memcontrol: do not iterate uninitialized memcgs

Peter Zijlstra <peterz@infradead.org>
    perf: fix perf bug in fork()

Xiubo Li <Li.Xiubo@freescale.com>
    ASoC: core: fix possible ZERO_SIZE_PTR pointer dereferencing error.

Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
    ASoC: ssm2602: do not hardcode type to SSM2602

Jan Kara <jack@suse.cz>
    udf: Avoid infinite loop when processing indirect ICBs


-------------

Diffstat:

 Makefile                                 |  4 +-
 arch/ia64/pci/fixup.c                    |  4 +-
 arch/x86/include/asm/vga.h               |  6 ---
 arch/x86/pci/fixup.c                     |  3 +-
 drivers/cpufreq/integrator-cpufreq.c     |  4 +-
 drivers/cpufreq/pcc-cpufreq.c            |  2 +-
 drivers/gpu/drm/i915/i915_gem_gtt.c      | 14 ++++++-
 drivers/gpu/drm/i915/intel_opregion.c    | 16 +++++---
 drivers/gpu/vga/vgaarb.c                 | 38 +++++++++++++++++-
 drivers/i2c/busses/i2c-qup.c             | 12 ++++--
 drivers/i2c/busses/i2c-rk3x.c            |  2 +-
 drivers/md/raid5.c                       | 18 ++++++++-
 drivers/media/v4l2-core/videobuf2-core.c | 15 ++++++-
 drivers/usb/storage/uas-detect.h         | 67 ++++++++++++++++++++------------
 drivers/video/fbdev/efifb.c              | 39 -------------------
 fs/cifs/smb1ops.c                        |  2 +-
 fs/cifs/smb2maperror.c                   |  2 +
 fs/udf/inode.c                           | 35 ++++++++++-------
 include/linux/jiffies.h                  | 12 ------
 include/media/videobuf2-core.h           |  4 ++
 init/Kconfig                             |  1 +
 kernel/events/core.c                     |  4 +-
 kernel/fork.c                            |  5 ++-
 kernel/time.c                            | 54 +++++++++++++------------
 kernel/trace/ring_buffer.c               |  2 +-
 mm/huge_memory.c                         | 11 ++++--
 mm/memcontrol.c                          | 36 ++++++++++++++---
 mm/migrate.c                             |  5 ++-
 sound/soc/codecs/ssm2602.c               |  2 +-
 sound/soc/soc-core.c                     |  2 +-
 30 files changed, 260 insertions(+), 161 deletions(-)


