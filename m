Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752346AbbABR2m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 12:28:42 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49227 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750717AbbABR2l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 12:28:41 -0500
Date: Fri, 2 Jan 2015 18:28:35 +0100
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Tejun Heo <tj@kernel.org>, Jan Kara <jack@suse.cz>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] lib: proportions.c:  Remove some unused functions
Message-ID: <20150102172835.GB14135@quack.suse.cz>
References: <1419087113-4087-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <20141222132626.2697567529c7708804c4061a@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141222132626.2697567529c7708804c4061a@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 22-12-14 13:26:26, Andrew Morton wrote:
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
> 
> Perhaps we should just ifdef it out, so the code is still sitting there if
> someone wishes to resurrect it.
  I believe the reason was API completeness. Ifdefing the code out looks
like a sensible thing to do - although I would be happier if we at least
compile-tested the code... Isn't there some config option we could key off
to detect something like all-yes config build?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
