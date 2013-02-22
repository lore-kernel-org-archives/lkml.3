Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758534Ab3BVUvJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 15:51:09 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:61027 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758477Ab3BVUvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 15:51:05 -0500
Date: Fri, 22 Feb 2013 12:50:25 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Ric Mason <ric.masonn@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Petr Holasek <pholasek@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Izik Eidus <izik.eidus@ravellosystems.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/7] ksm: add some comments
In-Reply-To: <5126F360.1060507@gmail.com>
Message-ID: <alpine.LNX.2.00.1302221239450.6100@eggly.anvils>
References: <alpine.LNX.2.00.1302210013120.17843@eggly.anvils> <alpine.LNX.2.00.1302210018100.17843@eggly.anvils> <5126F360.1060507@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Feb 2013, Ric Mason wrote:
> 
> What's the root reason merge_across_nodes setting just can be changed only
> when there are no ksm shared pages in system?

Simplicity.  Why add code (moving nodes from tree to tree, handling
the collisions) for a rare case that doesn't need to be fast?

> Can they be unmerged and merged again during ksmd scan?

That's more or less what happens, isn't it?  Perhaps you're
asking why the admin has to echo 2 >run; echo 0 >merge; echo 1 >run
instead of that all happening automatically inside the echo 0 > merge?

If I'd implemented it myself, I might have chosen to do it that way;
but neither I nor other reviewers felt strongly enough to change that,
though we could do so.

Hugh
