Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751824Ab3LQGZO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 01:25:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63956 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750930Ab3LQGZM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 01:25:12 -0500
Date: Tue, 17 Dec 2013 14:24:17 +0800
From: Dave Young <dyoung@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org,
        mjg59@srcf.ucam.org, hpa@zytor.com,
        James.Bottomley@HansenPartnership.com, vgoyal@redhat.com,
        ebiederm@xmission.com, horms@verge.net.au, kexec@lists.infradead.org,
        bp@alien8.de, greg@kroah.com, toshi.kani@hp.com,
        akpm@linux-foundation.org, mingo@kernel.org, msalter@redhat.com,
        leif.lindholm@linaro.org
Subject: Re: [PATCH v6 14/14] x86: kdebugfs do not use __va for getting
 setup_data virt addr
Message-ID: <20131217062417.GE6751@dhcp-16-126.nay.redhat.com>
References: <1387186235-15972-1-git-send-email-dyoung@redhat.com>
 <1387186235-15972-15-git-send-email-dyoung@redhat.com>
 <20131216163501.GB3873@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131216163501.GB3873@console-pimps.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/13 at 04:35pm, Matt Fleming wrote:
> On Mon, 16 Dec, at 05:30:35PM, Dave Young wrote:
> > kdump kernel will use memmap=exactmap kernel cmdline, but __va does not
> > work in case memmap=exactmap, so let's always use ioremap_cache.
> > 
> > Signed-off-by: Dave Young <dyoung@redhat.com>
> > ---
> >  arch/x86/kernel/kdebugfs.c | 35 +++++++++++------------------------
> >  1 file changed, 11 insertions(+), 24 deletions(-)
> 
> Dave, I've no idea why this change is necessary from the commit log. Is
> it required for kexec to function on EFI? Why does __va() not work in
> the memmap=exactmap case?
> 

During previous kdump tests I saw panics while reading the setup_data in debugfs.
I thought it is caused by some unmapped addresses. At that time I also reproduced
it by booting the non-kexec kernel with memmap=exact.

Since you are asking about this I'm testing it again but I seems can not
reproduce this problem any more, it's weird.

I should dug more about it and save the panic messages.

So let's drop this patch for now, I will keep an eye on this and address it later
if I can find the problem again.

--
Thanks
Dave
