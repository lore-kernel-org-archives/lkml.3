Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756529AbaISL0P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 07:26:15 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:59141 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754988AbaISL0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 07:26:13 -0400
Date: Fri, 19 Sep 2014 04:26:12 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: Milosz Tanski <milosz@adfin.com>, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-aio@kvack.org, Mel Gorman <mgorman@suse.de>,
        Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>,
        Jeff Moyer <jmoyer@redhat.com>, Andreas Dilger <adilger@dilger.ca>
Subject: Re: [RFC 1/2] aio: async readahead
Message-ID: <20140919112612.GC4639@infradead.org>
References: <cover.1410810247.git.milosz@adfin.com>
 <20140917144925.GU24821@kvack.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140917144925.GU24821@kvack.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Requiring the block mappings to be entirely async is why we never went
for full buffered aio.  What would seem more useful is to offload all
readahead to workqueues to make sure they never block the caller for
sys_readahead or if we decide to readahead for the nonblocking read.

I tried to implement this, but I couldn't find a good place to hang
the work_struct for it off.  If we decide to dynamically allocate
the ra structure separate from struct file that might be an obvious
place.
