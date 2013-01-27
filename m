Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767Ab3A0SVg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 13:21:36 -0500
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:47749 "EHLO
	mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754359Ab3A0SVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 13:21:32 -0500
Date: Sun, 27 Jan 2013 18:23:28 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        "Serge E. Hallyn" <serge@hallyn.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH review 5/6] userns: Allow the userns root to mount
 ramfs.
Message-ID: <20130127182328.GB338@mail.hallyn.com>
References: <87ehh8it9s.fsf@xmission.com>
 <87ip6khe7w.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ip6khe7w.fsf@xmission.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> 
> There is no backing store to ramfs and file creation
> rules are the same as for any other filesystem so
> it is semantically safe to allow unprivileged users
> to mount it.
> 
> The memory control group successfully limits how much
> memory ramfs can consume on any system that cares about
> a user namespace root using ramfs to exhaust memory
> the memory control group can be deployed.
> 
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>

> ---
>  fs/ramfs/inode.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ramfs/inode.c b/fs/ramfs/inode.c
> index eab8c09..c24f1e1 100644
> --- a/fs/ramfs/inode.c
> +++ b/fs/ramfs/inode.c
> @@ -260,6 +260,7 @@ static struct file_system_type ramfs_fs_type = {
>  	.name		= "ramfs",
>  	.mount		= ramfs_mount,
>  	.kill_sb	= ramfs_kill_sb,
> +	.fs_flags	= FS_USERNS_MOUNT,
>  };
>  static struct file_system_type rootfs_fs_type = {
>  	.name		= "rootfs",
> -- 
> 1.7.5.4
