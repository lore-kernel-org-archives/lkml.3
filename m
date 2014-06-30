Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751914AbaF3Fbb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 01:31:31 -0400
Received: from mga14.intel.com ([192.55.52.115]:65133 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751112AbaF3Fba (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 01:31:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,573,1400050800"; 
   d="scan'208";a="555099378"
Date: Mon, 30 Jun 2014 13:31:26 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Stephan Mueller <smueller@chronox.de>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, Jet Chen <jet.chen@intel.com>,
        Su Tao <tao.su@intel.com>, Yuanhan Liu <yuanhan.liu@intel.com>,
        LKP <lkp@01.org>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, aris@redhat.com, aquini@redhat.com
Subject: Re: [crypto] BUG: unable to handle kernel paging request at
 ffff88000bb88000
Message-ID: <20140630053126.GA13887@localhost>
References: <20140629145246.GA9134@localhost>
 <42550233.Kxs179MjQV@myon.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <42550233.Kxs179MjQV@myon.chronox.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephan,

On Sun, Jun 29, 2014 at 09:45:48PM +0200, Stephan Mueller wrote:
> Am Sonntag, 29. Juni 2014, 22:52:46 schrieb Fengguang Wu:
> 
> Hi Fengguang,
> 
> > Greetings,
> > 
> > 0day kernel testing robot got the below dmesg and the first bad commit is
> 
> May I ask whether there is anything special in your kernel config?

It's an x86_64 randconfig. You may find it in the attachment of the
original report email.

> This very bug should have been triggered already in all previous code levels! 
> I am seriously wondering why this bug was not triggered before -- does kalloc 
> somehow allocates more memory than you requested? And only your specific 
> kernel config made kalloc to allocate the exact amount of memory that was 
> requested?

Yeah the bug may have been triggered in other places. If you see
anything valuable from this bisect result, it would be great. Judging
from the comparison of 64d1cdfbe2 and its parent commit 3332ee2a17,
it's pretty reproducible, so easy to verify the possible fixes.

+----------------------------------------------------------------------------+------------+------------+
|                                                                            | 3332ee2a17 | 64d1cdfbe2 |
+----------------------------------------------------------------------------+------------+------------+
| boot_successes                                                             | 81         | 3          |
| boot_failures                                                              | 0          | 23         |
| BUG:unable_to_handle_kernel_paging_request                                 | 0          | 20         |
| Oops                                                                       | 0          | 19         |
| RIP:kzfree                                                                 | 0          | 15         |
| WARNING:CPU:PID:at_kernel/rcu/tree.c:rcu_do_batch()                        | 0          | 9          |
| backtrace:cryptomgr_test                                                   | 0          | 18         |
| backtrace:cpu_startup_entry                                                | 0          | 3          |
| kernel_BUG_at_include/linux/mm.h                                           | 0          | 1          |
...

Thanks,
Fengguang
