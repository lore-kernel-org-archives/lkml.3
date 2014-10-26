Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751795AbaJZBpA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2014 21:45:00 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:40861 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483AbaJZBo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2014 21:44:58 -0400
Date: Sun, 26 Oct 2014 10:44:50 +0900
From: Minchan Kim <minchan@kernel.org>
To: Weijie Yang <weijie.yang@samsung.com>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Dan Streetman'" <ddstreet@ieee.org>,
        "'Sergey Senozhatsky'" <sergey.senozhatsky@gmail.com>,
        "'Nitin Gupta'" <ngupta@vflare.org>, "'Linux-MM'" <linux-mm@kvack.org>,
        "'linux-kernel'" <linux-kernel@vger.kernel.org>,
        "'Weijie Yang'" <weijie.yang.kh@gmail.com>
Subject: Re: [PATCH 2/2] zram: avoid NULL pointer access when reading
 mem_used_total
Message-ID: <20141026014450.GB3328@gmail.com>
References: <000101cff035$d9f50480$8ddf0d80$%yang@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000101cff035$d9f50480$8ddf0d80$%yang@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 25, 2014 at 05:26:31PM +0800, Weijie Yang wrote:
> There is a rare NULL pointer bug in mem_used_total_show() in concurrent
> situation, like this:
> zram is not initialized, process A is a mem_used_total reader which runs
> periodicity, while process B try to init zram.
> 
> 	process A 				process B
> access meta, get a NULL value
> 						init zram, done
> init_done() is true
> access meta->mem_pool, get a NULL pointer BUG
> 
> This patch fixes this issue.
> 	
> Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
Acked-by: Minchan Kim <minchan@kernel.org>

Thanks!

-- 
Kind regards,
Minchan Kim
