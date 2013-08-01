Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751296Ab3HAGgl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 02:36:41 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:49976 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742Ab3HAGgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 02:36:40 -0400
X-AuditID: 9c930179-b7c49ae000000e68-b9-51fa01f64c2e
Date: Thu, 1 Aug 2013 15:37:06 +0900
From: Minchan Kim <minchan@kernel.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, luto@amacapital.net,
        xemul@parallels.com, akpm@linux-foundation.org, mpm@selenic.com,
        xiaoguangrong@linux.vnet.ibm.com, mtosatti@redhat.com,
        kosaki.motohiro@gmail.com, sfr@canb.auug.org.au, peterz@infradead.org,
        aneesh.kumar@linux.vnet.ibm.com
Subject: Re: [patch 1/2] [PATCH] mm: Save soft-dirty bits on swapped pages
Message-ID: <20130801063706.GF19540@bbox>
References: <20130730204154.407090410@gmail.com>
 <20130730204654.844299768@gmail.com>
 <20130801005132.GB19540@bbox>
 <20130801055303.GA1764@moon>
 <20130801061632.GE19540@bbox>
 <20130801062814.GB1764@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130801062814.GB1764@moon>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 01, 2013 at 10:28:14AM +0400, Cyrill Gorcunov wrote:
> On Thu, Aug 01, 2013 at 03:16:32PM +0900, Minchan Kim wrote:
> > 
> > I don't get it. Could you correct me with below example?
> > 
> > Process A context
> >         try_to_unmap
> >                 swp_pte = swp_entry_to_pte /* change generic swp into arch swap */
> >                 swp_pte = pte_swp_mksoft_dirty(swp_pte);
> >                 set_pte_at(, swp_pte);
> > 
> > Process A context
> >         ..
> >         mincore_pte_range
> 		pte_t pte = *ptep;	<-- local copy of the pte value, in memory it remains the same
> 						with swap softdirty bit set

Argh, I missed that. Thank you!

Reviewed-by: Minchan Kim <minchan@kernel.org>
-- 
Kind regards,
Minchan Kim
