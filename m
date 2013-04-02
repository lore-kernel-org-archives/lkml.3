Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760853Ab3DBGsY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 02:48:24 -0400
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:41934 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760636Ab3DBGsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 02:48:21 -0400
Date: Tue, 2 Apr 2013 08:48:08 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Tejun Heo <tj@kernel.org>, linux-arch@vger.kernel.org,
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
Subject: Re: [PATCH 3/5] dump_stack: consolidate dump_stack()
 implementations and unify their behaviors
Message-ID: <20130402084808.0c6d61f8@mschwide>
In-Reply-To: <20130330114534.GA5404@osiris>
References: <1364610428-2074-1-git-send-email-tj@kernel.org>
	<1364610428-2074-4-git-send-email-tj@kernel.org>
	<20130330114534.GA5404@osiris>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13040206-1948-0000-0000-000004B4CD55
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 Mar 2013 12:45:35 +0100
Heiko Carstens <heiko.carstens@de.ibm.com> wrote:

> On Fri, Mar 29, 2013 at 07:27:06PM -0700, Tejun Heo wrote:
> > Both dump_stack() and show_stack() are currently implemented by each
> > architecture.  show_stack(NULL, NULL) dumps the backtrace for the
> > current task as does dump_stack().  On some archs, dump_stack() prints
> > extra information - pid, utsname and so on - in addition to the
> > backtrace while the two are identical on other archs.
> 
> [...]
> 
> > This patch expands the dummy fallback dump_stack() implementation in
> > lib/dump_stack.c such that it prints out debug information (taken from
> > x86) and invokes show_stack(NULL, NULL) and drops arch-specific
> > dump_stack() implementations in all archs except blackfin and s390.
> > Blackfin's dump_stack() does something wonky that I don't understand
> > and s390 prints its own debug information which includes fields which
> > aren't accessible from arch-indepdent code.
> 
> The couple of extra fields aren't worth an s390 version of dump_stack()
> that differs from all other architectures.
> Please drop the s390 version as well. Thanks!

Hmm, we would lose task_thread_info(current)->cpu and current->thread.ksp,
I don't care much about the kernel stack pointer which has been stored at
the last call to __switch_to but the cpu number might be interesting.
Could we add the cpu number to the generic dump_stack version?

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

