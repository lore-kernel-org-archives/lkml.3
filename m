Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123Ab3KKNpP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 08:45:15 -0500
Received: from mail-ea0-f177.google.com ([209.85.215.177]:34749 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753735Ab3KKNpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 08:45:03 -0500
Date: Mon, 11 Nov 2013 14:44:59 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/3] panic: setup panic_timeout early
Message-ID: <20131111134459.GA8781@gmail.com>
References: <1383871600-3831-1-git-send-email-felipe.contreras@gmail.com>
 <1383871600-3831-2-git-send-email-felipe.contreras@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383871600-3831-2-git-send-email-felipe.contreras@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Felipe Contreras <felipe.contreras@gmail.com> wrote:

> Otherwise we might not reboot when the user needs it the most (early
> on).
> 
> Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
> ---
>  kernel/panic.c | 14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/panic.c b/kernel/panic.c
> index b6c482c..46e37ff 100644
> --- a/kernel/panic.c
> +++ b/kernel/panic.c
> @@ -468,9 +468,21 @@ EXPORT_SYMBOL(__stack_chk_fail);
>  
>  #endif
>  
> -core_param(panic, panic_timeout, int, 0644);
>  core_param(pause_on_oops, pause_on_oops, int, 0644);
>  
> +static int __init set_panic_timeout(char *str)
> +{
> +	int timeout;
> +
> +	if (!get_option(&str, &timeout))
> +		return -EINVAL;
> +
> +	panic_timeout = timeout;
> +	return 0;
> +}
> +
> +early_param("panic_timeout", set_panic_timeout);
> +

For simple integer parameters simple_strtol() is better and (a tiny bit) 
faster.

Thanks,

	Ingo
