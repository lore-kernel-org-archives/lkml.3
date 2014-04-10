Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935625AbaDJO2G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 10:28:06 -0400
Received: from mga09.intel.com ([134.134.136.24]:56466 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934688AbaDJO2E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 10:28:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,834,1389772800"; 
   d="scan'208";a="490797977"
Date: Thu, 10 Apr 2014 10:27:29 -0400
From: Matthew Wilcox <willy@linux.intel.com>
To: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v7 18/22] xip: Add xip_zero_page_range
Message-ID: <20140410142729.GL5727@linux.intel.com>
References: <cover.1395591795.git.matthew.r.wilcox@intel.com>
 <5a87acda8c3e4d2b7ea5dd1249fcbf8be23b9645.1395591795.git.matthew.r.wilcox@intel.com>
 <20140409101512.GL32103@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140409101512.GL32103@quack.suse.cz>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 09, 2014 at 12:15:12PM +0200, Jan Kara wrote:
> > +		/*
> > +		 * ext4 sometimes asks to zero past the end of a block.  It
> > +		 * really just wants to zero to the end of the block.
> > +		 */
>   Then we should really fix ext4 I believe...

Since I didn't want to do this ...

> > +/* Can't be a function because PAGE_CACHE_SIZE is defined in pagemap.h */
> > +#define dax_truncate_page(inode, from, get_block)	\
> > +	dax_zero_page_range(inode, from, PAGE_CACHE_SIZE, get_block)
>                                          ^^^^
> This should be (PAGE_CACHE_SIZE - (from & (PAGE_CACHE_SIZE - 1))), shouldn't it?

... I could get away without doing that ;-)
