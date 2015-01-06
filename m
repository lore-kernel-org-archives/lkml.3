Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755247AbbAFL1r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 06:27:47 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38197 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753292AbbAFL1q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 06:27:46 -0500
Message-ID: <54ABC6AF.1020108@suse.cz>
Date: Tue, 06 Jan 2015 12:27:43 +0100
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Mel Gorman <mgorman@suse.de>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] mm/compaction: add tracepoint to observe behaviour
 of compaction defer
References: <1417593127-6819-1-git-send-email-iamjoonsoo.kim@lge.com> <1417593127-6819-3-git-send-email-iamjoonsoo.kim@lge.com>
In-Reply-To: <1417593127-6819-3-git-send-email-iamjoonsoo.kim@lge.com>
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2014 08:52 AM, Joonsoo Kim wrote:
> compaction deferring logic is heavy hammer that block the way to
> the compaction. It doesn't consider overall system state, so it
> could prevent user from doing compaction falsely. In other words,
> even if system has enough range of memory to compact, compaction would be
> skipped due to compaction deferring logic. This patch add new tracepoint
> to understand work of deferring logic. This will also help to check
> compaction success and fail.
> 
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

You only call the tracepoints from try_to_compact_pages(), but the corresponding
functions are also called from elsewhere, e.g. kswapd. Shouldn't all be
included? Otherwise one might consider the trace as showing a bug, where the
defer state suddenly changed without being captured in the trace.

