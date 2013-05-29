Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965125Ab3E2IPr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 04:15:47 -0400
Received: from mail-ea0-f170.google.com ([209.85.215.170]:63282 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965078Ab3E2IPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 04:15:43 -0400
Date: Wed, 29 May 2013 10:15:39 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Dimitri Sivanich <sivanich@sgi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Alexander Gordeev <agordeev@redhat.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Russ Anderson <rja@sgi.com>, Mike Travis <travis@sgi.com>
Subject: Re: [PATCH] x86/UV: GRU distributed mode mappings
Message-ID: <20130529081539.GA25444@gmail.com>
References: <20130523155013.GA16496@sgi.com>
 <20130528075912.GA29336@gmail.com>
 <20130528134106.GA5619@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130528134106.GA5619@sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dimitri Sivanich <sivanich@sgi.com> wrote:

> On Tue, May 28, 2013 at 09:59:12AM +0200, Ingo Molnar wrote:
> > 
> > * Dimitri Sivanich <sivanich@sgi.com> wrote:
> > 
> > > Setup mappings for GRU distributed mode and include them as untracked
> > > pat ranges.
> > 
> > Would be nice to have the customary changelog content:
> > 
> >   " Current code does (A), this has a problem when (B).
> >     We can improve this doing (C), because (D)."
> > 
> > Or so - your changelog is pretty light on the 'why' aspect.
> >
> How about the following?

Looks good to me.

> UV GRU hardware will support an optional distributed mode that will allow 
> per-node address mapping of local GRU space, as opposed to mapping all GRU
> hardware to the same contiguous high space.
> 
> If GRU distributed mode is selected, setup per-node page table mappings and
> include them as untracked pat ranges.
> 
> Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>
> ---
>  arch/x86/kernel/apic/x2apic_uv_x.c |   63 +++++++++++++++++++++++++++++----
>  1 file changed, 57 insertions(+), 6 deletions(-)

So this looks like suitable v3.11 material - not an urgent fix needed for 
v3.10, right?

Noticed this detail:

> +	} else
> +		return start >= gru_start_paddr && end <= gru_end_paddr;

in the kernel we generally try to balance curly braces - either all 
branches are curly or none.

> +	/* Save upper (63:M) bits of address only for is_GRU_range */
> +	gru_first_node_paddr &= gru_dist_umask;
> +	gru_last_node_paddr &= gru_dist_umask;
> +	pr_info("UV: Map GRU_DIST base 0x%016llx  0x%016llx - 0x%016llx\n",
> +		gru_dist_base, gru_first_node_paddr, gru_last_node_paddr);

I suspect this should be pr_debug()?

Thanks,

	Ingo
