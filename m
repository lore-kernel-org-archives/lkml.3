Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753617AbaIDP3o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 11:29:44 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:60042 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752525AbaIDP3l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 11:29:41 -0400
Date: Thu, 4 Sep 2014 11:29:29 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linuxfoundation.org>, Rik van Riel <riel@redhat.com>,
        David Rientjes <rientjes@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Fengguang Wu <fengguang.wu@intel.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: page_alloc: Default to node-ordering on 64-bit NUMA
 machines
Message-ID: <20140904152915.GB10794@cmpxchg.org>
References: <20140901125551.GI12424@suse.de>
 <20140902135120.GC29501@cmpxchg.org>
 <20140902152143.GL12424@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140902152143.GL12424@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 02, 2014 at 04:21:43PM +0100, Mel Gorman wrote:
> On Tue, Sep 02, 2014 at 09:51:20AM -0400, Johannes Weiner wrote:
> > On Mon, Sep 01, 2014 at 01:55:51PM +0100, Mel Gorman wrote:
> > > I cannot find a good reason to incur a performance penalty on all 64-bit NUMA
> > > machines in case someone throws a brain damanged TV or graphics card in there.
> > > This patch defaults to node-ordering on 64-bit NUMA machines. I was tempted
> > > to make it default everywhere but I understand that some embedded arches may
> > > be using 32-bit NUMA where I cannot predict the consequences.
> > 
> > This patch is a step in the right direction, but I'm not too fond of
> > further fragmenting this code and where it applies, while leaving all
> > the complexity from the heuristics and the zonelist building in, just
> > on spec.  Could we at least remove the heuristics too?  If anybody is
> > affected by this, they can always override the default on the cmdline.
> 
> I see no problem with deleting the heuristics. Default node for 64-bit
> and default zone for 32-bit sound ok to you?

Is there a strong reason against defaulting both to node order?  Zone
ordering, if anything, is a niche application.  We might even be able
to remove it in the future.  We still have the backup of allowing the
user to explicitely request zone ordering on the commandline, should
someone depend on it unexpectedly.
