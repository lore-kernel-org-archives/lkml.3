Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691AbaACPMD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 10:12:03 -0500
Received: from mail-ob0-f171.google.com ([209.85.214.171]:59093 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950AbaACPMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 10:12:00 -0500
Date: Fri, 3 Jan 2014 09:11:54 -0600
From: Seth Jennings <sjennings@variantweb.net>
To: Dan Streetman <ddstreet@ieee.org>
Cc: Linux-MM <linux-mm@kvack.org>, linux-kernel <linux-kernel@vger.kernel.org>,
        Bob Liu <bob.liu@oracle.com>, Minchan Kim <minchan@kernel.org>,
        Weijie Yang <weijie.yang@samsung.com>,
        Shirish Pargaonkar <spargaonkar@suse.com>,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mm/zswap: add writethrough option
Message-ID: <20140103151154.GA2940@cerebellum.variantweb.net>
References: <1387459407-29342-1-git-send-email-ddstreet@ieee.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387459407-29342-1-git-send-email-ddstreet@ieee.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19, 2013 at 08:23:27AM -0500, Dan Streetman wrote:
> Currently, zswap is writeback cache; stored pages are not sent
> to swap disk, and when zswap wants to evict old pages it must
> first write them back to swap cache/disk manually.  This avoids
> swap out disk I/O up front, but only moves that disk I/O to
> the writeback case (for pages that are evicted), and adds the
> overhead of having to uncompress the evicted pages and the
> need for an additional free page (to store the uncompressed page).
> 
> This optionally changes zswap to writethrough cache by enabling
> frontswap_writethrough() before registering, so that any
> successful page store will also be written to swap disk.  The
> default remains writeback.  To enable writethrough, the param
> zswap.writethrough=1 must be used at boot.
> 
> Whether writeback or writethrough will provide better performance
> depends on many factors including disk I/O speed/throughput,
> CPU speed(s), system load, etc.  In most cases it is likely
> that writeback has better performance than writethrough before
> zswap is full, but after zswap fills up writethrough has
> better performance than writeback.
> 
> Signed-off-by: Dan Streetman <ddstreet@ieee.org>

Hey Dan, sorry for the delay on this.  Vacation and busyness.

This looks like a good option for those that don't mind having
the write overhead to ensure that things don't really bog down
if the compress pool overflows, while maintaining the read fault
speedup by decompressing from the pool.

Acked-by: Seth Jennings <sjennings@variantweb.net>
