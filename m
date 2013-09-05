Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610Ab3IEDTi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 23:19:38 -0400
Received: from smtp.nue.novell.com ([195.135.221.5]:53485 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772Ab3IEDTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 23:19:37 -0400
Subject: Re: [PATCH V3 09/11] uswsusp: Disable when module loading is
 restricted
From: joeyli <jlee@suse.com>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        keescook@chromium.org, hpa@zytor.com
In-Reply-To: <1378252218-18798-10-git-send-email-matthew.garrett@nebula.com>
References: <1378252218-18798-1-git-send-email-matthew.garrett@nebula.com>
	 <1378252218-18798-10-git-send-email-matthew.garrett@nebula.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 05 Sep 2013 11:20:26 +0800
Message-ID: <1378351226.6380.84.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

於 二，2013-09-03 於 19:50 -0400，Matthew Garrett 提到：
> uswsusp allows a user process to dump and then restore kernel state, which
> makes it possible to avoid module loading restrictions. Prevent this when
> any restrictions have been imposed on loading modules.
> 
> Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>

Tested-by: Lee, Chun-Yi <jlee@suse.com>

> ---
>  kernel/power/user.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/kernel/power/user.c b/kernel/power/user.c
> index 4ed81e7..15cb72f 100644
> --- a/kernel/power/user.c
> +++ b/kernel/power/user.c
> @@ -24,6 +24,7 @@
>  #include <linux/console.h>
>  #include <linux/cpu.h>
>  #include <linux/freezer.h>
> +#include <linux/module.h>
>  
>  #include <asm/uaccess.h>
>  
> @@ -48,6 +49,9 @@ static int snapshot_open(struct inode *inode, struct file *filp)
>  	struct snapshot_data *data;
>  	int error;
>  
> +	if (secure_modules())
> +		return -EPERM;
> +
>  	lock_system_sleep();
>  
>  	if (!atomic_add_unless(&snapshot_device_available, -1, 0)) {

Thanks
Joey Lee


