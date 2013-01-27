Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754935Ab3A0SVn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 13:21:43 -0500
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:47753 "EHLO
	mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754359Ab3A0SVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 13:21:39 -0500
Date: Sun, 27 Jan 2013 18:23:34 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        "Serge E. Hallyn" <serge@hallyn.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH review 6/6] userns: Allow the userns root to mount
 tmpfs.
Message-ID: <20130127182334.GC338@mail.hallyn.com>
References: <87ehh8it9s.fsf@xmission.com>
 <87d2wshe6v.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87d2wshe6v.fsf@xmission.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> 
> There is no backing store to tmpfs and file creation rules are the
> same as for any other filesystem so it is semantically safe to allow
> unprivileged users to mount it.  ramfs is safe for the same reasons so
> allow either flavor of tmpfs to be mounted by a user namespace root
> user.
> 
> The memory control group successfully limits how much memory tmpfs can
> consume on any system that cares about a user namespace root using
> tmpfs to exhaust memory the memory control group can be deployed.
> 
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>

> ---
>  mm/shmem.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 5c90d84..197ca5e 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -2766,6 +2766,7 @@ static struct file_system_type shmem_fs_type = {
>  	.name		= "tmpfs",
>  	.mount		= shmem_mount,
>  	.kill_sb	= kill_litter_super,
> +	.fs_flags	= FS_USERNS_MOUNT,
>  };
>  
>  int __init shmem_init(void)
> @@ -2823,6 +2824,7 @@ static struct file_system_type shmem_fs_type = {
>  	.name		= "tmpfs",
>  	.mount		= ramfs_mount,
>  	.kill_sb	= kill_litter_super,
> +	.fs_flags	= FS_USERNS_MOUNT,
>  };
>  
>  int __init shmem_init(void)
> -- 
> 1.7.5.4
