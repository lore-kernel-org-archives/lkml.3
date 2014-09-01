Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887AbaIANPU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 09:15:20 -0400
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:35747 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753AbaIANPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 09:15:17 -0400
Message-ID: <5404715F.9070707@codethink.co.uk>
Date: Mon, 01 Sep 2014 14:15:11 +0100
From: Rob Jones <rob.jones@codethink.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.7.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: linux-fsdevel@vger.kernel.org, viro@zeniv.org.uk,
        akpm@linux-foundation.org, linux-kernel@codethink.co.uk
Subject: Re: [PATCH] fs: replace int param with size_t for seq_open_private()
References: <1409577185-16100-1-git-send-email-rob.jones@codethink.co.uk>
In-Reply-To: <1409577185-16100-1-git-send-email-rob.jones@codethink.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resubmitting - mistranscribed Alexander Viro's email address.

On 01/09/14 14:13, Rob Jones wrote:
> also for __seq_open_private()
>
> Signed-off-by: Rob Jones <rob.jones@codethink.co.uk>
> ---
>   fs/seq_file.c            |    4 ++--
>   include/linux/seq_file.h |    4 ++--
>   2 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/fs/seq_file.c b/fs/seq_file.c
> index 1d641bb..dc2dfec 100644
> --- a/fs/seq_file.c
> +++ b/fs/seq_file.c
> @@ -640,7 +640,7 @@ int seq_release_private(struct inode *inode, struct file *file)
>   EXPORT_SYMBOL(seq_release_private);
>
>   void *__seq_open_private(struct file *f, const struct seq_operations *ops,
> -		int psize)
> +		size_t psize)
>   {
>   	int rc;
>   	void *private;
> @@ -666,7 +666,7 @@ out:
>   EXPORT_SYMBOL(__seq_open_private);
>
>   int seq_open_private(struct file *filp, const struct seq_operations *ops,
> -		int psize)
> +		size_t psize)
>   {
>   	return __seq_open_private(filp, ops, psize) ? 0 : -ENOMEM;
>   }
> diff --git a/include/linux/seq_file.h b/include/linux/seq_file.h
> index 52e0097..9382339 100644
> --- a/include/linux/seq_file.h
> +++ b/include/linux/seq_file.h
> @@ -140,8 +140,8 @@ static inline int seq_nodemask_list(struct seq_file *m, nodemask_t *mask)
>   int single_open(struct file *, int (*)(struct seq_file *, void *), void *);
>   int single_open_size(struct file *, int (*)(struct seq_file *, void *), void *, size_t);
>   int single_release(struct inode *, struct file *);
> -void *__seq_open_private(struct file *, const struct seq_operations *, int);
> -int seq_open_private(struct file *, const struct seq_operations *, int);
> +void *__seq_open_private(struct file *, const struct seq_operations *, size_t);
> +int seq_open_private(struct file *, const struct seq_operations *, size_t);
>   int seq_release_private(struct inode *, struct file *);
>   int seq_put_decimal_ull(struct seq_file *m, char delimiter,
>   			unsigned long long num);
>

-- 
Rob Jones
Codethink Ltd
mailto:rob.jones@codethink.co.uk
tel:+44 161 236 5575
