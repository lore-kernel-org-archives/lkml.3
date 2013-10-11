Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755913Ab3JKJaz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 05:30:55 -0400
Received: from mga03.intel.com ([143.182.124.21]:8721 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752103Ab3JKJax (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 05:30:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1079,1371106800"; 
   d="scan'208";a="409330080"
Date: Fri, 11 Oct 2013 17:30:29 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Jakub Jelinek <jakub@redhat.com>, Richard Henderson <rth@twiddle.net>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH, -v3] compiler/gcc4: Add quirk for 'asm goto'
 miscompilation bug
Message-ID: <20131011093029.GA30308@localhost>
References: <20131010065104.GY30970@tucnak.zalov.cz>
 <20131010080457.GC21875@tucnak.zalov.cz>
 <20131010082430.GA20577@gmail.com>
 <20131010083107.GZ30970@tucnak.zalov.cz>
 <5256B3E2.4060401@twiddle.net>
 <20131010142703.GI30970@tucnak.zalov.cz>
 <20131010151219.GC5167@gmail.com>
 <20131011043553.GA9015@localhost>
 <20131011054655.GA28077@gmail.com>
 <20131011065149.GA16470@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131011065149.GA16470@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

After adding more test runs to these kernels, we can see that the boot hangs
happen both before/after patch. So the patch is fine. 

Tested-by: Fengguang Wu <fengguang.wu@intel.com>


/kernel/x86_64-randconfig-a1-1009/c015a7f0b746d0a7e18b82876bd2b693722479d2

+-------------------------------------------------+--------------+--------------+
|                                                 | 3354781a2184 | c015a7f0b746 |
+-------------------------------------------------+--------------+--------------+
| good_boots                                      | 1012         | 1067         |
| has_kernel_error_warning                        | 27           | 40           |
| BUG:kernel_early_hang_without_any_printk_output | 14           | 13           |
| BUG:kernel_boot_hang                            | 13           | 27           |
+-------------------------------------------------+--------------+--------------+

/kernel/x86_64-randconfig-a5-1009/c015a7f0b746d0a7e18b82876bd2b693722479d2

+-------------------------------------------------+--------------+--------------+
|                                                 | 3354781a2184 | c015a7f0b746 |
+-------------------------------------------------+--------------+--------------+
| good_boots                                      | 1078         | 1058         |
| has_kernel_error_warning                        | 35           | 13           |
| BUG:kernel_early_hang_without_any_printk_output | 35           | 13           |
+-------------------------------------------------+--------------+--------------+

btw, the boot hangs all happen in one of the test boxes, which is
probably misconfigured or not reliable.

Thanks,
Fengguang
