Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752461Ab3DLWAJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 18:00:09 -0400
Received: from mail-qc0-f176.google.com ([209.85.216.176]:39857 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875Ab3DLWAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 18:00:06 -0400
Date: Fri, 12 Apr 2013 14:59:56 -0700
From: Tejun Heo <tj@kernel.org>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, mingo@redhat.com, x86@kernel.org,
        rth@twiddle.net, linux@arm.linux.org.uk, msalter@redhat.com,
        starvik@axis.com, dhowells@redhat.com, tony.luck@intel.com,
        benh@kernel.crashing.org, takata@linux-m32r.org, geert@linux-m68k.org,
        james.hogan@imgtec.com, monstr@monstr.eu, ralf@linux-mips.org,
        jonas@southpole.se, rkuo@codeaurora.org, schwidefsky@de.ibm.com,
        liqin.chen@sunplusct.com, davem@davemloft.net, lethal@linux-sh.org,
        vgupta@synopsys.com, chris@zankel.net, ysato@users.sourceforge.jp,
        gxt@mprc.pku.edu.cn, jdike@addtoit.com,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux-s390@vger.kernel.org,
        Mike Frysinger <vapier@gentoo.org>,
        uclinux-dist-devel@blackfin.uclinux.org,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [PATCH 3/7] dump_stack: consolidate dump_stack() implementations
 and unify their behaviors
Message-ID: <20130412215956.GG11956@mtj.dyndns.org>
References: <1365016497-32033-1-git-send-email-tj@kernel.org>
 <1365016497-32033-4-git-send-email-tj@kernel.org>
 <516870E5.3050901@tilera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <516870E5.3050901@tilera.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Apr 12, 2013 at 04:39:01PM -0400, Chris Metcalf wrote:
> On 4/3/2013 3:14 PM, Tejun Heo wrote:
> > This patch expands the dummy fallback dump_stack() implementation in
> > lib/dump_stack.c such that it prints out debug information (taken from
> > x86) and invokes show_stack(NULL, NULL) and drops arch-specific
> > dump_stack() implementations in all archs except blackfin.  Blackfin's
> > dump_stack() does something wonky that I don't understand.
> 
> arch/tile has a dump_stack() entry point in assembly (see
> arch/tile/kernel/entry.S) that passes to _dump_stack(), which passes
> to dump_stack_regs(), which passes to tile_show_stack().  Similarly,
> show_stack() passes to tile_show_stack(), which does lots of work to
> cross into userspace and continue showing the stack if possible,
> print symbol info for both kernel and userspace, etc.  I don't know
> if that's all supported fully in Tejun's generic version.

I see.  In that case, this patchset shouldn't change anything for tile
as the generic dump_stack() is linked iff arch implementation doesn't
exist.

> Would it make sense for me to look at this after it's merged up into
> -next and see what tile needs?  Unfortunately I'm taking off for a
> week's vacation so won't be able to do much until after the 23rd.

It'd be nice to get it inline with other archs but I don't think
updating tile to print the common debug info is a priority, so no
problem with dealing with it later.

Thanks.

Thanks.

-- 
tejun
