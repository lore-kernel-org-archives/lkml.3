Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068AbaFKBuS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 21:50:18 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:60534 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718AbaFKBuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 21:50:16 -0400
X-Original-SENDERIP: 10.177.220.169
X-Original-MAILFROM: minchan@kernel.org
Date: Wed, 11 Jun 2014 10:50:20 +0900
From: Minchan Kim <minchan@kernel.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Thelen <gthelen@google.com>, Mel Gorman <mgorman@suse.de>,
        Michal Nazarewicz <mina86@mina86.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 04/10] mm, compaction: skip rechecks when lock was
 already held
Message-ID: <20140611015020.GE15630@bbox>
References: <1402305982-6928-1-git-send-email-vbabka@suse.cz>
 <1402305982-6928-4-git-send-email-vbabka@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402305982-6928-4-git-send-email-vbabka@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 09, 2014 at 11:26:16AM +0200, Vlastimil Babka wrote:
> Compaction scanners try to lock zone locks as late as possible by checking
> many page or pageblock properties opportunistically without lock and skipping
> them if not unsuitable. For pages that pass the initial checks, some properties
> have to be checked again safely under lock. However, if the lock was already
> held from a previous iteration in the initial checks, the rechecks are
> unnecessary.
> 
> This patch therefore skips the rechecks when the lock was already held. This is
> now possible to do, since we don't (potentially) drop and reacquire the lock
> between the initial checks and the safe rechecks anymore.
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Minchan Kim <minchan@kernel.org>

-- 
Kind regards,
Minchan Kim
