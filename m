Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755848AbaEOWTI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 18:19:08 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:59842 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754758AbaEOWTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 18:19:04 -0400
Message-ID: <53753D54.7040308@gmail.com>
Date: Thu, 15 May 2014 15:19:00 -0700
From: Frank Rowand <frowand.list@gmail.com>
Reply-To: frowand.list@gmail.com
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Grant Likely <grant.likely@linaro.org>
CC: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH 1/3] lib: add glibc style strchrnul() variant
References: <1399993115-21552-1-git-send-email-grant.likely@linaro.org> <1399993115-21552-2-git-send-email-grant.likely@linaro.org>
In-Reply-To: <1399993115-21552-2-git-send-email-grant.likely@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/13/2014 7:58 AM, Grant Likely wrote:
> The strchrnul() variant helpfully returns a the end of the string
> instead of a NULL if the requested character is not found. This can
> simplify string parsing code since it doesn't need to expicitly check
> for a NULL return. If a valid string pointer is passed in, then a valid
> null terminated string will always come back out.
> 
> Signed-off-by: Grant Likely <grant.likely@linaro.org>
> ---
>  include/linux/string.h |  3 +++
>  lib/string.c           | 15 +++++++++++++++
>  2 files changed, 18 insertions(+)
> 
> diff --git a/include/linux/string.h b/include/linux/string.h
> index ac889c5ea11b..d36977e029af 100644
> --- a/include/linux/string.h
> +++ b/include/linux/string.h
> @@ -52,6 +52,9 @@ extern int strncasecmp(const char *s1, const char *s2, size_t n);
>  #ifndef __HAVE_ARCH_STRCHR
>  extern char * strchr(const char *,int);
>  #endif
> +#ifndef __HAVE_ARCH_STRCHRNUL
> +extern char * strchrnul(const char *,int);
> +#endif
>  #ifndef __HAVE_ARCH_STRNCHR
>  extern char * strnchr(const char *, size_t, int);
>  #endif
> diff --git a/lib/string.c b/lib/string.c
> index 9b1f9062a202..059636f92c26 100644
> --- a/lib/string.c
> +++ b/lib/string.c
> @@ -301,6 +301,21 @@ char *strchr(const char *s, int c)
>  EXPORT_SYMBOL(strchr);
>  #endif
>  
> +#ifndef __HAVE_ARCH_STRCHRNUL
> +/**
> + * strchr - Find the first occurrence of a character in a string

s/strchr/strchrnul/

Add to the end of the description: if c is not found in s then return
a pointer to the null byte at the end of s

> + * @s: The string to be searched
> + * @c: The character to search for
> + */
> +char *strchrnul(const char *s, int c)
> +{
> +	while (*s && *s != (char)c)
> +		s++;
> +	return (char *)s;
> +}
> +EXPORT_SYMBOL(strchrnul);
> +#endif
> +
>  #ifndef __HAVE_ARCH_STRRCHR
>  /**
>   * strrchr - Find the last occurrence of a character in a string
> 

