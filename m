Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755797Ab3JADsk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 23:48:40 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:40074 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755593Ab3JADsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 23:48:38 -0400
Date: Tue, 1 Oct 2013 12:48:35 +0900
From: Simon Horman <horms@verge.net.au>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH v2] ARM: shmobile: ape6evm: fix incorrect placement of
 __initdata tag
Message-ID: <20131001034831.GA3083@verge.net.au>
References: <1959578.PFsrHiTtYY@amdc1032>
 <27072275.6rIbiFzHY2@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <27072275.6rIbiFzHY2@avalon>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 30, 2013 at 08:31:05PM +0200, Laurent Pinchart wrote:
> On Monday 30 September 2013 17:34:36 Bartlomiej Zolnierkiewicz wrote:
> > __initdata tag should be placed between the variable name and equal
> > sign for the variable to be placed in the intended .init.data section.
> > 
> > Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> 
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Thanks, I will queue this up.

> 
> > ---
> > v2:
> > - use __initdata as it is OK to do it
> > 
> >  arch/arm/mach-shmobile/board-ape6evm.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/arch/arm/mach-shmobile/board-ape6evm.c
> > b/arch/arm/mach-shmobile/board-ape6evm.c index 7627385..8954f55 100644
> > --- a/arch/arm/mach-shmobile/board-ape6evm.c
> > +++ b/arch/arm/mach-shmobile/board-ape6evm.c
> > @@ -86,7 +86,7 @@ static struct gpio_keys_button gpio_buttons[] = {
> >  	GPIO_KEY(KEY_VOLUMEDOWN,	329,	"S21"),
> >  };
> > 
> > -static struct __initdata gpio_keys_platform_data ape6evm_keys_pdata = {
> > +static struct gpio_keys_platform_data ape6evm_keys_pdata __initdata = {
> >  	.buttons	= gpio_buttons,
> >  	.nbuttons	= ARRAY_SIZE(gpio_buttons),
> >  };
> -- 
> Regards,
> 
> Laurent Pinchart
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sh" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
