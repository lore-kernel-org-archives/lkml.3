Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934196Ab3IDApt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 20:45:49 -0400
Received: from tundra.namei.org ([65.99.196.166]:34541 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761445Ab3IDAps (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 20:45:48 -0400
Date: Wed, 4 Sep 2013 10:47:19 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Matthew Garrett <matthew.garrett@nebula.com>
cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        keescook@chromium.org, hpa@zytor.com
Subject: Re: [PATCH V3 06/11] Restrict /dev/mem and /dev/kmem when module
 loading is restricted
In-Reply-To: <1378252218-18798-7-git-send-email-matthew.garrett@nebula.com>
Message-ID: <alpine.LRH.2.02.1309041047110.20116@tundra.namei.org>
References: <1378252218-18798-1-git-send-email-matthew.garrett@nebula.com> <1378252218-18798-7-git-send-email-matthew.garrett@nebula.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Sep 2013, Matthew Garrett wrote:

> Allowing users to write to address space makes it possible for the kernel
> to be subverted, avoiding module loading restrictions. Prevent this when
> any restrictions have been imposed on loading modules.
> 
> Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>


Reviewed-by: James Morris <jmorris@namei.org>



> ---
>  drivers/char/mem.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/char/mem.c b/drivers/char/mem.c
> index 1af8664..61406c8 100644
> --- a/drivers/char/mem.c
> +++ b/drivers/char/mem.c
> @@ -159,6 +159,9 @@ static ssize_t write_mem(struct file *file, const char __user *buf,
>  	unsigned long copied;
>  	void *ptr;
>  
> +	if (secure_modules())
> +		return -EPERM;
> +
>  	if (!valid_phys_addr_range(p, count))
>  		return -EFAULT;
>  
> @@ -497,6 +500,9 @@ static ssize_t write_kmem(struct file *file, const char __user *buf,
>  	char *kbuf; /* k-addr because vwrite() takes vmlist_lock rwlock */
>  	int err = 0;
>  
> +	if (secure_modules())
> +		return -EPERM;
> +
>  	if (p < (unsigned long) high_memory) {
>  		unsigned long to_write = min_t(unsigned long, count,
>  					       (unsigned long)high_memory - p);
> -- 
> 1.8.3.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
James Morris
<jmorris@namei.org>
