Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761139AbaGPDdO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 23:33:14 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:53429 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757735AbaGPDdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 23:33:11 -0400
X-Greylist: delayed 488 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Jul 2014 23:33:11 EDT
X-Sasl-enc: GOSqrK1wI/ri4AUo2WW6hbNpDLEeH1bwLNurf+L0qEX7 1405481165
Message-ID: <1405481162.2527.10.camel@perseus.fritz.box>
Subject: Re: [PATCH 1/6] autofs4: remove unused autofs4_ispending()
From: Ian Kent <raven@themaw.net>
To: NeilBrown <neilb@suse.de>
Cc: autofs@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 16 Jul 2014 11:26:02 +0800
In-Reply-To: <20140709234114.4525.94513.stgit@notabene.brown>
References: <20140709233541.4525.25151.stgit@notabene.brown>
	 <20140709234114.4525.94513.stgit@notabene.brown>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-07-10 at 09:41 +1000, NeilBrown wrote:
> Signed-off-by: NeilBrown <neilb@suse.de>

Obviously straight forward.
Acked-by: Ian Kent <raven@themaw.net>

> ---
>  fs/autofs4/autofs_i.h |   14 --------------
>  1 file changed, 14 deletions(-)
> 
> diff --git a/fs/autofs4/autofs_i.h b/fs/autofs4/autofs_i.h
> index acf32054edd8..22a280151e45 100644
> --- a/fs/autofs4/autofs_i.h
> +++ b/fs/autofs4/autofs_i.h
> @@ -143,20 +143,6 @@ static inline int autofs4_oz_mode(struct autofs_sb_info *sbi) {
>  	return sbi->catatonic || task_pgrp(current) == sbi->oz_pgrp;
>  }
>  
> -/* Does a dentry have some pending activity? */
> -static inline int autofs4_ispending(struct dentry *dentry)
> -{
> -	struct autofs_info *inf = autofs4_dentry_ino(dentry);
> -
> -	if (inf->flags & AUTOFS_INF_PENDING)
> -		return 1;
> -
> -	if (inf->flags & AUTOFS_INF_EXPIRING)
> -		return 1;
> -
> -	return 0;
> -}
> -
>  struct inode *autofs4_get_inode(struct super_block *, umode_t);
>  void autofs4_free_ino(struct autofs_info *);
>  
> 
> 


