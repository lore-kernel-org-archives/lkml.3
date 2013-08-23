Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932123Ab3HWR4H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 13:56:07 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:53289 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932109Ab3HWR4F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 13:56:05 -0400
Date: Fri, 23 Aug 2013 10:22:29 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
To: Weijie Yang <weijie.yang.kh@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>, Bob Liu <bob.liu@oracle.com>,
        weijie.yang@samsung.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] zswap bugfix: memory leaks and other problem
Message-ID: <20130823152229.GA5439@variantweb.net>
References: <CAL1ERfON5p1t_KskkQc_7u78Qk=kmy6nNyqsnDwriesTi2ubLA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL1ERfON5p1t_KskkQc_7u78Qk=kmy6nNyqsnDwriesTi2ubLA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082317-7182-0000-0000-00000831CB00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 23, 2013 at 07:26:01PM +0800, Weijie Yang wrote:
> This patch series fix a few bugs in zswap based on Linux-3.11-rc6.
> 
> Corresponding mail thread see: lkml.org/lkml/2013/8/18/59 .
> 
> These issues fixed are:
>  1. memory leaks when re-swapon
>  2. potential problem which store and reclaim functions is called recursively
>  3. memory leaks when invalidate and reclaim occur simultaneously
>  4. unnecessary page scanning

Thanks for the patches!

Patches 2-4 have whitespace corruption (line wrapping) probably caused
by your mail agent.  You might check Documentation/email-clients.txt on
how to prevent this.

Seth

> 
> Issues discussed in that mail thread NOT fixed as it happens rarely or
> not a big problem:
>  1. a "theoretical race condition" when reclaim page
>  when a handle alloced from zbud, zbud considers this handle is used
> validly by upper(zswap) and can be a candidate for reclaim.
>  But zswap has to initialize it such as setting swapentry and adding
> it to rbtree. so there is a race condition, such as:
>  thread 0: obtain handle x from zbud_alloc
>  thread 1: zbud_reclaim_page is called
>  thread 1: callback zswap_writeback_entry to reclaim handle x
>  thread 1: get swpentry from handle x (it is random value now)
>  thread 1: bad thing may happen
>  thread 0: initialize handle x with swapentry
> 
> 2. frontswap_map bitmap not cleared after zswap reclaim
>  Frontswap uses frontswap_map bitmap to track page in "backend" implementation,
>  when zswap reclaim a page, the corresponding bitmap record is not cleared.
> 
> mm/zswap.c |   35 ++++++++++++++++++++++++-----------
>   1 files changed, 24 insertions(+), 11 deletions(-)
> 

