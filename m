Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301Ab3HOKCz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 06:02:55 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:64963 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752318Ab3HOKCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 06:02:53 -0400
MIME-Version: 1.0
Date: Thu, 15 Aug 2013 18:02:53 +0800
Message-ID: <CAJd=RBBF2h_tRpbTV6OkxQOfkvKt=ebn_PbE8+r7JxAuaFZxFQ@mail.gmail.com>
Subject: kswapd skips compaction if reclaim order drops to zero?
From: Hillf Danton <dhillf@gmail.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Minchan Kim <minchan@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the allocation order is not high, direct compaction does nothing.
Can we skip compaction here if order drops to zero?

--- a/mm/vmscan.c Thu Aug 15 17:47:26 2013
+++ b/mm/vmscan.c Thu Aug 15 17:48:58 2013
@@ -3034,7 +3034,7 @@ static unsigned long balance_pgdat(pg_da
  * Compact if necessary and kswapd is reclaiming at least the
  * high watermark number of pages as requsted
  */
- if (pgdat_needs_compaction && sc.nr_reclaimed > nr_attempted)
+ if (pgdat_needs_compaction && sc.nr_reclaimed > nr_attempted && order)
  compact_pgdat(pgdat, order);

  /*
--
