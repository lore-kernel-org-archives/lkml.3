Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752447Ab3BUISi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 03:18:38 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:54532 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199Ab3BUISg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 03:18:36 -0500
Date: Thu, 21 Feb 2013 00:17:48 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Mel Gorman <mgorman@suse.de>, Petr Holasek <pholasek@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Izik Eidus <izik.eidus@ravellosystems.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 0/7] ksm: responses to NUMA review
Message-ID: <alpine.LNX.2.00.1302210013120.17843@eggly.anvils>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's a second KSM series, based on mmotm 2013-02-19-17-20: partly in
response to Mel's review feedback, partly fixes to issues that I found
myself in doing more review and testing.  None of the issues fixed are
truly show-stoppers, though I would prefer them fixed sooner than later.

1 ksm: add some comments
2 ksm: treat unstable nid like in stable tree
3 ksm: shrink 32-bit rmap_item back to 32 bytes
4 mm,ksm: FOLL_MIGRATION do migration_entry_wait
5 mm,ksm: swapoff might need to copy
6 mm: cleanup "swapcache" in do_swap_page
7 ksm: allocate roots when needed

 Documentation/vm/ksm.txt |   16 +++-
 include/linux/mm.h       |    1 
 mm/ksm.c                 |  137 +++++++++++++++++++++++--------------
 mm/memory.c              |   38 +++++++---
 mm/swapfile.c            |   15 +++-
 5 files changed, 140 insertions(+), 67 deletions(-)

Thanks,
Hugh
