Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751738AbaBIHwV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 02:52:21 -0500
Received: from linuxhacker.ru ([217.76.32.60]:37337 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751435AbaBIHwU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 02:52:20 -0500
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Oleg Drokin <green@linuxhacker.ru>
Subject: [PATCH 0/5] Lustre fixes
Date: Sun,  9 Feb 2014 02:51:44 -0500
Message-Id: <1391932309-6009-1-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a set of patches that eliminates rest of crashes and
most leaks hit during standard lustre regression testing for me.

This serie + O_LOV_DELAY_CREATE patch from Andreas (that was
submitted separately and needs separate approval:
http://www.spinics.net/lists/linux-fsdevel/msg72386.html )
makes most of the sanity testing to also pass.


Andrew Perepechko (1):
  lustre/xattr: separate ACL and XATTR caches

Bobi Jam (1):
  lustre/lov: avoid subobj's coh_parent race

John L. Hammond (1):
  lustre: don't leak llog handle in llog_cat_process_cb()

Swapnil Pimpale (1):
  lustre: Unsafe error handling around ll_splice_alias

yang sheng (1):
  lustre: instantiate negative dentry

 .../lustre/lustre/include/lustre/lustre_idl.h      |   1 -
 drivers/staging/lustre/lustre/ldlm/ldlm_lock.c     |   2 -
 .../staging/lustre/lustre/llite/llite_internal.h   |   7 --
 drivers/staging/lustre/lustre/llite/namei.c        |  15 ++-
 drivers/staging/lustre/lustre/llite/statahead.c    |   9 +-
 drivers/staging/lustre/lustre/llite/xattr.c        |  29 +++--
 drivers/staging/lustre/lustre/llite/xattr_cache.c  | 117 ++++-----------------
 drivers/staging/lustre/lustre/lov/lov_object.c     |  10 +-
 drivers/staging/lustre/lustre/lov/lovsub_dev.c     |   4 +
 drivers/staging/lustre/lustre/mdc/mdc_internal.h   |   2 +-
 drivers/staging/lustre/lustre/mdc/mdc_locks.c      |   9 +-
 drivers/staging/lustre/lustre/mdc/mdc_reint.c      |   2 +-
 drivers/staging/lustre/lustre/mdc/mdc_request.c    |  30 +++++-
 drivers/staging/lustre/lustre/obdclass/llog_cat.c  |   6 +-
 drivers/staging/lustre/lustre/ptlrpc/layout.c      |   3 +-
 15 files changed, 100 insertions(+), 146 deletions(-)

-- 
1.8.5.3

