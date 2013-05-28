Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759257Ab3E1XPG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 19:15:06 -0400
Received: from merlin.infradead.org ([205.233.59.134]:42951 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758468Ab3E1XPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 19:15:05 -0400
Message-ID: <1369782894.21216.25.camel@smoke>
Subject: Re: [PATCH 20/21] powerpc/ps3: remove inline marking of
 EXPORT_SYMBOL functions
From: Geoff Levand <geoff@infradead.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Denis Efremov <yefremov.denis@gmail.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jiri Kosina <trivial@kernel.org>, ldv-project@linuxtesting.org
Date: Tue, 28 May 2013 16:14:54 -0700
In-Reply-To: <CAMuHMdUU5+WJnYER8kO2Ne2iaBQESYp_bbBMTLDvTEJchDu15A@mail.gmail.com>
References: <1368086241-9357-1-git-send-email-yefremov.denis@gmail.com>
	 <1368095819-11011-9-git-send-email-yefremov.denis@gmail.com>
	 <CAMuHMdUU5+WJnYER8kO2Ne2iaBQESYp_bbBMTLDvTEJchDu15A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

On Fri, 2013-05-17 at 18:05 +0200, Geert Uytterhoeven wrote:
> On Thu, May 9, 2013 at 12:36 PM, Denis Efremov <yefremov.denis@gmail.com> wrote:
> > -inline u64 ps3_get_spe_id(void *arg)
> > +u64 ps3_get_spe_id(void *arg)
> >  {
> >         return spu_pdata(arg)->spe_id;
> >  }
> 
> FYI, this symbol is not used in mainline.
> 
> IIRC, it's used for profiling only. Any chance the profile code will
> ever make it
> in mainline?

As I announced (below), I dropped the profiling patches since
ps3-queue-v3.8.

The profiling code does not use ps3_get_spe_id(), so I think we should
remove it.  I'll submit a patch.

-Geoff

-------- Forwarded Message --------
From: Geoff Levand <geoff@infradead.org>
To: cbe-oss-dev@lists.ozlabs.org
Subject: Dropping PS3 oprofile support in v3.8
Date: Wed, 13 Feb 2013 17:30:39 -0800

Hi All,

I'll be dropping the PS3 oprofile patches from my ps3-linux git tree
from linux-3.8.  These are the patches: 

 7f02610 ps3-debugging: Add oprofile test script
 49213b6 powerpc/ps3: PS3 oprofile support
 aee2985 powerpc/ps3: Add ps3 pmu platform routines
 531c3f4 powerpc/ps3: Rearrange order of lpm routines
 9d8a7d3 powerpc/cell: Add pmu platform abstraction
 6865b99 powerpc/cell: Rearrange order of pmu routines

These patches will still be available in the ps3-queue-v3.7 and earlier
branches for anyone who wants them.

-Geoff




