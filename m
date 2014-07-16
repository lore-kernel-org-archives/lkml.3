Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761204AbaGPDdT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 23:33:19 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:53266 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759783AbaGPDdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 23:33:11 -0400
X-Sasl-enc: dyLyPjAa5tJ9dFHT7/rAMyoeWT583Zkfz+VKuOH6jqBu 1405481235
Message-ID: <1405481232.2527.12.camel@perseus.fritz.box>
Subject: Re: [PATCH 2/6] autofs4: remove a redundant assignment
From: Ian Kent <raven@themaw.net>
To: NeilBrown <neilb@suse.de>
Cc: autofs@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 16 Jul 2014 11:27:12 +0800
In-Reply-To: <20140709234114.4525.3341.stgit@notabene.brown>
References: <20140709233541.4525.25151.stgit@notabene.brown>
	 <20140709234114.4525.3341.stgit@notabene.brown>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-07-10 at 09:41 +1000, NeilBrown wrote:
> The variable 'ino' already exists and already
> has the correct value.  The d_fsdata of a dentry
> is never changed after the d_fsdata is instantiated,
> so this new assignment cannot be necessary.
> 
> It was introduced in
> commit b5b801779d59165c4ecf1009009109545bd1f642
>     autofs4: Add d_manage() dentry operation
> 
> Signed-off-by: NeilBrown <neilb@suse.de>

Again, an obvious cleanup, thanks for that.
Acked-by: Ian Kent <raven@themaw.net>

> ---
>  fs/autofs4/expire.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/fs/autofs4/expire.c b/fs/autofs4/expire.c
> index 394e90b02c5e..a7be57e39be7 100644
> --- a/fs/autofs4/expire.c
> +++ b/fs/autofs4/expire.c
> @@ -333,7 +333,6 @@ struct dentry *autofs4_expire_direct(struct super_block *sb,
>  	if (ino->flags & AUTOFS_INF_PENDING)
>  		goto out;
>  	if (!autofs4_direct_busy(mnt, root, timeout, do_now)) {
> -		struct autofs_info *ino = autofs4_dentry_ino(root);
>  		ino->flags |= AUTOFS_INF_EXPIRING;
>  		init_completion(&ino->expire_complete);
>  		spin_unlock(&sbi->fs_lock);
> 
> 


