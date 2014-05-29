Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757374AbaE2NZE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 09:25:04 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:45272 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756143AbaE2NZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 09:25:01 -0400
Date: Thu, 29 May 2014 14:23:21 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Borislav Petkov <bp@alien8.de>
Cc: Minchan Kim <minchan@kernel.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Hugh Dickins <hughd@google.com>, rusty@rustcorp.com.au, mst@redhat.com,
        Dave Hansen <dave.hansen@intel.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC 2/2] x86_64: expand kernel stack to 16K
Message-ID: <20140529142321.6ac951d3@alan.etchedpixels.co.uk>
In-Reply-To: <20140528092717.GA17220@pd.tnic>
References: <1401260039-18189-1-git-send-email-minchan@kernel.org>
	<1401260039-18189-2-git-send-email-minchan@kernel.org>
	<20140528092717.GA17220@pd.tnic>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hmm, stupid question: what happens when 16K is not enough too, do we
> increase again? When do we stop increasing? 1M, 2M... ?

It's not a stupid question, it's IMHO the most important question

> Sounds like we want to make it a config option with a couple of sizes
> for everyone to be happy. :-)

At the moment it goes bang if you freakily get three layers of recursion
through allocations. But show me the proof we can't already hit four, or
five, or six  ....

We don't *need* to allocate tons of stack memory to each task just because
we might recursively allocate. We don't solve the problem by doing so
either. We at best fudge over it.

Why is *any* recursive memory allocation not ending up waiting for other
kernel worker threads to free up memory (beyond it being rather hard to
go and retrofit) ?


