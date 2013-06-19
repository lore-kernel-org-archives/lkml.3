Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935149Ab3FSXin (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 19:38:43 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:63244 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934170Ab3FSXil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 19:38:41 -0400
Date: Wed, 19 Jun 2013 16:38:36 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: akpm@linux-foundation.org, tj@kernel.org, axboe@kernel.dk,
        nab@linux-iscsi.org, bcrl@kvack.org, linux-kernel@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [PATCH 03/10] idr: Rewrite ida
Message-ID: <20130619233836.GA6986@localhost>
References: <1371600150-23557-1-git-send-email-koverstreet@google.com>
 <1371600150-23557-4-git-send-email-koverstreet@google.com>
 <1371634822.2735.9.camel@menhir>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371634822.2735.9.camel@menhir>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 19, 2013 at 10:40:22AM +0100, Steven Whitehouse wrote:
> Hi,
> 
> On Tue, 2013-06-18 at 17:02 -0700, Kent Overstreet wrote:
> > This is a new, from scratch implementation of ida that should be
> > simpler, faster and more space efficient.
> > 
> [...]
> 
> > 
> > This does mean that the entire bitmap is stored in one contiguous memory
> > allocation - and as currently implemented we won't be able to allocate
> > _quite_ as many ids as with the previous implementation.
> > 
> > I don't expect this to be an issue in practice since anywhere this is
> > used, an id corresponds to a struct allocation somewher else - we can't
> > allocate an unbounded number of ids, we'll run out of memory somewhere
> > else eventually, and I expect that to be the limiting factor in
> > practice.
> > 
> > If a user/use case does come up where this matters I can add some
> > sharding (or perhaps add a separate big_ida implementation) - but the
> > extra complexity would adversely affect performance for the users that
> > don't need > millions of ids, so I intend to leave the implementation as
> > is until if and when this becomes an issue.
> > 
> 
> Millions of IDs is something that is fairly normal for DLM, since there
> will be two DLM locks per cached inode with GFS2 and people tend to use
> it on pretty large servers with lots of memory,

Thanks, I wasn't aware of that. Is the 31 bits for the id limitation an
issue for you? While I'm at changing ids to longs should be fairly
trivial.
