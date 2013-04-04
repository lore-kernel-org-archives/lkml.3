Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763601Ab3DDHN2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 03:13:28 -0400
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:46255 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763126Ab3DDHN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 03:13:26 -0400
Date: Thu, 4 Apr 2013 09:13:09 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, mingo@redhat.com, x86@kernel.org,
        rth@twiddle.net, linux@arm.linux.org.uk, msalter@redhat.com,
        starvik@axis.com, dhowells@redhat.com, tony.luck@intel.com,
        benh@kernel.crashing.org, takata@linux-m32r.org, geert@linux-m68k.org,
        james.hogan@imgtec.com, monstr@monstr.eu, ralf@linux-mips.org,
        jonas@southpole.se, rkuo@codeaurora.org, liqin.chen@sunplusct.com,
        davem@davemloft.net, lethal@linux-sh.org, vgupta@synopsys.com,
        chris@zankel.net, cmetcalf@tilera.com, ysato@users.sourceforge.jp,
        gxt@mprc.pku.edu.cn, jdike@addtoit.com,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux-s390@vger.kernel.org,
        Mike Frysinger <vapier@gentoo.org>,
        uclinux-dist-devel@blackfin.uclinux.org,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [PATCH 3/7] dump_stack: consolidate dump_stack()
 implementations and unify their behaviors
Message-ID: <20130404091309.5c9da9d3@mschwide>
In-Reply-To: <1365016497-32033-4-git-send-email-tj@kernel.org>
References: <1365016497-32033-1-git-send-email-tj@kernel.org>
	<1365016497-32033-4-git-send-email-tj@kernel.org>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13040407-1948-0000-0000-000004BB6BD0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  3 Apr 2013 12:14:53 -0700
Tejun Heo <tj@kernel.org> wrote:

> v2: CPU number added to the generic debug info as requested by s390
>     folks and dropped the s390 specific dump_stack().  This loses %ksp
>     from the debug message which the maintainers think isn't important
>     enough to keep the s390-specific dump_stack() implementation.
> 
>     dump_stack_print_info() is moved to kernel/printk.c from
>     lib/dump_stack.c.  Because linkage is per objecct file,
>     dump_stack_print_info() living in the same lib file as generic
>     dump_stack() means that archs which implement custom dump_stack()
>     - at this point, only blackfin - can't use dump_stack_print_info()
>     as that will bring in the generic version of dump_stack() too.  v1
>     The v1 patch broke build on blackfin due to this issue.  The build
>     breakage was reported by Fengguang Wu.

For the s390 changes:
Acked-by: Martin Schwidefsky <schwidefsky@de.ibm.com>

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

