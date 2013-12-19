Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752345Ab3LSGHE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 01:07:04 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:64977 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210Ab3LSGHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 01:07:01 -0500
X-AuditID: 9c93017d-b7c5eae000004296-7a-52b28d048288
Date: Thu, 19 Dec 2013 15:07:03 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sasha.levin@oracle.com>, Hugh Dickins <hughd@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] mm/rmap: fix BUG at rmap_walk
Message-ID: <20131219060703.GA27787@lge.com>
References: <1387431715-6786-1-git-send-email-liwanp@linux.vnet.ibm.com>
 <20131219055510.GA27532@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131219055510.GA27532@lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19, 2013 at 02:55:10PM +0900, Joonsoo Kim wrote:
> On Thu, Dec 19, 2013 at 01:41:55PM +0800, Wanpeng Li wrote:
> > This bug is introduced by commit 37f093cdf(mm/rmap: use rmap_walk() in 
> > page_referenced()). page_get_anon_vma() called in page_referenced_anon() 
> > will lock and increase the refcount of anon_vma. PageLocked is not required 
> > by page_referenced_anon() and there is not any assertion before, commit 
> > 37f093cdf introduced this extra BUG_ON() checking for anon page by mistake.
> > This patch fix it by remove rmap_walk()'s VM_BUG_ON() and comment reason why 
> > the page must be locked for rmap_walk_ksm() and rmap_walk_file().

FYI.

See following link to get more information.

https://lkml.org/lkml/2004/7/12/241

Thanks.
