Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213Ab3EAIU0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 04:20:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47541 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755196Ab3EAIUW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 04:20:22 -0400
Date: Wed, 1 May 2013 09:20:18 +0100
From: Mel Gorman <mgorman@suse.de>
To: Ric Mason <ric.masonn@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Jerome Marchand <jmarchan@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH] mm: swap: Mark swap pages writeback before queueing for
 direct IO
Message-ID: <20130501082018.GG11497@suse.de>
References: <516E918B.3050309@redhat.com>
 <20130422133746.ffbbb70c0394fdbf1096c7ee@linux-foundation.org>
 <20130424185744.GB2144@suse.de>
 <5180BCFB.6090707@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <5180BCFB.6090707@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 01, 2013 at 02:58:03PM +0800, Ric Mason wrote:
> Hi Mel,
> On 04/25/2013 02:57 AM, Mel Gorman wrote:
> >As pointed out by Andrew Morton, the swap-over-NFS writeback is not setting
> >PageWriteback before it is queued for direct IO. While swap pages do not
> 
> Before commit commit 62c230bc1 (mm: add support for a filesystem to
> activate swap files and use direct_IO for writing swap pages), swap
> pages will write to page cache firstly and then writeback?
> 

That commit added an *optional* address_space operations method that
allowed a filesystem to use their aops->direct_IO method to write to a
swapfile. The existing methods for writing swap files are still there so
before and after commit 62c230bc1, swap partitions and most swapfiles
(backed by filesystems that support bmap) are still the same. Look at
swapfile.c, swap_state.c and page_io.c for the details on how swap gets
activated, pages are added to swap cache and the writepage method used
when aops->writepage is called to write the page to disk respectively.

-- 
Mel Gorman
SUSE Labs
