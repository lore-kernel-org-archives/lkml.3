Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485AbbAXDBC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 22:01:02 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:43653 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564AbbAXDA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 22:00:59 -0500
Date: Sat, 24 Jan 2015 11:00:56 +0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 4/5 v2] tracefs: Add directory /sys/kernel/tracing
Message-ID: <20150124030056.GC5009@kroah.com>
References: <20150123155525.795129339@goodmis.org>
 <20150123162414.743137310@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150123162414.743137310@goodmis.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2015 at 10:55:29AM -0500, Steven Rostedt wrote:
> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> 
> When tracefs is configured, have the directory /sys/kernel/tracing appear
> just like /sys/kernel/debug appears when debugfs is configured.
> 
> This will give a consistent place for system admins to mount tracefs.
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  fs/tracefs/inode.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/fs/tracefs/inode.c b/fs/tracefs/inode.c
> index c31997a303c7..cdbaa42b44a1 100644
> --- a/fs/tracefs/inode.c
> +++ b/fs/tracefs/inode.c
> @@ -16,6 +16,7 @@
>  #include <linux/module.h>
>  #include <linux/fs.h>
>  #include <linux/mount.h>
> +#include <linux/kobject.h>
>  #include <linux/namei.h>
>  #include <linux/tracefs.h>
>  #include <linux/fsnotify.h>
> @@ -547,10 +548,16 @@ bool tracefs_initialized(void)
>  	return tracefs_registered;
>  }
>  
> +static struct kobject *trace_kobj;
> +
>  static int __init tracefs_init(void)
>  {
>  	int retval;
>  
> +	trace_kobj = kobject_create_and_add("tracing", kernel_kobj);
> +	if (!trace_kobj)
> +		return -EINVAL;
> +
>  	retval = register_filesystem(&trace_fs_type);
>  	if (!retval)
>  		tracefs_registered = true;
> -- 
> 2.1.4
> 

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
