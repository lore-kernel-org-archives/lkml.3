Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932416AbaDXS5q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 14:57:46 -0400
Received: from mga09.intel.com ([134.134.136.24]:23172 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753229AbaDXS5n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 14:57:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,920,1389772800"; 
   d="scan'208";a="527680822"
Date: Thu, 24 Apr 2014 14:57:40 -0400
From: Matthew Wilcox <willy@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH v3 5/7] swap: Use bdev_read_page() / bdev_write_page()
Message-ID: <20140424185740.GE5886@linux.intel.com>
References: <cover.1397429628.git.matthew.r.wilcox@intel.com>
 <9fb0b4031b0fba312963a7cc21bf258d944cddcf.1397429628.git.matthew.r.wilcox@intel.com>
 <20140424111817.9cc62b2ff1e368c5cf27d262@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140424111817.9cc62b2ff1e368c5cf27d262@linux-foundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2014 at 11:18:17AM -0700, Andrew Morton wrote:
> On Sun, 13 Apr 2014 18:59:54 -0400 Matthew Wilcox <matthew.r.wilcox@intel.com> wrote:
> 
> >  mm/page_io.c | 23 +++++++++++++++++++++--
> >  1 file changed, 21 insertions(+), 2 deletions(-)
> 
> Some changelog here would be nice.  What were the reasons for the
> change?  Any observable performance changes?

Whoops ... I could swear I wrote one.  Wonder what happened to it.  Here
was all I had:

We can avoid allocating a BIO if we use the writepage path instead of
the Direct I/O path.

But that's kind of lame.  I don't have any performance numbers right now,
so how about we go with:

By calling the device driver to write the page directly, we avoid
allocating a BIO, which allows us to free memory without allocating
memory.
