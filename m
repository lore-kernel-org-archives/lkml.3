Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755195Ab3DVKx7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 06:53:59 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:40304 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241Ab3DVKx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 06:53:58 -0400
Date: Mon, 22 Apr 2013 11:53:53 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Vinod Koul <vinod.koul@intel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com,
        Dan Williams <djbw@fb.com>, Per Forlin <per.forlin@stericsson.com>,
        Rabin Vincent <rabin@rab.in>
Subject: Re: [PATCH 08/32] dmaengine: ste_dma40: Optimise local MAX() macro
Message-ID: <20130422105353.GN3432@gmail.com>
References: <1366279934-30761-1-git-send-email-lee.jones@linaro.org>
 <1366279934-30761-9-git-send-email-lee.jones@linaro.org>
 <20130422101029.GP24632@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130422101029.GP24632@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Apr 2013, Vinod Koul wrote:

> On Thu, Apr 18, 2013 at 11:11:50AM +0100, Lee Jones wrote:
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
> > ---
> >  drivers/dma/ste_dma40.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
> > index b21a8a3..7b451b2 100644
> > --- a/drivers/dma/ste_dma40.c
> > +++ b/drivers/dma/ste_dma40.c
> > @@ -53,7 +53,7 @@
> >  #define D40_ALLOC_PHY		BIT(30)
> >  #define D40_ALLOC_LOG_FREE	BIT(0)
> >  
> > -#define MAX(a, b) (((a) < (b)) ? (b) : (a))
> > +#define MAX(a, b) ((a > b) ? a : b)
> Am not a big fan of own redefines, can you use kernel max() macro instead

Unfortunately not in this instance, as the kernel max() macro uses
curly braces and is not suitable for this use-case. There is a thread
regarding this on the MLs with Arnd Bergmann, Russell King and myself.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
