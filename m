Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753812Ab3KLJmT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 04:42:19 -0500
Received: from mail-ea0-f177.google.com ([209.85.215.177]:59279 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753427Ab3KLJmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 04:42:14 -0500
Date: Tue, 12 Nov 2013 10:42:10 +0100
From: Ingo Molnar <mingo@kernel.org>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Olof Johansson <olof@lixom.net>
Subject: Re: [RFC PATCH 3/3] x86, boot: Change the BIOS corruption checker to
 scan 640K
Message-ID: <20131112094210.GA11777@gmail.com>
References: <1384215407-22288-1-git-send-email-hpa@linux.intel.com>
 <1384215407-22288-4-git-send-email-hpa@linux.intel.com>
 <20131112040703.GA28410@gmail.com>
 <5281D682.4040700@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5281D682.4040700@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@linux.intel.com> wrote:

> On 11/11/2013 08:07 PM, Ingo Molnar wrote:
>
> > I agree with your patches so far, and I'd suggest we go even further: 
> > I'd say the config option is now a misnomer, it should probably be 
> > renamed to CONFIG_X86_FORCE_RESERVE_BIOS_LOW_1MB=y or so.
> 
> Why is that?  It doesn't seem to make much sense to me.  I think the 
> current option names seem to be just fine, but perhaps I'm missing 
> something.

My argument is that CONFIG_X86_CHECK_BIOS_CORRUPTION=y doesn't actually 
_check_ any 'BIOS corruption'. Its largest operative effect to the vast 
majority of users is to reserve the whole 1MB lower range to the BIOS and 
it performs no checking whatsoever.

That used to be different btw., it used to be on by default, that's why I 
named the option in such a way original. That original role has been 
almost completely eliminated though.

The _real_ option that turns on memory corruption checking is 
CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y. (The 
memory_corruption_check=1 option is something very few users and 
essentially no distro will use - distros will use the .config option.)

> > Btw., should we also force-reserve the remaining bits over 640K..1MB, 
> > if they are not marked as reserved in the memory maps, or do we 
> > already force-reserve them somewhere?
> 
> We do, in trim_bios_range().  We treat it as available for I/O 
> assignments, since that is necessary on some systems.

Ok, good.

> > The CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y option and the 
> > memory_corruption_check=1 boot option then allow the activation of the 
> > low memory corrupion checker - which debug facility can be used on 
> > systems where someone wants to live dangerously and not reserve the 
> > low 1MB of RAM to the firmware.
> 
> That is indeed what this patch does, I think...

Yes, and that's my argument for simply renaming the option, no other 
change is needed IMO.

Thanks,

	Ingo
