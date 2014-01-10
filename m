Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555AbaAJSso (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 13:48:44 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:45920 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035AbaAJSsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 13:48:41 -0500
From: Davidlohr Bueso <davidlohr@hp.com>
To: akpm@linux-foundation.org, manfred@colorfullife.com
Cc: riel@redhat.com, aswin@hp.com, davidlohr@hp.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH -next 0/7] ipc: some misc updates & optimizations
Date: Fri, 10 Jan 2014 10:48:20 -0800
Message-Id: <1389379707-20298-1-git-send-email-davidlohr@hp.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A few updates to the ipc code, mostly some very needed cleanups (yes, we still
have loads more to do, but it's a start). Nothing particularly interesting,
except perhaps for the last two patches, which include a locking optimization
and barrier documentation for message queues. Absolutely no functional changes.

Applies on top of linux-next +  Manfred's 'whitespace cleanup' patch. Tested
with LTP.

Thanks!

Davidlohr Bueso (7):
  ipc: standardize code comments
  ipc: remove braces for single statements
  ipc: remove useless return statement
  ipc: simplify sysvipc_proc_open return
  ipc: delete seq_max field in struct ipc_ids
  ipc: share ids rwsem when possible in ipcget_public
  ipc,msg: document barriers

 include/linux/ipc_namespace.h |   1 -
 ipc/compat.c                  |  18 +--
 ipc/mqueue.c                  |   6 +-
 ipc/msg.c                     |  19 ++-
 ipc/sem.c                     |  32 ++---
 ipc/shm.c                     |   1 -
 ipc/util.c                    | 328 ++++++++++++++++++++----------------------
 ipc/util.h                    |   1 +
 8 files changed, 198 insertions(+), 208 deletions(-)

-- 
1.8.1.4

