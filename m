Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936704Ab3DRWdu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 18:33:50 -0400
Received: from mga14.intel.com ([143.182.124.37]:54014 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936545Ab3DRWdt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 18:33:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,504,1363158000"; 
   d="scan'208";a="229028501"
Date: Fri, 19 Apr 2013 00:33:44 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, Anmar Oueja <anmar.oueja@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v3] MFD: ab8500: pass AB8500 IRQ to debugfs code by
 resource
Message-ID: <20130418223344.GB8798@zurbaran>
References: <1366012021-9039-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366012021-9039-1-git-send-email-linus.walleij@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Mon, Apr 15, 2013 at 09:47:01AM +0200, Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> The AB8500 debug code which was merged in parallel with the
> multiplatform work incidentally introduced a new instance using
> the <mach/irqs.h> header which is now deleted, causing this
> build regression:
> 
> drivers/mfd/ab8500-debugfs.c:95:23:
> fatal error: mach/irqs.h: No such file or directory
> compilation terminated.
> make[4]: *** [drivers/mfd/ab8500-debugfs.o] Error 1
> 
> The code most certainly never worked with device tree either
> since that does not rely on this kind of hard-coded interrupt
> numbers.
> 
> Fix the problem at the root by passing it as a named resource
> from the ab8500-core driver. Use an untyped resource to
> stop the MFD core from remapping this IRQ relative to the
> AB8500 irqdomain.
> 
> Cc: Arnd Bergmann <arnd@arndb.de>
> Acked-by: Lee Jones <lee.jones@linaro.org>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> ChangeLov v2->v3:
> - Fix typos.
> ChangeLog v1->v2:
> - Pass an untyped resource to avoid problems due to IRQ
>   remapping.
> 
> Sam this would have to go into the v3.10-targetted stuff...
> Either immediately before you send it upstream or as a fixup.
I usually try to send one single pull request during the merge window, so I'll
add this one to my 3.10 MFD fixup pull request.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
