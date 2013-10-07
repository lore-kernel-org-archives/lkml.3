Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360Ab3JGXdb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 19:33:31 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40721 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819Ab3JGXd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 19:33:28 -0400
Date: Tue, 8 Oct 2013 00:33:10 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Fengguang Wu <fengguang.wu@intel.com>, xen-devel@lists.xenproject.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [xen] double fault: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
Message-ID: <20131007233310.GA24844@n2100.arm.linux.org.uk>
References: <20131006082340.GA24568@localhost> <CA+55aFxk2FoG7+BpHJAysR2bz-WQXpje6buMd8Sp6-SBqHexZg@mail.gmail.com> <20131007021118.GA27927@localhost> <20131007051038.GA9764@localhost> <CA+55aFz85in-ntjF_VT4=kBoUrw1m8ON7xL-=431vQKL5oCMxQ@mail.gmail.com> <20131007083505.GA22585@localhost> <CA+55aFzknXawREZRBrr0Hs+crKt62fPf+S8SubJHXk84U8AFaw@mail.gmail.com> <20131007222925.GV12758@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131007222925.GV12758@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 07, 2013 at 11:29:25PM +0100, Russell King - ARM Linux wrote:
> However, due to the problems with x86, that's fallen on its head and I
> have no solution to get better debugging out which works across all
> architectures.  I'm stumpted by this.

The final attempt at trying to sort this may be to try allocating
a struct at release time to contain a pointer to the kobject and
the delayed work queue, and maybe a stack trace.  The thing I worry
about is whether we can allocate memory at that point.  GFP_ATOMIC
maybe?  Should be a small enough structure that it shouldn't eat
too much into the reserved pools.

I won't be coding it up tonight though!
