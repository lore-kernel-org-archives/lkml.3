Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822AbaJWXup (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 19:50:45 -0400
Received: from galahad.ideasonboard.com ([185.26.127.97]:44330 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754554AbaJWXun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 19:50:43 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Michal Nazarewicz <mina86@mina86.com>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-sh@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Re: [PATCH 2/4] mm: cma: Always consider a 0 base address reservation as dynamic
Date: Fri, 24 Oct 2014 02:50:42 +0300
Message-ID: <3165257.hQsT1mEnTD@avalon>
User-Agent: KMail/4.12.5 (Linux/3.14.14-gentoo; KDE/4.12.5; x86_64; ; )
In-Reply-To: <xa1tk33qlo93.fsf@mina86.com>
References: <1414074828-4488-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <1414074828-4488-3-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <xa1tk33qlo93.fsf@mina86.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal,

On Thursday 23 October 2014 18:55:20 Michal Nazarewicz wrote:
> On Thu, Oct 23 2014, Laurent Pinchart wrote:
> > The fixed parameter to cma_declare_contiguous() tells the function
> > whether the given base address must be honoured or should be considered
> > as a hint only. The API considers a zero base address as meaning any
> > base address, which must never be considered as a fixed value.
> > 
> > Part of the implementation correctly checks both fixed and base != 0,
> > but two locations check the fixed value only. Set fixed to false when
> > base is 0 to fix that and simplify the code.
> > 
> > Signed-off-by: Laurent Pinchart
> > <laurent.pinchart+renesas@ideasonboard.com>
> 
> Acked-by: Michal Nazarewicz <mina86@mina86.com>
> 
> And like before, this should also probably also go to stable.

v3.17 and older don't have the extra fixed checks, so I don't think there's a 
need to Cc stable.

> > ---
> > 
> >  mm/cma.c | 5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> > 
> > diff --git a/mm/cma.c b/mm/cma.c
> > index 16c6650..6b14346 100644
> > --- a/mm/cma.c
> > +++ b/mm/cma.c
> > @@ -239,6 +239,9 @@ int __init cma_declare_contiguous(phys_addr_t base,
> >  	size = ALIGN(size, alignment);
> >  	limit &= ~(alignment - 1);
> > 
> > +	if (!base)
> > +		fixed = false;
> > +
> >  	/* size should be aligned with order_per_bit */
> >  	if (!IS_ALIGNED(size >> PAGE_SHIFT, 1 << order_per_bit))
> >  		return -EINVAL;
> > @@ -262,7 +265,7 @@ int __init cma_declare_contiguous(phys_addr_t base,
> >  	}
> >  	
> >  	/* Reserve memory */
> > -	if (base && fixed) {
> > +	if (fixed) {
> >  		if (memblock_is_region_reserved(base, size) ||
> >  		    memblock_reserve(base, size) < 0) {
> >  			ret = -EBUSY;

-- 
Regards,

Laurent Pinchart

