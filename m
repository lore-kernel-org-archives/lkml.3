Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756938AbaGNT4k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 15:56:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34776 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756492AbaGNT4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 15:56:38 -0400
Date: Mon, 14 Jul 2014 12:56:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.cz>,
        Minchan Kim <minchan.kim@gmail.com>, Rik van Riel <riel@redhat.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 3/3] mm: vmscan: clean up struct scan_control
Message-Id: <20140714125636.45e6a186a428499b5bd00726@linux-foundation.org>
In-Reply-To: <1405344049-19868-4-git-send-email-hannes@cmpxchg.org>
References: <1405344049-19868-1-git-send-email-hannes@cmpxchg.org>
	<1405344049-19868-4-git-send-email-hannes@cmpxchg.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jul 2014 09:20:49 -0400 Johannes Weiner <hannes@cmpxchg.org> wrote:

> Reorder the members by input and output, then turn the individual
> integers for may_writepage, may_unmap, may_swap, compaction_ready,
> hibernation_mode into flags that fit into a single integer.

bitfields would be a pretty good fit here.  I usually don't like them
because of locking concerns with the RMWs, but scan_control is never
accessed from another thread.

> -		if (!sc->may_unmap && page_mapped(page))
> +		if (!(sc->flags & MAY_UNMAP) && page_mapped(page))

Then edits such as this are unneeded.

