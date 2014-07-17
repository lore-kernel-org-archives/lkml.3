Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965425AbaGQQXx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 12:23:53 -0400
Received: from smtp4-g21.free.fr ([212.27.42.4]:5688 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757600AbaGQQXt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 12:23:49 -0400
Date: Thu, 17 Jul 2014 18:23:45 +0200
From: Guillaume Morin <guillaume@morinfr.org>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Hugh Dickins <hughd@google.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [BUG] new copy_hugetlb_page_range() causing crashes
Message-ID: <20140717162345.GA8550@bender.morinfr.org>
Mail-Followup-To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
	Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Naoya, Hugh,

I am seeing lots of crashes with the new copy_hugetlb_page_range() code
added by 4a705fef986231a3e7a6b1a6d3c37025f021f49f for some set of
programs.

Specifically, I am running some test programs which use huge pages for
malloc (through libhugetlbfs with HUGETLB_MORECORE=yes and
HUGETLB_NO_PREFAULT= set) that also do fork() a lot.  The crashes are
very diverse: assertion failures in malloc() or the python GC code, some
SIGSEGV as well.

I started observing these crashes with 3.4.98 and 3.14.12 which just got
a backport of the patch above (as
2bcdd4933ff4dc46445dcae93cb37c648283b782 in the stable branch).  The 3.4
and 3.14 patches are identical to the upstream commit so that's not a patch
backport issue.

If I revert only 2bcdd4933ff4dc46445dcae93cb37c648283b782 in my 3.4
tree, the crashes disappear right away and everything is stable. 

-- 
Guillaume Morin <guillaume@morinfr.org>
