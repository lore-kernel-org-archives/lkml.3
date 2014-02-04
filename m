Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753796AbaBDCBD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 21:01:03 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:43096 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350AbaBDCBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 21:01:00 -0500
Date: Mon, 3 Feb 2014 18:00:56 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
cc: Mel Gorman <mgorman@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [patch] mm, compaction: avoid isolating pinned pages fix
In-Reply-To: <20140204015332.GA14779@lge.com>
Message-ID: <alpine.DEB.2.02.1402031755440.26347@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1402012145510.2593@chino.kir.corp.google.com> <20140203095329.GH6732@suse.de> <alpine.DEB.2.02.1402030231590.31061@chino.kir.corp.google.com> <20140204000237.GA17331@lge.com> <alpine.DEB.2.02.1402031610090.10778@chino.kir.corp.google.com>
 <20140204015332.GA14779@lge.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Feb 2014, Joonsoo Kim wrote:

> Okay. It can't fix your situation. Anyway, *normal* anon pages may be mapped
> and have positive page_count(), so your code such as
> '!page_mapping(page) && page_count(page)' makes compaction skip these *normal*
> anon pages and this is incorrect behaviour.
> 

So how does that work with migrate_page_move_mapping() which demands 
page_count(page) == 1 and the get_page_unless_zero() in 
__isolate_lru_page()?
