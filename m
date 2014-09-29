Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748AbaI2Pmy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 11:42:54 -0400
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:38377 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521AbaI2Pmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 11:42:53 -0400
Message-ID: <54297DF9.5080003@codethink.co.uk>
Date: Mon, 29 Sep 2014 16:42:49 +0100
From: Rob Jones <rob.jones@codethink.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.7.0
MIME-Version: 1.0
To: dhowells@redhat.com
CC: linux-cachefs@redhat.com, linux-kernel@vger.kernel.org,
        linux-kernel@codethink.co.uk
Subject: Re: [PATCH] fs/fscache/object-list.c: use __seq_open_private()
References: <1410944200-24288-1-git-send-email-rob.jones@codethink.co.uk>
In-Reply-To: <1410944200-24288-1-git-send-email-rob.jones@codethink.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I submitted the patch below on 17th September but have had no feedback.

It seems to me a worthwhile change (well, I wouldn't have written it
otherwise) but does anybody else have any comments on it?

On 17/09/14 09:56, Rob Jones wrote:
> Reduce boilerplate code by using __seq_open_private() instead of seq_open()
> in fscache_objlist_open().
>
> Signed-off-by: Rob Jones <rob.jones@codethink.co.uk>
> ---
>
> Note that sparse generates a warning on this file but it is outside the
> remit of this patch.
>
> Note 2, it looks to me like the sparse warning may be a false positive.
>
>   fs/fscache/object-list.c |   16 ++--------------
>   1 file changed, 2 insertions(+), 14 deletions(-)
>
> diff --git a/fs/fscache/object-list.c b/fs/fscache/object-list.c
> index b5ebc2d..a1ca2f9 100644
> --- a/fs/fscache/object-list.c
> +++ b/fs/fscache/object-list.c
> @@ -380,26 +380,14 @@ no_config:
>   static int fscache_objlist_open(struct inode *inode, struct file *file)
>   {
>   	struct fscache_objlist_data *data;
> -	struct seq_file *m;
> -	int ret;
>
> -	ret = seq_open(file, &fscache_objlist_ops);
> -	if (ret < 0)
> -		return ret;
> -
> -	m = file->private_data;
> -
> -	/* buffer for key extraction */
> -	data = kmalloc(sizeof(struct fscache_objlist_data), GFP_KERNEL);
> -	if (!data) {
> -		seq_release(inode, file);
> +	data = __seq_open_private(file, &fscache_objlist_ops, sizeof(*data));
> +	if (!data)
>   		return -ENOMEM;
> -	}
>
>   	/* get the configuration key */
>   	fscache_objlist_config(data);
>
> -	m->private = data;
>   	return 0;
>   }
>
>

-- 
Rob Jones
Codethink Ltd
mailto:rob.jones@codethink.co.uk
tel:+44 161 236 5575
