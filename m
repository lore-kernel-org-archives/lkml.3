Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006AbaIXHct (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 03:32:49 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:52592 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752813AbaIXHcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 03:32:46 -0400
Date: Wed, 24 Sep 2014 09:32:42 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Trond Myklebust <trond.myklebust@fys.uio.no>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kirill Tkhai <ktkhai@parallels.com>, Christoph Hellwig <hch@lst.de>
Subject: Re: linux-next: manual merge of the tip tree with the nfs tree
Message-ID: <20140924073242.GA1962@gmail.com>
References: <20140922133156.454481f9@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140922133156.454481f9@canb.auug.org.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi all,
> 
> Today's linux-next merge of the tip tree got conflicts in
> fs/nfs/blocklayout/blocklayoutdev.c and
> fs/nfs/blocklayout/blocklayoutdm.c between commit 871760ce97a9
> ("pnfs/blocklayout: move all rpc_pipefs related code into a single
> file") from the nfs tree and commit f139caf2e897 ("sched, cleanup,
> treewide: Remove set_current_state(TASK_RUNNING) after schedule()")
> from the tip tree.
> 
> I fixed it up (the former move the code in these two files into
> fs/nfs/blocklayout/rpc_pipefs.c, so I deleted the 2 files and applied
> the following merge fix patch) and can carry the fix as necessary (no
> action is required).
> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Mon, 22 Sep 2014 13:29:19 +1000
> Subject: [PATCH] pnfs: merge fixup for sched cleanup of set_current_state(TASK_RUNNING)
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  fs/nfs/blocklayout/rpc_pipefs.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/fs/nfs/blocklayout/rpc_pipefs.c b/fs/nfs/blocklayout/rpc_pipefs.c
> index 8d04bda2bd2e..e966c023b1b7 100644
> --- a/fs/nfs/blocklayout/rpc_pipefs.c
> +++ b/fs/nfs/blocklayout/rpc_pipefs.c
> @@ -92,7 +92,6 @@ bl_resolve_deviceid(struct nfs_server *server, struct pnfs_block_volume *b,
>  
>  	set_current_state(TASK_UNINTERRUPTIBLE);
>  	schedule();
> -	__set_current_state(TASK_RUNNING);
>  	remove_wait_queue(&nn->bl_wq, &wq);
>  
>  	if (reply->status != BL_DEVICE_REQUEST_PROC) {

Looks good, thanks Stephen!

	Ingo
