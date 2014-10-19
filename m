Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751700AbaJSPk4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 11:40:56 -0400
Received: from asavdk4.altibox.net ([109.247.116.15]:37815 "EHLO
	asavdk4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109AbaJSPky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 11:40:54 -0400
X-Greylist: delayed 496 seconds by postgrey-1.27 at vger.kernel.org; Sun, 19 Oct 2014 11:40:53 EDT
Date: Sun, 19 Oct 2014 17:32:20 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: David Miller <davem@davemloft.net>
Cc: mroos@linux.ee, iamjoonsoo.kim@lge.com, linux-kernel@vger.kernel.org,
        cl@linux.com, penberg@kernel.org, rientjes@google.com,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        sparclinux@vger.kernel.org
Subject: Re: unaligned accesses in SLAB etc.
Message-ID: <20141019153219.GA10644@ravnborg.org>
References: <20141016.165017.1151349565275102498.davem@davemloft.net>
 <alpine.LRH.2.11.1410171410210.25429@adalberg.ut.ee>
 <20141018.135907.356113264227709132.davem@davemloft.net>
 <20141018.142335.1935310766779155342.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141018.142335.1935310766779155342.davem@davemloft.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 18, 2014 at 02:23:35PM -0400, David Miller wrote:
> From: David Miller <davem@davemloft.net>
> Date: Sat, 18 Oct 2014 13:59:07 -0400 (EDT)
> 
> > I don't want to define the array size of the fpregs save area
> > explicitly and thereby placing an artificial limit there.
> 
> Nevermind, it seems we have a hard limit of 7 FPU save areas anyways.
> 
> Meelis, please try this patch:
> 
> diff --git a/arch/sparc/include/asm/thread_info_64.h b/arch/sparc/include/asm/thread_info_64.h
> index f85dc85..cc6275c 100644
> --- a/arch/sparc/include/asm/thread_info_64.h
> +++ b/arch/sparc/include/asm/thread_info_64.h
> @@ -63,7 +63,8 @@ struct thread_info {
>  	struct pt_regs		*kern_una_regs;
>  	unsigned int		kern_una_insn;
>  
> -	unsigned long		fpregs[0] __attribute__ ((aligned(64)));
> +	unsigned long		fpregs[(7 * 256) / sizeof(unsigned long)]

This part:

> +		__attribute__ ((aligned(64)));

Could be written as __aligned(64)

	Sam
