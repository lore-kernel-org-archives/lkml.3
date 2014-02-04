Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754071AbaBDCP5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 21:15:57 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:45200 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753987AbaBDCPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 21:15:33 -0500
X-Original-SENDERIP: 10.177.222.146
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Tue, 4 Feb 2014 11:15:33 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mgorman@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [patch] mm, compaction: avoid isolating pinned pages fix
Message-ID: <20140204021533.GA14924@lge.com>
References: <alpine.DEB.2.02.1402012145510.2593@chino.kir.corp.google.com>
 <20140203095329.GH6732@suse.de>
 <alpine.DEB.2.02.1402030231590.31061@chino.kir.corp.google.com>
 <20140204000237.GA17331@lge.com>
 <alpine.DEB.2.02.1402031610090.10778@chino.kir.corp.google.com>
 <20140204015332.GA14779@lge.com>
 <alpine.DEB.2.02.1402031755440.26347@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1402031755440.26347@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 03, 2014 at 06:00:56PM -0800, David Rientjes wrote:
> On Tue, 4 Feb 2014, Joonsoo Kim wrote:
> 
> > Okay. It can't fix your situation. Anyway, *normal* anon pages may be mapped
> > and have positive page_count(), so your code such as
> > '!page_mapping(page) && page_count(page)' makes compaction skip these *normal*
> > anon pages and this is incorrect behaviour.
> > 
> 
> So how does that work with migrate_page_move_mapping() which demands 
> page_count(page) == 1 and the get_page_unless_zero() in 
> __isolate_lru_page()?

Before doing migrate_page_move_mapping(), try_to_unmap() is called so that all
mapping is unmapped. Then, remained page_count() is 1 which is grabbed by
__isolate_lru_page(). Am I missing something?

Thanks.
