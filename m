Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933970Ab3CNQjE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 12:39:04 -0400
Received: from mail.active-venture.com ([67.228.131.205]:62637 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932487Ab3CNQjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 12:39:02 -0400
X-Originating-IP: 108.223.40.66
Date: Thu, 14 Mar 2013 09:39:04 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Joe Perches <joe@perches.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@canonical.com>, Jean Delvare <khali@linux-fr.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] checkpatch: Add check for reuse of krealloc arg
Message-ID: <20130314163904.GA11384@roeck-us.net>
References: <1363267820.4853.41.camel@i7.infradead.org>
 <1363277885.2146.3.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1363277885.2146.3.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 14, 2013 at 09:18:05AM -0700, Joe Perches wrote:
> On Thu, 2013-03-14 at 13:30 +0000, David Woodhouse wrote:
> > If krealloc() returns NULL, it *doesn't* free the original. So any code
> > of the form 'foo = krealloc(foo, …);' is almost certainly a bug.
> 
> So add a check for it to checkpatch.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Excellent idea.

Tested-by: Guenter Roeck <linux@roeck-us.net>
Acked-by: Guenter Roeck <linux@roeck-us.net>

> ---
>  scripts/checkpatch.pl | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index b28cc38..7ef2b4b 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -3476,6 +3476,13 @@ sub process {
>  			     "unnecessary cast may hide bugs, see http://c-faq.com/malloc/mallocnocast.html\n" . $herecurr);
>  		}
>  
> +# check for krealloc arg reuse
> +		if ($^V && $^V ge 5.10.0 &&
> +		    $line =~ /\b($Lval)\s*\=\s*(?:$balanced_parens)?\s*krealloc\s*\(\s*\1\s*,/) {
> +			WARN("KREALLOC_ARG_REUSE",
> +			     "Reusing the krealloc arg is almost always a bug\n" . $herecurr);
> +		}
> +
>  # check for alloc argument mismatch
>  		if ($line =~ /\b(kcalloc|kmalloc_array)\s*\(\s*sizeof\b/) {
>  			WARN("ALLOC_ARRAY_ARGS",
> 
> 
> 
