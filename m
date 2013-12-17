Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752163Ab3LQIVZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 03:21:25 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:37672 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871Ab3LQIVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 03:21:23 -0500
Date: Tue, 17 Dec 2013 00:21:18 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Wei Yongjun'" <weiyj.lk@gmail.com>,
        "'David Woodhouse'" <dwmw2@infradead.org>,
        "'Bill Pemberton'" <wfp5p@virginia.edu>,
        "'Artem Bityutskiy'" <artem.bityutskiy@linux.intel.com>,
        "'Wei Yongjun'" <yongjun_wei@trendmicro.com.cn>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MIPS: Alchemy: add missing platform_set_drvdata() in
 au1550nd_probe()
Message-ID: <20131217082118.GI12034@norris-Latitude-E6410>
References: <CAPgLHd-qf8Zj0gWgJh3_WMZOAx5-H6aABrVFqRsAw=XkOfDdmw@mail.gmail.com>
 <20131126235026.GN9468@ld-irv-0074.broadcom.com>
 <004e01ceeb05$9d579690$d806c3b0$%han@samsung.com>
 <20131127033555.GY9468@ld-irv-0074.broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131127033555.GY9468@ld-irv-0074.broadcom.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 26, 2013 at 07:35:55PM -0800, Brian Norris wrote:
> On Wed, Nov 27, 2013 at 09:14:18AM +0900, Jingoo Han wrote:
> > On Wednesday, November 27, 2013 8:50 AM, Brian Norris wrote:
> > > On Mon, Nov 11, 2013 at 02:18:29PM +0800, Wei Yongjun wrote:
> > > > --- a/drivers/mtd/nand/au1550nd.c
> > > > +++ b/drivers/mtd/nand/au1550nd.c
> > > > @@ -480,6 +480,8 @@ static int au1550nd_probe(struct platform_device *pdev)
> > > >
> > > >  	mtd_device_register(&ctx->info, pd->parts, pd->num_parts);
> > > >
> > > > +	platform_set_drvdata(pdev, ctx);
> > > > +
> > > 
> > > Personally, I'd choose to call platform_set_drvdata() earlier in the
> > > probe routine (e.g., immediately after its allocation), in case we end
> > > up calling platform_get_drvdata() from some sub-routine in the future.
> > 
> > Do you mean the following?
> > But, most drivers calls platform_set_drvdata() later in the probe routine.
> 
> I wouldn't say "most." An unscientific survey seemed to show some
> variation, with no clear pattern.

I'm just pushing the original patch, since this isn't really a big
issue.

Pushed to l2-mtd.git. I reworked the $subject, since this isn't really
about MIPS at all. Thanks Wei and Jingoo.

Brian
