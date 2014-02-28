Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753116AbaB1WTW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 17:19:22 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:39354 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495AbaB1WTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 17:19:19 -0500
From: Ning Qu <quning@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Dave Chinner <david@fromorbit.com>, Ning Qu <quning@gmail.com>,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ning Qu <quning@google.com>
Subject: [PATCH 0/1] mm, shmem: map few pages around fault address if they are in page cache
Date: Fri, 28 Feb 2014 14:18:50 -0800
Message-Id: <1393625931-2858-1-git-send-email-quning@google.com>
X-Mailer: git-send-email 1.9.0.279.gdc9e3eb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a follow-up patch for "mm: map few pages around fault address if they are in page cache"

We use the generic filemap_map_pages as ->map_pages in shmem/tmpfs.

Please consider applying.

=========================================================================
Below is just some simple experiment numbers from this patch, let me know if
you would like more:

Tested on Xeon machine with 64GiB of RAM, using the current default fault
order 4.

Sequential access 8GiB file
			Baseline 	with-patch
1 thread
    minor fault		205		101	
    time, seconds	7.94		7.82

Random access 8GiB file
			Baseline 	with-patch
1 thread
    minor fault		724		623
    time, seconds	9.75		9.84


Ning Qu (1):
  mm: implement ->map_pages for shmem/tmpfs

 mm/shmem.c | 1 +
 1 file changed, 1 insertion(+)

-- 
1.9.0.279.gdc9e3eb

