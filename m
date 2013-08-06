Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756719Ab3HFWYA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 18:24:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56610 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755714Ab3HFWX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 18:23:59 -0400
Date: Tue, 6 Aug 2013 15:23:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Joonsoo Kim <js1304@gmail.com>, Minchan Kim <minchan@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH] mm, page_alloc: optimize batch count in
 free_pcppages_bulk()
Message-Id: <20130806152357.40031f6702c92ce9f0d10fca@linux-foundation.org>
In-Reply-To: <1375778440-31503-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1375778440-31503-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  6 Aug 2013 17:40:40 +0900 Joonsoo Kim <iamjoonsoo.kim@lge.com> wrote:

> If we use a division operation, we can compute a batch count more closed
> to ideal value. With this value, we can finish our job within
> MIGRATE_PCPTYPES iteration. In addition, batching to free more pages
> may be helpful to cache usage.
> 

hm, maybe.  The .text got 120 bytes larger so the code now will
eject two of someone else's cachelines, which can't be good.  I need
more convincing, please ;)

(bss got larger too - I don't have a clue why this happens).

