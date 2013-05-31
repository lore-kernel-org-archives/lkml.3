Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754292Ab3EaLGX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 07:06:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45652 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753928Ab3EaLGO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 07:06:14 -0400
Date: Fri, 31 May 2013 13:06:09 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Ingo Molnar <mingo@kernel.org>
Cc: Russ Anderson <rja@sgi.com>, joeyli <jlee@suse.com>,
        Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <matthew.garrett@nebula.com>, matt.fleming@intel.com,
        linux-efi@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [regression, bisected] x86: efi: Pass boot services variable
 info to runtime code
In-Reply-To: <20130531101250.GD30394@gmail.com>
Message-ID: <alpine.LNX.2.00.1305311259520.30576@pobox.suse.cz>
References: <20130523115801.GJ14575@console-pimps.org> <20130523203234.GD20913@sgi.com> <20130524074331.GL14575@console-pimps.org> <20130529210115.GC28027@sgi.com> <alpine.LRH.2.00.1305300018180.1111@twin.jikos.cz> <20130529224645.GA16582@sgi.com>
 <alpine.LNX.2.00.1305300048520.30576@pobox.suse.cz> <1369880172.17397.11.camel@linux-s257.site> <20130530221737.GA11105@sgi.com> <alpine.LNX.2.00.1305310023020.30576@pobox.suse.cz> <20130531101250.GD30394@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 May 2013, Ingo Molnar wrote:

> So this change needs to be reverted or fixed.

I don't think anyone is arguing against that.

My remark was purely to describe the current status quo and help to 
understand what exactly is happening, i.e.:

- QueryVariableInfo() should be a valid thing to do from inside boot  
  environment, according to the spec
- now we see that at least SGI bios (an probably other incarnations) 
  think otherwise
- if we are not able to fix / work around the bug in BIOS (*), we have to 
  make a choice between two evils -- either increase likelyhood of 
  bricking certain machines due to filling the EFI storage space, or 
  break booting on broken BIOSen
- the theory is that Borislav's 1:1 mapping patches will work this around; 
  one of the supporting arguments being that it's probably what Windows is 
  doing. I believe Borislav is in the process of testing this. But the 
  patches are not ready for mainline yet.

(*) If one would be naive enough, he'd believe that the pressure should be 
    put on the BIOS writers instead of OS to fix the bug :)

-- 
Jiri Kosina
SUSE Labs
