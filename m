Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751408AbaHOXWZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 19:22:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44432 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233AbaHOXWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 19:22:24 -0400
Date: Fri, 15 Aug 2014 16:21:48 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Hema Prathaban <hemaklnce@gmail.com>
Cc: devel@driverdev.osuosl.org, oleg.drokin@intel.com,
        andreas.dilger@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: lustre: lustre: libcfs: pr_warn instead printk
Message-ID: <20140815232148.GA10600@kroah.com>
References: <20140815181805.GA4709@hema-Inspiron-3520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140815181805.GA4709@hema-Inspiron-3520>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 15, 2014 at 11:48:05PM +0530, Hema Prathaban wrote:
> This patch fixes the following warning using checkpatch.pl
> WARNING: Prefer [subsystem eg: netdev]_warn([subsystem]dev, ... then
> dev_warn(dev, ... then pr_warn(...  to printk(KERN_WARNING ...
> 
> Signed-off-by: Hema Prathaban <hemaklnce@gmail.com>
> ---
>  drivers/staging/lustre/lustre/libcfs/debug.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/staging/lustre/lustre/libcfs/debug.c b/drivers/staging/lustre/lustre/libcfs/debug.c
> index 6b58469..8143ebe 100644
> --- a/drivers/staging/lustre/lustre/libcfs/debug.c
> +++ b/drivers/staging/lustre/lustre/libcfs/debug.c
> @@ -344,7 +344,7 @@ void libcfs_debug_dumplog_internal(void *arg)
>  		snprintf(debug_file_name, sizeof(debug_file_name) - 1,
>  			 "%s.%ld.%ld", libcfs_debug_file_path_arr,
>  			 get_seconds(), (long_ptr_t)arg);
> -		printk(KERN_ALERT "LustreError: dumping log to %s\n",
> +		pr_alert(KERN_ALERT "LustreError: dumping log to %s\n",
>  		       debug_file_name);
>  		cfs_tracefile_dump_all_pages(debug_file_name);
>  		libcfs_run_debug_log_upcall(debug_file_name);
> @@ -376,7 +376,7 @@ void libcfs_debug_dumplog(void)
>  			     (void *)(long)current_pid(),
>  			     "libcfs_debug_dumper");
>  	if (IS_ERR(dumper))
> -		printk(KERN_ERR "LustreError: cannot start log dump thread:"
> +		pr_err(KERN_ERR "LustreError: cannot start log dump thread:"

You need to take the printk prefix off of these types of lines if you
are using the pr_*() macro, otherwise you will get a mess in the system
log.

thanks,

greg k-h
