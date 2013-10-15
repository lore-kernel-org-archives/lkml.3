Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933257Ab3JOPQj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 11:16:39 -0400
Received: from merlin.infradead.org ([205.233.59.134]:59188 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932203Ab3JOPQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 11:16:36 -0400
Date: Tue, 15 Oct 2013 09:16:31 -0600
From: Jens Axboe <axboe@kernel.dk>
To: Shaohua Li <shli@kernel.org>
Cc: linux-kernel@vger.kernel.org, kmo@daterainc.com
Subject: Re: [patch 0/4 v2] blk-mq: use percpu_ida to manage tags
Message-ID: <20131015151631.GK541@kernel.dk>
References: <20131015010500.435964635@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131015010500.435964635@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 15 2013, Shaohua Li wrote:
> Hi,
> blk-mq and percpu_ida use similar algorithm to manage tags. The difference
> is when a cpu can't allocate tags, blk-mq will use ipi to purge remote cpu
> cache, while percpu-ida directly purges remote cpu cache. In practice, the
> percpu-ida approach is much faster when we can't allocate enough for percpu
> cache.
> 
> This patch makes blk-mq use percpu_ida to manage tags, this avoids some
> duplicate code and has better performance as I mentioned. To test the patches,
> rebase blk-mq tree to latest kernel first.
> 
> The v2 patch updated some log descriptions, fixed one issue Kent pointed out
> and added performance data.

Thanks, I've rebased it to 3.12-rc5 and applied the series.

-- 
Jens Axboe

