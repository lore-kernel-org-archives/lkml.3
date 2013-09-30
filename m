Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756115Ab3I3P2A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 11:28:00 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:19966 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755347Ab3I3P17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 11:27:59 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-91-5249987db405
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH] x86/acpi: fix incorrect placement of __initdata tag
Date: Mon, 30 Sep 2013 17:27:46 +0200
Message-id: <10479344.AmK4cG4GID@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-52-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <Pine.LNX.4.44L0.1309301023040.1352-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1309301023040.1352-100000@iolanthe.rowland.org>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=US-ASCII
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrALMWRmVeSWpSXmKPExsVy+t9jAd3aGZ5BBnNv6FqcbXrDbjFryl4m
	i8u75rBZfO49wmhx99RRNov+hb1MFhN+X2BzYPdYvOclk8fsuz8YPfq2rGL0eLS4hdFjxerv
	7B6fN8kFsEVx2aSk5mSWpRbp2yVwZcw/Oou54BdXxYVr59kbGD9xdDFyckgImEhs//+EFcIW
	k7hwbz1bFyMXh5DAIkaJ653bGSGcFiaJpztnsoFUsQlYSUxsX8UIYosIaElsbnrJDFLELHCK
	UWLJ7StgRcICHhKLHi0Gsjk4WARUJQ60WIOEeYHq58zpZAexRQU8JT5NWsoMYnMK+Er0N35h
	BykXEvCR6DpqAFEuKPFj8j0WEJtZQF5i3/6prBA20NptTawTGAVmISmbhaRsFpKyBYzMqxhF
	UwuSC4qT0nON9IoTc4tL89L1kvNzNzGCw/2Z9A7GVQ0WhxgFOBiVeHgN6j2DhFgTy4orcw8x
	SnAwK4nwvp4AFOJNSaysSi3Kjy8qzUktPsQozcGiJM57sNU6UEggPbEkNTs1tSC1CCbLxMEp
	1cA4b/Zl1c4rVcJMExrYHIwOWm2Sea52siNin8aX+J7O12w+7RfviCi5am7k+Mmfq7q6iulc
	6lVmn7+CbkI6sl2+D+/9/9cX9GTd6inJLiaJyznktYNzn66YJ2C4gnVy8XI2iRXMtw447G7V
	Tb1xd7dg/MzaujNNB8zUn878ma3/JS/L97U2X6oSS3FGoqEWc1FxIgC+R1xocwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, September 30, 2013 10:24:41 AM Alan Stern wrote:
> On Mon, 30 Sep 2013, Bartlomiej Zolnierkiewicz wrote:
> 
> > __initdata tag should be placed between the variable name and equal
> > sign for the variable to be placed in the intended .init.data section.
> 
> The line you are changing does not have an equals sign.  Therefore, 
> according to your own patch description, the patch is incorrect.  :-)

Uh, indeed, copypasta is bad. :)

Thanks for noticing, I'll post v2 shortly.

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

> > Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> > ---
> >  arch/x86/kernel/acpi/boot.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
> > index 1f7c074..6c0b43b 100644
> > --- a/arch/x86/kernel/acpi/boot.c
> > +++ b/arch/x86/kernel/acpi/boot.c
> > @@ -695,7 +695,7 @@ static int __init acpi_parse_sbf(struct acpi_table_header *table)
> >  #ifdef CONFIG_HPET_TIMER
> >  #include <asm/hpet.h>
> >  
> > -static struct __initdata resource *hpet_res;
> > +static struct resource *hpet_res __initdata;
> >  
> >  static int __init acpi_parse_hpet(struct acpi_table_header *table)
> >  {
> 
> Alan Stern

