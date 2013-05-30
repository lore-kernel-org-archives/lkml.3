Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759908Ab3E3Way (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 18:30:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57278 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751140Ab3E3Waq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 18:30:46 -0400
Date: Fri, 31 May 2013 00:30:43 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Russ Anderson <rja@sgi.com>
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
In-Reply-To: <20130530222836.GB11105@sgi.com>
Message-ID: <alpine.LNX.2.00.1305310029560.30576@pobox.suse.cz>
References: <20130523115801.GJ14575@console-pimps.org> <20130523203234.GD20913@sgi.com> <20130524074331.GL14575@console-pimps.org> <20130529210115.GC28027@sgi.com> <alpine.LRH.2.00.1305300018180.1111@twin.jikos.cz> <20130529224645.GA16582@sgi.com>
 <alpine.LNX.2.00.1305300048520.30576@pobox.suse.cz> <1369880172.17397.11.camel@linux-s257.site> <20130530221737.GA11105@sgi.com> <1369952512.11620.14.camel@x230> <20130530222836.GB11105@sgi.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 May 2013, Russ Anderson wrote:

> > > That's a great idea.  This patch moves the QueryVariableInfo()
> > > call from bootime to runtime, in efi_late_init().  The attached
> > > patch is consistent with the UEFI spec and avoids the problem.
> > 
> > No, that defeats the entire point of the original patch.
> 
> How so?  It is still calling QueryVariableInfo()
> before the data is used.

You lose information provided by QueryVariableInfo() about boot-only 
variables once the transition boot -> runtime has happened.

-- 
Jiri Kosina
SUSE Labs
