Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758083Ab3J2PJw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 11:09:52 -0400
Received: from static.92.5.9.176.clients.your-server.de ([176.9.5.92]:59240
	"EHLO hallynmail2" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755195Ab3J2PJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 11:09:51 -0400
Date: Tue, 29 Oct 2013 15:09:49 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: viro@zeniv.linux.org.uk, ebiederm@xmission.com, keescook@chromium.org,
        serge.hallyn@canonical.com, yongjun_wei@trendmicro.com.cn,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] befs: fix return value check in befs_iget()
Message-ID: <20131029150949.GA32008@mail.hallyn.com>
References: <CAPgLHd_bHP-DMMbsFkc1RwmDK4dp+cZY8LRBFyDDuoEohJ-O_g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPgLHd_bHP-DMMbsFkc1RwmDK4dp+cZY8LRBFyDDuoEohJ-O_g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Wei Yongjun (weiyj.lk@gmail.com):
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> In case of error, the function iget_locked() returns NULL pointer
> not ERR_PTR(). The IS_ERR() test in the return value check should
> be replaced with NULL test.
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>

> ---
>  fs/befs/linuxvfs.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/befs/linuxvfs.c b/fs/befs/linuxvfs.c
> index e9c75e2..d714dda 100644
> --- a/fs/befs/linuxvfs.c
> +++ b/fs/befs/linuxvfs.c
> @@ -319,8 +319,8 @@ static struct inode *befs_iget(struct super_block *sb, unsigned long ino)
>  	befs_debug(sb, "---> befs_read_inode() " "inode = %lu", ino);
>  
>  	inode = iget_locked(sb, ino);
> -	if (IS_ERR(inode))
> -		return inode;
> +	if (!inode)
> +		return ERR_PTR(-ENOMEM);
>  	if (!(inode->i_state & I_NEW))
>  		return inode;
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
