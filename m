Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966136Ab3DRLAR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 07:00:17 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:60549 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965199Ab3DRLAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 07:00:15 -0400
Date: Thu, 18 Apr 2013 12:00:09 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rabin Vincent <rabin@rab.in>, linus.walleij@stericsson.com,
        arnd@arndb.de, Vinod Koul <vinod.koul@intel.com>,
        Per Forlin <per.forlin@stericsson.com>, Dan Williams <djbw@fb.com>
Subject: Re: [PATCH 03/32] dmaengine: ste_dma40: Use the BIT macro to replace
 ugly '(1 << x)'s
Message-ID: <20130418110009.GA27903@gmail.com>
References: <1366279934-30761-1-git-send-email-lee.jones@linaro.org>
 <1366279934-30761-4-git-send-email-lee.jones@linaro.org>
 <20130418104338.GM14496@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130418104338.GM14496@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Apr 2013, Russell King - ARM Linux wrote:

> On Thu, Apr 18, 2013 at 11:11:45AM +0100, Lee Jones wrote:
> > The aim is to make the code that little more readable.
> 
> Maybe we should also invent the MULT() macro too, because a * b is just
> too ugly as well?  Maybe ADD(), SUB() and DIV() macros as well...  Think
> of all those extra parens you could use! :)

Very amusing. :)

I just happen to like this macro.

It's more for tidiness than readability to be honest, but still.

> > @@ -1448,7 +1448,7 @@ static u32 d40_residue(struct d40_chan *d40c)
> >  			  >> D40_SREG_ELEM_PHY_ECNT_POS;
> >  	}
> >  
> > -	return num_elt * (1 << d40c->dma_cfg.dst_info.data_width);
> > +	return num_elt * BIT(d40c->dma_cfg.dst_info.data_width);
> 
> This should be:
> 	return num_elt << d40c->dma_cfg.dst_info.data_width;

Thanks. I'll fixup.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
