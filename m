Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753623Ab3HEQuV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 12:50:21 -0400
Received: from crispin.apple.com ([17.151.62.50]:43517 "EHLO
	mail-out.apple.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063Ab3HEQuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 12:50:20 -0400
X-Greylist: delayed 3600 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Aug 2013 12:50:20 EDT
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; CHARSET=US-ASCII
X-AuditID: 11807157-b7f1a6d000003e11-60-51ffc9b91423
Subject: Re: [edk2] Corrupted EFI region
From: Andrew Fish <afish@apple.com>
In-reply-to: <20130805144010.GE31845@pd.tnic>
Date: Mon, 05 Aug 2013 08:50:17 -0700
Cc: Laszlo Ersek <lersek@redhat.com>, linux-efi@vger.kernel.org,
        Gleb Natapov <gleb@redhat.com>, lkml <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>
Message-id: <2DBE3EA4-E321-4A7B-B9AF-EDE55BC2E358@apple.com>
References: <20130731205431.GG4724@pd.tnic>
 <1375307727.22084.103.camel@shinybook.infradead.org>
 <20130801164927.GA7445@pd.tnic> <51FF8C14.2070405@redhat.com>
 <20130805130258.GB31845@pd.tnic> <51FFAB13.4090603@redhat.com>
 <20130805140306.GD31845@pd.tnic> <51FFB660.4060400@redhat.com>
 <20130805144010.GE31845@pd.tnic>
To: edk2-devel@lists.sourceforge.net
X-Mailer: Apple Mail (2.1508)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPLMWRmVeSWpSXmKPExsUiOFM3X3fPyf+BBusPs1lMXDmZ2eLvn//M
	FqsOdLBaLDu2g8Wi7eEtRovLu+awObB5bF6h5bF7wWcmj/f7rrJ5fN4kF8ASxWWTkpqTWZZa
	pG+XwJXxb9p9toJ28YorHU/ZGhiPCXUxcnJICJhI/Pl8nRHCFpO4cG89WxcjF4eQQC+TRMfx
	CewgCWYBLYkb/14ygdi8AnoSS//NAWsQFtCQWHTnGzOIzSagLLFi/gewek4BXYmbW54D2Rwc
	LAIqEmevq4PMZBbYzCjR+PA0K8RMbYllC18zQ8y0kXg8fR07xOK9TBJTVrxnA0mIADW/OfKY
	CWSQhICsxM7fSRMY+WchOWkWkpNmIRm7gJF5FaNAUWpOYqWJXmJBQU6qXnJ+7iZGULA2FIbv
	YPy3zOoQowAHoxIPrwL7/0Ah1sSy4srcQ4wSHMxKIrzztwCFeFMSK6tSi/Lji0pzUosPMUpz
	sCiJ81qG/g4UEkhPLEnNTk0tSC2CyTJxcEo1MKYe7rwhx2iT8+a8dFjJcSnDY8fe5YYffdPy
	TTZvzg428d/J93Wi/Z+E8uxYkyn8UKzu7LTv/AwvXxWZzfLsNs/xMmE65NNSekF/tcOe5rin
	L03NbqlLfphb0nukIpo9SuGL9ht71o8ReQK1wWk+PMeOtMzRY18Qkfj8RL2M13GPqUt3TirQ
	UWIpzkg01GIuKk4EACIjXVZSAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 5, 2013, at 7:40 AM, Borislav Petkov <bp@alien8.de> wrote:

> On Mon, Aug 05, 2013 at 04:27:44PM +0200, Laszlo Ersek wrote:
>> I wouldn't call the design of SetVirtualAddressMap() braindead.
> 
> Ok, I've always wondered and you could probably shed some light on the
> matter: why is SetVirtualAddressMap() a call-once only? Why can't I
> simply call it again and update the mappings?
> 
>> I'd rather call kexec unique and somewhat unexpected :)
> 
> In all fairness, it was there before UEFI, AFAICT.
> 

AFAICT EFI pre-dates kexec merge into mainline by a number of years as SetVirtualaddressMap() was part of EFI 1.0 (previous millennium) 

The EFI to UEFI conversion was placing EFI 1.10  into an industry standard, UEFI 2.0. UEFI is an industry standard so some one just needs to make a proposal to update the spec. The edk2 open source project is not part of the standards body so complaining on this mailing list is not going to get anything changed. 

The conversion of C code to run from address A to address B is a non trivial operation, and a single conversion is bad enough. The infrastructure code required to do the conversion from physical to virtual addressing currently only runs from physical mode, so a call to change virtual address mappings from virtual mode is more complex than the current scheme. 
In general you don't want complexity in the locked NOR FLASH of the platform that can only be updated by the platform vendor. Even if the platform firmware is easy to update you want to have complexity in the OS as it is easier to change and easier to get right.

Thanks,

Andrew Fish 

>>> I wouldn't wonder if we f*cked it up again like the last time. I'll give
>>> it a long hard look.
>> 
>> Ah sorry, by "and you guys suspect" I didn't mean to imply anything
>> between the lines, I was simply trying to ascertain your working idea :)
> 
> As long as we get to the bottom of this, we're all fine. And I'd
> pretty much expect everyone who is dealing with EFI to have grown a
> sufficiently thick skin before starting to do so, so don't worry.
> 
> :-)
> 
> -- 
> Regards/Gruss,
>    Boris.
> 
> Sent from a fat crate under my desk. Formatting is fine.
> --
> 
> ------------------------------------------------------------------------------
> Get your SQL database under version control now!
> Version control is standard for application code, but databases havent 
> caught up. So what steps can you take to put your SQL databases under 
> version control? Why should you start doing it? Read more to find out.
> http://pubads.g.doubleclick.net/gampad/clk?id=49501711&iu=/4140/ostg.clktrk
> _______________________________________________
> edk2-devel mailing list
> edk2-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/edk2-devel

