Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753315Ab3LPKOa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 05:14:30 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50563 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752566Ab3LPKO3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 05:14:29 -0500
From: Vlastimil Babka <vbabka@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sasha.levin@oracle.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        joern@logfs.org, Michel Lespinasse <walken@google.com>,
        Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH 0/3] Fix bugs in munlock
Date: Mon, 16 Dec 2013 11:14:13 +0100
Message-Id: <1387188856-21027-1-git-send-email-vbabka@suse.cz>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <52AE07B4.4020203@oracle.com>
References: <52AE07B4.4020203@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch mini-series is a result of Sasha Levin's bug reports via trinity.

First two patches are quite straightforward fixes for bugs introduced in 3.12,
and earlier versions have been tested. Sasha, can you please test the final
versions of the first two (together) again? The first one added an extra
VM_BUG_ON.

The third is based on me noticing there might still be an (older than 3.12)
race with a THP page split with non-fatal but still bad consequences, such as
pages being kept mlocked. Since this is quite rare and was not reported, any
review agreeing that it can really happen would be great. Testing as well, of
course.  So it's kind of RFC at this point.

Vlastimil Babka (3):
  mm: munlock: fix a bug where THP tail page is encountered
  mm: munlock: fix deadlock in __munlock_pagevec()
  mm: munlock: fix potential race with THP page split

 mm/mlock.c | 116 ++++++++++++++++++++++++++++++++++++++++---------------------
 1 file changed, 76 insertions(+), 40 deletions(-)

-- 
1.8.4

