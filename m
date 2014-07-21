Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932961AbaGUPzn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 11:55:43 -0400
Received: from 8bytes.org ([81.169.241.247]:51566 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932420AbaGUPzm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 11:55:42 -0400
Date: Mon, 21 Jul 2014 17:55:40 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] PM / Hibernate: Memory bitmap scalability
 improvements
Message-ID: <20140721155540.GO30979@8bytes.org>
References: <1405684643-30234-1-git-send-email-joro@8bytes.org>
 <20140719134904.GA2852@amd.pavel.ucw.cz>
 <20140721083211.GK30979@8bytes.org>
 <20140721114507.GA13921@amd.pavel.ucw.cz>
 <20140721142951.GN30979@8bytes.org>
 <20140721143905.GA16454@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140721143905.GA16454@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Jul 21, 2014 at 04:39:05PM +0200, Pavel Machek wrote:
> So you reduced O(n) to O(n/2 log(n)) ... that's still O(n log(n)), right?

Radix trees have a memory complexity of ~O(n + log(n)). We have an
additional log(n) space requirement for the tree itself, but we linearly
safe memory for each node compared to the old implementation. Since n
beats log(n) at some point there is a point where we need less pages
with the new code than with the old. That break-even point is somewhere
around 32GB of RAM, for smaller sizes we need 2 additional pages at
most.

> 
> > You can also modify the above tool to give you some data to plot, then
> > you will also SEE that there is still a linear relationship between RAM
> > size and memory required by the old and new memory bitmap
> > implementation.
> 
> I believe radix tree is O(log(N)) per operation, but its memory is
> certainly not linear.

Numbers beat believes.


	Joerg

