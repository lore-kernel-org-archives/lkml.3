Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587Ab3EaKGV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 06:06:21 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:33486 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754016Ab3EaKGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 06:06:11 -0400
Date: Fri, 31 May 2013 12:06:06 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Russ Anderson <rja@sgi.com>
Cc: Matthew Garrett <matthew.garrett@nebula.com>, joeyli <jlee@suse.com>,
        Jiri Kosina <jkosina@suse.cz>, Matt Fleming <matt@console-pimps.org>,
        "matt.fleming@intel.com" <matt.fleming@intel.com>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Borislav Petkov <bp@alien8.de>
Subject: Re: [regression, bisected] x86: efi: Pass boot services variable
 info to runtime code
Message-ID: <20130531100606.GC30394@gmail.com>
References: <20130529210115.GC28027@sgi.com>
 <alpine.LRH.2.00.1305300018180.1111@twin.jikos.cz>
 <20130529224645.GA16582@sgi.com>
 <alpine.LNX.2.00.1305300048520.30576@pobox.suse.cz>
 <1369880172.17397.11.camel@linux-s257.site>
 <20130530221737.GA11105@sgi.com>
 <1369952512.11620.14.camel@x230>
 <20130530222836.GB11105@sgi.com>
 <1369953129.11620.15.camel@x230>
 <20130531025438.GB24287@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130531025438.GB24287@sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Russ Anderson <rja@sgi.com> wrote:

> On Thu, May 30, 2013 at 10:32:09PM +0000, Matthew Garrett wrote:
> > On Thu, 2013-05-30 at 17:28 -0500, Russ Anderson wrote:
> > > On Thu, May 30, 2013 at 10:21:53PM +0000, Matthew Garrett wrote:
> > > > On Thu, 2013-05-30 at 17:17 -0500, Russ Anderson wrote:
> > > > 
> > > > > That's a great idea.  This patch moves the QueryVariableInfo()
> > > > > call from bootime to runtime, in efi_late_init().  The attached
> > > > > patch is consistent with the UEFI spec and avoids the problem.
> > > > 
> > > > No, that defeats the entire point of the original patch.
> > > 
> > > How so?  It is still calling QueryVariableInfo()
> > > before the data is used.
> > 
> > We want to know how much space is used by variables that aren't visible
> > at runtime.
> 
> We want to boot.  We could boot up through 3.9-rc7.
> 
> Knowing how much space is used by variables that aren't
> visible at runtime it moot if you can't boot.

Exactly - fixing a boot regression is _WAY_ more important than pretty 
much any other concern.

and the boot breakage is not limited to UV systems - the thread mentioned 
a couple of other systems as well.

So it's an absolute no-brainer that this change should be reverted or 
fixed via your patch.

Once a safer mechanism is implemented to call QueryVariableInfo() earlier 
(Boris's patches?) the change can be reintroduced.

Thanks,

	Ingo
