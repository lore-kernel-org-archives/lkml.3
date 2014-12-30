Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751818AbaL3WfX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 17:35:23 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:49959 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461AbaL3WfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 17:35:22 -0500
Date: Tue, 30 Dec 2014 14:35:18 -0800
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Serguey Parkhomovsky <sergueyparkhomovsky@gmail.com>
Cc: Oleg Drokin <oleg.drokin@intel.com>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        HPDD-discuss@ml01.01.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: lustre: linux-prim.c: fix sparse warnings about
 static declaration
Message-ID: <20141230223518.GA31616@hudson.localdomain>
Mail-Followup-To: Jeremiah Mahler <jmmahler@gmail.com>,
	Serguey Parkhomovsky <sergueyparkhomovsky@gmail.com>,
	Oleg Drokin <oleg.drokin@intel.com>,
	Andreas Dilger <andreas.dilger@intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	HPDD-discuss@lists.01.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
References: <20141229111032.GA18686@fedora.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141229111032.GA18686@fedora.localdomain>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serguey,

On Mon, Dec 29, 2014 at 03:10:32AM -0800, Serguey Parkhomovsky wrote:
> Fixes the following sparse warnings:
> 
> drivers/staging/lustre/lustre/libcfs/linux/linux-prim.c:198:1: warning: symbol 'libcfs_arch_init' was not declared. Should it be static?
> drivers/staging/lustre/lustre/libcfs/linux/linux-prim.c:204:1: warning: symbol 'libcfs_arch_cleanup' was not declared. Should it be static?
> 
> Signed-off-by: Serguey Parkhomovsky <sergueyparkhomovsky@gmail.com>
> ---
>  drivers/staging/lustre/lustre/libcfs/linux/linux-prim.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/staging/lustre/lustre/libcfs/linux/linux-prim.c b/drivers/staging/lustre/lustre/libcfs/linux/linux-prim.c
> index 19f405e..4fee73f 100644
> --- a/drivers/staging/lustre/lustre/libcfs/linux/linux-prim.c
> +++ b/drivers/staging/lustre/lustre/libcfs/linux/linux-prim.c
> @@ -194,14 +194,12 @@ cfs_clear_sigpending(void)
>  	spin_unlock_irqrestore(&current->sighand->siglock, flags);
>  }
>  
> -int
> -libcfs_arch_init(void)
> +static int libcfs_arch_init(void)
>  {
>  	return 0;
>  }
>  
> -void
> -libcfs_arch_cleanup(void)
> +static void libcfs_arch_cleanup(void)
>  {
>  	return;
>  }

If you look at the source code just below these functions you will find:

EXPORT_SYMBOL(libcfs_arch_init);
EXPORT_SYMBOL(libcfs_arch_cleanup);

So making these static is incorrect because they are being used outside
of this file.

> -- 
> 1.9.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
- Jeremiah Mahler
