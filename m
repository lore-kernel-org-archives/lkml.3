Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030320AbaDJQxq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 12:53:46 -0400
Received: from mga09.intel.com ([134.134.136.24]:42044 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030212AbaDJQxo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 12:53:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,835,1389772800"; 
   d="scan'208";a="518622045"
From: Andi Kleen <andi@firstfloor.org>
To: Richard Yao <ryao@gentoo.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Zhang Yanfei <zhangyanfei.yes@gmail.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, kernel@gentoo.org,
        Matthew Thode <mthode@mthode.org>
Subject: Re: [PATCH] mm/vmalloc: Introduce DEBUG_VMALLOCINFO to reduce spinlock contention
References: <1397148058-8737-1-git-send-email-ryao@gentoo.org>
Date: Thu, 10 Apr 2014 09:51:57 -0700
In-Reply-To: <1397148058-8737-1-git-send-email-ryao@gentoo.org> (Richard Yao's
	message of "Thu, 10 Apr 2014 12:40:58 -0400")
Message-ID: <87txa1i0uq.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Yao <ryao@gentoo.org> writes:

> Performance analysis of software compilation by Gentoo portage on an
> Intel E5-2620 with 64GB of RAM revealed that a sizeable amount of time,
> anywhere from 5% to 15%, was spent in get_vmalloc_info(), with at least
> 40% of that time spent in the _raw_spin_lock() invoked by it.

I don't think that's the right fix. We want to be able 
to debug kernels without having to recompile them.

And switching locking around dynamically like this is very
ugly and hard to maintain.

Besides are you sure the spin lock is not needed elsewhere?

How are writers to the list protected?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
