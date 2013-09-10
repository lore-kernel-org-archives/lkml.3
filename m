Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751647Ab3IJOsa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 10:48:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47222 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751225Ab3IJOs2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 10:48:28 -0400
Date: Tue, 10 Sep 2013 15:48:24 +0100
From: Mel Gorman <mgorman@suse.de>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, Hillf Danton <dhillf@gmail.com>,
        Michal Hocko <mhocko@suse.cz>, Rik van Riel <riel@redhat.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        Naoya Horiguchi <nao.horiguchi@gmail.com>
Subject: Re: [PATCH 9/9] prepare to remove
 /proc/sys/vm/hugepages_treat_as_movable
Message-ID: <20130910144823.GS22421@suse.de>
References: <1376025702-14818-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <1376025702-14818-10-git-send-email-n-horiguchi@ah.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1376025702-14818-10-git-send-email-n-horiguchi@ah.jp.nec.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 09, 2013 at 01:21:42AM -0400, Naoya Horiguchi wrote:
> Now we have extended hugepage migration and it's opened to many users
> of page migration, which is a good reason to consider hugepage as movable.
> So we can go to the direction to remove this parameter. In order to
> allow userspace to prepare for the removal, let's leave this sysctl handler
> as noop for a while.
> 

Note that this assumes that users interested in memory hot-remove and
hugepages are also willing to resize the hugepage pool on the target nodes
before attempting the hot-remove operation. I guess that technically the
necessary setup steps could be done from userspace or manually by the
system administrator but it may not be obvious to the system
administrator that the step is required.

-- 
Mel Gorman
SUSE Labs
