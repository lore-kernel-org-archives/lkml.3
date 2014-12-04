Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572AbaLDAK5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 19:10:57 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:37545 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430AbaLDAK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 19:10:56 -0500
Date: Wed, 3 Dec 2014 16:10:51 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        torvalds@linux-foundation.org
Subject: Re: [PATCH 4/9] x86/gup: Replace ACCESS_ONCE with READ_ONCE
Message-ID: <20141204001051.GA25340@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1417645821-54731-1-git-send-email-borntraeger@de.ibm.com>
 <1417645821-54731-5-git-send-email-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417645821-54731-5-git-send-email-borntraeger@de.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120400-0017-0000-0000-000006CBF797
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 03, 2014 at 11:30:16PM +0100, Christian Borntraeger wrote:
> ACCESS_ONCE does not work reliably on non-scalar types. For
> example gcc 4.6 and 4.7 might remove the volatile tag for such
> accesses during the SRA (scalar replacement of aggregates) step
> (https://gcc.gnu.org/bugzilla/show_bug.cgi?id=58145)
> 
> Change the gup code to replace ACCESS_ONCE with READ_ONCE.
> 
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> ---
>  arch/x86/mm/gup.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/mm/gup.c b/arch/x86/mm/gup.c
> index 207d9aef..d754782 100644
> --- a/arch/x86/mm/gup.c
> +++ b/arch/x86/mm/gup.c
> @@ -15,7 +15,7 @@
>  static inline pte_t gup_get_pte(pte_t *ptep)
>  {
>  #ifndef CONFIG_X86_PAE
> -	return ACCESS_ONCE(*ptep);
> +	return READ_ONCE(*ptep);
>  #else
>  	/*
>  	 * With get_user_pages_fast, we walk down the pagetables without taking
> -- 
> 1.9.3
> 

