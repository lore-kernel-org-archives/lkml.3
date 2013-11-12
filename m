Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495Ab3KLCXU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 21:23:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1594 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753149Ab3KLCXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 21:23:13 -0500
Date: Tue, 12 Nov 2013 10:22:56 +0800
From: Dave Young <dyoung@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: matt.fleming@intel.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] efi earlyprintk fix
Message-ID: <20131112022256.GC4341@dhcp-16-126.nay.redhat.com>
References: <20131103121647.GA4770@dhcp-16-126.nay.redhat.com>
 <20131104103739.GD21688@console-pimps.org>
 <20131104125853.GB5118@dhcp-16-126.nay.redhat.com>
 <20131106092335.GA3952@dhcp-16-126.nay.redhat.com>
 <20131106093832.GC22856@console-pimps.org>
 <20131107120906.GB4116@dhcp-16-126.nay.redhat.com>
 <20131108103648.GA2318@console-pimps.org>
 <20131109034429.GA4294@dhcp-16-126.nay.redhat.com>
 <20131111161347.GH22636@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131111161347.GH22636@console-pimps.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/13 at 04:13pm, Matt Fleming wrote:
> On Sat, 09 Nov, at 11:44:29AM, Dave Young wrote:
> > Hi, Matt
> > 
> > Confirmed, your patch work ok for the pr_cont issue.
>  
> Excellent, thanks for testing.
> 
> > Actually I mixed two problems in my report, one is there's always one blank line
> > at the bottom of screen, the other is the pr_cont issue. For the second problem
> > change >= to > looks better. For the previous problem still need to move the
> > hunk below to the beginning point of early_efi_write function. It just works for me
> > but I'm not sure why this is not necessary for other machines. 
> > 
> > +		if (efi_y + font->height > si->lfb_height) {
> > +			u32 i;
> > +
> > +			efi_y -= font->height;
> > +			early_efi_scroll_up();
> > +
> > +			for (i = 0; i < font->height; i++)
> > +				early_efi_clear_scanline(efi_y + i);
> > +		}
> 
> Dave, unfortunately you're going to need to debug this further because
> it doesn't make any sense that your patch is needed, unless there's a
> bug in the existing code.

Ok, will dig more about this and find out why it only happens on this machine.

> 
> You may also want to rule out that your boot_delay patches are not
> inserting delays after printing pr_fmt().

In fact with or without the delay testing results are same. There's might be
something wrong in the setup as you said. I will update once I have got something.

Thanks
Dave
