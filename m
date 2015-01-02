Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750782AbbABFLX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 00:11:23 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:49236 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbbABFLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 00:11:13 -0500
Date: Fri, 2 Jan 2015 06:11:11 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Minchan Kim <minchan@kernel.org>
Cc: "Stefan I. Strogin" <s.strogin@partner.samsung.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>, aneesh.kumar@linux.vnet.ibm.com,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Dmitry Safonov <d.safonov@partner.samsung.com>,
        Pintu Kumar <pintu.k@samsung.com>,
        Weijie Yang <weijie.yang@samsung.com>,
        Laura Abbott <lauraa@codeaurora.org>,
        SeongJae Park <sj38.park@gmail.com>, Hui Zhu <zhuhui@xiaomi.com>,
        Dyasly Sergey <s.dyasly@samsung.com>,
        Vyacheslav Tyrtov <v.tyrtov@samsung.com>
Subject: Re: [PATCH 0/3] mm: cma: /proc/cmainfo
Message-ID: <20150102051111.GC4873@amd>
References: <cover.1419602920.git.s.strogin@partner.samsung.com>
 <20141229023639.GC27095@bbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141229023639.GC27095@bbox>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2014-12-29 11:36:39, Minchan Kim wrote:
> Hello,
> 
> On Fri, Dec 26, 2014 at 05:39:01PM +0300, Stefan I. Strogin wrote:
> > Hello all,
> > 
> > Here is a patch set that adds /proc/cmainfo.
> > 
> > When compiled with CONFIG_CMA_DEBUG /proc/cmainfo will contain information
> > about about total, used, maximum free contiguous chunk and all currently
> > allocated contiguous buffers in CMA regions. The information about allocated
> > CMA buffers includes pid, comm, allocation latency and stacktrace at the
> > moment of allocation.

We should not add new non-process related files in
/proc. So... NAK. Should this go to debugfs instead?

> It just says what you are doing but you didn't say why we need it.
> I can guess but clear description(ie, the problem what you want to
> solve with this patchset) would help others to review, for instance,
> why we need latency, why we need callstack, why we need new wheel
> rather than ftrace and so on.
> 
> Thanks.
> 
> > 
> > Example:
> > 
> > # cat /proc/cmainfo 
> > CMARegion stat:    65536 kB total,      248 kB used,    65216 kB max contiguous chunk


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
