Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753630Ab3KCMfg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 07:35:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34697 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753384Ab3KCMff (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 07:35:35 -0500
Date: Sun, 3 Nov 2013 20:35:08 +0800
From: Dave Young <dyoung@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: Borislav Petkov <bp@alien8.de>, Linux EFI <linux-efi@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Vivek Goyal <vgoyal@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>
Subject: Re: [PATCH 10/11] EFI: Runtime services virtual mapping
Message-ID: <20131103123508.GB5313@dhcp-16-126.nay.redhat.com>
References: <1383236709-19716-1-git-send-email-bp@alien8.de>
 <1383236709-19716-11-git-send-email-bp@alien8.de>
 <20131101032551.GC4378@dhcp-16-126.nay.redhat.com>
 <20131101033508.GA13527@dhcp-16-126.nay.redhat.com>
 <20131101125057.GA21688@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131101125057.GA21688@console-pimps.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/13 at 12:50pm, Matt Fleming wrote:
> On Fri, 01 Nov, at 11:35:08AM, Dave Young wrote:
> > > The conflict is caused by missing one commit in matt's efi next tree:
> > > 
> > > commit 700870119f49084da004ab588ea2b799689efaf7
> > > Author: Josh Boyer <jwboyer@redhat.com>
> > > Date:   Thu Apr 18 07:51:34 2013 -0700
> > > 
> > >     x86, efi: Don't map Boot Services on i386
> > >     
> > >     Add patch to fix 32bit EFI service mapping (rhbz 726701)
> > >     
> > >     Multiple people are reporting hitting the following WARNING on i386,
> > >     
> > >       WARNING: at arch/x86/mm/ioremap.c:102 __ioremap_caller+0x3d3/0x440()
> > >       Modules linked in:
> > >       Pid: 0, comm: swapper Not tainted 3.9.0-rc7+ #95
> > 
> > Rethinking about above commit, it is actually a workaround for
> > mapping boot service, I suspect the problem connect to the off-by-one
> > problem in boot service reserve function. Matt, idea?
> 
> No, it's not the same problem. And just to make absolutely sure I
> reverted the above commit and applied your patch, but I still see the
> WARN_ON() described above.

Ok, I'm wrong then, thanks for verifying..
