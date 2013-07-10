Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979Ab3GJBOw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 21:14:52 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64866 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753735Ab3GJBOv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 21:14:51 -0400
X-IronPort-AV: E=Sophos;i="4.87,1032,1363104000"; 
   d="scan'208";a="7840983"
Message-ID: <51DCB585.9030105@cn.fujitsu.com>
Date: Wed, 10 Jul 2013 09:14:45 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Eric Biederman <ebiederm@xmission.com>, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH REPOST] kexec: return error of machine_kexec() fails
References: <1373386597-3884-1-git-send-email-swarren@wwwdotorg.org>
In-Reply-To: <1373386597-3884-1-git-send-email-swarren@wwwdotorg.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/10 09:13:05,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/10 09:13:09
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013/7/10 0:16, Stephen Warren 写道:
> From: Stephen Warren <swarren@nvidia.com>
> 
> Prior to commit 3ab8352 "kexec jump", if machine_kexec() returned,
> sys_reboot() would return -EINVAL. This patch restores this behaviour
> for the non-KEXEC_JUMP case, where machine_kexec() is not expected to
> return.
> 
> This situation can occur on ARM, where kexec requires disabling all but
> one CPU using CPU hotplug. However, if hotplug isn't supported by the
> particular HW the kernel is running on, then kexec cannot succeed.

I don't have an ARM machine, but I believe you are right by reading the
code. So

Acked-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>

> 
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> Acked-by: Will Deacon <will.deacon@arm.com>
> ---
>  kernel/kexec.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/kernel/kexec.c b/kernel/kexec.c
> index 59f7b55..bde1190 100644
> --- a/kernel/kexec.c
> +++ b/kernel/kexec.c
> @@ -1702,6 +1702,8 @@ int kernel_kexec(void)
>  		pm_restore_console();
>  		unlock_system_sleep();
>  	}
> +#else
> +	error = -EINVAL;
>  #endif
>  
>   Unlock:
> 


-- 
Thanks.
Zhang Yanfei
