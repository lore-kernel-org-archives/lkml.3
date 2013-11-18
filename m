Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751360Ab3KRObr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 09:31:47 -0500
Received: from mail-we0-f172.google.com ([74.125.82.172]:54170 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640Ab3KRObi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 09:31:38 -0500
Date: Mon, 18 Nov 2013 14:31:35 +0000
From: Andy Whitcroft <apw@canonical.com>
To: Joe Perches <joe@perches.com>
Cc: Gerhard Sittig <gsi@denx.de>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] checkpatch: Fix "Use of uninitialized value" warnings
Message-ID: <20131118143135.GF3126@dm>
References: <20131118114528.GJ17929@book.gsilab.sittig.org>
 <1384782664.5814.17.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384782664.5814.17.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 18, 2013 at 05:51:04AM -0800, Joe Perches wrote:
> checkpatch is currently confused about some complex macros
> and references undefined variables $stat and $cond.
> 
> Make sure these are defined before using them.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  scripts/checkpatch.pl | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index 61090e0..9c981003 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -3289,6 +3289,7 @@ sub process {
>  			}
>  		}
>  		if (!defined $suppress_whiletrailers{$linenr} &&
> +		    defined($stat) && defined($cond) &&
>  		    $line =~ /\b(?:if|while|for)\s*\(/ && $line !~ /^.\s*#/) {
>  			my ($s, $c) = ($stat, $cond);

Seems reasonable indeed.

Acked-by: Andy Whitcroft <apw@canonical.com>

-apw
