Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756655AbaELQF3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 12:05:29 -0400
Received: from qmta03.emeryville.ca.mail.comcast.net ([76.96.30.32]:34469 "EHLO
	qmta03.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752115AbaELQF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 12:05:27 -0400
Date: Mon, 12 May 2014 11:05:24 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Jianyu Zhan <nasa4836@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        Andrea Arcangeli <aarcange@redhat.com>, fabf@skynet.be,
        sasha.levin@oracle.com, oleg@redhat.com,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, iamjoonsoo.kim@lge.com,
        kirill.shutemov@linux.intel.com, Cyrill Gorcunov <gorcunov@gmail.com>,
        dave.hansen@linux.intel.com, toshi.kani@hp.com,
        paul.gortmaker@windriver.com, srivatsa.bhat@linux.vnet.ibm.com,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] mm: add comment for __mod_zone_page_stat
In-Reply-To: <CAHz2CGUfLx7DNgdNoAL0G3a9Ht6yf3bhWaojjNx91aF7L-iDQw@mail.gmail.com>
Message-ID: <alpine.DEB.2.10.1405121102170.17673@gentwo.org>
References: <1399811500-14472-1-git-send-email-nasa4836@gmail.com> <alpine.DEB.2.10.1405120858040.3090@gentwo.org> <CAHz2CGUfLx7DNgdNoAL0G3a9Ht6yf3bhWaojjNx91aF7L-iDQw@mail.gmail.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 May 2014, Jianyu Zhan wrote:

> This means they guarantee that even they are preemted the vm
> counter won't be modified incorrectly.  Because the counter is page-related
> (e.g., a new anon page added), and they are exclusively hold the pte lock.

But there are multiple pte locks for numerous page. Another process could
modify the counter because the pte lock for a different page was
available which would cause counter corruption.


> So, as you concludes in the other mail that __modd_zone_page_stat
> couldn't be used.
> in mlocked_vma_newpage, then what qualifies other call sites for using
> it, in the same situation?

Preemption should be off in those functions because a spinlock is being
held.
