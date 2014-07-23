Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757550AbaGWN7v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 09:59:51 -0400
Received: from mga09.intel.com ([134.134.136.24]:61766 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757248AbaGWN7t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 09:59:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,717,1400050800"; 
   d="scan'208";a="547769364"
Date: Wed, 23 Jul 2014 09:59:46 -0400
From: Matthew Wilcox <willy@linux.intel.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 00/22] Support ext4 on NV-DIMMs
Message-ID: <20140723135946.GC6754@linux.intel.com>
References: <cover.1406058387.git.matthew.r.wilcox@intel.com>
 <20140723123028.GA11355@node.dhcp.inet.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140723123028.GA11355@node.dhcp.inet.fi>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 03:30:28PM +0300, Kirill A. Shutemov wrote:
> On Tue, Jul 22, 2014 at 03:47:48PM -0400, Matthew Wilcox wrote:
> > One of the primary uses for NV-DIMMs is to expose them as a block device
> > and use a filesystem to store files on the NV-DIMM.  While that works,
> > it currently wastes memory and CPU time buffering the files in the page
> > cache.  We have support in ext2 for bypassing the page cache, but it
> > has some races which are unfixable in the current design.  This series
> > of patches rewrite the underlying support, and add support for direct
> > access to ext4.
> 
> Matthew, as discussed before, your patchset make exessive use of
> i_mmap_mutex. Are you going to address this later? Or what's the plan?

Yes, it'll be addressed later.  I have some ideas, but I'd like to get
some experience with just how bad this single mutex is before trying to
split it.
