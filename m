Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823Ab3FCIWy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 04:22:54 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51558 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179Ab3FCIWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 04:22:50 -0400
Date: Mon, 3 Jun 2013 10:22:09 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-mm@kvack.org, Andi Kleen <andi@firstfloor.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Thelen <gthelen@google.com>,
        Christoph Hellwig <hch@infradead.org>, Hugh Dickins <hughd@google.com>,
        Jan Kara <jack@suse.cz>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan.kim@gmail.com>,
        Rik van Riel <riel@redhat.com>, Michel Lespinasse <walken@google.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Roman Gushchin <klamm@yandex-team.ru>, metin d <metdos@yahoo.com>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [patch 10/10] mm: workingset: keep shadow entries in check
Message-ID: <20130603082209.GG5910@twins.programming.kicks-ass.net>
References: <1369937046-27666-1-git-send-email-hannes@cmpxchg.org>
 <1369937046-27666-11-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369937046-27666-11-git-send-email-hannes@cmpxchg.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 30, 2013 at 02:04:06PM -0400, Johannes Weiner wrote:
> 2. a list of files that contain shadow entries is maintained.  If the
>    global number of shadows exceeds a certain threshold, a shrinker is
>    activated that reclaims old entries from the mappings.  This is
>    heavy-handed but it should not be a common case and is only there
>    to protect from accidentally/maliciously induced OOM kills.

Grrr.. another global files list. We've been trying rather hard to get
rid of the first one :/

I see why you want it but ugh.

I have similar worries for your global time counter, large machines
might thrash on that one cacheline.

