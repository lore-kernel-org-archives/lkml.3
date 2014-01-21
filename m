Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755168AbaAURL1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 12:11:27 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:29057 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754438AbaAURL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 12:11:26 -0500
Date: Tue, 21 Jan 2014 17:10:54 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: "H.J. Lu" <hjl.tools@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/8] Use __kernel_ulong_t in x86 struct semid64_ds
Message-ID: <20140121171053.GD20798@arm.com>
References: <1388165112-6545-1-git-send-email-hjl.tools@gmail.com>
 <1388165112-6545-7-git-send-email-hjl.tools@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1388165112-6545-7-git-send-email-hjl.tools@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 27, 2013 at 05:25:10PM +0000, H.J. Lu wrote:
> Both x32 and x86-64 use the same struct semid64_ds for system calls.
> But x32 long is 32-bit. This patch replaces unsigned long with
> __kernel_ulong_t in x86 struct semid64_ds.
> 
> Signed-off-by: H.J. Lu <hjl.tools@gmail.com>
> ---
>  arch/x86/include/uapi/asm/sembuf.h | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/include/uapi/asm/sembuf.h b/arch/x86/include/uapi/asm/sembuf.h
> index ee50c80..cc2d6a3 100644
> --- a/arch/x86/include/uapi/asm/sembuf.h
> +++ b/arch/x86/include/uapi/asm/sembuf.h
> @@ -13,12 +13,12 @@
>  struct semid64_ds {
>  	struct ipc64_perm sem_perm;	/* permissions .. see ipc.h */
>  	__kernel_time_t	sem_otime;	/* last semop time */
> -	unsigned long	__unused1;
> +	__kernel_ulong_t __unused1;
>  	__kernel_time_t	sem_ctime;	/* last change time */
> -	unsigned long	__unused2;
> -	unsigned long	sem_nsems;	/* no. of semaphores in array */
> -	unsigned long	__unused3;
> -	unsigned long	__unused4;
> +	__kernel_ulong_t __unused2;
> +	__kernel_ulong_t sem_nsems;	/* no. of semaphores in array */
> +	__kernel_ulong_t __unused3;
> +	__kernel_ulong_t __unused4;
>  };

Since you are at this, could you please change the
include/uapi/asm-generic/sembuf.h structure as well?

-- 
Catalin
