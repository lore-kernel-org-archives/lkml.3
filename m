Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772Ab3FAOko (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 10:40:44 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:49422 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754506Ab3FAOkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 10:40:36 -0400
Date: Sat, 1 Jun 2013 15:40:08 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@alien8.de>,
        Jiri Kosina <jkosina@suse.cz>, Russ Anderson <rja@sgi.com>,
        joeyli <jlee@suse.com>, Matt Fleming <matt@console-pimps.org>,
        matt.fleming@intel.com, linux-efi@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [regression, bisected] x86: efi: Pass boot services variable
 info to runtime code
Message-ID: <20130601144008.GA23140@srcf.ucam.org>
References: <alpine.LNX.2.00.1305300048520.30576@pobox.suse.cz>
 <1369880172.17397.11.camel@linux-s257.site>
 <20130530221737.GA11105@sgi.com>
 <alpine.LNX.2.00.1305310023020.30576@pobox.suse.cz>
 <20130531101250.GD30394@gmail.com>
 <alpine.LNX.2.00.1305311259520.30576@pobox.suse.cz>
 <20130531123015.GC17843@nazgul.tnic>
 <20130531124356.GA8212@gmail.com>
 <20130531143425.GA5850@srcf.ucam.org>
 <alpine.LFD.2.03.1306011956350.9068@pixel.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.03.1306011956350.9068@pixel.linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 01, 2013 at 08:01:59PM +0900, Linus Torvalds wrote:
> On Fri, 31 May 2013, Matthew Garrett wrote:
> > 
> > I agree that a revert is probably the right thing to do here, but the 
> > original patch was there to permit a more accurate calculation of the 
> > amount of nvram in use, not to provide additional debug information. 
> > Reverting it is going to differently break a different set of systems
> 
> So "differently break" doesn't matter, if it's old breakage, and people 
> thus don't really expect it to work. We need to fix bugs without *new* 
> breakage, and quite frankly, I have been distressed by hearing the EFI 
> "specifications" mentioned so many times in this thread.

The old breakage has only ever been present in -rcs, not in released 
kernels. We worked around the worst of it with the patchset that's 
causing the problems. We can avoid that old breakage by reverting the 
patches that introduced it, but that gets us back to bricking some 
machines.

> Anyway, I'm traveling with absolutely horrendous internet access, so can 
> somebody please send a description of the revert with the relevant 
> information, because I literally have a hard time extracting it all from 
> this thread because my email access is so slow and flaky... Make it easy 
> for me to do the revert with a good explanation message, please,

I've finally got some information from Samsung that *should* let us fix 
this without anything else breaking in the process, but since we're 
dealing with firmware there's obviously a risk that that won't actually 
be true. I'll send that later today.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
