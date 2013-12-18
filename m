Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752147Ab3LRCHW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 21:07:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52630 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751052Ab3LRCHU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 21:07:20 -0500
Date: Wed, 18 Dec 2013 10:06:27 +0800
From: Dave Young <dyoung@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org,
        mjg59@srcf.ucam.org, hpa@zytor.com,
        James.Bottomley@HansenPartnership.com, vgoyal@redhat.com,
        ebiederm@xmission.com, horms@verge.net.au, kexec@lists.infradead.org,
        greg@kroah.com, matt@console-pimps.org, toshi.kani@hp.com
Subject: Re: [PATCH v5 10/14] efi: only print saved efi runtime maps instead
 of all memmap ranges for kexec
Message-ID: <20131218020627.GA3917@dhcp-16-126.nay.redhat.com>
References: <1386582147-9802-1-git-send-email-dyoung@redhat.com>
 <1386582147-9802-11-git-send-email-dyoung@redhat.com>
 <20131213160150.GE32329@pd.tnic>
 <20131216020010.GC3754@dhcp-16-126.nay.redhat.com>
 <20131216113324.GB4922@pd.tnic>
 <20131217063436.GF6751@dhcp-16-126.nay.redhat.com>
 <20131217155844.GG30592@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131217155844.GG30592@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/13 at 04:58pm, Borislav Petkov wrote:
> On Tue, Dec 17, 2013 at 02:34:36PM +0800, Dave Young wrote:
> > They are moved to efi.c efi_setup_init(), I'm not sure if I expained
> > clear enough, in current code parse_efi_setup only accept one argument
> > phys_addr so I will mapping it with sizeof(struct setup_data) to
> > get the payload size then get the nr_efi_runtime_map. This is a
> > simplification from the old implementation.
> >
> > Based on current implementation, yes, I can add back another argument
> > data_len to avoid the 1st mapping thus I can print efi memmap as you
> > said.
> >
> > In this way I need export another extern for the data_len though.
> 
> Well, think about it: do you want to do the memremap/unmap a second time
> *just* to print the memmap in the efi kernel or do you want to do the
> memremap/unmap only once and do the work once?
> 
> If you say you don't care about speed and wasting cycles then I'm
> certainly fine with that as I've spent more time hinting at the
> performance aspect than I'd like to.

For these non critical path I would prefer the code which should be easier to 
be understood. But yes I have managed to work out what you want in latest
version. Of course I appreciate your time for reviewing those patches.
Thanks.

> 
> > What do you mean about NOPARSE, do you want another function name like
> > save_efi_setup()?
> 
> -ENOPARSE means I cannot parse what you said above.

Ok.

Thanks
Dave
