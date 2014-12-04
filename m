Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752589AbaLDALW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 19:11:22 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:37650 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959AbaLDALU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 19:11:20 -0500
Date: Wed, 3 Dec 2014 16:11:16 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        torvalds@linux-foundation.org
Subject: Re: [PATCH 5/9] mips/gup: Replace ACCESS_ONCE with READ_ONCE
Message-ID: <20141204001116.GB25340@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1417645821-54731-1-git-send-email-borntraeger@de.ibm.com>
 <1417645821-54731-6-git-send-email-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417645821-54731-6-git-send-email-borntraeger@de.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120400-0017-0000-0000-000006CBF7FB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 03, 2014 at 11:30:17PM +0100, Christian Borntraeger wrote:
> ACCESS_ONCE does not work reliably on non-scalar types. For
> example gcc 4.6 and 4.7 might remove the volatile tag for such
> accesses during the SRA (scalar replacement of aggregates) step
> https://gcc.gnu.org/bugzilla/show_bug.cgi?id=58145)
> 
> Change the gup code to replace ACCESS_ONCE with READ_ONCE.
> 
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> ---
>  arch/mips/mm/gup.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/mips/mm/gup.c b/arch/mips/mm/gup.c
> index 06ce17c..8aa50e3 100644
> --- a/arch/mips/mm/gup.c
> +++ b/arch/mips/mm/gup.c
> @@ -30,7 +30,7 @@ retry:
> 
>  	return pte;
>  #else
> -	return ACCESS_ONCE(*ptep);
> +	return READ_ONCE(*ptep);
>  #endif
>  }
> 
> -- 
> 1.9.3
> 

