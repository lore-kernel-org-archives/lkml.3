Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932434AbaEGJlM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 05:41:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56863 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932261AbaEGJlI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 05:41:08 -0400
Date: Wed, 7 May 2014 10:41:05 +0100
From: Mel Gorman <mgorman@suse.de>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Greg Thelen <gthelen@google.com>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch v3 6/6] mm, compaction: terminate async compaction when
 rescheduling
Message-ID: <20140507094105.GF23991@suse.de>
References: <alpine.DEB.2.02.1404301744110.8415@chino.kir.corp.google.com>
 <alpine.DEB.2.02.1405011434140.23898@chino.kir.corp.google.com>
 <alpine.DEB.2.02.1405061920470.18635@chino.kir.corp.google.com>
 <alpine.DEB.2.02.1405061922220.18635@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1405061922220.18635@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 06, 2014 at 07:22:52PM -0700, David Rientjes wrote:
> Async compaction terminates prematurely when need_resched(), see
> compact_checklock_irqsave().  This can never trigger, however, if the 
> cond_resched() in isolate_migratepages_range() always takes care of the 
> scheduling.
> 
> If the cond_resched() actually triggers, then terminate this pageblock scan for 
> async compaction as well.
> 
> Signed-off-by: David Rientjes <rientjes@google.com>

Acked-by: Mel Gorman <mgorman@suse.de>

-- 
Mel Gorman
SUSE Labs
