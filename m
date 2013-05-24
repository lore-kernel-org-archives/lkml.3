Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760014Ab3EXDe3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 23:34:29 -0400
Received: from intranet.asianux.com ([58.214.24.6]:61168 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759596Ab3EXDe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 23:34:27 -0400
X-Spam-Score: -100.8
Message-ID: <519EDF8F.5080607@asianux.com>
Date: Fri, 24 May 2013 11:33:35 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Takashi Iwai <tiwai@suse.de>
Subject: Re: [Suggestion] fs/namespace.c: the direct cause of the warning
 for: "ida_remove called for id=0 which is not allocated" with mnt_release_group_id()
References: <5191FE96.6050607@asianux.com> <20130523161805.1faa0f8c59bfc8ee728d8c7f@linux-foundation.org>
In-Reply-To: <20130523161805.1faa0f8c59bfc8ee728d8c7f@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Takashi Iwai <tiwai@suse.de>
> Subject: vfs: fix invalid ida_remove() call
> 
> When the group id of a shared mount is not allocated, the umount still
> tries to call mnt_release_group_id(), which eventually hits a kernel
> warning at ida_remove() spewing a message like:
> 
>   ida_remove called for id=0 which is not allocated.
> 
> This patch fixes the bug simply checking the group id in the caller.
> 
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> Reported-by: Cristian Rodr�guez <crrodriguez@opensuse.org>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 

Tested-by Chen Gang <gang.chen@asianux.com>

Thanks.


>  fs/pnode.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff -puN fs/pnode.c~vfs-fix-invalid-ida_remove-call fs/pnode.c
> --- a/fs/pnode.c~vfs-fix-invalid-ida_remove-call
> +++ a/fs/pnode.c
> @@ -83,7 +83,8 @@ static int do_make_slave(struct mount *m
>  		if (peer_mnt == mnt)
>  			peer_mnt = NULL;
>  	}
> -	if (IS_MNT_SHARED(mnt) && list_empty(&mnt->mnt_share))
> +	if (mnt->mnt_group_id && IS_MNT_SHARED(mnt) &&
> +	    list_empty(&mnt->mnt_share))
>  		mnt_release_group_id(mnt);
>  
>  	list_del_init(&mnt->mnt_share);
> _
> 
> 
> 


-- 
Chen Gang

Asianux Corporation
