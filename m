Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759393Ab3E3W2w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 18:28:52 -0400
Received: from relay3.sgi.com ([192.48.152.1]:34382 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756190Ab3E3W2j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 18:28:39 -0400
Date: Thu, 30 May 2013 17:28:36 -0500
From: Russ Anderson <rja@sgi.com>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: joeyli <jlee@suse.com>, Jiri Kosina <jkosina@suse.cz>,
        Matt Fleming <matt@console-pimps.org>,
        "matt.fleming@intel.com" <matt.fleming@intel.com>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Borislav Petkov <bp@alien8.de>
Subject: Re: [regression, bisected] x86: efi: Pass boot services variable
	info to runtime code
Message-ID: <20130530222836.GB11105@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
References: <20130523115801.GJ14575@console-pimps.org> <20130523203234.GD20913@sgi.com> <20130524074331.GL14575@console-pimps.org> <20130529210115.GC28027@sgi.com> <alpine.LRH.2.00.1305300018180.1111@twin.jikos.cz> <20130529224645.GA16582@sgi.com> <alpine.LNX.2.00.1305300048520.30576@pobox.suse.cz> <1369880172.17397.11.camel@linux-s257.site> <20130530221737.GA11105@sgi.com> <1369952512.11620.14.camel@x230>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369952512.11620.14.camel@x230>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 30, 2013 at 10:21:53PM +0000, Matthew Garrett wrote:
> On Thu, 2013-05-30 at 17:17 -0500, Russ Anderson wrote:
> 
> > That's a great idea.  This patch moves the QueryVariableInfo()
> > call from bootime to runtime, in efi_late_init().  The attached
> > patch is consistent with the UEFI spec and avoids the problem.
> 
> No, that defeats the entire point of the original patch.

How so?  It is still calling QueryVariableInfo()
before the data is used.

-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
