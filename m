Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758964Ab3CECcL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 21:32:11 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:50542 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579Ab3CECcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 21:32:09 -0500
Date: Tue, 5 Mar 2013 11:32:06 +0900
From: Simon Horman <horms@verge.net.au>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: Eric Biederman <ebiederm@xmission.com>, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kexec: consolidate crash late initialization
Message-ID: <20130305023206.GL16128@verge.net.au>
References: <1338372309-24983-1-git-send-email-vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338372309-24983-1-git-send-email-vdavydov@parallels.com>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2012 at 02:05:09PM +0400, Vladimir Davydov wrote:
> Use one module_init() instead of two.

I'm not sure I understand the motivation for this change.

> ---
>  kernel/kexec.c |    9 +++++++--
>  1 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/kexec.c b/kernel/kexec.c
> index 4e2e472..c3341cb 100644
> --- a/kernel/kexec.c
> +++ b/kernel/kexec.c
> @@ -1240,7 +1240,6 @@ static int __init crash_notes_memory_init(void)
>  	}
>  	return 0;
>  }
> -module_init(crash_notes_memory_init)
>  
>  
>  /*
> @@ -1520,7 +1519,13 @@ static int __init crash_save_vmcoreinfo_init(void)
>  	return 0;
>  }
>  
> -module_init(crash_save_vmcoreinfo_init)
> +static int __init crash_init(void)
> +{
> +	crash_notes_memory_init();
> +	crash_save_vmcoreinfo_init();
> +	return 0;
> +}
> +module_init(crash_init)
>  
>  /*
>   * Move into place and start executing a preloaded standalone
> -- 
> 1.7.1
> 
> 
> _______________________________________________
> kexec mailing list
> kexec@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kexec
> 
