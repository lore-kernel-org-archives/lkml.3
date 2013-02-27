Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194Ab3B0UJT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 15:09:19 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36911 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752183Ab3B0UJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 15:09:18 -0500
Date: Wed, 27 Feb 2013 14:09:07 -0600
From: Serge Hallyn <serge.hallyn@ubuntu.com>
To: "Raphael S.Carvalho" <raphael.scarv@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Serge E. Hallyn" <serge@hallyn.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] kernel/nsproxy.c: Improving a snippet of code.
Message-ID: <20130227200907.GA19205@sergelap>
References: <1361989929-1145-1-git-send-email-raphael.scarv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361989929-1145-1-git-send-email-raphael.scarv@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Raphael S.Carvalho (raphael.scarv@gmail.com):
> It seems GCC generates a better code in that way, so I changed that statement.
> Btw, they have the same semantic, so I'm sending this patch due to performance issues.
> 
> Signed-off-by: Raphael S.Carvalho <raphael.scarv@gmail.com>

Acked-by: Serge E. Hallyn <serge.hallyn@ubuntu.com>

> ---
>  kernel/nsproxy.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
> index 78e2ecb..21da3d1 100644
> --- a/kernel/nsproxy.c
> +++ b/kernel/nsproxy.c
> @@ -148,7 +148,8 @@ int copy_namespaces(unsigned long flags, struct task_struct *tsk)
>  	 * means share undolist with parent, so we must forbid using
>  	 * it along with CLONE_NEWIPC.
>  	 */
> -	if ((flags & CLONE_NEWIPC) && (flags & CLONE_SYSVSEM)) {
> +	if ((flags & (CLONE_NEWIPC | CLONE_SYSVSEM)) ==
> +		(CLONE_NEWIPC | CLONE_SYSVSEM)) {
>  		err = -EINVAL;
>  		goto out;
>  	}
> -- 
> 1.7.2.5
> 
