Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757687Ab3APCxc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 21:53:32 -0500
Received: from mga11.intel.com ([192.55.52.93]:32569 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756803Ab3APCxb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 21:53:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,476,1355126400"; 
   d="scan'208";a="274274966"
Date: Wed, 16 Jan 2013 10:53:26 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Jan Kara <jack@suse.cz>
Cc: Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org, chavey@google.com
Subject: Re: [PATCH v2] writeback: mark sysctl vm.block_dump for removal
Message-ID: <20130116025326.GB10000@localhost>
References: <1357938397-5413-1-git-send-email-tj@kernel.org>
 <20130114140227.GB2441@kernel.dk>
 <20130114174318.GD27942@mtj.dyndns.org>
 <20130114182203.GE27942@mtj.dyndns.org>
 <20130115162813.GB2668@htj.dyndns.org>
 <20130116020753.GB25806@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130116020753.GB25806@quack.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2013 at 03:07:53AM +0100, Jan Kara wrote:
> On Tue 15-01-13 08:28:13, Tejun Heo wrote:
> > vm.block_dump is nasty in that it dumps IO traces directly to printk.
> > It isn't scalable and can easily lead to looping behavior - IO
> > generating kernel message which in turn genreates log IO, ad
> > infinitum.
> > 
> > Now that proper tracepoints are in place, vm.block_dump isn't
> > necessary.  Generate a warning if used so that it can be removed down
> > the road.

> > +	if (!warned && block_dump) {
> > +		pr_warning("sysctl: vm.block_dump is scheduled for removal. Use tracepoints instead.\n");
> > +		pr_warning("sysctl: Please contact Jens Axboe <axboe@kernel.dk> if you require this.\n");
> > +		warned = true;

Looks good to me. A warning in dmesg is pertinent because the
block_dump users will be looking at dmesg for block dump results.

Hmm, perhaps a more practical tip on the usage of replacement
tracepoints or tool will help eliminate some user emails to Jens.

> > diff --git a/patches/series b/patches/series
> > index 9fb9bfe..b2582cb 100644
> > --- a/patches/series
> > +++ b/patches/series
> > @@ -18,3 +18,4 @@ kill-pool-gcwq
> >  remove-gcwq
> >  rename-nr_running
> >  cleanup-leftovers
> > +dbg

An extra chunk.

Reviewed-by: Fengguang Wu <fengguang.wu@intel.com>

Thanks!
