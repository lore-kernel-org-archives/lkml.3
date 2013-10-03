Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756367Ab3JCFpz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 01:45:55 -0400
Received: from mail-ea0-f182.google.com ([209.85.215.182]:57058 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754216Ab3JCFpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 01:45:53 -0400
Date: Thu, 3 Oct 2013 07:45:48 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Mike Travis <travis@sgi.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dimitri Sivanich <sivanich@sgi.com>, Hedi Berriche <hedi@sgi.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/7] KGDB/KDB: add support for external NMI handler to
 call KGDB/KDB.
Message-ID: <20131003054548.GA25345@gmail.com>
References: <20130923212459.544517569@asylum.americas.sgi.com>
 <20130923212500.866318244@asylum.americas.sgi.com>
 <52449CED.803@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52449CED.803@windriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jason Wessel <jason.wessel@windriver.com> wrote:

> On 09/23/2013 04:25 PM, Mike Travis wrote:
> > This patch adds a kgdb_nmicallin() interface that can be used by
> > external NMI handlers to call the KGDB/KDB handler.  The primary need
> > for this is for those types of NMI interrupts where all the CPUs
> > have already received the NMI signal.  Therefore no send_IPI(NMI)
> > is required, and in fact it will cause a 2nd unhandled NMI to occur.
> > This generates the "Dazed and Confuzed" messages.
> > 
> > Since all the CPUs are getting the NMI at roughly the same time, it's not
> > guaranteed that the first CPU that hits the NMI handler will manage to
> > enter KGDB and set the dbg_master_lock before the slaves start entering.
> > The new argument "send_ready" was added for KGDB to signal the NMI handler
> > to release the slave CPUs for entry into KGDB.
> > 
> > Signed-off-by: Mike Travis <travis@sgi.com>
> > Reviewed-by: Dimitri Sivanich <sivanich@sgi.com>
> > Reviewed-by: Hedi Berriche <hedi@sgi.com>
> 
> One problem that I pointed out before and then you can add 
> 
> Acked-by: Jason Wessel <jason.wessel@windriver.com>
>
> > ---
> >  include/linux/kdb.h             |    1 +
> >  include/linux/kgdb.h            |    1 +
> >  kernel/debug/debug_core.c       |   30 +++++++++++++++++++++++++++++-
> >  kernel/debug/debug_core.h       |    1 +
> >  kernel/debug/kdb/kdb_debugger.c |    5 ++++-
> >  kernel/debug/kdb/kdb_main.c     |    3 +++
> >  6 files changed, 39 insertions(+), 2 deletions(-)

Jason, would you be fine with me merging this via tip:x86/uv with your 
Acked-by? That is the tree where the actual usecase of this callback would 
be merged upstream (v3.13-ish), and most of the other commits are x86/uv 
specific.

Thanks,

	Ingo
