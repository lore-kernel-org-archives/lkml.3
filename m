Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437AbaDNH2E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 03:28:04 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:50305 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912AbaDNH2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 03:28:01 -0400
Date: Mon, 14 Apr 2014 09:27:56 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Brian Gerst <brgerst@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, stable <stable@vger.kernel.org>
Subject: Re: [tip:x86/urgent] x86-64, modify_ldt: Ban 16-bit segments on
 64-bit kernels
Message-ID: <20140414072755.GA719@gmail.com>
References: <tip-kicdm89kzw9lldryb1br9od0@git.kernel.org>
 <CAMzpN2jx4H4p8fQr-WHxVyCHhWi0iO3WZZKyxYD7Dfa7pWkEgg@mail.gmail.com>
 <CA+55aFwzvSiAGYfFb2R3JeVvh8_PQuOKJDrYP5C_3VQz2zhnBw@mail.gmail.com>
 <53483896.9070404@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53483896.9070404@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@linux.intel.com> wrote:

> On 04/11/2014 11:41 AM, Linus Torvalds wrote:
> > 
> > Ok, so you actually do this on x86-64, and it currently works? For
> > some reason I thought that 16-bit windows apps already didn't work.
> > 
> 
> Some will work, because not all 16-bit software care about the upper
> half of ESP getting randomly corrupted.
> 
> That is the "functionality bit" of the problem.  The other bit, of
> course, is that that random corruption is the address of the kernel stack.
> 
> > Because if we have working users of this, then I don't think we can do
> > the "we don't support 16-bit segments", or at least we need to make it
> > runtime configurable.
> 
> I'll let you pick what the policy should be here.  I personally 
> think that we have to be able to draw a line somewhere sometimes 
> (Microsoft themselves haven't supported running 16-bit binaries for 
> several Windows generations now), but it is your policy, not mine.

I think the mmap_min_addr model works pretty well:

 - it defaults to secure

 - allow a security policy to grant an exception to a known package, 
   built by the distro

 - end user can also grant an exception

This essentially punts any 'makes the system less secure' exceptions 
to the distro and the end user.

Thanks,

	Ingo
