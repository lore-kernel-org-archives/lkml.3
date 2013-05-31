Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687Ab3EaPn7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 11:43:59 -0400
Received: from relay2.sgi.com ([192.48.179.30]:54926 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756301Ab3EaPnw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 11:43:52 -0400
Date: Fri, 31 May 2013 10:43:49 -0500
From: Russ Anderson <rja@sgi.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@alien8.de>,
        Jiri Kosina <jkosina@suse.cz>, joeyli <jlee@suse.com>,
        Matt Fleming <matt@console-pimps.org>, matt.fleming@intel.com,
        linux-efi@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [regression, bisected] x86: efi: Pass boot services variable
	info to runtime code
Message-ID: <20130531154348.GA17145@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
References: <1369880172.17397.11.camel@linux-s257.site> <20130530221737.GA11105@sgi.com> <alpine.LNX.2.00.1305310023020.30576@pobox.suse.cz> <20130531101250.GD30394@gmail.com> <alpine.LNX.2.00.1305311259520.30576@pobox.suse.cz> <20130531123015.GC17843@nazgul.tnic> <20130531124356.GA8212@gmail.com> <20130531143425.GA5850@srcf.ucam.org> <1370011357.1913.15.camel@dabdike.int.hansenpartnership.com> <20130531144826.GB5850@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130531144826.GB5850@srcf.ucam.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 31, 2013 at 03:48:26PM +0100, Matthew Garrett wrote:
> On Fri, May 31, 2013 at 07:42:37AM -0700, James Bottomley wrote:
> > On Fri, 2013-05-31 at 15:34 +0100, Matthew Garrett wrote:
> > > I agree that a revert is probably the right thing to do here, but the 
> > > original patch was there to permit a more accurate calculation of the 
> > > amount of nvram in use, not to provide additional debug information. 
> > > Reverting it is going to differently break a different set of systems
> > 
> > The only ones that are broken are the Samsung ones.  Samsung claims to
> > have fixed their UEFI firmware, so we could refer any problems to them.
> 
> No, reverting this gets us back to the old state of refusing any writes 
> if more than 50% of the variable store *appears* to be used, regardless 
> of whether it's actually used. Which, unfortunately, makes it impossible 
> to install Linux on most UEFI machines.

When did writing EFI variables to nvram become necessary to boot
on UEFI?  And if it is necessary, why is it that only linux boot
loaders that use EFI stubs (generally grub2) need it?  The current
kernel boots using EFI/grub and EFI/elilo.  It is just when
EFI stubs are used that the boot fails.

I'm missing the background on why linux needs to write so many
EFI variables to nvram that it fills up nvram.  What is that
all about?

>                                              In any case, Samsung clearly 
> haven't fixed this problem on a pile of machines that have already 
> shipped.

Which means the previous patch(es) that caused the bricking should
get pulled, too.


-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
