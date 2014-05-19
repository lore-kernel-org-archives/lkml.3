Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932113AbaESMeY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 08:34:24 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34377 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754559AbaESMeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 08:34:21 -0400
Message-ID: <5379FA44.90107@canonical.com>
Date: Mon, 19 May 2014 05:34:12 -0700
From: John Johansen <john.johansen@canonical.com>
Organization: Canonical
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, miklos@szeredi.hu,
        jmorris@namei.org, selinux@tycho.nsa.gov
CC: linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH (for 3.15) 5/5] LSM: Remove duplicated rename handling.
References: <201404242020.FJD18726.LOOJtOQMFVFFSH@I-love.SAKURA.ne.jp>	<201405012058.JEG30273.LJFHOOFMtOFQVS@I-love.SAKURA.ne.jp>	<201405051449.GAE81222.LOOFtFJMQFOSVH@I-love.SAKURA.ne.jp>	<201405120053.HJG95368.HFLQSFMOOtOVJF@I-love.SAKURA.ne.jp>	<201405122221.DBG43278.LOQtJSOFVFFOHM@I-love.SAKURA.ne.jp> <201405122225.CIE09825.MFHOtOOSQVFFLJ@I-love.SAKURA.ne.jp>
In-Reply-To: <201405122225.CIE09825.MFHOtOOSQVFFLJ@I-love.SAKURA.ne.jp>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12/2014 06:25 AM, Tetsuo Handa wrote:
>>From 479d305929c4ef600de99948f42ed633b24458b0 Mon Sep 17 00:00:00 2001
> From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Date: Mon, 12 May 2014 22:02:30 +0900
> Subject: [PATCH (for 3.15) 5/5] LSM: Remove duplicated rename handling.
> 
> Since all LSM modules are now ready to handle the rename flags,
> security_inode_rename() and security_path_rename() no longer need to
> call each LSM module with reversed arguments.
> 
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Acked-by: John Johansen <john.johansen@canonical.com>

> ---
>  security/security.c |   18 ------------------
>  1 files changed, 0 insertions(+), 18 deletions(-)
> 
> diff --git a/security/security.c b/security/security.c
> index 81d7ffe..fbc4968 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -439,15 +439,6 @@ int security_path_rename(struct path *old_dir, struct dentry *old_dentry,
>  	if (unlikely(IS_PRIVATE(old_dentry->d_inode) ||
>  		     (new_dentry->d_inode && IS_PRIVATE(new_dentry->d_inode))))
>  		return 0;
> -
> -	if (flags & RENAME_EXCHANGE) {
> -		int err = security_ops->path_rename(new_dir, new_dentry,
> -						    old_dir, old_dentry,
> -						    flags);
> -		if (err)
> -			return err;
> -	}
> -
>  	return security_ops->path_rename(old_dir, old_dentry, new_dir,
>  					 new_dentry, flags);
>  }
> @@ -540,15 +531,6 @@ int security_inode_rename(struct inode *old_dir, struct dentry *old_dentry,
>          if (unlikely(IS_PRIVATE(old_dentry->d_inode) ||
>              (new_dentry->d_inode && IS_PRIVATE(new_dentry->d_inode))))
>  		return 0;
> -
> -	if (flags & RENAME_EXCHANGE) {
> -		int err = security_ops->inode_rename(new_dir, new_dentry,
> -						     old_dir, old_dentry,
> -						     flags);
> -		if (err)
> -			return err;
> -	}
> -
>  	return security_ops->inode_rename(old_dir, old_dentry,
>  					  new_dir, new_dentry, flags);
>  }
> 

