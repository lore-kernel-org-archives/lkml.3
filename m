Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751984AbaERRHN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 13:07:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36170 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527AbaERRHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 13:07:08 -0400
Date: Sun, 18 May 2014 09:49:18 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Benjamin Romer <benjamin.romer@unisys.com>
Cc: sparmaintainer@unisys.com, linux-kernel@vger.kernel.org, jkc@redhat.com,
        devel@driverdev.osuosl.org
Subject: Re: [PATCH 2/7] staging: unisys: move uislib/platform proc entry to
 debugfs
Message-ID: <20140518164918.GA10285@kroah.com>
References: <1399912715-16142-1-git-send-email-benjamin.romer@unisys.com>
 <1399912715-16142-3-git-send-email-benjamin.romer@unisys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399912715-16142-3-git-send-email-benjamin.romer@unisys.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2014 at 12:38:30PM -0400, Benjamin Romer wrote:
> Convert /proc/uislib/platform to an equivalent entry in debugfs.
> 
> Signed-off-by: Benjamin Romer <benjamin.romer@unisys.com>
> ---
>  drivers/staging/unisys/uislib/uislib.c | 62 ++++++++++------------------------
>  1 file changed, 17 insertions(+), 45 deletions(-)
> 
> diff --git a/drivers/staging/unisys/uislib/uislib.c b/drivers/staging/unisys/uislib/uislib.c
> index fdc23676..b71f387 100644
> --- a/drivers/staging/unisys/uislib/uislib.c
> +++ b/drivers/staging/unisys/uislib/uislib.c
> @@ -23,6 +23,7 @@
>  #include <config/modversions.h>
>  #endif
>  #include <linux/module.h>
> +#include <linux/debugfs.h>
>  
>  #include "commontypes.h"
>  
> @@ -91,19 +92,23 @@ static int Go_Polling_Device_Channels;
>  static struct proc_dir_entry *uislib_proc_dir;
>  static struct proc_dir_entry *uislib_proc_vbus_dir;
>  static struct proc_dir_entry *info_proc_entry;
> -static struct proc_dir_entry *platformnumber_proc_entry;
>  static struct proc_dir_entry *cycles_before_wait_proc_entry;
>  static struct proc_dir_entry *smart_wakeup_proc_entry;
>  
>  #define DIR_PROC_ENTRY "uislib"
>  #define DIR_VBUS_PROC_ENTRY "vbus"
>  #define INFO_PROC_ENTRY_FN "info"
> -#define PLATFORMNUMBER_PROC_ENTRY_FN "platform"
>  #define CYCLES_BEFORE_WAIT_PROC_ENTRY_FN "cycles_before_wait"
>  #define SMART_WAKEUP_PROC_ENTRY_FN "smart_wakeup"
>  #define CALLHOME_PROC_ENTRY_FN "callhome"
>  #define CALLHOME_THROTTLED_PROC_ENTRY_FN "callhome_throttled"
>  
> +#define DIR_DEBUGFS_ENTRY "uislib"
> +static struct dentry *dir_debugfs;
> +
> +#define PLATFORMNUMBER_DEBUGFS_ENTRY_FN "platform"
> +static struct dentry *platformnumber_debugfs_read;

There's no need to keep this dentry around, you can just remove all the
debugfs files in your directory recursively when you exit.  That will
save you code and logic overall.

I'll leave this for now, you can clean that up in a future patch.

Also, why are these entries moving to debugfs at all?  Why are they
needed?  Who will use them?  Are tools relying on them to be there?

thanks,

greg k-h
