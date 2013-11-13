Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757354Ab3KMAEG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 19:04:06 -0500
Received: from mail-ee0-f52.google.com ([74.125.83.52]:46649 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754169Ab3KMAEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 19:04:01 -0500
Date: Wed, 13 Nov 2013 01:03:58 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2] panic: setup panic_timeout early
Message-ID: <20131113000358.GA2420@gmail.com>
References: <1384180814-21823-1-git-send-email-felipe.contreras@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384180814-21823-1-git-send-email-felipe.contreras@gmail.com>
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
> 
[...]
>
> diff --git a/kernel/panic.c b/kernel/panic.c
> index b6c482c..d865263 100644
> --- a/kernel/panic.c
> +++ b/kernel/panic.c
> @@ -468,9 +468,23 @@ EXPORT_SYMBOL(__stack_chk_fail);
>  
>  #endif
>  
> -core_param(panic, panic_timeout, int, 0644);
>  core_param(pause_on_oops, pause_on_oops, int, 0644);
>  
> +static int __init set_panic_timeout(char *val)
> +{
> +	long timeout;
> +	int ret;
> +
> +	ret = kstrtol(val, 0, &timeout);
> +	if (ret < 0)
> +		return ret;
> +
> +	panic_timeout = timeout;
> +	return 0;
> +}

I think the type of the 'timeout' local variable should match the type of 
'panic_timeout' (which is 'int', not 'long').

Thanks,

	Ingo
