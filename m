Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524AbaAQKYk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 05:24:40 -0500
Received: from mga02.intel.com ([134.134.136.20]:14771 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751331AbaAQKYh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 05:24:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,670,1384329600"; 
   d="scan'208";a="460430576"
Date: Fri, 17 Jan 2014 18:24:28 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [ipc] 5769cf63: LTP semget02 TFAILs
Message-ID: <20140117102428.GC8751@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Davidlohr,

We noticed LTP test failures

        ltp.msgget02.1.TFAIL
        ltp.semget02.2.TFAIL
        ltp.semget02.3.TFAIL

and the first bad commit is

commit 5769cf6355d87f63906b3e51887eff7017c39217
Author:     Davidlohr Bueso <davidlohr@hp.com>
AuthorDate: Wed Jan 15 16:56:01 2014 +1100
Commit:     Stephen Rothwell <sfr@canb.auug.org.au>
CommitDate: Wed Jan 15 16:56:01 2014 +1100

    ipc: share ids rwsem when possible in ipcget_public
    
    ...  and rewrite the function.  For scenarios where the key is found and
    we end up just doing different routinary checks, we can downgrade the
    ids->rwsem and share it among concurrent readers.  These checks include
    the following, which are all safe to share the lock:
    
    ops->more_checks() >>  sem_more_checks(), shm_more_checks()
    ipc_check_perms()  >>  ipcperms(),ops->associate() >> [lsm]_[ipctype]_associate()
    
    Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
    Cc: Aswin Chandramouleeswaran <aswin@hp.com>
    Cc: Rik van Riel <riel@redhat.com>
    Cc: Manfred Spraul <manfred@colorfullife.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

 ipc/util.c | 60 +++++++++++++++++++++++++++++++++---------------------------
 1 file changed, 33 insertions(+), 27 deletions(-)

Thanks,
Fengguang
