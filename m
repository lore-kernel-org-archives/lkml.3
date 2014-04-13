Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751369AbaDMWhL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 18:37:11 -0400
Received: from mga02.intel.com ([134.134.136.20]:58613 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750958AbaDMWhJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 18:37:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,853,1389772800"; 
   d="scan'208";a="492293363"
Date: Sun, 13 Apr 2014 15:07:21 -0400
From: Matthew Wilcox <willy@linux.intel.com>
To: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 08/22] Replace xip_truncate_page with dax_truncate_page
Message-ID: <20140413190721.GA21460@linux.intel.com>
References: <cover.1395591795.git.matthew.r.wilcox@intel.com>
 <fd328c564ddc79b41a3a8d754080e6e6e77bbf4f.1395591795.git.matthew.r.wilcox@intel.com>
 <20140408221759.GD26019@quack.suse.cz>
 <20140409092635.GB32103@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140409092635.GB32103@quack.suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 09, 2014 at 11:26:35AM +0200, Jan Kara wrote:
>   I thought about this for a while and classical IO, truncation etc. could
> easily work for blocksize < pagesize. And for mmap() you could just use
> pagecache. Not sure if it's worth the complications though. Anyway we
> should decide whether we don't care about blocksize < PAGE_CACHE_SIZE at
> all, or whether we try to make things which can work reasonably easily
> functional. In that case dax_truncate_page() needs some tweaking because it
> currently assumes blocksize == PAGE_CACHE_SIZE.

I think it actually assumes that blocksize <= PAGE_CACHE_SIZE in that
it doesn't contain a loop to iterate over all blocks.  It wouldn't be
hard to fix but I'll just put in a comment noting what needs to be fixed
... I don't think there's going to be a lot of enthusiasm for adding
support for blocksize != PAGE_SIZE / PAGE_CACHE_SIZE.
