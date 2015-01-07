Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902AbbAGExW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 23:53:22 -0500
Received: from mail-qc0-f180.google.com ([209.85.216.180]:33854 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754854AbbAGExU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 23:53:20 -0500
MIME-Version: 1.0
In-Reply-To: <54AAB548.3050807@suse.cz>
References: <1418400805-4661-1-git-send-email-vbabka@suse.cz>
	<20141218132619.4e6b349d0aa1744c41f985c7@linux-foundation.org>
	<54AA9E09.7040308@suse.cz>
	<54AAB548.3050807@suse.cz>
Date: Tue, 6 Jan 2015 20:53:19 -0800
X-Google-Sender-Auth: HHGg8SterEPoJq9Shh9u9_uuJ2M
Message-ID: <CA+55aFyLWFYzLkE3orkxKsGciq5eUEtcJE5L0uypNZFcW3h2HQ@mail.gmail.com>
Subject: Re: [PATCH V3 0/4] Reducing parameters of alloc_pages* family of functions
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        David Rientjes <rientjes@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.cz>,
        Minchan Kim <minchan@kernel.org>, Rik van Riel <riel@redhat.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 5, 2015 at 8:01 AM, Vlastimil Babka <vbabka@suse.cz> wrote:
>
> Hm, nope. The !CONFIG_COMPACTION variant of try_to_compact_pages() is static
> inline that returns COMPACT_CONTINUE, which is defined in compaction.h.
> Another solution is to add a "forward" declaration (not actually followed later
> by a full definition) of struct alloc_context into compaction.h. Seems to work
> here, but I'm not sure if such thing is allowed?

We do forward struct declarations quite often (well, _relatively_
often) in order to avoid nasty circular header includes, and sometimes
just to avoid unnecessarily many header includes.

See for example

    git grep '\<struct [a-zA-Z_0-9]*;'

it's not exactly rare.

So it's fine.

                        Linus
