Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752865AbaIXL1I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 07:27:08 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:60004 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281AbaIXL1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 07:27:05 -0400
From: Jeff Layton <jeff.layton@primarydata.com>
X-Google-Original-From: Jeff Layton <jlayton@primarydata.com>
Date: Wed, 24 Sep 2014 07:27:01 -0400
To: NeilBrown <neilb@suse.de>
Cc: Trond Myklebust <trond.myklebust@primarydata.com>,
        linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Ingo Molnar <mingo@redhat.com>,
        linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Jeff Layton <jeff.layton@primarydata.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 0/5]  Remove possible deadlocks in nfs_release_page() -
 V3
Message-ID: <20140924072701.49a70346@tlielax.poochiereds.net>
In-Reply-To: <20140924012422.4838.29188.stgit@notabene.brown>
References: <20140924012422.4838.29188.stgit@notabene.brown>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Sep 2014 11:28:32 +1000
NeilBrown <neilb@suse.de> wrote:

> This set includes acked-by's from Andrew and Peter so it should be
> OK for all five patches to go upstream through the NFS tree.
> 
> I split the congestion tracking patch out from the wait-for-PG_private
> patch as they are conceptually separate.
> 
> This set continues to perform well in my tests and addresses all
> issues that have been raised.
> 
> Thanks a lot,
> NeilBrown
> 
> 
> ---
> 
> NeilBrown (5):
>       SCHED: add some "wait..on_bit...timeout()" interfaces.
>       MM: export page_wakeup functions
>       NFS: avoid deadlocks with loop-back mounted NFS filesystems.
>       NFS: avoid waiting at all in nfs_release_page when congested.
>       NFS/SUNRPC: Remove other deadlock-avoidance mechanisms in nfs_release_page()
> 
> 
>  fs/nfs/file.c                   |   29 +++++++++++++++++++----------
>  fs/nfs/write.c                  |    7 +++++++
>  include/linux/pagemap.h         |   12 ++++++++++--
>  include/linux/wait.h            |    5 ++++-
>  kernel/sched/wait.c             |   36 ++++++++++++++++++++++++++++++++++++
>  mm/filemap.c                    |   21 +++++++++++++++------
>  net/sunrpc/sched.c              |    2 --
>  net/sunrpc/xprtrdma/transport.c |    2 --
>  net/sunrpc/xprtsock.c           |   10 ----------
>  9 files changed, 91 insertions(+), 33 deletions(-)
> 

Cool!

This looks like it'll address my earlier concern about setting the BDI
congested inappropriately. You can add this to the set if you like:

Acked-by: Jeff Layton <jlayton@primarydata.com>
