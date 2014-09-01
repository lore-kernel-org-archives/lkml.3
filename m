Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543AbaIAG0e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 02:26:34 -0400
Received: from mail.kapsi.fi ([217.30.184.167]:34195 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752174AbaIAG0a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 02:26:30 -0400
From: Mikko Rapeli <mikko.rapeli@iki.fi>
To: linux-kernel@vger.kernel.org
Cc: linux-kbuild@vger.kernel.org, mikko.rapeli@iki.fi
Subject: [RFC PATCH v2 00/27] Compile test and fixes for exported header files
Date: Mon,  1 Sep 2014 09:25:51 +0300
Message-Id: <1409552778-2537-1-git-send-email-mikko.rapeli@iki.fi>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1408660449-4011-1-git-send-email-mikko.rapeli@iki.fi>
References: <1408660449-4011-1-git-send-email-mikko.rapeli@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 217.30.184.161
X-SA-Exim-Mail-From: mcfrisk@kapsi.fi
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series introduces a simple compile test for exported header files
and fixes a few example findings from the test.

It's a bit of a pain to see headers in userspace with unknown kernel
definitions, incomplete header file dependencies and other compile failures.

The test was simple until I found out that some kernel headers depend on
gcc and libc headers.  Now there's a hack to copy libc headers and hard coded
path to gcc headers for the tests but hopefully in further iterations I can
make this more portable. Maybe there's a chance that a test like this
could be added into 'headers_chech_all' or even 'headers_install'.
Further uses for compiling headers might be ABI checkers but I've not
explored this any further.

The fixed issues are just a few samples I've been able to fix so far.
I'm hoping to get some feedback if fixes or the tests are doing something
completely wrong. Some problems like with via_drm.h seem several years old but
have not been fixed thus far:

http://marc.info/?l=linux-kbuild&m=122919682002000&w=2

Mikko Rapeli (27):
  Compile test script for exported header files
  scripts/headers.sh: add verbose option to make calls if defined
  Makefile: propagate verbose options
  headers_install.sh: enhance error handling
  drm.h: include stdlib.h in userspace
  drm_mode.h: include stdint.h and linux/types.h in userspace
  exynos_drm.h: include stdint.h in userspace
  nouveau_drm.h: include stdint.h in userspace
  radeon_drm.h: include stdint.h in userspace
  vmwgfx_drm.h: include drm/drm.h instead of drm.h in userspace
  dm-log-userspace.h: include stdint.h in userspace
  hsi_char.h: include stdint.h in userspace
  ebtables.h: include stdint.h in userspace
  cld.h: include stdint.h in userspace
  rds.h: include stdint.h in userspace
  sctp.h: include stdint.h in userspace
  scsi_bsg_fc.h: include stdint.h in userspace
  scsi_netlink.h: include stdint.h in userspace
  scsi_netlink_fc.h: include stdint.h in userspace
  hdspm.h: include stdint.h in userspace
  gntalloc.h: include stdint.h in userspace
  gntdev.h: include stdint.h in userspace
  r128_drm.h: include drm/drm.h
  via_drm.h: include linux/types.h instead of non-existing
    via_drmclient.h
  via_drm.h: hide struct via_file_private in userspace
  savage_drm.h: include <drm/drm.h>
  sis_drm.h: hide sis_file_private in userspace

 Makefile                                       |  8 +--
 include/uapi/drm/drm.h                         |  4 ++
 include/uapi/drm/drm_mode.h                    |  5 ++
 include/uapi/drm/exynos_drm.h                  |  5 ++
 include/uapi/drm/nouveau_drm.h                 |  6 ++
 include/uapi/drm/r128_drm.h                    |  2 +
 include/uapi/drm/radeon_drm.h                  |  5 ++
 include/uapi/drm/savage_drm.h                  |  2 +
 include/uapi/drm/sis_drm.h                     |  2 +
 include/uapi/drm/via_drm.h                     |  6 +-
 include/uapi/drm/vmwgfx_drm.h                  |  2 +-
 include/uapi/linux/dm-log-userspace.h          |  5 ++
 include/uapi/linux/hsi/hsi_char.h              |  7 ++-
 include/uapi/linux/netfilter_bridge/ebtables.h |  5 ++
 include/uapi/linux/nfsd/cld.h                  |  6 ++
 include/uapi/linux/rds.h                       |  4 ++
 include/uapi/linux/sctp.h                      |  4 ++
 include/uapi/scsi/scsi_bsg_fc.h                |  6 ++
 include/uapi/scsi/scsi_netlink.h               |  6 +-
 include/uapi/scsi/scsi_netlink_fc.h            |  5 ++
 include/uapi/sound/hdspm.h                     |  6 ++
 include/uapi/xen/gntalloc.h                    |  6 ++
 include/uapi/xen/gntdev.h                      |  6 ++
 scripts/headers.sh                             |  2 +-
 scripts/headers_compile_test.sh                | 84 ++++++++++++++++++++++++++
 scripts/headers_install.sh                     | 15 +++--
 26 files changed, 198 insertions(+), 16 deletions(-)
 create mode 100755 scripts/headers_compile_test.sh

-- 
2.1.0

