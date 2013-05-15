Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759885Ab3EORlR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 13:41:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3132 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759831Ab3EORlP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 13:41:15 -0400
Message-ID: <5193C8AA.206@redhat.com>
Date: Wed, 15 May 2013 13:40:58 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Alexey Lyahkov <alexey.lyashkov@gmail.com>,
        Andrew Perepechko <anserper@ya.ru>, Robin Dong <sanbai@taobao.com>,
        Theodore Tso <tytso@mit.edu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Bernd Schubert <bernd.schubert@fastmail.fm>,
        David Howells <dhowells@redhat.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux-ext4 <linux-ext4@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH 3/4] mm: Activate !PageLRU pages on mark_page_accessed
 if page is on local pagevec
References: <1368440482-27909-1-git-send-email-mgorman@suse.de> <1368440482-27909-4-git-send-email-mgorman@suse.de>
In-Reply-To: <1368440482-27909-4-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2013 06:21 AM, Mel Gorman wrote:

> In this case a PageActive page is added to the inactivate list and later the
> inactive/active stats will get skewed. While the PageActive checks in vmscan
> could be removed and potentially dealt with, a skew in the statistics would
> be very difficult to detect. Hence this patch deals just with the common case
> where a page being marked accessed has just been added to the local pagevec.
>
> Signed-off-by: Mel Gorman <mgorman@suse.de>

After thinking about it some more, I suspect the possible issue
I outlined before should not be an issue in practice.

Acked-by: Rik van Riel <riel@redhat.com>


-- 
All rights reversed
