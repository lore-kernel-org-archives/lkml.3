Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932118AbbAGVE1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 16:04:27 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:34728 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754768AbbAGVEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 16:04:25 -0500
Date: Wed, 7 Jan 2015 13:04:19 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: [PATCH] next: sh: Fix compile error
Message-ID: <20150107210419.GH5280@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1420662748-28129-1-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420662748-28129-1-git-send-email-linux@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15010721-0005-0000-0000-000007D429C0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 07, 2015 at 12:32:28PM -0800, Guenter Roeck wrote:
> Commit a91ed664749c ("kernel: tighten rules for ACCESS ONCE") results in a
> compile failure for sh builds with CONFIG_X2TLB enabled.
> 
> arch/sh/mm/gup.c: In function 'gup_get_pte':
> arch/sh/mm/gup.c:20:2: error: invalid initializer
> make[1]: *** [arch/sh/mm/gup.o] Error 1
> 
> Replace ACCESS_ONCE with READ_ONCE to fix the problem.
> 
> Fixes: a91ed664749c ("kernel: tighten rules for ACCESS ONCE")
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> Cc: Christian Borntraeger <borntraeger@de.ibm.com>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
> Compile tested only.
> 
>  arch/sh/mm/gup.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/sh/mm/gup.c b/arch/sh/mm/gup.c
> index 37458f3..e113bb4 100644
> --- a/arch/sh/mm/gup.c
> +++ b/arch/sh/mm/gup.c
> @@ -17,7 +17,7 @@
>  static inline pte_t gup_get_pte(pte_t *ptep)
>  {
>  #ifndef CONFIG_X2TLB
> -	return ACCESS_ONCE(*ptep);
> +	return READ_ONCE(*ptep);
>  #else
>  	/*
>  	 * With get_user_pages_fast, we walk down the pagetables without
> -- 
> 2.1.0
> 

