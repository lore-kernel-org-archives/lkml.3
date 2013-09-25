Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755048Ab3IYCbr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 22:31:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9512 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754603Ab3IYCbp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 22:31:45 -0400
Date: Wed, 25 Sep 2013 10:31:17 +0800
From: Dave Young <dyoung@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Vivek Goyal <vgoyal@redhat.com>, linux-efi@vger.kernel.org
Subject: Re: [PATCH -v2] EFI: Runtime services virtual mapping
Message-ID: <20130925023117.GA7434@dhcp-16-126.nay.redhat.com>
References: <e39e1065bddc2afee2cb6eed957e3ba8.squirrel@www.skyhub.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e39e1065bddc2afee2cb6eed957e3ba8.squirrel@www.skyhub.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/13 at 04:56pm, Borislav Petkov wrote:
> On Tue, September 24, 2013 2:45 pm, Dave Young wrote:
> > Think again about this, how about 1:1 map them from a base address
> > like -64G phy_addr -> (-64G + phy_addr), in this way we can avoid
> > depending on the previous region size.
> 
> Right, how we layout the regions is arbitrary as long as we start at
> the same VA and use the same regions, in the same order and of the same
> size...
> 
> > For the zero region problem, we can resolve it as a standalone
> > problem.
> 
> ... however, we still need to understand why it fails mapping the boot
> services region as some implementations apparently do call boot services
> even after ExitBootServices(). IOW, we need that region mapped in the
> kexec'ed kernel too.

In 1st kernel, the memmap is provided by firmware and unchanged before
we do the mapping, later efi_reserve_boot_services() try to reserve the
mem range, but failed due to conflict with other region (why?), then the
memmap item size is set to 0 (why?).

In 2nd kernel, we use same memmap from firmware, but the boot service
ranges size have been set to 0, thus efi mapping code will mapping runtime
regions to different va from 1st kernel.

--
Thanks
Dave
