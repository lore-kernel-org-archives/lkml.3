Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752488AbaDRNv2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 09:51:28 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:45764 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667AbaDRNv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 09:51:26 -0400
Date: Fri, 18 Apr 2014 06:51:14 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jianyu Zhan <nasa4836@gmail.com>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, minchan@kernel.org,
        shli@kernel.org, riel@redhat.com, sjenning@linux.vnet.ibm.com,
        iamjoonsoo.kim@lge.com, mgorman@suse.de, aquini@redhat.com,
        aarcange@redhat.com, khalid.aziz@oracle.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm/swap: cleanup *lru_cache_add* functions
Message-ID: <20140418135114.GA4911@infradead.org>
References: <1397826591-19379-1-git-send-email-nasa4836@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397826591-19379-1-git-send-email-nasa4836@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 18, 2014 at 09:09:51PM +0800, Jianyu Zhan wrote:
> In mm/swap.c, __lru_cache_add() is exported, but actually there are
> no users outside this file. However, lru_cache_add() is supposed to
> be used by vfs, or whatever others, but it is not exported.

There are no modular users of lru_cache_add, so please don't needlessly
export it.
