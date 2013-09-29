Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755073Ab3I2T07 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 15:26:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59091 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754960Ab3I2T0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 15:26:55 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [ 00/17] 3.0.98-stable review
Date: Sun, 29 Sep 2013 12:26:39 -0700
Message-Id: <20130929190757.138351117@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.0.98 release.
There are 17 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Tue Oct  1 19:07:47 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.98-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.0.98-rc1

Daniel Santos <daniel.santos@pobox.com>
    kernel-doc: bugfix - multi-line macros

Ben Hutchings <bhutchings@solarflare.com>
    sfc: Fix efx_rx_buf_offset() for recycled pages

Andi Kleen <ak@linux.intel.com>
    perf tools: Handle JITed code in shared memory

Lino Sanfilippo <LinoSanfilippo@gmx.de>
    fanotify: dont merge permission events

Peter Zijlstra <a.p.zijlstra@chello.nl>
    perf: Fix perf_cgroup_switch for sw-events

Peter Zijlstra <a.p.zijlstra@chello.nl>
    perf: Clarify perf_cpu_context::active_pmu usage by renaming it to ::unique_pmu

Li Zefan <lizefan@huawei.com>
    cgroup: fail if monitored file and event_control are in different cgroup

Sasha Levin <levinsasha928@gmail.com>
    SCSI: iscsi: don't hang in endless loop if no targets present

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: fix handling of variable sized arrays for router objects

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: fix resume on some rs4xx boards (v2)

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: update line buffer allocation for dce4.1/5

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: fix LCD record parsing

Kees Cook <keescook@chromium.org>
    HID: zeroplus: validate output report details

Kees Cook <keescook@chromium.org>
    HID: provide a helper for validating hid reports

Stanislaw Gruszka <sgruszka@redhat.com>
    rt2800: fix wrong TX power compensation

Fabio Porcedda <fabio.porcedda@gmail.com>
    net: usb: cdc_ether: Use wwan interface for Telit modules

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "sctp: fix call to SCTP_CMD_PROCESS_SACK in sctp_cmd_interpreter()"


-------------

Diffstat:

 Makefile                                 |  4 +--
 drivers/gpu/drm/radeon/evergreen.c       | 25 +++++++++++---
 drivers/gpu/drm/radeon/evergreend.h      |  4 +++
 drivers/gpu/drm/radeon/radeon_atombios.c | 13 ++++---
 drivers/gpu/drm/radeon/rs400.c           |  9 +++--
 drivers/hid/hid-core.c                   | 58 ++++++++++++++++++++++++++++++++
 drivers/hid/hid-zpff.c                   | 18 +++-------
 drivers/net/sfc/rx.c                     |  3 +-
 drivers/net/usb/cdc_ether.c              |  5 +++
 drivers/net/wireless/rt2x00/rt2800lib.c  |  7 ++++
 drivers/scsi/scsi_transport_iscsi.c      |  2 +-
 fs/notify/fanotify/fanotify.c            |  6 ++++
 include/linux/hid.h                      |  4 +++
 include/linux/perf_event.h               |  2 +-
 kernel/cgroup.c                          | 11 ++++++
 kernel/events/core.c                     | 21 +++++++-----
 net/sctp/sm_sideeffect.c                 |  3 +-
 scripts/kernel-doc                       |  3 ++
 tools/perf/util/map.c                    |  1 +
 19 files changed, 159 insertions(+), 40 deletions(-)


