Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758219Ab3IBKxe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 06:53:34 -0400
Received: from mga14.intel.com ([143.182.124.37]:26420 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755704Ab3IBKxc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 06:53:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,1006,1367996400"; 
   d="scan'208";a="289808316"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Andi Kleen <andi@firstfloor.org>,
        Michal Hocko <mhocko@suse.cz>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
        kirill.shutemov@linux.intel.com,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Alex Thorlton <athorlton@sgi.com>, linux-kernel@vger.kernel.org
In-Reply-To: <1377883120-5280-3-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1377883120-5280-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <1377883120-5280-3-git-send-email-n-horiguchi@ah.jp.nec.com>
Subject: RE: [PATCH 2/2] thp: support split page table lock
Content-Transfer-Encoding: 7bit
Message-Id: <20130902105327.AE4D4E0090@blue.fi.intel.com>
Date: Mon,  2 Sep 2013 13:53:27 +0300 (EEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Naoya Horiguchi wrote:
> Thp related code also uses per process mm->page_table_lock now. So making
> it fine-grained can provide better performance.
> 
> This patch makes thp support split page table lock which makes us use
> page->ptl of the pages storing "pmd_trans_huge" pmds.

Hm. So, you use page->ptl only when you deal with thp pages, otherwise
mm->page_table_lock, right?

It looks inconsistent to me. Does it mean we have to take both locks on
split and collapse paths? I'm not sure if it's safe to take only
page->ptl for alloc path. Probably not.

Why not to use new locking for pmd everywhere?

-- 
 Kirill A. Shutemov
