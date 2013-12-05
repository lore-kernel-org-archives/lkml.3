Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756094Ab3LELeI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 06:34:08 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43982 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755741Ab3LELeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 06:34:05 -0500
Date: Thu, 5 Dec 2013 11:33:48 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Will Deacon <will.deacon@arm.com>,
        Vyacheslav Tyrtov <v.tyrtov@samsung.com>
Subject: Re: [PATCH 1/2] ARM: check stack pointer in get_wchan
Message-ID: <20131205113348.GE4360@n2100.arm.linux.org.uk>
References: <20131205083424.32632.51618.stgit@buzz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131205083424.32632.51618.stgit@buzz>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 05, 2013 at 12:34:24PM +0400, Konstantin Khlebnikov wrote:
> get_wchan() is lockless. Task may wakeup at any time and change its own stack,
> thus each next stack frame may be overwritten and filled with random stuff.
> 
> /proc/$pid/stack interface had been disabled for non-current tasks, see [1]
> But 'wchan' still allows to trigger stack frame unwinding on volatile stack.
> 
> This patch fixes oops in unwind_frame() by adding stack pointer validation on
> each step (as x86 code do), unwind_frame() already checks frame pointer.
> 
> Also I've found another report of this oops on stackoverflow (irony).

Your two patches look fine to me.  Please put them in the patch system
and we'll get them merged - I think they should also be merged into stable
trees too - it looks like this goes all the way back to 2.6.30 kernels.

Thanks.
