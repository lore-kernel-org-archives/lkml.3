Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757904Ab3CUITH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 04:19:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45709 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753011Ab3CUITF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 04:19:05 -0400
Date: Thu, 21 Mar 2013 09:19:02 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Simon Jeons <simon.jeons@gmail.com>
Cc: Mel Gorman <mgorman@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
        Hedi Berriche <hedi@sgi.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: page_alloc: Avoid marking zones full prematurely
 after zone_reclaim()
Message-ID: <20130321081902.GD6094@dhcp22.suse.cz>
References: <20130320181957.GA1878@suse.de>
 <514A7163.5070700@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <514A7163.5070700@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 21-03-13 10:33:07, Simon Jeons wrote:
> Hi Mel,
> On 03/21/2013 02:19 AM, Mel Gorman wrote:
> >The following problem was reported against a distribution kernel when
> >zone_reclaim was enabled but the same problem applies to the mainline
> >kernel. The reproduction case was as follows
> >
> >1. Run numactl -m +0 dd if=largefile of=/dev/null
> >    This allocates a large number of clean pages in node 0
> 
> I confuse why this need allocate a large number of clean pages?

It reads from file and puts pages into the page cache. The pages are not
modified so they are clean. Output file is /dev/null so no pages are
written. dd doesn't call fadvise(POSIX_FADV_DONTNEED) on the input file
by default so pages from the file stay in the page cache
-- 
Michal Hocko
SUSE Labs
