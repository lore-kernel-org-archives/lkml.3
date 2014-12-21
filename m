Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752520AbaLUHWA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 02:22:00 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:40482 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbaLUHV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 02:21:58 -0500
Date: Sat, 20 Dec 2014 23:21:55 -0800
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Gangadhar Vukkesala <gangs.freelancer@gmail.com>
Cc: akpm@linux-foundation.org, oleg@redhat.com, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kernel: removed unnecessary initialization of static
 variable
Message-ID: <20141221072155.GB10123@hudson.localdomain>
Mail-Followup-To: Jeremiah Mahler <jmmahler@gmail.com>,
	Gangadhar Vukkesala <gangs.freelancer@gmail.com>,
	akpm@linux-foundation.org, oleg@redhat.com, viro@zeniv.linux.org.uk,
	linux-kernel@vger.kernel.org
References: <1419133145-5137-1-git-send-email-gangs.freelancer@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419133145-5137-1-git-send-email-gangs.freelancer@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gangadhar,

On Sun, Dec 21, 2014 at 09:09:05AM +0530, Gangadhar Vukkesala wrote:
> Removed unnecessary initialization of static variable "zero" to 0 
> in pid_namespace.c as default value of static variable is 0.
> This issue was found when running checkpatch.pl script on pid_namespace.c.
> 
> Signed-off-by: Gangadhar Vukkesala <gangs.freelancer@gmail.com>
> ---
>  kernel/pid_namespace.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
> index a65ba13..f21eb3f 100644
> --- a/kernel/pid_namespace.c
> +++ b/kernel/pid_namespace.c
> @@ -290,7 +290,7 @@ static int pid_ns_ctl_handler(struct ctl_table *table, int write,
>  }
>  
>  extern int pid_max;
> -static int zero = 0;
> +static int zero;
>  static struct ctl_table pid_ns_ctl_table[] = {
>  	{
>  		.procname = "ns_last_pid",
> -- 
> Gangadhar Vukkesala
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

Looks good.

Reviewed-by: Jeremiah Mahler <jmmahler@gmail.com>

-- 
- Jeremiah Mahler
