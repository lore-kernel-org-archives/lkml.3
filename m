Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752098AbaEVVPx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 17:15:53 -0400
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:58937 "EHLO
	relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbaEVVPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 17:15:52 -0400
X-Originating-IP: 173.246.103.110
Date: Thu, 22 May 2014 14:15:43 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] rcutorture: avoid format string leak to thead name
Message-ID: <20140522211543.GA11775@jtriplet-mobl1>
References: <20140522185104.GA8674@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140522185104.GA8674@www.outflux.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2014 at 11:51:04AM -0700, Kees Cook wrote:
> Since the rcutorture thread creation interface does not include format
> string arguments, make sure the name can never be accidentally processed
> as a format string.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

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
