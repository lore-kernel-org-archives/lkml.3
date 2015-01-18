Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751796AbbAROII (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 09:08:08 -0500
Received: from srv-hp10.netsons.net ([94.141.22.72]:47268 "EHLO
	srv-hp10.netsons.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750953AbbAROIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 09:08:05 -0500
From: Luca Ceresoli <luca@lucaceresoli.net>
To: Oleg Drokin <oleg.drokin@intel.com>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Luca Ceresoli <luca@lucaceresoli.net>, Peng Tao <bergwolf@gmail.com>,
        Jinshan Xiong <jinshan.xiong@intel.com>,
        Srikrishan Malik <srikrishanmalik@gmail.com>, HPDD-discuss@ml01.01.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/6] staging: lustre: declare internal symbols as static
Date: Sun, 18 Jan 2015 15:06:46 +0100
Message-Id: <1421590012-7082-1-git-send-email-luca@lucaceresoli.net>
X-Mailer: git-send-email 1.9.1
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - srv-hp10.netsons.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - lucaceresoli.net
X-Get-Message-Sender-Via: srv-hp10.netsons.net: authenticated_id: luca+lucaceresoli.net/only user confirmed/virtual account not confirmed
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this small patch series fixes dozens of sparse warnings like:
  warning: symbol '...' was not declared. Should it be static?

I previously sent it as one larger patch [1], but Greg couldn't apply it to his
staging-next because other patches had fixed some of the same issues in the
meantime. So, to reduce the probability of further conflicts, I'm resending
that patch as a set of smaller ones.

FWIW, this patchset applies on current master (v3.19-rc5), next (next-20150116),
staging-next (v3.19-rc2-138-gef4c653) and staging-testing
(v3.19-rc2-369-g06d30f0).

Luca

[1] http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/2015-January/063751.html

Luca Ceresoli (6):
  staging: lustre: mdc: declare internal symbols as static
  staging: lustre: lmv: declare internal symbols as static
  staging: lustre: libcfs: declare internal symbols as static
  staging: lustre: llite: declare internal symbols as static
  staging: lustre: fld: declare internal symbols as static
  staging: lustre: lnet: declare internal symbols as static

 drivers/staging/lustre/lnet/lnet/module.c          |  2 +-
 drivers/staging/lustre/lnet/selftest/conctl.c      |  2 +-
 drivers/staging/lustre/lnet/selftest/conrpc.c      |  2 +-
 drivers/staging/lustre/lnet/selftest/console.c     |  2 +-
 drivers/staging/lustre/lustre/fld/fld_cache.c      |  6 +-
 drivers/staging/lustre/lustre/fld/lproc_fld.c      |  2 +-
 drivers/staging/lustre/lustre/libcfs/debug.c       |  8 +-
 .../lustre/lustre/libcfs/linux/linux-curproc.c     |  2 +-
 .../lustre/lustre/libcfs/linux/linux-proc.c        | 24 +++---
 .../lustre/lustre/libcfs/linux/linux-tcpip.c       |  2 +-
 drivers/staging/lustre/lustre/libcfs/tracefile.c   |  2 +-
 drivers/staging/lustre/lustre/llite/dir.c          |  4 +-
 drivers/staging/lustre/lustre/llite/file.c         |  3 +-
 drivers/staging/lustre/lustre/lmv/lmv_obd.c        | 87 +++++++++++-----------
 drivers/staging/lustre/lustre/lmv/lproc_lmv.c      |  4 +-
 drivers/staging/lustre/lustre/mdc/mdc_request.c    | 54 +++++++-------
 16 files changed, 107 insertions(+), 99 deletions(-)

-- 
1.9.1

