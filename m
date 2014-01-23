Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632AbaAWQge (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 11:36:34 -0500
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:33307 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838AbaAWQgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 11:36:33 -0500
Message-ID: <1390494619.1792.482.camel@misato.fc.hp.com>
Subject: Re: [PATCH 0/5] EFI memmap and other fixes, v3
From: Toshi Kani <toshi.kani@hp.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: Borislav Petkov <bp@alien8.de>, Linux EFI <linux-efi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 23 Jan 2014 09:30:19 -0700
In-Reply-To: <20140123090654.GA17297@console-pimps.org>
References: <1390045698-16882-1-git-send-email-bp@alien8.de>
	 <20140123090654.GA17297@console-pimps.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-01-23 at 09:06 +0000, Matt Fleming wrote:
> On Sat, 18 Jan, at 12:48:13PM, Borislav Petkov wrote:
> > From: Borislav Petkov <bp@suse.de>
> > 
> > Hi all,
> > 
> > this is the latest incarnation which should hopefully work just fine. It
> > tpasses esting at least on all our boxes so we have *some* coverage.
> > 
> > It took us a long time to debug the unmapping path and realize how
> > exactly we're doing the PGD sharing between the kernel and the EFI page
> > table. I've commented on this verbosely in 4/5 for future reference
> > because this stuff is not trivial.
> > 
> > We definitely should have this in mind when we do more changes on how we
> > handle the EFI page table and what we do with it, maybe even decouple it
> > completely from the kernel one. I dunno - it is all future stuff to pay
> > attention to.
> > 
> > Anyway, if anyone with an EFI box wants to give it a run, feel free to
> > do so.
> > 
> > As always, all comments and suggestions are appreciated.
> 
> Thanks Borislav. I picked these up and applied them to my 'next' branch.
> 
> You'll notice that I haven't stuck them in my 'urgent' branch, so these
> won't be sent to Linus before v3.15 despite the fact that they're bug
> fixes. I think Toshi's box is special enough that most people shouldn't
> hit this issue, and since these patches involve rewriting the way we do
> SetVirtualAddressMap() I'm happy for people to hammer on the stuff that
> did make it into the merge window without this added complication.
> 
> Having said that, if people think it's worth the effort I don't mind
> setting up a new branch containing this series that can be sent to Linus
> much sooner.

Since this issue is quite serious on our systems (3.14 kernels won't
boot up), I'd really appreciate if the fixes can be made into some
3.14-rc.  It can hit on any EFI systems with large memory.

Thanks,
-Toshi

