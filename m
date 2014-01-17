Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752074AbaAQGxU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 01:53:20 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:61466 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbaAQGxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 01:53:17 -0500
X-AuditID: 9c93017d-b7b51ae000000e33-2a-52d8d35c8427
Date: Fri, 17 Jan 2014 15:54:11 +0900
From: Minchan Kim <minchan@kernel.org>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Jerome Marchand <jmarchan@redhat.com>, Nitin Gupta <ngupta@vflare.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 4/8] zram: use atomic64_t for all zram stats
Message-ID: <20140117065411.GH26602@bbox>
References: <1389877936-15543-1-git-send-email-sergey.senozhatsky@gmail.com>
 <1389877936-15543-5-git-send-email-sergey.senozhatsky@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389877936-15543-5-git-send-email-sergey.senozhatsky@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 16, 2014 at 04:12:12PM +0300, Sergey Senozhatsky wrote:
> This is a preparation patch for stats code duplication removal.
> 
> 1) use atomic64_t for `pages_zero' and `pages_stored' zram stats.
> 2) `compr_size' and `pages_zero' struct zram_stats members did not
> follow the existing device attr naming scheme: zram_stats.ATTR has
> ATTR_show() function. rename them:
> -- compr_size -> compr_data_size
> -- pages_zero -> zero_pages
> 
> Minchan Kim's note:
>  If we really have trouble with atomic stat operation, we could
>  change it with percpu_counter so that it could solve atomic overhead and
>  unnecessary memory space by introducing unsigned long instead of 64bit
>  atomic_t.
> 
> Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>

-- 
Kind regards,
Minchan Kim
