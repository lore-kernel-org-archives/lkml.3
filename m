Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198Ab3C3Lpr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 07:45:47 -0400
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:33667 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754486Ab3C3Lpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 07:45:44 -0400
Date: Sat, 30 Mar 2013 12:45:35 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, mingo@redhat.com, x86@kernel.org,
        rth@twiddle.net, linux@arm.linux.org.uk, msalter@redhat.com,
        starvik@axis.com, dhowells@redhat.com, tony.luck@intel.com,
        benh@kernel.crashing.org, takata@linux-m32r.org, geert@linux-m68k.org,
        james.hogan@imgtec.com, monstr@monstr.eu, ralf@linux-mips.org,
        jonas@southpole.se, rkuo@codeaurora.org, schwidefsky@de.ibm.com,
        liqin.chen@sunplusct.com, davem@davemloft.net, lethal@linux-sh.org,
        vgupta@synopsys.com, chris@zankel.net, cmetcalf@tilera.com,
        ysato@users.sourceforge.jp, gxt@mprc.pku.edu.cn, jdike@addtoit.com,
        linux-s390@vger.kernel.org, Mike Frysinger <vapier@gentoo.org>,
        uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [PATCH 3/5] dump_stack: consolidate dump_stack() implementations
 and unify their behaviors
Message-ID: <20130330114534.GA5404@osiris>
References: <1364610428-2074-1-git-send-email-tj@kernel.org>
 <1364610428-2074-4-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364610428-2074-4-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13033011-3548-0000-0000-000004F2C008
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 29, 2013 at 07:27:06PM -0700, Tejun Heo wrote:
> Both dump_stack() and show_stack() are currently implemented by each
> architecture.  show_stack(NULL, NULL) dumps the backtrace for the
> current task as does dump_stack().  On some archs, dump_stack() prints
> extra information - pid, utsname and so on - in addition to the
> backtrace while the two are identical on other archs.

[...]

> This patch expands the dummy fallback dump_stack() implementation in
> lib/dump_stack.c such that it prints out debug information (taken from
> x86) and invokes show_stack(NULL, NULL) and drops arch-specific
> dump_stack() implementations in all archs except blackfin and s390.
> Blackfin's dump_stack() does something wonky that I don't understand
> and s390 prints its own debug information which includes fields which
> aren't accessible from arch-indepdent code.

The couple of extra fields aren't worth an s390 version of dump_stack()
that differs from all other architectures.
Please drop the s390 version as well. Thanks!

