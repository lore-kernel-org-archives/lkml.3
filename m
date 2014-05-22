Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752448AbaEVT4g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 15:56:36 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:45888 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146AbaEVT4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 15:56:35 -0400
Date: Thu, 22 May 2014 12:56:29 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Josh Triplett <josh@joshtriplett.org>
Subject: Re: [PATCH] rcutorture: avoid format string leak to thead name
Message-ID: <20140522195629.GX4570@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140522185104.GA8674@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140522185104.GA8674@www.outflux.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14052219-0928-0000-0000-00000218A9C5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2014 at 11:51:04AM -0700, Kees Cook wrote:
> Since the rcutorture thread creation interface does not include format
> string arguments, make sure the name can never be accidentally processed
> as a format string.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>

Queued for 3.17, thank you, Kees!

							Thanx, Paul

> ---
>  kernel/torture.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/torture.c b/kernel/torture.c
> index acc9afc2f26e..9dad2ffaf995 100644
> --- a/kernel/torture.c
> +++ b/kernel/torture.c
> @@ -694,7 +694,7 @@ int _torture_create_kthread(int (*fn)(void *arg), void *arg, char *s, char *m,
>  	int ret = 0;
> 
>  	VERBOSE_TOROUT_STRING(m);
> -	*tp = kthread_run(fn, arg, s);
> +	*tp = kthread_run(fn, arg, "%s", s);
>  	if (IS_ERR(*tp)) {
>  		ret = PTR_ERR(*tp);
>  		VERBOSE_TOROUT_ERRSTRING(f);
> -- 
> 1.7.9.5
> 
> 
> -- 
> Kees Cook
> Chrome OS Security
> 

