Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253Ab3AJX1e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 18:27:34 -0500
Received: from mail-ob0-f176.google.com ([209.85.214.176]:41233 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339Ab3AJX1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 18:27:33 -0500
MIME-Version: 1.0
In-Reply-To: <CAA25o9TjXNCpLHAyowboAxZrnQZmNmJOevDgA-zq4kA1K-PHXQ@mail.gmail.com>
References: <1357712474-27595-1-git-send-email-minchan@kernel.org>
	<1357712474-27595-2-git-send-email-minchan@kernel.org>
	<20130109161854.67412dcc.akpm@linux-foundation.org>
	<20130110020347.GA14685@blaptop>
	<CAA25o9TjXNCpLHAyowboAxZrnQZmNmJOevDgA-zq4kA1K-PHXQ@mail.gmail.com>
Date: Thu, 10 Jan 2013 15:27:32 -0800
Message-ID: <CAA25o9RzsU_pGRK6eYUs7WgEiuW_FHnimO_MXPgRH3L51sFB2w@mail.gmail.com>
Subject: Re: [PATCH 1/2] mm: prevent to add a page to swap if may_writepage is unset
From: Luigi Semenzato <semenzato@google.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Sonny Rao <sonnyrao@google.com>, Bryan Freed <bfreed@google.com>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[I may have screwed up my previous message, sorry if this is a
duplicate.  (Content-Policy reject msg: The message contains HTML
subpart, therefore we consider it SPAM or Outlook Virus.)]

------------------------------------------

For what it's worth, I tested this patch on my 3.4 kernel, and it
works as advertised.  Here's my setup.

- 2 GB RAM
- a 3 GB zram disk for swapping
- start one "hog" process per second (each hog process mallocs and
touches 200 MB of memory).
- watch /proc/meminfo

1. I verified that the problem still exists on my current 3.4 kernel.
With laptop_mode = 2, hog processes are oom-killed when about 1.8-1.9
(out of 3) GB of swap space are still left

2. I double-checked that the problem does not exist with laptop_mode =
0: hog processes are oom-killed when swap space is exhausted (with
good approximation).

3. I added the two-line patch, put back laptop_mode = 2, and verified
that hog processes are oom-killed when swap space is exhausted, same
as case 2.

Let me know if I can run any more tests for you, and thanks for all
the support so far!
