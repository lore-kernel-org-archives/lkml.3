Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752020AbaANAS5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 19:18:57 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:57642 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414AbaANASy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 19:18:54 -0500
X-AuditID: 9c930197-b7c20ae000001031-67-52d4826bbae9
Date: Tue, 14 Jan 2014 09:19:35 +0900
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Nitin Gupta <ngupta@vflare.org>,
        Jerome Marchand <jmarchan@redhat.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: Re: [PATCH 4/7] zram: use atomic operation for stat
Message-ID: <20140114001935.GW1992@bbox>
References: <1389611942-15544-1-git-send-email-minchan@kernel.org>
 <1389611942-15544-5-git-send-email-minchan@kernel.org>
 <20140113155814.07ab74c8f77179fc770a8e5f@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140113155814.07ab74c8f77179fc770a8e5f@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 13, 2014 at 03:58:14PM -0800, Andrew Morton wrote:
> On Mon, 13 Jan 2014 20:18:59 +0900 Minchan Kim <minchan@kernel.org> wrote:
> 
> > Some of fields in zram->stats are protected by zram->lock which
> > is rather coarse-grained so let's use atomic operation without
> > explict locking.
> 
> Confused.  The patch didn't remove any locking, so it made the code
> slower.

True but it could make remove dependency of zram->lock for 32bit stat
so further patches can remove messy code and enhance write performance.
So, it's preparing patch for further step.
Should I rewrite the description to explain this?

> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Kind regards,
Minchan Kim
