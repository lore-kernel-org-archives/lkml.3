Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808Ab3K2Igl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 03:36:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25573 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750985Ab3K2Igg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 03:36:36 -0500
Date: Fri, 29 Nov 2013 16:35:52 +0800
From: Dave Young <dyoung@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org,
        mjg59@srcf.ucam.org, hpa@zytor.com,
        James.Bottomley@HansenPartnership.com, vgoyal@redhat.com,
        ebiederm@xmission.com, horms@verge.net.au, kexec@lists.infradead.org,
        greg@kroah.com, matt@console-pimps.org, toshi.kani@hp.com
Subject: Re: [PATCH v4 11/12] x86: reserve setup_data ranges late after
 parsing memmap cmdline
Message-ID: <20131129083551.GB4186@dhcp-16-126.nay.redhat.com>
References: <1385445477-9665-1-git-send-email-dyoung@redhat.com>
 <1385445477-9665-12-git-send-email-dyoung@redhat.com>
 <20131127150710.GH32267@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131127150710.GH32267@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27/13 at 04:07pm, Borislav Petkov wrote:
> On Tue, Nov 26, 2013 at 01:57:56PM +0800, Dave Young wrote:
> > Kdump kernel using memmap=exactmap, move e820_reserve_setup_data after
> > parsing early params so they can be set reserved finally. Or kdump kernel
> > will warn about ioremap a normal ram range.
> 
> I had to stare for a while at this commit message, rereading it a couple
> of times and looking at the code in order to understand why you're
> moving the call further down.
> 
> Please rewrite it into something more readable.
> 
> The usual structure which you could use is:
> 
> 1. Currently we have A
> 2. We need B
> 3. In order to achieve it, we do C
> 
> or something to that effect.

Is below changes ok to you?

Currently e820_reserve_setup_data is called before parsing early params,
it works in normal case. But for memmap=exactmap, the final memory ranges
are created after parsing memmap= cmdline params, so the previous
e820_reserve_setup_data has no effect. For example for setup_data ranges
will still be marked as normal system ram, thus when later sysfs driver
ioremap them kernel will warn about mapping normal ram.

This patch fix it by moving the e820_reserve_setup_data callback after
parsing early params so they can be set as reserved ranges and later
ioremap will be fine with it.

Thanks
Dave
