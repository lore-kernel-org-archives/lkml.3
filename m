Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790Ab3A2BRX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 20:17:23 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:42126 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518Ab3A2BRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 20:17:21 -0500
Date: Mon, 28 Jan 2013 17:17:24 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Petr Holasek <pholasek@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
        Izik Eidus <izik.eidus@ravellosystems.com>,
        Rik van Riel <riel@redhat.com>, David Rientjes <rientjes@google.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 1/11] ksm: allow trees per NUMA node
In-Reply-To: <20130128150304.2e7a2fb4.akpm@linux-foundation.org>
Message-ID: <alpine.LNX.2.00.1301281707430.4947@eggly.anvils>
References: <alpine.LNX.2.00.1301251747590.29196@eggly.anvils> <alpine.LNX.2.00.1301251753380.29196@eggly.anvils> <20130128150304.2e7a2fb4.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jan 2013, Andrew Morton wrote:
> On Fri, 25 Jan 2013 17:54:53 -0800 (PST)
> Hugh Dickins <hughd@google.com> wrote:
> 
> > --- mmotm.orig/Documentation/vm/ksm.txt	2013-01-25 14:36:31.724205455 -0800
> > +++ mmotm/Documentation/vm/ksm.txt	2013-01-25 14:36:38.608205618 -0800
> > @@ -58,6 +58,13 @@ sleep_millisecs  - how many milliseconds
> >                     e.g. "echo 20 > /sys/kernel/mm/ksm/sleep_millisecs"
> >                     Default: 20 (chosen for demonstration purposes)
> >  
> > +merge_across_nodes - specifies if pages from different numa nodes can be merged.
> > +                   When set to 0, ksm merges only pages which physically
> > +                   reside in the memory area of same NUMA node. It brings
> > +                   lower latency to access to shared page. Value can be
> > +                   changed only when there is no ksm shared pages in system.
> > +                   Default: 1
> > +
> 
> The explanation doesn't really tell the operator whether or not to set
> merge_across_nodes for a particular machine/workload.
> 
> I guess most people will just shrug, turn the thing on and see if it
> improved things, but that's rather random.

Right.  I don't think we can tell them which is going to be better,
but surely we could do a better job of hinting at the tradeoffs.

I think we expect large NUMA machines with lots of memory to want the
better NUMA behavior of !merge_across_nodes, but machines with more
limited memory across short-distance NUMA nodes, to prefer the greater
deduplication of merge_across nodes.

Petr, do you have a more informative text for this?

Hugh
