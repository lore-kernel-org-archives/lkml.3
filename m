Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497Ab3DXPII (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 11:08:08 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:63946 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754230Ab3DXPIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 11:08:06 -0400
Date: Wed, 24 Apr 2013 16:08:01 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Per Forlin <per.forlin@stericsson.com>, Rabin Vincent <rabin@rab.in>
Subject: Re: [PATCH 03/32 v2] dmaengine: ste_dma40: Use the BIT macro to
 replace ugly '(1 << x)'s
Message-ID: <20130424150801.GF9652@gmail.com>
References: <1366279934-30761-1-git-send-email-lee.jones@linaro.org>
 <1366279934-30761-4-git-send-email-lee.jones@linaro.org>
 <20130418121637.GG27903@gmail.com>
 <CACRpkdYCub2GN5okM4NW9E5snwVnGKvnGd02V2qLX=s6R04e9Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdYCub2GN5okM4NW9E5snwVnGKvnGd02V2qLX=s6R04e9Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Apr 2013, Linus Walleij wrote:

> On Thu, Apr 18, 2013 at 2:16 PM, Lee Jones <lee.jones@linaro.org> wrote:
> 
> > The aim is to make the code that little more readable.
> >
> > Cc: Vinod Koul <vinod.koul@intel.com>
> > Cc: Dan Williams <djbw@fb.com>
> > Cc: Per Forlin <per.forlin@stericsson.com>
> > Cc: Rabin Vincent <rabin@rab.in>
> > Acked-by: Arnd Bergmann <arnd@arndb.de>
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> >
> > diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
> > index 3b83dee..ddf5ff1 100644
> > --- a/drivers/dma/ste_dma40.c
> > +++ b/drivers/dma/ste_dma40.c
> > @@ -49,9 +49,9 @@
> >  #define MAX_LCLA_ALLOC_ATTEMPTS 256
> >
> >  /* Bit markings for allocation map */
> > -#define D40_ALLOC_FREE         (1 << 31)
> > -#define D40_ALLOC_PHY          (1 << 30)
> > -#define D40_ALLOC_LOG_FREE     0
> > +#define D40_ALLOC_FREE         BIT(31)
> > +#define D40_ALLOC_PHY          BIT(30)
> > +#define D40_ALLOC_LOG_FREE     BIT(0)
> 
> No. 0 != BIT(0)
> 
> Please fix this...

Good spot.

I've already fixed this though.

I'll send it as a v3 now.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
