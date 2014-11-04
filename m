Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751585AbaKDHvD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 02:51:03 -0500
Received: from www.linutronix.de ([62.245.132.108]:57444 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbaKDHvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 02:51:01 -0500
Date: Tue, 4 Nov 2014 08:50:50 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Daniel J Blueman <daniel@numascale.com>
cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Bjorn Helgaas <bhelgaas@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Steffen Persvold <sp@numascale.com>
Subject: Re: [PATCH v3 5/5] Use 2GB memory block size on large x86-64
 systems
In-Reply-To: <5458807E.80701@numascale.com>
Message-ID: <alpine.DEB.2.11.1411040848090.5308@nanos>
References: <1414915813-2462-1-git-send-email-daniel@numascale.com> <1414915813-2462-5-git-send-email-daniel@numascale.com> <alpine.DEB.2.11.1411032021331.5308@nanos> <54580C9E.7070706@numascale.com> <alpine.DEB.2.11.1411040033530.5308@nanos>
 <5458807E.80701@numascale.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Nov 2014, Daniel J Blueman wrote:
> On 11/04/2014 07:36 AM, Thomas Gleixner wrote:
> > On Tue, 4 Nov 2014, Daniel J Blueman wrote:
> > > > > @@ -1247,9 +1246,9 @@ static unsigned long
> > > > > probe_memory_block_size(void)
> > > > >    	/* start from 2g */
> > > > >    	unsigned long bz = 1UL<<31;
> > > > > 
> > > > > -#ifdef CONFIG_X86_UV
> > > > > -	if (is_uv_system()) {
> > > > > -		printk(KERN_INFO "UV: memory block size 2GB\n");
> > > > > +#ifdef CONFIG_X86_64
> > > > 
> > > > And this brainless 's/CONFIG_X86_UV/CONFIG_X86_64/' sucks even
> > > > more. I'm sure you can figure out the WHY yourself.
> > > 
> > > The benefit of this is applicable to other architectures. I'm unable to
> > > test
> > > the change, but if you agree it's conservative enough, I'll drop the
> > > ifdef?
> > 
> > Which other architectures? Care to turn on your brain before replying?
> 
> Clearly 64-bit architectures, including X86, MIPS, PARISC, SPARC, AArch64,
> ia64,

ROTFL

> however, I must be missing something, as a sizeof(long)/CONFIG_64BIT
> check would be redundant if we agree to drop the ifdef, as we're already
> checking the number of physical pages, which is bounded by the same limits.

# diffstat $this_patch

should precicely tell you what you're missing.

Thanks,

	tglx
