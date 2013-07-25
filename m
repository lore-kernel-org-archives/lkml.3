Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756659Ab3GYQrY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 12:47:24 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:59677 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756382Ab3GYQrV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 12:47:21 -0400
Message-ID: <1374770840.1957.4.camel@joe-AO722>
Subject: Re: [PATCH] dynamic_debug: add wildcard support to filter
 files/functions/modules
From: Joe Perches <joe@perches.com>
To: "Du, Changbin" <changbin.du@gmail.com>
Cc: jbaron@redhat.com, linux-kernel@vger.kernel.org
Date: Thu, 25 Jul 2013 09:47:20 -0700
In-Reply-To: <1374757321-5988-1-git-send-email-changbin.du@gmail.com>
References: <1374757321-5988-1-git-send-email-changbin.du@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-07-25 at 21:02 +0800, Du, Changbin wrote:
> From: "Du, Changbin" <changbin.du@gmail.com>
> 
> This patch add wildcard '*'(matches zero or more characters) and '?'
> (matches one character) support when qurying debug flags.

Seems very useful.  Caveat below.

> diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
[]
> @@ -127,6 +127,21 @@ static void vpr_info_dq(const struct ddebug_query *query, const char *msg)
>  		 query->first_lineno, query->last_lineno);
>  }
>  
> +static int match_pattern(char *pat, char *str)
> +{
> +	switch (*pat) {
> +	case '\0':
> +		return !*str;
> +	case '*':
> +		return  match_pattern(pat+1, str) || 
> +			(*str && match_pattern(pat, str+1));
> +	case '?':
> +		return *str && match_pattern(pat+1, str+1);
> +	default:
> +		return *pat == *str && match_pattern(pat+1, str 1);
> +	}
> +}

What's the maximum length string used today?
On a very long pattern, can this recursion cause stack overflow?

Other than that, I like it.


