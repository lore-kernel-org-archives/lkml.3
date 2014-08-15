Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751478AbaHOQsh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 12:48:37 -0400
Received: from linuxhacker.ru ([217.76.32.60]:41214 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750954AbaHOQse (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 12:48:34 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Oleg Drokin <green@linuxhacker.ru>
Subject: [PATCH 00/10] Catchup lustre fixes
Date: Fri, 15 Aug 2014 12:48:05 -0400
Message-Id: <1408121295-29115-1-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In this batch there are eight recent bugfixes to lustre client,
also adds Lustre MAINTAINERS entry and a bit of documention
in Documentation.filesystems with some basic info.

Patch #4 generates checkpatch warning about to long split message,
but it is genuinely long and won't fit into 80 columns considering indenting
and such.

Please consider.

Fan Yong (1):
  staging/lustre/ldlm: drop redundant ibits lock interoperability check

Frank Zago (1):
  staging/lustre/llite: optimize ll_fid2path()

John L. Hammond (3):
  staging/lustre/mdc: cleanup intent if mdc_finish_enqueue() fails
  staging/lustre/clio: reorder initialization in cl_req_alloc()
  staging/lustre/llite: hold inode mutex around ll_setattr_raw()

Nathaniel Clark (1):
  staging/lustre/llite: check for integer overflow in hsm user request

Oleg Drokin (3):
  staging/lustre/llite: Fix integer overflow in ll_fid2path
  lustre: Add MAINTAINERS entry
  lustre: Add some basic documentation

Paul Cassella (1):
  staging/lustre/llite: Make sure ft_flags is valid

 Documentation/filesystems/lustre.txt               | 87 ++++++++++++++++++++++
 MAINTAINERS                                        |  8 ++
 .../lustre/lustre/include/lustre/lustre_user.h     | 23 ++++--
 .../staging/lustre/lustre/include/obd_support.h    |  1 +
 drivers/staging/lustre/lustre/ldlm/ldlm_lock.c     | 50 ++-----------
 drivers/staging/lustre/lustre/ldlm/ldlm_request.c  | 15 +---
 drivers/staging/lustre/lustre/llite/dir.c          |  4 +-
 drivers/staging/lustre/lustre/llite/file.c         | 41 +++++-----
 .../staging/lustre/lustre/llite/llite_internal.h   |  6 +-
 drivers/staging/lustre/lustre/llite/llite_mmap.c   |  8 +-
 drivers/staging/lustre/lustre/llite/vvp_io.c       |  1 +
 drivers/staging/lustre/lustre/mdc/mdc_locks.c      |  5 ++
 drivers/staging/lustre/lustre/obdclass/cl_io.c     |  7 +-
 drivers/staging/lustre/lustre/ptlrpc/import.c      | 15 +++-
 14 files changed, 180 insertions(+), 91 deletions(-)
 create mode 100644 Documentation/filesystems/lustre.txt

-- 
1.9.3

