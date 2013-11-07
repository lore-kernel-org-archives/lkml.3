Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752940Ab3KGJQF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 04:16:05 -0500
Received: from mail-ee0-f52.google.com ([74.125.83.52]:57459 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802Ab3KGJP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 04:15:59 -0500
Date: Thu, 7 Nov 2013 10:15:55 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Josh Boyer <jwboyer@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, prarit@redhat.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, Russ Anderson <rja@sgi.com>
Subject: Re: [PATCH v3] x86/cpu: Allow higher NR_CPUS values
Message-ID: <20131107091555.GA2671@gmail.com>
References: <20131101141148.GH8652@hansolo.jdub.homelinux.org>
 <20131105143728.GJ9944@hansolo.jdub.homelinux.org>
 <20131106071540.GA3053@gmail.com>
 <20131106152113.GQ9944@hansolo.jdub.homelinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131106152113.GQ9944@hansolo.jdub.homelinux.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Josh Boyer <jwboyer@redhat.com> wrote:

> The current range for SMP configs is 2 - 512 CPUs, or a full 4096 in the 
> case of MAXSMP.  There are machines that have 1024 CPUs in them today 
> and configuring a kernel for that means you are forced to set MAXSMP.  
> This adds additional unnecessary overhead.  While that overhead might be 
> considered tiny for large machines, it isn't necessarily so if you are 
> building a kernel that runs across a wide variety of machines.
> 
> To cover the range of more common machines today, we allow NR_CPUS to be
> up to 4096 when CPUMASK_OFFSTACK is enabled.  Relatedly, we no longer make
> that option depend on DEBUG_PER_CPU_MASKS.

> index b3c8be0..50b47cd 100644
> --- a/lib/Kconfig
> +++ b/lib/Kconfig
> @@ -342,7 +342,8 @@ config CHECK_SIGNATURE
>  	bool
>  
>  config CPUMASK_OFFSTACK
> -	bool "Force CPU masks off stack" if DEBUG_PER_CPU_MAPS
> +	bool "Force CPU masks off stack"
> +	depends on SMP
>  	help
>  	  Use dynamic allocation for cpumask_var_t, instead of putting
>  	  them on the stack.  This is a bit more expensive, but avoids

So this chunk really doesn't belong into the patch - it should be a 
separate patch.

Also, because I already applied the patch (sans the unrelated chunk) 
please only send this single change against tip:master.

Thanks,

	Ingo
