Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752383AbaETHVL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 03:21:11 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:34360 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752327AbaETHVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 03:21:09 -0400
Date: Tue, 20 May 2014 00:20:57 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Chinner <david@fromorbit.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, riel@redhat.com,
        kosaki.motohiro@jp.fujitsu.com, fengguang.wu@intel.com,
        kamezawa.hiroyu@jp.fujitsu.com, linux-kernel@vger.kernel.org,
        xfs@oss.sgi.com
Subject: Re: [PATCH] mm/vmscan: Do not block forever at
 shrink_inactive_list().
Message-ID: <20140520072057.GA4952@infradead.org>
References: <201405192340.FCD48964.OFQHOOJLVSFFMt@I-love.SAKURA.ne.jp>
 <20140520004449.GE18954@dastard>
 <20140519225915.3370328d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140519225915.3370328d.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2014 at 10:59:15PM -0700, Andrew Morton wrote:
> So current_is_kswapd() returns true for a thread which is not kswapd. 
> That's a bit smelly.
> 
> Should this thread really be incrementing KSWAPD_INODESTEAL instead of
> PGINODESTEAL, for example?  current_is_kswapd() does a range of things,
> only one(?) of which you actually want.

Actually we want all of them. The allocation workqueue is a workaround
for the incredible stack usage in the Linux I/O path.  If it is called
by kswapd it should act as if it were kswapd for all purposes.

