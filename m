Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162813Ab3DEVRT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 17:17:19 -0400
Received: from mail-qe0-f46.google.com ([209.85.128.46]:48644 "EHLO
	mail-qe0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162724Ab3DEVRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 17:17:17 -0400
Message-ID: <515F3F5C.2090709@gmail.com>
Date: Fri, 05 Apr 2013 17:17:16 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
CC: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mel@csn.ul.ie>, Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, Hillf Danton <dhillf@gmail.com>,
        Michal Hocko <mhocko@suse.cz>, linux-kernel@vger.kernel.org,
        kosaki.motohiro@gmail.com
Subject: Re: [PATCH 05/10] migrate: add hugepage migration code to migrate_pages()
References: <1363983835-20184-1-git-send-email-n-horiguchi@ah.jp.nec.com> <1363983835-20184-6-git-send-email-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1363983835-20184-6-git-send-email-n-horiguchi@ah.jp.nec.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(3/22/13 4:23 PM), Naoya Horiguchi wrote:
> This patch extends check_range() to handle vma with VM_HUGETLB set.
> We will be able to migrate hugepage with migrate_pages(2) after
> applying the enablement patch which comes later in this series.
> 
> Note that for larger hugepages (covered by pud entries, 1GB for
> x86_64 for example), we simply skip it now.

check_range() has largely duplication with mm_walk and it is quirk subset.
Instead of, could you replace them to mm_walk and enhance/cleanup mm_walk?


