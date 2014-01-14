Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751976AbaANTHo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 14:07:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56863 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751951AbaANTHj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 14:07:39 -0500
Message-ID: <1389726456.681.0.camel@flatline.rdu.redhat.com>
Subject: Re: [PATCH 2/2] audit: Convert int limit uses to u32
From: Eric Paris <eparis@redhat.com>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Date: Tue, 14 Jan 2014 14:07:36 -0500
In-Reply-To: <7122d36ffb0d82a660bdf16f0c344d7611a5c1e1.1389724329.git.joe@perches.com>
References: <f4acac9406b7ec15f859215808e72305e6a3a46a.1389724329.git.joe@perches.com>
	 <7122d36ffb0d82a660bdf16f0c344d7611a5c1e1.1389724329.git.joe@perches.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-01-14 at 10:33 -0800, Joe Perches wrote:
> The equivalent uapi struct uses __u32 so make the kernel
> uses u32 too.
> 
> This can prevent some oddities where the limit is
> logged/emitted as a negative value.
> 
> Convert kstrtol to kstrtouint to disallow negative values.


> diff --git a/kernel/audit.c b/kernel/audit.c
> index f397ab2..902c3aa 100644
> --- a/kernel/audit.c
> +++ b/kernel/audit.c
> @@ -79,16 +79,16 @@ static int	audit_initialized;
>  #define AUDIT_OFF	0
>  #define AUDIT_ON	1
>  #define AUDIT_LOCKED	2
> -int		audit_enabled;
> -int		audit_ever_enabled;
> +u32		audit_enabled;
> +u32		audit_ever_enabled;
>  
>  EXPORT_SYMBOL_GPL(audit_enabled);
>  
>  /* Default state when kernel boots without any parameters. */
> -static int	audit_default;
> +u32	audit_default;

Can't figure out why you dropped the static...
I'm putting it back.

>  
>  /* If auditing cannot proceed, audit_failure selects what happens. */
> -static int	audit_failure = AUDIT_FAIL_PRINTK;
> +static u32	audit_failure = AUDIT_FAIL_PRINTK;
>  
>  /*
>   * If audit records are to be written to the netlink socket, audit_pid


