Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372AbaJVOBD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 10:01:03 -0400
Received: from mga01.intel.com ([192.55.52.88]:19786 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753308AbaJVOA7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 10:00:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,769,1406617200"; 
   d="scan'208";a="618527077"
Message-ID: <1413986270.2396.34.camel@linux.intel.com>
Subject: Re: [PATCH 2/2] perf tools: substitute yet another strtoull()
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Date: Wed, 22 Oct 2014 16:57:50 +0300
In-Reply-To: <1404474229-15272-2-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1404474229-15272-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1404474229-15272-2-git-send-email-andriy.shevchenko@linux.intel.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.6-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-07-04 at 14:43 +0300, Andy Shevchenko wrote:
> Instead of home grown function let's use what library provides us.
> 

Any comments on this? Should I resend it?

> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  tools/perf/util/util.c | 24 ++----------------------
>  1 file changed, 2 insertions(+), 22 deletions(-)
> 
> diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
> index e4132ae..861e16e 100644
> --- a/tools/perf/util/util.c
> +++ b/tools/perf/util/util.c
> @@ -206,35 +206,15 @@ size_t hex_width(u64 v)
>  	return n;
>  }
>  
> -static int hex(char ch)
> -{
> -	if ((ch >= '0') && (ch <= '9'))
> -		return ch - '0';
> -	if ((ch >= 'a') && (ch <= 'f'))
> -		return ch - 'a' + 10;
> -	if ((ch >= 'A') && (ch <= 'F'))
> -		return ch - 'A' + 10;
> -	return -1;
> -}
> -
>  /*
>   * While we find nice hex chars, build a long_val.
>   * Return number of chars processed.
>   */
>  int hex2u64(const char *ptr, u64 *long_val)
>  {
> -	const char *p = ptr;
> -	*long_val = 0;
> -
> -	while (*p) {
> -		const int hex_val = hex(*p);
> +	char *p;
>  
> -		if (hex_val < 0)
> -			break;
> -
> -		*long_val = (*long_val << 4) | hex_val;
> -		p++;
> -	}
> +	*long_val = strtoull(ptr, &p, 16);
>  
>  	return p - ptr;
>  }


-- 
Andy Shevchenko <andriy.shevchenko@intel.com>
Intel Finland Oy

