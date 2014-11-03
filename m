Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750994AbaKCXhK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 18:37:10 -0500
Received: from www.linutronix.de ([62.245.132.108]:56022 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbaKCXhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 18:37:07 -0500
Date: Tue, 4 Nov 2014 00:36:57 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Daniel J Blueman <daniel@numascale.com>
cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Bjorn Helgaas <bhelgaas@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Steffen Persvold <sp@numascale.com>
Subject: Re: [PATCH v3 5/5] Use 2GB memory block size on large x86-64
 systems
In-Reply-To: <54580C9E.7070706@numascale.com>
Message-ID: <alpine.DEB.2.11.1411040033530.5308@nanos>
References: <1414915813-2462-1-git-send-email-daniel@numascale.com> <1414915813-2462-5-git-send-email-daniel@numascale.com> <alpine.DEB.2.11.1411032021331.5308@nanos> <54580C9E.7070706@numascale.com>
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

> On 11/04/2014 03:38 AM, Thomas Gleixner wrote:
> > On Sun, 2 Nov 2014, Daniel J Blueman wrote:
> > 
> > > On larger x64-64 systems, use a 2GB memory block size to reduce sysfs
> > > entry creation time by 16x. Large is defined as 64GB or more memory.
> > 
> > This changelog sucks.
> > 
> > It neither tells which sysfs entries are meant nor does it explain
> > what the actual effect of this change is aside of speeding up some
> > random sysfs thingy.
> 
> How about this?
> 
> On large-memory systems of 64GB or more with memory hot-plug enabled, use a
> 2GB memory block size. Eg with 64GB memory, this reduces the number of
> directories in /sys/devices/system/memory from 512 to 32, making it more
> manageable, and reducing the creation time accordingly.

It still does not tell what the downside is of this and why you think
it does not matter.
 
> > > @@ -1247,9 +1246,9 @@ static unsigned long probe_memory_block_size(void)
> > >   	/* start from 2g */
> > >   	unsigned long bz = 1UL<<31;
> > > 
> > > -#ifdef CONFIG_X86_UV
> > > -	if (is_uv_system()) {
> > > -		printk(KERN_INFO "UV: memory block size 2GB\n");
> > > +#ifdef CONFIG_X86_64
> > 
> > And this brainless 's/CONFIG_X86_UV/CONFIG_X86_64/' sucks even
> > more. I'm sure you can figure out the WHY yourself.
> 
> The benefit of this is applicable to other architectures. I'm unable to test
> the change, but if you agree it's conservative enough, I'll drop the ifdef?

Which other architectures? Care to turn on your brain before replying?

Thanks,

	tglx
