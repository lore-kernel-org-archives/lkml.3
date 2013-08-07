Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933160Ab3HGU3S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 16:29:18 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:65128 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932350Ab3HGU3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 16:29:17 -0400
Date: Thu, 8 Aug 2013 00:29:14 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, luto@amacapital.net,
        xemul@parallels.com, mpm@selenic.com, xiaoguangrong@linux.vnet.ibm.com,
        mtosatti@redhat.com, kosaki.motohiro@gmail.com, sfr@canb.auug.org.au,
        peterz@infradead.org, aneesh.kumar@linux.vnet.ibm.com
Subject: Re: [patch 1/2] [PATCH] mm: Save soft-dirty bits on swapped pages
Message-ID: <20130807202914.GO7999@moon>
References: <20130730204154.407090410@gmail.com>
 <20130730204654.844299768@gmail.com>
 <20130807132156.e97bbcc3d543cf88d5a0997d@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130807132156.e97bbcc3d543cf88d5a0997d@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 07, 2013 at 01:21:56PM -0700, Andrew Morton wrote:
> > 
> > One of the problem was to find a place in pte entry where we can
> > save the _PTE_SWP_SOFT_DIRTY bit while page is in swap. The
> > _PAGE_PSE was chosen for that, it doesn't intersect with swap
> > entry format stored in pte.
> 
> So the implication is that if another architecture wants to support
> this (and, realistically, wants to support CRIU), that architecture
> must find a spare pte bit to implement _PTE_SWP_SOFT_DIRTY.  Yes?

Exactly.
