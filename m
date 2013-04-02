Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762096Ab3DBS0M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 14:26:12 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:63535 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757676Ab3DBS0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 14:26:10 -0400
Date: Tue, 2 Apr 2013 11:26:04 -0700
From: Tejun Heo <tj@kernel.org>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        mingo@redhat.com, x86@kernel.org, rth@twiddle.net,
        linux@arm.linux.org.uk, msalter@redhat.com, starvik@axis.com,
        dhowells@redhat.com, tony.luck@intel.com, benh@kernel.crashing.org,
        takata@linux-m32r.org, geert@linux-m68k.org, james.hogan@imgtec.com,
        monstr@monstr.eu, ralf@linux-mips.org, jonas@southpole.se,
        rkuo@codeaurora.org, liqin.chen@sunplusct.com, davem@davemloft.net,
        lethal@linux-sh.org, vgupta@synopsys.com, chris@zankel.net,
        cmetcalf@tilera.com, ysato@users.sourceforge.jp, gxt@mprc.pku.edu.cn,
        jdike@addtoit.com, linux-s390@vger.kernel.org,
        Mike Frysinger <vapier@gentoo.org>,
        uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [PATCH 3/5] dump_stack: consolidate dump_stack() implementations
 and unify their behaviors
Message-ID: <20130402182604.GC6185@htj.dyndns.org>
References: <1364610428-2074-1-git-send-email-tj@kernel.org>
 <1364610428-2074-4-git-send-email-tj@kernel.org>
 <20130330114534.GA5404@osiris>
 <20130402084808.0c6d61f8@mschwide>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130402084808.0c6d61f8@mschwide>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Martin.

On Tue, Apr 02, 2013 at 08:48:08AM +0200, Martin Schwidefsky wrote:
> > The couple of extra fields aren't worth an s390 version of dump_stack()
> > that differs from all other architectures.
> > Please drop the s390 version as well. Thanks!
> 
> Hmm, we would lose task_thread_info(current)->cpu and current->thread.ksp,
> I don't care much about the kernel stack pointer which has been stored at
> the last call to __switch_to but the cpu number might be interesting.
> Could we add the cpu number to the generic dump_stack version?

Yeah, I can move CPU from show_regs() to dump_stack().  It actually
makes sense.  I'll do that and convert s390 together with other archs.

Thanks!

-- 
tejun
