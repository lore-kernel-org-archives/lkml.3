Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167AbaFMV7G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 17:59:06 -0400
Received: from mail-ig0-f177.google.com ([209.85.213.177]:53998 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754143AbaFMV7C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 17:59:02 -0400
Date: Fri, 13 Jun 2014 14:58:59 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH v4] lib: add size unit t/p/e to memparse
In-Reply-To: <1402623746-1171-1-git-send-email-guihc.fnst@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.02.1406131457480.31981@chino.kir.corp.google.com>
References: <1402623746-1171-1-git-send-email-guihc.fnst@cn.fujitsu.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jun 2014, Gui Hecheng wrote:

> diff --git a/lib/cmdline.c b/lib/cmdline.c
> index d4932f7..76a712e 100644
> --- a/lib/cmdline.c
> +++ b/lib/cmdline.c
> @@ -121,11 +121,7 @@ EXPORT_SYMBOL(get_options);
>   *	@retptr: (output) Optional pointer to next char after parse completes
>   *
>   *	Parses a string into a number.  The number stored at @ptr is
> - *	potentially suffixed with %K (for kilobytes, or 1024 bytes),
> - *	%M (for megabytes, or 1048576 bytes), or %G (for gigabytes, or
> - *	1073741824).  If the number is suffixed with K, M, or G, then
> - *	the return value is the number multiplied by one kilobyte, one
> - *	megabyte, or one gigabyte, respectively.
> + *	potentially suffixed with K, M, G, T, P, E.
>   */
>  
>  unsigned long long memparse(const char *ptr, char **retptr)
> @@ -135,6 +131,15 @@ unsigned long long memparse(const char *ptr, char **retptr)
>  	unsigned long long ret = simple_strtoull(ptr, &endptr, 0);
>  
>  	switch (*endptr) {
> +	case 'E':
> +	case 'e':
> +		ret <<= 10;
> +	case 'P':
> +	case 'p':
> +		ret <<= 10;
> +	case 'T':
> +	case 't':
> +		ret <<= 10;
>  	case 'G':
>  	case 'g':
>  		ret <<= 10;

Seems fine since unsigned long long is always at least 64 bits, but 
perhaps also change simple_strtoull() to use kstrtoull() at the same time 
since the former is deprecated?
