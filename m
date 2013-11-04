Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139Ab3KDKnF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 05:43:05 -0500
Received: from mga02.intel.com ([134.134.136.20]:51485 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751821Ab3KDKnD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 05:43:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="429428236"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-arch@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
In-Reply-To: <1382442839-7458-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1382442839-7458-1-git-send-email-kirill.shutemov@linux.intel.com>
Subject: RE: [PATCH] mm: create a separate slab for page->ptl allocation
Content-Transfer-Encoding: 7bit
Message-Id: <20131104104259.86AFEE0090@blue.fi.intel.com>
Date: Mon,  4 Nov 2013 12:42:59 +0200 (EET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kirill A. Shutemov wrote:
> If DEBUG_SPINLOCK and DEBUG_LOCK_ALLOC are enabled spinlock_t on x86_64
> is 72 bytes. For page->ptl they will be allocated from kmalloc-96 slab,
> so we loose 24 on each. An average system can easily allocate few tens
> thousands of page->ptl and overhead is significant.
> 
> Let's create a separate slab for page->ptl allocation to solve this.
> 
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

ping?

-- 
 Kirill A. Shutemov
