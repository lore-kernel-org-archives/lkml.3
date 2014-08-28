Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629AbaH1Syk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 14:54:40 -0400
Received: from linuxhacker.ru ([217.76.32.60]:33812 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753344AbaH1Syh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 14:54:37 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Oleg Drokin <green@linuxhacker.ru>
Subject: [PATCH 0/4] Remove unused lustre files
Date: Thu, 28 Aug 2014 14:54:19 -0400
Message-Id: <1409252063-23070-1-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This batch of patches removes some lustre files that are not being built
and are overall unneeded in the client only code.
These include EA from disk swabbing code, various network request policies
for server-site traffic prioritization, server-side llog code,
lustre binary heap implementation.

Please consider for inclusion.

Oleg Drokin (4):
  staging/lustre/obdclass: remove unused file md_attrs.c
  staging/lustre/obdclass: remove unused file llog_lvfs.c
  staging/lustre/obdclass: remove unused file linkea.c
  staging/lustre: remove unused request policies.

 .../lustre/lustre/include/lustre/lustre_idl.h      |   6 -
 .../staging/lustre/lustre/include/lustre_linkea.h  |  57 --
 drivers/staging/lustre/lustre/include/lustre_log.h |   3 -
 drivers/staging/lustre/lustre/include/lustre_net.h | 276 -------
 drivers/staging/lustre/lustre/include/md_object.h  |   4 -
 drivers/staging/lustre/lustre/libcfs/heap.c        | 475 ------------
 drivers/staging/lustre/lustre/obdclass/linkea.c    | 194 -----
 drivers/staging/lustre/lustre/obdclass/llog_lvfs.c | 847 ---------------------
 drivers/staging/lustre/lustre/obdclass/md_attrs.c  | 199 -----
 drivers/staging/lustre/lustre/ptlrpc/nrs_crr.c     |  40 -
 10 files changed, 2101 deletions(-)
 delete mode 100644 drivers/staging/lustre/lustre/include/lustre_linkea.h
 delete mode 100644 drivers/staging/lustre/lustre/libcfs/heap.c
 delete mode 100644 drivers/staging/lustre/lustre/obdclass/linkea.c
 delete mode 100644 drivers/staging/lustre/lustre/obdclass/llog_lvfs.c
 delete mode 100644 drivers/staging/lustre/lustre/obdclass/md_attrs.c
 delete mode 100644 drivers/staging/lustre/lustre/ptlrpc/nrs_crr.c

-- 
1.9.3

