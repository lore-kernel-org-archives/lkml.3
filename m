Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966791Ab3E2UQY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 16:16:24 -0400
Received: from relay2.sgi.com ([192.48.179.30]:44322 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965519Ab3E2UQT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 16:16:19 -0400
Date: Wed, 29 May 2013 15:16:17 -0500
From: Russ Anderson <rja@sgi.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: Matthew Garrett <matthew.garrett@nebula.com>, matt.fleming@intel.com,
        linux-efi@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Josh Boyer <jwboyer@redhat.com>
Subject: Re: [regression, bisected] x86: efi: Pass boot services variable
	info to runtime code
Message-ID: <20130529201616.GB28027@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
References: <20130522162747.GA20816@sgi.com> <20130523115801.GJ14575@console-pimps.org> <20130523222321.GB31880@sgi.com> <20130524074544.GM14575@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130524074544.GM14575@console-pimps.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 24, 2013 at 08:45:44AM +0100, Matt Fleming wrote:
> On Thu, 23 May, at 05:23:21PM, Russ Anderson wrote:
> > Interesting data point.  The failure is on a rhel7/grub2 root.
> > The identical kernel on a rhel6/grub root boots.  So maybe
> > grub2 brings out the failure?  I suspect Fedora19/grub2 on
> > EFI should hit the problem (for someone looking to reproduce
> > it).
> > 
> > In both cases the kernel boot line options are the same.
> 
> I'll bet that rhel7 is using the EFI handover protocol which uses the
> internal mechanisms of the EFI boot stub.

To be more specific (now that I've dug through the code), grub2 (used
by rhel7) uses EFI boot stubs.  grub and elilo apparently do not use
EFI boot stubs, so they don't hit the problem (at least on my test
systems).



-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
