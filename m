Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234Ab3EaXax (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 19:30:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39512 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755013Ab3EaXap (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 19:30:45 -0400
Date: Sat, 1 Jun 2013 01:30:39 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Russ Anderson <rja@sgi.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@alien8.de>,
        joeyli <jlee@suse.com>, Matt Fleming <matt@console-pimps.org>,
        matt.fleming@intel.com, linux-efi@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [regression, bisected] x86: efi: Pass boot services variable
 info to runtime code
In-Reply-To: <20130531225730.GB14752@sgi.com>
Message-ID: <alpine.LNX.2.00.1306010124420.2852@pobox.suse.cz>
References: <alpine.LNX.2.00.1305310023020.30576@pobox.suse.cz> <20130531101250.GD30394@gmail.com> <alpine.LNX.2.00.1305311259520.30576@pobox.suse.cz> <20130531123015.GC17843@nazgul.tnic> <20130531124356.GA8212@gmail.com> <20130531143425.GA5850@srcf.ucam.org>
 <1370011357.1913.15.camel@dabdike.int.hansenpartnership.com> <20130531144826.GB5850@srcf.ucam.org> <20130531154348.GA17145@sgi.com> <20130531162815.GA8082@srcf.ucam.org> <20130531225730.GB14752@sgi.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 May 2013, Russ Anderson wrote:

> OK.  I get nvram looks full due to lack of garbage collection
> on some systems.  Does QueryVariableInfo (at runtime) tell you
> it is full?  Is the problem that it says it is full when it
> is not, or does not tell you it is full when it is?

We are trying to count the size occupied by existing UEFI variables. 
QueryVariableInfo() called from runtime environment doesn't give a full 
picture, as it doesn't provide information about boot-only variables.

Hence the patch.

> > up the size of the variables ourselves, but that only gives us the value 
> > for runtime-visible variables. We also need to know how much space is 
> > used by variables that are only visible during boot,
> 
> Is it valid to assume that only the kernel writes to nvram at
> runtime?  

Well, mostly yes. But if the kernel doesn't know what the initial state 
is, it can't count the size properly.

> > > Which means the previous patch(es) that caused the bricking should
> > > get pulled, too.
> > 
> > There are no patches that cause the bricking.
> 
> I thought that was the problem you were trying to avoid.

The problem that needs to be avoided is machines turning into bricks if 
EFI storage nvram is getting full.

-- 
Jiri Kosina
SUSE Labs
