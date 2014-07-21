Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932565AbaGUO34 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 10:29:56 -0400
Received: from 8bytes.org ([81.169.241.247]:51406 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754125AbaGUO3z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 10:29:55 -0400
Date: Mon, 21 Jul 2014 16:29:51 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] PM / Hibernate: Memory bitmap scalability
 improvements
Message-ID: <20140721142951.GN30979@8bytes.org>
References: <1405684643-30234-1-git-send-email-joro@8bytes.org>
 <20140719134904.GA2852@amd.pavel.ucw.cz>
 <20140721083211.GK30979@8bytes.org>
 <20140721114507.GA13921@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140721114507.GA13921@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Jul 21, 2014 at 01:45:07PM +0200, Pavel Machek wrote:
> Ok, so you have sped it up from O(n) to O(log(n)) speed, and increased
> memory requirements from O(n) to O(n * log(n)), right?

No, new memory requirements are still ~O(n), because the additional pages
needed for the index in the radix tree are outweighted by the memory
saved by the smaller size of struct rtree_node compared to struct
bm_block.

If you want to see real numbers, here is a small tool which tells you
exactly when you need more memory and how much you save with the new
memory bitmap implementation:

	http://www.zlug.org/~joro/data/mem_req.c

It will tell you that the new implementation uses at most 2 more pages
for smaller RAM sizes (2 pages because 2 memory bitmaps are allocated)
and will actually save pages for bigger RAM sizes (already 30 pages on a
1TB machine, 384 pages on a 12TB machine)

You can also modify the above tool to give you some data to plot, then
you will also SEE that there is still a linear relationship between RAM
size and memory required by the old and new memory bitmap
implementation.


	Joerg

