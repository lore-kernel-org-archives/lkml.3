Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755151Ab3LUQnC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Dec 2013 11:43:02 -0500
Received: from mta-out.inet.fi ([195.156.147.13]:38544 "EHLO jenni2.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753519Ab3LUQnA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Dec 2013 11:43:00 -0500
X-Greylist: delayed 362 seconds by postgrey-1.27 at vger.kernel.org; Sat, 21 Dec 2013 11:42:59 EST
Date: Sat, 21 Dec 2013 18:36:48 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Olof Johansson <olof@lixom.net>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, akpm@linux-foundation.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH] mm: fix build of split ptlock code
Message-ID: <20131221163648.GA25306@node.dhcp.inet.fi>
References: <1387578485-11829-1-git-send-email-olof@lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387578485-11829-1-git-send-email-olof@lixom.net>
User-Agent: Mutt/1.5.22.1-rc1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 20, 2013 at 02:28:05PM -0800, Olof Johansson wrote:
> Commit 597d795a2a78 ('mm: do not allocate page->ptl dynamically, if
> spinlock_t fits to long') restructures some allocators that are compiled
> even if USE_SPLIT_PTLOCKS arn't used. It results in compilation failure:
> 
> mm/memory.c:4282:6: error: 'struct page' has no member named 'ptl'
> mm/memory.c:4288:12: error: 'struct page' has no member named 'ptl'
> 
> Add in the missing ifdef.
> 
> Fixes: 597d795a2a78 ('mm: do not allocate page->ptl dynamically, if spinlock_t fits to long')
> Signed-off-by: Olof Johansson <olof@lixom.net>
> Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Cc: Hugh Dickins <hughd@google.com>

Sorry, for that.

Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

-- 
 Kirill A. Shutemov
