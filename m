Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512Ab3EXUtn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 16:49:43 -0400
Received: from relay2.sgi.com ([192.48.179.30]:59369 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753787Ab3EXUtm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 16:49:42 -0400
Date: Fri, 24 May 2013 15:49:38 -0500
From: Russ Anderson <rja@sgi.com>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: Matt Fleming <matt@console-pimps.org>,
        "matt.fleming@intel.com" <matt.fleming@intel.com>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Borislav Petkov <bp@alien8.de>
Subject: Re: [regression, bisected] x86: efi: Pass boot services variable
 info to runtime code
Message-ID: <20130524204937.GB3322@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
References: <20130522162747.GA20816@sgi.com>
 <20130523115801.GJ14575@console-pimps.org>
 <20130523203234.GD20913@sgi.com>
 <20130524074331.GL14575@console-pimps.org>
 <20130524200539.GA3322@sgi.com>
 <1369426255.2217.9.camel@x230>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369426255.2217.9.camel@x230>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 24, 2013 at 08:11:01PM +0000, Matthew Garrett wrote:
> On Fri, 2013-05-24 at 15:05 -0500, Russ Anderson wrote:
> 
> > One other data point is if the query_variable_info call is hacked to
> > remove one of the EFI flags (ie comment out EFI_VARIABLE_BOOTSERVICE_ACCESS)
> > the efi_call_phys4() call fails with EFI_INVALID_PARAMETER and
> > the system boots.  Of course it does not create /sys/firmware/efivars
> > entries and complains "[Firmware Bug]: efi: Inconsistent initial sizes".
> > But at least it boots.
> 
> EFI_VARIABLE_RUNTIME_ACCESS is only legal if
> EFI_VARIABLE_BOOTSERVICE_ACCESS is set, so it's correct to throw
> EFI_INVALID_PARAMETER there.

Yes.  The point of the experiment was to see if it returned a
valid failure status (which it did) and see if the boot still
failed (which it didn't).  So something about going deeper
into that call seems to trigger the failure.

Why does the kernel still try to create /sys/firmware/efivars/
entries in the original failure even though efi_call_phys4()
failed?  Or does it always try to create those entries
and GetNextVariable() blows up in the original failure
but not in my experiment?

Thanks,
-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
