Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757652Ab3HMGfY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 02:35:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60856 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757609Ab3HMGfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 02:35:01 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [ 00/17] 3.4.58-stable review
Date: Mon, 12 Aug 2013 23:35:46 -0700
Message-Id: <20130813063501.728847844@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.3.825.g36032ce.dirty
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.4.58 release.
There are 17 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu Aug 15 06:34:52 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.58-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.4.58-rc1

Joshua Zhu <zhu.wen-jie@hp.com>
    perf tools: Add anonymous huge page recognition

NeilBrown <neilb@suse.de>
    vfs: d_obtain_alias() needs to use "/" as default name.

Arnd Bergmann <arnd@arndb.de>
    SCSI: nsp32: use mdelay instead of large udelay constants

Andrew Vagin <avagin@openvz.org>
    tracing: Fix fields of struct trace_iterator that are zeroed by mistake

Oleg Nesterov <oleg@redhat.com>
    debugfs: debugfs_remove_recursive() must not rely on list_empty(d_subdirs)

Julius Werner <jwerner@chromium.org>
    usb: core: don't try to reset_device() a port that got just disconnected

Chen Gang <gang.chen@asianux.com>
    cifs: extend the buffer length enought for sprintf() using

Piotr Sarna <p.sarna@partner.samsung.com>
    ext4: fix mount/remount error messages for incompatible mount options

Amit Shah <amit.shah@redhat.com>
    virtio: console: return -ENODEV on all read operations after unplug

Amit Shah <amit.shah@redhat.com>
    virtio: console: fix raising SIGIO after port unplug

Amit Shah <amit.shah@redhat.com>
    virtio: console: clean up port data immediately at time of unplug

Amit Shah <amit.shah@redhat.com>
    virtio: console: fix race in port_fops_open() and port unplug

Amit Shah <amit.shah@redhat.com>
    virtio: console: fix race with port unplug and open/close

Curt Brune <curt@cumulusnetworks.com>
    hwmon: (adt7470) Fix incorrect return code check

Theodore Ts'o <tytso@mit.edu>
    ext4: make sure group number is bumped after a inode allocation race

Sumit.Saxena@lsi.com <Sumit.Saxena@lsi.com>
    SCSI: megaraid_sas: megaraid_sas driver init fails in kdump kernel

Martin K. Petersen <martin.petersen@oracle.com>
    SCSI: Don't attempt to send extended INQUIRY command if skip_vpd_pages is set


-------------

Diffstat:

 Makefile                                  |  4 +-
 drivers/char/virtio_console.c             | 47 ++++++++++++---------
 drivers/hwmon/adt7470.c                   |  2 +-
 drivers/scsi/megaraid/megaraid_sas_base.c | 20 ++++++---
 drivers/scsi/nsp32.c                      |  2 +-
 drivers/scsi/scsi.c                       |  3 ++
 drivers/usb/core/hub.c                    |  5 ++-
 fs/cifs/cifsencrypt.c                     |  2 +-
 fs/cifs/cifsglob.h                        |  1 +
 fs/cifs/connect.c                         |  7 ++--
 fs/cifs/sess.c                            |  6 +--
 fs/dcache.c                               |  2 +-
 fs/debugfs/inode.c                        | 69 ++++++++++---------------------
 fs/ext4/ialloc.c                          | 10 ++---
 fs/ext4/super.c                           | 17 +++++++-
 include/linux/ftrace_event.h              |  4 +-
 kernel/trace/trace.c                      |  1 +
 tools/perf/util/map.c                     |  3 +-
 18 files changed, 112 insertions(+), 93 deletions(-)


