Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757210Ab3A1B1f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 20:27:35 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:3667 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755670Ab3A1B1d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 20:27:33 -0500
X-IronPort-AV: E=Sophos;i="4.84,549,1355068800"; 
   d="scan'208";a="6651042"
Message-ID: <5105D423.9080909@cn.fujitsu.com>
Date: Mon, 28 Jan 2013 09:28:03 +0800
From: Gao feng <gaofeng@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Linux Containers <containers@lists.linux-foundation.org>,
        "Serge E. Hallyn" <serge@hallyn.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH review 6/6] userns: Allow the userns root to mount tmpfs.
References: <87ehh8it9s.fsf@xmission.com> <87d2wshe6v.fsf@xmission.com>
In-Reply-To: <87d2wshe6v.fsf@xmission.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/28 09:26:25,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/28 09:26:28,
	Serialize complete at 2013/01/28 09:26:28
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/01/26 10:26, Eric W. Biederman wrote:
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
> ---

useful to me,thanks Eric & Serge.

Acked-by: Gao feng <gaofeng@cn.fujitsu.com>

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
> 

