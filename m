Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934673AbaICWrO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 18:47:14 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:56113 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933475AbaICWrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 18:47:01 -0400
X-Greylist: delayed 1868 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Sep 2014 18:47:01 EDT
Date: Wed, 3 Sep 2014 23:15:47 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "H. Peter Anvin" <h.peter.anvin@intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kees Cook <keescook@chromium.org>
Subject: Re: RFC: Tainting the kernel on raw I/O access
Message-ID: <20140903221547.GA21800@srcf.ucam.org>
References: <5407863B.9030608@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5407863B.9030608@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Cc: Kees)

On Wed, Sep 03, 2014 at 02:20:59PM -0700, H. Peter Anvin wrote:
> In a meeting earlier today, we discussed MSR access and that it could be
> used to do bad things.  The same applies to other forms of raw I/O
> (/dev/mem, /dev/port, ioperm, iopl, etc.)
> 
> This is basically the same problem with which the secure boot people
> have been struggling.
> 
> Peter Z. suggested we should taint the kernel on raw I/O access, and I
> tend to concur.
> 
> So what I would like to suggest is that we create a new kernel helper
> function which can return an error in secure boot mode and otherwise
> taints the kernel with a raw I/O taint.
> 
> What do people think?

Not a bad plan, but there's a couple of places where you'd want to 
forbid stuff in Secure Boot without tainting the kernel in the generic 
use-case, so there's still some problem to solve there.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
