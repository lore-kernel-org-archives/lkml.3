Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751909Ab3LLUL6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 15:11:58 -0500
Received: from mail-qe0-f43.google.com ([209.85.128.43]:45960 "EHLO
	mail-qe0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519Ab3LLUL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 15:11:56 -0500
MIME-Version: 1.0
In-Reply-To: <20131212180050.GC134240@sgi.com>
References: <cover.1386790423.git.athorlton@sgi.com> <20131212180050.GC134240@sgi.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 12 Dec 2013 12:11:34 -0800
Message-ID: <CALCETrWfFRhjuoK8T9G8hecxsRxFPQ+qA0x7azoof1X5tuxruA@mail.gmail.com>
Subject: Re: [RFC PATCH 2/3] Add tunable to control THP behavior
To: Alex Thorlton <athorlton@sgi.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Rik van Riel <riel@redhat.com>, Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Mel Gorman <mgorman@suse.de>, Michel Lespinasse <walken@google.com>,
        Benjamin LaHaise <bcrl@kvack.org>, Oleg Nesterov <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        David Rientjes <rientjes@google.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Jiang Liu <jiang.liu@huawei.com>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        Glauber Costa <glommer@parallels.com>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 12, 2013 at 10:00 AM, Alex Thorlton <athorlton@sgi.com> wrote:
> This part of the patch adds a tunable to
> /sys/kernel/mm/transparent_hugepage called threshold.  This threshold
> determines how many pages a user must fault in from a single node before
> a temporary compound page is turned into a THP.

Is there a setting that will turn off the must-be-the-same-node
behavior?  There are workloads where TLB matters more than cross-node
traffic (or where all the pages are hopelessly shared between nodes,
but hugepages are still useful).

--Andy
