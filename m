Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754366Ab3HOKrd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 06:47:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50076 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752579Ab3HOKrc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 06:47:32 -0400
Date: Thu, 15 Aug 2013 11:47:27 +0100
From: Mel Gorman <mgorman@suse.de>
To: Hillf Danton <dhillf@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>
Subject: Re: kswapd skips compaction if reclaim order drops to zero?
Message-ID: <20130815104727.GT2296@suse.de>
References: <CAJd=RBBF2h_tRpbTV6OkxQOfkvKt=ebn_PbE8+r7JxAuaFZxFQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <CAJd=RBBF2h_tRpbTV6OkxQOfkvKt=ebn_PbE8+r7JxAuaFZxFQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 15, 2013 at 06:02:53PM +0800, Hillf Danton wrote:
> If the allocation order is not high, direct compaction does nothing.
> Can we skip compaction here if order drops to zero?
> 

If the allocation order is not high then

pgdat_needs_compaction == (order > 0) == false == no calling compact_pdatt

In the case where order is reset to 0 due to fragmentation then it does
call compact_pgdat but it does no work due to the cc->order check in
__compact_pgdat.

-- 
Mel Gorman
SUSE Labs
