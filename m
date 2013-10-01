Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907Ab3JAPAy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 11:00:54 -0400
Received: from relay2.sgi.com ([192.48.179.30]:37311 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753323Ab3JAPAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 11:00:47 -0400
Message-ID: <524AE39B.3040505@sgi.com>
Date: Tue, 01 Oct 2013 10:00:43 -0500
From: Mark Tinguely <tinguely@sgi.com>
User-Agent: Mozilla/5.0 (X11; FreeBSD amd64; rv:9.0) Gecko/20120122 Thunderbird/9.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: Ben Myers <bpm@sgi.com>, Alex Elder <elder@kernel.org>,
        linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [PATCH] xfs: Use kmem_free() instead of free()
References: <1380638873-5181-1-git-send-email-treding@nvidia.com>
In-Reply-To: <1380638873-5181-1-git-send-email-treding@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/13 09:47, Thierry Reding wrote:
> This fixes a build failure caused by calling the free() function which
> does not exist in the Linux kernel.
>
> Signed-off-by: Thierry Reding<treding@nvidia.com>
> ---
>   fs/xfs/xfs_log_recover.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 4324058..3979749 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -1585,7 +1585,7 @@ xlog_recover_add_to_trans(
>   		"bad number of regions (%d) in inode log format",
>   				  in_f->ilf_size);
>   			ASSERT(0);
> -			free(ptr);
> +			kmem_free(ptr);
>   			return XFS_ERROR(EIO);
>   		}
>

Looks good. I will remove the other list items in another patch.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>
