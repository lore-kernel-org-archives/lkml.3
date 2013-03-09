Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751523Ab3CIUSz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Mar 2013 15:18:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57289 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751327Ab3CIUSy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Mar 2013 15:18:54 -0500
Date: Sat, 9 Mar 2013 21:17:04 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Cc: lucas.de.marchi@gmail.com, David Howells <dhowells@redhat.com>,
        James Morris <james.l.morris@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/7] kernel/sys.c: Use the simpler
	call_usermodehelper()
Message-ID: <20130309201704.GA16399@redhat.com>
References: <1362723313-839-1-git-send-email-lucas.demarchi@profusion.mobi> <1362723313-839-2-git-send-email-lucas.demarchi@profusion.mobi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362723313-839-2-git-send-email-lucas.demarchi@profusion.mobi>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08, Lucas De Marchi wrote:
>
> Commit "7ff6764 usermodehelper: cleanup/fix __orderly_poweroff() &&
> argv_free()" simplified __orderly_poweroff() removing the need to use
> call_usermodehelper_fns().
>
> Since we are not passing any callback, it's simpler to use
> call_usermodehelper().
>
> Signed-off-by: Lucas De Marchi <lucas.demarchi@profusion.mobi>

Reviewed-by: Oleg Nesterov <oleg@redhat.com>

> ---
>  kernel/sys.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/kernel/sys.c b/kernel/sys.c
> index 81f5644..bd15276 100644
> --- a/kernel/sys.c
> +++ b/kernel/sys.c
> @@ -2203,8 +2203,7 @@ static int __orderly_poweroff(void)
>  		return -ENOMEM;
>  	}
>  
> -	ret = call_usermodehelper_fns(argv[0], argv, envp, UMH_WAIT_EXEC,
> -				      NULL, NULL, NULL);
> +	ret = call_usermodehelper(argv[0], argv, envp, UMH_WAIT_EXEC);
>  	argv_free(argv);
>  
>  	return ret;
> -- 
> 1.8.1.5
> 

