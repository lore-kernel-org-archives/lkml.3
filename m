Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759619Ab3GZUZQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 16:25:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50251 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753594Ab3GZUZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 16:25:14 -0400
Date: Fri, 26 Jul 2013 13:25:12 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-stable <stable@vger.kernel.org>, hpa@linux.intel.com,
        hjl.tools@gmail.com, mingo@kernel.org, tglx@linutronix.de,
        "tip-bot for H.J. Lu" <tipbot@zytor.com>,
        linux-tip-commits@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [tip:x86/urgent] x86, fpu: correct the asm constraints for
 fxsave , unbreak mxcsr.daz
Message-ID: <20130726202512.GA4585@kroah.com>
References: <tip-eaa5a990191d204ba0f9d35dbe5505ec2cdd1460@git.kernel.org>
 <51F2D9D2.8050405@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51F2D9D2.8050405@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 26, 2013 at 01:19:30PM -0700, H. Peter Anvin wrote:
> Hi everyone,
> 
> I have tagged this one for -stable, but it is a definite "maybe", so I
> wanted to:
> 
> a) qualify that tagging, and
> b) perhaps use it as a boundary case for policy clarification.
> 
> This patch is an old bug, an incorrect assembly constraint, but as
> happens with this type of bug it is being exposed by a change in gcc.
> Therefore, although this is neither a regression per se in the kernel
> nor in gcc, it is a regression in the combined output.
> 
> The bug is obvious; the fix at the very least *should* be obvious; the
> main source of risk would appear that it might trigger bugs in very old
> versions of gcc.
> 
> The gain is less inherently obvious: currently the only MXCSR bit
> affected is DAZ, although this also affects any future MXCSR bits.  Most
> users do not care about DAZ, but the ones that do generally care *a lot*
> about it as their applications may suffer very bad performance otherwise.
> 
> There is a kernel bugzilla for this:
> 
> 	https://bugzilla.kernel.org/show_bug.cgi?id=60633
> 
> ... but it doesn't really add any additional information.

Thanks for the additional information, it's much appreciated.

greg k-h
