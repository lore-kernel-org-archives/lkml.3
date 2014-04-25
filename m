Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675AbaDYOBN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 10:01:13 -0400
Received: from mga01.intel.com ([192.55.52.88]:34383 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751858AbaDYOBK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 10:01:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,927,1389772800"; 
   d="scan'208";a="527324632"
Date: Fri, 25 Apr 2014 10:01:01 -0400
From: Matthew Wilcox <willy@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH v3 5/7] swap: Use bdev_read_page() / bdev_write_page()
Message-ID: <20140425140100.GF5886@linux.intel.com>
References: <cover.1397429628.git.matthew.r.wilcox@intel.com>
 <9fb0b4031b0fba312963a7cc21bf258d944cddcf.1397429628.git.matthew.r.wilcox@intel.com>
 <20140424111817.9cc62b2ff1e368c5cf27d262@linux-foundation.org>
 <20140424185740.GE5886@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140424185740.GE5886@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2014 at 02:57:40PM -0400, Matthew Wilcox wrote:
> By calling the device driver to write the page directly, we avoid
> allocating a BIO, which allows us to free memory without allocating
> memory.

I got handed some performance numbers last night!  Next time you're updating
the patch description, please use:

By calling the device driver to write the page directly, we avoid
allocating a BIO, which allows us to free memory without allocating
memory.  When running a swap-heavy benchmark, system time is reduced by
about 20%.

Tested-by: Dheeraj Reddy <dheeraj.reddy@intel.com>
Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
