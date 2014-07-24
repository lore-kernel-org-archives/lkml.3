Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759511AbaGXRB0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 13:01:26 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:57501 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571AbaGXRBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 13:01:24 -0400
Date: Thu, 24 Jul 2014 17:01:19 +0000
From: Serge Hallyn <serge.hallyn@ubuntu.com>
To: Aditya Kali <adityakali@google.com>
Cc: tj@kernel.org, lizefan@huawei.com, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        mingo@redhat.com, containers@lists.linux-foundation.org
Subject: Re: [PATCH 2/5] sched: new clone flag CLONE_NEWCGROUP for cgroup
 namespace
Message-ID: <20140724170119.GR26600@ubuntumail>
References: <adityakali-cgroupns>
 <1405626731-12220-1-git-send-email-adityakali@google.com>
 <1405626731-12220-3-git-send-email-adityakali@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405626731-12220-3-git-send-email-adityakali@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Aditya Kali (adityakali@google.com):
> CLONE_NEWCGROUP will be used to create new cgroup namespace.
> 

This is fine and I'm not looking to bikeshed, but am wondering - did
you consider any other ways beside unshare (i.e. a new mount option
to cgroupfs)?  If so, do you have a list of the downsides of those?
(I mainly ask bc clone flags are still a scarce commodity)

> Signed-off-by: Aditya Kali <adityakali@google.com>

Acked-by: Serge E. Hallyn <serge.hallyn@ubuntu.com>

> ---
>  include/uapi/linux/sched.h | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/include/uapi/linux/sched.h b/include/uapi/linux/sched.h
> index 34f9d73..2f90d00 100644
> --- a/include/uapi/linux/sched.h
> +++ b/include/uapi/linux/sched.h
> @@ -21,8 +21,7 @@
>  #define CLONE_DETACHED		0x00400000	/* Unused, ignored */
>  #define CLONE_UNTRACED		0x00800000	/* set if the tracing process can't force CLONE_PTRACE on this clone */
>  #define CLONE_CHILD_SETTID	0x01000000	/* set the TID in the child */
> -/* 0x02000000 was previously the unused CLONE_STOPPED (Start in stopped state)
> -   and is now available for re-use. */
> +#define CLONE_NEWCGROUP		0x02000000	/* New cgroup namespace */
>  #define CLONE_NEWUTS		0x04000000	/* New utsname group? */
>  #define CLONE_NEWIPC		0x08000000	/* New ipcs */
>  #define CLONE_NEWUSER		0x10000000	/* New user namespace */
> -- 
> 2.0.0.526.g5318336
> 
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/containers
