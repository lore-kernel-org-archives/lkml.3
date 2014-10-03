Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751931AbaJCMDx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 08:03:53 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:48203 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbaJCMDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 08:03:50 -0400
Date: Fri, 3 Oct 2014 14:03:45 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: Why do we still have 32 bit counters? Interrupt counters
 overflow within 50 days
Message-ID: <20141003120345.GA6652@localhost.localdomain>
References: <alpine.DEB.2.11.1410030435260.8324@gentwo.org>
 <alpine.DEB.2.11.1410031231420.4383@nanos>
 <alpine.DEB.2.11.1410030653040.8496@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1410030653040.8496@gentwo.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 03, 2014 at 06:54:22AM -0500, Christoph Lameter wrote:
> Subject: Increase irq counters to 64 bit

...

> Index: linux/arch/x86/include/asm/processor.h
> ===================================================================
> --- linux.orig/arch/x86/include/asm/processor.h
> +++ linux/arch/x86/include/asm/processor.h
> @@ -432,7 +432,7 @@ DECLARE_PER_CPU_FIRST(union irq_stack_un
>  DECLARE_INIT_PER_CPU(irq_stack_union);
> 
>  DECLARE_PER_CPU(char *, irq_stack_ptr);
> -DECLARE_PER_CPU(unsigned int, irq_count);
> +DECLARE_PER_CPU(unsigned long, irq_count);

Still 32 bit on 32 bit machines...

Thanks,
Richard
