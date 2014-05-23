Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752873AbaEWMwc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 08:52:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1777 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752819AbaEWMwZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 08:52:25 -0400
Subject: [PATCH 0/4] AFS: Fixes and cleanups
From: David Howells <dhowells@redhat.com>
To: torvalds@linux-foundation.org
Cc: dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Fri, 23 May 2014 13:52:00 +0100
Message-ID: <20140523125200.25385.8586.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Here are some patches to the AFS filesystem:

 (1) Fix problems in the clean-up parts of the cache manager service handler.

 (2) Split afs_end_call() introduced in (1) and replace some identical code
     elsewhere with a call to the first half of the split function.

 (3) Fix an error introduced in the workqueue PREPARE_WORK() elimination
     commits.

 (4) Clean up argument passing to functions called from the workqueue as
     there's now an insulating layer between them and the workqueue.  This is
     possible from (3).

They can be found here also:

	http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=afs

ending at the afs-fixes-20140523 tag.

David
---
David Howells (2):
      AFS: Fix cache manager service handlers
      AFS: Pass an afs_call* to call->async_workfn() instead of a work_struct*

Nathaniel Wesley Filardo (2):
      AFS: Part of afs_end_call() is identical to code elsewhere, so split it
      AFS: Fix kafs module unloading


 fs/afs/cmservice.c |   19 +++++++++++
 fs/afs/internal.h  |    2 +
 fs/afs/rxrpc.c     |   86 ++++++++++++++++++++++++++--------------------------
 3 files changed, 63 insertions(+), 44 deletions(-)

