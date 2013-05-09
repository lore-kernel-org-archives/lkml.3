Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758337Ab3EIWeo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 18:34:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46252 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758304Ab3EIWem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 18:34:42 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [ 00/26] 3.4.45-stable review
Date: Thu,  9 May 2013 15:34:14 -0700
Message-Id: <20130509223422.368544659@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
User-Agent: quilt/0.60-5.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.4.45 release.
There are 26 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat May 11 22:32:50 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.45-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.4.45-rc1

Jerry Hoemann <jerry.hoemann@hp.com>
    x86/mm: account for PGDIR_SIZE alignment

Chen Gang <gang.chen@asianux.com>
    kernel/audit_tree.c: tree will leak memory when failure occurs in audit_trim_trees()

Steven Rostedt (Red Hat) <rostedt@goodmis.org>
    tracing: Fix ftrace_dump()

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: fix handling of v6 power tables

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: add new richland pci ids

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: fix possible segfault when parsing pm tables

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: fix endian bugs in atom_allocate_fb_scratch()

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon/evergreen+: don't enable HPD interrupts on eDP/LVDS

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: add some new SI PCI ids

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: disable the crtcs in mc_stop (evergreen+) (v2)

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: properly lock disp in mc_stop/resume for evergreen+

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon/dce6: add missing display reg for tiling setup

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: don't use get_engine_clock() on APUs

David Müller <d.mueller@elsoft.ch>
    drm/i915: Fall back to bit banging mode for DVO transmitter detection

Christian Lamparter <chunkeey@googlemail.com>
    drm/i915: Add no-lvds quirk for Fujitsu Esprimo Q900

Rafał Bilski <rafalbilski@interia.pl>
    cpufreq / Longhaul: Disable driver by default

Stefan Bader <stefan.bader@canonical.com>
    r8169: fix 8168evl frame padding.

Theodore Ts'o <tytso@mit.edu>
    ext4: add check for inodes_count overflow in new resize ioctl

Hans Schillstrom <hans@schillstrom.com>
    ipvs: ip_vs_sip_fill_param() BUG: bad check of return value

Sarah Sharp <sarah.a.sharp@linux.intel.com>
    xhci: Don't warn on empty ring for suspended devices.

Peter Zijlstra <a.p.zijlstra@chello.nl>
    perf/x86/intel/lbr: Demand proper privileges for PERF_SAMPLE_BRANCH_KERNEL

Peter Zijlstra <a.p.zijlstra@chello.nl>
    perf/x86/intel/lbr: Fix LBR filter

Benjamin Herrenschmidt <benh@kernel.crashing.org>
    net/eth/ibmveth: Fixup retrieval of MAC address

David Jeffery <djeffery@redhat.com>
    autofs - remove autofs dentry mount check

Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
    powerpc: fix numa distance for form0 device tree

Anton Blanchard <anton@samba.org>
    powerpc: Emulate non privileged DSCR read and write


-------------

Diffstat:

 Makefile                                   |  4 +-
 arch/powerpc/include/asm/ppc-opcode.h      |  4 ++
 arch/powerpc/kernel/traps.c                | 10 ++++-
 arch/powerpc/mm/numa.c                     |  2 +-
 arch/x86/kernel/cpu/perf_event_intel_lbr.c | 27 +++++++++---
 arch/x86/mm/init.c                         |  5 +++
 drivers/cpufreq/longhaul.c                 | 10 ++++-
 drivers/gpu/drm/i915/intel_dvo.c           | 13 +++++-
 drivers/gpu/drm/i915/intel_lvds.c          |  8 ++++
 drivers/gpu/drm/radeon/atom.c              |  6 +--
 drivers/gpu/drm/radeon/evergreen.c         | 67 ++++++++++++++++++++++++++++--
 drivers/gpu/drm/radeon/evergreen_reg.h     |  2 +
 drivers/gpu/drm/radeon/ni.c                |  8 +++-
 drivers/gpu/drm/radeon/nid.h               |  4 ++
 drivers/gpu/drm/radeon/radeon_atombios.c   | 21 ++++++----
 drivers/gpu/drm/radeon/radeon_pm.c         |  6 ++-
 drivers/gpu/drm/radeon/si.c                |  1 +
 drivers/gpu/drm/radeon/sid.h               |  2 +
 drivers/net/ethernet/ibm/ibmveth.c         | 23 +++++-----
 drivers/net/ethernet/realtek/r8169.c       |  9 ++++
 drivers/usb/host/xhci-ring.c               | 23 ++++++----
 fs/autofs4/expire.c                        |  9 ----
 fs/ext4/resize.c                           |  4 ++
 include/drm/drm_pciids.h                   |  5 +++
 kernel/audit_tree.c                        |  2 +-
 kernel/trace/trace.c                       | 62 ++++++++++++---------------
 kernel/trace/trace_selftest.c              |  9 ++--
 net/netfilter/ipvs/ip_vs_pe_sip.c          |  6 +--
 28 files changed, 248 insertions(+), 104 deletions(-)


