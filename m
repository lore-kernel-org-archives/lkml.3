Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040AbaIISg7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 14:36:59 -0400
Received: from mga02.intel.com ([134.134.136.20]:45435 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751285AbaIISg5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 14:36:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,492,1406617200"; 
   d="scan'208";a="570723162"
Message-ID: <540F48BA.2090304@intel.com>
Date: Tue, 09 Sep 2014 11:36:42 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Boaz Harrosh <boaz@plexistor.com>,
        Ross Zwisler <ross.zwisler@linux.intel.com>, Jens Axboe <axboe@fb.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-nvdimm@ml01.01.org, Toshi Kani <toshi.kani@hp.com>,
        linux-mm@kvack.org
CC: Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/9] mm: Let sparse_{add,remove}_one_section receive a
 node_id
References: <1409173922-7484-1-git-send-email-ross.zwisler@linux.intel.com> <540F1EC6.4000504@plexistor.com> <540F20AB.4000404@plexistor.com>
In-Reply-To: <540F20AB.4000404@plexistor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2014 08:45 AM, Boaz Harrosh wrote:
> This is for add_persistent_memory that will want a section of pages
> allocated but without any zone associated. This is because belonging
> to a zone will give the memory to the page allocators, but
> persistent_memory belongs to a block device, and is not available for
> regular volatile usage.

I don't think we should be taking patches like this in to the kernel
until we've seen the other side of it.  Where is the page allocator code
which will see a page belonging to no zone?  Am I missing it in this set?

I see about 80 or so calls to page_zone() in the kernel.  How will a
zone-less page look to all of these sites?
