Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057Ab3KKQOR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 11:14:17 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:48778 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753689Ab3KKQOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 11:14:07 -0500
Date: Mon, 11 Nov 2013 16:13:47 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Dave Young <dyoung@redhat.com>
Cc: matt.fleming@intel.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] efi earlyprintk fix
Message-ID: <20131111161347.GH22636@console-pimps.org>
References: <20131103121647.GA4770@dhcp-16-126.nay.redhat.com>
 <20131104103739.GD21688@console-pimps.org>
 <20131104125853.GB5118@dhcp-16-126.nay.redhat.com>
 <20131106092335.GA3952@dhcp-16-126.nay.redhat.com>
 <20131106093832.GC22856@console-pimps.org>
 <20131107120906.GB4116@dhcp-16-126.nay.redhat.com>
 <20131108103648.GA2318@console-pimps.org>
 <20131109034429.GA4294@dhcp-16-126.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131109034429.GA4294@dhcp-16-126.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 09 Nov, at 11:44:29AM, Dave Young wrote:
> Hi, Matt
> 
> Confirmed, your patch work ok for the pr_cont issue.
 
Excellent, thanks for testing.

> Actually I mixed two problems in my report, one is there's always one blank line
> at the bottom of screen, the other is the pr_cont issue. For the second problem
> change >= to > looks better. For the previous problem still need to move the
> hunk below to the beginning point of early_efi_write function. It just works for me
> but I'm not sure why this is not necessary for other machines. 
> 
> +		if (efi_y + font->height > si->lfb_height) {
> +			u32 i;
> +
> +			efi_y -= font->height;
> +			early_efi_scroll_up();
> +
> +			for (i = 0; i < font->height; i++)
> +				early_efi_clear_scanline(efi_y + i);
> +		}

Dave, unfortunately you're going to need to debug this further because
it doesn't make any sense that your patch is needed, unless there's a
bug in the existing code.

You may also want to rule out that your boot_delay patches are not
inserting delays after printing pr_fmt().

-- 
Matt Fleming, Intel Open Source Technology Center
