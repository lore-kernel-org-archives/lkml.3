Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751722AbaJRWPa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2014 18:15:30 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:33776 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518AbaJRWP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2014 18:15:27 -0400
Date: Sun, 19 Oct 2014 00:15:25 +0200
From: Pavel Machek <pavel@denx.de>
To: Hui Zhu <zhuhui@xiaomi.com>
Cc: rjw@rjwysocki.net, len.brown@intel.com, m.szyprowski@samsung.com,
        akpm@linux-foundation.org, mina86@mina86.com,
        aneesh.kumar@linux.vnet.ibm.com, iamjoonsoo.kim@lge.com,
        hannes@cmpxchg.org, riel@redhat.com, mgorman@suse.de,
        minchan@kernel.org, nasa4836@gmail.com, ddstreet@ieee.org,
        hughd@google.com, mingo@kernel.org, rientjes@google.com,
        peterz@infradead.org, keescook@chromium.org, atomlin@redhat.com,
        raistlin@linux.it, axboe@fb.com, paulmck@linux.vnet.ibm.com,
        kirill.shutemov@linux.intel.com, n-horiguchi@ah.jp.nec.com,
        k.khlebnikov@samsung.com, msalter@redhat.com, deller@gmx.de,
        tangchen@cn.fujitsu.com, ben@decadent.org.uk, akinobu.mita@gmail.com,
        lauraa@codeaurora.org, vbabka@suse.cz, sasha.levin@oracle.com,
        vdavydov@parallels.com, suleiman@google.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 1/4] (CMA_AGGRESSIVE) Add CMA_AGGRESSIVE to Kconfig
Message-ID: <20141018221525.GB10843@amd>
References: <1413430551-22392-1-git-send-email-zhuhui@xiaomi.com>
 <1413430551-22392-2-git-send-email-zhuhui@xiaomi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413430551-22392-2-git-send-email-zhuhui@xiaomi.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Add CMA_AGGRESSIVE config that depend on CMA to Linux kernel config.
> Add CMA_AGGRESSIVE_PHY_MAX, CMA_AGGRESSIVE_FREE_MIN and CMA_AGGRESSIVE_SHRINK
> that depend on CMA_AGGRESSIVE.
> 
> If physical memory size (not include CMA memory) in byte less than or equal to
> CMA_AGGRESSIVE_PHY_MAX, CMA aggressive switch (sysctl vm.cma-aggressive-switch)
> will be opened.

Ok...

Do I understand it correctly that there is some problem with
hibernation not working on machines not working on machines with big
CMA areas...?

But adding 4 config options end-user has no chance to set right can
not be the best solution, can it?

> +config CMA_AGGRESSIVE_PHY_MAX
> +	hex "Physical memory size in Bytes that auto turn on the CMA aggressive switch"
> +	depends on CMA_AGGRESSIVE
> +	default 0x40000000
> +	help
> +	  If physical memory size (not include CMA memory) in byte less than or
> +	  equal to this value, CMA aggressive switch will be opened.
> +	  After the Linux boot, sysctl "vm.cma-aggressive-switch" can control
> +	  the CMA AGGRESSIVE switch.

For example... how am I expected to figure right value to place here?

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
