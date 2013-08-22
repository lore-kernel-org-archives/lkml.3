Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753146Ab3HVOXu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 10:23:50 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42442 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416Ab3HVOXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 10:23:48 -0400
Date: Thu, 22 Aug 2013 15:23:39 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Tushar Behera <tushar.behera@linaro.org>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@redhat.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Kevin Hilman <khilman@linaro.org>
Subject: Re: Linking failure on linux-next with arm allyesconfig
Message-ID: <20130822142339.GI6617@n2100.arm.linux.org.uk>
References: <CAHbNUh2MXZhg7L8BN9ds17rmg8ueo6d8CJhRMgy6fK-xn7qRoQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHbNUh2MXZhg7L8BN9ds17rmg8ueo6d8CJhRMgy6fK-xn7qRoQ@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm not sure why you're sending this to ARM people as I don't believe we
are the ones responsible for this breakage, neither have we had any
visibility of this breakage coming up.

>From what I can see, the mainline state is that we reference user_exit
when CONTEXT_TRACKING is enabled, and kernel/context_tracking.c is
built also when this symbol is enabled, and that file provides
user_exit() and user_entry().

If these two functions have been removed without our knowledge, it is
because someone is not following correct procedure when making changes
to the kernel source.  Using grep to find users of the symbols that
they're removing for example, and copying those who may be affected by
those changes with the patch etc.

If you are going to be spending time running build tests and reporting
breakage, can you also please spend the time to diagnose the cause of
the breakage so you can target your reports a little better.  Thanks.

On Thu, Aug 22, 2013 at 07:38:15PM +0530, Tushar Behera wrote:
> Hi,
> 
> With ARCH=arm 'allyesconfig' on next-20130822, following linking error
> is observed.
> 
> arch/arm/kernel/built-in.o: In function `ret_fast_syscall':
> /home/tushar/work/lt_devel/staging-tree/linux-next/arch/arm/kernel/entry-common.S:42:
> undefined reference to `user_enter'
> arch/arm/kernel/built-in.o: In function `no_work_pending':
> /home/tushar/work/lt_devel/staging-tree/linux-next/arch/arm/kernel/entry-common.S:77:
> undefined reference to `user_enter'
> arch/arm/kernel/built-in.o: In function `vector_swi':
> /home/tushar/work/lt_devel/staging-tree/linux-next/arch/arm/kernel/entry-common.S:376:
> undefined reference to `user_exit'
> arch/arm/kernel/built-in.o: In function `__dabt_usr':
> /home/tushar/work/lt_devel/staging-tree/linux-next/arch/arm/kernel/entry-armv.S:365:
> undefined reference to `user_exit'
> arch/arm/kernel/built-in.o: In function `__irq_usr':
> /home/tushar/work/lt_devel/staging-tree/linux-next/arch/arm/kernel/entry-armv.S:375:
> undefined reference to `user_exit'
> arch/arm/kernel/built-in.o: In function `__und_usr':
> /home/tushar/work/lt_devel/staging-tree/linux-next/arch/arm/kernel/entry-armv.S:388:
> undefined reference to `user_exit'
> arch/arm/kernel/built-in.o: In function `__pabt_usr':
> /home/tushar/work/lt_devel/staging-tree/linux-next/arch/arm/kernel/entry-armv.S:662:
> undefined reference to `user_exit'
> 
> -- 
> Tushar Behera
