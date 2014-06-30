Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752364AbaF3OBL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 10:01:11 -0400
Received: from ozlabs.org ([103.22.144.67]:39124 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750897AbaF3OBJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 10:01:09 -0400
Message-ID: <1404136867.18325.8.camel@ale.ozlabs.ibm.com>
Subject: Re: [PATCH] powerpc/powernv: Check for IRQHAPPENED before sleeping
From: Michael Neuling <mikey@neuling.org>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: benh@kernel.crashing.org, mpe@ellerman.id.au, shreyas@linux.vnet.ibm.com,
        svaidy@linux.vnet.ibm.com, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Date: Mon, 30 Jun 2014 09:01:07 -0500
In-Reply-To: <20140630062404.29315.23382.stgit@preeti.in.ibm.com>
References: <20140630062404.29315.23382.stgit@preeti.in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-06-30 at 11:54 +0530, Preeti U Murthy wrote:
> Commit 8d6f7c5a: "powerpc/powernv: Make it possible to skip the IRQHAPPENED
> check in power7_nap()" added code that prevents even cores which enter sleep
> on idle, from checking for pending interrupts. Fix this.
> 
> Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>

Acked-by: Michael Neuling <mikey@neuling.org>

> ---
> 
>  arch/powerpc/kernel/idle_power7.S |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
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

