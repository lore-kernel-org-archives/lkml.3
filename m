Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932229Ab3HNL6A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 07:58:00 -0400
Received: from static.92.5.9.176.clients.your-server.de ([176.9.5.92]:54718
	"EHLO hallynmail2" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759573Ab3HNL57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 07:57:59 -0400
Date: Wed, 14 Aug 2013 11:57:57 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] efs: iget_locked() doesn't return an ERR_PTR()
Message-ID: <20130814115757.GA16458@mail.hallyn.com>
References: <20130814094940.GF521@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130814094940.GF521@elgon.mountain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Dan Carpenter (dan.carpenter@oracle.com):
> The iget_locked() function returns NULL on error and never an ERR_PTR.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>

> diff --git a/fs/efs/inode.c b/fs/efs/inode.c
> index f3913eb..d15ccf2 100644
> --- a/fs/efs/inode.c
> +++ b/fs/efs/inode.c
> @@ -57,7 +57,7 @@ struct inode *efs_iget(struct super_block *super, unsigned long ino)
>  	struct inode *inode;
>  
>  	inode = iget_locked(super, ino);
> -	if (IS_ERR(inode))
> +	if (!inode)
>  		return ERR_PTR(-ENOMEM);
>  	if (!(inode->i_state & I_NEW))
>  		return inode;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
