Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752557AbbAMORA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 09:17:00 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:37755 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbbAMOQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 09:16:58 -0500
Date: Tue, 13 Jan 2015 15:16:52 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Tejun Heo <tj@kernel.org>, Jan Kara <jack@suse.cz>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib: proportions.c:  Remove some unused functions
Message-ID: <20150113141652.GJ25256@twins.programming.kicks-ass.net>
References: <1419087113-4087-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <20141222132626.2697567529c7708804c4061a@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141222132626.2697567529c7708804c4061a@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 22, 2014 at 01:26:26PM -0800, Andrew Morton wrote:
> On Sat, 20 Dec 2014 15:51:53 +0100 Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se> wrote:
> 
> > Removes some functions that are not used anywhere:
> > prop_change_shift() prop_descriptor_init() prop_fraction_percpu() prop_fraction_single() __prop_inc_percpu_max() prop_local_destroy_percpu() prop_local_destroy_single() prop_local_init_percpu() prop_local_init_single()
> > 
> > This was partially found by using a static code analysis program called cppcheck.
> > 
> > ---
> >  include/linux/proportions.h |   14 ----
> >  lib/proportions.c           |  177 -------------------------------------------
> >  2 files changed, 191 deletions(-)
> 
> Gee, that's a heck of a lot of dead code.
> 
> Peter, what was the thinking here?  Was this code once used, or added
> for API completeness or what?

Some of it was used once, we changed the BDI code over to the flexible
proportion code from Honza, that removed 

> Perhaps we should just ifdef it out, so the code is still sitting there if
> someone wishes to resurrect it.

If there are still users of the !flex proportion code I would argue to
just leave it sit there for API completeness. It doesn't actually harm
anyone. Linkers are very good at removing dead code.

If there are in fact no users left of the !flex proportion code, then we
should just kill the entire thing.
