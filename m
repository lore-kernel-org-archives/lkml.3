Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932208Ab3I3WCZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 18:02:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43172 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756230Ab3I3WCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 18:02:09 -0400
Date: Mon, 30 Sep 2013 15:02:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Bob Liu <lliubbo@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
        mgorman@suse.de, hannes@cmpxchg.org, riel@redhat.com,
        minchan@kernel.org, Bob Liu <bob.liu@oracle.com>
Subject: Re: [PATCH] mm: pagevec: cleanup: drop pvec->cold argument in all
 places
Message-Id: <20130930150207.3661b5c146b6ecea84194547@linux-foundation.org>
In-Reply-To: <1380357239-30102-1-git-send-email-bob.liu@oracle.com>
References: <1380357239-30102-1-git-send-email-bob.liu@oracle.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Sep 2013 16:33:58 +0800 Bob Liu <lliubbo@gmail.com> wrote:

> Nobody uses the pvec->cold argument of pagevec and it's also unreasonable for
> pages in pagevec released as cold page, so drop the cold argument from pagevec.

Is it unreasonable?  I'd say it's unreasonable to assume that all pages
in all cases are likely to be cache-hot.  Example: what if the pages
are being truncated and were found to be on the inactive LRU,
unreferenced?

A useful exercise would be to go through all those pagevec_init() sites
and convince ourselves that the decision at each place was the correct
one.
