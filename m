Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284AbaIPUwI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 16:52:08 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:47267 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754958AbaIPUv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 16:51:59 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH 00/22] treewide: Replace strnicmp with strncasecmp
Date: Tue, 16 Sep 2014 22:51:14 +0200
Message-Id: <1410900696-6481-1-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel used to contain two functions for length-delimited,
case-insensitive string comparison, strnicmp with correct semantics
and a slightly buggy strncasecmp. The latter is the POSIX name, so
strnicmp was renamed to strncasecmp, and strnicmp made into a wrapper
for the new strncasecmp to avoid breaking existing users.

To allow the compat wrapper strnicmp to be removed at some point in
the future, and to avoid the extra indirection cost, do
s/strnicmp/strncasecmp/g.

Sorry for the unimaginative and identical commit messages.

Rasmus Villemoes (22):
  ARM: Replace strnicmp with strncasecmp
  block: Replace strnicmp with strncasecmp
  netfilter: Replace strnicmp with strncasecmp
  video: fbdev: Replace strnicmp with strncasecmp
  cifs: Replace strnicmp with strncasecmp
  ocfs2: Replace strnicmp with strncasecmp
  isofs: Replace strnicmp with strncasecmp
  ALSA: hda - Replace strnicmp with strncasecmp
  batman-adv: Replace strnicmp with strncasecmp
  ACPI / battery: Replace strnicmp with strncasecmp
  cpufreq: Replace strnicmp with strncasecmp
  cpuidle: Replace strnicmp with strncasecmp
  scsi: Replace strnicmp with strncasecmp
  ib_srpt: Replace strnicmp with strncasecmp
  Input: edt-ft5x06 - Replace strnicmp with strncasecmp
  altera-stapl: Replace strnicmp with strncasecmp
  thinkpad_acpi: Replace strnicmp with strncasecmp
  PNP: Replace strnicmp with strncasecmp
  s390/cio: Replace strnicmp with strncasecmp
  staging: r8188eu: Replace strnicmp with strncasecmp
  Thermal: Replace strnicmp with strncasecmp
  kdb: Replace strnicmp with strncasecmp

 arch/arm/mach-pxa/lpd270.c                     | 12 ++---
 block/partitions/mac.c                         |  8 ++--
 drivers/acpi/battery.c                         |  2 +-
 drivers/cpufreq/cpufreq.c                      |  6 +--
 drivers/cpuidle/governor.c                     |  2 +-
 drivers/infiniband/ulp/srpt/ib_srpt.c          |  2 +-
 drivers/input/touchscreen/edt-ft5x06.c         |  2 +-
 drivers/misc/altera-stapl/altera.c             |  4 +-
 drivers/platform/x86/thinkpad_acpi.c           |  4 +-
 drivers/pnp/interface.c                        | 24 +++++-----
 drivers/s390/cio/chp.c                         |  4 +-
 drivers/scsi/ips.c                             |  2 +-
 drivers/scsi/scsi_debug.c                      |  2 +-
 drivers/staging/rtl8188eu/os_dep/rtw_android.c |  2 +-
 drivers/thermal/thermal_core.c                 |  8 ++--
 drivers/video/fbdev/pvr2fb.c                   |  2 +-
 drivers/video/fbdev/s3c2410fb.c                |  8 ++--
 drivers/video/fbdev/sis/sis_main.c             | 66 +++++++++++++-------------
 drivers/video/fbdev/sm501fb.c                  |  4 +-
 fs/cifs/cifs_dfs_ref.c                         |  6 +--
 fs/cifs/connect.c                              |  4 +-
 fs/isofs/inode.c                               |  2 +-
 fs/ocfs2/cluster/heartbeat.c                   |  2 +-
 fs/ocfs2/cluster/masklog.c                     |  6 +--
 kernel/debug/kdb/kdb_bp.c                      |  6 +--
 net/batman-adv/gateway_common.c                |  8 ++--
 net/netfilter/ipvs/ip_vs_ftp.c                 |  6 +--
 net/netfilter/nf_conntrack_ftp.c               |  4 +-
 net/netfilter/nf_conntrack_sip.c               | 22 ++++-----
 net/netfilter/nf_log.c                         |  2 +-
 net/netfilter/nf_nat_sip.c                     |  2 +-
 sound/pci/hda/hda_sysfs.c                      |  2 +-
 32 files changed, 118 insertions(+), 118 deletions(-)

-- 
2.0.4

