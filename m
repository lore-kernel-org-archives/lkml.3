Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756426Ab3DYJPw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 05:15:52 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:34412 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754140Ab3DYJPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 05:15:51 -0400
Date: Thu, 25 Apr 2013 10:15:44 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Per Forlin <per.forlin@stericsson.com>, Rabin Vincent <rabin@rab.in>
Subject: Re: [PATCH 08/32] dmaengine: ste_dma40: Optimise local MAX() macro
Message-ID: <20130425091544.GE4623@gmail.com>
References: <1366279934-30761-1-git-send-email-lee.jones@linaro.org>
 <1366279934-30761-9-git-send-email-lee.jones@linaro.org>
 <CACRpkdZ9j8Xr2-m6KG_Uet6Hft8xx_WJkKUQpi9QwuoE=9H1NA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdZ9j8Xr2-m6KG_Uet6Hft8xx_WJkKUQpi9QwuoE=9H1NA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Apr 2013, Linus Walleij wrote:

> On Thu, Apr 18, 2013 at 12:11 PM, Lee Jones <lee.jones@linaro.org> wrote:
> 
> > The current implementation of the DMA40's local MAX() macro evaluates
> > its arguments more times than is necessary. This patch strips it
> > optimises it to only evaluate what's appropriate.
> >
> > Cc: Vinod Koul <vinod.koul@intel.com>
> > Cc: Dan Williams <djbw@fb.com>
> > Cc: Per Forlin <per.forlin@stericsson.com>
> > Cc: Rabin Vincent <rabin@rab.in>
> > Reported-by: Harvey Harrison <harvey.harrison@gmail.com>
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> (...)
> > -#define MAX(a, b) (((a) < (b)) ? (b) : (a))
> > +#define MAX(a, b) ((a > b) ? a : b)
> 
> Much has been said about this patch already, but notice what it is
> used for instead, one single thing at compile-time:
> 
> struct d40_base {
> (...)
>         u32
> reg_val_backup_v4[MAX(BACKUP_REGS_SZ_V4A, BACKUP_REGS_SZ_V4B)];
> (...)
> };
> 
> i.e. defining the size of that array at compile-time.
> 
> The actual size is figured out in d40_hw_detect_init().
> 
> So what about you just devm_kmalloc() that array instead and
> delete this macro. That is the real fix.

I'm happy to do it, but please see v2 of this patch first.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
