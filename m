Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754301AbaKDPRO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 10:17:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45741 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752851AbaKDPRN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 10:17:13 -0500
Message-ID: <1415114229.2373.14.camel@redhat.com>
Subject: Re: [PATCH] audit_tree: keep inode pinned
From: Eric Paris <eparis@redhat.com>
To: Miklos Szeredi <miklos@szeredi.hu>, pmoore@redhat.com, rgb@redhat.com
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 04 Nov 2014 10:17:09 -0500
In-Reply-To: <20141104102712.GA7088@tucsk.piliscsaba.szeredi.hu>
References: <20141104102712.GA7088@tucsk.piliscsaba.szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[adding paul and richard]

On Tue, 2014-11-04 at 11:27 +0100, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> Audit rules disappear when an inode they watch is evicted from the cache.
> This is likely not what we want.
> 
> The guilty commit is "fsnotify: allow marks to not pin inodes in core",
> which didn't take into account that audit_tree adds watches with a zero
> mask.
> 
> Adding any mask should fix this.
> 
> Fixes: 90b1e7a57880 ("fsnotify: allow marks to not pin inodes in core")
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> Cc: stable@vger.kernel.org # 2.6.36+
> ---
>  kernel/audit_tree.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- a/kernel/audit_tree.c
> +++ b/kernel/audit_tree.c
> @@ -154,6 +154,7 @@ static struct audit_chunk *alloc_chunk(i
>  		chunk->owners[i].index = i;
>  	}
>  	fsnotify_init_mark(&chunk->mark, audit_tree_destroy_watch);
> +	chunk->mark.mask = FS_IN_IGNORED;
>  	return chunk;
>  }
>  


