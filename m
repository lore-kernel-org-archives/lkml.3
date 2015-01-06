Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948AbbAFJFq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 04:05:46 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34418 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750844AbbAFJFm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 04:05:42 -0500
Message-ID: <54ABA563.1040103@suse.cz>
Date: Tue, 06 Jan 2015 10:05:39 +0100
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Mel Gorman <mgorman@suse.de>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] mm/compaction: enhance trace output to know more
 about compaction internals
References: <1417593127-6819-1-git-send-email-iamjoonsoo.kim@lge.com>
In-Reply-To: <1417593127-6819-1-git-send-email-iamjoonsoo.kim@lge.com>
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2014 08:52 AM, Joonsoo Kim wrote:
> It'd be useful to know where the both scanner is start. And, it also be
> useful to know current range where compaction work. It will help to find
> odd behaviour or problem on compaction.

Overall it looks good, just two questions:
1) Why change the pfn output to hexadecimal with different printf layout and
change the variable names and? Is it that better to warrant people having to
potentially modify their scripts parsing the old output?
2) Would it be useful to also print in the mm_compaction_isolate_template based
tracepoints, pfn of where the particular scanner left off a block prematurely?
It doesn't always match start_pfn + nr_scanned.

Thanks,
Vlastimil

