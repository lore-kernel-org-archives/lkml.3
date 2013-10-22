Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059Ab3JVMz0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 08:55:26 -0400
Received: from mga09.intel.com ([134.134.136.24]:50141 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752809Ab3JVMzV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 08:55:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,548,1378882800"; 
   d="scan'208";a="415129131"
Date: Tue, 22 Oct 2013 13:55:12 +0100
From: Fengguang Wu <fengguang.wu@intel.com>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH] mm: create a separate slab for page->ptl allocation
Message-ID: <20131022125512.GA24418@localhost>
References: <1382442839-7458-1-git-send-email-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382442839-7458-1-git-send-email-kirill.shutemov@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 22, 2013 at 02:53:59PM +0300, Kirill A. Shutemov wrote:
> If DEBUG_SPINLOCK and DEBUG_LOCK_ALLOC are enabled spinlock_t on x86_64
> is 72 bytes. For page->ptl they will be allocated from kmalloc-96 slab,
> so we loose 24 on each. An average system can easily allocate few tens
> thousands of page->ptl and overhead is significant.
> 
> Let's create a separate slab for page->ptl allocation to solve this.

Tested-by: Fengguang Wu <fengguang.wu@intel.com>

In a 4p server, we noticed up to +469.1% increase in will-it-scale page_fault3
test case and +199.8% in vm-scalability case-shm-pread-seq-mt.

    5c02216ce3110aab070d      5a58baaa0a1af0a43d7c
------------------------  ------------------------  
               300409.00      +440.2%   1622770.80  TOTAL will-it-scale.page_fault3.90.threads

    5c02216ce3110aab070d      5a58baaa0a1af0a43d7c
------------------------  ------------------------  
               291257.80      +469.1%   1657582.20  TOTAL will-it-scale.page_fault3.120.threads

...

    5c02216ce3110aab070d      5a58baaa0a1af0a43d7c
------------------------  ------------------------  
              4034831.40      +199.8%  12095649.80  TOTAL vm-scalability.throughput

Thanks,
Fengguang
