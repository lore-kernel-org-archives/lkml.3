Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759083Ab3DYQt5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 12:49:57 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:56746
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758966Ab3DYQtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 12:49:55 -0400
Date: Thu, 25 Apr 2013 18:48:37 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        eranian@google.com, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/2] Fix perf LBR filtering
Message-ID: <20130425164837.GD5828@dyad.programming.kicks-ass.net>
References: <1366844694-2770-1-git-send-email-andi@firstfloor.org>
 <20130425162535.GA5828@dyad.programming.kicks-ass.net>
 <20130425164100.GC16732@two.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130425164100.GC16732@two.firstfloor.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 25, 2013 at 06:41:00PM +0200, Andi Kleen wrote:
> > So why not do the same as we do for userspace? Copy MAX_INSN_SIZE bytes
> > and trap -EFAULT.
> 
> Read the whole description, then you'll know why that is insecure.

You didn't actually explicitly mention it; you just said unconditional reading
of random addresses was bad.

You list:

> But that is dangerous if can be controlled by the user:
> - It can be used to crash the kernel
> - It allows to probe any physical address for a small set of values
> (valid call op codes) which is an information leak.
> - It may point to a side effect on read MMIO region

Traping the read deals with the first. The second shouldn't be a problem since
we generally only allow kernel info for CAP_ADMIN; if we don't already for LBR
that needs to be fixed separately.

That only leaves the third.. can we descern MMIO maps from the kernel page tables?

