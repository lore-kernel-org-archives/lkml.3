Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130AbaHOQ4M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 12:56:12 -0400
Received: from linuxhacker.ru ([217.76.32.60]:41327 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751364AbaHOQ4J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 12:56:09 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Oleg Drokin <green@linuxhacker.ru>
Subject: [PATCH 0/2] Getting rid of (some of) lustre typedefs
Date: Fri, 15 Aug 2014 12:55:54 -0400
Message-Id: <1408121756-29186-1-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is beginning of removal of Lustre typedefs that don't make
sense and only obscure things for innocent viewers.

The typedefs are replaced with uXX and sXX which is what I think
what is desired, except the definitions in lustre_idl.h
that uses __uXX and __sXX (necessary because some of our userspace
tools include it), hopefully that's still ok, though?

More of this sort of patches will follow after we make sure
of the correctness of the end result.

Oleg Drokin (2):
  staging/lustre: get rid of seqno_t and mdsno_t typedefs
  staging/lustre: get rid of obd_* typedefs

 drivers/staging/lustre/lustre/fid/fid_request.c    |   6 +-
 drivers/staging/lustre/lustre/fld/fld_cache.c      |  16 +--
 drivers/staging/lustre/lustre/fld/fld_internal.h   |   2 +-
 drivers/staging/lustre/lustre/fld/fld_request.c    |   9 +-
 drivers/staging/lustre/lustre/include/cl_object.h  |   4 +-
 drivers/staging/lustre/lustre/include/lclient.h    |   2 +-
 .../lustre/lustre/include/linux/obd_class.h        |   6 +-
 drivers/staging/lustre/lustre/include/lu_object.h  |   6 +-
 .../lustre/lustre/include/lustre/lustre_idl.h      | 124 +++++++++------------
 drivers/staging/lustre/lustre/include/lustre_fid.h |   2 +-
 drivers/staging/lustre/lustre/include/lustre_fld.h |   5 +-
 drivers/staging/lustre/lustre/include/lustre_lib.h |   8 +-
 .../staging/lustre/lustre/include/lustre_lite.h    |   2 +-
 drivers/staging/lustre/lustre/include/md_object.h  |   2 +-
 drivers/staging/lustre/lustre/include/obd.h        |  50 ++++-----
 drivers/staging/lustre/lustre/include/obd_cksum.h  |   6 +-
 drivers/staging/lustre/lustre/include/obd_class.h  |  24 ++--
 drivers/staging/lustre/lustre/include/obd_ost.h    |   2 +-
 drivers/staging/lustre/lustre/lclient/lcommon_cl.c |   4 +-
 drivers/staging/lustre/lustre/llite/file.c         |   7 +-
 .../staging/lustre/lustre/llite/llite_internal.h   |   4 +-
 drivers/staging/lustre/lustre/llite/llite_lib.c    |   2 +-
 drivers/staging/lustre/lustre/llite/llite_rmtacl.c |   2 +-
 drivers/staging/lustre/lustre/llite/lloop.c        |   2 +-
 drivers/staging/lustre/lustre/lmv/lmv_fld.c        |   2 +-
 drivers/staging/lustre/lustre/lmv/lmv_internal.h   |  10 +-
 drivers/staging/lustre/lustre/lmv/lmv_obd.c        |  16 ++-
 .../staging/lustre/lustre/lov/lov_cl_internal.h    |   4 +-
 drivers/staging/lustre/lustre/lov/lov_ea.c         |   8 +-
 drivers/staging/lustre/lustre/lov/lov_internal.h   |  28 ++---
 drivers/staging/lustre/lustre/lov/lov_io.c         |   8 +-
 drivers/staging/lustre/lustre/lov/lov_lock.c       |  24 ++--
 drivers/staging/lustre/lustre/lov/lov_merge.c      |  14 +--
 drivers/staging/lustre/lustre/lov/lov_obd.c        |  44 ++++----
 drivers/staging/lustre/lustre/lov/lov_offset.c     |  29 +++--
 drivers/staging/lustre/lustre/lov/lov_pack.c       |   4 +-
 drivers/staging/lustre/lustre/lov/lov_page.c       |   2 +-
 drivers/staging/lustre/lustre/lov/lov_request.c    |  18 +--
 drivers/staging/lustre/lustre/lov/lovsub_dev.c     |   2 +-
 drivers/staging/lustre/lustre/mdc/mdc_internal.h   |   2 +-
 drivers/staging/lustre/lustre/mdc/mdc_locks.c      |   2 +-
 drivers/staging/lustre/lustre/mdc/mdc_request.c    |  14 +--
 drivers/staging/lustre/lustre/mgc/mgc_request.c    |   4 +-
 drivers/staging/lustre/lustre/obdclass/cl_io.c     |   2 +-
 .../lustre/lustre/obdclass/linux/linux-obdo.c      |   8 +-
 .../staging/lustre/lustre/obdclass/local_storage.c |   2 +-
 drivers/staging/lustre/lustre/obdclass/obdo.c      |  12 +-
 drivers/staging/lustre/lustre/obdecho/echo.c       |  21 ++--
 .../staging/lustre/lustre/obdecho/echo_client.c    |  58 +++++-----
 drivers/staging/lustre/lustre/osc/lproc_osc.c      |   2 +-
 drivers/staging/lustre/lustre/osc/osc_cache.c      |   2 +-
 .../staging/lustre/lustre/osc/osc_cl_internal.h    |   2 +-
 drivers/staging/lustre/lustre/osc/osc_internal.h   |   6 +-
 drivers/staging/lustre/lustre/osc/osc_io.c         |   2 +-
 drivers/staging/lustre/lustre/osc/osc_quota.c      |   8 +-
 drivers/staging/lustre/lustre/osc/osc_request.c    |  46 ++++----
 drivers/staging/lustre/lustre/ptlrpc/layout.c      |   4 +-
 .../staging/lustre/lustre/ptlrpc/pack_generic.c    |   6 +-
 58 files changed, 344 insertions(+), 369 deletions(-)

-- 
1.9.3

