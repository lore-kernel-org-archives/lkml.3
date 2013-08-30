Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754969Ab3H3BPQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 21:15:16 -0400
Received: from static.92.5.9.176.clients.your-server.de ([176.9.5.92]:40557
	"EHLO hallynmail2" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753245Ab3H3BPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 21:15:14 -0400
Date: Fri, 30 Aug 2013 01:15:14 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        "Serge E. Hallyn" <serge@hallyn.com>, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>
Subject: Re: [REVIEW][PATCH 2/5] userns: Allow PR_CAPBSET_DROP in a user
 namespace.
Message-ID: <20130830011513.GC12720@mail.hallyn.com>
References: <87ob8gys0d.fsf@xmission.com>
 <87eh9cyrxj.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87eh9cyrxj.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> 
> As the capabilites and capability bounding set are per user namespace
> properties it is safe to allow changing them with just CAP_SETPCAP
> permission in the user namespace.
> 
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
> Tested-by: Richard Weinberger <richard@nod.at>

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>

> ---
>  security/commoncap.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/security/commoncap.c b/security/commoncap.c
> index c44b6fe..9fccf71 100644
> --- a/security/commoncap.c
> +++ b/security/commoncap.c
> @@ -824,7 +824,7 @@ int cap_task_setnice(struct task_struct *p, int nice)
>   */
>  static long cap_prctl_drop(struct cred *new, unsigned long cap)
>  {
> -	if (!capable(CAP_SETPCAP))
> +	if (!ns_capable(current_user_ns(), CAP_SETPCAP))
>  		return -EPERM;
>  	if (!cap_valid(cap))
>  		return -EINVAL;
> -- 
> 1.7.5.4
