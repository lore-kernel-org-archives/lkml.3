Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826AbbAMVzJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 16:55:09 -0500
Received: from mga01.intel.com ([192.55.52.88]:20184 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751385AbbAMVzH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 16:55:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,751,1413270000"; 
   d="scan'208";a="661352545"
Date: Tue, 13 Jan 2015 16:55:05 -0500
From: Matthew Wilcox <willy@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        willy@linux.intel.com
Subject: Re: [PATCH v12 09/20] dax,ext2: Replace xip_truncate_page with
 dax_truncate_page
Message-ID: <20150113215505.GL5661@wil.cx>
References: <1414185652-28663-1-git-send-email-matthew.r.wilcox@intel.com>
 <1414185652-28663-10-git-send-email-matthew.r.wilcox@intel.com>
 <20150112150958.2e6bd85dc3e25b953d28c6cb@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150112150958.2e6bd85dc3e25b953d28c6cb@linux-foundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 03:09:58PM -0800, Andrew Morton wrote:
> > + * Similar to block_truncate_page(), this function can be called by a
> > + * filesystem when it is truncating an DAX file to handle the partial page.
> > + *
> > + * We work in terms of PAGE_CACHE_SIZE here for commonality with
> > + * block_truncate_page(), but we could go down to PAGE_SIZE if the filesystem
> > + * took care of disposing of the unnecessary blocks.
> 
> But PAGE_SIZE==PAGE_CACHE_SIZE.  Unclear what you're saying here.

The last I heard, some people were trying to resurrect the PAGE_CACHE_SIZE
> PAGE_SIZE patches.  I'd be grateful if the distinction between PAGE_SIZE
and PAGE_CACHE_SIZE went away, tbh.
