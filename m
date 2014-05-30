Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932649AbaE3Hdd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 03:33:33 -0400
Received: from mail.skyhub.de ([78.46.96.112]:39041 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932565AbaE3Hdb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 03:33:31 -0400
Date: Fri, 30 May 2014 09:33:23 +0200
From: Borislav Petkov <bp@alien8.de>
To: Dave Young <dyoung@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, matt.fleming@intel.com,
        linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org
Subject: Re: [PATCH] export efi.flags to sysfs
Message-ID: <20140530073323.GB28131@pd.tnic>
References: <20140526083935.GA19682@dhcp-16-198.nay.redhat.com>
 <20140527133411.GG10994@redhat.com>
 <20140528021359.GC2820@darkstar.nay.redhat.com>
 <20140528124029.GF14863@redhat.com>
 <20140529020837.GB2068@darkstar.nay.redhat.com>
 <20140529124520.GC14570@redhat.com>
 <20140530022438.GC1985@darkstar.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140530022438.GC1985@darkstar.nay.redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 30, 2014 at 10:24:38AM +0800, Dave Young wrote:
> > > > How does /sys/firmware/efi/runtime-map/* look like with old mapping? Can't
> > > > we look at it and figure out if it is 1:1 or not.
> > > 
> > > There's phys_addr and virt_addr, (virt_addr - phys_addr) will always be
> > > -64G for 1:1 map, ioremapped addresses space is different.
> 
> Correct myself it's top to down (-4G - -64G) instead of down to top.

This is the new mapping.

AFAICR, the question is about the old mapping. Which was "normal"
ioremap into the kernel page table. The new mapping is into another page
table.

> > I am curious that what's the meaning of 1:1 mapping here? So far I thought
> > that means virt and physical addresses are same but that does not seem
> > to be the case. So what does it mean?
> 
> while doing the mapping, we will iterate the memory ranges (md[])
> 
> Like below without considering alignment:
> Virt addr   (down) <------------------------------> (top)
> md0 (size0)                                 <-----> 
>                                              (size0)
> md1 (size1)                        <------->
>                                     (size1)
> ...
> 
> Boris can correct me if I'm wrong.

Yes, this is the new mapping, top = -2G.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
