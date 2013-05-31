Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748Ab3EaCR6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 22:17:58 -0400
Received: from relay1.sgi.com ([192.48.179.29]:50403 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751455Ab3EaCRu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 22:17:50 -0400
Date: Thu, 30 May 2013 21:17:49 -0500
From: Russ Anderson <rja@sgi.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Matthew Garrett <matthew.garrett@nebula.com>, joeyli <jlee@suse.com>,
        Matt Fleming <matt@console-pimps.org>,
        "matt.fleming@intel.com" <matt.fleming@intel.com>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Borislav Petkov <bp@alien8.de>
Subject: Re: [regression, bisected] x86: efi: Pass boot services variable
	info to runtime code
Message-ID: <20130531021749.GA24287@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
References: <20130524074331.GL14575@console-pimps.org> <20130529210115.GC28027@sgi.com> <alpine.LRH.2.00.1305300018180.1111@twin.jikos.cz> <20130529224645.GA16582@sgi.com> <alpine.LNX.2.00.1305300048520.30576@pobox.suse.cz> <1369880172.17397.11.camel@linux-s257.site> <20130530221737.GA11105@sgi.com> <1369952512.11620.14.camel@x230> <20130530222836.GB11105@sgi.com> <alpine.LNX.2.00.1305310029560.30576@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1305310029560.30576@pobox.suse.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 31, 2013 at 12:30:43AM +0200, Jiri Kosina wrote:
> On Thu, 30 May 2013, Russ Anderson wrote:
> 
> > > > That's a great idea.  This patch moves the QueryVariableInfo()
> > > > call from bootime to runtime, in efi_late_init().  The attached
> > > > patch is consistent with the UEFI spec and avoids the problem.
> > > 
> > > No, that defeats the entire point of the original patch.
> > 
> > How so?  It is still calling QueryVariableInfo()
> > before the data is used.
> 
> You lose information provided by QueryVariableInfo() about boot-only 
> variables once the transition boot -> runtime has happened.

Is that information really more important than the ability
to boot?

Correct me if I'm wrong, but linux was able to boot without
the boottime QueryVariableInfo() call up until 3.9-rc7,
and it still does on systems that do not use EFI stubs (ie
grub and elilo).  It is only when linux uses EFI stubs (ie
grub2) that linux makes the boottime QueryVariableInfo()
call.  So why is that call, or whatever is dependent on it,
more important than booting?



Thanks,
-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
