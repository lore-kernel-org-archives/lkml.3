Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079Ab3EaMoL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 08:44:11 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:40890 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755634Ab3EaMoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 08:44:00 -0400
Date: Fri, 31 May 2013 14:43:56 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Jiri Kosina <jkosina@suse.cz>, Russ Anderson <rja@sgi.com>,
        joeyli <jlee@suse.com>, Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <matthew.garrett@nebula.com>, matt.fleming@intel.com,
        linux-efi@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [regression, bisected] x86: efi: Pass boot services variable
 info to runtime code
Message-ID: <20130531124356.GA8212@gmail.com>
References: <20130529210115.GC28027@sgi.com>
 <alpine.LRH.2.00.1305300018180.1111@twin.jikos.cz>
 <20130529224645.GA16582@sgi.com>
 <alpine.LNX.2.00.1305300048520.30576@pobox.suse.cz>
 <1369880172.17397.11.camel@linux-s257.site>
 <20130530221737.GA11105@sgi.com>
 <alpine.LNX.2.00.1305310023020.30576@pobox.suse.cz>
 <20130531101250.GD30394@gmail.com>
 <alpine.LNX.2.00.1305311259520.30576@pobox.suse.cz>
 <20130531123015.GC17843@nazgul.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130531123015.GC17843@nazgul.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <bp@alien8.de> wrote:

> On Fri, May 31, 2013 at 01:06:09PM +0200, Jiri Kosina wrote:
> >
> > (*) If one would be naive enough, he'd believe that the pressure 
> > should be put on the BIOS writers instead of OS to fix the bug :)
> 
> Oh, definitely pressure on BIOS dudes. If they're in violation of the 
> spec and they still can fix it in time, they better. I'm sick and tired 
> of having to deal with BIOS idiocy in kernel code.

I'm all for some BIOS quality bashing, but the reality is:

1) It's not just about SGI/UV systems but apparently about several 
   different types of x86 laptops produce the same boot crash pattern: 
   most of which come from manufacturers that simply don't care about 
   Linux all that much.

   So by not reverting we'd screw our users, not put any recognizable 
   pressure on any BIOS writers or manufacturers.

2) Obviously Windows does not crash, and that's what most laptops test.
   So our realistic 'spec target' is not some sort of pure 'EFI spec',
   but EFI implementations _tested under Windows_. Consider it an 
   'extended EFI compatibility spec'.

3) There's a better, more robust firmware environment approach being 
   worked on (by you?) that avoids such 1:1 physical mapping assumption 
   crashes. That's something worth doing anyway, so why not delay the 
   early QueryVariableInfo() call change to when that enviroment is 
   properly implemented?

4) The revert is easy, and the functionality the original patch provided
   was a marginal increase in debug output to begin with...

So to me the right approach seems to be:

 A: revert now for v3.10
 B: implement 1:1 mappings environment for firmware, for v3.11
 C: reintroduce the early QueryVariableInfo() call again, in v3.11

Thanks,

	Ingo
