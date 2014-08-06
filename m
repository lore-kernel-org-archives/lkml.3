Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756060AbaHFK0u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 06:26:50 -0400
Received: from mail-ig0-f180.google.com ([209.85.213.180]:55792 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755780AbaHFK0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 06:26:47 -0400
Date: Wed, 6 Aug 2014 11:26:41 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Brian Norris <computersforpeace@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, "Gupta, Pekon\"" <pekon@ti.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-mtd@lists.infradead.org, devicetree@vger.kernel.org,
        Boris BREZILLON <b.brezillon.dev@gmail.com>
Subject: Re: [PATCH] mtd: nand: stm_nand_bch: add new driver
Message-ID: <20140806102641.GB10136@lee--X1>
References: <1401268805-26043-1-git-send-email-lee.jones@linaro.org>
 <20140703002237.GM3599@ld-irv-0074>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140703002237.GM3599@ld-irv-0074>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 02 Jul 2014, Brian Norris wrote:
> On Wed, May 28, 2014 at 10:20:05AM +0100, Lee Jones wrote:

[...]

> > +	if (((unsigned int)buf & (NANDI_BCH_DMA_ALIGNMENT - 1)) ||
> > +	    (!virt_addr_valid(buf))) /* vmalloc'd buffer! */
> > +		bounce = true;
> > +
> > +	p = bounce ? nandi->page_buf : buf;
> 
> It looks like you're reimplementing NAND_USE_BOUNCE_BUFFER. Can you try
> using that flag? (You may need to extend it to account for your DMA
> alignment, too.)

NAND_USE_BOUNCE_BUFFER won't work for us unless we can guarantee that
the bounce buffer will always be 64 Byte aligned, which I don't think
we can.  Another way to do it would be to assign all of our own
buffers, but I'm really not comfortable fiddling with those as there
are a lot of controller specific intricacies which a) I'm not familiar
with and b) no longer have Angus to fire questions off to and/or
review.

So if you don't mind, I'd really rather use Angus' implementation.
It's only an extra couple of lines and Angus has already tested it to
a high level.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
