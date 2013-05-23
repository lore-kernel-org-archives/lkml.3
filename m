Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759790Ab3EWWXZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 18:23:25 -0400
Received: from relay1.sgi.com ([192.48.179.29]:37305 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759725Ab3EWWXX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 18:23:23 -0400
Date: Thu, 23 May 2013 17:23:21 -0500
From: Russ Anderson <rja@sgi.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: Matthew Garrett <matthew.garrett@nebula.com>, matt.fleming@intel.com,
        linux-efi@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [regression, bisected] x86: efi: Pass boot services variable
 info to runtime code
Message-ID: <20130523222321.GB31880@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
References: <20130522162747.GA20816@sgi.com>
 <20130523115801.GJ14575@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130523115801.GJ14575@console-pimps.org>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 23, 2013 at 12:58:01PM +0100, Matt Fleming wrote:
> On Wed, 22 May, at 11:27:47AM, Russ Anderson wrote:
> > [    6.062157] EFI Variables Facility v0.08 2004-May-17
> > [    6.067731] BUG: unable to handle kernel paging request at 000000007ca95b10
> > [    6.075519] IP: [<ffff88007dbf2140>] 0xffff88007dbf213f
> 
> This is a bit of a head scratcher. Could you paste the EFI memmap
> entries in your dmesg for the regions that cover 0x7ca95b10 and
> 0x7dbf2140?  My guess would be that they're EFI runtime code regions,
> which would at least explain why we seem to be executing code in the
> direct mapping region (0xffff8800xxxxxxxx).
> 
> Are you booting via the EFI boot stub?

Interesting data point.  The failure is on a rhel7/grub2 root.
The identical kernel on a rhel6/grub root boots.  So maybe
grub2 brings out the failure?  I suspect Fedora19/grub2 on
EFI should hit the problem (for someone looking to reproduce
it).

In both cases the kernel boot line options are the same.

-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
