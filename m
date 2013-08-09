Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031439Ab3HIWxN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 18:53:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37774 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031386Ab3HIWxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 18:53:11 -0400
Date: Fri, 9 Aug 2013 15:53:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-mm@kvack.org, Andi Kleen <andi@firstfloor.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Greg Thelen <gthelen@google.com>,
        Christoph Hellwig <hch@infradead.org>, Hugh Dickins <hughd@google.com>,
        Jan Kara <jack@suse.cz>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan.kim@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        Michel Lespinasse <walken@google.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Roman Gushchin <klamm@yandex-team.ru>,
        Ozgun Erdogan <ozgun@citusdata.com>, Metin Doslu <metin@citusdata.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 0/9] mm: thrash detection-based file cache sizing v3
Message-Id: <20130809155309.71d93380425ef8e19c0ff44c@linux-foundation.org>
In-Reply-To: <1375829050-12654-1-git-send-email-hannes@cmpxchg.org>
References: <1375829050-12654-1-git-send-email-hannes@cmpxchg.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  6 Aug 2013 18:44:01 -0400 Johannes Weiner <hannes@cmpxchg.org> wrote:

> This series solves the problem by maintaining a history of pages
> evicted from the inactive list, enabling the VM to tell streaming IO
> from thrashing and rebalance the page cache lists when appropriate.

Looks nice. The lack of testing results is conspicuous ;)

It only really solves the problem in the case where

	size-of-inactive-list < size-of-working-set < size-of-total-memory

yes?  In fact less than that, because the active list presumably
doesn't get shrunk to zero (how far *can* it go?).  I wonder how many
workloads fit into those constraints in the real world.

