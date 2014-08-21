Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753116AbaHUElc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 00:41:32 -0400
Received: from ozlabs.org ([103.22.144.67]:59668 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780AbaHUElb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 00:41:31 -0400
Message-ID: <1408596086.9307.3.camel@concordia>
Subject: Re: [PATCH] powerpc/pseries: Drop unnecessary continue
From: Michael Ellerman <mpe@ellerman.id.au>
To: Himangi Saraogi <himangi774@gmail.com>
Cc: benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>,
        rcj4747@gmail.com
Date: Thu, 21 Aug 2014 14:41:26 +1000
In-Reply-To: <20140813091847.GA3078@himangi-Dell>
References: <20140813091847.GA3078@himangi-Dell>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-08-13 at 14:48 +0530, Himangi Saraogi wrote:
> Continue is not needed at the bottom of a loop.
 
True.

I wonder though, is the code trying to continue to the outer loop? I stared at
it for a minute but it wasn't obvious.

I wonder if Robert still remembers?

cheers

> diff --git a/arch/powerpc/platforms/pseries/cmm.c b/arch/powerpc/platforms/pseries/cmm.c
> index 2d8bf15..fc44ad0 100644
> --- a/arch/powerpc/platforms/pseries/cmm.c
> +++ b/arch/powerpc/platforms/pseries/cmm.c
> @@ -555,7 +555,6 @@ static int cmm_mem_going_offline(void *arg)
>  				pa_last = pa_last->next;
>  				free_page((unsigned long)cmm_page_list);
>  				cmm_page_list = pa_last;
> -				continue;
>  			}
>  		}
>  		pa_curr = pa_curr->next;


