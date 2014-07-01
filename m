Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752443AbaGAAwL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 20:52:11 -0400
Received: from ozlabs.org ([103.22.144.67]:49335 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750996AbaGAAwJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 20:52:09 -0400
Message-ID: <1404175926.30002.1.camel@concordia>
Subject: Re: [PATCH] powerpc/powernv: Check for IRQHAPPENED before sleeping
From: Michael Ellerman <mpe@ellerman.id.au>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: benh@kernel.crashing.org, mikey@neuling.org, shreyas@linux.vnet.ibm.com,
        svaidy@linux.vnet.ibm.com, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Date: Tue, 01 Jul 2014 10:52:06 +1000
In-Reply-To: <20140630062404.29315.23382.stgit@preeti.in.ibm.com>
References: <20140630062404.29315.23382.stgit@preeti.in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-06-30 at 11:54 +0530, Preeti U Murthy wrote:
> Commit 8d6f7c5a: "powerpc/powernv: Make it possible to skip the IRQHAPPENED
> check in power7_nap()" added code that prevents even cores which enter sleep
> on idle, from checking for pending interrupts. Fix this.

To be clear, it is a bug in the original commit. Mikey and I pair programmed
that code, and he was *definitely* typing at that point ;)

Can you please include in the changelog what the symptom of the bug is, and
have you seen it in practice?

The bad commit went into 3.16-rc1, so we don't need to backport this to any
stable release.

cheers

> diff --git a/arch/powerpc/kernel/idle_power7.S b/arch/powerpc/kernel/idle_power7.S
> index 2480256..5cf3d36 100644
> --- a/arch/powerpc/kernel/idle_power7.S
> +++ b/arch/powerpc/kernel/idle_power7.S
> @@ -131,7 +131,7 @@ _GLOBAL(power7_nap)
>  
>  _GLOBAL(power7_sleep)
>  	li	r3,1
> -	li	r4,0
> +	li	r4,1
>  	b	power7_powersave_common
>  	/* No return */
>  
> 





