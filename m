Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756999Ab3LFIu5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 03:50:57 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:61284 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753205Ab3LFIux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 03:50:53 -0500
X-AuditID: 9c930179-b7ce4ae000000e86-bc-52a18feb60e1
Date: Fri, 6 Dec 2013 17:53:31 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Rafael Aquini <aquini@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [QUESTION] balloon page isolation needs LRU lock?
Message-ID: <20131206085331.GA24706@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Rafael.

I looked at some compaction code and found that some oddity about
balloon compaction. In isolate_migratepages_range(), if we meet
!PageLRU(), we check whether this page is for balloon compaction.
In this case, code needs locked. Is the lock really needed? I can't find
any relationship between balloon compaction and LRU lock.

Second question is that in above case if we don't hold a lock, we
skip this page. I guess that if we meet balloon page repeatedly, there
is no change to run isolation. Am I missing?

Please let me know what I am missing.

Thanks in advance.
