Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753789AbbAHIXp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 03:23:45 -0500
Received: from lgeamrelo04.lge.com ([156.147.1.127]:44957 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752908AbbAHIXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 03:23:44 -0500
X-Original-SENDERIP: 10.177.222.153
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Thu, 8 Jan 2015 17:23:53 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] mm/compaction: add tracepoint to observe behaviour
 of compaction defer
Message-ID: <20150108082353.GE25453@js1304-P5Q-DELUXE>
References: <1417593127-6819-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1417593127-6819-3-git-send-email-iamjoonsoo.kim@lge.com>
 <54ABC6AF.1020108@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54ABC6AF.1020108@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2015 at 12:27:43PM +0100, Vlastimil Babka wrote:
> On 12/03/2014 08:52 AM, Joonsoo Kim wrote:
> > compaction deferring logic is heavy hammer that block the way to
> > the compaction. It doesn't consider overall system state, so it
> > could prevent user from doing compaction falsely. In other words,
> > even if system has enough range of memory to compact, compaction would be
> > skipped due to compaction deferring logic. This patch add new tracepoint
> > to understand work of deferring logic. This will also help to check
> > compaction success and fail.
> > 
> > Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> 
> You only call the tracepoints from try_to_compact_pages(), but the corresponding
> functions are also called from elsewhere, e.g. kswapd. Shouldn't all be
> included? Otherwise one might consider the trace as showing a bug, where the
> defer state suddenly changed without being captured in the trace.

Yes, I should include all the others. I also have experience of this
confusion.

Thanks.
